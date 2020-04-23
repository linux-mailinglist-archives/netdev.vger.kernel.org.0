Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F031B51D4
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgDWBdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWBdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:33:43 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B56C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 18:33:43 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t8so2077385qvw.5
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 18:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hQZreuLotPHHKx7xw/UOadFcaq9wGFesE+jCD9BAoGA=;
        b=ZrCNmWMz6rQF+lqqsMXim0Fjt/u5J5Dl0GKAyjokMX8xnaF1+f9S3Id6gzH8oHRlll
         9VOQLRVy03Aqs3p4en8AaPUVv/QjP+caYw1NYteCzB4bfe7obdG0yD2C16JNmbebWPG7
         Df5q2E+eK+vQk+KAlOy9ANIe1dTnze/av+9HRAqWgD2u6jPXhztAHO7X5cPE7fORseC2
         xzIHTmCy4goSN5er3xZtgKJIwI78SOmUmzEtRwB6u0icePkQ1gdmQd8u5vWLq1YjLYgE
         C6Ud3S69+yaBSGW5fUSlALG77h6IitxhTZtz0Ozw5IELYKJTrjFjXOy2sPEeMGqi5ePW
         AJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hQZreuLotPHHKx7xw/UOadFcaq9wGFesE+jCD9BAoGA=;
        b=QTjuIFERwx1zp++SVKCQcDJWdEvZ3fGgjPdIh1iaVgPsjq75zV0cjK6oyrKYS/tQww
         VRLTi9dFTVY95QWesqqUvfUY22UPcKp4awuUOD68Z7nFzXPtZP/psBgNa+omxx7QsLQy
         /jFpaK/9GhWjKD5pAlZukilVdd8OP7xz3GOJGQWkCd35Q3aGafyQIXHEKvznmVGBcwB5
         GmjPa/TeTm8ac6SAv/m6hFdDGMgWtrvVblZX6JwRQSB1cpzaPKlKxHa82O/saDduj/Ug
         lHj8UaRW/5ga0i2UzrNZNek/XaW/WC39wbNbhCBWDobxi6X1Qgy3P7DCBVZhfW2WlhHs
         iETA==
X-Gm-Message-State: AGi0PuZ6/+LgbAkmMyKnJ0hq4Ve794LsJt+rvLJaiQM6qUMcpOaeMsA7
        mj2bsTm/rE+IpjqhOVSawxE=
X-Google-Smtp-Source: APiQypLlt16jpdR0ZxfgonfJQD9gN0ECm3dE9hgvhR1LSCg7klqpAL18NHJBVG8thNhx4WFna+rCCA==
X-Received: by 2002:ad4:4e65:: with SMTP id ec5mr1989051qvb.32.1587605622779;
        Wed, 22 Apr 2020 18:33:42 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19e:4650:3a73:fee4? ([2601:282:803:7700:c19e:4650:3a73:fee4])
        by smtp.googlemail.com with ESMTPSA id b19sm680750qkg.72.2020.04.22.18.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 18:33:42 -0700 (PDT)
Subject: Re: [PATCH bpf-next 12/16] libbpf: Add egress XDP support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-13-dsahern@kernel.org>
 <CAEf4Bzb1Zu1pYvPm+UhT9v7JVBjxOhABA9-fVEza=p0Wpr4e9Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6d931d8e-41cf-7cbc-bedd-d0715527a499@gmail.com>
Date:   Wed, 22 Apr 2020 19:33:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb1Zu1pYvPm+UhT9v7JVBjxOhABA9-fVEza=p0Wpr4e9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 7:19 PM, Andrii Nakryiko wrote:
>>
>> +int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
>> +                         size_t info_size, __u32 flags)
>> +{
>> +       return __bpf_get_link_xdp_info(ifindex, info, info_size, flags,
>> +                                      IFLA_XDP);
>> +}
>> +
>> +int bpf_get_link_xdp_egress_info(int ifindex, struct xdp_link_info *info,
>> +                                size_t info_size, __u32 flags)
>> +{
>> +       return __bpf_get_link_xdp_info(ifindex, info, info_size, flags,
>> +                                      IFLA_XDP_EGRESS);
>> +}
>> +
>>  static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
>>  {
>>         if (info->attach_mode != XDP_ATTACHED_MULTI && !flags)
>> @@ -345,6 +376,22 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
>>         return ret;
>>  }
>>
>> +int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id, __u32 flags)
> 
> Is bpf_get_link_xdp_egress_id() even needed? This is a special case of
> bpf_get_link_xdp_egress_info(), I don't think we have to add another
> API to support it specifically.
> 
> Also, just curious, would it be better to have a generalized
> XDP/XDP_EGRESS xdp_info() functions instead of two separate ones?

Toke mentioned that too, and I have removed bpf_get_link_xdp_egress_info.

bpf_get_link_xdp_egress_id is needed. The flags argument is a direct
pass through for the kernel uapi and correlates to XDP_FLAGS that are
passed to the kernel. There is no harm or overhead in exporting symbols.
Having a simple, easy to use API for applications is important to making
a library user friendly which is key to its adoption.

Will fix the other comments.
