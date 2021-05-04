Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03E237247E
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 04:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhEDClP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 22:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDClO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 22:41:14 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C16C061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 19:40:20 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id g15-20020a9d128f0000b02902a7d7a7bb6eso255043otg.9
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 19:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tNIp3orXfPodlfXi3Yb0NNE7Op3g69xIG1ULLs8ziTM=;
        b=ddSvDHYGhRjTbncRm7mRjadHMFZ2YshBDM9uAa8ERpcvRuNSSyulsv57rx93nXGaiF
         7R8S1hbFgjaYeuKZ9xBfPrVOrWUwMrxHmlzKwB9A1Nl4evuQQTxFZ8FgXz/WuZnJvV3u
         FBr8HqnUjAiMzYLizGuVuo2hIE+3OsReWNM0y466UmfOqua7KUKOo2lZySjlPYYj4Ii9
         v4CQZPA+5MReSLS/ZSR5a+2d18MmDL9e8b2XzrRa2kf+x0o9zlFS79LHDCUXUHH/AHgb
         Xdq0/Xrc9kKPiZOSnTvC9QVJpGLzCKwCKVN4IDw0XyPMpZNclqH9+rSWWI6qXDOhEjVe
         JlFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tNIp3orXfPodlfXi3Yb0NNE7Op3g69xIG1ULLs8ziTM=;
        b=HMEkCaIKS98TsAPlfim5c+NwiIEGu3PtCwRPMO5H8yRCBjDYuezSE2+vwPIoz8S7Ev
         1/Z4HtAMy+Sib1mHWoPj/KsF/uyISAR+fAiK7HWEmbeGFYS822rD4uxaqVWiCpfExvSi
         EgdFxI+erZ0uUw3psFTwxnHaiSixoohPmZc2m/8DR1q8OhXC1eqgDGit5G3JjT+klZmg
         PZNdF+XzeBuzhi1WVmjClC8IGLoumK7GsEl0ER5w2y7q/PlIeeQAxbdWoCzxHS5D46VJ
         HfB78GKee1IL6pSGKIX0NfpunSPueIArworZgbK996Jo/gNmRJfM7ckonFODql6YW0Pt
         V17w==
X-Gm-Message-State: AOAM533GObxedpSckfki4boUmMzjIgx+CjznzYmXdhGP+Wz8IiwYHwzl
        UdKPJ2+2OIT0tQDr4YVGBAY=
X-Google-Smtp-Source: ABdhPJwWJE1kADlTKGRf0AxvkZmjsrCf/pCZDHK/ZSdK463TKa/3bSSDyQJrOksefm2WrSdGCc/ZRA==
X-Received: by 2002:a05:6830:108c:: with SMTP id y12mr17677662oto.276.1620096020156;
        Mon, 03 May 2021 19:40:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id o6sm483695ote.14.2021.05.03.19.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:40:19 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 03/10] ipv4: Add custom multipath hash policy
From:   David Ahern <dsahern@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210502162257.3472453-1-idosch@idosch.org>
 <20210502162257.3472453-4-idosch@idosch.org>
 <7cfadc51-2d4a-f7ed-f762-eb001b0c2b32@gmail.com>
Message-ID: <beb58830-de0e-cb47-0a5c-6109be737fb5@gmail.com>
Date:   Mon, 3 May 2021 20:40:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <7cfadc51-2d4a-f7ed-f762-eb001b0c2b32@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/3/21 8:38 PM, David Ahern wrote:
> On 5/2/21 10:22 AM, Ido Schimmel wrote:
>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>> index 8ab61f4edf02..549601494694 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -99,6 +99,8 @@ fib_multipath_hash_policy - INTEGER
>>  	- 0 - Layer 3
>>  	- 1 - Layer 4
>>  	- 2 - Layer 3 or inner Layer 3 if present
>> +	- 3 - Custom multipath hash. Fields used for multipath hash calculation
>> +	  are determined by fib_multipath_hash_fields sysctl
>>  
> 
> If you default the fields to L3, then seems like the custom option is a
> more generic case of '0'.
> 

Actually this is the more generic case of all of them, so all of them
could be implemented using this custom field selection.
