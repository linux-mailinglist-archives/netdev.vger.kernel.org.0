Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56066090DE
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 04:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJWCy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 22:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJWCy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 22:54:28 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5074D1012
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 19:54:22 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-13b98587fb4so359902fac.0
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 19:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFe5pPAagGmzvFbahLXaI2A6kAZo1avW0+zEReLuGbo=;
        b=EipWqOyNRGM16B/RmdFLk3bGG1oiGgjoCVUXJUbd3L+dEAbKyaiQDCND4cVEMe8Z89
         KUIQQ9g+lqEskE9Qt6xETdI8pDhvsaGrkKiqb30TyJhvg9g+BdQ1TJDfsG7+ov62zYFw
         axv/oHlGj9vgUnSGn19ig09KvrTa0O/fwMGZ9suvmMIvu84mpCWiX7E3KgZSlnC2Xe7R
         asiMG8w4M9df4gKgkPS4FvA709oUXiJ7+q4Rrs96mz34onyzs5psCNqo9/I8+b2EKMnD
         /jsX0CDupYblLSsuimmPqokX1H57fW58OoexjdBsLwTSrt8kdRN5DA+lWAskM1bO8KkT
         HFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFe5pPAagGmzvFbahLXaI2A6kAZo1avW0+zEReLuGbo=;
        b=8IWalzBzTjT43KfDgI1rasMMNslUFW5TJ7fCj2Y8Gili3yztqOUGAMEXT4gLdG/NHX
         Dtsmi2lkKHZds9KFlWDc+2dJ128BpdFwkI4cZcchYPtvBEeUEdSkSh5RYT48t9DJhuB3
         6LELA3cwqFsEo8O2q9XOXJO9NmezjWJqY1dJt66Z/vJ0eOeBBrhderOVq7yHguCY/ped
         Y+yWu3mhHtGKXOFIRSTpvnPtZg7rerDuS5jKYbl1nBK27y3eiaZCfhPAnBLLbguJ1H6B
         mAHTKO1OxJQVp7ACXh0jubTF6IogxccW/0oBrn/DTlozVpx0oQLI/45nkqyZ7hTGPg0/
         zwoA==
X-Gm-Message-State: ACrzQf3kaWba8Itkvet4dNUZyBhhqhTZN9lMmEyYR/4EY9JXhbl5fuHz
        VtAxvM/upNE57VWh/As5VHw=
X-Google-Smtp-Source: AMsMyM7HD+gXOg9tfDQvfNlqx+NaRH+/J5jfLrvtJW/KRf+sY1LHvvW0YzHBV6tp5R6foroGqWcDPA==
X-Received: by 2002:a05:6870:d686:b0:12a:f869:cb90 with SMTP id z6-20020a056870d68600b0012af869cb90mr33063921oap.242.1666493661702;
        Sat, 22 Oct 2022 19:54:21 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:2e02:af9:d9bc:69c5])
        by smtp.gmail.com with ESMTPSA id er33-20020a056870c8a100b0011e37fb5493sm12303767oab.30.2022.10.22.19.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 19:54:21 -0700 (PDT)
Date:   Sat, 22 Oct 2022 19:54:20 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kaber@trash.net, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net] net: sched: cbq: stop timer in cbq_destroy() when
 cbq_init() fails
Message-ID: <Y1Ss3OaWuWR5p2A3@pop-os.localdomain>
References: <20221022104054.221968-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022104054.221968-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 06:40:54PM +0800, Zhengchao Shao wrote:
> When qdisc_create() fails to invoke the cbq_init() function for
> initialization, the timer has been started. But cbq_destroy() doesn't
> stop the timer. Fix it.
> 

Hmm? qdisc_watchdog_init() only initializes it, not starts it, right?

Thanks.
