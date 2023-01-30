Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77582680CA8
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbjA3L6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbjA3L6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:58:00 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A132D142;
        Mon, 30 Jan 2023 03:57:29 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hx15so11436090ejc.11;
        Mon, 30 Jan 2023 03:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0N5sOtPH7xyPyyPi0ciu98Glo9H4n1MGA966NUG3zlw=;
        b=YvSYvPnI1W1n5/7U85hGsMVA8NNgh42R9jjPGBZ+NplITgmmAvl09iUZdqCw1dVhnO
         LGCacDVWtWzy0FSA/9urNGCmKkSozuLF42/I6nNOam71vguAPaxNJW4iapC4wCSCJzum
         55krael8U+MpePFFryw8LW8bU75tbNNFACyZcOOrEn/h5Xw+rOGtWnurFMPu2F09IsAx
         jkD33uGVJZqOm+reGGYmOik9U8XrKyM3fAUKabsO1ej/ZAafzGWftCvBvZqh/NaCxOoD
         xDXd6SCqc3Et/3R7nBh5E+zbpwZMZKOFpTRvfOM5Fcc5tJ0zcPTMb3mN9DV+dZwdZrvL
         8JkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0N5sOtPH7xyPyyPi0ciu98Glo9H4n1MGA966NUG3zlw=;
        b=Rj4WsePbHwQIrCbQN7gWSnz4BCfujI+bHk7zbFgMkJYittlaF8IdUmNoyz8NEHeWA9
         X8IVovJkJM0eftn0T8ohtFBsuoK7TXA87HsFr+yKa6J8dr9mLLzte8zal60lBXmIqdCP
         j2DvfWqkEgnDoRmI226dhic1AGr2vxt+T0Ml0o04V6kh4mpn/vGpoB1ItSJzJ/3REFd1
         Xvp0gfi6IJSgomw/QbRIe5sdb4PxE3XIT+A9Qs6GmUN93q+Gk/NcNbvknmzdGUyoGnwR
         3Mcz80nk7q1RJrUyYRcX9u3l4RF9cjZoinXjynNtyix4gASp0NbLNtN+c8ZVErlIeKtV
         BK3g==
X-Gm-Message-State: AO0yUKUVF6yWkED7HYlEX2PhXgmxcbN6aVfcS558yruF3BeebYR1dOaf
        JRcHYUoEvd7P7RKsKrOUo9WUCR9g4gk=
X-Google-Smtp-Source: AK7set9sCp7yJJ+9ZnkT9U7hNePHtbSycg8mbaAKXUMr53hLmxa64raD48JYc4c0hDg/O0MZPmEutg==
X-Received: by 2002:a17:907:1c9c:b0:880:5ab7:cb76 with SMTP id nb28-20020a1709071c9c00b008805ab7cb76mr11375103ejc.33.1675079848389;
        Mon, 30 Jan 2023 03:57:28 -0800 (PST)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id o5-20020a17090637c500b007bff9fb211fsm6845879ejc.57.2023.01.30.03.57.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Jan 2023 03:57:27 -0800 (PST)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: allow user to offload tc action to net device : Question
Message-Id: <3F8BCB2E-D60B-49FF-8826-BD4B34E90898@gmail.com>
Date:   Mon, 30 Jan 2023 13:57:26 +0200
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pablo@netfilter.org,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
To:     simon.horman@corigine.com
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon , Pablo
I write here and need help
found : https://lwn.net/Articles/879034/

and try to start use offload traffic to ethernet card with nftables ans tc .

but not work 

try with Intel xl710 and Mellanox 5  but every time i receive error : 

RTNETLINK answers: Operation not supported
We have an error talking to the kernel


Try with kernel 6.1.8 with latest iproute2 and all other software.


is there any that need to load in kernel 
ethtool set hw-tc-offload on on card.


in nftables : 

Error: Could not process rule: Operation not supported


idea is to offload tc and netfilter nat to card and reduce cpu load.


Best regards,
Martin
