Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576772546B2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgH0OVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 10:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgH0OVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 10:21:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE6AC061264;
        Thu, 27 Aug 2020 07:14:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DDD31274889E;
        Thu, 27 Aug 2020 06:57:23 -0700 (PDT)
Date:   Thu, 27 Aug 2020 07:14:08 -0700 (PDT)
Message-Id: <20200827.071408.2257489516960391705.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     fabf@skynet.be, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 net-next] vxlan: add VXLAN_NL2FLAG macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827095025.p4mxmuh2jwmzs5kt@lion.mk-sys.cz>
References: <20200827065019.5787-1-fabf@skynet.be>
        <20200827095025.p4mxmuh2jwmzs5kt@lion.mk-sys.cz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 06:57:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Thu, 27 Aug 2020 11:50:25 +0200

> On Thu, Aug 27, 2020 at 08:50:19AM +0200, Fabian Frederick wrote:
>> Replace common flag assignment with a macro.
>> This could yet be simplified with changelink/supported but it would
>> remove clarity
>> 
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>> ---
> [...]
>> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
>> index 3a41627cbdfe5..8a56b7a0f75f9 100644
>> --- a/include/net/vxlan.h
>> +++ b/include/net/vxlan.h
>> @@ -290,6 +290,16 @@ struct vxlan_dev {
>>  					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
>>  					 VXLAN_F_COLLECT_METADATA)
>>  
>> +
>> +#define VXLAN_NL2FLAG(iflag, flag, changelink, changelink_supported) {   \
>> +	if (data[iflag]) {						 \
>> +		err = vxlan_nl2flag(conf, data, iflag, flag, changelink, \
>> +				    changelink_supported, extack);       \
>> +		if (err)						 \
>> +			return err;					 \
>> +	}								 \
>> +}
>> +
> 
> Hiding a goto or return in a macro is generally discouraged as it may
> confuse people reading or updating the code.

Agreed, please don't do this.

