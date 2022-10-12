Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7910D5FC561
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJLMea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiJLMe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:34:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8D9C6960;
        Wed, 12 Oct 2022 05:34:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a26so37673012ejc.4;
        Wed, 12 Oct 2022 05:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9/RIE4UtfSnbb24YnWB8sjXppAAKMhorvgvYfIUj5k4=;
        b=dBQz1uVSih9iBYNDG+HvDmLo2oLgdqcmQEq1z+bpjGgeQM2VbL6mvbFTVD8bQrRg8w
         SiDoQTUOn4BCEALVWnpIxLPD4/QogY2rqMaNw+ZseI4XTqvSDEdmj+EdlTzAVPxvuUFX
         SLg9sUHpH27bwUUp4wZDxlh9Hobs39km8D0RBUghVFePZh1v8bx356ApfBUGtBJrpllt
         83ZikNmUH+iCo0LL3ZKoaDisVK5douU410IW0J0xSK20RxgIkQR/XiSY09xxp/aUBjBh
         Mo71R3FtgBUjzsmevzYgpWXa6eCJ3btCkjFTjPYzdbj7WBTT+RpU+62Wo5mSbcuee5/H
         yPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/RIE4UtfSnbb24YnWB8sjXppAAKMhorvgvYfIUj5k4=;
        b=FJfzh6R60MOgI5P7ca2o4P1a4KBrT+WHXxuLMzn22fTW/3v1mia4LSsa0t4bN9vmaF
         50VEum1vKkDCjVYFF9OGo+y381Mm663KnF+JgYJ7yKSqDxkb31hsNoegAHa82Yy9d/sG
         EGbzCvOVj3u19kUW0rDTtdluwTgW877P01rc8z9+eqr5tl+PMcQNCK/iN4UfNwyhfV5w
         Y8jwETlRVrHKphWSJ46m/UFidI1PTl1DT9OnKx1GpidrjYEwD/Ea01q+re2vhpx5uumX
         f+hC4BdhdMQ6xPgWdBFk92z9XMgI90uDGrNqnJcuR9W/jdM5OuhJIrbxGgidNBhDOZMR
         ihhA==
X-Gm-Message-State: ACrzQf3Pta+WuQkz07EfwwqykaTtn/Xnsd++KwOelPPy8WV2o4+pwLyl
        uBLycl4IsZD9GLj5P1kPvRk=
X-Google-Smtp-Source: AMsMyM6iiVUpEIeWX1XO2f5hwEdoAqSvNflAm9iN3wbYxrZVZpcjBbuOvdp6juwchz1X6lRVeYFhVQ==
X-Received: by 2002:a17:907:8a15:b0:782:e6da:f13d with SMTP id sc21-20020a1709078a1500b00782e6daf13dmr22750273ejc.152.1665578066004;
        Wed, 12 Oct 2022 05:34:26 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090609ca00b00780636a85fasm1133082eje.221.2022.10.12.05.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 05:34:25 -0700 (PDT)
Message-ID: <6346b451.170a0220.2c49b.3ebc@mx.google.com>
X-Google-Original-Message-ID: <Y0a0Tkbsg40yFOq5@Ansuel-xps.>
Date:   Wed, 12 Oct 2022 14:34:22 +0200
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
 <Y0RqDd/P3XkrSzc3@lunn.ch>
 <63446da5.050a0220.92e81.d3fb@mx.google.com>
 <Y0azJlxthYXr7gMX@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0azJlxthYXr7gMX@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 02:29:26PM +0200, Andrew Lunn wrote:
> On Mon, Oct 10, 2022 at 02:44:46PM +0200, Christian Marangi wrote:
> > On Mon, Oct 10, 2022 at 08:53:01PM +0200, Andrew Lunn wrote:
> > > >  /* Special struct emulating a Ethernet header */
> > > >  struct qca_mgmt_ethhdr {
> > > > -	u32 command;		/* command bit 31:0 */
> > > > -	u32 seq;		/* seq 63:32 */
> > > > -	u32 mdio_data;		/* first 4byte mdio */
> > > > +	__le32 command;		/* command bit 31:0 */
> > > > +	__le32 seq;		/* seq 63:32 */
> > > > +	__le32 mdio_data;		/* first 4byte mdio */
> > > >  	__be16 hdr;		/* qca hdr */
> > > >  } __packed;
> > > 
> > > It looks odd that hdr is BE while the rest are LE. Did you check this?
> > > 
> > >    Andrew
> > 
> > Yes we did many test to analyze this and I just checked with some
> > tcpdump that the hdr is BE everytime.
> 
> That might actual make sense. The comment says:
> 
> > > >  /* Special struct emulating a Ethernet header */
> 
> And hdr is where the Ether type would be, which is network endian,
> i.e. big endian.
> 
>      Andrew

Yes that is my theory... hdr is in the ether type position so it's the
only part that the switch treat in a standard way as it has to be like
that or a dev creating a tagger driver would have no way to understand
if the packet is autocast, in band ack or a simple packet so who created
the fw for the switch had this concern in mind and stick to keeping at
least the hdr in a standard way.

-- 
	Ansuel
