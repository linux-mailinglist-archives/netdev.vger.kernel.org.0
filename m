Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30111A74FF
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfICUet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:34:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35564 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfICUes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 16:34:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0020E6085C; Tue,  3 Sep 2019 20:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567542887;
        bh=a5RdGD9HLYb5JfSs7oy4DNSHjvThStqYpkCPLyypeXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YpFNdcA3B5iO75sqlzYMiPZHzh6peHRjOPUuwogCCxIIt+zNzzDdH9Gf4LG9xl8xP
         c1E3c2RkZm3D06+d6oacmWxqK6sG8dIonDLnXLjICEGAOvVKKHlktkYImG5P6M5Y7M
         +S2pC3JX0HlYI+9KJgmYHIPnX5KPRrTxcepVNSPQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 75D0A607F4;
        Tue,  3 Sep 2019 20:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567542886;
        bh=a5RdGD9HLYb5JfSs7oy4DNSHjvThStqYpkCPLyypeXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=by1/C/XwQOR2JMGNbIHZpL80J7fw3o3bfwbvpEhRfNc+eGosK+jh8rTFNOPbFZNtj
         km0e20Qh1vXd1zwX37D0Qht80SIWSycP9man0W7qFAnaNSzciwgpqfpvTX2of0E8Cu
         L2CpekKKEIFhT0b+oFMr1jmTmEpC6E/PSVfg267c=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 03 Sep 2019 14:34:45 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, stranche@codeaurora.org
Subject: Re: [PATCH net-next] net: Fail explicit bind to local reserved ports
In-Reply-To: <20190830.142202.1082989152863915040.davem@davemloft.net>
References: <1567049214-19804-1-git-send-email-subashab@codeaurora.org>
 <20190830.142202.1082989152863915040.davem@davemloft.net>
Message-ID: <10c297103bf3992e1630604972efa681@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't know how happy I am about this.  Whatever sets up the 
> transparent
> proxy business can block any attempt to communicate over these ports.
> 
> Also, protocols like SCTP need the new handling too.

Hi David

The purpose of this patch was to allow the transparent proxy application
to block the specific socket ranges to prevent the communication on the
specific ports.

Dropping packets for this particular port using iptables could lead to
applications on the system getting stuck without getting a socket error.
If bind fails explicitly, the application can atleast retry for some 
other
port.
Is there some alternate existing mechanism to achieve this already?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
