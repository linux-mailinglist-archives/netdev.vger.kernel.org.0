Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1FA498477
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbiAXQQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbiAXQQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:16:52 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2C7C06173B;
        Mon, 24 Jan 2022 08:16:51 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id jx6so22845325ejb.0;
        Mon, 24 Jan 2022 08:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=hgz8pwLNoIFw5VewISaQVdMjs0FpjEywU/yMtg1Rd4A=;
        b=Rm0xcs9o821/FD00ILIeqW9BAIieqi80Or1MtrM18hCNKTgUIv0DDxr78m/D/h2Z1t
         oJoVFmDsNYI6aFN1lDTXgA5WnUiAJad9McsWGUTwgQ0SbLnKtF5QH6mq/4UHF+G+pO+a
         iYbcyZbxHG8VvDH/SLdzu8t6UN7+qJhn9opNVF2Ik2FafetYvfF3kqwWimx516nZqlEk
         vHi4lL8btBE9MAOBJ9E6ukw7Q5XsovXqxl2wfpdqqNJL/+M2fIFD8IblVR4qfcVcO4r/
         qWOsYOgusuLErUc9a9tHV4G8iscR7W9suK3rGmGUtwQpaXNQQdYOkbKsNX5spCldRvKa
         iBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=hgz8pwLNoIFw5VewISaQVdMjs0FpjEywU/yMtg1Rd4A=;
        b=POR76TOY/YVoRdMSqZ0S0bjGF/T7eYhhSPXsfbGC83P4C7fWzUV0ZgLeEmbRoNKuWJ
         9s5JhAIihZSiZq0o7JkbdOgVcNvma2OFrx7dvx8PdXNIVpaibPLZtqCyZuoIieVtowap
         s032vVoXZmv1+zBT6r+VzBREnA8uHKHi9Q5yUH+H4LJRnVDt7bItid8cWts3D5acs/R1
         v0CFMd8S3/zPGBNyMBtK3vg93OE56rNqa9ihy8+0mmcp8dEtVtlj2BgF+3oKqVZ7QhKP
         tPWEpd1YD9rCmRG4D0D6pnpmi6IlGHBqH0VBnV0NOlJ9k+WCkWlRzb7zg2qyB7+7foVw
         gm5Q==
X-Gm-Message-State: AOAM533JtyFYFxfeUBWi3ftjTpJgU1Z+es3iQ7Hw4DXURWuvfw0E45qA
        CBsR6emkRduI3o5bzXE7pZA=
X-Google-Smtp-Source: ABdhPJwZizppz/HBJH+s92s+L/DAHCwKnLvLLxWfPgqRxxRx9xgqpgtenhFuz14VjCg7HkTSDTm9kg==
X-Received: by 2002:a17:907:7408:: with SMTP id gj8mr5518873ejc.6.1643041010191;
        Mon, 24 Jan 2022 08:16:50 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id t13sm5024704ejs.187.2022.01.24.08.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:16:49 -0800 (PST)
Message-ID: <61eed0f1.1c69fb81.5b7bd.585e@mx.google.com>
X-Google-Original-Message-ID: <Ye7Q7s4FzBzdWaNn@Ansuel-xps.>
Date:   Mon, 24 Jan 2022 17:16:46 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling
 mgmt Ethernet packet
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-7-ansuelsmth@gmail.com>
 <20220124160537.6xqdd337mg43ivn6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124160537.6xqdd337mg43ivn6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 06:05:37PM +0200, Vladimir Oltean wrote:
