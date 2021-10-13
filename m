Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C026D42BBE4
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbhJMJr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbhJMJr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:47:28 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AECC061570;
        Wed, 13 Oct 2021 02:45:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y4so1461441plb.0;
        Wed, 13 Oct 2021 02:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=BrKCJQFvwmk9+F3h85qO7G0CpIYqsgeNh2/UOTqHtB0=;
        b=hOZ/1ug+uWEL5wGHqeSrmICYb/uXdo76aPrf4VXriFjr9uI5jDgelEc4392bmBQNBc
         2ld6Ex+6FcpFH9fpdbmS3i85qaB+dDUkoo1meux9a5Uc3TQ/XSTvCoxtKad4FbH18BkL
         x8y1KOFBr8XX46dD3wPuGx1UfHIQLZr4RVCKI3FaFGU6RbgLt89GH2DbbgXAPw2jsVoA
         XmTP57HpNwmKztE8pjbHxfhR+t7Z86c6vparKLrrKh/2e9P+R+8kUteutq3O7fXmD2qa
         PffTIrIL6GW9oJKIX2JvINFbDi75J1bScwysyiLQ2IRsYcpSZ520z8Ywceaz8IIa8sJS
         RS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=BrKCJQFvwmk9+F3h85qO7G0CpIYqsgeNh2/UOTqHtB0=;
        b=jitrSdU/+2K+x/LMVSuqBBCZ3LE93uLnFcUZdWFtEs/dMzAgNvEYwA2SkAn6zmoBKd
         5h0dWe+whbnYlZcB2j9OBAs/Zi+/yFyAmLr4ufLR9twRtqj2fDADH2DHw6Y1+RIidxx4
         +zBrAaeu4WPsPbe0gpMNeKYpxmJ16PjSWGTEL4AE5o5RROLr1ZnhnIl8Kp7JsssU5ARq
         lvHddf7J9LPaKqw6/pM9g/XSDTtbrE2bVai35DapAf9S8QmVVW+Emr3ozv0QATbyyt53
         r32/Nx8mmQNZHDmyydaGmd2MoLgYQc+44Ly7n1nNz3gt2qLzC7YBPMH3Ez1ijQpZqKHt
         b+Sg==
X-Gm-Message-State: AOAM531FKLG6ttLe/t2vNWAwQHCv5xFXDnNpQ7asaR87V0/NXTu3BYUu
        jY3r6nBlaQHP36Z/mHVaSqc=
X-Google-Smtp-Source: ABdhPJw54hhYIcb8lsEv9DNL8xE12ewqKSmB4EmktPnxSj3bs1PiKIazqN62kFvB6TR7Bcm/WEbLPw==
X-Received: by 2002:a17:902:9b8d:b0:13e:b693:c23d with SMTP id y13-20020a1709029b8d00b0013eb693c23dmr34650917plp.11.1634118325231;
        Wed, 13 Oct 2021 02:45:25 -0700 (PDT)
Received: from localhost.localdomain ([171.211.26.24])
        by smtp.gmail.com with ESMTPSA id t125sm3813868pfc.119.2021.10.13.02.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 02:45:24 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
Date:   Wed, 13 Oct 2021 17:45:16 +0800
Message-Id: <20211013094516.55722-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012123557.3547280-5-alvin@pqrs.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk> <20211012123557.3547280-5-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 02:35:53PM +0200, Alvin Šipraga wrote:
> +static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> +				      struct net_device *dev)
> +{
> +	__be16 *tag;
> +	u16 etype;
> +	u8 proto;
> +	u8 port;
> +
> +	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> +		return NULL;
> +
> +	tag = dsa_etype_header_pos_rx(skb);
> +
> +	/* Parse Realtek EtherType */
> +	etype = ntohs(tag[0]);
> +	if (unlikely(etype != ETH_P_REALTEK)) {
> +		dev_warn_ratelimited(&dev->dev,
> +				     "non-realtek ethertype 0x%04x\n", etype);
> +		return NULL;
> +	}
> +
> +	/* Parse Protocol */
> +	proto = ntohs(tag[1]) >> 8;
> +	if (unlikely(proto != RTL8_4_PROTOCOL_RTL8365MB)) {
> +		dev_warn_ratelimited(&dev->dev,
> +				     "unknown realtek protocol 0x%02x\n",
> +				     proto);
> +		return NULL;
> +	}
> +
> +	/* Parse TX (switch->CPU) */
> +	port = ntohs(tag[3]) & 0xf; /* Port number is the LSB 4 bits */
> +	skb->dev = dsa_master_find_slave(dev, 0, port);
> +	if (!skb->dev) {
> +		dev_warn_ratelimited(&dev->dev,
> +				     "could not find slave for port %d\n",
> +				     port);
> +		return NULL;
> +	}
> +
> +	/* Remove tag and recalculate checksum */
> +	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
> +
> +	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
> +
> +	dsa_default_offload_fwd_mark(skb);

This should not be set if the REASON is trapped to CPU.

> +
> +	return skb;
> +}
