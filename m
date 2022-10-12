Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD15FC5A8
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJLMzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJLMzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:55:07 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8FF186DF;
        Wed, 12 Oct 2022 05:55:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id q9so33245511ejd.0;
        Wed, 12 Oct 2022 05:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=v8IwUcx5X1rZkbWMDsrbcC20oSFNufwW/oJWRFUHsbI=;
        b=YCsHTEdXOhTgRYogfR0YgBa31FlkuzhfbwHfl39EMES4gqu0zcA+k4G+sOCG/lUxrU
         93rKi3Fp9mtI7W/4fgMH8HoeVe765Vk49N9Z/4DWIb5UGcTD6c9qJS0qhxh2iMEn+58R
         Xq4ZKZOBMg35xymVGWp9XsIdR2xF/sqDfVsudvvE64ukoxjMMI91F7DnVpcTYLIRFZE/
         N13rPLJjQlO9JcLugqFIX0RArL4834yaAcd1L2hk11tdvnstPcJYbt71hssH3/y+/lwj
         qSQdDCwb7eGof+P5gqo0SDmeoCNCzIRdS9bw3R9qiPXvRdLcPXznYb8ugT6XiwhutNRp
         rf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8IwUcx5X1rZkbWMDsrbcC20oSFNufwW/oJWRFUHsbI=;
        b=4XXCWrCkSVP9BavAVczNcBLSVdB+WtlndvhZxtjZymWvjHJpC+t68W6/ht3ZYoCDoY
         kMzZwjZwANFgTZw2+ONRyEQzbEBACBNU+cSZWwnb8sULi4HlbwSPB30r9W0vIasiuArX
         uvxGZ+QOPJfXa0R2zgOZsXFygagVwBfTS/XWwRKfxBUDPXPWWHojF0ruHre7MxYlGSDd
         6EKze5kEA3iqE91cOgOq2X5uGSpY+sx2OZ5ttkDHdQpXdNTe3XUTu4Vu5boCOzVGaa1l
         RFeyGXMlwHfhKwysrqV4I+56iHClEv9AoGJ92s1wqw9TBa9/0LjrAl339v4l9RfhdbOL
         CIpA==
X-Gm-Message-State: ACrzQf08w/99lOpOoHWFEWbYJC2uJjTbAmYWUd1tNwoedZRF8vtzfWZy
        J7gC8uBawXMpL0RPJ+QbctE=
X-Google-Smtp-Source: AMsMyM5B+Wn5Lk3WaMk6hzFXBkzGPgv5QgiMMFUKsKNXhdU4mn/vUh8FsegbGhfv5GxO8t1Igql3Ag==
X-Received: by 2002:a17:907:1c98:b0:78d:3b08:33ef with SMTP id nb24-20020a1709071c9800b0078d3b0833efmr23140976ejc.175.1665579297988;
        Wed, 12 Oct 2022 05:54:57 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7c157000000b0044e937ddcabsm11247699edp.77.2022.10.12.05.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 05:54:57 -0700 (PDT)
Message-ID: <6346b921.a70a0220.64f4e.a0bc@mx.google.com>
X-Google-Original-Message-ID: <Y0a5Hrs+FWq0RFaL@Ansuel-xps.>
Date:   Wed, 12 Oct 2022 14:54:54 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
 <Y0a2KD9pVeoYkHkK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0a2KD9pVeoYkHkK@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 02:42:16PM +0200, Andrew Lunn wrote:
> On Mon, Oct 10, 2022 at 01:14:58PM +0200, Christian Marangi wrote:
> > The header and the data of the skb for the inband mgmt requires
> > to be in little-endian. This is problematic for big-endian system
> > as the mgmt header is written in the cpu byte order.
> > 
> > Fix this by converting each value for the mgmt header and data to
> > little-endian, and convert to cpu byte order the mgmt header and
> > data sent by the switch.
> > 
> > Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> > Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
> > Tested-by: Lech Perczak <lech.perczak@gmail.com>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > Reviewed-by: Lech Perczak <lech.perczak@gmail.com>
> > ---
> >  drivers/net/dsa/qca/qca8k-8xxx.c | 63 ++++++++++++++++++++++++--------
> >  include/linux/dsa/tag_qca.h      |  6 +--
> >  2 files changed, 50 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> > index 5669c92c93f7..4bb9b7eac68b 100644
> > --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> > +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> > @@ -137,27 +137,42 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
> >  	struct qca8k_mgmt_eth_data *mgmt_eth_data;
> >  	struct qca8k_priv *priv = ds->priv;
> >  	struct qca_mgmt_ethhdr *mgmt_ethhdr;
> > +	u32 command;
> >  	u8 len, cmd;
> > +	int i;
> >  
> >  	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
> >  	mgmt_eth_data = &priv->mgmt_eth_data;
> >  
> > -	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
> > -	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
> > +	command = le32_to_cpu(mgmt_ethhdr->command);
> > +	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
> > +	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);
> 
> Humm...
> 
> This might have the same alignment issue as the second patch. In fact,
> because the Ethernet header is 14 bytes in size, it is often
> deliberately out of alignment by 2 bytes, so that the IP header is
> aligned. You should probably be using get_unaligned_le32() when
> accessing members of mgmt_ethhdr.
> 
> 	  Andrew

Should I replace everything to get_unaligned_le32? Or this is only
needed for the mgmt_ethhdr as it's 12 bytes?

The skb data is all 32 bit contiguous stuff so it should be safe? Or
should we treat that also as unalligned just to make sure?

Same question for patch 2. the rest of the mib in skb data are all 32 or
64 values contiguous so wonder if we just take extra care of the
mgmt_ethhdr. 

-- 
	Ansuel
