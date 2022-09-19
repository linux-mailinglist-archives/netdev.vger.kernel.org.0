Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C812C5BD29A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiISQw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiISQwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:52:10 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1450D3F1CE;
        Mon, 19 Sep 2022 09:50:55 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id f26so18515835qto.11;
        Mon, 19 Sep 2022 09:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Lz3atA4R6nrrhHxQaJkqKicvJYlqVdz63cFPHxCu8cU=;
        b=MX2pwRJHfiLEYqBS2dDaFne/3FPSIXvw2l1ZPsaGXq2onXv2PgJ0UZi1iS+VlQmh7F
         Z0Nois/yz/CucFDk/wf99qd3/sekx9RWLWoIFmNjTqWYlYg/sejsDgnOdeRdWTA1dAke
         cDgVreRHs5ikg1ER3wFNdtCzBXfG5W7JCec62KdFznLDChTnroak8fha9Aua2MrSvjip
         VFvM9KXuxQ/fMdwW7fYyyRMqKcv3rHwIpzZ0aXIUMPTriJILlmiMX2h1aNi1h5x6grXX
         QZU0KWmy7Zf4efAaS8Ul80alaK73z/olCFRJP62v5eX6e8GHLu+qQZbNilSeEcA0QNJz
         hp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Lz3atA4R6nrrhHxQaJkqKicvJYlqVdz63cFPHxCu8cU=;
        b=opvXYgK0Rk3Qt7j5NtBSieaWQ6zPzWt1lSu9q4ExKR7rmwWst/vEcuqDjuLWvo8FXQ
         4DGZUrtbjG5Ljmjj2VQGWVkKKhYfZ4YXwKBInZ+MYW1u2xDL+WSdzdNALrWFAEKkyZfD
         mviK5FrfSGX9mYrt3BmzSWWYnicj04I6ZlwfSzPogWMdc7ioaTkJ5rziGUgJwum56mJP
         +98X1YKvMy7MzPe1TMqbuGy/mbgAmdMYyy1l8upGVrSCzvy5X6LL7MHmlT04Xn9IocCA
         23nUs2P6mMT4vnumIRrf5u+RNn/f+QwKEcaX4bosHRHXN6TiSdhmM/eZW9BwM34vcFLG
         gkFw==
X-Gm-Message-State: ACrzQf1uMZm60YM9eGu57gLWWUKJkOerChQN2o4OTDdD1hsZeHkpJbwr
        txfBDEj3AoSOL1HqU5NcF3Kf+OqpLvk=
X-Google-Smtp-Source: AMsMyM6we4T9efqZbXB/OAr2oporYksGZawdmkHHa/g6sQp4LxBARTXi9G6WvZDZgotQnFtEFPjymA==
X-Received: by 2002:ac8:4e4b:0:b0:35c:f64d:ea3e with SMTP id e11-20020ac84e4b000000b0035cf64dea3emr523665qtw.251.1663606241248;
        Mon, 19 Sep 2022 09:50:41 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:e599:ec9f:997f:2930])
        by smtp.gmail.com with ESMTPSA id l3-20020ac84a83000000b00342fc6a8e25sm10738753qtq.50.2022.09.19.09.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 09:50:40 -0700 (PDT)
Date:   Mon, 19 Sep 2022 09:50:39 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, jiri@resnulli.us, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [RFC PATCH net-next 1/2] net: sched: act_api: add helper macro
 for tcf_action in module and net init/exit
Message-ID: <Yyid37e8ddqU1NrG@pop-os.localdomain>
References: <20220916085155.33750-1-shaozhengchao@huawei.com>
 <20220916085155.33750-2-shaozhengchao@huawei.com>
 <YyYZ5cKm5TiuKBgv@pop-os.localdomain>
 <6524401a-4e1f-61bf-5b8d-e56b4fcdc67d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6524401a-4e1f-61bf-5b8d-e56b4fcdc67d@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 07:07:22PM +0800, shaozhengchao wrote:
> 
> 
> On 2022/9/18 3:03, Cong Wang wrote:
> > On Fri, Sep 16, 2022 at 04:51:54PM +0800, Zhengchao Shao wrote:
> > > Helper macro for tcf_action that don't do anything special in module
> > > and net init/exit. This eliminates a lot of boilerplate. Each module
> > > may only use this macro once, and calling it replaces module/net_init()
> > > and module/net_exit().
> > > 
> > 
> > This looks over engineering to me. I don't think this reduces any code
> > size or help any readability.
> > 
> > Thanks.
> Hi Wang:
> 	Thank you for your review. I think this macro can simplify
> repeated code when adding action modules later.
> 

I don't think so, it hides the actual code in a less readable way. I'd
like to read the non-macro code.

Thanks.
