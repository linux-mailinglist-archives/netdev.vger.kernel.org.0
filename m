Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4DD5F070F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiI3JDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiI3JDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:03:05 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EB11F7B03
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:03:04 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bq9so5822322wrb.4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=BLV+zDqQy7WNjek6U4auqEgP56ZeMfwgVYiRBqm1xUc=;
        b=DhkpPGXoSx0PH6gPNF3MJdSrkQEUMEZxPf1vTk/y5BQZ8ylviScO+p2a8mzjOkWAv8
         sX7Klbb0oQA5kHp+oM6Kp7TD6KKa47TQIeN4IT7qTxoO2NrUOa7fXAPu9cYK401mx9K/
         sTdB/Dw+w7yT6OGczxhnaSzqM3XkkjqzTnXe8/Lkqrg5mLEG7O5E0NabzCcIU5uwop8x
         NgQ7i2vLvfDxrF4G8LblTOFU05JwmnuTqa8kh0u4cTeTqfXtKJ6GU2DUgXFTM2S+pseF
         1xpexdbfKJicbx393qxEoJ/mdz2LIMax71Fvp3dewGT6UOACXXEjbu8YlwqSpxtmbW/5
         u9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=BLV+zDqQy7WNjek6U4auqEgP56ZeMfwgVYiRBqm1xUc=;
        b=1UV+d8/59IHSUILk+ZZNCGE5jweu1pbKAxDgPF9BGw0pXHaCIRyigHkSUBvkXGE6yf
         YoYU9uyWFPLIp7TPgtn3upQf2MMmfc4IMIJJB3s0B766uavuRvJ/CfW9sawH64ZRv5/v
         6Dq2nwEms/zA2v91iS5Scg8XdhF5Unx5cAfOVtv42Wi5U4/QDhJEaNbgiFFF/bStm+P3
         LlOFIQr27WUcI5o3lGCR37wEtLk18EJsolJ1O2HTwz7q/G9uY1nvOctbKdC8G0VTqU9W
         VnJFqnwy2DOaEV8h8KQvAYhPaZAYwe83kTTDpHCqUhQt/NL/PII+mvzNGAH9yct8fs1s
         1Edg==
X-Gm-Message-State: ACrzQf0nqQPpK4PtBLxV/qiaNLr9rv0btyLB7taChJqY4IFfu81XUcZ5
        bzU31b43SQh94Bs4xxNz3Zk=
X-Google-Smtp-Source: AMsMyM4+23NlNWnXVHqKsZV8GqmMXXOGvdsAAtMuPCjuBbax8eUkQDVB0KH5gRmp8WqyRfhgdeeTFA==
X-Received: by 2002:a5d:6d85:0:b0:226:ffd5:5231 with SMTP id l5-20020a5d6d85000000b00226ffd55231mr4810367wrs.202.1664528582763;
        Fri, 30 Sep 2022 02:03:02 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id v11-20020a05600c444b00b003a682354f63sm6684722wmn.11.2022.09.30.02.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 02:03:02 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
 <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
 <20220928104426.1edd2fa2@kernel.org>
 <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
 <20220928113253.1823c7e1@kernel.org>
 <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
 <20220928120754.5671c0d7@kernel.org>
 <bc338a78-a6da-78ad-ca70-d350e8e13422@gmail.com>
 <20220928181504.234644e3@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <16da471c-076b-90b3-3935-abd31c6ef4d3@gmail.com>
Date:   Fri, 30 Sep 2022 10:03:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220928181504.234644e3@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2022 02:15, Jakub Kicinski wrote:
> Hm. I wonder if throwing a tracepoint into the extack setting
> machinery would be a reasonable stop gap for debugging.

It has one (do_trace_netlink_extack()), but sadly that won't play
 so well with formatted extacks since AIUI trace needs a constant
 string (I'm just giving it the format string in my prototype).
But yeah it's better than nothing.
