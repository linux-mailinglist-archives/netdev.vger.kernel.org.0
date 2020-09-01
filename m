Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8DE2584B2
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 02:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgIAAQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 20:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgIAAQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 20:16:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B16C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 17:16:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B16512985931;
        Mon, 31 Aug 2020 16:59:28 -0700 (PDT)
Date:   Mon, 31 Aug 2020 17:16:13 -0700 (PDT)
Message-Id: <20200831.171613.1392501036623240615.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     snelson@pensando.io, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] ionic: smaller coalesce default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831165054.6d16f0dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200831233558.71417-1-snelson@pensando.io>
        <20200831233558.71417-3-snelson@pensando.io>
        <20200831165054.6d16f0dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 31 Aug 2020 16:59:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 31 Aug 2020 16:50:54 -0700

> On Mon, 31 Aug 2020 16:35:55 -0700 Shannon Nelson wrote:
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> index 9e2ac2b8a082..2b2eb5f2a0e5 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> @@ -16,7 +16,7 @@
>>  #define IONIC_DEF_TXRX_DESC		4096
>>  #define IONIC_LIFS_MAX			1024
>>  #define IONIC_WATCHDOG_SECS		5
>> -#define IONIC_ITR_COAL_USEC_DEFAULT	64
>> +#define IONIC_ITR_COAL_USEC_DEFAULT	8
> 
> 8 us interrupt coalescing does not hurt general operations?! No way.
> 
> It's your customers who'll get hurt here, so your call, but I seriously
> doubt this. Unless the unit is not usec?

Agreed, 8usec is really really low.  You won't get much coalescing during
bulk transfers with a value like that, eliminating the gain from coalescing
in the first place.
