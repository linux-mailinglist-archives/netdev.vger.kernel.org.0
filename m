Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B378578D57
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiGRWLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGRWLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:11:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC0931376;
        Mon, 18 Jul 2022 15:11:53 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z12so19026209wrq.7;
        Mon, 18 Jul 2022 15:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=KhoNbI1/wIdu6SVDPbjXasWJrkQ2kVGR6Zwa7oq3DcM=;
        b=jmxNWExbZtsN3rwoEB7zPuWlh7iDucNSlKl1aDegRkFhtqZRi3UCSKDWRDMsdHcdgx
         +fxwC7bjJdtQ+//2NYCCQUnQ0upbUuGYPFKaQYsrK/2tQXWMLucTxynuK0BS3vJzEEJW
         EKr/cRsuwoLrKuQobulznLwAQnNRjf2dGRBZm1S9p2wW09DvoGS0jS7UwKLMoP2qzY8Z
         yw3G21uqjAshW8iYw1GQfBgbS65gRwzNLwjtFCRUaGZp04FTqG1y+Dn6UA4Sws4iY3bg
         t0LMWyBh63M1oDTdWiNPtVo5Dog+yAo9O+iRc4ImKbnLWrV4bhIFr7TAwQbONPtBqFQj
         LpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=KhoNbI1/wIdu6SVDPbjXasWJrkQ2kVGR6Zwa7oq3DcM=;
        b=00KV8pXXqFWKUJhJ1MiSlCwWSpQfzBLbMOL0JaO4c/Qx8tqac7mCvrE/flwS+l7t76
         PM4VT4H57ml9RxVTEVj+GL8esK3sJHU9DFjaNrmkobLXAAblyO6TrKvqIwGExsQWw8IT
         ERFLSqdruAnTEFRjJpE0Cjdxd/cDw8wJeGkmFbs3J2sNzXlHEPkurl16seFEpH8qSQ4w
         +lfZq+lK6xMwwGnEIuZNjCxjkcx6IxSFZUcuwEQMOtdXM9JVr6z/ddrR7Xv0UpdxXVZi
         3whLqv7BeFRkIiUZCqOkHI+CsGipohGTWIBek6PHKl3jO8l1aNFJ9j6nEOiU6cDWeU54
         Q8UA==
X-Gm-Message-State: AJIora/vrLr+WIZvG0v4fPV/N2Ym0L/mu2/Y1A+aEdiMc4KFZHHPNjYL
        nGaV+mYr0SP5ME3vqwipN5k=
X-Google-Smtp-Source: AGRyM1vVMQXtN6e6Ok1nHQQ/eKlHncOU5kuHKla6+h5eGht2sb6fJOL9sWPJV3atsxWoRYFaVQ1R3g==
X-Received: by 2002:a05:6000:15c9:b0:21d:ad06:f4c with SMTP id y9-20020a05600015c900b0021dad060f4cmr23648446wry.427.1658182311785;
        Mon, 18 Jul 2022 15:11:51 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id ba5-20020a0560001c0500b0021d6c7a9f50sm11576127wrb.41.2022.07.18.15.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 15:11:51 -0700 (PDT)
Message-ID: <62d5daa7.1c69fb81.111b1.97f2@mx.google.com>
X-Google-Original-Message-ID: <YtXWpJGxOT0W0a2c@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 23:54:44 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
 <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
 <20220718203042.j3ahonkf3jhw7rg3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718203042.j3ahonkf3jhw7rg3@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 11:30:42PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 18, 2022 at 09:30:58PM +0200, Christian Marangi wrote:
> > Tell me if I got this wrong.
> > 
> > The suggestion was to move the struct dsa_switch_ops to qca8k.h and add
> > in the specific code probe the needed ops to add to the generic
> > struct...
> 
> The declaration yes; the definition to qca8k-common.c. See for example
> where felix_switch_ops is, relative to felix_vsc9959.c, seville_vsc9953.c
> (users), felix.h (declaration), and felix.c (definition). Or how
> mv88e6xxx_switch_ops does things and still supports a gazillion of switches.

Mhh I checked the example and they doesn't seems to be useful from my
problem. But I think it's better to discuss this to the patch directly
so you can better understand whay I intended with having dsa_switch_ops
set to const.

-- 
	Ansuel