> On Sun, Jan 23, 2022 at 02:33:27AM +0100, Ansuel Smith wrote:
> > Add all the required define to prepare support for mgmt read/write in
> > Ethernet packet. Any packet of this type has to be dropped as the only
> > use of these special packet is receive ack for an mgmt write request or
> > receive data for an mgmt read request.
> > A struct is used that emulates the Ethernet header but is used for a
> > different purpose.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  include/linux/dsa/tag_qca.h | 44 +++++++++++++++++++++++++++++++++++++
> >  net/dsa/tag_qca.c           | 13 ++++++++---
> >  2 files changed, 54 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> > index c02d2d39ff4a..1a02f695f3a3 100644
> > --- a/include/linux/dsa/tag_qca.h
> > +++ b/include/linux/dsa/tag_qca.h
> > @@ -12,10 +12,54 @@
> >  #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
> >  #define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
> >  
> > +/* Packet type for recv */
> > +#define QCA_HDR_RECV_TYPE_NORMAL	0x0
> > +#define QCA_HDR_RECV_TYPE_MIB		0x1
> > +#define QCA_HDR_RECV_TYPE_RW_REG_ACK	0x2
> > +
> >  #define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
> >  #define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
> >  #define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
> >  #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
> >  #define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
> >  
> > +/* Packet type for xmit */
> > +#define QCA_HDR_XMIT_TYPE_NORMAL	0x0
> > +#define QCA_HDR_XMIT_TYPE_RW_REG	0x1
> > +
> > +/* Check code for a valid mgmt packet. Switch will ignore the packet
> > + * with this wrong.
> > + */
> > +#define QCA_HDR_MGMT_CHECK_CODE_VAL	0x5
> > +
> > +/* Specific define for in-band MDIO read/write with Ethernet packet */
> > +#define QCA_HDR_MGMT_SEQ_LEN		4 /* 4 byte for the seq */
> > +#define QCA_HDR_MGMT_COMMAND_LEN	4 /* 4 byte for the command */
> > +#define QCA_HDR_MGMT_DATA1_LEN		4 /* First 4 byte for the mdio data */
> > +#define QCA_HDR_MGMT_HEADER_LEN		(QCA_HDR_MGMT_SEQ_LEN + \
> > +					QCA_HDR_MGMT_COMMAND_LEN + \
> > +					QCA_HDR_MGMT_DATA1_LEN)
> > +
> > +#define QCA_HDR_MGMT_DATA2_LEN		12 /* Other 12 byte for the mdio data */
> > +#define QCA_HDR_MGMT_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
> > +
> > +#define QCA_HDR_MGMT_PKG_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
> > +					QCA_HDR_LEN + \
> > +					QCA_HDR_MGMT_DATA2_LEN + \
> > +					QCA_HDR_MGMT_PADDING_LEN)
> 
> s/PKG/PKT/
> 
> > +
> > +#define QCA_HDR_MGMT_SEQ_NUM		GENMASK(31, 0)  /* 63, 32 */
> > +#define QCA_HDR_MGMT_CHECK_CODE		GENMASK(31, 29) /* 31, 29 */
> > +#define QCA_HDR_MGMT_CMD		BIT(28)		/* 28 */
> > +#define QCA_HDR_MGMT_LENGTH		GENMASK(23, 20) /* 23, 20 */
> > +#define QCA_HDR_MGMT_ADDR		GENMASK(18, 0)  /* 18, 0 */
> > +
> > +/* Special struct emulating a Ethernet header */
> > +struct mgmt_ethhdr {
> > +	u32 command;		/* command bit 31:0 */
> > +	u32 seq;		/* seq 63:32 */
> > +	u32 mdio_data;		/* first 4byte mdio */
> > +	__be16 hdr;		/* qca hdr */
> > +} __packed;
> 
> Could you name this something a bit more specific, like qca_mgmt_ethhdr?
>

Sure will fix in v8.

> > +
> >  #endif /* __TAG_QCA_H */
> > diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> > index f8df49d5956f..c57d6e1a0c0c 100644
> > --- a/net/dsa/tag_qca.c
> > +++ b/net/dsa/tag_qca.c
> > @@ -32,10 +32,10 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
> >  
> >  static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
> >  {
> > -	u8 ver;
> > -	u16  hdr;
> > -	int port;
> > +	u16 hdr, pk_type;
> >  	__be16 *phdr;
> > +	int port;
> > +	u8 ver;
> >  
> >  	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
> >  		return NULL;
> > @@ -48,6 +48,13 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
> >  	if (unlikely(ver != QCA_HDR_VERSION))
> >  		return NULL;
> >  
> > +	/* Get pk type */
> > +	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
> > +
> > +	/* Ethernet MDIO read/write packet */
> > +	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
> > +		return NULL;
> > +
> >  	/* Remove QCA tag and recalculate checksum */
> >  	skb_pull_rcsum(skb, QCA_HDR_LEN);
> >  	dsa_strip_etype_header(skb, QCA_HDR_LEN);
> > -- 
> > 2.33.1
> > 
> 

-- 
	Ansuel
