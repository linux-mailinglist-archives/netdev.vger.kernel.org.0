Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201F350EEE2
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 04:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242449AbiDZCw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 22:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240518AbiDZCwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 22:52:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4E2B3E
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:49:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b12so14167599plg.4
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aqwNZmlsLP2nY8OdRO3qnK+rK4uYR62ZOaw9XQvFoFo=;
        b=SHfb7h6NtP4DfVIC6JpCMTf/67pdxkR5NudvBENFe+MuM/Lv+LmuM6S29FDZja7cI4
         Bnp9R4H1cCCs9sl1VDFKu+4Ihby5grvALPM1rjq+SQlwqHYSChPG37DBKtaWnf0xo95n
         7Wbo9ixx4W30XCIljhsRzt/SL8y2yqV3bZ0A5I/mneEDjjrGrnhr9pyOVShUzXI1ytq+
         sEHca4mhy9ucCew5nXWLdI1bMYWrmcCELXVAphk79VhJzb0i+vf8TkKeXXVkeK2JTN4M
         XQAcnidqxtAbO0gh1hFcN1UcB1AevLjF4lM5r3oZijOUiAsyWnTLJnS8WuSN2ePVkh40
         1GGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aqwNZmlsLP2nY8OdRO3qnK+rK4uYR62ZOaw9XQvFoFo=;
        b=a7/z+P99fppHje1V5kyw4v0BDhVK8vl77TFYhi/ZHw82g+byQDfE/3ymMijRwWJp5T
         xr3iVLJiZ8kKxDkE61yV4Et8jUHjX3lfZqpCeRA7vlahwY1DBKnPB0XMNF7tB2QbrW3+
         UVQaLqwPasuxMrZ7hyUtcxjgQtCHKAtbekPqyTw+pFVfUeCkiD/tSw+/AOUbjgLYVqU4
         rrVPhVC37MtBHDwAuOyiNzNfWXzzuCT3HxvN18w26Z3FNhyHyW06COvRfBuWeKNuIv30
         RMvc59wdjJVx4Fwv/QyguYFADl/t5wmwknfmusbJZX87xc1N38N0k7U4YIFtQzddAJ8U
         Bhag==
X-Gm-Message-State: AOAM532i1s23Ww892ABXD44JkSIf6YNoxnd24uhWh81i+PD8sCzGKMm6
        nlVFYxbUmyItp5fPCvRV8vQ=
X-Google-Smtp-Source: ABdhPJxKuWsNSHmRCi5fm763XoaFy6ydIxAdedybJF5p/Ec1Ut7dkj5HJS1Ik/1PwPtND9n2RTbF0Q==
X-Received: by 2002:a17:90b:1b42:b0:1d9:73b4:4433 with SMTP id nv2-20020a17090b1b4200b001d973b44433mr9382854pjb.69.1650941358871;
        Mon, 25 Apr 2022 19:49:18 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j64-20020a62c543000000b0050d260c0ea8sm8977420pfg.110.2022.04.25.19.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 19:49:18 -0700 (PDT)
Date:   Mon, 25 Apr 2022 19:49:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220426024915.GA22745@hoboy.vegasvil.org>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220425011931.GB4472@hoboy.vegasvil.org>
 <20220425233043.q5335cvto5c6zcck@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425233043.q5335cvto5c6zcck@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 04:30:43PM -0700, Jonathan Lemon wrote:
> On Sun, Apr 24, 2022 at 06:19:31PM -0700, Richard Cochran wrote:
> > On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:
> > 
> > > +static bool bcm_ptp_rxtstamp(struct mii_timestamper *mii_ts,
> > > +			     struct sk_buff *skb, int type)
> > > +{
> > > +	struct bcm_ptp_private *priv = mii2priv(mii_ts);
> > > +	struct skb_shared_hwtstamps *hwts;
> > > +	struct ptp_header *header;
> > > +	u32 sec, nsec;
> > > +	u8 *data;
> > > +
> > > +	if (!priv->hwts_rx)
> > > +		return false;
> > > +
> > > +	header = ptp_parse_header(skb, type);
> > > +	if (!header)
> > > +		return false;
> > > +
> > > +	data = (u8 *)(header + 1);
> > 
> > No need to pointer math, as ptp_header already has reserved1 and reserved2.
> > 
> > > +	sec = get_unaligned_be32(data);
> > 
> > Something is missing here.  The seconds field is only four bits, so
> > the code needs to read the 80 bit counter once in a while and augment
> > the time stamp with the upper bits.
> 
> The BCM chip inserts a 64-bit sec.nsec RX timestamp immediately after
> the PTP header.  So I'm recovering it here.  I'll also update the patch
> to memmove() the tail of the skb up in order to remove it, just in case
> it makes a difference.

Okay, this is something different.  This won't work because that
corrupts the PTP message format.

I'm talking about a different mode where the PHY places the time stamp
into the reserved1/2 fields.

Thanks,
Richard
