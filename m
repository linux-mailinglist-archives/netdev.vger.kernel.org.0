Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1648F81A
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 17:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiAOQ6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 11:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiAOQ6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 11:58:47 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A9AC061574
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 08:58:46 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ay4-20020a05600c1e0400b0034a81a94607so10951550wmb.1
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 08:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=flpafWvQZH9VlFgsKJUbtGYcp5rCIiWdZqEGz4+K2CM=;
        b=HJNzQDvFLnwWd5qBjS+hC/AbSlblSvOdkLTCMF439xmVrWXowNHXmKBV3MiHpjLIFs
         nxONRzpX4mwm31Ns3F5vOS9dQAAcS2N2DOCyJX48zn+7vfPjxTwbhf/0BVSdwYHTeFF0
         iDr8MhxgAIZNWNQGC1eJITixxsvuEA0gXjqWAV9Tduur8/1CTuGr0pZWAIAyQjqYMB/A
         rM8y1EmmJ3uEbCceKsUP7c+TdBlDGknCEGsifyEx9hbgjcgXV1mO8aZ7mKfxuQdOZeJk
         0hrgI+8ja6AIiS9BJLZLSaI8+PQBSdeV/pCa9rl639Ul/I/0C+F4O2rlnoPIgtP1ZIrt
         vBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=flpafWvQZH9VlFgsKJUbtGYcp5rCIiWdZqEGz4+K2CM=;
        b=cTLErVGOw/13mWNmGlD8AVL3GlTBiATxUneU6uJrpMROJ69ExIGHB1DVcqMe5BGwhQ
         4wdyXVSU1RRWol4FyuZkSX3rI8PiedrgE8FzrmzV8ijKyit84wYvSso9+TRXNTx2wtbl
         kqcN1McCCi1qv4v6kWd4HQkWOmOivg+Jf9sDxmZ4zN8TKtYsxLT+ys55mfSz1Yy4+1+H
         4hSNY3cn8Hl5aIQ69l5OWXmV45FydmICcGe2UjMU8m94PoMnvKw+7jzVMVXdxCmhM6Pb
         ObxMyTrNy4RfNVG9rE40E1Um5W1Jg4XgzCB109P61FZf4D9GGHY0F8L5GdWrZ+7JBlHg
         vFZA==
X-Gm-Message-State: AOAM532D6srookhZuD5pmQXJPzP2UMRLY3EnBzMpb8UBsEgZDUzBLb7h
        vl7iyvEIcYp/XIKaObhtaVQ=
X-Google-Smtp-Source: ABdhPJw0zx8WUWXT6403vq+k1uYa+yvJDtijZmIZV+EXg10PfFFDGl14gZwAhqMFaopJeLhMNyCHPA==
X-Received: by 2002:a5d:525a:: with SMTP id k26mr2579402wrc.625.1642265925233;
        Sat, 15 Jan 2022 08:58:45 -0800 (PST)
Received: from debian64.daheim (p4fd09498.dip0.t-ipconnect.de. [79.208.148.152])
        by smtp.gmail.com with ESMTPSA id e12sm6449846wrg.33.2022.01.15.08.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 08:58:44 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1n8mO3-003BFB-Ih;
        Sat, 15 Jan 2022 17:58:43 +0100
Message-ID: <d4533eb7-97c1-5eb1-011d-60b59ff7ccbb@gmail.com>
Date:   Sat, 15 Jan 2022 17:58:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag
 mode
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        netdev@vger.kernel.org,
        =?UTF-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
References: <20211130073929.376942-1-bjorn@mork.no>
 <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
 <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/12/2021 13:58, Russell King (Oracle) wrote:
> On Fri, Dec 03, 2021 at 11:54:57AM +0000, Russell King (Oracle) wrote:
> [...]
> Thinking a little more, how about this:
>
>   drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 51a1da50c608..4c900d063b19 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
>   static int sfp_module_parse_power(struct sfp *sfp)
>   {
>   	u32 power_mW = 1000;
> +	bool supports_a2;
>   
>   	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
>   		power_mW = 1500;
>   	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
>   		power_mW = 2000;
>   
> +	supports_a2 = sfp->id.ext.sff8472_compliance !=
> +				SFP_SFF8472_COMPLIANCE_NONE ||
> +		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
> +
>   	if (power_mW > sfp->max_power_mW) {
>   		/* Module power specification exceeds the allowed maximum. */
> -		if (sfp->id.ext.sff8472_compliance ==
> -			SFP_SFF8472_COMPLIANCE_NONE &&
> -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> +		if (!supports_a2) {
>   			/* The module appears not to implement bus address
>   			 * 0xa2, so assume that the module powers up in the
>   			 * indicated mode.
> @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp *sfp)
>   		}
>   	}
>   
> +	if (power_mW <= 1000) {
> +		/* Modules below 1W do not require a power change sequence */
> +		return 0;
> +	}
> +
> +	if (!supports_a2) {
> +		/* The module power level is below the host maximum and the
> +		 * module appears not to implement bus address 0xa2, so assume
> +		 * that the module powers up in the indicated mode.
> +		 */
> +		return 0;
> +	}
> +
>   	/* If the module requires a higher power mode, but also requires
>   	 * an address change sequence, warn the user that the module may
>   	 * not be functional.
>   	 */
> -	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
> +	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
>   		dev_warn(sfp->dev,
>   			 "Address Change Sequence not supported but module requires %u.%uW, module may not be functional\n",
>   			 power_mW / 1000, (power_mW / 100) % 10);
>

The reporter has problems reaching you. But from what I can tell in his reply to his
OpenWrt Github PR:
<https://github.com/openwrt/openwrt/pull/4802#issuecomment-1013439827>

your approach is working perfectly. Could you spin this up as a fully-fledged patch (backports?)

Thank you & Cheers,
Christian
