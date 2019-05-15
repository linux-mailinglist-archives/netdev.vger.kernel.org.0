Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B231F7E8
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfEOPnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:43:35 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:42692 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfEOPnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 11:43:35 -0400
Received: by mail-pl1-f176.google.com with SMTP id x15so58446pln.9
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 08:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RqxWv6KRTQkR9bm4kJgLejCSRILBr5S/s6oUQe3FJXo=;
        b=gc70Lxz6rNjlvOpWduRQDojN9R7AfBniBPVFf3lGHvLRskXV05cIdmw/pfM0Ywym9R
         ometjdvc7xs7DQBI1cGYX7JUPVt9fc8k98AgsWrnXb+3lZzAsKQ0xQnrfaaKPsyfCEP3
         wc5gqkB6TBCldKsJje2i9/MmGvoNN5okwW/cKRMXAjSGV1KPfEiC2ZMosqxFlso7fz+2
         YJt7PEvyejGLAZacfuQMm30iHKrvQeeeHVUcir6oqYlwY7pvBMWiyWuTcD+HYViFpAv4
         WT1BNvERgiqJefXJhMklYOzwlWZgt/w5JinHfuOc1vtU8+t+pORjrkh2CzX8BA57tD7Z
         Yddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RqxWv6KRTQkR9bm4kJgLejCSRILBr5S/s6oUQe3FJXo=;
        b=Hr9ojaEaMIi2UEMogtIVwg29ytNMiA5I3bqz/4lWNy5AYd/Nkec3ZIRIIWw07+XYA2
         O5/9YCOSeOOOVprrcAe0nG55oSJEaisvsZtAfGKW70HtIwocS7Kh49wByN6GMO4mNFTQ
         B5sWUr8lTZ+Mlxg6pbxdvCc/WffWGUCa4e3RmY9N6rHkW5euyICSXxn+GZvssI5poqXu
         Fd90LUNHuIjVmUXmVFcOVEWtqw7BVw91SmsaJFhjRgz7ivBSsVC7ZBAe8B9xquHgE0ua
         s3JDXA1XmRkwRCaGVDyf6OS48noxadYWxHxImTcJ7sfr+abB0bLD2Pq6GYKWHpSJ4L5g
         /dOQ==
X-Gm-Message-State: APjAAAUnuZI/1+NyH0Vd9VVMugU98/SfU5sesejl++Jwxqe3dRVtIjes
        M8fKwj/T2S2W4ceYHUsi5OLENgSS
X-Google-Smtp-Source: APXvYqxCF+YbZ9+ZY3ONpah+J1FcTHzXbEBplKFOaj4nhaQbyd+JdKcfPRRe4JMUpTGvfA8Qoy5RFA==
X-Received: by 2002:a17:902:201:: with SMTP id 1mr26636265plc.89.1557935014135;
        Wed, 15 May 2019 08:43:34 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:81dc:8ee9:edb2:6ea? ([2601:282:800:fd80:81dc:8ee9:edb2:6ea])
        by smtp.googlemail.com with ESMTPSA id t78sm7095257pfa.154.2019.05.15.08.43.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 08:43:33 -0700 (PDT)
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
To:     Wei Wang <weiwan@google.com>, Stefano Brivio <sbrivio@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
 <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com>
 <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
 <20190514163308.2f870f27@redhat.com>
 <CAEA6p_Cs7ExpRtTHeTXFFwLEF27zs6_fFOMVN7cgWUuA3=M1rA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f818d389-66e3-e952-4466-fc047cf15c21@gmail.com>
Date:   Wed, 15 May 2019 09:43:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_Cs7ExpRtTHeTXFFwLEF27zs6_fFOMVN7cgWUuA3=M1rA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/19 1:33 PM, Wei Wang wrote:
> I think the bug is because when creating exceptions, src_addr is not
> always set even though fib6_info is in the subtree. (because of
> rt6_is_gw_or_nonexthop() check)
> However, when looking up for exceptions, we always set src_addr to the
> passed in flow->src_addr if fib6_info is in the subtree. That causes
> the exception lookup to fail.
> I will make it consistent.
> However, I don't quite understand the following logic in ip6_rt_cache_alloc():
>         if (!rt6_is_gw_or_nonexthop(ort)) {
>                 if (ort->fib6_dst.plen != 128 &&
>                     ipv6_addr_equal(&ort->fib6_dst.addr, daddr))
>                         rt->rt6i_flags |= RTF_ANYCAST;
> #ifdef CONFIG_IPV6_SUBTREES
>                 if (rt->rt6i_src.plen && saddr) {
>                         rt->rt6i_src.addr = *saddr;
>                         rt->rt6i_src.plen = 128;
>                 }
> #endif
>         }
> Why do we need to check that the route is not gateway and has next hop
> for updating rt6i_src? I checked the git history and it seems this
> part was there from very early on (with some refactor in between)...

I can not make sense of that check either.
