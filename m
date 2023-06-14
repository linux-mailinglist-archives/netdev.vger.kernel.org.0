Return-Path: <netdev+bounces-10868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 182D7730983
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F00D71C20DB9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEA011CB1;
	Wed, 14 Jun 2023 21:00:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC716D3F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:00:14 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380A019B5;
	Wed, 14 Jun 2023 14:00:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686776381; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=e+knpUe+Ng4xZa8FT/nRnJISWoAC5XHVTW6OGz6rksfE7XQe1mq3cdXXjftKcP1IxPWpAIcrJQFpDaUioPxND3eCytsSQFufZpQlZ8RkT3e43OgwMCENBpwOXR/ovcSw3LPeDHr1FyYKEsDhfAMFuS/6nU0a5pEs8X4Q4Mh4Krs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686776381; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=QCE8raYlbiidyJWssP8dsm4pMUq5xPCJhSiYfiXhjM8=; 
	b=MMNb7KWrg8V6jnxJINYdVu5pjFQVL1YdNMpsGmKyscsHHZh3czbUqaSzmjWUhruljyKHYvNuUzj49IMwg6zU/BDNThw+BeKA2fUrR242YAnQPPZ4QapTtRusvw3aeB1jtER9/WrqYBN4R/QA9NoIZVuUn+bIwWvKXMdyQi1hwcc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686776381;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=QCE8raYlbiidyJWssP8dsm4pMUq5xPCJhSiYfiXhjM8=;
	b=j2XhT3ae6El0gobD+RnJWAdi+TU1LAOhSgYd5YsbDvK8KK7fKCwzQoxv6KNfiStB
	BcUHFZSWMvSq7br7gc900l/28/rarj+7Ovrmtfz50v+wsD+9Ew3Yra0r+meb09MNR4b
	x2aL4kqIw1U9bOzS+C+gBATc+F3IaA2u7IMVYT6Y=
Received: from [192.168.99.141] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 168677637978093.19420675487902; Wed, 14 Jun 2023 13:59:39 -0700 (PDT)
Message-ID: <581f410d-e94f-e980-f54b-b870017ba73c@arinc9.com>
Date: Wed, 14 Jun 2023 23:59:33 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 3/7] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-4-arinc.unal@arinc9.com>
 <20230614201336.lf5hqrp5nw7han4r@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230614201336.lf5hqrp5nw7han4r@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 14.06.2023 23:13, Vladimir Oltean wrote:
> On Mon, Jun 12, 2023 at 10:59:41AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The check for setting the CPU_PORT bits must include the non-MT7621 SoC
>> MT7530 switch variants to trap frames. Expand the check to include them.
>>
>> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   drivers/net/dsa/mt7530.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index ef8879087932..2bde2fdb5fba 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -3073,7 +3073,7 @@ mt753x_master_state_change(struct dsa_switch *ds,
>>   	 * the numerically smallest CPU port which is affine to the DSA conduit
>>   	 * interface that is up.
>>   	 */
>> -	if (priv->id != ID_MT7621)
>> +	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
>>   		return;
> 
> This patch and 2/7 should probably be reversed, since 2/7 is not going to net.

This patch is still necessary. It'll just modify the other location 
instead of here.

https://github.com/arinc9/linux/commit/4c8b983f7a95ba637799ccd1b700ee054b030729

Arınç

