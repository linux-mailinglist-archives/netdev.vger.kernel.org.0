Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBE27AF66
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfG3ROX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:14:23 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:35488 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfG3ROX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:14:23 -0400
Received: by mail-pl1-f182.google.com with SMTP id w24so29147696plp.2
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 10:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=c8CDz77E2KE66c/Thjy7UNmKE5zqBCQgdv1sVQ5wn1U=;
        b=FFr2eAfHwOD2fye2eMYspUjtwco5Pfb1u5tyQi3rY9n5ZVMBXK61bGesvLo5fF5MLa
         iFzx6toro3H2yhJ27FI8F10lmahlG1RMaFeIOiiO84WZzY81nLNLh+D1lUqmbveTYNJ/
         esaxta7B0tXk52xyFV13YgNAwjcnFESwD+e2wWLN4R7AWireC5ph3V3zwXxJKtcb1zeZ
         sIRzbN6juInQhExl05NyU4y2OdyuJxkrX1Uks5xdJISz/yZtGPViShBoKgQZfTRiltqb
         U8AELcV7DOBlKhFS8S/ZMyCv8XLk4U9HiPX1cmReDuXhatg9BSSGRSVoXv+K6v65AEcH
         ANWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=c8CDz77E2KE66c/Thjy7UNmKE5zqBCQgdv1sVQ5wn1U=;
        b=AwIJvbU4XtPq2TkTX9laza0CGj7JGjfvXT/7RFRSksjP+9z2hUvYnd2z5iaXr2oCb9
         /yhrq+nFHAfyYhveXsNHbXjbCusfyTauAJZ242XHhEEdmzRopdFIa80B0Dxv9BfYfXzN
         /7KZ5SQpnvlg/EPDJFStfxGNv9FaSvoDbKJie2qowuEF/ZnxWBUGihKiu9HQFKN4zDYh
         nI6fXoMB4v5itoLJJxC9dkpBmEANocREGUhs+7VjKiTqv/2o9RFV9z6EmT1wUtCS/CGl
         pGl1ivd8Sw5IM+7lgfcgB53tV+5URgkTMNkaInoAMo32vO0IYFOqR8b1iqP2YYMtTosh
         V6cA==
X-Gm-Message-State: APjAAAW+imo3JaivilZMozR5z+hsTD1+H7xbs7X7m4Y37sUnubUnWBnT
        8FQSBn02BfxNY/AC4OGQ/H3FJw==
X-Google-Smtp-Source: APXvYqwPzBjFojFrnIZ/IzR+IQY18ELaHFCsZ+mbcg+0pwxjf4BdEZHlohyuMblAFTvjopNwMI7Sng==
X-Received: by 2002:a17:902:e703:: with SMTP id co3mr18827574plb.119.1564506862901;
        Tue, 30 Jul 2019 10:14:22 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id v13sm76784375pfe.105.2019.07.30.10.14.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 10:14:22 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:14:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 3/3] netdevsim: create devlink and netdev
 instances in namespace
Message-ID: <20190730101411.7dc1e83d@cakuba.netronome.com>
In-Reply-To: <20190730060655.GB2312@nanopsycho.orion>
References: <20190727094459.26345-1-jiri@resnulli.us>
        <20190727094459.26345-4-jiri@resnulli.us>
        <20190729115906.6bc2176d@cakuba.netronome.com>
        <20190730060655.GB2312@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 08:06:55 +0200, Jiri Pirko wrote:
> >> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> >> index 79c05af2a7c0..cdf53d0e0c49 100644
> >> --- a/drivers/net/netdevsim/netdevsim.h
> >> +++ b/drivers/net/netdevsim/netdevsim.h
> >> @@ -19,6 +19,7 @@
> >>  #include <linux/netdevice.h>
> >>  #include <linux/u64_stats_sync.h>
> >>  #include <net/devlink.h>
> >> +#include <net/net_namespace.h>  
> >
> >You can just do a forward declaration, no need to pull in the header.  
> 
> Sure, but why?

Less time to compile the kernel after net_namespace.h was touched.
Don't we all spend more time that we would like to recompiling the
kernel? :(  Not a huge deal if you have a strong preference.
