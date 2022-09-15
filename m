Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5615BA31F
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 01:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiIOXXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 19:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIOXXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 19:23:14 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB4D7CA8F;
        Thu, 15 Sep 2022 16:23:13 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id i15so15421548qvp.5;
        Thu, 15 Sep 2022 16:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=1QrCyzzwTfUJwLj3S6cxRWluHW2svGs+HhM9SBpAePE=;
        b=KqmVkpIAbDwHrCcz/+17YNfdK8pPZ2kpbOanusQsqLSovcj0Sj0cx1YpV52/VoL+Th
         aUqd4zDweolb8nIucDWd37S2o4VfPYkC+1bmzUlxNphQ2a3nV9Ak26blluBbRIkNgANR
         bANHNgt1/rg0CMKPve7qmIZE+PhrMa2jBri+JYHpA0QOd1eF4HQDrsz2OEpDFpjbBcPU
         LcTrjy2BU7VqVIbrXuSh/GdRD85LFpOMe8GfzjkEWAToZt6fg3sqWZixsgha7DI/7tUK
         2A68HaTkKT5+tbGzFXc5B+E1yBmCcsjNMGN3etvqVYFLHiu7H95oG5VkPgT2PzOwfhzZ
         yFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1QrCyzzwTfUJwLj3S6cxRWluHW2svGs+HhM9SBpAePE=;
        b=c8h0KGrYCjSTcYkV+C9N+5QPwNj9WMEZrK+I7QUrvE5fuFcLphg41C4JXTrhrhexfZ
         BGJEtWN53TfeGFADBMGzcTepsySTCMdo8+OCAhUqBwiZX+ogJgYuMxUGz87eE2ggffqv
         wsLK/Jj7TvzAbAQt5lOyD8x+Tme9jZKkE+YxDYOs5kG7etelruO9d9vsEHYjGUTfE7tC
         7R9gMPNxORNKX0bMmk2MnKLCi46SEf5/WELqYRUw9NSvteWXq2LhrPcZpVhTOHvuUQsr
         u5N3j8OsVK+vbljbbnuHdfhVOjhnmz0e6BQaSTYaX9ArTWIMbWUVna+7t2MNWOlPaPJN
         o+5w==
X-Gm-Message-State: ACrzQf26lteT9OKUO9iYfTFmuZgbx2EnPUJFOT2CUN6pe2KBKingglc8
        6nBP9Q+Y3+CWZ7vkjMJagbo=
X-Google-Smtp-Source: AMsMyM6+1hmP35AruDorcXQm3QRKD7aRMMfVX2bqHBh0nOLbYPetC8uLp3aGwW71JA2eK/k/OnOrWg==
X-Received: by 2002:ad4:5ba7:0:b0:4a9:33e4:2801 with SMTP id 7-20020ad45ba7000000b004a933e42801mr1824874qvq.87.1663284193003;
        Thu, 15 Sep 2022 16:23:13 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:3158:855c:7b19:dc49])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a454c00b006cc190f627bsm5175794qkp.63.2022.09.15.16.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 16:23:12 -0700 (PDT)
Date:   Thu, 15 Sep 2022 16:23:10 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net-next,v3 1/9] net/sched: cls_api: add helper for tc
 cls walker stats updating
Message-ID: <YyOz3qLWTS3raNpe@pop-os.localdomain>
References: <20220915063038.20010-1-shaozhengchao@huawei.com>
 <20220915063038.20010-2-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915063038.20010-2-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 02:30:30PM +0800, Zhengchao Shao wrote:
> The walk implementation of most tc cls modules is basically the same.
> That is, the values of count and skip are checked first. If count is
> greater than or equal to skip, the registered fn function is executed.
> Otherwise, increase the value of count. So we can reconstruct them.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/pkt_cls.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index d9d90e6925e1..d3cbbabf7592 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -81,6 +81,19 @@ int tcf_classify(struct sk_buff *skb,
>  		 const struct tcf_proto *tp, struct tcf_result *res,
>  		 bool compat_mode);
>  
> +static inline bool tc_cls_stats_update(struct tcf_proto *tp,

This function name is confusing, I don't think it updates anything,
probably we only dump stats when calling ->walk(). Please use a better
name here, like tc_cls_stats_dump().

Thanks.
