Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B2A62443F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiKJO2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiKJO20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:28:26 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE6959FFC
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:28:20 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id t25-20020a1c7719000000b003cfa34ea516so4138115wmi.1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OuqFxBaxjmGS8vHZWox+dggoZc9OmvY8M2AfXlJU0R8=;
        b=ajB4H0a6WchJa0TPWnDA1l/S+VvoZ3Aignfw6CB9Khx3EoOmQz44WmdZiFDiyT8HPr
         vhS2DnKWKgwBwtJFo+8YpY3GPf0zMSsP77e24ilWvDsNMLljfY2XdzU+r3YwiUdUhvwo
         3p3tiRt9l4IGufdRwdmUXmnIhO819CXw3f4UOaO27j65iaa9fA+/kjALT6qJXTJBQxg3
         BRpjuadfyxlv2JM124CSdCzNfP/y+tO83csk4O8EjXIZtxz8p0AQ5SijYXhMqZu5NLqS
         x00/KKWiZ2u5livNVfGkCJUKZFkWtHwe9519WNHg9b58Au8LsukUQ8WYj0qyhEzVD6pT
         fLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OuqFxBaxjmGS8vHZWox+dggoZc9OmvY8M2AfXlJU0R8=;
        b=K+SlZNHDVsBmuUeTtmMqdCV2c27XWCXDMIHp9ZbA2KF70t0ABtyAGrvHEdKtBH74A7
         YL1tiMMfxxXBWTb+IqmH3R6v4BR9Tr57PMd19FQvReamiyxOowuV47KexMuKpvJns56r
         LmvTBynUxvkAC8JdA0dYBAczBxFMdX/4EpcQXzAup1gnGdPdPdjpxf1YPTle00JrVH1u
         A1YVKnhY4wndCX8GXtgcxieOvHoGs4CZrhRFtSNGSmSb/iHq1PyuvnB4UjdthV7M/gsw
         S881NP+MReUXupySqCNQixJDqOXX8k/9MUQvaSiW4f51ED8in0SKX5WfcSQHmM9pZoZm
         OtgQ==
X-Gm-Message-State: ACrzQf0jwtbsDCHkA2SZ3IXGKrIOLStTcxPDgyXDC4SzRU/NSGy1Jb34
        fYUSEDcXSauTwzExlhalVhg=
X-Google-Smtp-Source: AMsMyM7TvV/ACzOcKSosDbshDfkaAHOF9iaM7AWChs0Ym7t4LKZ1i41uQlxxpykDs92oIW1yI12Jkg==
X-Received: by 2002:a05:600c:1994:b0:3cf:7c1e:8227 with SMTP id t20-20020a05600c199400b003cf7c1e8227mr33822528wmq.103.1668090498922;
        Thu, 10 Nov 2022 06:28:18 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id m12-20020a5d6a0c000000b00238df11940fsm16202285wru.16.2022.11.10.06.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 06:28:18 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:28:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next v2 00/12] Multiqueue + DSA untag support + fixes
 for mtk_eth_soc
Message-ID: <20221110142816.nzy4sb27km7xpctd@skbuf>
References: <20221109163426.76164-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 05:34:14PM +0100, Felix Fietkau wrote:
> This series contains multiple improvements for mtk_eth_soc:
> 
> On devices with QDMA (MT7621 and newer), multiqueue support is implemented
> by using the SoC's traffic shaper function, which sits on the DMA engine.
> The driver exposes traffic shaper queues as network stack queues and configures
> them to the link speed limit. This fixes an issue where traffic to slower ports
> would drown out traffic to faster ports. It also fixes packet drops and jitter
> when running hardware offloaded traffic alongside traffic from the CPU.
> 
> On MT7622, the DSA tag for MT753x switches can be untagged by the DMA engine,
> which removes the need for header mangling in the DSA tag driver.
> 
> This is implemented by letting DSA skip the tag receive function, if the port
> is passed via metadata dst type METADATA_HW_PORT_MUX
> 
> Also part of this series are a number of fixes to TSO/SG support
> 
> Changes in v2:
> - drop the use of skb vlan tags to pass the port information to the tag driver,
>   use metadata_dst instead
> - fix a small issue in enabling untag

Please split the work and let's concentrate on one thing at a time
without extra noise, for example DSA RX tag processing offload first,
since that needs the most attention.

Also please use ./scripts/get_maintainer.pl when sending patches ;)
