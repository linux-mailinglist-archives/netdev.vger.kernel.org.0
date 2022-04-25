Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A450DA9C
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 09:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241662AbiDYH4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 03:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241675AbiDYH40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 03:56:26 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2314B2AC45
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:52:53 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k12so271483lfr.9
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HugK2ntbkcJCh6QRg1Q+TDwNNZ2dR7iOtRvGXKXtnMs=;
        b=bViRL/hPvcFoJQII8kXHrUbDemTl5jNdXCSQbtZy3YFL4dG4F4sP/g+NRnpjS3h7S6
         o65wO/Tmtv9amgQa+O+sBHWT+BxGRMLzwTmEDc15YlB8tCOxNiZ3ns6le3E4tYU1QG+v
         6Gtr8soaEa92GzJNaizT+YVE7zEXQh/6R84DEA03hahpTNz0hiDFpBRLjNiaMGhij3Lb
         2N8daZEPKXaOeaXLC8HBswmmEezJzG0iDDMNJefpAVf2+w/x4hUCOLVJ5liQBOI0a5JB
         bUSPX6ySQivX+zR1WvcwNKBK0l61j2EkK0JW0+/zBs8Tu+1+gdqLJPtJXMCUMF8nTicv
         Jmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HugK2ntbkcJCh6QRg1Q+TDwNNZ2dR7iOtRvGXKXtnMs=;
        b=QK48fgga94yBduSwYyoN+2R4RtqJFe/WMMtLMx8AXAUtKzpDQ5+/BkaLglnGPbO30n
         iZtPQH+bFthDEqA5gplgeIi22/5l4P3G5nb2gzXU8J0sDPk/F/u8rBecuQNm83ctmG39
         BxSYxhoQNkygSyt+qF020X43W0kFN1pcErB/X3TsjzX/ODhOXFXbxqT5FV159X0riity
         0FO01yD/7PffaoW8nOwk5khMM64e2rTn6iOvs9g98X8lzA+uHTw3dbaT3wY9fes362Aj
         duSXTchjRxJdw0Pou3APlABp1Z+QtN5ef0L6cl5BpfvlkEggEAku9vZi4zuq6jfOLui2
         7Gkw==
X-Gm-Message-State: AOAM532Bc/8LePC0zfk8rGdEBhCMNDAe44e3NetCcTxIS/smDRbCwTcH
        I1g6SSMjnkTn0c+u2ItA8NE=
X-Google-Smtp-Source: ABdhPJzo3zUAPAW8XbpfXlDb8UEWeMRcLX4mKCMsPz2VMqxUo7gE95NUnZBJ5lP/5Sg1cnsZ401eng==
X-Received: by 2002:a05:6512:239c:b0:472:3d5:7e77 with SMTP id c28-20020a056512239c00b0047203d57e77mr3473670lfv.448.1650873171033;
        Mon, 25 Apr 2022 00:52:51 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id w1-20020a2e9bc1000000b0024db4902930sm1154301ljj.25.2022.04.25.00.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 00:52:50 -0700 (PDT)
Message-ID: <4bb1c769-4539-bc97-b32b-a4b884dd297b@gmail.com>
Date:   Mon, 25 Apr 2022 09:52:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC net-next] net: tc: flow indirect framework issue
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@nvidia.com" <roid@nvidia.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
 <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <20220413090705.zkfrp2fjhejqdj6a@skbuf>
 <2a82cf39-48b9-2c6c-f662-c1d1bce391ba@gmail.com> <YlbR4Cgzd/ulpT25@salvia>
 <20220414105701.54c3fba4@kernel.org>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220414105701.54c3fba4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-14 10:57, Jakub Kicinski wrote:
>> I think some people believe doing things fully transparent is good, at
>> the cost of adding more kernel complexity and hiding details that are
>> relevant to the user (such as if hardware offload is enabled for
>> vxlan0 and what is the real device that is actually being used for the
>> vxlan0 to be offloaded).
>>
>> So, there are no flags when setting up the vxlan0 device for the user
>> to say: "I would like to hardware offload vxlan0", and going slightly
>> further there is not "please attach this vxlan0 device to eth0 for
>> hardware offload". Any real device could be potentially used to
>> offload vxlan0, the user does not know which one is actually used.
>>
>> Exposing this information is a bit more work on top of the user, but:
>>
>> 1) it will be transparent: the control plane shows that the vxlan0 is
>>    hardware offloaded. Then if eth0 is gone, vxlan0 tc ingress can be
>>    removed too, because it depends on eth0.
>>
>> 2) The control plane validates if hardware offload for vxlan0. If this
>>    is not possible, display an error to the user: "sorry, I cannot
>>    offload vxlan0 on eth0 for reason X".
>>
>> Since this is not exposed to the control plane, the existing
>> infrastructure follows a snooping scheme, but tracking devices that
>> might be able to hardware offload.
>>
>> There is no obvious way to relate vxlan0 with the real device
>> (eth0) that is actually performing the hardware offloading.
> 
> Let's not over-complicate things, Mattias just needs replay to work.
> 90% sure it worked when we did the work back in the day with John H,
> before the nft rewrite etc.

To me the first thing to determine is how flow_indr_dev_register should work?
With only a superficial knowledge of tc I'd seem to me that if we
have a function called tcf_action_reoffload_cb and tc has all the information
about current blocks/filters/rules it should really reoffload those. The other way
would mean bookkeeping the same information at multiple places. It also
means restrictions on which sequence one should setup a network topology.
Would we like it that way?
 
