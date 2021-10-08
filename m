Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C94262CD
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 05:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhJHDTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 23:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJHDTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 23:19:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6825C061570;
        Thu,  7 Oct 2021 20:17:52 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a11so5304925plm.0;
        Thu, 07 Oct 2021 20:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=ApOKKBCMuAZ4Vx/5ob40RCelwZhTvT67bmG3ANEluW8=;
        b=Qfr5WIt0rkHg4KG3t1iY6J1y1yLDEgcbPf5SHUv1rIzqRBsz/5uzLcJUMZnSn74YL8
         kRDVeCfxp8GigTyNHwoZ0dXS73QmhUds18a8OLJcmshBKJVJLe6dPwCPtGt1Pm425Lvf
         Nl38h/rnebJWGEFPAjPhXZI4C6082a0v7n/5at9C7DIMPq1KY7RgPmh+MyINTBQEz9Kf
         fAdfYxw9vzfPkZCGrmScZLnFVBB/toVTa6tTKyv9z6ZL86/N4zNYHsk9+3+DLh3TPZFp
         pS/H/KM1lSxf7yVQzufzSNFL0cS7lg0i6H4kVt4nnJT8F1ACV5tpppKEn6vYpgoPTEYk
         mJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=ApOKKBCMuAZ4Vx/5ob40RCelwZhTvT67bmG3ANEluW8=;
        b=PzrhFa3b1p8tBpCaa/665/irUbFhUCnS+iHfUofrVh7taxKYvaiRCWZIotz9uBh3Xb
         Vb+Dm5D/WPgBFqaYWEGQ2CdZzkw9U/FSSnpbCALBUW27Zk3E1QkYqBB/KvxEtYKkPa9U
         QxEUWCV6NVRxhl/ozZ+SH+UySM9MEfYFFk6kHjxS1m2Cv9PBrWA5/4ifLblekEcpB2ag
         9YvDWxTfrgIlXZvPJ8GOCTuEb30TVFYZvxFTCeCpSii8ug80n0tFgdLvZNQIriHUOTtU
         fD0AvMiPQ9eq8os27NxrGO+cSxHS33wurWhN4W9MFGCFVsEnunka4psahR/7L3ucLcdp
         N+mQ==
X-Gm-Message-State: AOAM532D/os97iS1tk4CllEQ7ixCb4B3Kgb7X9ZcJ9E2pNLgTGvP0K4f
        aOHRBZeynKkG2sj3pAs8D58=
X-Google-Smtp-Source: ABdhPJyZsmxJ9hP5Kw+9bGwzN9Glcf1vHwpjV6UZVC8OiQmND7+AHtV3qdpWmvagZ5sP1eBuwNI/TQ==
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr7406835plq.59.1633663071904;
        Thu, 07 Oct 2021 20:17:51 -0700 (PDT)
Received: from localhost (122x211x248x161.ap122.ftth.ucom.ne.jp. [122.211.248.161])
        by smtp.gmail.com with ESMTPSA id w185sm737585pfd.113.2021.10.07.20.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 20:17:51 -0700 (PDT)
From:   Punit Agrawal <punitagrawal@gmail.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     davem@davemloft.net, michael.riesch@wolfvision.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, lgirdwood@gmail.com,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Ethernet broken on rockpro64 by commit 2d26f6e39afb
 ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
References: <8e33c244-b786-18e8-79bc-407e27e4756b@arm.com>
Date:   Fri, 08 Oct 2021 12:17:48 +0900
In-Reply-To: <8e33c244-b786-18e8-79bc-407e27e4756b@arm.com> (Alexandru
        Elisei's message of "Tue, 28 Sep 2021 10:25:59 +0100")
Message-ID: <87zgrk19yb.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> (Sorry I'm sending this to the wrong person, this is what I got
> scripts/get_maintainer.pl for the file touched by the commit)
>
> After commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
> pm_runtime_enable warnings"), the network card on my rockpro64-v2 was left unable
> to get a DHCP lease from the network. The offending commit was found by bisecting
> the kernel; I tried reverting the commit from current master (commit 0513e464f900
> ("Merge tag 'perf-tools-fixes-for-v5.15-2021-09-27' of
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux")) and the network card
> was working as expected.
>
> It goes without saying that I can help with testing the fix and
> further diagnosing.

A fix was recently merged for this (see aec3f415f724 ("net: stmmac:
dwmac-rk: Fix ethernet on rk3399 based devices") and should show up in
the next rc. Please shout out if that doesn't fix the broken ethernet
for you.

Thanks,
Punit

