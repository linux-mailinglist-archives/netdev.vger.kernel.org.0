Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAE04C2DB9
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiBXN7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiBXN7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:59:44 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EB61CF0BC
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:59:13 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id v28so2957763ljv.9
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Hx8qcrUpKwD3ZMmHTneVz1r8yqruW/VfpRM/Y8XRyGY=;
        b=B9Cps+y643AFbXupKs1kO8QeclwRqGVmvGQMdYhyChkLb36sepYdR5GTGUdtsfjkIE
         vDpWy4Yg02v+xlFxXe6jmrek0p74Mwx9P/szS+XAAc3shTqhZ9c4mlfrTIyKMXnIR1Bd
         pVljyleLy6/s7oPDvcpvAynOjavIip6odrtM5YHOHv3LrtHAPZtP0R0IUmox7dJ9m8pN
         Xe6esRN3gpU9ajcG1UDyez8pmMHKGnGBcR7E97yUcHfXvaFCVviHXbRO/JDq51XKokpN
         rPpFQwyVosCtnHfSwzV9y7l/By7p6qxzgTtZ3bWpvMw70Xej+ZfwxQIo1ehuENKyU8Nl
         /vpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Hx8qcrUpKwD3ZMmHTneVz1r8yqruW/VfpRM/Y8XRyGY=;
        b=CRtmX85Ta64V1ey1fPYksWN3Me0aazqBllkXnlaQbYDy5D+HUhYIl2Hf5YbX2rAPRz
         /gTKpWO9ctW6TGV++dy+M1/laleu3SQ7sidVaaJ0Wn3+E3IC7wnIFsD8UIrkzhvTW7P/
         iqEwchnG2ULj2PrQ0Bn/x3JsLakp+5CJ1zuscoKhjvGeA1qhcEo9raQvAmyRBCZkls6I
         gBlKlCrPx2FyNbY5wZ88eCFXlQpBOLXvn/5gmlqQIs7Gv711V2NjKiqj3K7r/CNqCWh+
         GnKCxJYI4w2I6jVSPJMHqNtVsTjhcH0pR+vqu/FSkeMReQZt/Xan5i2EmUIwvXBcbN5L
         odlg==
X-Gm-Message-State: AOAM533qWc3e8RgXVDfEUlfw6uZe59GPhoy857UB0AiFJpY1MVeCJKqy
        hv2EExNgo6bBk0i+S2CuCqU=
X-Google-Smtp-Source: ABdhPJyqgZcP9z6Ev993YWy5NQ27h09wuNq69NzIkB/AEV1mhu1CQr21J29r1vA03MeIXE52g/kRhw==
X-Received: by 2002:a05:651c:10b:b0:246:280:c7 with SMTP id a11-20020a05651c010b00b00246028000c7mr2006127ljb.126.1645711152150;
        Thu, 24 Feb 2022 05:59:12 -0800 (PST)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id w12sm213430lfl.131.2022.02.24.05.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 05:59:11 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/1 net-next] net: bridge: add support for host l2 mdb entries
In-Reply-To: <66dc205f-9f57-61c1-35d9-8712e8d9fe3a@blackwall.org>
References: <20220223172407.175865-1-troglobit@gmail.com> <66dc205f-9f57-61c1-35d9-8712e8d9fe3a@blackwall.org>
Date:   Thu, 24 Feb 2022 14:59:10 +0100
Message-ID: <878ru0qsb5.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 13:26, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 23/02/2022 19:24, Joachim Wiberg wrote:
>> This patch expands on the earlier work on layer-2 mdb entries by adding
>> support for host entries.
> It would be nice to add a selftest for L2 entries. You can send it as a follow-up.

OK, will do!  It's on my immediate backlog.

Thanks
 /Joachim
 
