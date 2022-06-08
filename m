Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D76543E0B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiFHU6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbiFHU6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:58:50 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E3F223BE9
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 13:58:50 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c196so19395079pfb.1
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 13:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ckcyiwBk0vu0y6fmgert98IS70avOx7Z2LHYXhU/IQ=;
        b=GMzHaezS+YTzKOy9T44U0TeGgm0MHXi3RrGY67Eku3apWfXckfDEIvf+YJ9nFGR3bP
         hOCJUNcWhvH52G47193Tdb4yrwuZqO1g+HnN99dNekEbZ7Uqf26mBtH+ktyJuF8tyY6D
         288LKCZc+0EEFCVfBOudPA5nZULuBQJOgsUMFT8TH9Zg3mtLIymewUpb2n0XHZJCfrvL
         CVe96z/fQO0yR9juYAcsfc8e6avZ9V9XFfAfCY6OkoH7WXuKnDtE9lZQziBbKQCOLAIC
         qd52c1wXm8WoCsRRRqoC86YFWhGaZs7co+6YLKweocv/WnM37ml2HBDkB8r7NNwNJhI8
         6u+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ckcyiwBk0vu0y6fmgert98IS70avOx7Z2LHYXhU/IQ=;
        b=wKMYLfO3a37uYcevy0L2nRg2PixrYMwR6S2qtmQP4z5kbhbOz48YdH2YaDH63IP8md
         CwtBM0DEmeNSG2XBhyRar7MzvKABWLwUv7StywQi8lZcoOY9UX7mS35fJ3wUtDAIJ0Rm
         rWPrwGJH5O8iepW5p8TVsI1hqm5i6w2UwCSVSHq7VkeJHb8324nFqbYRfBJCCOYmyeFb
         0oP9/zvEqcM+T29bw0lidrM5p3MP9hH3KJJOMxVL5dvmDQSQLRhMJfWdf3igsjU5jgKM
         zscraHhTnr9BYcbz5Toap892+BBARaI+nPhjrE9MvPQ6cZoOWwsT4hwgV8/3K+MTMUJX
         pyTA==
X-Gm-Message-State: AOAM5305yPr8vpwdEKKspUZlwXaDCCWZTx/CP4usjw0xvtG+AJBewv77
        EpBrjz4XxG/CUzJ8oObhcRo=
X-Google-Smtp-Source: ABdhPJyxlhTGCzHZ0M+i/WtLJjRlq2ybGbXmRob4l0QlYWAcNuKXEkcdT1YZNOmdQMgWJOdnpPxDtA==
X-Received: by 2002:a63:2344:0:b0:3fd:fd53:5fd1 with SMTP id u4-20020a632344000000b003fdfd535fd1mr9137406pgm.478.1654721929619;
        Wed, 08 Jun 2022 13:58:49 -0700 (PDT)
Received: from [100.127.84.93] ([2620:10d:c090:400::4:f897])
        by smtp.gmail.com with ESMTPSA id ji11-20020a170903324b00b00161955fe0d5sm15276830plb.274.2022.06.08.13.58.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jun 2022 13:58:48 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 3/3] net: phy: Add support for 1PPS out and external timestamps
Date:   Wed, 08 Jun 2022 13:58:45 -0700
X-Mailer: MailMate (1.14r5852)
Message-ID: <F8F52C51-9E03-4E05-AB56-809C37C2BF58@gmail.com>
In-Reply-To: <20220608205039.GA16693@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-4-jonathan.lemon@gmail.com>
 <20220608205039.GA16693@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 Jun 2022, at 13:50, Richard Cochran wrote:

> On Wed, Jun 08, 2022 at 01:44:51PM -0700, Jonathan Lemon wrote:
>> The perout function is used to generate a 1PPS signal, synchronized
>> to the PHC.  This is accomplished by a using the hardware oneshot
>> functionality, which is reset by a timer.
>
> Is this now really in sync with the PHC?
>
> (previously there was talk about it being random phase/frequency)

Yes - I removed that function.

In the current code, the target time is loaded into the registers,
and the hw generates an output when the PHC matches the target.
—
Jonathan
