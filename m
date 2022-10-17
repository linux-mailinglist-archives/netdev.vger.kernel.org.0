Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE393600E88
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJQMEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJQMEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:04:40 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D11120AC
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 05:04:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a10so18062273wrm.12
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 05:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9ipY9Q6QdQ9gwRaiKZpShKe6etYw3VCYFiimXfGTcQ=;
        b=ec/yWMs6hgqrMbFqM0JvobqoO4qPpelM+AvtINVevY0+1y/JJIJgtoMR4Jr9RHN5hO
         HP+LDtyIOAmM3KPJEFutKGW8v7KNPcTucwUC6iX6TaoZvDizzCnuQOQrHW1iS6mtcXPq
         3fehdpiFKQG+4yVHjkbJb1+f191HofHyOhpLchFApzC7xYjSNWvJByQpqZZlhZNmMKvR
         ZEp71YhF4BLSRo4HdiW/KPVK1BP2xoweRstna/ML+D0JMnd0SocOUvZvP38nQbQRyzDI
         Vhpu2lJ+FfApQ3AsB2vBnndmoYcJp7Zfz//PmR/vqIWUje0k291ND3ak35xGICS6qpDC
         b3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9ipY9Q6QdQ9gwRaiKZpShKe6etYw3VCYFiimXfGTcQ=;
        b=3k8OSUQnCiE887tLMlVrth3XYUv7LV9alMkaD3pitPUG3G+GMihx95CrWfrH0Abx8r
         ZnCPNoPNHd94b6X6zudFlxct+Gph+TS5sPFEQtykPgVCv8dG+eabSOZQ3B7Oaj6vw2Sc
         8xLN6tE4nHQQR470Pc3AySMFJy108fCA4xnLBsu6trhP+fPDH31ON32aNLbvaIXT9xna
         QgBQMt0lhNbMn/HsWPT/C7gnDVore7sc0lteHPlIVaZiIE2UK11uTzBUeHZ4uyM6rgXM
         p2vV3gv5dhdHJfP8shPwGt7D1LZYVb5fmfaku1gSAt/K4UlVLoHd+aWni48uPHJXWYYz
         gzEA==
X-Gm-Message-State: ACrzQf0nP2934legLabJvhUvhwAvJCWA7/s12D0PcpE1iakmGGlm4Pql
        nt7gY1a6hwW57u7eSLg5KDQ=
X-Google-Smtp-Source: AMsMyM5+cDeFsdmfqymXtJUn3tLigi3ZMh8LQi0eJpu7HN9f869obts5H6hye9zCQY+uihKsi3rZ8A==
X-Received: by 2002:adf:c582:0:b0:22b:3c72:6b81 with SMTP id m2-20020adfc582000000b0022b3c726b81mr5992028wrg.320.1666008277001;
        Mon, 17 Oct 2022 05:04:37 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a05600c4ec600b003b477532e66sm27635743wmq.2.2022.10.17.05.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 05:04:36 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 1/3] netlink: add support for formatted
 extack messages
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, johannes@sipsolutions.net,
        marcelo.leitner@gmail.com
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
 <26c2cf2e699de83905e2c21491b71af0e34d00d8.1665567166.git.ecree.xilinx@gmail.com>
 <20221013082913.0719721e@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ac4c37d1-e33b-2cd8-707a-9f6abd382df3@gmail.com>
Date:   Mon, 17 Oct 2022 13:04:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20221013082913.0719721e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2022 16:29, Jakub Kicinski wrote:
>    (I think splicing the "trunced extack:" with fmt will result
>     in the format string getting stored in .ro twice?)

Yes, it will.  I guess we could splice "%s" with fmt in _both_
 calls (snprintf and net_warn_ratelimited), pass "" to one and
 "truncated extack: " to the other.  Then there's only a single
 string to put in .ro.  Is that worth the complication?
