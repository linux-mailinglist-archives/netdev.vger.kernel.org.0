Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8861B4883C5
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 14:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiAHNYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 08:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAHNYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 08:24:02 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DF1C061574
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 05:24:02 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id q4so8418798qvh.9
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 05:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ao+mYao5PN9UDC3Mw8Dk9dSI/gBeXX2VlN8vR9x5IVA=;
        b=359/EXwYgFwIPUk+4uQlP9KOHKuL72vKsIj9SK37whNIaeqpVj0cVyn8Afk0i9dsGx
         tpqvaxS+3dEWecu9wx32gl76wFNiED9kqNWtz8n25pqR26pZx2s3COVJT2N0IDdnWV95
         yH+uPw5OBp49IVb210By2T74Aqlweg/zj3iQPA+6HDQ+k5vmEiOPWRMOuT5fir/s8YfI
         FSXiYIvynDvRPIhVQqE76pHyA+KONfCT4VZJXUWLy9MKrDxzfCZ0JpU/K/YeXrFAS0mp
         DdIOaHYfEHTo1GWh1bJLIb86xB1xidTQLMCmokOXgPgcH5JYCzFEQ3EovVXoJtYBe7U5
         bzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ao+mYao5PN9UDC3Mw8Dk9dSI/gBeXX2VlN8vR9x5IVA=;
        b=tpv5GUI1+o3IIfpPzzDYXLKsIhQb4k72VfBj1HB0YEhRsg9Sh2jsfCnh7da8/GH7Dl
         kEPfAdjjU6G1q1MpsAE7b1CNyAvOdfrwx7eaL8haK0vdsrZxYoUQLqNEbx4gfUcO69bD
         7TVCdFoQ9Qu4yRoNM0j8sGcBlgXPFg8DdjPsy/hh/0S0cbMQNemig9X2MqM/Ypzoa1Uz
         1pEJ4IgmhX8wiQrd+xlbEOUHsgRETO6J1/Ee+jBWRQbhQYza2BnCoVnvV9ZGfuCUWueD
         bnKMXPUUP7pUpS8FDDOUBCCRiIrKTXoelMYcIQCUBQXk44WIJgxWKOO2gEGxUa/CzvxZ
         T1jw==
X-Gm-Message-State: AOAM531OqvoVfWR4SjCr+Np8eBy8FILxRngQK/v8Wj8lRHfjN8qr/A7T
        brcg08/alIJ9/dPQTike4pyt5A==
X-Google-Smtp-Source: ABdhPJyJuTovlLC7iwVO8GDGJGKxLHbuReVdjf2Qz/ZmFMKj1fGz2A59W3t7LBHNH5ZcxSE4VCAgBw==
X-Received: by 2002:a05:6214:e46:: with SMTP id o6mr10991489qvc.110.1641648241378;
        Sat, 08 Jan 2022 05:24:01 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id g5sm1017493qtb.97.2022.01.08.05.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 05:24:00 -0800 (PST)
Message-ID: <0f503669-ffbb-5844-7ef5-27b87aa4c38f@mojatatu.com>
Date:   Sat, 8 Jan 2022 08:23:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net v2 1/1] net: openvswitch: Fix ct_state nat flags for
 conns arriving from tc
Content-Language: en-US
To:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220106153804.26451-1-paulb@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220106153804.26451-1-paulb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-06 10:38, Paul Blakey wrote:
> Netfilter conntrack maintains NAT flags per connection indicating
> whether NAT was configured for the connection. Openvswitch maintains
> NAT flags on the per packet flow key ct_state field, indicating
> whether NAT was actually executed on the packet.
> 
> When a packet misses from tc to ovs the conntrack NAT flags are set.
> However, NAT was not necessarily executed on the packet because the
> connection's state might still be in NEW state. As such, openvswitch
> wrongly assumes that NAT was executed and sets an incorrect flow key
> NAT flags.
> 
> Fix this, by flagging to openvswitch which NAT was actually done in
> act_ct via tc_skb_ext and tc_skb_cb to the openvswitch module, so
> the packet flow key NAT flags will be correctly set.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>


cheers,
jamal
