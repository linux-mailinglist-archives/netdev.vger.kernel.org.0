Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1733F4C700B
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiB1Ovm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbiB1Ovl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:51:41 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1E770CE1
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 06:51:02 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hw13so25220068ejc.9
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 06:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tSUWg31TLb/DMmDiB+yxa1SKyHnt2XLfrbce8lKX+Js=;
        b=Acb6r1L1m4lYCpnCXB5zOseq25UWW3aGqZEz7UMqgosKV1YWWz7TbJThM+OsAwBNhC
         ik2H/MBg5ds/e/gqtuGfBcmI4Wd/oKafxFi4aTxLmK3w8Y8/UkIg4Ulb20FJjOrNRJee
         Az6Z0OxXWbFUxnDptxNAwJE6EqmztjgYK8z+KKoW18SyCEg/dVvuoaT1KqgPJWx9wIaZ
         LR9eZLR4qCiunIzMfNdYEK2/lIbX1L18kMp6B1PDWyPj7CknjAhpvaRurxbHmM2zpomy
         trmRqMJWEGMaLJ/khDgj2BrWZBe3TgXd7fY9F8zZwIzxcJEE12b0rQCmXfAY6e24Wx6v
         4RwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tSUWg31TLb/DMmDiB+yxa1SKyHnt2XLfrbce8lKX+Js=;
        b=NoDb6RNvvIs67BCpUnVMtM2sbj2A7AnNGgPCsuHFroiiUzcdt+tvHxCm5eRrz9j9nj
         rO/56Qt8i5VgWR8vxNejBvr5sWS1+ul4y5XMf/IerJnyjkStHo2HkEQHqJ/VY21mu4v/
         LcFUynog3Dv8aQ1EIGQg02UZgCQZcdc/8k+g0NoOhU9VbtfELJNSXo8ND66tQKR0ZUtN
         oNKh7rxZyiblReV1atiYBcwxS11Da8ig5zG9iA4ZX8MNK6IxVxbcGhwLa/fWlnUrWBAW
         GSWJ3QOqpt+h7jpIDnqkQQxWHTEvR2OpVG0zzS9RJ5+Z6j1SVeq2nxo0qAEX5QKZ9uP5
         NQBA==
X-Gm-Message-State: AOAM530a5ACAHFTcvUMgkKBRy9UgoBIfQmq1u9RPL+taK0vJvQH227Qz
        R9//qR7P7Ab+zoyWe57J8DI=
X-Google-Smtp-Source: ABdhPJyWCezpKCOfm7KItLun+df6AZQfu5Jcw8Q6qglMRZKP04ALBXGOryCqEPTYabBi424GkRRTzg==
X-Received: by 2002:a17:906:9454:b0:6b5:aa6:2822 with SMTP id z20-20020a170906945400b006b50aa62822mr14910322ejx.619.1646059860753;
        Mon, 28 Feb 2022 06:51:00 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id b22-20020aa7df96000000b0040fb8c4806fsm6050848edy.93.2022.02.28.06.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 06:50:59 -0800 (PST)
Date:   Mon, 28 Feb 2022 16:50:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v4 2/3] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Message-ID: <20220228145058.g6ikbdp32s2rhdgl@skbuf>
References: <20220227035920.19101-1-luizluca@gmail.com>
 <20220227035920.19101-3-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220227035920.19101-3-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 12:59:19AM -0300, Luiz Angelo Daros de Luca wrote:
> Realtek switches supports the same tag both before ethertype or between
> payload and the CRC.
> 
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  include/net/dsa.h    |   2 +
>  net/dsa/tag_rtl8_4.c | 150 +++++++++++++++++++++++++++++++++----------
>  2 files changed, 117 insertions(+), 35 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index fd1f62a6e0a8..b688ced04b0e 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -52,6 +52,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
>  #define DSA_TAG_PROTO_SJA1110_VALUE		23
>  #define DSA_TAG_PROTO_RTL8_4_VALUE		24
> +#define DSA_TAG_PROTO_RTL8_4T_VALUE		25
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -79,6 +80,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
>  	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
>  	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
> +	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
>  };
>  
>  struct dsa_switch;
> diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> index 02686ad4045d..bf34b257b193 100644
> --- a/net/dsa/tag_rtl8_4.c
> +++ b/net/dsa/tag_rtl8_4.c
> @@ -9,11 +9,6 @@
>   *
>   * This tag header has the following format:

