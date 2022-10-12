Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38895FC5C1
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiJLM7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJLM73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:59:29 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A818CAE55;
        Wed, 12 Oct 2022 05:59:23 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e18so24356244edj.3;
        Wed, 12 Oct 2022 05:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TGYVPLfEdQwtvJxVHUpmNuryEZMsjuZwbLk7iMaLssI=;
        b=Pg+wd76hIb4W7HIoA5VArWvdEWW9tB3Sq4qMTNoc+30cWPllz01InDCrNdh/V5Bq+C
         O0VYuE703OEEU7gJaBNtfZdlngwAzoO0XTs37gJsvkoxOgroVM2i+R0LO2rFqE2VoNjv
         SdrWmEnAL58PoyTIuOaItacOk7FhMhMt1LwV4iJmfSeI+EAPbMegGpc2lyZcB8W9oBod
         1Grhvr5CbwFQi/UyO7lH9Hmj7YJ8HCxDXeNrwfbpEjSpOa3CISrhSgSYrl20O/sm0pAZ
         v1dtDzq9A7Bo9AyPiOKZvmDnb7wOec1Ozzdq/YesEM9UtybS4Yw/FDUmQ9w5SQL7aqPv
         GF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGYVPLfEdQwtvJxVHUpmNuryEZMsjuZwbLk7iMaLssI=;
        b=3+QgIEiJRYFs7HaP/tro0JJUvNo+ykVpA0pQtn7ywdVw1N+nvx1rlBi7AkW05uFMxx
         N4HugjQYJsYJGosERpIwKoRnrorWzLpS3EboujygsSmWnzHZ+BfJdKVvG5q95kclIg/c
         XzWdBIG6Su3lh2+ZDLHumhHYyQ1mTZyX8k7QOcoAdrxQE0BEAFYWaYN/UulRo/RnmI8r
         1VHwR0V4BlPuRoVGzoN47Q5is+EzBBT+D/jOheDpuYkV2zn+FqULCZOddfdCk89hNu7w
         nzk+pt+cRmEOX2bu4P6hGcqqkAGiFp9G4JzrF/RaVRfeL/0s/FOylPows5VT/dHctVdI
         SNAA==
X-Gm-Message-State: ACrzQf2vsqRWYqhg/zFmILHvfasearORBQIgegL2hEY8uvRNCb5JUaY7
        dn0SH2kPdBNR3J2GG8lzX6w=
X-Google-Smtp-Source: AMsMyM6rWXEdncz+6V7MNAoZBd0IFj9YJotfErFTyjo7admzhQ3rekATf8bMtFXIGRjeUd+hepCM5Q==
X-Received: by 2002:a05:6402:b35:b0:45c:9c9d:2531 with SMTP id bo21-20020a0564020b3500b0045c9c9d2531mr4474162edb.410.1665579561392;
        Wed, 12 Oct 2022 05:59:21 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id p2-20020a056402044200b00458c07702c1sm11076377edw.23.2022.10.12.05.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 05:59:20 -0700 (PDT)
Message-ID: <6346ba28.050a0220.f0e18.949b@mx.google.com>
X-Google-Original-Message-ID: <Y0a6JW7rzPUDnx2i@Ansuel-xps.>
Date:   Wed, 12 Oct 2022 14:59:17 +0200
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
 <6346b921.a70a0220.64f4e.a0bc@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6346b921.a70a0220.64f4e.a0bc@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 02:54:54PM +0200, Christian Marangi wrote:
> On Wed, Oct 12, 2022 at 02:42:16PM +0200, Andrew Lunn wrote:
> > On Mon, Oct 10, 2022 at 01:14:58PM +0200, Christian Marangi wrote:
> > > The header and the data of the skb for the inband mgmt requires
> > > to be in little-endian. This is problematic for big-endian system
> > > as the mgmt header is written in the cpu byte order.
> > > 
> > > Fix this by converting each value for the mgmt header and data to
> > > little-endian, and convert to cpu byte order the mgmt header and
> > > data sent by the switch.
> > > 
> > > Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> > > Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
> > > Tested-by: Lech Perczak <lech.perczak@gmail.com>
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > Reviewed-by: Lech Perczak <lech.perczak@gmail.com>
> > > ---
> > >  drivers/net/dsa/qca/qca8k-8xxx.c | 63 ++++++++++++++++++++++++--------
> > >  include/linux/dsa/tag_qca.h      |  6 +--
> > >  2 files changed, 50 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> > > index 5669c92c93f7..4bb9b7eac68b 100644
> > > --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> > > +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> > > @@ -137,27 +137,42 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
> > >  	struct qca8k_mgmt_eth_data *mgmt_eth_data;
> > >  	struct qca8k_priv *priv = ds->priv;
> > >  	struct qca_mgmt_ethhdr *mgmt_ethhdr;
> > > +	u32 command;
> > >  	u8 len, cmd;
> > > +	int i;
> > >  
> > >  	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
> > >  	mgmt_eth_data = &priv->mgmt_eth_data;
> > >  
> > > -	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
> > > -	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
> > > +	command = le32_to_cpu(mgmt_ethhdr->command);
> > > +	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
> > > +	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);
> > 
> > Humm...
> > 
> > This might have the same alignment issue as the second patch. In fact,
> > because the Ethernet header is 14 bytes in size, it is often
> > deliberately out of alignment by 2 bytes, so that the IP header is
> > aligned. You should probably be using get_unaligned_le32() when
> > accessing members of mgmt_ethhdr.
> > 
> > 	  Andrew
> 
> Should I replace everything to get_unaligned_le32? Or this is only
> needed for the mgmt_ethhdr as it's 12 bytes?
> 
> The skb data is all 32 bit contiguous stuff so it should be safe? Or
> should we treat that also as unalligned just to make sure?
> 
> Same question for patch 2. the rest of the mib in skb data are all 32 or
> 64 values contiguous so wonder if we just take extra care of the
> mgmt_ethhdr. 
> 

Also also... Should I use put_unalligned to fill the mgmt_ethhdr?

-- 
	Ansuel
