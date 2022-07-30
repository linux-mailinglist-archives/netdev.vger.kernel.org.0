Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E732585B2F
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 17:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiG3P67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 11:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiG3P65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 11:58:57 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCD8DF55
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 08:58:56 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z18so8943580edb.10
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 08:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=DnMOj9t6t4ctngwIKooiACvAQ9sK4xzMu2PPkAQAu/g=;
        b=Lm36qD60gTl71mOhvLTF1M3ke2Ps/QMCQJBZ2PKCdqjBO/d8pVO1u15G3Cy0BFI70I
         mdAvV69w0znzx8EoXgNV7/qLhv640J3w/sxyUEtL5XdGryntlfLxrYlHXDSqOYFsVgI1
         xT5TFW8jm8ZvztRjcxDIfEmK4tMCrL1FhmRGnzT/tnrdCY1rz1KYQWIk6cRxq9vwm3tZ
         rAiRZafZEKct+ODE1Pn8NmAOSkR6f0cYpqaikwh83JVlX8Y5NCE61gec0Ih32RZQPOw+
         j8WVxWoFiMBg+zMk1cDGcfl6ndJybZnfNxvmlSYDiOqkoY11V8GghT0FctU9bsmejJ7N
         pC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=DnMOj9t6t4ctngwIKooiACvAQ9sK4xzMu2PPkAQAu/g=;
        b=DKAZNtSpQ2jAKg2jcyDdN3a0NSFosaBP0DMMkeZ6AWtRXpccuCRcz5/tW2yk7wVUmZ
         jPcvOoXPdGWttT15Qp0vcxrCPa83zm+ICXzxosxwS3CyX+A9xP9xod7sVG8YgsExEZzI
         PbY5H9Rgx3yK4TFnMPuVqvqW9PfOvRMCfWBz0Qe7ktuGl6Yru8cUnRy039SlznyX/VYp
         x5AGwP06/+k1AOiw3pGiGbtCwMefXIxSDAEeeSH3lo2N41yepAgyQvO90rLdtnGmLra+
         jhHBICNOSK5HR9syWxEnHJsqGiy3hTt2Ee1brENXPb9l7v4WG/4ajKiRS8/zg7TM+k+R
         q38w==
X-Gm-Message-State: AJIora+G9A5bAPz14ZbE1j+bYhGcwqGgK2r3uA5qXCwsHSLBS2r/fYcH
        twKoF6NbqBRPhfWWHdb1LeG9vdkGwSA=
X-Google-Smtp-Source: AGRyM1vCbsWg31k0PCdbkMBNqTjXrQ/G1fV+uisBV1voK854XWf9CWDdkboY33zxzXTcr8vT4pNHcQ==
X-Received: by 2002:a05:6402:4516:b0:43b:c806:6346 with SMTP id ez22-20020a056402451600b0043bc8066346mr8286356edb.52.1659196734474;
        Sat, 30 Jul 2022 08:58:54 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b9c0:f700:d5b:898b:b7ca:1bf3? (dynamic-2a01-0c23-b9c0-f700-0d5b-898b-b7ca-1bf3.c23.pool.telefonica.de. [2a01:c23:b9c0:f700:d5b:898b:b7ca:1bf3])
        by smtp.googlemail.com with ESMTPSA id h22-20020a50ed96000000b0043c0fbdcd8esm3959295edr.70.2022.07.30.08.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jul 2022 08:58:54 -0700 (PDT)
Message-ID: <ca9560eb-af9c-3cfa-c35e-388e7e71aab7@gmail.com>
Date:   Sat, 30 Jul 2022 17:58:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Meson GXL and Rockchip PHY based on same IP?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meson GXL and Rockchip ethernet PHY drivers have quite something in common.
They share a number of non-standard registers, using the same bits
and same bank handling. This makes me think they they may be using
the same IP. However they have different quirk handling. But this
doesn't rule out that actually they would need the same quirk handling.
Eventually it might be possible to merge both drivers.
When working on the Meson GXL PHY driver, did you ever come across
this similarity?
