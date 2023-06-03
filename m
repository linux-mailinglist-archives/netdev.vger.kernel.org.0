Return-Path: <netdev+bounces-7651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3A172100A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82877281A4F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 12:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644D5C2CC;
	Sat,  3 Jun 2023 12:16:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582802F5F
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 12:16:58 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2635712E;
	Sat,  3 Jun 2023 05:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685794562; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Xvqiw3yzscwdOuNEZuj9bk1qgagVIpEYpQq1Zly/oUG0ooMHU2QKajWc0lOwmj8HMCU5lIsJUUwIyuPtj4qcrIs+ntb1+txujpq93n8GL6PTlpJsaqCtJLAcyIDYf+ptjnwJw3sS+RX+nMpaCPMPgNDDUR7U2txU4bUP5OsjSfM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685794562; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=WPDeeRYKsXgzNnD2TDmyh/FFUdtpjXLTBrqxtvSxcRY=; 
	b=U4GSADPf72TR4tfXTES0TsH7bL4SqezL4JoikTyrRZlGfNGcldX0EAxjDbVRVRzCsr6lzkK430gycCKszCqW1CM2p1GV223VdBQK0ozt9PmM8C4PMccn9aRab1dHo4dy+iwv/0OBrCZxkE0yrcSE8Gwq9mvCsZbQif/aL1uW4R4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685794562;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=WPDeeRYKsXgzNnD2TDmyh/FFUdtpjXLTBrqxtvSxcRY=;
	b=T1kuO19JFzFHPwhRMdNSeL9+StwxDCvVCAZPeOc2iY5EvTGbA6C6d71Kr9aRhEln
	e8o2rv9j6QK4NnlUVE/e5IGDSOjsxsmsIuj9UPHqG1BHTNx/xJ5qc4jKtwrpcjs3E/a
	nCATSvCNdmLnFfku3SzRn6k09h/yomP1Dh+RqdG4=
Received: from [192.168.83.218] (62.74.57.39 [62.74.57.39]) by mx.zohomail.com
	with SMTPS id 1685794561743322.6704321273826; Sat, 3 Jun 2023 05:16:01 -0700 (PDT)
Message-ID: <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
Date: Sat, 3 Jun 2023 15:15:52 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230524175107.hwzygo7p4l4rvawj@skbuf>
 <576f92b0-1900-f6ff-e92d-4b82e3436ea1@arinc9.com>
 <20230526130145.7wg75yoe6ut4na7g@skbuf>
Content-Language: en-US
In-Reply-To: <20230526130145.7wg75yoe6ut4na7g@skbuf>
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

On 26.05.2023 16:01, Vladimir Oltean wrote:
> On Thu, May 25, 2023 at 09:49:58AM +0300, Arınç ÜNAL wrote:
>> On 24.05.2023 20:51, Vladimir Oltean wrote:
>>> On Mon, May 22, 2023 at 03:15:10PM +0300, arinc9.unal@gmail.com wrote:
>>>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>>>> index 710c6622d648..d837aa20968c 100644
>>>> --- a/drivers/net/dsa/mt7530.c
>>>> +++ b/drivers/net/dsa/mt7530.c
>>>> @@ -2728,25 +2722,20 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>>>    			goto unsupported;
>>>>    		break;
>>>>    	case 5: /* Port 5, can be used as a CPU port. */
>>>> -		if (priv->p5_interface == state->interface)
>>>> +		if (priv->p5_configured)
>>>>    			break;
>>>>    		if (mt753x_mac_config(ds, port, mode, state) < 0)
>>>>    			goto unsupported;
>>>> -
>>>> -		if (priv->p5_intf_sel != P5_DISABLED)
>>>> -			priv->p5_interface = state->interface;
>>>
>>> If you don't replace this bit with anything, who will set priv->p5_configured
>>> for mt7530?
>>
>> I intend priv->p5_configured and priv->p6_configured to be only used for
>> MT7531 as I have stated on the mt7530_priv description.
> 
> Ok, but given the premise of this patch set, that phylink is always available,
> does it make sense for mt7531_cpu_port_config() and mt7988_cpu_port_config()
> to manually call phylink methods?

All I know is that that's how the implementation of phylink's PCS 
support in this driver works. It expects the MAC to be set up before 
calling mt753x_phylink_pcs_link_up() and mt753x_phylink_mac_link_up().

Arınç

