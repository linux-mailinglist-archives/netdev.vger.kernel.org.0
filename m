Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1979E61A40C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiKDW2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKDW2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:28:17 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5490143AE9
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 15:28:16 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o30so3773185wms.2
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 15:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Vz94NQx4bg3V8rmKTdcRAM+MLA1vV2c3Cf0Uu7kmjJU=;
        b=D3gNVAO8LaCxomo7ENXgv72WuB77gAO2iLvOVeEDfha1PRfPrxYN9ak36nF9kvk4Ed
         t8iHrBHAzM5wzIknaASBPtJfIDS6evXNMZPlWRmB/XF6xo/gPWRhD8FEq3ka3nyqOsF4
         9A/MLbX+yGzjX60HKnPiGUBsP2PC44I0DNaBY9fHU2grBAhpX04vbn0kMhTw3bNd5KM7
         Q2BH9aDvm0yPpj6aryqBnaknJI1WkxDATGffu/Pbdls6n2cfl7sLX6Xy0+tmyYsegVTG
         lveQr48Q6jWyc+5x7K45vZ5DsUKJYAFdu7Zyw1PPn6tWrgHUoENMaXX8kwWwHvrToN1s
         1Deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vz94NQx4bg3V8rmKTdcRAM+MLA1vV2c3Cf0Uu7kmjJU=;
        b=fWiclQPs23FSTSrMTsKdXymTPo8Vg0bo9gnT5TLOAkDY3Ukdcb0JsY2l5wHpOKVdvd
         PY1VJEJ5tfztTBrJptdGWzWfmordsW+vdw72zKURRB35dQApeT4mtbDxO9LJcBXQK/3n
         ZEFod4p0Qdvo3V/4gwff9XIDSK9w6dD8dcqX4B3XIL0juYAS6uHIU37nFXWZonqJkf0v
         SNPhB2OdZN24l0lPb/DldrDrRFvo3wr3fwh0BHmM5iExG1pUlizIRdp/oonWFhUamINn
         SJ7BHmjcs4B307D1dJLGWKclHUVxYQrLNa6+t6FQ714M+cnQo0mYKOGamqCHkU8nUPtY
         f2xw==
X-Gm-Message-State: ACrzQf3HlJ2ELAnYHkgPSXwLhaXHL5CAlF0MrcJK/MppMxKHhcdvYb2m
        3JyhY9+M/ANGEL5rjrswRRgR9Q==
X-Google-Smtp-Source: AMsMyM5Mc25ErYENT3Xeo+Kpfyig4cecFde8QQoYWg5J2xFxaxeIPYIvrNzKLRoFStNju0xGUshAhw==
X-Received: by 2002:a05:600c:2d85:b0:3cf:9cd9:a88b with SMTP id i5-20020a05600c2d8500b003cf9cd9a88bmr2181874wmg.92.1667600894871;
        Fri, 04 Nov 2022 15:28:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:58af:dfc5:5988:a97d? ([2a01:e0a:b41:c160:58af:dfc5:5988:a97d])
        by smtp.gmail.com with ESMTPSA id d6-20020adfe2c6000000b0022cc6b8df5esm478272wrj.7.2022.11.04.15.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 15:28:14 -0700 (PDT)
Message-ID: <3631cc77-6866-904b-e256-0d66af44fcc8@6wind.com>
Date:   Fri, 4 Nov 2022 23:28:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2 12/13] genetlink: allow families to use split
 ops directly
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de
References: <20221102213338.194672-1-kuba@kernel.org>
 <20221102213338.194672-13-kuba@kernel.org>
 <cea8a3b5-135b-efc6-ae8d-2a27c1db3b5f@6wind.com>
 <20221104151920.141553de@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20221104151920.141553de@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 04/11/2022 à 23:19, Jakub Kicinski a écrit :
> On Fri, 4 Nov 2022 23:10:57 +0100 Nicolas Dichtel wrote:
>>> +		/* Check sort order */
>>> +		if (a->cmd < b->cmd)
>>> +			continue;  
>> If I understand correctly, the goal of the below checks, between a and b, is to
>> enforce flags consitency between the do and the dump.
>> Does this work if the cmds in the struct genl_split_ops are declared randomly (
>> ie the do and the dump are separated by another cmd)?
> 
> I'm trying to go further and enforce sort order as weel (see comment
> above the check), so that we can use binary search if we ever get to 
> a large enough family for it to matter.
Ok, thanks for the details. TBH, the comment before the check confuses me, I
read it as an explanation of the check, not like a TODO ;-)
