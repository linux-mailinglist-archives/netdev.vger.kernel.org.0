Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D436BDD35
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404909AbfIYLfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:35:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34566 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732353AbfIYLfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:35:10 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B233F154CC67E;
        Wed, 25 Sep 2019 04:35:08 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:35:07 +0200 (CEST)
Message-Id: <20190925.133507.2083224833639646147.davem@davemloft.net>
To:     alvaro.gamez@hazent.com
Cc:     dan.carpenter@oracle.com, radhey.shyam.pandey@xilinx.com,
        michal.simek@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: axienet: fix a signedness bug in probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925110542.GA21923@salem.gmr.ssr.upm.es>
References: <20190925105911.GI3264@mwanda>
        <20190925110542.GA21923@salem.gmr.ssr.upm.es>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:35:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alvaro G. M" <alvaro.gamez@hazent.com>
Date: Wed, 25 Sep 2019 13:05:43 +0200

> Hi, Dan
> 
> On Wed, Sep 25, 2019 at 01:59:11PM +0300, Dan Carpenter wrote:
>> The "lp->phy_mode" is an enum but in this context GCC treats it as an
>> unsigned int so the error handling is never triggered.
>> 
>>  		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
>> -		if (lp->phy_mode < 0) {
>> +		if ((int)lp->phy_mode < 0) {
> 
> This (almost) exact code appears in a lot of different drivers too,
> so maybe it'd be nice to review them all and apply the same cast if needed?

Or make the thing an int if negative values are never valid 32-bit phy_mode
values anyways.
