Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688086B0CF4
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCHPha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjCHPhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:37:05 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84396040A
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 07:36:33 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z11so10495197pfh.4
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 07:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678289757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qzXYMtwc+09RdIXWjorPpQsH2q1hf/JTgvulfHYUzvM=;
        b=WhkLWQ1XuViIo2vvImFS6xDKg3M3xLtxo9yGqv+G+Rtk7Y/g2lTAp8Q3fAxYgWOHPb
         fKd3HJf2oWgUwAsFBw9ZaenoY5PiM9Obg0fDpg+j6VHS2Rza/n0Zxze4YP56yc6HCMYq
         U+crFmNYaAVuCjurd3/READUtRHuhsoDmm47F4p7O/jSWh11A1uSAM2KXb0WHYV5WGpI
         M5K6XB3h0mq+Qqcd2HjwDiDIwqWt0XoFJuf6rMRdzzL/NFyprerhmHaAinYSHKIaQWkk
         6SujRh+dDnmmQf0Dq8WirmPO+Xyjh8nVTHN+y4mj5vd2x+d1nCL5WM8LNumsfACVxhSv
         0lvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678289757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzXYMtwc+09RdIXWjorPpQsH2q1hf/JTgvulfHYUzvM=;
        b=bcWFrGNq+6oE7vY2Nxpj3gPdV2Pnm1WDPSlZh6Vk0ooXf1bRst3m/Ll0GFXc+6qXiI
         iJy+X8m9Wcyb2Lpkey89Q2oNBdoIDMjKOtHx4Smi4ljgUVDuS/quz+qSPrmX+ga0iSGm
         c7xPzQaE5qIcDOtmJ10vKC4sryT4HlLqHsv9JED02nkn58GHcO2q85OudaIBGfLC5br/
         MoE9PQ2jKjyZuKO83fmSm56XxCm/LCMhzTdjRevwOB+UADM2xn4lNCR3c2gnndfjTDLQ
         SLzCL2u/W5u6ilU91zD6I9Tyn0AgxBxZRtHpgg/cFjkcgXnWdWjpIF8C2y5DgaLFF9r1
         bKMg==
X-Gm-Message-State: AO0yUKX3K7gxzoos9lSmM7VsBngGC+pl82FGlt9bCVbHZ6eayN1Oz66k
        rOPfjZRFLbL6KEqovpO3reiXLs4YTKOXPYTaVus=
X-Google-Smtp-Source: AK7set8JdByvQuNh0tXw+axrOJrfkBPuRzBSMC7yfDtlTU3ueo2O2mGHGd/2lRB5agp2bnIt5suI+Q==
X-Received: by 2002:a05:6a00:2a08:b0:5ef:8b7f:f69b with SMTP id ce8-20020a056a002a0800b005ef8b7ff69bmr18279264pfb.0.1678289756802;
        Wed, 08 Mar 2023 07:35:56 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id h16-20020aa786d0000000b005921c46cbadsm9842088pfo.99.2023.03.08.07.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 07:35:56 -0800 (PST)
Message-ID: <43574499-f016-c62d-6d3e-868139ff66c2@kernel.dk>
Date:   Wed, 8 Mar 2023 08:35:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net/packet: Allow MSG_NOSIGNAL flag in packet_recvmsg
Content-Language: en-US
To:     Adnan Dizdarevic <adnan.dizdarevic@eks-intec.de>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Cc:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <BE1P281MB18589C91B10886A86B26EB6BA3B49@BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <BE1P281MB18589C91B10886A86B26EB6BA3B49@BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/23 8:18 AM, Adnan Dizdarevic wrote:
> By adding MSG_NOSIGNAL flag to allowed flags in packet_recvmsg, this
> patch fixes io_uring recvmsg operations returning -EINVAL when used with
> packet socket file descriptors.
> 
> In io_uring, MSG_NOSIGNAL flag is added in:
> io_uring/net.c/io_recvmsg_prep

FWIW, this did get fixed in io_uring, it's in 6.3-rc1 and is making
its way into the stable releases too:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7605c43d67face310b4b87dee1a28bc0c8cd8c0f

-- 
Jens Axboe


