Return-Path: <netdev+bounces-7785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CE37217DF
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 993101C20991
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13094D524;
	Sun,  4 Jun 2023 14:43:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0294C23A5
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 14:43:28 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C5E18E
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:43:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-977c8423dccso213240666b.1
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 07:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685889781; x=1688481781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzPaAbjiwUgiiseLRq82xmrHe1oI+Dk2/aHhvA6JMrk=;
        b=Q0Pe6y0Vf4BJPZmgRCYrk6l15F4GVQ8JedOaTuX9rQwt4yZd2FM79EWv88zL2pOa/b
         1MqbguMtO1VHwIQc75AWVkqo3gbDdHpxflmvLvNvERyH293UiBmS9o9xfhiR83pK96YK
         Yj1Hx5Ql2f+a1G41NsolK5QQJvgaVDvK/kYKCsJ4/dBir2S5Q9UFa16Ec39bxYJ59Fwi
         ZFVI1cozM966XECD5pKVR2AhLdpzrG0GSma4gjg663uSYK8cIzNNu+5Ob8EnI/dAI1Ub
         Q7pfKnR3MrWaF43yzaBKR6cSeuqifDNX+tVXA5b8pj38TbCitzZjcbMw1XxnBNdM+suP
         CJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685889781; x=1688481781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gzPaAbjiwUgiiseLRq82xmrHe1oI+Dk2/aHhvA6JMrk=;
        b=YfCLFbQIBwHJosy5e+8OhNEKkMKlDl7c6tLvpQ+N0bg7bU+gojVZKOqhwMgS3i0RqK
         bWCsGVCwmV/1JXcpcGBZhKktS1CKdrrwbgSv5BFYlihGGlO2B+0XR3jlBDj7akpc0RgA
         gR4zA6s2J9gXaJEUdH6MrrCGMpv3ZFbCBM4lTphk6Kcp6CIYBVa+OHoEKcusK7fRSxxe
         RM5AmJEtjodMyF5OjWfCpv3YI+DMItV2OZoogY4Ah4zA0nzo/w3dkDFAMch9MFsu9rmE
         k/m0x6cQip6s1G4MQNcbtwnfMR2yoOoHgdOYuXKWCzo4Ode9sciT2bVae1M2a/F9J7h6
         W8Uw==
X-Gm-Message-State: AC+VfDy0M4wH4DUsC98PcIU6QKrlEINvxQeLU+uoTCfZBli2ORWBf5y7
	1XqVOZk/mv7se22HazgT1W4=
X-Google-Smtp-Source: ACHHUZ6oa0d3sgemcUjFQ9eqXWbllkYPbd+dVZ2k4WHDaOWYlM3KL2tpmOn7GwYoleu49HUUFbSfAA==
X-Received: by 2002:a17:907:9709:b0:977:cc4b:eeb1 with SMTP id jg9-20020a170907970900b00977cc4beeb1mr2208177ejc.19.1685889780217;
        Sun, 04 Jun 2023 07:43:00 -0700 (PDT)
Received: from shift.daheim (p4fd09d7d.dip0.t-ipconnect.de. [79.208.157.125])
        by smtp.gmail.com with ESMTPSA id jp25-20020a170906f75900b0096f675ce45csm3109306ejb.182.2023.06.04.07.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 07:42:59 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.96)
	(envelope-from <chunkeey@gmail.com>)
	id 1q5owc-001K93-2Z;
	Sun, 04 Jun 2023 16:42:58 +0200
Message-ID: <7111d194-3dde-d139-a405-5997ea729dc1@gmail.com>
Date: Sun, 4 Jun 2023 16:42:58 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1] net: dsa: realtek: rtl8365mb: use mdio passthrough to
 access PHYs
Content-Language: de-DE
To: =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "luizluca@gmail.com" <luizluca@gmail.com>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "andrew@lunn.ch" <andrew@lunn.ch>, "olteanv@gmail.com" <olteanv@gmail.com>,
 "f.fainelli@gmail.com" <f.fainelli@gmail.com>
