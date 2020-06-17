Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A91FCA56
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFQJ71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 05:59:27 -0400
Received: from smtp32.i.mail.ru ([94.100.177.92]:48336 "EHLO smtp32.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgFQJ70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 05:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=b5MPf83zfr1gghG1pTsW6fVwYRf1CJQcdXFVKRwPte8=;
        b=SRkciVJjNIne6q8Il6NEmqmhnDKOt4mKSDVc3N9gRrLyf3cKm1DrrjMwFl91z9QHx/Az1GbfrZk5xFczHcoKxfX8TKNsfZAdbCEql/i2GYdR2IeOByL1f4oUnmLq1wtW7VY3TkgdnZHbej0K9noC5qA4bGF8NFgGuy/lmKtySsY=;
Received: by smtp32.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jlUqp-0002d1-C6; Wed, 17 Jun 2020 12:59:23 +0300
Subject: Re: [PATCH v2 01/02] net: phy: marvell: Add Marvell 88E1340 support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
References: <05f6912b-d529-ae7d-183e-efa6951e94b7@inbox.ru>
 <20200617084729.GN1551@shell.armlinux.org.uk>
From:   Maxim Kochetkov <fido_max@inbox.ru>
Message-ID: <c06a1893-64bf-68df-9008-684506c5e354@inbox.ru>
Date:   Wed, 17 Jun 2020 12:59:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200617084729.GN1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp32.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9F3DF18D84EDC53E03273ADD47276010DDF84FAD614EA721E182A05F538085040E5B1E094669FF15AEB90B2257F97810BF2F377E1B5D62914C8546C139DD2F8A6
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7A179494B5629353BEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637B23888C9749F3CAC8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC3465A7BABD88B4E59DDA71EE1AD65A340D0E5DBBB844B088389733CBF5DBD5E913377AFFFEAFD269A417C69337E82CC2CC7F00164DA146DAFE8445B8C89999725571747095F342E8C26CFBAC0749D213D2E47CDBA5A9658378DA827A17800CE71AE4D56B06699BBC9FA2833FD35BB23DF004C906525384303BDABC7E18AA350CD8FC6C240DEA76428AA50765F7900637F3743B84211EF447D81D268191BDAD3DBD4B6F7A4D31EC0BD28E6F1989ABE784D81D268191BDAD3D78DA827A17800CE7E34610862E5853DDEC76A7562686271E8729DE7A884B61D135872C767BF85DA29E625A9149C048EE0A3850AC1BE2E735D2457FAF19517CF24AD6D5ED66289B524E70A05D1297E1BB35872C767BF85DA227C277FBC8AE2E8BDAE3FA6833AEA0C275ECD9A6C639B01B4E70A05D1297E1BBC6867C52282FAC85D9B7C4F32B44FF57285124B2A10EEC6C00306258E7E6ABB4E4A6367B16DE6309
X-C8649E89: 66CAA23DAA1F5691FCB0006736781D6CC91D0936210FA9D64FE975E9D58273CAAA5209167E0B1095
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj1fDABIY57ZhKMJ+wnhYltw==
X-Mailru-Internal-Actual: A:0.80966334383055
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB2478A6756CF8553D5E55D5009BE5192477C41A96CE181C003AEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just copied this part from another marvell PHY description.
I can remove &-style reference for all marvell PHY's at next patch.

17.06.2020 11:47, Russell King - ARM Linux admin wrote:
> On Wed, Jun 17, 2020 at 07:52:45AM +0300, Maxim Kochetkov wrote:
>> Add Marvell 88E1340 support
>> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
>> ---
>>   drivers/net/phy/marvell.c   | 23 +++++++++++++++++++++++
>>   include/linux/marvell_phy.h |  1 +
>>   2 files changed, 24 insertions(+)
>>
>> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
>> index 7fc8e10c5f33..4cc4e25fed2d 100644
>> --- a/drivers/net/phy/marvell.c
>> +++ b/drivers/net/phy/marvell.c
>> @@ -2459,6 +2459,28 @@ static struct phy_driver marvell_drivers[] = {
>>   		.get_tunable = m88e1540_get_tunable,
>>   		.set_tunable = m88e1540_set_tunable,
>>   	},
>> +	{
>> +		.phy_id = MARVELL_PHY_ID_88E1340S,
>> +		.phy_id_mask = MARVELL_PHY_ID_MASK,
>> +		.name = "Marvell 88E1340S",
>> +		.probe = m88e1510_probe,
>> +		/* PHY_GBIT_FEATURES */
>> +		.config_init = &marvell_config_init,
>> +		.config_aneg = &m88e1510_config_aneg,
>> +		.read_status = &marvell_read_status,
>> +		.ack_interrupt = &marvell_ack_interrupt,
>> +		.config_intr = &marvell_config_intr,
>> +		.did_interrupt = &m88e1121_did_interrupt,
>> +		.resume = &genphy_resume,
>> +		.suspend = &genphy_suspend,
>> +		.read_page = marvell_read_page,
>> +		.write_page = marvell_write_page,
>> +		.get_sset_count = marvell_get_sset_count,
>> +		.get_strings = marvell_get_strings,
>> +		.get_stats = marvell_get_stats,
>> +		.get_tunable = m88e1540_get_tunable,
>> +		.set_tunable = m88e1540_set_tunable,
> 
> Can we use a single style for referencing functions please?  The kernel
> in general does not use &func, it's more typing than is necessary.  The
> C99 standard says:
> 
>     6.3.2.1  Lvalues, arrays, and function designators
> 
> 4  A function designator is an expression that has function type.
>     Except when it is the operand of the sizeof operator or the unary
>     & operator, a function designator with type ``function returning
>     type'' is converted to an expression that has type ``pointer to
>     function returning type''.
> 
> Hence,
> 
>    .resume = &genphy_resume
> 
> and
> 
>    .resume = genphy_resume
> 
> are equivalent but sizeof(genphy_resume) and sizeof(&genphy_resume) are
> not.
> 
> Thanks.
> 
