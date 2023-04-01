Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42F6D2F20
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 10:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDAI5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 04:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDAI5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 04:57:39 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843811BF50;
        Sat,  1 Apr 2023 01:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680339412; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=VdYkSYR5RmNZ+RWaNQDfOuZUU8qUC7/+xgHXVfO9ZEReDTtHM/MXXHZtb7W4vpQGVo4qZWTnChv9cW4lnRhaLCzW/Euten6jw2BRzCM0orAC4nnL5HQa0zFuJcJv1RFAXAYzj1L/evM6PabtFNzqO5yX96b/dQwjUZ7Xai9MpG8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680339412; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/iWeKdrBOSA19S1rC727IKvEokvMFX7GotTXt2f+now=; 
        b=GHjXRDsSxQKcA4thF7mvUqYaQ3GoM5tH2tRQfiPoMCXBpk9d+SEDppCmmvWTSaD7/hWbcTcKqxpBe01MaFr2jLfbxBdMFdVinknEoadyLYg6f4u8nGEbxwZQxN8q3mm2aykTtzftSvuiVj1JQqrDyvZxFyi27cgv9yRW2GGvf38=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680339412;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=/iWeKdrBOSA19S1rC727IKvEokvMFX7GotTXt2f+now=;
        b=Rw2n6rbevRoohK/cskTFbaONKfppeEOsXaQX2qb0B5SSunxs06rlQGFsMsjMh53e
        422jiScYdq2/v73Hb4aeF8UAdIa+qQgac6F4NvtFWPuFtMqbN3RMEKwL8+bcQn6RkHH
        PJ9nB4Xgh0g72NPLuY/38xgbyM/9RNLzXIVpDfIc=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680339410626354.00740361215094; Sat, 1 Apr 2023 01:56:50 -0700 (PDT)
Message-ID: <8f213456-af0b-3047-d7ec-865fecec8142@arinc9.com>
Date:   Sat, 1 Apr 2023 11:56:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 13/15] net: dsa: mt7530: add support for 10G link
 modes for CPU port
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <89ef48606fdbe896705a57a65a85c22cae01936e.1680180959.git.daniel@makrotopia.org>
Content-Language: en-US
In-Reply-To: <89ef48606fdbe896705a57a65a85c22cae01936e.1680180959.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.2023 18:23, Daniel Golle wrote:
> The built-in switch of the MT7988 SoC is internally connected using
> a stateless 10G link. Add support for 10G interface modes to silence
> a warning otherwise occurring when the switch driver is setup.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>   drivers/net/dsa/mt7530.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 3a4682e71e746..ac666da2d10dc 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2618,6 +2618,9 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>   	case PHY_INTERFACE_MODE_1000BASEX:
>   	case PHY_INTERFACE_MODE_2500BASEX:
>   		/* handled in SGMII PCS driver */
> +	case PHY_INTERFACE_MODE_USXGMII:
> +	case PHY_INTERFACE_MODE_10GKR:
> +		/* internal stateless 10G link */
>   		return 0;
>   	default:
>   		return -EINVAL;

I think it'd be better to make this explicitly for the switch in the
MT7988 SoC.

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e5347dd2521b..f7542c7f60e4 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2666,10 +2665,13 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
  	case PHY_INTERFACE_MODE_1000BASEX:
  	case PHY_INTERFACE_MODE_2500BASEX:
  		/* handled in SGMII PCS driver */
+		return 0;
  	case PHY_INTERFACE_MODE_USXGMII:
  	case PHY_INTERFACE_MODE_10GKR:
-		/* internal stateless 10G link */
-		return 0;
+		if (priv->id == ID_MT7988)
+			/* internal stateless 10G link */
+			return 0;
+
  	default:
  		return -EINVAL;
  	}

Arınç
