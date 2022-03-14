Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBA64D7E6C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 10:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbiCNJ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 05:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiCNJ1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 05:27:40 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8062A706;
        Mon, 14 Mar 2022 02:26:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id h5so11646695plf.7;
        Mon, 14 Mar 2022 02:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qkGZkCufnME0csNaFQuxVL/vBAMYc6bRYOjfKnEHWrQ=;
        b=NH10CMtUBCwdYbHlfZE4HmejCKGPqSlIWc3CubMUK/cFHkJAXDJcNRxvvryvmSTdJh
         ofmsyEnVV5sQXJJSbK9JNP1oCwL5mW2zTWgPwlp2ACTR3ExoPeUmZkeq3yVK++T/cH8H
         i+WZGK6OBYVdJMPCnmsusqQaFRatJTjJ6ZORIgzJCf4euvvZ3Qse5CpZ5ekUeDPSKjdC
         mO0ORGf5uEG726YazDczT7Kuf4piaSWiqfhpf7x20foO+e5AaBQ8b0eodNmvnQugCJlz
         is0umaKHsYKYR63Uw3u6fkLwS6F8EHvOYYtShUlSdyyYKxlK6GKJodO4KzlcSQy+sWxn
         FexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qkGZkCufnME0csNaFQuxVL/vBAMYc6bRYOjfKnEHWrQ=;
        b=a0O5+wV1i3cYhbWQGWYLdAsxcHPX3Z9UnAu3TGfAYm/HE6OzdauYNtuqUylOJsu1g9
         BNfembYllVOMPWlQ6K1LNf3yfq9d935UQC7sxHj+nOrl2LnEERw1i8rJusKKdj2QN2sy
         QzkxZBO2sfvp6jSgeMnlZUHp4V4h3CB/QA8WWqEzlVdbb6ar+2XRrZ0z6xp66J5rV94q
         FJlRhlFmJqMbFv8mCrCAODJnonDWvsKbT9LFwK2ShAaWox980gPYWL3/3vDH5OQ1ggJb
         z247aD5e5zZ8VVYr6r1azeg1DCy/kGI8JMHtc2YlH1iVMv6MhWLUGpDujj3ReXTN1hdQ
         RHPA==
X-Gm-Message-State: AOAM531POtX+pHU3Mzxcjv59dvVHLZQ99yOoA9vW4FMoBW6jurmnZ1qN
        rIfCAebtCSCT9zZAp4bp/Mk=
X-Google-Smtp-Source: ABdhPJwo4azc41+a95sSq0jMkW7neTuLD6Vt7BK0pTVhvfuBs0GQ8PlAK95CPwUvHrLE7XqUG56IyQ==
X-Received: by 2002:a17:90a:d0c4:b0:1bc:b02e:ed75 with SMTP id y4-20020a17090ad0c400b001bcb02eed75mr35265444pjw.104.1647249990052;
        Mon, 14 Mar 2022 02:26:30 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x9-20020a056a00188900b004f7454e4f53sm19972448pfh.37.2022.03.14.02.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 02:26:29 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        toke@toke.dk
Subject: Re: [PATCH V2] ath9k: Use platform_get_irq() to get the interrupt
Date:   Mon, 14 Mar 2022 09:26:25 +0000
Message-Id: <20220314092625.2115134-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <8735jlq7q2.fsf@kernel.org>
References: <8735jlq7q2.fsf@kernel.org>
MIME-Version: 1.0
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

There has been a little problem with the mailbox recently, and we are
working on fixing it.

thanks
