Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1F9518105
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 11:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiECJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 05:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiECJcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 05:32:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8965034641
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 02:28:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id iq10so14852897pjb.0
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 02:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:references:from
         :in-reply-to:content-transfer-encoding;
        bh=EWZiGK0YSwR1AT61y5rj8swpeDT/Nh77VqcYoQ0jGP4=;
        b=dSTANvYqimBUrttktNrVtfRmQ+DYaW+2VX9rD1nv8F0JvMR0jypUrMZTamT6scbfg1
         K5EV6wWWlX9eGgaqW5OYPoGPV3nHq3DOSYZ3+jLUH/N4mpayq6KePQ4luoXr/vr8XtY7
         VEBk6hztha/UGLHIy0Pg9WmzNPrKSmcGtC+DiJcogOIOYDWt9S7uceudp2xibKoGc3j4
         TYRmMxPxjPSvIxd1gJIMPWTGNAFReAgzSratUyWHdYZIe7bkJC7H6GMVUOD5QJ7XJ/bE
         uTI0cUhQK1ty8X0HXJ58kSh6mQoPKh5GLWQs5HUEuOuQdjs7F0WQEBENMR1wboq/qTtJ
         mjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=EWZiGK0YSwR1AT61y5rj8swpeDT/Nh77VqcYoQ0jGP4=;
        b=JX4ac0Ns15Q99UuLHd7oXhbMDePDJnrW76rYqnvjhz+qnboJo2RwJ9ErrO3yGFjopa
         2LeYrSLTTNWiJiD8ukhdSoAujez5hPlTD9piOGwWX6sH3xt3H4Vn8AABb4yf9K2JpOa5
         XHLeZmgWmpQXetXzsfSAZOjmE9hTN0UmJ6Hx0J5tFEF+VKi/Sar6+vti5ocTCZ1hIBgJ
         HP0ruqirhKQoTEnnqFArr2EVpDS4UGwr1tVXFC21F2T4d/F8Ao9bhi4nVL504QZczS5s
         TdE7hjse8XCqDvclOI34uUd3MojbIWvlNiovfJrl05zmBQgJBUuZbhB/29I5CMUpWjRk
         8FPQ==
X-Gm-Message-State: AOAM531d46VmYRiyVULM+mqIEFe7uZ8zLnElebjS13295duApEHh+QA6
        B3+KZrsWK1XLAufqQ2O4rjY=
X-Google-Smtp-Source: ABdhPJwyNT/aI8ZlB0tEzs6a+sMYqVlaH+fSo+FH8XRKIjmLcA6vo5e4iuPqVkcn/Q6NTh8NzsOOyQ==
X-Received: by 2002:a17:902:c404:b0:15e:a090:dc8a with SMTP id k4-20020a170902c40400b0015ea090dc8amr10064810plk.31.1651570121944;
        Tue, 03 May 2022 02:28:41 -0700 (PDT)
Received: from [172.25.58.87] ([203.246.171.161])
        by smtp.gmail.com with ESMTPSA id e18-20020a62ee12000000b0050dc76281c5sm5938956pfi.159.2022.05.03.02.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 02:28:40 -0700 (PDT)
Message-ID: <83d7f24b-660e-1090-beef-f42fc29fe8aa@gmail.com>
Date:   Tue, 3 May 2022 18:28:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [net-next PATCH] amt: Use BIT macros instead of open codes
To:     Joe Perches <joe@perches.com>, Paolo Abeni <pabeni@redhat.com>,
        Juhee Kang <claudiajkang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
References: <20220430135622.103683-1-claudiajkang@gmail.com>
 <4320a4cb3e826335db51a6fac49053dbd386f119.camel@redhat.com>
 <56e0b30632826dda7db247bd5b6e4bb28245eaa7.camel@perches.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <56e0b30632826dda7db247bd5b6e4bb28245eaa7.camel@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022. 5. 3. 오전 2:19에 Joe Perches 이(가) 쓴 글:
 > On Mon, 2022-05-02 at 12:11 +0200, Paolo Abeni wrote:

Hi Paolo and Joe,
Thanks a lot for the reviews!

 >> On Sat, 2022-04-30 at 13:56 +0000, Juhee Kang wrote:
 >>> Replace open code related to bit operation with BIT macros, which 
kernel
 >>> provided. This patch provides no functional change.
 > []
 >>> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
 > []
 >>> @@ -959,7 +959,7 @@ static void amt_req_work(struct work_struct *work)
 >>>   	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 >>>   	spin_lock_bh(&amt->lock);
 >>>   out:
 >>> -	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 >>> +	exp = min_t(u32, (1 * BIT(amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 >>>   	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 
1000));
 >>>   	spin_unlock_bh(&amt->lock);
 >>>   }
 >>> diff --git a/include/net/amt.h b/include/net/amt.h
 > []
 >>> @@ -354,7 +354,7 @@ struct amt_dev {
 >>>   #define AMT_MAX_GROUP		32
 >>>   #define AMT_MAX_SOURCE		128
 >>>   #define AMT_HSIZE_SHIFT		8
 >>> -#define AMT_HSIZE		(1 << AMT_HSIZE_SHIFT)
 >>> +#define AMT_HSIZE		BIT(AMT_HSIZE_SHIFT)
 >>>
 >>>   #define AMT_DISCOVERY_TIMEOUT	5000
 >>>   #define AMT_INIT_REQ_TIMEOUT	1
 >>
 >> Even if the 2 replaced statements use shift operations, they do not
 >> look like bit manipulation: the first one is an exponential timeout,
 >> the 2nd one is an (hash) size. I think using the BIT() macro here will
 >> be confusing.
 >
 > I agree.
 >
 > I also believe one of the uses of amt->req_cnt is error prone.
 >
 > 	drivers/net/amt.c:946:  if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {
 >
 > Combining a test and post increment is not a great style IMO.
 > Is this really the intended behavior?

I agree that it would be better to avoid that style.
I will send a patch for that after some bugfix.

Thanks a lot,
Taehee Yoo

 >
 >
