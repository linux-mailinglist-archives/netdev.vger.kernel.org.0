Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B228561624
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 11:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbiF3JTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiF3JTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:19:37 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EA13617B;
        Thu, 30 Jun 2022 02:19:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id jb13so16491612plb.9;
        Thu, 30 Jun 2022 02:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fLYDaSCtaI4oKBIoE33L26xaElZMqg+lpnSIEv8ui4M=;
        b=lQS+XYiWOOir8W0h4O7FLvFCbXwQ1NslTGRCyy+sYAdMQt7kYtHsiTaqWvnlQphT52
         rmH/898s2V8aSXHRk7DAEazmm7cuRgEGYHW9S+WDmA2fBPpwq0bg5q1af6s9/PQ/dq3x
         3NCjGiJkt67TAmLgL0zS5JllWOc9ovhWit0j+ex/4XXqr9Ab7Ry1Y0T1T9YwLOuSGQgQ
         xhVe/3MU46/JycjOULbinyJ2qZCQ/noICqDmAGaY82NNjvJuUZr6n9UeLGidhofdUKW9
         /O/uVMCJ9vkznFRg4l+tHHyHlS2i3SksSlXnllf82f8lYmIeVgAq216JCnejPGkj1KZ7
         MKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fLYDaSCtaI4oKBIoE33L26xaElZMqg+lpnSIEv8ui4M=;
        b=PMQISoBvzHhZNknGRdgQyXdZRsGYCsdvGLZxv2M+rr3PNxaqJXDAL2GkKZqlzX0ayn
         n9AS0L+BVKOnJlCfW1wrcGigEhe0nhyV81nKln25qiD84zSp4iY9T1kGsR3loZIc4cJW
         qa7Bn4aaa1IFfoFchCw4ZEEZn4/qz7GXqUCkg+piTq8sFR0Q5dU3L0Gov9i3vVD5QDZA
         m49u54wHIL+7jI8fq1ZnlLl3FGlCKOiHPRm31mz+bkdnoFYGPsiLFj8PiNMBmAXzzePc
         JDA6hNyFf8IhqQMrR96vfvefY5EYhZwNfRm9Vdn+m7GQOiLHBupzB/cA+UVZJuud/UYd
         RRfA==
X-Gm-Message-State: AJIora+7AAcqipHfbKArYFt5+PgfrxLC05Hw1nTiC6DpWOpyCG1RdD7h
        EHnxefBHcQW1eCwHvL/kA9BZ4jQ6mLSNzA==
X-Google-Smtp-Source: AGRyM1vLop+Jg2Qyz8OlJ9mHLFy3qCvrTfWpgyKdWHGPoJmvygDLtysX/JGUENFAxWM/OgooTXeEUA==
X-Received: by 2002:a17:90b:3a8d:b0:1ef:7d4:6a5f with SMTP id om13-20020a17090b3a8d00b001ef07d46a5fmr8969827pjb.139.1656580766226;
        Thu, 30 Jun 2022 02:19:26 -0700 (PDT)
Received: from [192.168.50.247] ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b0015e8d4eb231sm12958654plp.123.2022.06.30.02.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 02:19:25 -0700 (PDT)
Message-ID: <665de056-6ec1-e4e1-adf9-4df3e35628b7@gmail.com>
Date:   Thu, 30 Jun 2022 17:19:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] net: tipc: fix possible infoleak in tipc_mon_rcv()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        tung.q.nguyen@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20220628083122.26942-1-hbh25y@gmail.com>
 <20220629203118.7bdcc87f@kernel.org>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220629203118.7bdcc87f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/6/30 11:31, Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 16:31:22 +0800 Hangyu Hua wrote:
>> dom_bef is use to cache current domain record only if current domain
>> exists. But when current domain does not exist, dom_bef will still be used
>> in mon_identify_lost_members. This may lead to an information leak.
> 
> AFAICT applied_bef must be zero if peer->domain was 0, so I don't think
> mon_identify_lost_members() will do anything.
> 

void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
		  struct tipc_mon_state *state, int bearer_id)
{
...
	if (!dom || (dom->len < new_dlen)) {
		kfree(dom);
		dom = kmalloc(new_dlen, GFP_ATOMIC);	<--- [1]
		peer->domain = dom;
		if (!dom)
			goto exit;
	}
...
}

peer->domain will be NULL when [1] fails. But there will not change 
peer->applied to 0. In this case, if tipc_mon_rcv is called again then 
an information leak will happen.

Thanks,
Hangyu.

>> Fix this by adding a memset before using dom_bef.
>>
>> Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
