Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74777228D0D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 02:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgGVAUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 20:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgGVAUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 20:20:38 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45FCC061794;
        Tue, 21 Jul 2020 17:20:38 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so407632iof.12;
        Tue, 21 Jul 2020 17:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TmTrDCfg5K4WtuF0p56ccvnTlbYpSnW273RU+lkT12k=;
        b=MeFiLKYD5MtxrJ274jfdA/ycOGOwYNxKsHk90YnJZ+eyu0k9PFaP6+AFgMjR+pWbXr
         xWyUtfGWQX3ViLWIP6spkEzsXBoqKaHjVfSbve+LFOEeHF3BwXOgkLSRT4SZIsPSxueI
         eZU5O51G+j+1YHNXvu0/+2oUKB3K4TPJ2HO1Qd6xOe8QB70Kd8iCENqexUm5cNffIQry
         01FhtrUV3rTWang2PNXV6eagOMcwsXNEzTLGh+ln3lFFjV5QdfNLUoG4CYk+EpYTa0Hd
         28Y5pNd1YpCmw4fpBglEwXzNmYd7hB9BScwTfEKh7S7PmXfLC4e6SRB0cZMO8RwkkLc0
         a1Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TmTrDCfg5K4WtuF0p56ccvnTlbYpSnW273RU+lkT12k=;
        b=mmhaCYEpE1x/v6gVkzeI7OTGE+I4T1MA9lEE8iOFuAvo9leOV4OTQtaU4O1ac/6L+1
         pN5XN0iJazcN14VNYMfT6vaolPwCTfUJBGLUnv5Q5muR8gGDZWkJrcJcJYY9Rq4QQoBx
         7k0/uagAM/G0YnOxNvTPT1o+02A1yW8RpjHLix2cUJU73zoMDHfucJTX1tcH4N8pT3Up
         zMjx85VSdv8RHltxB4jDtW/MPhAo/PKqfR2oXbD59mNutHgpngdKx4qOgafWQRWAxcxL
         sgFvK+3plURlAyIQv0XAz9Fhf2eikRbS6FZYpHt/WeWcabNmo0hkJih0ekbbWLMFIv4+
         F0YQ==
X-Gm-Message-State: AOAM530LDI2s2X3pKDl/oSydVzJx1xSBclA/5ul6P+7K2OQV1LMY8P2l
        Mlo5EKRWnxpA0qHYNekAZzzTR7J2UlRs+fKmLVg=
X-Google-Smtp-Source: ABdhPJwVtDp0IToOziqA0DBae8YwMtZZPPjcM1keyU/iIOFtTJlAMtv2Og/DPjqIIqSNvcMUp8tEO2hGhX+UOJ/8m8k=
X-Received: by 2002:a05:6638:2493:: with SMTP id x19mr35752446jat.53.1595377238151;
 Tue, 21 Jul 2020 17:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200717225543.32126-1-Tony.Ambardar@gmail.com>
 <20200721024817.13701-1-Tony.Ambardar@gmail.com> <c494168f-4f1d-1814-893a-5e93c6a643c8@iogearbox.net>
In-Reply-To: <c494168f-4f1d-1814-893a-5e93c6a643c8@iogearbox.net>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Tue, 21 Jul 2020 17:20:30 -0700
Message-ID: <CAPGftE-ZP1eDrk2o5gCTj6d0D+=Kwp09dEM6O8RybTjdpsks6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpftool: use only nftw for file tree parsing
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 at 14:50, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/21/20 4:48 AM, Tony Ambardar wrote:
> > The bpftool sources include code to walk file trees, but use multiple
> > frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
> > is widely available, fts is not conformant and less common, especially on
> > non-glibc systems. The inconsistent framework usage hampers maintenance
> > and portability of bpftool, in particular for embedded systems.
> >
> > Standardize code usage by rewriting one fts-based function to use nftw and
> > clean up some related function warnings by extending use of "const char *"
> > arguments. This change helps in building bpftool against musl for OpenWrt.
> >
> > Also fix an unsafe call to dirname() by duplicating the string to pass,
> > since some implementations may directly alter it. The same approach is
> > used in libbpf.c.
> >
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
>
> Lgtm, applied, thanks!

Thank you, and much appreciation to Quentin for helpful review and feedback.

Best regards,
Tony
