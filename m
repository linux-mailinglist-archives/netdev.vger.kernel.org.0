Return-Path: <netdev+bounces-4076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F6970A8C8
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 17:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 942621C209EC
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 15:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80056AD9;
	Sat, 20 May 2023 15:17:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDBE6FA1
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 15:17:15 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3732DF2;
	Sat, 20 May 2023 08:17:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9661047f8b8so805870466b.0;
        Sat, 20 May 2023 08:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684595831; x=1687187831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y469sUGtR54aB4T78LIqmlcF1QDANFMy5ogHNLimX/8=;
        b=DFGJio+BvQf2QBCLxS3QiRfSEguV8mxHgnUjYIc9KGq//OWlZGVi/lpMTog2PemY6n
         Zk6kqS8Yqilei/RcZvC9ZCWW80Mbu7V5xgLLG9QruVK1YqtEiJAqsAu5BtGKKgAtVnrZ
         zRUulNIlgTUKmA9UzHUEk0I1b6kz/7CZL0L9IkwQqAR2lQL12qHidLf1i9psqrKqv5+K
         U3u88h9F/YH1leyVgpK4RYc4jQIAGfPFLoOvYT82ByvesmsGgE61ooTAUrFO/ScAhfJ/
         Mwtx8FLP/hBHQsmaYLtU+mJCf4BJsdQI5+9z5iOt0FgyFHgX/gzBwaVmNsq3WFswOLOp
         viGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684595831; x=1687187831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y469sUGtR54aB4T78LIqmlcF1QDANFMy5ogHNLimX/8=;
        b=AyMJYIFTSbo7zgqWokOWOaxsGBG1h/tGb4lxAuG2a6PrwVxOxNsalcwdjJI7YaTNjB
         XReEAcZndMGbYfpqliL+08K+rn/VpwwJWHBJj1UF1mb5l5XPa8s2AgZtkBpILuGvFW+o
         uxMaMI6kV3I0Qzn7lBADM3fmbgSirkuhf2cyijvFU07FDSZyFvCRkD90tfZq3QK29zz2
         eOoWrs86LIeAWKpW2P5862IVwCEnj26qWrvU2HsbLbyOQ3AcTV3XfiCEj4g35FBdbRAW
         S0jgQlky0WCRdQC/K4lwfjjdo0h3ErUne86jkagMtJ8GFi3jv3OhJzXtDRCQAE5n1rRH
         EQcw==
X-Gm-Message-State: AC+VfDw+wUzP2F504r1YMkwJYnoZTCx8k8MwHA/y8Z7exq2R2HIjU5tV
	jfex3oaxCiiQtoFIUO6CBXM=
X-Google-Smtp-Source: ACHHUZ6GXK0nu3XJofgB096aLk7moFqBp/ZMelrOb0gVAWgAFfUwRBEGrxnrHYOHWW61+GMWOH0siA==
X-Received: by 2002:a17:907:7f1d:b0:88a:1ea9:a5ea with SMTP id qf29-20020a1709077f1d00b0088a1ea9a5eamr4771025ejc.65.1684595831311;
        Sat, 20 May 2023 08:17:11 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id g18-20020a170906199200b00965cfc209d5sm889840ejd.8.2023.05.20.08.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 08:17:10 -0700 (PDT)
Date: Sat, 20 May 2023 18:17:08 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Woojung Huh <woojung.huh@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	UNGLinuxDriver@microchip.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230520151708.24duenxufth4xsh5@skbuf>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
 <20230519143004.luvz73jiyvnqxk4y@skbuf>
 <20230519185015.GA18246@pengutronix.de>
 <20230519203449.pc5vbfgbfc6rdo6i@skbuf>
 <20230520050317.GC18246@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520050317.GC18246@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 07:03:17AM +0200, Oleksij Rempel wrote:
> On Fri, May 19, 2023 at 11:34:49PM +0300, Vladimir Oltean wrote:
> > On Fri, May 19, 2023 at 08:50:15PM +0200, Oleksij Rempel wrote:
> > > Thank you for your feedback. I see your point. 
> > > 
> > > We need to remember that the KSZ switch series has different types of
> > > ports. Specifically, for the KSZ8 series, there's a unique port. This
> > > port is unique because it's the only one that can be configured with
> > > global registers, and it is only one supports tail tagging. This special
> > > port is already referenced in the driver by "dev->cpu_port", so I continued
> > > using it in my patch.
> > 
> > Ok, I understand, so for the KSZ8 family, the assumption about which
> > port will use tail tagging is baked into the hardware.
> > 
> > > It is important to note that while this port has an xMII interface, it
> > > is not the only port that could have an xMII interface. Therefore, using
> > > "dev->info->internal_phy" may not be the best way to identify this port,
> > > because there can be ports that are not global/cpu, have an xMII
> > > interface, but don't have an internal PHY.
> > 
> > Right, but since we're talking about phylink, the goal is to identify
> > the xMII ports, not the CPU ports... This is a particularly denatured
> > case because the xMII port is global and is also the CPU port.
> 
> I see. Do you have any suggestions for a better or more suitable
> implementation? I'm open to ideas.

Trying to answer here for both questions. In the RFC/RFT patch set I had
posted, I introduced the concept of "wacky" registers, which are registers
which should be per port (and are accessed as per-port by the driver),
but because there is a single such port in the switch, the hardware
design degenerated into moving them in the global area. Nonetheless,
treating the xMII global registers as per-port makes it possible for the
common driver to share more code between KSZ8 and others.

If you look at ksz9477_phylink_mac_link_up() - renamed to just
ksz_phylink_mac_link_up() in my patch set - hard enough, you can see
that it makes an attempt to generalize the "link up" procedure for all
switch families, via these regs and fields. At the end of that regfield
series, I theoretically converted KSZ8765/KSZ8794/KSZ8795 to reuse
ksz9477_phylink_mac_link_up(). Theoretically because no one commented
on whether the result still worked.

I think that regfields and that KSZ_WACKY_REG_FIELD_8() are an avenue
worth exploring here.

