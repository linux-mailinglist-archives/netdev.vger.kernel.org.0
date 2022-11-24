Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCAE637BE5
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiKXOxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiKXOx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:53:28 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A3863CED;
        Thu, 24 Nov 2022 06:52:53 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w129so1805303pfb.5;
        Thu, 24 Nov 2022 06:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nVlVHt+rR1A/mnk2+jRjQKtqfAREMkBc59LU4VGb4YI=;
        b=dpGIad4wwM4Ko4bgzazYPSDTevzuPXHWxDTLCA8Vn9qYhSmYGCH3TKfYwnVKnkA7Na
         KA4lka8l6q3FxKDk2zZ6+tqcD/MuDaFwJXLNcPTH8ORHd47VRWHrDAGG8eeDHjwGbDe6
         ZKvh/HclcB1C9ahqVqrz07i4i5wpX1fpnlkiY/vvu8B8b97UVHSAjPdI0COnbrX7zVy8
         aqVL5vSCK1vNtP+d0UYE6F2fDo8/FUYcIe5A1PcpD2azH97QoP5fr+dLQmiFIAY7+KRG
         0tll/7s/HHppZiOCEyeKfok0WzWjVARBVS17i4gKf0wK/HRYW2ttTfTrKOJjuQnG1UmR
         xiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVlVHt+rR1A/mnk2+jRjQKtqfAREMkBc59LU4VGb4YI=;
        b=ewh5uoHDR9iMbm0cgg4ljrlFgtgXli4/D5e/9BOR2t8IIxGHW1PAr59a8gvuPFK8BM
         RwFVO3++cS8qPaFqw84xLU+qlI5qlgbOELk7pTcSZJTOA0Xwd0oVNVrFHGsJVFhBIWdG
         43KORkPXAY1nt4mqlOyzzXX67ZSBokcTm0IIkBgVHBxdAgulZY2Sa8UywneMcpTXzCvk
         iTOSVpC42SXqWlAcZU6B7fNNhjMhnAbrarnu+4f5S56ZCOJxWj87ElEOxPqBlfvG+tiH
         hgdPTTli5NYq8pP2hv/532GB7rhMX1vp/6CLjFOQpLmCmlvYguZALEH2YKcPuFibcbHV
         Bu3g==
X-Gm-Message-State: ANoB5plWYrSf67zB+y2Mrh6Ch4BX/4UE0Y1coGgcYT3BKekoiuVbmuz4
        I0QUK3XlmR8HPM+79KDkPe8=
X-Google-Smtp-Source: AA0mqf6ksphTgejqw7AwvHkgzVLNNLHOOATIP9RvebA8dRm5a/YiyHsRQ3HGt2gx6tG+NpB9s5ZWlw==
X-Received: by 2002:a63:1345:0:b0:476:f92f:69f0 with SMTP id 5-20020a631345000000b00476f92f69f0mr30631067pgt.463.1669301572765;
        Thu, 24 Nov 2022 06:52:52 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q5-20020a17090311c500b00182a9c27acfsm1401826plh.227.2022.11.24.06.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 06:52:52 -0800 (PST)
Date:   Thu, 24 Nov 2022 06:52:49 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [RFC Patch net-next v2 1/8] net: ptp: add helper for one-step
 P2P clocks
Message-ID: <Y3+FQeOoE+N7X0hC@hoboy.vegasvil.org>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-2-arun.ramadoss@microchip.com>
 <Y3zd4s7c3TPKd/Rb@hoboy.vegasvil.org>
 <8de1953d8297c506b58d960fc56edee135d7d8c5.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8de1953d8297c506b58d960fc56edee135d7d8c5.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 07:10:58AM +0000, Arun.Ramadoss@microchip.com wrote:
> This patch series is extension of PTP support for KSZ9563 patch series
> submitted two years back which is not mainlined.
> In that patch review feedback, it was suggested to make this function
> generic and so it was moved from ksz_common.h to ptp_classify.h
> 
> Link: 
> https://lore.kernel.org/netdev/20201022113243.4shddtywgvpcqq6c@skbuf/
> 
> 
> https://lore.kernel.org/netdev/20201022143429.GA9743@hoboy.vegasvil.org/

okay

Thanks,
Richard
