Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDC2656AF5
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 13:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiL0MZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 07:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbiL0MZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 07:25:02 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4C1E97
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 04:24:27 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id j16-20020a056830271000b0067202045ee9so8087243otu.7
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 04:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dV8isNUppacynWpg45DwTWA/VWjEAGzXX+K9/4Lkct8=;
        b=f/t4KgC7HXwvjrgBON1ICJtbFLbtYnJ2nherC2JR9NUcExu5ff+BgHVgj4o3OXLQsY
         Mn6f8wfgXRGyF+04P283Mg7rUnYeLvXKjeVQHQ4lr5p69FWd893lW8b0ij1+Zsi734A5
         JcnU1ith+6I6Y8q9iuTjrjrqYssm+ol/Nj5XdUsPtaYMfD2xN7sa2TGezWYBr9AzYMaj
         98se/PLLZwNinK5LxUUmlAXkP/WlUgOGPYxhxE62+LkuXg6DF4yxsyR6gwgfDzcoO0om
         mmY7VzoEr/CzpxjWdbO61mmpuAcGalOMO2rgn9RSxcTZmBMaHh5l7lcL0EAbcfpTiXGq
         4Xdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dV8isNUppacynWpg45DwTWA/VWjEAGzXX+K9/4Lkct8=;
        b=y3eKVavHnI3wqUNFwYNyqhuKTEMvL957e6qCI+yLjd8p9y8JsKeHu+DWFlpxuwTjGU
         CTdksPwxrT0Peojo3kzjGliE6GqPp1nMJs8sxpB3d1s9ra0uB6BnCVRLulSuZpw5YVJc
         4ttLBfxVS7vkcTTjTQp4pxomPNn3HGlZYrwSfjc42cSYbgbl9Kr2Qn4bliHIjjGvOyhi
         hlEbMz7gt6IRr7fubT+4yLiCD7RCXGgqaaCQ4wA85wXls6eV9l9k+VYzV0T8CsSbcKW1
         9oa9kAIUV2dwRyuQbhtG3S/G6j/1uaF/iWWtBOPr5xyPeQralcsbpcjyKzl4+TPIC1/H
         lT7Q==
X-Gm-Message-State: AFqh2krRMFtoegrx4+8sn5BWYqTZ8+ikXndxKHgtBYtkd1du2NGi8spy
        ajtnSGByG82SDrN7tqTka2c1mQ==
X-Google-Smtp-Source: AMrXdXvnTqQsEGOxkGO4mFjcmw+KnpvIu+qJjoICn+Nl3zlT9BcRo1dMNL/QyQWHQH7BEV9i5calcg==
X-Received: by 2002:a05:6830:1251:b0:670:7865:133c with SMTP id s17-20020a056830125100b006707865133cmr10578090otp.13.1672143866971;
        Tue, 27 Dec 2022 04:24:26 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:e4b6:5a8e:5e17:7db3? ([2804:14d:5c5e:4698:e4b6:5a8e:5e17:7db3])
        by smtp.gmail.com with ESMTPSA id s6-20020a9d7586000000b0066ca61230casm6471717otk.8.2022.12.27.04.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 04:24:26 -0800 (PST)
Message-ID: <e527f418-1cfc-df4d-614f-873128bb1368@mojatatu.com>
Date:   Tue, 27 Dec 2022 09:24:22 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v6 0/4] net/sched: retpoline wrappers for tc
Content-Language: en-US
To:     Rudi Heitbaum <rudi@heitbaum.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com, linux-kernel@vger.kernel.org
References: <20221206135513.1904815-1-pctammela@mojatatu.com>
 <20221227083317.GA1025927@82a1e6c4c19b>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20221227083317.GA1025927@82a1e6c4c19b>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/12/2022 05:33, Rudi Heitbaum wrote:
> Hi Pedro,
> 
> Compiling kernel 6.2-rc1 fails on x86_64 when CONFIG_NET_CLS or
> CONFIG_NET_CLS_ACT is not set, when CONFIG_RETPOLINE=y is set.
> 
> Does tc_wrapper RETPOLINE need a dependency on NET_CLS/NET_CLS_ACT
> to be added? Or a default?
> 
> net/sched/sch_api.c: In function 'pktsched_init':
> net/sched/sch_api.c:2306:9: error: implicit declaration of function
> 'tc_wrapper_init' [-Werror=implicit-function-declaration]
>   2306 |         tc_wrapper_init();
>        |         ^~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:252: net/sched/sch_api.o] Error 1
> make[2]: *** [scripts/Makefile.build:504: net/sched] Error 2
> make[1]: *** [scripts/Makefile.build:504: net] Error 2
> 
> below is the relevent lines from the .config file.
> 
> $ grep -e RETPOLINE -e NET_CLS projects/Generic/linux/linux.x86_64.conf
> CONFIG_RETPOLINE=y
> # CONFIG_NET_CLS_BASIC is not set
> # CONFIG_NET_CLS_TCINDEX is not set
> # CONFIG_NET_CLS_ROUTE4 is not set
> # CONFIG_NET_CLS_FW is not set
> # CONFIG_NET_CLS_U32 is not set
> # CONFIG_NET_CLS_RSVP is not set
> # CONFIG_NET_CLS_RSVP6 is not set
> # CONFIG_NET_CLS_FLOW is not set
> # CONFIG_NET_CLS_CGROUP is not set
> # CONFIG_NET_CLS_BPF is not set
> # CONFIG_NET_CLS_FLOWER is not set
> # CONFIG_NET_CLS_MATCHALL is not set
> # CONFIG_NET_CLS_ACT is not set
> 

Hi Rudi,

Thanks for the report.
Could you try the following patch?

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
index ceed2fc089ff..d323fffb839a 100644
--- a/include/net/tc_wrapper.h
+++ b/include/net/tc_wrapper.h
@@ -216,6 +216,8 @@ static inline int tc_classify(struct sk_buff *skb, 
const struct tcf_proto *tp,
         return tp->classify(skb, tp, res);
  }

+#endif /* CONFIG_NET_CLS */
+
  static inline void tc_wrapper_init(void)
  {
  #ifdef CONFIG_X86
@@ -224,8 +226,6 @@ static inline void tc_wrapper_init(void)
  #endif
  }

-#endif /* CONFIG_NET_CLS */
-
  #else

  #define TC_INDIRECT_SCOPE static


