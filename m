Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470EEFE44A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKORpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 12:45:40 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:52404 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfKORpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 12:45:40 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id xAFHiuoF021741;
        Fri, 15 Nov 2019 18:45:01 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.17])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 6E582120288;
        Fri, 15 Nov 2019 18:44:52 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1573839892; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+gMUpNvXVmANKnt9biF9wy+hihvyOaCvIM2XBgwx5k=;
        b=rjHnXjwBoLKZ7zt0plnJZANkLWcH014rXejP75TbOEZ4lQQRRvgHpzUx8oy5Sv+gWBCvyL
        +zo6ApJbV6PQ+hAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1573839892; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+gMUpNvXVmANKnt9biF9wy+hihvyOaCvIM2XBgwx5k=;
        b=qhegkJsU5LSEbbqG9RCyf7ATS3q1ZekBwgitPl2tilRWDIdg10dMctXpQ0AADtMOR3NLI7
        EhuPGSRkGEBtzB+nG/cnNXYNhmEdRpPORRZzqemjKyVLunWNqcE7PK4gwpMmaP2USux/q9
        n/IrlJh0R+nsBDrJm2izgiNAsuVZP3v8IGGrbsfnqlHAiu5BKMx2BtbujZWC/aGIrnDvOj
        ZMJawXxrZ7rAAHcSLpPJ2xczegYfSCLTu2Pnv8gHdN3JWPtaeI4jKRih1tV6aBKq1M9iqK
        1QMTwaFSDPIyulnSDwYg/ZMl2oKsw2eTmtfooYGSpz/IzfuzlD9YtRMpS/3rpg==
Date:   Fri, 15 Nov 2019 18:44:52 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dav.lebrun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrea.mayer@uniroma2.it
Subject: Re: [net-next, 1/3] seg6: verify srh pointer in get_srh()
Message-Id: <20191115184452.828eb26ff29c90ff432bc2f5@uniroma2.it>
In-Reply-To: <20191114.174512.2282984013110706126.davem@davemloft.net>
References: <20191113192912.17546-1-andrea.mayer@uniroma2.it>
        <20191113192912.17546-2-andrea.mayer@uniroma2.it>
        <20191114.174512.2282984013110706126.davem@davemloft.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 17:45:12 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Andrea Mayer <andrea.mayer@uniroma2.it>
> Date: Wed, 13 Nov 2019 20:29:10 +0100
> 
> > pskb_may_pull may change pointers in header. For this reason, it is
> > mandatory to reload any pointer that points into skb header.
> > 
> > Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> 
> This is a bug fix and must be separated out and submitted to 'net'.
> 
> Then you must wait until 'net' is merged into 'net-next' so that you
> can cleanly resubmit the other changes in this series which add the
> new features.
> 
> Actually, patch #2 looks like a bug fix as well.

Hi,
thanks for your review. I will submit the first two patches to 'net'.

Regards,
Andrea Mayer
