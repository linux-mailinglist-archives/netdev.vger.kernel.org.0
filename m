Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7488C539CE5
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349804AbiFAGDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349795AbiFAGDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:03:48 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE42F64D0D;
        Tue, 31 May 2022 23:03:45 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n13-20020a17090a394d00b001e30a60f82dso5140125pjf.5;
        Tue, 31 May 2022 23:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MD+IAt0ZHEv19FxkkpkkA6n95ELIlauVLaQ5zvxEY50=;
        b=kGMt3K6tQy2jgmNtJ3VAziSVj8zycjsrnzfv2pFyWiWQsvH0MFaSEZLmAJfoVhdoKQ
         +Lnu093U0RjsgTAL83KBU79nr5gk/gn00gGOe8QZuvODO2TzxzhGSjfce2QB03OemtdY
         Bn7xk7jR1wPFw34/UjdfAsQ7TbZDMlwnI4nmE9/S90RU1oq2NnO7UvBfWo+1GGALciEQ
         IysW0ncgBcwHbZ2TXQILPIeNIQfssiCvGqaybwW1fLYwd3fklcyHThP82wCmI1lYvnBy
         o/ObXyhsCLHScx7QI8PFOGKoaIgsMhZMQUToUdMLWHpMt8sDS64f4DMAbpg1JwKSui9N
         QExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MD+IAt0ZHEv19FxkkpkkA6n95ELIlauVLaQ5zvxEY50=;
        b=Vo8dPZL3YHpyRVbaPwszQ1XssBIt9zhFOHZbj2Et3KtUIOLCZ+FN1FooMR59Q8TFrr
         HqbFNczR7y3jGYa7c7+6iv6dLWH4LQjqVadULvdE02eIiOLnSf6ShngLafeA/a2ndbeX
         c4ksxpqVvwsfnuMH/DkGGNiCxriDEsa/zddK4R//+vTA3JQTA2JmRiMRx+AA7b4dvBru
         rL8bIiinzvZ5VMJrWo0/o4gOQ/iakjKVlKDgAQjO1vXE0mgyqxwHNDLKcFyOjwcNSzdN
         /h0Rmc3MHwcfmGLyEBO46ZqoTBu882P6XsbaEC5cGIYwIAOunGknQeLOHuAdtRCo62vk
         //0A==
X-Gm-Message-State: AOAM530ZSnnxNIYRDmEPRw7dBuAY75vGXZIL1BGsfCJsjfdyVoCL+POs
        APNCNlTQI9C7Zxs2JpQ4gVGLnbpki/MLXg==
X-Google-Smtp-Source: ABdhPJzXSxMoatazvxQ/uzJstIthpD7V3bCB1977AFb8l5M4VyD3yxL94rJbjrkAtxMAEn3KBqkzfA==
X-Received: by 2002:a17:902:d510:b0:163:622b:63db with SMTP id b16-20020a170902d51000b00163622b63dbmr33176575plg.135.1654063423863;
        Tue, 31 May 2022 23:03:43 -0700 (PDT)
Received: from [192.168.99.7] (i114-182-222-92.s42.a013.ap.plala.or.jp. [114.182.222.92])
        by smtp.googlemail.com with ESMTPSA id 21-20020a621815000000b0051b4e53c487sm507075pfy.45.2022.05.31.23.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 23:03:43 -0700 (PDT)
Message-ID: <3e96d6ae-bc97-9915-5f72-901c04dee3c2@gmail.com>
Date:   Wed, 1 Jun 2022 15:03:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net] net/sched: act_api: fix error code in
 tcf_ct_flow_table_fill_tuple_ipv6()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YpYFnbDxFl6tQ3Bn@kili>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <YpYFnbDxFl6tQ3Bn@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/31 21:10, Dan Carpenter wrote:
> The tcf_ct_flow_table_fill_tuple_ipv6() function is supposed to return
> false on failure.  It should not return negatives because that means
> succes/true.
> 
> Fixes: fcb6aa86532c ("act_ct: Support GRE offload")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thank you!

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
