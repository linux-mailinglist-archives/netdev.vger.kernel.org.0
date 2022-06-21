Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB60E5534EB
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351965AbiFUOsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 10:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351919AbiFUOsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 10:48:51 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D921835B;
        Tue, 21 Jun 2022 07:48:50 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id n1so19055685wrg.12;
        Tue, 21 Jun 2022 07:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=vlnKRuBPqss3zsQNpDmnIm6uVAnBcGHoNC6WSZ5FLE0=;
        b=ATyPaeNCm+RavESosXQxuYwdmPLZwgPqSl2lWPcmJaUElksx8WCtRcjNGOzumVJ3bh
         Mh8WiMW0oQLGvb/u3pZwT8HrVuq7k/5tk5NxB7/bbz02D+XjBrpiv2X70BRESjE1+uaw
         jMUM/cSCXpfksjHMGhf3oLUDygBm9OiC9Yh44O9HcEO5SQmoazkqG3DzR/WRRrmeEkep
         vz4Hg9Ncy1lPg4LQ6vvA3GqgwZTAaenwSuh8/H9C6YEAFac2gPvezj+ent/aRGjTdCjE
         7WaXyRC9w+AlEfYEg8GotXuPkiGBpln3a4iiFCGqvuB3GhHU0xXQNuYnGnIbO2ub0x9l
         63mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=vlnKRuBPqss3zsQNpDmnIm6uVAnBcGHoNC6WSZ5FLE0=;
        b=MQHWCYpZgqzhRvuc42OIlFtePIFIPELvoVGyZAkKcFY5Reye+WKsM04R400mOMC6Wy
         QwF0jrsbiubVTU/sSQZNJQZvmwlP4lp6cCqL0Jak03LHHbvCDMcg7QKN7GVk0pDhMNn7
         x6s8+iECF6ZEXVW6JzIfSWUis6dELqstiYINhkQruHUSxocqWZFGUPJXt3+6HZbRWTHc
         rJRbNiZGGIp6FKDBXvpuGr3ALxN0oJdLv6s+Xd5Tgl6zQ3xhYb1CEoU6xCxiL3piZ410
         IoGuiq2zPtldmTTti8YRTvz6QF9fTS4TkbEMA7Tmrgo5aq8Z9jfIdgQGcLLBxobohvIX
         QklQ==
X-Gm-Message-State: AJIora+powTiziCAW+zx923tNGQit7KGaOm2gZBLscHfsZHA4oTeZ5KT
        1n1un54P7vhiPU03wq9+SI0=
X-Google-Smtp-Source: AGRyM1tvXZLrrUbKR+gsHOyD1FD16/5ehOu9iiQCaOw5Yxpis0oosu8Pa14UfBeLsw6pF0Gd9rCczQ==
X-Received: by 2002:a05:6000:10d0:b0:21b:8ffb:80ad with SMTP id b16-20020a05600010d000b0021b8ffb80admr10459888wrx.444.1655822929034;
        Tue, 21 Jun 2022 07:48:49 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id cc3-20020a5d5c03000000b00213ba3384aesm16252153wrb.35.2022.06.21.07.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 07:48:48 -0700 (PDT)
Message-ID: <62b1da50.1c69fb81.c77ce.0278@mx.google.com>
X-Google-Original-Message-ID: <YrHaT0CwbpDvJM/+@Ansuel-xps.>
Date:   Tue, 21 Jun 2022 16:48:47 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: dsa: qca8k: reduce mgmt ethernet timeout
References: <20220618062300.28541-1-ansuelsmth@gmail.com>
 <20220621123335.gvuuob7pnlz77lof@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621123335.gvuuob7pnlz77lof@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 03:33:35PM +0300, Vladimir Oltean wrote:
> On Sat, Jun 18, 2022 at 08:22:58AM +0200, Christian Marangi wrote:
> > The current mgmt ethernet timeout is set to 100ms. This value is too
> > big and would slow down any mdio command in case the mgmt ethernet
> > packet have some problems on the receiving part.
> > Reduce it to just 5ms to handle case when some operation are done on the
> > master port that would cause the mgmt ethernet to not work temporarily.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> 
> I think this could very well qualify as a regression and have a tag of:
> 
> Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> 
> if it was presented along with a situation where users could hit some
> real life conditions where the Ethernet management interface isn't
> functional.
>

It's really to handle corner case... In testing the MTU change (and
noticing the mgmt ethernet going "macheroni") I notice the timeout was
absurdly high. In a situation where something goes wrong at least you
can have access to it after some time.

Ok I will add the fixes tag.

> >  drivers/net/dsa/qca8k.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index 04408e11402a..ec58d0e80a70 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -15,7 +15,7 @@
> >  
> >  #define QCA8K_ETHERNET_MDIO_PRIORITY			7
> >  #define QCA8K_ETHERNET_PHY_PRIORITY			6
> > -#define QCA8K_ETHERNET_TIMEOUT				100
> > +#define QCA8K_ETHERNET_TIMEOUT				5
> >  
> >  #define QCA8K_NUM_PORTS					7
> >  #define QCA8K_NUM_CPU_PORTS				2
> > -- 
> > 2.36.1
> > 

-- 
	Ansuel