If you generalize the comments, then it is no longer a "header".

>   *
> - *  -------------------------------------------
> - *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> - *  -------------------------------------------
> - *     _______________/            \______________________________________
> - *    /                                                                   \
>   *  0                                  7|8                                 15
>   *  |-----------------------------------+-----------------------------------|---
>   *  |                               (16-bit)                                | ^
> @@ -58,6 +53,24 @@
>   *    TX/RX      | TX (switch->CPU): port number the packet was received on
>   *               | RX (CPU->switch): forwarding port mask (if ALLOW=0)
>   *               |                   allowance port mask (if ALLOW=1)
> + *
> + * The tag can be positioned before Ethertype, using tag "rtl8_4":
> + *
> + *  +--------+--------+------------+------+-----
> + *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> + *  +--------+--------+------------+------+-----
> + *
> + * The tag can also appear between the end of the payload and before the CRC,
> + * using tag "rtl8_4t":
> + *
> + * +--------+--------+------+-----+---------+------------+-----+
> + * | MAC DA | MAC SA | TYPE | ... | payload | 8-byte tag | CRC |
> + * +--------+--------+------+-----+---------+------------+-----+
> + *
> + * The added bytes after the payload will break most checksums, either in
> + * software or hardware. To avoid this issue, if the checksum is still pending,
> + * this tagger checksum the packet in software before adding the tag.

s/checksum/checksums/

