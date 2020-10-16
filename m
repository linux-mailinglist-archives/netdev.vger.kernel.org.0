Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AAE290952
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409202AbgJPQHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395322AbgJPQHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 12:07:49 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1B1C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 09:07:47 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q63so2339627qkf.3
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 09:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o0gYhmEzcMEprls/DJVzSMZqHL9O3JXuw3Ia+lARi8U=;
        b=j85YRmhdSzO/yKn1LZSjgP4H6qzVlNrauzbpre5CQL4zkoXfF9pnUcn5agSkxYFZyA
         G+31xRyEcQ5K3DezdydXyRrJkTjiHoSm/m2vA0uvFGLlqkl1/WeueX04soJo6DATJkx+
         yiQ9bcuhqBOVJqjtCxP3yc0P5w1tp9ZI7skQgbZejdry8LUU633gJ/DfRZwmqfRKMD5E
         pWQYE6lyIlBHPB7BX5DptXbGJOJ4KoIsVI2LjiU7uNaFokK/Q9fGJ3FirKeds0Nsoq4B
         s3lnCUFdveOuNRdauj5Hf3u2Wbw9vD0Rh17xUYnaLbE34a6whdruXsUVsS+nZO0NajaM
         q4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o0gYhmEzcMEprls/DJVzSMZqHL9O3JXuw3Ia+lARi8U=;
        b=eX3YjqELsk2hv86K5FsTm+RL6GLrsOhb6py4k5R+DIK7BCU7hBvNXUrCnnY5N7yRt1
         zu5mN86uuaHfb5C/ELHprtguF5XUnUIsqFhlFWkgYrvVZA0zS7DTT6pNxFh+74IXf4qJ
         oe6Rp68ENWUWd+usaXgbdJI5R/5HXV32iLVKQS/UDqToKIJW1NW0KR73k2C4Z3FL7gtv
         QkR7unUnFhFYPEsO3wbCsCtRCUY0tdxFDOnHpG67MP9N0cJU5cEa1LeqUh71MyeBvSRg
         ko1/ciKxf1oypEVtv18SCvzrMgWflP0qf9vpJduhV9biMqhwKGGfN37VGOZfzTKMSjkM
         Bz0g==
X-Gm-Message-State: AOAM533iv33LGY9ATBXK4HJhgGGg+PRW4mgDiRVRZSQs5kW5eoiC+BfR
        R6qLw5RI/AhOgN0W8/7WZVX2Kg==
X-Google-Smtp-Source: ABdhPJz8Xk1O9+8JlDCtBAF0k7l0Wiej1w+IhD2XMF3NaPauUPT0n2ho+yzX8Sh80HCP0R7qtUnmvg==
X-Received: by 2002:a05:620a:127c:: with SMTP id b28mr4679375qkl.491.1602864467183;
        Fri, 16 Oct 2020 09:07:47 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 82sm1000834qke.130.2020.10.16.09.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 09:07:46 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        vlad@buslov.dev, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
Date:   Fri, 16 Oct 2020 12:07:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201016144205.21787-3-vladbu@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-16 10:42 a.m., Vlad Buslov wrote:
> From: Vlad Buslov <vladbu@mellanox.com>
> 
> Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
> tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
> user requested it with following example CLI (-br for 'brief'):
> 
> $ tc -s -brief filter show dev ens1f0 ingress
> filter protocol all pref 49151 flower chain 0
> filter protocol all pref 49151 flower chain 0 handle 0x1
>    not_in_hw
>          action order 1:         Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
> filter protocol all pref 49152 flower chain 0
> filter protocol all pref 49152 flower chain 0 handle 0x1
>    not_in_hw
>          action order 1:         Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 

Should the action name at least show up?


cheers,
jamal
