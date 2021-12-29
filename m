Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9048140C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhL2OXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbhL2OXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:23:42 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82613C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:23:42 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id i6so9983283pla.0
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MOCa+YxoIfO7Z1zSWTXyVPkKS3aH5rpaKLSAXQKBV0o=;
        b=NqHT/1TxAXtSbAOORPkQqeS5ZNpFFasHpTgkve2SPDq/doBi8qRcrj1Jf7pJOjPhVb
         BU+rBgL1n5azWIp9dorty3rV57xlXA9N+ejeuMWWt3trrkaZsrc0SgKWcoD1WDPepikb
         NqH5aQB8PPdHKRK1k8BdLxO+OzBTtqkmZbWS9vvSjOcA7OXee6Zd241XlBhfAFPEaCZN
         xFB2LXn/epJCg5585z2Ku7SjIoQ7nd/PQi49O0Q3mJRyG4hhHbtSMtL8Ng5elK50emYK
         E/qzpp+dV0qxZ33PLiAH2HphAt+DlKPRsAmSbOGkg3wsNm/g1rmMcTK2zaaIMUJ5wS71
         vYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MOCa+YxoIfO7Z1zSWTXyVPkKS3aH5rpaKLSAXQKBV0o=;
        b=fZEFPrJAx5yDxYioUj6dWDspLSrIlZJX4/h/QAAAAyRDns3NsW5hTmoP01E2nxa4Gl
         UIkskPQ6qm4CYAsxRiMQvIcH2/RH4wMmySQluWysxHeeNbZVybNKB/5JfoHB1+a27mng
         mAMeJQI9nERKkxeP70LSEfsizxdy+xdgaFpGor4go/MEhIuEmglu0nkC8Q3Uwk9AHOaP
         nkax8/Tg9o0S/I3T/7nq8OdzYtxiZIRceA4zmhC6iGWgiOBEEYZR2NWZGtBSungfHHDq
         AyCpxmyrFqa1BIX47UpWXoPAg3RqpEaA9uE7V2zyKvoCYCoJCJLzmKIXcZR8dV7sSq5Z
         3Qiw==
X-Gm-Message-State: AOAM531SixtVlWvsX6WwRM7tdaFvNL8ZbQ1TrPutVh17xB7u1u00SDVG
        69WpymSwx2wcVixiaMNJbH8=
X-Google-Smtp-Source: ABdhPJwpPUlgQff3dUbOEmmnqMBOtougslUHVdqczRwQ0iKrPzSH99nEL4qbXrpCHlVY6Wxpk80YGg==
X-Received: by 2002:a17:90a:d792:: with SMTP id z18mr32525246pju.182.1640787822098;
        Wed, 29 Dec 2021 06:23:42 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j23sm19773218pga.59.2021.12.29.06.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:23:41 -0800 (PST)
Date:   Wed, 29 Dec 2021 06:23:39 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 2/2] Bonding: return
 HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify user space
Message-ID: <20211229142339.GB4912@hoboy.vegasvil.org>
References: <20211229080938.231324-1-liuhangbin@gmail.com>
 <20211229080938.231324-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229080938.231324-3-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 04:09:38PM +0800, Hangbin Liu wrote:
> If the userspace program is distributed in binary form (distro package),
> there is no way to know on which kernel versions it will run.
> 
> Let's only check if the flag was set when do SIOCSHWTSTAMP. And return
> hwtstamp_config with flag HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify
> userspace whether the new feature is supported or not.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: 085d61000845 ("Bonding: force user to add HWTSTAMP_FLAG_BONDED_PHC_INDEX when get/set HWTSTAMP")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