> + *
>   */
>  
>  #include <linux/bitfield.h>
> @@ -84,87 +97,133 @@
>  #define RTL8_4_TX			GENMASK(3, 0)
>  #define RTL8_4_RX			GENMASK(10, 0)
>  
> -static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> -				       struct net_device *dev)
> +static void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *dev,
> +			     void *tag)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	__be16 *tag;
> -
> -	skb_push(skb, RTL8_4_TAG_LEN);
> -
> -	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> -	tag = dsa_etype_header_pos_tx(skb);
> +	__be16 tag16[RTL8_4_TAG_LEN / 2];
>  
>  	/* Set Realtek EtherType */
> -	tag[0] = htons(ETH_P_REALTEK);
> +	tag16[0] = htons(ETH_P_REALTEK);
>  
>  	/* Set Protocol; zero REASON */
> -	tag[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
> +	tag16[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
>  
>  	/* Zero FID_EN, FID, PRI_EN, PRI, KEEP; set LEARN_DIS */
> -	tag[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> +	tag16[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
>  
>  	/* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
> -	tag[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> +	tag16[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> +
> +	memcpy(tag, tag16, RTL8_4_TAG_LEN);
> +}
> +
> +static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	skb_push(skb, RTL8_4_TAG_LEN);
> +
> +	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> +
> +	rtl8_4_write_tag(skb, dev, dsa_etype_header_pos_tx(skb));
>  
>  	return skb;
>  }
>  
> -static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> -				      struct net_device *dev)
> +static struct sk_buff *rtl8_4t_tag_xmit(struct sk_buff *skb,
> +					struct net_device *dev)
> +{
> +	/* Calculate the checksum here if not done yet as trailing tags will
> +	 * break either software and hardware based checksum

"either" is typically used with "or", not with "and"

> +	 */
> +	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
> +		return NULL;
> +
> +	rtl8_4_write_tag(skb, dev, skb_put(skb, RTL8_4_TAG_LEN));
> +
> +	return skb;
> +}
> +
> +static int rtl8_4_read_tag(struct sk_buff *skb, struct net_device *dev,
> +			   void *tag)
>  {
> -	__be16 *tag;
> +	__be16 tag16[RTL8_4_TAG_LEN / 2];
>  	u16 etype;
>  	u8 reason;
>  	u8 proto;
>  	u8 port;
>  
> -	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> -		return NULL;
> -
> -	tag = dsa_etype_header_pos_rx(skb);
> +	memcpy(tag16, tag, RTL8_4_TAG_LEN);
>  
>  	/* Parse Realtek EtherType */
> -	etype = ntohs(tag[0]);
> +	etype = ntohs(tag16[0]);
>  	if (unlikely(etype != ETH_P_REALTEK)) {
>  		dev_warn_ratelimited(&dev->dev,
>  				     "non-realtek ethertype 0x%04x\n", etype);
> -		return NULL;
> +		return -EPROTO;
>  	}
>  
>  	/* Parse Protocol */
> -	proto = FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag[1]));
> +	proto = FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag16[1]));
>  	if (unlikely(proto != RTL8_4_PROTOCOL_RTL8365MB)) {
>  		dev_warn_ratelimited(&dev->dev,
>  				     "unknown realtek protocol 0x%02x\n",
>  				     proto);
> -		return NULL;
> +		return -EPROTO;
>  	}
>  
>  	/* Parse REASON */
> -	reason = FIELD_GET(RTL8_4_REASON, ntohs(tag[1]));
> +	reason = FIELD_GET(RTL8_4_REASON, ntohs(tag16[1]));
>  
>  	/* Parse TX (switch->CPU) */
> -	port = FIELD_GET(RTL8_4_TX, ntohs(tag[3]));
> +	port = FIELD_GET(RTL8_4_TX, ntohs(tag16[3]));
>  	skb->dev = dsa_master_find_slave(dev, 0, port);
>  	if (!skb->dev) {
>  		dev_warn_ratelimited(&dev->dev,
>  				     "could not find slave for port %d\n",
>  				     port);
> -		return NULL;
> +		return -ENOENT;
>  	}
>  
> +	if (reason != RTL8_4_REASON_TRAP)
> +		dsa_default_offload_fwd_mark(skb);
> +
> +	return 0;
> +}
> +
> +static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> +				      struct net_device *dev)
> +{
> +	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> +		return NULL;
> +
> +	if (unlikely(rtl8_4_read_tag(skb, dev, dsa_etype_header_pos_rx(skb))))
> +		return NULL;
> +
>  	/* Remove tag and recalculate checksum */
>  	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
>  
>  	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
>  
> -	if (reason != RTL8_4_REASON_TRAP)
> -		dsa_default_offload_fwd_mark(skb);
> +	return skb;
> +}
> +
> +static struct sk_buff *rtl8_4t_tag_rcv(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	if (skb_linearize(skb))
> +		return NULL;
> +
> +	if (unlikely(rtl8_4_read_tag(skb, dev, skb_tail_pointer(skb) - RTL8_4_TAG_LEN)))
> +		return NULL;
> +
> +	if (pskb_trim_rcsum(skb, skb->len - RTL8_4_TAG_LEN))
> +		return NULL;
>  
>  	return skb;
>  }
>  
> +/* Ethertype version */
>  static const struct dsa_device_ops rtl8_4_netdev_ops = {
>  	.name = "rtl8_4",
>  	.proto = DSA_TAG_PROTO_RTL8_4,
> @@ -172,7 +231,28 @@ static const struct dsa_device_ops rtl8_4_netdev_ops = {
>  	.rcv = rtl8_4_tag_rcv,
>  	.needed_headroom = RTL8_4_TAG_LEN,
>  };
> -module_dsa_tag_driver(rtl8_4_netdev_ops);
>  
> -MODULE_LICENSE("GPL");
> +DSA_TAG_DRIVER(rtl8_4_netdev_ops);
> +
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
> +
> +/* Tail version */
> +static const struct dsa_device_ops rtl8_4t_netdev_ops = {
> +	.name = "rtl8_4t",
> +	.proto = DSA_TAG_PROTO_RTL8_4T,
> +	.xmit = rtl8_4t_tag_xmit,
> +	.rcv = rtl8_4t_tag_rcv,
> +	.needed_tailroom = RTL8_4_TAG_LEN,
> +};
> +
> +DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
> +
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
> +
> +static struct dsa_tag_driver *dsa_tag_drivers[] = {
> +	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
> +	&DSA_TAG_DRIVER_NAME(rtl8_4t_netdev_ops),
> +};
> +module_dsa_tag_drivers(dsa_tag_drivers);
> +
> +MODULE_LICENSE("GPL");
> -- 
> 2.35.1
> 
