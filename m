Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D149555D
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 21:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377610AbiATUVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 15:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbiATUVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 15:21:48 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36884C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 12:21:48 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso24587568wmj.0
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 12:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fYFk8dsh6smhRnCB1VTT2kbuc9pYWj6Jn4ZPM45/ak=;
        b=ULioeqEn6wokqmUdDr73WtRSFxDRDEtaA0Xsl+8sIOlS87qKlJTEG9Sjfb+fZ6Jhdp
         UOvXeGeGE6b4TTtGasC682SGYJBWhdnNSuAHCcZEtiepLZ6+jCI5A5e6RiclPeHTpsF/
         NFz8Lbyg2zlmAiBoSZ1Sn/zCBe/RIi7DuySrKFfdqLjRWmnB5gf139cO5/Kn5s965Yuk
         33LAI0puTGchUD95frz5DH9oT2rWd9cPQ5vf9Zot3g62P4/Id2zj/5T4u2UMjGHQHScF
         viDSAzbsiik8OicFM5/MU/ELRjAvggdrPNewPCnoQ/MgAgbks1sfRysc5WAT9NWaxWGn
         n7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fYFk8dsh6smhRnCB1VTT2kbuc9pYWj6Jn4ZPM45/ak=;
        b=aRtsCIYrz2zFlTVWpyPnM5mfxkhZYJVtQnu1eU2n34rEtBiTO5mTTxtyKxILAJnDXE
         dO/CKRinlrMYOn6ScvZu9OmKE+5u7pwIoJzPFBZzalH5MzRAQR5aRtYrtC7tbxivEcyA
         7Cws9NIoC9ph4Bw//575mwYdkEjM45xIRz1YJFyjCfWEKGzMSpg9lk5n4Q3BQBTQFO3e
         bNYUrwrLDZEdI3Gfx6NsVTB+Euovu4YhoJ5fGEyFN1nrU4stNqaOjR1GX4NZ+Dgjl7oq
         4KqdGc2PxNAJJocHtn8CHEfaMOvU6Qqf3TP6BXXxSOlv3P0dSedFtJyvJQ8MLFEA6GHg
         vY7Q==
X-Gm-Message-State: AOAM531z2M81ehG6gfWFxwEBCfuv1S6slwPgVcfAxS2wqMAmmpfe7H3C
        BKO8HCTVPvVzmfj8egn0MuPLL/KIsdErkOA8px5Rcw==
X-Google-Smtp-Source: ABdhPJz2RpKOcY27H/Qtp51p3HFcUeXLf0wtUAEeYdwb/ATsd1+fFiuill+90WvMkgt/N8LSBKxBkPEQ3/nO8Y9AmxY=
X-Received: by 2002:a05:6000:2aa:: with SMTP id l10mr681790wry.57.1642710106794;
 Thu, 20 Jan 2022 12:21:46 -0800 (PST)
MIME-Version: 1.0
References: <20220111175438.21901-1-sthemmin@microsoft.com>
 <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com> <e8e78f5e-748b-6db4-7abe-4ccbf70eaaf0@mojatatu.com>
 <CA+NMeC8ksPxUbg_2M9=1oKFWAPg_Y8uaVndTCAdC+0xvFRMmFQ@mail.gmail.com> <b3917b75-9420-c965-e6cf-0dcfeb35b1bd@gmail.com>
In-Reply-To: <b3917b75-9420-c965-e6cf-0dcfeb35b1bd@gmail.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Thu, 20 Jan 2022 17:21:35 -0300
Message-ID: <CA+NMeC_P=d3AN9zg-aAPg2Zq+ZBW8=r2xD+v0FPm=ae8nDegoA@mail.gmail.com>
Subject: Re: [PATCH v2 iproute2-next 00/11] clang warning fixes
To:     David Ahern <dsahern@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 4:20 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/20/22 5:48 AM, Victor Nogueira wrote:
> > Hi,
> > Sorry for not responding sooner. I patched iproute2 and several
> > existing tests failed.
> > Example:
> > Test 696a: Add simple ct action
> >
> > All test results:
> >
> > 1..1
> > not ok 1 696a - Add simple ct action
> > Could not match regex pattern. Verify command output:
> > total acts 1
> >
> > action order 0: ct
> > zone 0 pipe
> > index 42 ref 1 bind 0
> >
> > The problem is the additional new line added.
> >
> > WIthout this patch:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220117175019.13993-6-stephen@networkplumber.org/
> > it the output of tc actions list action ct is:
> >
> > total acts 1
> >
> > action order 0: ct zone 0 pipe
> > index 42 ref 1 bind 0
> >
> > With it it is:
> >
> > total acts 1
> >
> > action order 0: ct
> > zone 0 pipe
> > index 42 ref 1 bind 0
> >
> > So I believe the problem is just formatting, however it still breaks some tests
> >
>
> Thanks, Victor. Hopefully that is addressed in v3 of the set.
>

Actually, I tested using v3 patches.
Sorry, I should've said that in the previous email.

cheers,
Victor
