Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999B94F9DC6
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbiDHTv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiDHTv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:51:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC963CE7;
        Fri,  8 Apr 2022 12:49:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b2-20020a17090a010200b001cb0c78db57so7474547pjb.2;
        Fri, 08 Apr 2022 12:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7VQXuZOd0i1jvW/8gCp/qhiKPoeAGyVQPlsfy06ITt4=;
        b=ACXahYMulsP2jKhj0mAcWDG3pD96LO59FWQpva03C0IiYkyS1uG5gdfH0vlyTwz5+c
         jXrKokmTChr61HZBdmc79zdx9xVFaNrQ10zYyCAWixVIq56G/B8rcu5WiE048xuOZ1go
         ntgJjoIHOrm286ejdw3NPZlowHtVFjdVpnQmezyhv7CfFXb2Ihx8DC+jdlMLKzf4dPFA
         dzyKkaTdWyi3VV8uKWpTKZOtLlrzqckNCHOMIxVjPWnLrrD+1bbL88O4Yq/h//3w20PP
         Cl1CZzLMZyYGaOC5T2n5P8MzDpvhvBBxWOQbKmOLCzUjyIN0C4oga79Vw9b1iJEZoXhU
         Basw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7VQXuZOd0i1jvW/8gCp/qhiKPoeAGyVQPlsfy06ITt4=;
        b=K5qWETEgb6HPsiEG0J99jveaig4nJPUhdGaNOMTd+onj+0ByqTW6iQHJzgr3O0ZMH2
         MAZsTvpoYRAsb82puBgs87lobtaDUrjXHHvRbC3SwjUjZ7utReephhZsvPSvb4twLRy+
         ngD1hu3Uy0I/XZvOX97YAdC0V6+cFyZTLa9VKNnEh3SZqOB/aiJ93I4bEKSKFkt1qL40
         9FZ9mj5ZLeGYzLXJWGWqJj3h4AsQYBzWflscELKk+bWeYgrlm/fJXb58TYffUIIYd9Dg
         Iwvb4GOAz18/VJGkuz2ClkP2XlHEQDTEe1RdLCHy5FLLU/7IYBYzeYY969G9tw5790Ju
         766w==
X-Gm-Message-State: AOAM53349RePgdHzml2NTWrxiQ/AgpTlCXSl++KSHDYZmP7g9h++WV4L
        XWYuas5GimdH4H50iTEXycw=
X-Google-Smtp-Source: ABdhPJzPEx6FJevH1oP26OCAH9K0RFm/bws+3Hw1AmDOS4a9VwgmVLEiIagDWrkP6KIteD5aaDSMXQ==
X-Received: by 2002:a17:903:11c7:b0:151:9769:3505 with SMTP id q7-20020a17090311c700b0015197693505mr20712810plh.72.1649447392412;
        Fri, 08 Apr 2022 12:49:52 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm26450531pfe.49.2022.04.08.12.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 12:49:51 -0700 (PDT)
Message-ID: <a111f4f5-3b4b-781a-71c2-34dd042fa19f@gmail.com>
Date:   Sat, 9 Apr 2022 04:49:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 0/3] net: atlantic: Add XDP support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        irusskikh@marvell.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
References: <20220408165950.10515-1-ap420073@gmail.com>
 <d4106b81-31cb-2569-6b49-9393bd2c2b34@gmail.com>
 <20220408115825.319e815e@kernel.org>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220408115825.319e815e@kernel.org>
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

On 4/9/22 03:58, Jakub Kicinski wrote:

Hi Jakub,
Thank you so much for your advice!

 > On Sat, 9 Apr 2022 02:32:51 +0900 Taehee Yoo wrote:
 >> I will send v4 patch because of compile warning.
 >
 > Please don't resend your series more often than once a day.
 >
 > If your code doesn't compile cleanly, too bad, you'll have to wait.
 >
 > This is sort of documented in the FAQ:
 >
 >    2.10. I have received review feedback, when should I post a revised
 >          version of the patches?
 >
 >          Allow at least 24 hours to pass between postings. This will
 >          ensure reviewers from all geographical locations have a chance
 >          to chime in. Do not wait too long (weeks) between postings
 >          either as it will make it harder for reviewers to recall all
 >          the context.
 >
 > 
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches

Sorry for that I was too hasty.
I will always send a new version patch after enough time for review.

Thanks a lot,
Taehee Yoo
