Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8626B9B51
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCNQ0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCNQZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:25:58 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F6A2127
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:25:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i9so5891911wrp.3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678811142;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zkaVx6VypfrjWQc4xA3UfJ6cOvLAqaIsksqtcpSAwKk=;
        b=aTxfWGqSaGI6nI0Y8IINVhO8CNlh0mCiEwJwlZ5PmM0t2TN2vRP2mealfdyii0XBZ9
         2jB9fc96yrHiFWQcoU+LVrEzfburshWTrNl4PDiw45k0AL+Sjy/9gppNIgKj5HewlcjC
         8y1OO6msAvvnBxfCmCd5EBAorT/wESNz8+aj6tK89dPzno06OGHAT4f6usGA5yQwMs2/
         bGMcv03nngQIPXlFy8fLcxMG9EAQ1nC+E+uGxrWQ19CLvfNlLZi6n5/Bpetyyjn0G72M
         4Di8VMnpCJcF2q8rieVgYuBckNKJozKiefX6hr+MjUVCofjYFbqOk2jdDKsx7V7crqgk
         Ih6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678811142;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zkaVx6VypfrjWQc4xA3UfJ6cOvLAqaIsksqtcpSAwKk=;
        b=Quu4g7Y2zKrUniIZTzz2C74Owz3dTao88GTlXodxEPVW0NCf/u5n70ShxiMNN+UAgx
         7RLUNsa5plANvA+BErgzI6+yAKz8f1U/4ragMAqvkKgVcJSRbQ5/AFGAIME749BpgbXC
         HGsojiUZZzefP5vC+uhThevGiCad0TtP/D/36jThx/wbUkEwSCNle6WZD95qXerf0PWL
         MNudB8drjyPdmkhcMA8/b7TX2h9MzCqCrqN+hXn/Yab5sAQTSIbKrHeaaWtnimBo4A10
         MQJ7b/5KcN4KjR5I7Lq4WwbCN47mSmhrMcqCWsOmuDwpTfx/j1FR1NemurX3BBQCxs0w
         eG9w==
X-Gm-Message-State: AO0yUKVUtJ0VExsbG92V1XToL9F46h8E+CQ/ucQ7T4FYtdTd2XHaMtSe
        wrdXVTBYOSff5hQXOSLWcRw=
X-Google-Smtp-Source: AK7set/rcO018m/lgQ0HbgzGS9s8Zq5F1dr0u6vbvIwbFGpuzA5mzLEBvH6dI/NDiXeJBt7RBoxZww==
X-Received: by 2002:adf:f151:0:b0:2ce:a835:83d4 with SMTP id y17-20020adff151000000b002cea83583d4mr8167228wro.27.1678811142026;
        Tue, 14 Mar 2023 09:25:42 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t2-20020a5d49c2000000b002ce72cff2ecsm2507473wrs.72.2023.03.14.09.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 09:25:41 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next v4 1/4] sfc: store PTP filters in a list
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-2-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ff57ba46-9284-4f66-8a59-7c351960402c@gmail.com>
Date:   Tue, 14 Mar 2023 16:25:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230314100925.12040-2-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 10:09, Íñigo Huguet wrote:
> Instead of using a fixed sized array for the PTP filters, use a list.
> 
> This is not actually necessary at this point because the filters for
> multicast PTP are a fixed number, but this is a preparation for the
> following patches adding support for unicast PTP.
> 
> To avoid confusion with the new struct type efx_ptp_rxfilter, change the
> name of some local variables from rxfilter to spec, given they're of the
> type efx_filter_spec.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
