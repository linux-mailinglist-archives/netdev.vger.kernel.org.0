Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2995FC541
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJLMY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJLMYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:24:55 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8249327CF0;
        Wed, 12 Oct 2022 05:24:53 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so37538250ejb.13;
        Wed, 12 Oct 2022 05:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ytqQ1cDOxBZFD/vHgDeWMTdy0Xdb3L8hzizbhg/VDps=;
        b=DB8JwO9WuD4xmUBa2BA5PkVz1BGxJIDwCTpjS6YNA3ak1yzMMBnXHNVkBl3/RufvDc
         5bvvewC3ejedP/EtUThNQYMCrX5uqHz5kX8xNmDGIdpLQ/FvADFSJ7FxIW6OJadhNW1U
         hbUTTutdMdcdnv16/ftoZHPgCsiDNg823PH8FuskwTKfGq7ueBILCxed9suTDDOz/39/
         4MPehqB5og4cjH3npyDdESiDS0iWUch0eLBFhJWGOb/MBGDG9gpxqcmUMxnP5bzBou4T
         QuSin7IoqDg5z+eZ4qdCCUeH8ETlHAU4dv0zuXgPfqN7gItnJ5vrfK+u8LfNYnNfMQzh
         JHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytqQ1cDOxBZFD/vHgDeWMTdy0Xdb3L8hzizbhg/VDps=;
        b=phS3zVIyd2qA3PlJb5AoUltmuo+Sc2t8p2ri3Nff1n3YjAw6VeIguy7rRxplQkt/qU
         z+LNoRqP+ztBrYkLHKn1pE1rY/zt/ogRwg3QmuuEdBI6TZ8/kDlFIHSDPXuZNuD9hzb6
         +2hxahWW214qZ8zdrNPF+lAe0hnAf8/6FzLsMzCUMaSjrxB/+R6Cs0rWDvG+9uSgFNt3
         bZT43M4sq/L+ACg1nijQHl2vt8YuoB0sa//VF5sMMe/Bt9ZlFY7JvAtsr6oJkiXTEh11
         vzD8UCEglLv5oHLFqwGHDZH8p6DKUUPohjdZmRW81b691w1/0wjJ1d33hoSvLzzYMRaD
         v9Tg==
X-Gm-Message-State: ACrzQf05bv+MQj7KP4JHCGMzYoNC+0O4Wesl4Plz5wTS4+hY3nOEKvmt
        2faFApP98r8ULqrFD7CKUEx3O/NwHIA=
X-Google-Smtp-Source: AMsMyM454eJcJsbNPHab14fThr6MoHVYZ4t2YqL/WB3VoPJ18yNTVs+XL3WBqOl5VWGUqvDmq4zVOA==
X-Received: by 2002:a17:907:97c6:b0:783:dcad:3454 with SMTP id js6-20020a17090797c600b00783dcad3454mr23008541ejc.271.1665577491827;
        Wed, 12 Oct 2022 05:24:51 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0078d21574986sm1139245ejt.203.2022.10.12.05.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 05:24:51 -0700 (PDT)
Message-ID: <6346b213.170a0220.a9c38.3d7b@mx.google.com>
X-Google-Original-Message-ID: <Y0ayD81h0iqXLohZ@Ansuel-xps.>
Date:   Wed, 12 Oct 2022 14:24:47 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
 <20221012072411.dk7dynbttnaozyrl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012072411.dk7dynbttnaozyrl@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 10:24:11AM +0300, Vladimir Oltean wrote:
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
> > tcpdump that the hdr is BE everytime. If you want I can provide you some
> > tcpdump from 2 different systems.
> > 
> > Anyway it looks like this family switch treats the hdr in a standard way
> > with the network byte order and for anything else stick to LE.
> > 
> > Also as a side note the tagger worked correctly before the mgmt feature
> > on BE systems and also works correctly now... just any command is slow
> > as the mgmt system has to timeout and fallback to legacy mdio.
> 
> Could you provide a tcpdump?

Hi, this [0] is the zip with all the tcpdump.
The main packet to check are the one that are 60 in lenght and > 170 in
length for the autocast mib. I added both LE and BE and for BE I added
the broken and the correct one.

As you notice without following this endianess madness, the switch
doesn't answer to any request.

Hope the dump are not too bloated to understand this problem.

[0] https://we.tl/t-ZpXVObTIh0

-- 
	Ansuel