References: <0df383e20e5a90494e3cbd0cf23c508c5c943ab4.1685725191.git.chunkeey@gmail.com>
 <lhzfruwpfpern22sadwtkhgqtgaindqbwsbt7w3qbh6i6swcls@ydl7hh2pcwf5>
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <lhzfruwpfpern22sadwtkhgqtgaindqbwsbt7w3qbh6i6swcls@ydl7hh2pcwf5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/4/23 14:03, Alvin Šipraga wrote:
> On Fri, Jun 02, 2023 at 07:02:31PM +0200, Christian Lamparter wrote:
>> when bringing up the PHYs on a Netgear WNDAP660, I observed that
>> none of the PHYs are getting enumerated and the rtl8365mb fails
>> to load.
>>
>> | realtek-mdio [...] lan1 (unini...): validation of gmii with support \
>> |   0...,0.,..6280 and advertisement 0...,0...,6280 failed: -EINVAL
>> | realtek-mdio [...] lan1 (uninit...): failed to connect to PHY: -EINVAL
>> | realtek-mdio [...] lan1 (uninit...): error -22 setting up PHY for
>> |   tree 0, switch 0, port 0
>>
>> with phytool, all registers just returned "0000".
>>
>> Now, the same behavior was present with the swconfig version of
>> rtl8637b.c and in the device's uboot the "mii" register access
>> utility also reports bogus values.
> 
> Not really relevant...

Oh, maybe I should be blunt here. This is the first time that I
got proper mii values for this RTL8363. This is revevant, because
in u-boot the vendor (Netgear) usually takes care of the "mii" tool.

But this wasn't the case here, I'm not sure if this RTL8363SB is
an odd-ball or not. This patch was meant for discussion, if the
discussion is fruitful, I fully expect to do a v2..v3 with the
information that was gathered during review.

>>
>> The Netgear WNDAP660 might be somewhat special, since the RTL8363SB
>> uses exclusive MDC/MDIO-access (instead of SMI). (And the RTL8363SB
>> is not part of the supported list of this driver).
> 
> We had other MDIO switches with support added, so I don't think it's unique.
> 
>>
>> Since this was all hopeless, I dug up some datasheet when searching
>> for solutions:
>> "10/100M & 10/100/1000M Switch Controller Programming Guide".
>> It had an interesting passage that pointed to a magical
>> MDC_MDIO_OPERATION define which resulted in different slave PHY
>> access for the MDIO than it was implemented for SMI.
> 
> Got a reference? I do not see MDC_MDIO_OPERATION in your patch.

Oh, I overwrote the current rtl8365mb_dsa_phy_write and
rtl8365mb_mdio_phy_read to match what's I found in ASUS WRT's codebase.
 From what I gathered, this mdc-mdio was tested/developped with an RT-AC88U.
So I think you all are no stranger to the ASUSWRT Merlin Project @
https://www.asuswrt-merlin.net/. Thankfully they have a link to their
github and provide the realtek source code which includes the phy
access routines in:

https://github.com/RMerl/asuswrt-merlin.ng/blob/master/release/src-rt-6.x.4708/linux/linux-2.6.36/drivers/char/rtl8365mb/rtl8367c_asicdrv_phy.c

