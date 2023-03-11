Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52916B5DDE
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 17:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjCKQ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 11:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCKQ2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 11:28:30 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED6015C8F
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 08:28:28 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id y11so8721901plg.1
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 08:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678552108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htD5j8a2jQuFjKyPL5/RnOfg+yRRERl7hQx+Mdv1PFM=;
        b=KCHAKBaGduJF/vLv/9bANKgiKKBUyXjCGwmVOm4ISNqTP6Tc2emh1FgmehzjmBq5K3
         8PhKzcMn8jImVVTFg+ghja45UhBMLOYcDgDl8KI0coRRPUmDmBZrmPmm9jXKn6FkwPNi
         yarRtut/O4oAq7zKFUc3MuvePvyrwQds9hqvOoBgkQRKAt4p4dHmuBcS761/Zv1n1WyG
         yePzwCymQSKZd0BLnax6Qe0ZGENWSfincEnAS0SGm73kfPZV0eeYwfBWvZ3rDyVAfozg
         6QuSHbCGDMMOer0MZtcAX/hjuxayiKudVUh2c6esNvJYLPaHDvQgVsyAjOTGsoN6YSuB
         lwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678552108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=htD5j8a2jQuFjKyPL5/RnOfg+yRRERl7hQx+Mdv1PFM=;
        b=eVKg+kXbXt/5Hd1j3cTwOgjF+BBtuMF/IjxEbndNZzj4h00IGpYjYCfbFMze15uyVS
         uZ+kCjYygNFP6UkgbNjFoGvzc+fX4tGRV5klKVT9JEVg3sdArFoPS85PCRFGKNsFQk8x
         d8itkH6sRSlczH5P0EDIh/n0z4yhTFXsg/JPUib2s00sH+rF4glzh00RZiY3XrWT8mVp
         ksqB1NpcoBqbM7MumC2z1R5jlyFTu9Zy9LWUNv9tUMEZk/7EMscoJEIcaPRzDbzYsuXo
         1LsF+fl2zYudcYASYOOzC3MWYudM8e0vsz9qnFEX9s4KzxG1v/ohhBy4ASUIO2za/B5/
         3tGw==
X-Gm-Message-State: AO0yUKVa5/PCQ2A6zDRJUb2eGI7nyEHZZHfxlKRjKNpc53++dSi+5Zm9
        RYjr8Qee2rD0kmX8poX7HQFHdw==
X-Google-Smtp-Source: AK7set/tg6u9rOMpa8MUoN+AbgIhjuY1o5NqynJiLeWHkMLDkX8IE/Hf7M43LbdQVmKpqAtGiU8YcA==
X-Received: by 2002:a17:903:1103:b0:19e:b2f3:e8c4 with SMTP id n3-20020a170903110300b0019eb2f3e8c4mr25460311plh.25.1678552108383;
        Sat, 11 Mar 2023 08:28:28 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090274c400b0019f0e766809sm1697732plt.306.2023.03.11.08.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 08:28:28 -0800 (PST)
Date:   Sat, 11 Mar 2023 08:28:26 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com, roman.gushchin@linux.dev
Subject: Re: [RFC net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230311082826.3d2050c9@hermes.local>
In-Reply-To: <20230311050130.115138-1-kuba@kernel.org>
References: <20230311050130.115138-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 21:01:28 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> A lot of drivers follow the same scheme to stop / start queues
> without introducing locks between xmit and NAPI tx completions.
> I'm guessing they all copy'n'paste each other's code.
> 
> Smaller drivers shy away from the scheme and introduce a lock
> which may cause deadlocks in netpoll.
> 
> Provide macros which encapsulate the necessary logic.

Could any of these be inline functions instead for type safety?
