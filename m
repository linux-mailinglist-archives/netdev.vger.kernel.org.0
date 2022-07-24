Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771C857F7AD
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiGXXVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiGXXVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:21:02 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3423C25DF;
        Sun, 24 Jul 2022 16:21:01 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ss3so17506153ejc.11;
        Sun, 24 Jul 2022 16:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=/fstXUat/D3R+/oqd7Lu3xW263QleA/JR+y2rPeEERQ=;
        b=MhesJ8fmE/QZ4o8jbp/RE6pBWZflM+ib2M2OqBYK4/62UDdi87D3PkYtNJzX4KswBH
         hhAMGcO6800OHiDZ1qkHZ4t/G3vMjiT/vZnH+FoeethuxKnSlIsN6Th0rjbYqj6BmVx2
         6MetNYCDO2+pYQ6J7zgdlJy0g/s7HmMpLvhrAPkPh/1XHK3twWSyqTHCFv9JrFIaE3Cs
         rVc6eKJ1XscyY/sjHjyRMyEYt28N8HAaKhIMzpJNObPPnZUi46AWZtpZNJ88vZob7RzM
         XVwG/cPY6rIZvj39uY3ZP0yoKpCckbOZNouhHcWKeqp2V2xbzQ1LVHj7ODcnf90PVWz4
         Y5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=/fstXUat/D3R+/oqd7Lu3xW263QleA/JR+y2rPeEERQ=;
        b=M40BkjESHpzVB7rwp6nsh5wWMKdN4yZ5dNDg5WuGREuS3lEpTAz59hXsAL8j5tiqe4
         Hi52bJCwy3yz4U39rq87Ckibxq9TV3NDGKkOscPsMRnqsP6+BffLG5JFw7/IG2XY+KN4
         HWhDtoYu3e0vY54//SdOAkxjhjYCWlXKTUixteQCqtxlP1CmamlChURAdC9aqzPpGh9c
         Da1Midr64xLd2l04rFwINJCI8ElBQBmOYvLYo141NVUpPFV3V4Ne/EXof+oYVbRAaKjs
         +OmbPjwTE0LuCWDhEpa88GuAnjfHVIw+4GDXUzxjJoySp6JguMd9Nc4xmEt/xgF+fpuV
         PRqA==
X-Gm-Message-State: AJIora+dQlbUhrP7sadSQf/bs5tXZldtH7lwMey2PPvzCnaiMVddky5s
        LWqJ4HwnYYPx9rN/yJopSJQ=
X-Google-Smtp-Source: AGRyM1uJJXLGupAbCSW6E6Dya9UA5CKTInT4IcAoKK0Mj47kFxqGQd7bdZ4t+gFxewH0b5niMOWBRg==
X-Received: by 2002:a17:907:8a1d:b0:72b:9e7b:802a with SMTP id sc29-20020a1709078a1d00b0072b9e7b802amr8117514ejc.189.1658704859713;
        Sun, 24 Jul 2022 16:20:59 -0700 (PDT)
Received: from Ansuel-xps. (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906218100b0072f07213509sm4711884eju.12.2022.07.24.16.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:20:59 -0700 (PDT)
Message-ID: <62ddd3db.1c69fb81.d8b0f.a851@mx.google.com>
X-Google-Original-Message-ID: <Yt2wZUETG129QTl4@Ansuel-xps.>
Date:   Sun, 24 Jul 2022 22:49:41 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 01/14] net: dsa: qca8k: cache match data to
 speed up access
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220724223031.2ceczkbov6bcgrtq@skbuf>
 <62ddce96.1c69fb81.fdc52.a203@mx.google.com>
 <20220724230626.rzynvd2pxdcd2z3r@skbuf>
 <62ddd221.1c69fb81.95457.a4ee@mx.google.com>
 <20220724231843.kokvexqptpj4eaao@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724231843.kokvexqptpj4eaao@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 02:18:43AM +0300, Vladimir Oltean wrote:
> On Sun, Jul 24, 2022 at 10:42:20PM +0200, Christian Marangi wrote:
> > Sure, it was just a stupid idea to set everything not strictly neeeded
> > only after verifying that we have a correct switch... But it doesn't
> > make sense as qca8k_priv is freed anyway if that's the case.
> 
> I don't understand what you're saying. With your proposed logic,
> of_device_get_match_data() will be called anyway in qca8k_read_switch_id(),
> and if the switch id is valid, it will be called once more in qca8k_sw_probe().
> With my proposed logic, of_device_get_match_data() will be called exactly
> once, to populate priv->info *before* the first instance of when it's
> going to be needed.

Just ignore... it's me trying to give a reason for my broken logic.

-- 
	Ansuel
