Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE44599B81
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348716AbiHSL7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347592AbiHSL7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:59:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE26C6B60;
        Fri, 19 Aug 2022 04:59:38 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e21so531479edc.7;
        Fri, 19 Aug 2022 04:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc;
        bh=OFbstuxh2bM00OlidvhlMfZ5HY1I75qAICyPsDUJ70Y=;
        b=BO95pDtWkzJrDZfzILRRYN7GrY3Hnz3RqM3ZNMuGI1FC3WfZQ5P+c5D73FTi4mEs2j
         Jub1BH/HYKTPwoLXYzUAlcDx7+XKfyORexNQ/dU5y/eb4VD3RUG9N0/qiDoEMrtBCyfH
         udo10JlvI1DRloNgVjvIIY1zAMF0nYMwnN+3TwIWttFZ1JrUpJINL+ubOiDY3sWZK2xh
         /Ecxrl2Xicoxtc34yDJ00SzeHUZwTtLGxneGyLFR/SY8IGUc76EnCwF7FwX4YZUmFw6l
         jsAbrNskECodtzXG6WG24P34Fn0sD+4EgULBrvRkYWShUyIEgQ8A+nqzMvFYTak4zA/N
         CkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc;
        bh=OFbstuxh2bM00OlidvhlMfZ5HY1I75qAICyPsDUJ70Y=;
        b=eFbpvyDHk3XH9okWmqHFxMyVCFsDWHY5ePqflyfyqtqXgabW+U0e2kURw/18Q7zShX
         papafXxswXJqAm9GpahfEQ3Dhrd9LK43EljoRbqw0Gc0gbOXq+krrrgrCHePhfZv42SH
         IaOwuDizGboZw43tMuczAFGl3lFAhAQhsecSfol34aU3Wa5/hfYv46QLM5nNFANjh50V
         bUYZzjXnbkhB4IYHzV3YIdVl0AZZ3aC0J+jhQylH0ZNZAw9W0zPTWG0icJh5j6c4yrvP
         6dj18ggcodVS+VSs7Sw1IuN/j0Ie3/vFhiFRndkFbilgtzmZOlQ10NxDJw43ajTkojjH
         ORzw==
X-Gm-Message-State: ACgBeo2izRGo9DcxKAFnzo8YE/COdQj66B0ELynw7bZ+3Qhhp09PJNFR
        dHbDfjIsYc3wAPGQLPnIRPQ=
X-Google-Smtp-Source: AA6agR5+6v4xRQkCgYSr0SgKCtDdo+WH/SiJO/XJBRmGpNFZoYhAvvs0LMK2+lBFa4Bh1phS9IMOFw==
X-Received: by 2002:a05:6402:4282:b0:43e:612c:fcf7 with SMTP id g2-20020a056402428200b0043e612cfcf7mr5785323edc.242.1660910376823;
        Fri, 19 Aug 2022 04:59:36 -0700 (PDT)
Received: from Ansuel-xps. (host-95-250-253-218.retail.telecomitalia.it. [95.250.253.218])
        by smtp.gmail.com with ESMTPSA id r9-20020a1709061ba900b007317f017e64sm2222207ejg.134.2022.08.19.04.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:59:36 -0700 (PDT)
Message-ID: <62ff7b28.170a0220.91820.52c8@mx.google.com>
X-Google-Original-Message-ID: <Yv93fbdoPfRAaR0P@Ansuel-xps.>
Date:   Fri, 19 Aug 2022 13:43:57 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net: dsa: qca8k: convert to regmap
 read/write API
References: <20220806192253.7567-1-ansuelsmth@gmail.com>
 <20220806192253.7567-1-ansuelsmth@gmail.com>
 <20220818165119.c5cgk5og7jhmzpo6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818165119.c5cgk5og7jhmzpo6@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 07:51:19PM +0300, Vladimir Oltean wrote:
> On Sat, Aug 06, 2022 at 09:22:53PM +0200, Christian Marangi wrote:
> > Convert qca8k to regmap read/write bulk API. The mgmt eth can write up
> > to 16 bytes of data at times. Currently we use a custom function to do
> > it but regmap now supports declaration of read/write bulk even without a
> > bus.
> > 
> > Drop the custom function and rework the regmap function to this new
> > implementation.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> 
> Nothing in this change jumps out as wrong to me, but maybe you should
> copy Mark Brown too when you submit it proper, as the first user of the
> bulk regmap read/write over Ethernet, IIUC.

Should I send a v2 without RFC and CC Mark or CC directly here in the
RFC? This is ready so v2 won't have changes.

-- 
	Ansuel
