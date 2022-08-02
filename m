Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438BC587CBC
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbiHBM5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiHBM5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1218ED114
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CDF26131C
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C37C433D6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:57:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MnYWTuze"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1659445050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CgdetI88BVAtvZewGNp/b4PGZNuqMVDWW6rORAJ8yo8=;
        b=MnYWTuzefKDy24kss9NCIqrBrX2cgEa4eFeg7tXAwF28/SJrGGSFJltvuMJsxzQmq8zON5
        MhnGTDKoA7iB6zhBzgWe74amFQV6/oUq/odXdmL80ZJyIWR7K/kb1vKk26QZgMHEy57HOy
        0wtDkfuW7zkOrXjtqksIS6Xeol/Rk4c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 710a1357 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 2 Aug 2022 12:57:30 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id r3so23465718ybr.6
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 05:57:29 -0700 (PDT)
X-Gm-Message-State: ACgBeo0HtOn0DHEuZbhiUFOiFX6gXf9aQaQF7W8B1EK8eDts5cxehNuq
        CCjj+wvOw6gjUJ3+XRaCnqDI8/d47DAeYXAYH28=
X-Google-Smtp-Source: AA6agR4frcWSKoHMYTgwDMyum+3Gb+JpGIr892dQ/k3KXyTTq8swk24EfK7WtTfVUA746RmXO82My6TZZtoLbYquRCI=
X-Received: by 2002:a25:504c:0:b0:671:794d:5171 with SMTP id
 e73-20020a25504c000000b00671794d5171mr15219821ybb.231.1659445049516; Tue, 02
 Aug 2022 05:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220802125613.340848-1-Jason@zx2c4.com>
In-Reply-To: <20220802125613.340848-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 2 Aug 2022 14:57:18 +0200
X-Gmail-Original-Message-ID: <CAHmME9pnqpZV0ewUYe3jFp04NLsOafOhm7wgJ6wwpSDnvV0dgA@mail.gmail.com>
Message-ID: <CAHmME9pnqpZV0ewUYe3jFp04NLsOafOhm7wgJ6wwpSDnvV0dgA@mail.gmail.com>
Subject: Re: [PATCH next-next 0/4] wireguard patches for 5.20-rc1
To:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [PATCH next-next 0/4] wireguard patches for 5.20-rc1

Grrr... obviously I meant net-next not next-next.

Jason
