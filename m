Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B1157A41D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbiGSQUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiGSQUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:20:47 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8EB4E611;
        Tue, 19 Jul 2022 09:20:46 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ez10so28100705ejc.13;
        Tue, 19 Jul 2022 09:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LZRw9Jbxai2aWRRK093mCGgxgti+hlVssSiQk+LLoSw=;
        b=I9928u0qfeMVkZFesiq24zxJAM49+C2Oy0YABt4O4zbb7GB0Rpqi37Ra7+AoHvxDTK
         1v1YDexY2/U6g1Ny0IluzE7KSediqaEJfV+7E7NTA4z1DI1nqGqfuBEfkUMwYw+jpCm8
         bdlDoASbmlasuYAefNZ+eDuBiqH9AqlE32BAel+7PvUWNZ06cavFCglF031uWW9nYc+O
         kbvnYw0zWDXf2hmprc+UYr2ywryQqAheAU69k96jFv09zw8DMwcmsd8JTapbYxDsxnhM
         ip7o8oTorUO+pkaBdfZ1sXvJcMULn8RiXw6o8EuzU2g+tZlxlJJtJpJUqYlb9zzJ3uRb
         5SHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LZRw9Jbxai2aWRRK093mCGgxgti+hlVssSiQk+LLoSw=;
        b=bZKiL+9/BmfmGNjPi91Vi5sCMB3Pn2DnbiRjfYR21bz67Erqo5UkFVkMeuQ/CgpLv5
         iJyZ2hN74ttuLo9dyFzJDdGvNukX9VRBxDQDPwUFEyZ53laZpv3G85fmk5l/D2hHSWyp
         NcHN4Bl85bTJBTF/3LDbO8QQCOqkvFUGT8RMZfY3tUyMkr2yC1GLkm4k46zHNtF6DZAB
         qiJO4wQxqHDAb52CXyYbLXTZ7jkbSORBe1MwbCjeDaC4MysGBy6q800cVM/uqDEBmf23
         oOi8hJfKYZewqtzj1F+t9zYRE0qr7ZN9LLRksnPgYLLnlaZ4zU6qlTihHbjKheIwMUJG
         vltw==
X-Gm-Message-State: AJIora+eFXcxrayIvT2OAiAODiucaaNHWYqb5x/nsNftLT6PALoYOFYg
        gqVDcCYG95BW8OHUZMrhQrQ=
X-Google-Smtp-Source: AGRyM1uygjE5zWKt0bMkcTfCXqLOrtAbC4VkqyMHi+NtgKazzzS7X0jJFxQ25R13Sg+IFo9/XoTAFA==
X-Received: by 2002:a17:907:72ca:b0:72f:1a9b:361b with SMTP id du10-20020a17090772ca00b0072f1a9b361bmr15226261ejc.274.1658247644909;
        Tue, 19 Jul 2022 09:20:44 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id fp34-20020a1709069e2200b00722e8c47cc9sm6733157ejc.181.2022.07.19.09.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 09:20:44 -0700 (PDT)
Date:   Tue, 19 Jul 2022 19:20:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 4/9] net: pcs: lynx: Convert to an mdio
 driver
Message-ID: <20220719162041.y7vf3le5hitfsbkm@skbuf>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-5-sean.anderson@seco.com>
 <20220719160117.7pftbeytuqkjagsm@skbuf>
 <201ba777-f814-0e3f-6e1e-0327934a7122@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201ba777-f814-0e3f-6e1e-0327934a7122@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 12:16:17PM -0400, Sean Anderson wrote:
> > Curiously enough, mdio_device_create() only calls device_initialize().
> > It's mdio_device_register() that calls device_add(). So after this
> > patch, we cannot call lynx_pcs_create() without calling
> > mdio_device_register().
> 
> OK, so presumably we need to call mdio_device_register after mdio_device_create.
> I suppose I should have caught this because patch 5 does exactly this.

And that's only to not crash during boot, mind you. Networking is broken
at this stage. I'll proceed to patch 5 to see what happens next.
