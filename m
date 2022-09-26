Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C6D5EADD9
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIZRPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiIZRPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:15:01 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA9B7AC34;
        Mon, 26 Sep 2022 09:27:16 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id cj27so4412116qtb.7;
        Mon, 26 Sep 2022 09:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Qa31KKQFJNsa7i1wAa/ohYe0PASU85gghiNNI322LQY=;
        b=H0rg+7IB/kaadnXBs+xVU8Z81TFMY4Qnoi4KvoI6QzUumcd1HjMPOCXAxa341yVdit
         4wtvMgcAufpesRi7SIhAVF6nrRvCpScIHqeHQAUl3zX1LPyZQC4XfSvP+XuJaL7pcBpW
         qJfNLTXNces513U2PsF2MOy2DvCVgNUxhyOOCLJppaG2RhcmqI8ssCYhWtmq6MlJK+sP
         u8M0Wj4g4vzXa0coF52QwFzfyca4wBaQoS/QX6mCChBLdwln1t/ssAJjUZ+8RpVTd9E9
         yA51rk4UE1esJGoEslEbRwS5J7kJiDuJyRNYKwsUesZBVWexF+/RJWT/9FPKQ2n7BWjM
         HdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Qa31KKQFJNsa7i1wAa/ohYe0PASU85gghiNNI322LQY=;
        b=F3m40g8Hu8r8A7XxTFXjhlruEm/nQ1YYkqiNtMhxbLy/vQqRfmYUQVYvi0qhqsbtf0
         wcXDQIyUQtY5YbkSLX6GF1X5jJq4kRIYLRzOLTV7p8TXjbbwStk0+VdT5JJ+MDEGgSYp
         MocSwEKEjSz1ymLUQ2zSf8ikkR//JBsx+Sz5w6NezqnuF0tMdfAuzKtOfDuLpaxAHJJp
         87qLh3mAprFKNbIq+nPqxwiVImqxmhVpwqfp/fTiL3fX1nvc6d0X5/DNGRV4xDrFNRd1
         ivXqAhhsXwwGPKtpg5UtKWPkaGx3ECHrheTrQlZfPMNtQ3nxLsCMcaIromCXiuNBK/mr
         dZbg==
X-Gm-Message-State: ACrzQf0LP25wCpSqfwYM+DV3N5K2sBbnQiYTlcxAFwujcf9r3+2LCwyR
        vr8vGZkjCc7mZn5IlC8V6XU=
X-Google-Smtp-Source: AMsMyM5rJFeFowIdSFi8NJ40V0CvR8Q3AXfswZUMLSsB/d9v6Ot5KJ/nJ7sK4Z0V5/J2VZq0folk5A==
X-Received: by 2002:a05:622a:18a:b0:35c:ef69:1111 with SMTP id s10-20020a05622a018a00b0035cef691111mr18371452qtw.675.1664209635705;
        Mon, 26 Sep 2022 09:27:15 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:155c:f237:bceb:6273])
        by smtp.gmail.com with ESMTPSA id x11-20020a05622a000b00b0035d43a27703sm1497974qtw.33.2022.09.26.09.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 09:27:15 -0700 (PDT)
Date:   Mon, 26 Sep 2022 09:27:14 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 0/7] cpumask: repair cpumask_check()
Message-ID: <YzHS4sK5m0aDp0Sw@yury-laptop>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
 <CAAH8bW-TtZrvR5rZHVFXAHtfQySD85fqerxAAjUTN+eoh1bP2g@mail.gmail.com>
 <20220926080910.412408f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926080910.412408f9@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 08:09:10AM -0700, Jakub Kicinski wrote:
> On Sun, 25 Sep 2022 08:47:24 -0700 Yury Norov wrote:
> > Ping?
> 
> Sugar sweet, you really need to say more than ping. You put the entire
> recipient list in the To:, I have no idea what kind of feedback you
> expect and from whom.

From you I'd like to have a feedback on patch #2
