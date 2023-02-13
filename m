Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311B4694B64
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBMPjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjBMPjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:39:02 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6C619F3D;
        Mon, 13 Feb 2023 07:38:51 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a2so12685631wrd.6;
        Mon, 13 Feb 2023 07:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ER9L7/5f6uhjVfYElKZx3OXqKvldiL4xUMIV23nwQNc=;
        b=iv00oCWzVD1NDSXIFt8NcEMQr4yBbt/juRAurfKe7FMe/Bj1q4d+POBDxUGm/fVwr9
         gflQuE2ZVeYGZ2Sv9+9coeUC+WguejAz/ZcEsMLtNU/NJ5IG2KfcgW6LL3vW3Cw5Co39
         hwEWxWQ/O07WTYcuy8SBNziZe+QGNTGsifZzrGwbe28Mbr85fl/4uKSBjJ5FonYhLReA
         IZ6YEKqeZo2u5PuB/GcRxTs+ElMDsK5jJUzt7uyWaQz0kzGN8HTeHs5Hr8iy9PASFJuJ
         KWoh9IDhUx/gBieAL+c9oL2mC2Rm4zMwK3iYI7vnIj6fSq2XifiroqpkoMPcIKO2Du4j
         P8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ER9L7/5f6uhjVfYElKZx3OXqKvldiL4xUMIV23nwQNc=;
        b=zzs/Fpv+39pjcwrWOXJiUfEJvbVUTVPnS/dvvWt7PhiT5ye8ZeQcexsyjwBV/eREBU
         Z5kodThZ4QImw/RrbWoSRI7NOT18Urk1gxyMkNcdDt+pQfJcgJLrOAOGKtRnAy7VbMuY
         INM2huHn9V+592Y2NNDzmZ5X+g46V04kN854O2OIH2s/ZaiMVGXwRB5pt8wbOrK4Rdeq
         EVCfg4xjSbrb3Hf9GNDMpNz4BUfABwL5Dv5qNSM2i4UyVcQus0M1/zxDNo1zfRg6uEcp
         w/M3pb64IA5Qvb76jpTkL70B15Pzeju2Y9szoAu+lt87ysH5w2lsHh2A2koXr6UlSJxZ
         feqg==
X-Gm-Message-State: AO0yUKWYI4NLq7QZAryx5l3rO6JPcfKDkb3kJItCT73R/k/YIr0qmSZT
        Ug29mIzZFaB9ooyi+HpEqNA=
X-Google-Smtp-Source: AK7set++2HAyahiB/cBZCB/rt2m3nNZCnWeeg5Ei9l17cqJPnCaJa82xRIoIFlQErcTIy50N93pOJA==
X-Received: by 2002:a5d:5904:0:b0:2c5:4c32:92cb with SMTP id v4-20020a5d5904000000b002c54c3292cbmr7720483wrd.54.1676302729330;
        Mon, 13 Feb 2023 07:38:49 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id x1-20020adfffc1000000b002425be3c9e2sm10894869wrs.60.2023.02.13.07.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:38:49 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:13:25 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 04/10] net: microchip: sparx5: Use chain ids
 without offsets when enabling rules
Message-ID: <Y+pTlf+2o0mVEErX@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
 <20230213092426.1331379-5-steen.hegelund@microchip.com>
 <Y+oZjg8EkKp46V9Z@kadam>
 <b755fa1c818639a1e7c11ab3b2ac56443757ac3c.camel@microchip.com>
 <Y+pSKQdcpMw3YGvh@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+pSKQdcpMw3YGvh@kadam>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 06:07:21PM +0300, Dan Carpenter wrote:
> On Mon, Feb 13, 2023 at 01:48:50PM +0100, Steen Hegelund wrote:
> > Hi Dan,
> > 
> > On Mon, 2023-02-13 at 14:05 +0300, Dan Carpenter wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> > > content is safe
> > > 
> > > On Mon, Feb 13, 2023 at 10:24:20AM +0100, Steen Hegelund wrote:
> > > > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > index 68e04d47f6fd..9ca0cb855c3c 100644
> > > > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > @@ -1568,6 +1568,18 @@ static int vcap_write_counter(struct
> > > > vcap_rule_internal *ri,
> > > >       return 0;
> > > >  }
> > > > 
> > > > +/* Return the chain id rounded down to nearest lookup */
> > > > +static int vcap_round_down_chain(int cid)
> > > > +{
> > > > +     return cid - (cid % VCAP_CID_LOOKUP_SIZE);
> > > > +}
> > > > +
> > > > +/* Return the chain id rounded up to nearest lookup */
> > > > +static int vcap_round_up_chain(int cid)
> > > > +{
> > > > +     return vcap_round_down_chain(cid + VCAP_CID_LOOKUP_SIZE);
> > > 
> > > Just use the round_up/down() macros.
> > 
> > The only round up/down macros that I am aware of are:
> > 
> >  * round_up - round up to next specified power of 2
> >  * round_down - round down to next specified power of 2
> > 
> > And I cannot use these as the VCAP_CID_LOOKUP_SIZE is not a power of 2.
> > 
> > Did I miss something here?
> > 
> 
> Oh wow.  I didn't realize they needed to be a power of 2.  Sorry!

The correct macros are roundup/down().  Those don't have the power of
two requirement.

regards,
dan carpenter

