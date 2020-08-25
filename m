Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21692252466
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHYXpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgHYXpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:45:21 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D96C061574;
        Tue, 25 Aug 2020 16:45:19 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id c10so128037edk.6;
        Tue, 25 Aug 2020 16:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vrq4v6qq3XTqsCKD1xadXMdCN6zU2zFU1IE+7WmavGw=;
        b=Kn659dFWmM6eaNHeoUbbJFk/+yk+FWcjQ9E3SslJknb596Z2T+k3qG+VekL1ENpr/c
         lxWLaWefCF/KRQcDyXzRSo+u25QhzqOscYX5IuAYW1EITerFlnmBfUgkqu7FQyD52tdQ
         +C7pUhnqfTOeglZSNNoifcCJacfYzW6B2ckXMfJjLGAmy7OvQ90qmZYArLXM72L2PlwH
         YIngkJjC00Bk03d/u0dSLBM1KsdUACbnP72YNgLDLnm8W3BSar02CpmBwGIXWy6J2Svc
         r0gcedYv7R+66E8folLWb+u0VCfvAOoUCmbgXNklCd3WFuCF7LQtUWUV1r3jdD4zzjlm
         Bgow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vrq4v6qq3XTqsCKD1xadXMdCN6zU2zFU1IE+7WmavGw=;
        b=IKkHUXNmy0841pBUP7cG1YqlxWvJeXwzee7WLNoqXUQIy3eH6nbEYF3JJWOdNwggGX
         qDN5RGgKhIYJjuHYY1ox6ZxtJQTr2UcJVwiTNkpMCGUD0SXYI9oSg0k82zqQvHQ9H0yD
         F960Zv6mF1IpPKiXmRerM8+2dk6Aly4RJ7tS7VMElpf3ztkmy6RlqimuHQhKF+CGEW7A
         /HR2kxMXu+U94fCtx7ckTowO+rL+W9DFpCDjg/cqfDgpX1Hp/IdBV64lMSUN19gfOY8A
         /A/XaX9mxPtdeO8GqGE8wZgGCm3YFewoRYj19RgnxoTqAZ+hkGJO9TsmttWGxsfiL6h3
         LfBw==
X-Gm-Message-State: AOAM530JcS+ZUdLzgfYikMxvUbMi1aoDCEU6234RsN65yOpI+5AHXEgQ
        s+VwK7mTk/I5Zvp9CfSNYHw=
X-Google-Smtp-Source: ABdhPJx1TaRXrlWWmd+DeFQoGwngrI/rLvXGBVk1+SYj4vT9Z2hyfjQEHa2Wxgf66AMBphaMsUcjxg==
X-Received: by 2002:a05:6402:c1:: with SMTP id i1mr6143271edu.277.1598399118015;
        Tue, 25 Aug 2020 16:45:18 -0700 (PDT)
Received: from [10.55.3.147] ([173.38.220.45])
        by smtp.gmail.com with ESMTPSA id p16sm342051ejw.110.2020.08.25.16.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 16:45:17 -0700 (PDT)
Subject: Re: [net-next v5 1/2] seg6: inherit DSCP of inner IPv4 packets
To:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrea.mayer@uniroma2.it
References: <20200825160236.1123-1-ahabdels@gmail.com>
 <efaf3273-e147-c27e-d5b8-241930335b82@gmail.com>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <75f7be67-2362-e931-6793-1ce12c69b4ea@gmail.com>
Date:   Wed, 26 Aug 2020 01:45:14 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <efaf3273-e147-c27e-d5b8-241930335b82@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/2020 18:45, David Ahern wrote:
> On 8/25/20 10:02 AM, Ahmed Abdelsalam wrote:
>> This patch allows SRv6 encapsulation to inherit the DSCP value of
>> the inner IPv4 packet.
>>
>> This allows forwarding packet across the SRv6 fabric based on their
>> original traffic class.
>>
>> The option is controlled through a sysctl (seg6_inherit_inner_ipv4_dscp).
>> The sysctl has to be set to 1 to enable this feature.
>>
> 
> rather than adding another sysctl, can this be done as a SEG6_LOCAL
> attribute and managed via seg6_local_lwt?
> 

Hi David

The seg6 encap is implemented through the seg6_lwt rather than 
seg6_local_lwt.
We can add a flag(SEG6_IPTUNNEL_DSCP) in seg6_iptunnel.h if we do not 
want to go the sysctl direction.
Perhaps this would require various changes to seg6 infrastructure 
including seg6_iptunnel_policy, seg6_build_state, fill_encap, 
get_encap_size, etc.

We have proposed a patch before to support optional parameters for SRv6 
behaviors [1].
Unfortunately, this patch was rejected.

So i do not know which option is better.

[1] 
https://patchwork.ozlabs.org/project/netdev/patch/20200319183641.29608-1-andrea.mayer@uniroma2.it/

Ahmed
