Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08C54E6B06
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355636AbiCXXL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355629AbiCXXL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:11:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830C43C730;
        Thu, 24 Mar 2022 16:10:23 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b19so8590491wrh.11;
        Thu, 24 Mar 2022 16:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tbjCi9BsUij3nR57dqM2ZzzadZf5l8MvfHznVXR9JoE=;
        b=PFUwOKUjCQXLf/GkyGG/rFIcUbskVDHfqJIMmv1ZYzpdPABJjzPRxv8WUIQGWN6egd
         qae33RaA2jzhpIDT8TzmyxA+wvg18pmO+bsehQF673boXep+DzmoFP0d7W68INZkHwNr
         ovK7yLfBSAR4GThavV2wCxZyGg1aAKg5aIngO5L3JoR367z8padmpXW+aJzhWiLm29PZ
         wnSxPG2GLHOKfk+cN2WbGecpSBJ5q7nLLjZWi0jes7VoXOOinvrPKCZMrG9GA7+UdEpj
         ukC+pHzO7ZlwLv6pso/SpcC+muYFacESQZfWfk9ui++vUMnw92RGq1DpoHodO7sRFJZ8
         cSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tbjCi9BsUij3nR57dqM2ZzzadZf5l8MvfHznVXR9JoE=;
        b=aaWjCRP0XLo0qJGdZMB82ULl0Esvzz8vUzZfhPxnM8G+e4Bx4tJqiWbhGAXBLb30ie
         nyEZwE/cES2oM/yY4hxKDOGzzGjo1mrog61Lap7I3MwZ0zI570YjqpybrccyxEvEUx8Y
         SiBkR6JAvw4TafIEHX1qjap55HJ72mRgIIwny2lsfZh5X9PoSZTssffVQLvjIgpUOG6Z
         j0Fz2ZVJXLpV56WyLlgBgnQnGvf6zqjfaCSqwEe7TKdwuqSCCrmfhaJff72e87pKFHF/
         mQd2Q7BRyss88htyWOxMThxfLqO6o3io8TTroKDsgolzsjOrIUl0kxESAaBN8AxtBbEu
         2SXQ==
X-Gm-Message-State: AOAM530t+87wLkr1itjuNSFzoN1ftePvcPuivXU9QfVEF2EkEnfa1ydm
        t2QA9yJirzFHbpJZoUpPJwQjVeu9wZQ=
X-Google-Smtp-Source: ABdhPJwsjAVgLwD1Pt9I6LtAY+Vz1gOMYKfQN9m+XDMCao8N9KrAE0e1X9OQSR4ypYq9uRmfIhDjpA==
X-Received: by 2002:a5d:60c5:0:b0:203:f85a:2ea3 with SMTP id x5-20020a5d60c5000000b00203f85a2ea3mr6529362wrt.316.1648163421753;
        Thu, 24 Mar 2022 16:10:21 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.gmail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm3630295wmp.44.2022.03.24.16.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 16:10:21 -0700 (PDT)
Date:   Fri, 25 Mar 2022 00:10:19 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <Yjz6WxkElADpJ5e7@Ansuel-xps.localdomain>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
 <20220322135535.au5d2n7hcu4mfdxr@skbuf>
 <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
 <20220324104524.ou7jyqcbfj3fhpvo@skbuf>
 <YjzYK3oDDclLRmm2@Ansuel-xps.localdomain>
 <20220324210508.doj7fsjn3ihronnx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324210508.doj7fsjn3ihronnx@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 11:05:08PM +0200, Vladimir Oltean wrote:
> On Thu, Mar 24, 2022 at 09:44:27PM +0100, Ansuel Smith wrote:
> > On Thu, Mar 24, 2022 at 12:45:24PM +0200, Vladimir Oltean wrote:
> > > You need the max MTU.
> > > 
> > > Why calculate it again? Why don't you do what mt7530 does, which has a
> > > similar restriction, and just program the hardware when the CPU port MTU
> > > is updated?
> > >
> > 
> > I just checked and wow it was that easy...
> > Also wonder if I should add some check for jumbo frame... (I should
> > check what is the max MTU for the switch and if it can accept jumbo
> > frame+fcs+l2)
> 
> I'm not following you, sorry. What is your definition of "jumbo frame",
> and what check is there to add?
>

With jumbo frame i mean frame with MTU of 9000. This is supported by
this switch. Anyway i just checked and the reg can totally accept a 9000
MTU + fcs + l2

> > Wonder if I should propose a change for stmmac and just drop the
> > interface and restart it when the change is down.
> 
> In the case of stmmac, dev->mtu is considered from stmmac_fix_features()
> and from init_dma_rx_desc_rings(), so yes, putting the interface down
> before updating the MTU and the device features, and then putting it
> back up if it was previously up, should do the trick. Other drivers like
> gianfar and many others do this too.

Ok i'm reworking this in v2 with the stmmac change and the change to
change mtu following what is done for mt7530. Thx a lot for the
suggestion. Happy that the additional space can be dropped and still use
a more correct and simple approach.

-- 
	Ansuel
