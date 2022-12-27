Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C406965680F
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiL0H5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiL0H5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:57:30 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA95657D
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:57:24 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id j1so2793464uan.1
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7v/WSJyZmtBjH1RduwJIBnIVDn9u078UD/StpnslVx0=;
        b=mDjhdOb+37hZkSU5zz/DbB2FXU0Pc/729sq2tkWFJiYAVkgTfJKuUpOSXeo0P8EzEI
         bhvix75DeyyFatTBY3VZFtz+3N0uYxzvYQyIRe3J2bhYKTyltbqH3tHftOLiqj30uybe
         u4Ctr0Gk9w3V2DMnaAWShGbvxy33VSLGYTfcJXxyi0g6ADHstijwy8Mb6Ux2lh5SlkIF
         ylW1Upb/0Njy0ENduTaULY90gM/vB/jM/88JULcTRxcNXIchHnvyUw6EzkLggnuEyXNi
         nNZ9AVJDThH5Gy1xpZyGD5iPmx+Ez0gJ4ZgmpLUj6TOx1lWdtd2mxwaRoFaJNuny/6aF
         3XNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7v/WSJyZmtBjH1RduwJIBnIVDn9u078UD/StpnslVx0=;
        b=cirbWJBo0vB28gpNYnugpJWH5MAwRfvYIstbcIuoJan6orXiJ+NJqbDp4UaXsXJpig
         Lmf/PMTftCVQjPXp9K2/JeQz/vv+LtoAYriQxdsJEqjdtBWemUrRQZO0UJwnIVa9Xs7S
         42dfV45vBlDD2aEgabdR/C14/957HILXfEkhVmeMf/Eg4EKZ1BUZGF8Gg1dgTUjGFr51
         OdF2Bq9CLrLSKgog6XDgEqqQifwxFdxQBJ92Kza3llXnvK1SAaRe78ZH7T+dGRNHep8J
         J0H8zLXe5X/IjnVyUCbr2jZSEkRH0kWTtKHJGB/MwEFu4G6+pxSEBb6nbiqyDvVKQ1U3
         zDWA==
X-Gm-Message-State: AFqh2kojwhCynKLEBAtGE0F5SWIlq1iStfXmLoQGJTjdjigynJCEcg9e
        Ast0Ut+1OKEmqmyvYgQrwx/ERc+PMevlMtFN6GZClbkIc08bdBAO
X-Google-Smtp-Source: AMrXdXsR/ThovcjSI43AaK4Fos8vXu6n0K3qiqUEOlotWF5yGcagJgxiHP0FtJUsV9OnUNvEQSj+hEYwL6OSgTbFwqU=
X-Received: by 2002:ab0:2398:0:b0:3fe:c0cb:aa43 with SMTP id
 b24-20020ab02398000000b003fec0cbaa43mr1886262uan.72.1672127843661; Mon, 26
 Dec 2022 23:57:23 -0800 (PST)
MIME-Version: 1.0
References: <20221227022528.609839-1-mie@igel.co.jp> <20221227022528.609839-3-mie@igel.co.jp>
 <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
 <20221227020425-mutt-send-email-mst@kernel.org> <CANXvt5pXkS=TTOU0+Lkx6CjcV7xvDHRS6FbFikJ4Ww8832sg8g@mail.gmail.com>
 <20221227025534-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221227025534-mutt-send-email-mst@kernel.org>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Tue, 27 Dec 2022 16:57:12 +0900
Message-ID: <CANXvt5qh885mi7shJ9jiZbCBeSVR7=bDhx29GnpL1ZHymb_Rxw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to vringh_kiov
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 16:56 Michael S. Tsirkin <ms=
t@redhat.com>:
>
> On Tue, Dec 27, 2022 at 04:13:49PM +0900, Shunsuke Mie wrote:
> > 2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 16:05 Michael S. Tsirkin=
 <mst@redhat.com>:
> > >
> > > On Tue, Dec 27, 2022 at 02:04:03PM +0800, Jason Wang wrote:
> > > > On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrot=
e:
> > > > >
> > > > > struct vringh_iov is defined to hold userland addresses. However,=
 to use
> > > > > common function, __vring_iov, finally the vringh_iov converts to =
the
> > > > > vringh_kiov with simple cast. It includes compile time check code=
 to make
> > > > > sure it can be cast correctly.
> > > > >
> > > > > To simplify the code, this patch removes the struct vringh_iov an=
d unifies
> > > > > APIs to struct vringh_kiov.
> > > > >
> > > > > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> > > >
> > > > While at this, I wonder if we need to go further, that is, switch t=
o
> > > > using an iov iterator instead of a vringh customized one.
> > > >
> > > > Thanks
> > >
> > > Possibly, but when doing changes like this one needs to be careful
> > > to avoid breaking all the inlining tricks vringh relies on for
> > > performance.
> > Definitely, I'm evaluating the performance using vringh_test. I'll add =
a
> > result of the evaluation. But, If there are other evaluation methods, c=
ould you
> > please tell me?
>
> high level tests over virtio blk and net are possible, but let's
> start with vringh_test.
Ok, I'll do it.
> > > --
> > > MST
> > >
> >
> > Best,
> > Shunsuke
>
