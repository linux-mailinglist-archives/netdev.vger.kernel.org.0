Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBD24AFF91
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiBIV5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbiBIV5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:17 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEBDE00ED56
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:15 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id fj5so8016632ejc.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 13:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AtfzzCTTupOI6tT/gdCLhu3IHQi+3cqCi5QXJsaDmOs=;
        b=EOhL31K2lt/uf2eaTm4+kK5vE7y7GvhqWr12ZvAom5nV1QTyjyClfAtVZiqTuYBJjd
         bXiF9LaUQqTeifJ4n07t9alT39TxuJg/v5pWxkxkIYrZ/x/cu791V9llSOWejfb+/6Rw
         YD5QTbwcRdTI84qV/PdCdHoAmYLFkQSRTQbIkrtujdQmAWahUCrLeP4PRQF9nwFg4A6H
         scZpqInGGHckfSDZANdB9eAwyb6xwgSOL+InHmuESG0rdacWOgRPi80BDYrn0efazrrl
         dXiEwWCysiiTHjglzcFoYCNdyYWiLacNaKOiZKJwBeEtNuq9rvtRui4Nub7thJHtFnIz
         avdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AtfzzCTTupOI6tT/gdCLhu3IHQi+3cqCi5QXJsaDmOs=;
        b=Yur7DPhK6/MZJpxe4u0ugOUjpA/ZjXvcQ1VUpV07AInpbSoxrUSBKBl0J9tJfATQeA
         5oRp+ttivHssuYNauK5TLwKyM1agQJ1kA4VPNQp81HShU/YTm5mkeOVW3pczEwfk/eyG
         L9NOhmB39cshvSwqYyxl7rJQY8D5cm+tYRkkY7CX/lAGGDl9sAlOU/ipzGNelwHuYvX/
         DJap1uXMhgvz4kxkqbt9iwl6YVp2KKb9xgKGx1Od6qNrt7yX5wZUSZle5c7Sf7sYvuiR
         QbUWQfwqLm8jcXv0zDYSjNXG+oOSLH+Pk+sapkFI3D/urc0r7laRsKfVTcB/RYI1RqVD
         gH4g==
X-Gm-Message-State: AOAM530mUjUSlqkiDfDc6zx6vtijFz2xHxXhS/fexJA1+F+yKPM4tGIF
        t6yT9JR+Ey/M+XBBcXC+rSo=
X-Google-Smtp-Source: ABdhPJwQ/mLtj94Gcl+h48yHSkFXdk3sCX4/YJjFn2fyxo5K3s92YP/b8VbAWexTg9vasFVqLMpglg==
X-Received: by 2002:a17:907:60cb:: with SMTP id hv11mr3792438ejc.122.1644443833930;
        Wed, 09 Feb 2022 13:57:13 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id h16sm6433743ejj.56.2022.02.09.13.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:57:13 -0800 (PST)
Date:   Wed, 9 Feb 2022 23:57:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: add support
 for rtl8_4t
Message-ID: <20220209215712.tqytk6nosui7b2iu@skbuf>
References: <20220209211312.7242-1-luizluca@gmail.com>
 <20220209211312.7242-3-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209211312.7242-3-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 06:13:12PM -0300, Luiz Angelo Daros de Luca wrote:
> The tailing tag is also supported by this family. The default is still
> rtl8_4 but now the switch supports changing the tag to rtl8_4t.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 63 +++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index e0c7f64bc56f..02d1521887ae 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -853,9 +853,70 @@ static enum dsa_tag_protocol
>  rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
>  			   enum dsa_tag_protocol mp)
>  {
> +	struct realtek_priv *priv = ds->priv;
> +	u32 val;
> +
> +	/* No way to return error */
> +	regmap_read(priv->map, RTL8365MB_CPU_CTRL_REG, &val);
> +
> +	switch (FIELD_GET(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, val)) {
> +	case RTL8365MB_CPU_FORMAT_4BYTES:
> +		/* Similar to DSA_TAG_PROTO_RTL4_A but with 1-byte version
> +		 * To CPU: [0x88 0x99 0x04 portnum]. Not supported yet.
> +		 */
> +		break;
> +	case RTL8365MB_CPU_FORMAT_8BYTES:
> +		switch (FIELD_GET(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, val)) {
> +		case RTL8365MB_CPU_POS_BEFORE_CRC:
> +			return DSA_TAG_PROTO_RTL8_4T;
> +		case RTL8365MB_CPU_POS_AFTER_SA:
> +		default:
> +			return DSA_TAG_PROTO_RTL8_4;
> +		}
> +		break;
> +	}
> +
>  	return DSA_TAG_PROTO_RTL8_4;

Not great. dsa_get_tag_protocol gets called from dsa_port_parse_cpu,
which is earlier than rtl8365mb_cpu_config, so you may temporarily
report a tagging protocol which you don't expect (depending on what is
in hardware at the time). Can you not keep the current tagging protocol
in a variable? You could then avoid the need to return an error on
regmap_read too.

>  }
>  
> +static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu,
> +					 enum dsa_tag_protocol proto)
> +{
> +	struct realtek_priv *priv = ds->priv;
> +	int tag_position;
> +	int tag_format;
> +	int ret;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_RTL8_4:
> +		tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
> +		tag_position = RTL8365MB_CPU_POS_AFTER_SA;
> +		break;
> +	case DSA_TAG_PROTO_RTL8_4T:
> +		tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
> +		tag_position = RTL8365MB_CPU_POS_BEFORE_CRC;
> +		break;
> +	/* The switch also supports a 4-byte format, similar to rtl4a but with
> +	 * the same 0x04 8-bit version and probably 8-bit port source/dest.
> +	 * There is no public doc about it. Not supported yet.
> +	 */
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
> +				 RTL8365MB_CPU_CTRL_TAG_POSITION_MASK |
> +				 RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
> +				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK,
> +					    tag_position) |
> +				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
> +					    tag_format));
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
>  static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
>  				      phy_interface_t interface)
>  {
> @@ -2079,6 +2140,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>  
>  static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
>  	.get_tag_protocol = rtl8365mb_get_tag_protocol,
> +	.change_tag_protocol = rtl8365mb_change_tag_protocol,
>  	.setup = rtl8365mb_setup,
>  	.teardown = rtl8365mb_teardown,
>  	.phylink_get_caps = rtl8365mb_phylink_get_caps,
> @@ -2097,6 +2159,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
>  
>  static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
>  	.get_tag_protocol = rtl8365mb_get_tag_protocol,
> +	.change_tag_protocol = rtl8365mb_change_tag_protocol,
>  	.setup = rtl8365mb_setup,
>  	.teardown = rtl8365mb_teardown,
>  	.phylink_get_caps = rtl8365mb_phylink_get_caps,
> -- 
> 2.35.1
> 