as rtl8367c_setAsicPHYReg and rtl8367c_getAsicPHYReg. (look in line 21 for
the #if defined(MDC_MDIO_OPERATION) until the #else 188). These two are
what I implemented in rtl8365mb_mdio_phy_write and rtl8365mb_mdio_phy_read.

>>
>> With this implemented, the RTL8363SB PHYs came to live:
>>
>> | [...]: found an RTL8363SB-CG switch
>> | [...]: missing child interrupt-controller node
>> | [...]: no interrupt support
>> | [...]: configuring for fixed/rgmii link mode
>> | [...] lan1 (uninit...): PHY [dsa-0.0:01] driver [Generic PHY] (irq=POLL)
>> | [...] lan2 (uninit...): PHY [dsa-0.0:02] driver [Generic PHY] (irq=POLL)
>> | device eth0 entered promiscuous mode
>> | DSA: tree 0 setup
>> | realtek-mdio 4ef600c00.ethernet:00: Link is Up - 1Gbps/Full - [...]
>>
>> | # phytool lan1/2
>> | ieee-phy: id:0x001cc980 <--- this is correct!!
>> |
>> |  ieee-phy: reg:BMCR(0x00) val:0x1140
>> |     flags:          -reset -loopback +aneg-enable -power-down
>> |		      -isolate -aneg-restart -collision-test
>> |     speed:          1000-full
>> |
>> |  ieee-phy: reg:BMSR(0x01) val:0x7969
>> |     capabilities:   -100-b4 +100-f +100-h +10-f +10-h -100-t2-f
>> |		      -100-t2-h
>> |      flags:         +ext-status +aneg-complete -remote-fault
>> |		      +aneg-capable -link -jabber +ext-register
>>
>> the port statistics are working too and the exported LED triggers.
>> But so far I can't get any traffic to pass.
> 
> This info is also not entirely relevant in a commit message, but thanks for
> clarifying.

True :) and it was a pain to format. Still I'm hoping to get confirmation
about 0x001cc980-ish PHYID. This is something all switches should produce and
this should be repoduceable by others (with slightly different IDs).
The source for the phytool: https://github.com/wkz/phytool )

>> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
>> ---
>> Any good hints or comments? Is the RTL8363SB an odd one here and
>> everybody else can just use SMI?
> 
> Luiz implemented MDIO support presumably because he could not use SMI. I think
> at the very least, he or somebody else should test your patch on all existing
> MDIO-wired chips supported by the driver. Since this could cause regressions. If
> that is not possible but you would still like to support your new switch, maybe
> we need both implementations available.

Yes, I'm fully expecting these comments.

> 
> Regarding your patch, I do not fully understand it. I think you could perhaps
> explain it a little more clearly. Basically I see that you are provisioning the
> GPHY_OCP_MSB_0_REG a little bit differently, and then executing a register read
> at some particular offset. Contrast this with the current indirect access
> command register followed by polling. I think yours is a better approach, since
> it is more direct, but only if it works and is well documented.

There are sadly the only useful comment in the vendor driver is "Default OCP Address"
with the associated 0x29 "Magic value". This 0x29 becomes 0xA400 if you put it through
the FIELD_PREP... And funnily enough, that exactly matches the existing
"RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE" which is used by the current accessors (but they
do much much more).

It looks like the person that wrote the rtl8365mb_phy_ocp_read and
rtl8365mb_phy_ocp_write() could answer in detail what's behind this.
I'm sure this would be on a datasheet, but sadly I don't have one for the switch.

> Perhaps you can give a pointer to which logic in the vendor driver you followed
> in order to achieve this more direct register access without polling. This will
> help me review it :)
> 
> But since you still haven't got data through your switch, I am a bit reluctant
> to approve this kind of change. I would prefer to see a full series adding the
> support, so that this kind of change/quirk is justfieid. Otherwise it is just
> introducing potential regressions with no real benefit. I hope you understand.

Oh, this is no longer the case. I have it sort of working now. The "no traffic"
issue was "fixed" by the second patch
"net: dsa: realtek: rtl8365mb: add missing case for digital interface 0".

Though, It's not 100% finished. "Normal data" works, but it seems the switch
doesn't like that I have multiple other VLANs on the same network (including
non-vlan traffic). I see a constant stream of "non-realtek ethertype ..."
message from tag_rtl8_4.c. These include 802.1Q (0x8100) EtherTypes,
IPv4 (0x0800) and IPv6 (86DD)). Though, I'm optimistic that this can be solved.

>>
>> So far, I'm just reusing the existing jam tables. rtl8367b.c jam
>> tables ones don't help with getting "traffic". There are also the
>> phy_read in realtek_ops, but it doesn't look like realtek-mdio.c
>> is using those? So I left them as is.
> 
> Just fyi, the jam table is a bit of a fudge and might not be correct for all
> switches. It's basically a blob lifted from the vendor driver. It should
> probably be revisited and open-coded so that a human can read it. But I don't
> mean to imply that this is why you don't get data through your switch.

