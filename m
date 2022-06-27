Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1B755DF42
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240787AbiF0UCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237819AbiF0UCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:02:43 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FCD1C91D;
        Mon, 27 Jun 2022 13:02:42 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g26so21389835ejb.5;
        Mon, 27 Jun 2022 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2RG4T2ZEU66wsxzlt1P5Q73rY/z91mE7K4blE6N8+0Q=;
        b=EUILz45/4OGmZNOcDM30R2wHd/eF99q4yXPjOuDCAvrsDr3DfKx3NIHoBj0T2MYU64
         3l8lLeTEMq8t5ji1LfmOSveityf0k8W90FqiF19Xqh78fDMpP8c7eUF0w4OUOBinzOZ7
         9DDSiXXl6wFtnHIvA6GWLkqeSCJDoE48RKHCrfHJjzv0pmOapH4sGjKXl94nx5f4pI6P
         IRjhyXIGF3bw/40Oo+Np+J2UsWcG9Z0X2Hp82yNSpwjJtSYNIHtUmrwAu3JOoTZ8UOOn
         mmWbCbdSIRtiAjGJ5u1Cj37WitFpdymnAZHUsHzI973xfES16jQz9a7dXh3+BG/7N3j/
         b6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2RG4T2ZEU66wsxzlt1P5Q73rY/z91mE7K4blE6N8+0Q=;
        b=NA383uevUYQnGlHMJyvAsDoTRjrATLKmBlQwarCguejKy2DmQpWLEGkFVEmeWTYket
         eyGJeCQ7ighUi95rCB9OiYhIzvZmo9rI8xpx9GIAs6JogPZe1DuPuGTIOdSouBQsI7Mv
         eXg9l7qtHXygJlelejdrLKeFO87f94HQrowhN1AyTMHRQCMNpB0RcG2Y8tfED640PitZ
         vGikmG6vnk41Fi32BhS1ItmgY5H3aU1TV5iaN4rshTuMOfWXVxOOua/JlFw8aGTtwlNm
         6Au2Q5foxEhxSjfEfHHXCNUW9OOgL28rnOBIKtDmEW4+QXH43dAu39WHbG0OXtxiLD4w
         9YeA==
X-Gm-Message-State: AJIora9CwQPlfmRSjtlfATd6cCm90vPLf62xvWJmm+2YXwjFqJanUVG3
        bp3rdHPHSzGK466J1hrrNkg=
X-Google-Smtp-Source: AGRyM1ulqyAb4/mEof+6ZmLX6fDypco+ES2GGDjas9Fvn/zPh50a1MDHhWjsJ6ox+kdLfYgegg/x1Q==
X-Received: by 2002:a17:907:8a25:b0:726:c9f2:2f5e with SMTP id sc37-20020a1709078a2500b00726c9f22f5emr687054ejc.286.1656360160702;
        Mon, 27 Jun 2022 13:02:40 -0700 (PDT)
Received: from skbuf ([188.25.231.135])
        by smtp.gmail.com with ESMTPSA id x2-20020a05640225c200b00435651c4a01sm8145270edb.56.2022.06.27.13.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 13:02:39 -0700 (PDT)
Date:   Mon, 27 Jun 2022 23:02:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220627200238.en2b5zij4sakau2t@skbuf>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
 <20220624125902.4068436-2-o.rempel@pengutronix.de>
 <20220624220317.ckhx6z7cmzegvoqi@skbuf>
 <20220626171008.GA7581@pengutronix.de>
 <20220627091521.3b80a4e8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627091521.3b80a4e8@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 09:15:21AM -0700, Jakub Kicinski wrote:
> On Sun, 26 Jun 2022 19:10:08 +0200 Oleksij Rempel wrote:
> > > Is there an authoritative source who is able to tell whether rtnl_link_stats64 ::
> > > rx_packets and tx_packets should count PAUSE frames or not?  
> > 
> > Yes, it will be interesting to know how to proceed with it.
> 
> I'm curious as well, AFAIK most drivers do not count pause to ifc stats.

How do you know? Just because they manually bump stats->tx_bytes and
stats->tx_packets during ndo_start_xmit?

That would be a good assumption, but what if a network driver populates
struct rtnl_link_stats64 entirely based on counters reported by hardware,
including {rx,tx}_{packets,bytes}?

Personally I can't really find a reason why not count pause frames if
you can. And in the same note, why go to the extra lengths of hiding
them as Oleksij does. For example, the ocelot/felix switches do count
PAUSE frames as packets/bytes, both on rx and tx.

> > For example KSZ switch do count pause frame Bytes together will other
> > frames. At same time, atheros switch do not count pause frame bytes
> > at all.
> > 
> > To make things worse, i can manually send pause frame of any size, so
> > it will not be accounted by HW. What ever decision we will made, i
> > will need to calculate typical pause frame size and hope it will fit
> > for 90% of cases.
> 
> :(
