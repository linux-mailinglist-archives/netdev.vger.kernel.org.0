Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9422E81AC
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 19:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgLaSyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 13:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgLaSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 13:54:51 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379A0C061573
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 10:54:11 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id h186so11612366pfe.0
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 10:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RgSE22mCVB1+vgCTSPbUhDE3dmIVJevB/UHHwcyDHuw=;
        b=NrIw0usU3z0DFRLWSgg9FNE+EQ7XR4vvbP7s7c2X1vK7klFbpWH1A95812d7gzU6Bh
         3jmTrOH4SH+BucXqjtyOGbho6ENH18JtX8mt5RINuS21tnFD1Jtn4i12pcEqr8sixoYK
         Z9H63wTIHrLBp6KjKYuAYt9tD6lb9oXutV4oL9RdHwRmyej+63L8VKM3B9gEE27izZdF
         OLFMuFzmaaGVhzizYTVcz9oYJ5YLCG3mnOuijWtJzi4lbQhWjouPdykMVmCGV0v7Gpj1
         f6c+aPYfboLAKq/6k4kJAGLeV80WJr/ByRbb931h3TvMrZ176RmBqm3/Qv0C/lJAgb3/
         Rz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RgSE22mCVB1+vgCTSPbUhDE3dmIVJevB/UHHwcyDHuw=;
        b=bRSNDJTnvbGoRwb0no82ORaS/SGR0xPSOZjoP/CZzM9x2XPCA9q+sBQ9YkVuZ9Pksu
         TeBkGN39ImRmZQtTeFEot6qJhuCSrSt+tZh7VV2z9lBDHPl7r7Fau+UXz4eQC384YvgA
         Jba/UVC7ZhfRWLQ4ale/gUP3X1YjBf2BxH/kA6yW4lMthkKVpi0DhBnHl1CGu/XTo+hW
         ebOkY4zVIn2kn63Rz2iy9NHwn9pvpSUTkx9lQsbBryjpRcZmt/2EdyUQk5Uimaeddhec
         Jk6pP89YX8YsLphti2oA9kHgZaAfngE7IjLxZhxtfyLwFZX4HrKxvS7ISMGNORrSc9gZ
         L+Hg==
X-Gm-Message-State: AOAM533OAaSDchahn1zFjv635tDTe9iamZ8RnfdWHRgsCjIjx/cghaqB
        np0wFhNleEAYV/dh1TfWy9xjsesIYGm+lohSnCOi0hFdPR4=
X-Google-Smtp-Source: ABdhPJxvk8Kavs9NySK/mjwsSnFLJWUFBLTOsGEh3eNSlwKKSM/HSdjqMIEigB3IBsoNmuyfJJlKrxPk4rOmYrWnAEU=
X-Received: by 2002:a05:6a00:88b:b029:19c:780e:1cd with SMTP id
 q11-20020a056a00088bb029019c780e01cdmr53298097pfj.64.1609440850580; Thu, 31
 Dec 2020 10:54:10 -0800 (PST)
MIME-Version: 1.0
References: <20201229160447.GA3156@chinagar-linux.qualcomm.com>
In-Reply-To: <20201229160447.GA3156@chinagar-linux.qualcomm.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 31 Dec 2020 10:53:59 -0800
Message-ID: <CAM_iQpUFCnmu36L0hwrK+xv9gBWKtcq44nOVGNEyR=o9QDx7Pg@mail.gmail.com>
Subject: Re: Race Condition Observed in ARP Processing.
To:     Chinmay Agarwal <chinagar@codeaurora.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        sharathv@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 29, 2020 at 8:06 AM Chinmay Agarwal <chinagar@codeaurora.org> wrote:
>
> Hi All,
>
> We found a crash while performing some automated stress tests on a 5.4 kernel based device.
>
> We found out that it there is a freed neighbour address which was still part of the gc_list and was leading to crash.
> Upon adding some debugs and checking neigh_put/neigh_hold/neigh_destroy calls stacks, looks like there is a possibility of a Race condition happening in the code.
[...]
> The crash may have been due to out of order ARP replies.
> As neighbour is marked dead should we go ahead with updating our ARP Tables?

I think you are probably right, we should just do unlock and return
in __neigh_update() when hitting if (neigh->dead) branch. Something
like below:

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0..0ce592f585c8 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1250,6 +1250,7 @@ static int __neigh_update(struct neighbour
*neigh, const u8 *lladdr,
                goto out;
        if (neigh->dead) {
                NL_SET_ERR_MSG(extack, "Neighbor entry is now dead");
+               new = old;
                goto out;
        }

But given the old state probably contains NUD_PERMANENT, I guess
you hit the following branch instead:

        if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
            (old & (NUD_NOARP | NUD_PERMANENT)))
                goto out;

So we may have to check ->dead before this. Please double check.

This bug is probably introduced by commit 9c29a2f55ec05cc8b525ee.
Can you make a patch and send it out formally after testing?

Thanks!
