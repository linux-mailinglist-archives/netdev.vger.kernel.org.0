Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8D640F43
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiLBUpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiLBUpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:45:14 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCE9E5A8D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:45:13 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id c15so5938252pfb.13
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 12:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N2Mw2OQGTgk93IO5e+4hJ2BFEXDaEVfLfzZ7bVfmI3M=;
        b=KFM1t8Pzmmld9izqFUbu2SlBn9Brt88DrmTFJ8e1gHI3rSS9cXVg7akIOIu0bu1kfU
         mB/T5wsGrWaTUrszOYfRk3jSrpMcMWxczn9bOV4pQHYn7T1XCjL7AZ6ciKIK/rk7OUE7
         LGWRptWYLV0+11JoC13Vr7qtFttYhhfhawgnQiv93sADVVF/ayPxIfRU0xshdKLt9kvr
         KgahSfdZESMK2WbEaUkI8c8r/zAeUqVH+W2/KodYiDhM9gkuDEqqnBx1WVOkiiYJHNSF
         U40iagIFht0eUTPaPT/hwKvVNG2EhdDsKzrhIubL/cq5DSYnzGyyC0Bk+RVpLVAunnOw
         OBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2Mw2OQGTgk93IO5e+4hJ2BFEXDaEVfLfzZ7bVfmI3M=;
        b=xNpW6QjA2HE1QaTRnucXFkmYvBUcUM7V/dEunPYV/EKtAGobBTeZSwbXLKP2rGdXLg
         Q6aDKiWVKNVrZ+KBg6S6FxiumDMXOG8kKaeU/Gz/vuXJbZxB2sxh129p5OfCOFvV122X
         Tf7mp1YGV2/iFDeH1Y9vNdWUOFmqBDbCjxh1MicvjZkp+nuesAGiv/uoRvdv64j8VwOC
         yJMRatpglm8iwAOzECCKSWxQZWWcZvGkLGxs+AIYdn5KI89I8Mg2uEw0wH+TNBD1/+7j
         KYmKvDQQrwAitJ8AMtDXqkn8qNlgfiwGc1sEIQugAXLzlbuqrWrhTp4dhierThhiHbRL
         CY9w==
X-Gm-Message-State: ANoB5pkAKQ/LNIjJGnZRBy/6VPvXyExqK4+LWlFJFNtlUtXdJPfplC1U
        2kgW2sfr8wcwmTUlNLuQYBwRrkuISXM=
X-Google-Smtp-Source: AA0mqf5ZKaBFGemixErHjThyPMDovxzQsvRQ8wTL6giVefh0zxszSBZ5nYx2wcvSEsy5tf72F8pV7w==
X-Received: by 2002:a63:5a56:0:b0:46e:9bac:17f with SMTP id k22-20020a635a56000000b0046e9bac017fmr49010270pgm.420.1670013912786;
        Fri, 02 Dec 2022 12:45:12 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x3-20020aa79ac3000000b00575c5ae50cdsm5674333pfp.142.2022.12.02.12.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 12:45:11 -0800 (PST)
Date:   Fri, 2 Dec 2022 12:45:09 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aya Levin <ayal@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] ptp: Introduce .getfine callback to
 ptp_clock_info
Message-ID: <Y4pj1Xb6mrIWxLEm@hoboy.vegasvil.org>
References: <20221202201528.26634-1-rrameshbabu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202201528.26634-1-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 12:15:27PM -0800, Rahul Rameshbabu wrote:
> The current state of the ptp driver provides the ability to query the frequency
> of the ptp clock device by caching the frequency values used in previous
> adjustments done through the ptp driver. This works great when the ptp driver is
> the only means for changing the clock frequency. However, some devices support
> ways to adjust the frequency outside the ptp driver stack.

The kernel provides no other way to adjust the frequency.

So NAK on this series.

Thanks,
Richard

