Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A1F578BC8
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 22:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbiGRUbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 16:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiGRUar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 16:30:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB872E9FE;
        Mon, 18 Jul 2022 13:30:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z23so23440536eju.8;
        Mon, 18 Jul 2022 13:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TOuOgoVnhkOM913pnbYCYXErgh3ENiex7o53ls48oOw=;
        b=VbrqZxTeDuN/SNRIMZFkVV4M5SndiJxfszssKBiB/jeQFFjl8U5dwafDXPwWz07+I3
         i3x2WSA+1/zjMttMVmFLITSisvkWIELD1K+GYdRG194fTDP/77o0zgfD2KRttd/rpBD/
         /jfBCwL1bqZ2eyzqHehajZCs6EhTu8MKoFyycL8lpySD2nfoASPpJBlSlrrrQjzKRLHO
         v4BJgI7ME6tYxvAXaa26v91gBF3KURIhwwiSXbHDZ2DzsWKb6vpT9McIHnH462oyxb1U
         3uAAI6KKKxSpibvqhSACc6NkngHHXe8DwiYfAJ3Vq45562YjjpGx9a+WnYyouN9+l+bt
         jv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TOuOgoVnhkOM913pnbYCYXErgh3ENiex7o53ls48oOw=;
        b=aq7fLhc4zHbiGh4fWnaeP3LH3jGpzeH6iYWzmlqTCZtwc8AFBjNlG4pZaX+AkQSzs+
         zj38PwiyP19Mt1yimBLa6Q57+LonoBEpiP9plrtT5feUl4rLHmvjgN2RHujUNbPD1JVT
         vjdKJBddzuRJqS8mILqXyQO7J5lPHmw4MMBXYBmSrO6AkSpbC4DyjE0fufkLFWyTuF9e
         WHgHIBnjKAF2g2aIstsYDvVOudUtHLRH2UINo/Z+XzaOHd/tFgwdXh8z1YkeOAQf9Qi+
         MHHB3vnRLfjjD5bc05x6F1DJTqAc00XTzC1dF8WIpCUh73JMoZzeInrCaHVXKdArtgsz
         q4pQ==
X-Gm-Message-State: AJIora/YT1XCr6X/FGOcIvXOYGPHL0OgmIa1lqVZPfYkKx+hlWFcL1Vo
        amvnIoph7CQdxO64riubvg4=
X-Google-Smtp-Source: AGRyM1tf1/duln7n+VJP6zXjePD9gampRf4VzjnTi6th8i9xDHKf7VbDh0d5ZpVAXrjqe4Na3Fegww==
X-Received: by 2002:a17:907:3e15:b0:72b:879a:eec7 with SMTP id hp21-20020a1709073e1500b0072b879aeec7mr26826121ejc.136.1658176245373;
        Mon, 18 Jul 2022 13:30:45 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id o22-20020a170906769600b00722dceb3f8bsm5899663ejm.151.2022.07.18.13.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:44 -0700 (PDT)
Date:   Mon, 18 Jul 2022 23:30:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
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
Message-ID: <20220718203042.j3ahonkf3jhw7rg3@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
 <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:30:58PM +0200, Christian Marangi wrote:
> Tell me if I got this wrong.
> 
> The suggestion was to move the struct dsa_switch_ops to qca8k.h and add
> in the specific code probe the needed ops to add to the generic
> struct...

The declaration yes; the definition to qca8k-common.c. See for example
where felix_switch_ops is, relative to felix_vsc9959.c, seville_vsc9953.c
(users), felix.h (declaration), and felix.c (definition). Or how
mv88e6xxx_switch_ops does things and still supports a gazillion of switches.