Yes, the provided jam_tables are enough to get the switch "online".
Thing is, I tried openwrt's rtl8367b.c tables too. But didn't notice any
difference. (The WNDAP660 isn't capable of "saturating" the 1 Gbit/s.
So, it's unlikely that I can trigger any performance related bugs by
simply flooding it.

Regards,
Christian

> 
>> ---
>>   drivers/net/dsa/realtek/rtl8365mb.c | 78 +++++++++++++++++++++++++++--
>>   1 file changed, 74 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
>> index 41ea3b5a42b1..6c00e6dcb193 100644
>> --- a/drivers/net/dsa/realtek/rtl8365mb.c
>> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
>> @@ -825,15 +825,85 @@ static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regnum,
>>   	return 0;
>>   }
>>   
>> +static int rtl8365mb_mdio_phy_read(struct realtek_priv *priv, int phy, int regnum)
>> +{
>> +	unsigned int val, addr;
>> +	int ret;
>> +
>> +	if (phy > RTL8365MB_PHYADDRMAX)
>> +		return -EINVAL;
>> +
>> +	if (regnum > RTL8365MB_PHYREGMAX)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&priv->map_lock);
>> +	ret = regmap_update_bits(priv->map_nolock, RTL8365MB_GPHY_OCP_MSB_0_REG,
>> +				 RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK, /* 0xA40 */
>> +				 FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
>> +					    FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK,
>> +						      RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE)));
>> +	if (ret) {
>> +		mutex_unlock(&priv->map_lock);
>> +		return ret;
>> +	}
>> +
>> +	addr = RTL8365MB_PHY_BASE |
>> +	       FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK, phy) |
>> +	       regnum;
>> +	ret = regmap_read(priv->map_nolock, addr, &val);
>> +	mutex_unlock(&priv->map_lock);
>> +	if (ret)
>> +		return ret;
>> +
>> +	dev_dbg(priv->dev, "read PHY%d register 0x%02x, val <- %04x\n",
>> +		phy, regnum, val);
>> +
>> +	return val & 0xFFFF;
>> +}
>> +
>> +static int rtl8365mb_mdio_phy_write(struct realtek_priv *priv, int phy, int regnum,
>> +				    u16 val)
>> +{
>> +	unsigned int addr;
>> +	int ret;
>> +
>> +	if (phy > RTL8365MB_PHYADDRMAX)
>> +		return -EINVAL;
>> +
>> +	if (regnum > RTL8365MB_PHYREGMAX)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&priv->map_lock);
>> +	ret = regmap_update_bits(priv->map_nolock, RTL8365MB_GPHY_OCP_MSB_0_REG,
>> +				 RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
>> +				 FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
>> +					    FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK,
>> +						      RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE)));
>> +	if (ret) {
>> +		mutex_unlock(&priv->map_lock);
>> +		return ret;
>> +	}
>> +
>> +	addr = RTL8365MB_PHY_BASE |
>> +	       FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK, phy) |
>> +	       regnum;
>> +	ret = regmap_write(priv->map_nolock, addr, val);
>> +	mutex_unlock(&priv->map_lock);
>> +
>> +	dev_dbg(priv->dev, "write (%d) PHY%d register 0x%02x val -> %04x\n",
>> +		ret, phy, regnum, val);
>> +
>> +	return ret;
>> +}
>> +
>>   static int rtl8365mb_dsa_phy_read(struct dsa_switch *ds, int phy, int regnum)
>>   {
>> -	return rtl8365mb_phy_read(ds->priv, phy, regnum);
>> +	return rtl8365mb_mdio_phy_read(ds->priv, phy, regnum);
>>   }
>>   
>> -static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum,
>> -				   u16 val)
>> +static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum, u16 val)
>>   {
>> -	return rtl8365mb_phy_write(ds->priv, phy, regnum, val);
>> +	return rtl8365mb_mdio_phy_write(ds->priv, phy, regnum, val);
>>   }
>>   
>>   static const struct rtl8365mb_extint *
>> -- 
>> 2.40.1
>>


