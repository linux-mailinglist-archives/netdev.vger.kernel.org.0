Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D164F992D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbiDHPP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbiDHPPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:15:16 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EEF10A7D9
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 08:13:00 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n35so5700615wms.5
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 08:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=7tXZx8oH96HDrRtoUcUe3uYfImnor8ldCRWa8fP3YqI=;
        b=TZGGlsdIdgJLOaLG4OVDpx62hXDS6QlvdanrxXJe/0OWdSMkWNKcjjtS07nSF3Cn7T
         V7rakqD7T5ZV3Om3JzEOLzEalVPsYtMy+3FdKCFPvjO78Hf4Hk/kEnGgKO0KzVNjnxlk
         RARQ6EI1vu6pYelo23R6RNXSdXIAyJEdS8JGyqzXx68oGF/tvxfjYo88eJxnqPIjFbwR
         msmRqDs6+jfFDdPgxZ3nd2CTbokDG6VyQ9A274LubMhBBMCgalZ4Ed9Vt6ztG2kPTdfN
         J1RKaCBIWZiHnSTl5C40RH6hdtoB6g8elqCIkzeClMCqjz6RmwB0D6BOPp+1oPOGKJ8c
         yddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=7tXZx8oH96HDrRtoUcUe3uYfImnor8ldCRWa8fP3YqI=;
        b=rvvwhHAhYZOBfkC41spRXRS4hh72XIZlq6OesQ3wI5FP0JvYhqe259ltFbOmE5LTHH
         pOmoVUuNWnUBJ/eGJE1kTS+ueDFVprBenK394EI583UOEcjDnIvyVdz/CVIn3pLba0zq
         bcgOXX+oEbwk3M5w/kRLklA+tnceCLO5C0CJ0yr/AWIM18KTVF9PZKJ1NgzHNsZtNDjk
         1l6U88iJOxEFECLCZBXnNT1xONRgcq/3Ns03E2Z7F4hyY2FTu/Q6sz+JQ+ba/YZ9slzJ
         7pHyuajxcSqSVVpP5af/Ur69C8l2nF68+P3hcFRZxc5pVQN7fRKaZrzg69W6qkXj/+Y/
         z1kQ==
X-Gm-Message-State: AOAM530s5gRAwAAEvBAHCFz2sH5biATfgUnN63uv2zs+ZLCDfoF5IZZ5
        rWBPbTATUbQdN1IlFr7hbRul5d1IC7WrCTUz
X-Google-Smtp-Source: ABdhPJwN1SifnbMvZzCVpRLwTZWKZYq/Jz62Cu8CnBH8uz/PC+ZMNQVnyDLauRA1mnSjxEILfYAEKw==
X-Received: by 2002:a05:600c:154d:b0:38c:e9b8:d13f with SMTP id f13-20020a05600c154d00b0038ce9b8d13fmr17373176wmg.183.1649430778660;
        Fri, 08 Apr 2022 08:12:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:80c8:5ce1:a798:8d34? ([2a01:e0a:b41:c160:80c8:5ce1:a798:8d34])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c198600b0038cafe3d47dsm11468817wmq.42.2022.04.08.08.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 08:12:58 -0700 (PDT)
Message-ID: <397eda34-c27b-ea88-a137-bddaa9609b58@6wind.com>
Date:   Fri, 8 Apr 2022 17:12:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2 1/2] net: ipv4: fix route with nexthop object
 delete warning
Content-Language: en-US
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     stable <stable@vger.kernel.org>, dsahern@kernel.org,
        donaldsharp72@gmail.com, kuba@kernel.org, davem@davemloft.net,
        idosch@idosch.org, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Philippe Guibert <philippe.guibert@6wind.com>
References: <20220401073343.277047-1-razor@blackwall.org>
 <20220401073343.277047-2-razor@blackwall.org>
 <c87b0c4a-ec11-22a4-af19-9bf814a2214f@6wind.com>
 <CA+res+Ss4v8Y_xHyqz3HsqMNnuG71PygjxxX=RaMx8d_PquF8A@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CA+res+Ss4v8Y_xHyqz3HsqMNnuG71PygjxxX=RaMx8d_PquF8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 08/04/2022 à 17:06, Jack Wang a écrit :
[snip]
>> Could it be backported to stable trees?
> 
> Normally stable maintainer will auto backport because the Fixes tag.
Ok, there is no mention of this here:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Thus, I follow the 'option 2'.

> I tested with stable 5.10.y, it applied clean and the fix works.

Thanks,
Nicolas
