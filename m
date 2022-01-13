Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E717648DDDE
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiAMSus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiAMSur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 13:50:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEFAC061574;
        Thu, 13 Jan 2022 10:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B726B82326;
        Thu, 13 Jan 2022 18:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25C7C36AE9;
        Thu, 13 Jan 2022 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642099844;
        bh=FSWt886XgYsw7G7l3qo5p3On5r/WJnz+eCmQ5Qpdd0M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dnggfMrNjlIyO+NMIKoYed6mB25pA6bYhoPlA3Qm2pv9CDsbSRexHcnusVV+Uo7Be
         IjhhH7a69A+SGgX4AmgRQLNhXhWxQPTFnHQ2bV9Niin+2gQIddf43772iaR3Odt8w3
         YLOidr0P43eVDc+EHm1SMImpGiaYm4dS9a6s+I3Z1PWg5+v2TGRjQ1LwJOLAteovaG
         uDyJvV/1P/OOX1zO3oVGiPDHTDBHQkxiPmmtohod10pYMfP2QeXlDWDV4lofdd9tSw
         PPbMxJNiXxq8NbEy0CbLLEuvTHSW/b4iCk1x27OaNCo1QjKyVFXxcb4ykKoN+Vx/mi
         iUfYpMx42K48g==
Date:   Thu, 13 Jan 2022 10:50:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>, dust.li@linux.alibaba.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <20220113105042.7a45aeb1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
        <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
        <20220105044049.GA107642@e02h04389.eu6sqa>
        <20220105085748.GD31579@linux.alibaba.com>
        <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
        <20220105150612.GA75522@e02h04389.eu6sqa>
        <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
        <YdaUuOq+SkhYTWU8@TonyMac-Alibaba>
        <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 09:07:51 +0100 Karsten Graul wrote:
> Lets decide that when you have a specific control that you want to implement. 
> I want to have a very good to introduce another interface into the SMC module,
> making the code more complex and all of that. The decision for the netlink interface 
> was also done because we have the impression that this is the NEW way to go, and
> since we had no interface before we started with the most modern way to implement it.
> 
> TCP et al have a history with sysfs, so thats why it is still there. 
> But I might be wrong on that...

To the best of my knowledge you are correct.
