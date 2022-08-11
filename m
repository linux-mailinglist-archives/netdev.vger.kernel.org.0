Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180AC58F514
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 02:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiHKAJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 20:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbiHKAJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 20:09:32 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44497E821;
        Wed, 10 Aug 2022 17:09:31 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p8so15596399plq.13;
        Wed, 10 Aug 2022 17:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=eFBcu9YFdFlsv4/cPb5nOLceR847AjQQE9jq4LyMAew=;
        b=DGdaSB+nwdELrcUx+1Ve2JD8pyl8Jb2NDBX0Rhpo+shLllYuhE7n31Sw8321nnmdhJ
         63JHAC2/BUqnKJLWrllhhDUJKFae9jGrDHYZC3RfJ/i9i+C8yUS6IKMBrndmf/m1+nNL
         Bl4ep0O/CnSofJRdZNBSwMVd92YF9MqmeqMje0tDhbHr6r9AYY8kypiEVfpUe+dAW4q2
         2zv+Rfx6OPf44qYJqVntdXpAxTFvTD10R/ZX3MExQwOKKERDfBR+jClVmx2pznBBNiZc
         SP0mWbU1dUQAdpaxH1/RH0bxkVJWPAJPLzOsdP5FOd97U1juJ/mcicy7x5YjxOWiM//B
         1Tag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=eFBcu9YFdFlsv4/cPb5nOLceR847AjQQE9jq4LyMAew=;
        b=avIg/JBsDi7FuV9rmO+PFzKy5twqW3FJXR9WmVvBkArdWekYRCYs4xgl2yH/qe77un
         lq2aaj/sw3t1P3ZC5zJ38WJLYvOdFBVN9TqXVyjJar9dfBC2RJfSOiXnGHD82LEcrt0L
         y4DUb6LoT2NGtyKX1Ifa32hxQ+Dm/hi5PscJcRI9HgB0fczHoHS66z+c+nxOOU3qhxWn
         AU5unVQy8/S/yVog+tzjnJcTPylnkRrP3l80TQymgRMckfqXEJW9kaX5Z5EWwONXpJAX
         qk6GcJV4R5+DuGJz6/CLI11kfg6jjkEuZCqjXQ8zL9ExV1R/7nFvj4q/EZ6FwIvG1PJI
         HhGw==
X-Gm-Message-State: ACgBeo0XIj8/uMpdNG2X1d9uz/C6Wi1GLLzZj22SzVunpLlhxbJuMGwq
        B38m58grcFabK/RM5VHTf7Irbn4ahToZxFZ4
X-Google-Smtp-Source: AA6agR7f13QP3sxHiWfn03Cth6p40F8Wv6UKsIFJ3leURUC/FE1DcOoVY8YexnRXbxrWsI/Rlf6MOQ==
X-Received: by 2002:a17:90b:4c8e:b0:1f7:2083:a91b with SMTP id my14-20020a17090b4c8e00b001f72083a91bmr6121640pjb.119.1660176570964;
        Wed, 10 Aug 2022 17:09:30 -0700 (PDT)
Received: from [0.0.0.0] ([205.198.104.55])
        by smtp.gmail.com with ESMTPSA id y18-20020a626412000000b0052d5e93fcb7sm2600245pfb.191.2022.08.10.17.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 17:09:30 -0700 (PDT)
Subject: Re: [PATCH] igc: Remove _I_PHY_ID check for i225 devices
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220809133502.37387-1-meljbao@gmail.com>
 <b39c9fa3-1b7c-c7b1-c3dd-bf5ceb035dc8@intel.com>
 <0b4ce201-be78-5a5d-0098-0cbe14ea43fd@gmail.com>
 <da087ad9-981a-2a9f-a134-1f6cab7addc0@intel.com>
From:   Linjun Bao <meljbao@gmail.com>
Message-ID: <65791f63-d4d7-a5e8-06e6-f7030efb35a4@gmail.com>
Date:   Thu, 11 Aug 2022 08:09:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <da087ad9-981a-2a9f-a134-1f6cab7addc0@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/8/11 上午1:20, Tony Nguyen wrote:
> On 8/10/2022 1:22 AM, Linjun Bao wrote:
>> Yes this commit was committed to mainline about one year ago. But this commit has not been included into kernel 5.4 yet, and I encountered the probe failure when using alderlake-s with Ethernet adapter i225-LM. Since I could not directly apply the patch 7c496de538ee to kernel 5.4, so I generated this patch for kernel 5.4 usage.
>>
>>
>> Looks like sending a duplicated patch is not expected. Would you please advise what is the proper action when encountering such case? 
> 
> Sounds like you want this backported to stable. Documentation on how to do it is here [1]. Option 3 seems to be the correct choice.
> 
Thank you Tony, you guide me the correct way, yeah I want this backported to stable kernel 5.4. And now I understand the get_maintainer.pl is for mainline development.

Regards
Joseph

> Thanks,
> Tony
> 
> [1] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#procedure-for-submitting-patches-to-the-stable-tree
