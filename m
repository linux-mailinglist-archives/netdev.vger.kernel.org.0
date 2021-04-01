Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293C83521E6
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 23:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhDAVuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 17:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbhDAVuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 17:50:09 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B2FC0613E6;
        Thu,  1 Apr 2021 14:50:07 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b4so4949906lfi.6;
        Thu, 01 Apr 2021 14:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nt8N6sIOOpten5Jb+BVhllhO+HJ4NfvHsXx0djsr2LE=;
        b=TPykV+Tyl//+zkw7ak9VdeX+Hd+CIaxOH2+WxGnTesr9GOv9zzc0Jfs5bZ4uegJGkn
         9oeIWEY7z01KIlNfIeafo+EZsmPcL/JncipGopfitJigrhOxYloOgVI4/gDUSOOwsgjd
         EMUlu6woShWSVsUgSgymrvqu2P1J4fqQ4CFjw/uNldEPPHWuUDhwQ/NHw2EPPi6Nb+sr
         HXNEW3KbsvimKSM3czhWq5JHnz2oIq/Y4B6yxTgcTYeHwvLDK+rCBTUnO9ol8r+UJ7Mn
         WqFnY9BtWuZK9QvCYZrEb5fQ31jaQ1NmbwSCo915/98WuP3tEPGnEYe0NiciMb+yxJlX
         w4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nt8N6sIOOpten5Jb+BVhllhO+HJ4NfvHsXx0djsr2LE=;
        b=ZZ1aiLMJ+fOO9b61T4hsX0OgQrIr9dJ+QSZi6G2yxbkqkS8yA8UVu07KGTlTjdvKwi
         x6P8lcAabDPaCn6c6uVYbfj92Io5w4sLfbMTxLGWvfSBjC1SQdg71FeVxYIv0jbpt0EX
         a3L3eLX4567EqaNLylCj8d5AnNfO07fUU+3ZXlX516KiPeZba0XWGGuu5OLVCD4vsNaI
         3v+Nso7k0nGVEaDQStj/wf/FBe1muPBFDO2ncGaGeFaa+nzSMA/NuNFMYBvOvJyI3Vy8
         zFRFF4KuW1eiX8tFWCvoajkxFZtYuo4rlfBH/um2jkZKNZqiFNrIhGEHrh3hNZFnP9O2
         ZaRQ==
X-Gm-Message-State: AOAM533gD269LL/ap3/d6xI5pf9sqEzBHe6cpkZ7Tl9RaQQpYEU3OBQ1
        C9zVKjkZi8Wk/zzNQaRDwUUEkNnNdmmdxP0uReNBaUKA
X-Google-Smtp-Source: ABdhPJz4Y2CbrFkqXnjeWYApZYg/sWiDKVHxOfnREGcPEI5w83dOGSkpZ2dINGg/jjZiccKbeW+scJHOxMhmxSykCTA=
X-Received: by 2002:a19:ed06:: with SMTP id y6mr6912578lfy.539.1617313805961;
 Thu, 01 Apr 2021 14:50:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210331061218.1647-1-ciara.loftus@intel.com> <CAJ+HfNjsbAA0v48CLOgEw0bj4prsg5ZzP3=iU=QGTFWrAbOAng@mail.gmail.com>
In-Reply-To: <CAJ+HfNjsbAA0v48CLOgEw0bj4prsg5ZzP3=iU=QGTFWrAbOAng@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Apr 2021 14:49:54 -0700
Message-ID: <CAADnVQ+LrOpP6WXrKkjdt6pVGoTsRs8SXLHxWQV6OO=GpZJhVQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf 0/3] AF_XDP Socket Creation Fixes
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     Ciara Loftus <ciara.loftus@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 12:06 AM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> w=
rote:
>
> On Wed, 31 Mar 2021 at 08:43, Ciara Loftus <ciara.loftus@intel.com> wrote=
:
> >
> > This series fixes some issues around socket creation for AF_XDP.
> >
> > Patch 1 fixes a potential NULL pointer dereference in
> > xsk_socket__create_shared.
> >
> > Patch 2 ensures that the umem passed to xsk_socket__create(_shared)
> > remains unchanged in event of failure.
> >
> > Patch 3 makes it possible for xsk_socket__create(_shared) to
> > succeed even if the rx and tx XDP rings have already been set up by
> > introducing a new fields to struct xsk_umem which represent the ring
> > setup status for the xsk which shares the fd with the umem.
> >
> > v3->v4:
> > * Reduced nesting in xsk_put_ctx as suggested by Alexei.
> > * Use bools instead of a u8 and flags to represent the
> >   ring setup status as suggested by Bj=C3=B6rn.
> >
>
> Thanks, Ciara! LGTM!
>
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

Applied. Thanks
