Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB471E6F40
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437259AbgE1WiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437219AbgE1WiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:38:03 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9D4C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:38:02 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h9so417724qtj.7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fYfSGA701uEri5oskhA0CC3T23IE6Bc7x6lhtxVbIfM=;
        b=TlHhRPzPN7fRA0kSZqn7Rw6DQ6+7BG3q88kFpwk5bkhDFuZPULFe51LOudgdqQ2kYn
         VsQXySBsSfeEh90lSRYLRMZDupvlBWty/xNDUtcZKuCHbPKs2Fk6EnpZ/5pq6LQnWfZX
         dyzFmt9JOP5HXpb8vRJseOy6DFLdCC2dA+Q6zncKdp2kPQtbha+uLrYnPmP649+Nnm8G
         PeuRkW6ebLB6gvTGtjp8g54+y0bDCxqNUDfGU8tE30FF9Mvqm570ICkzpA7f/xJ9WtRT
         tCT1u2mDDBFBHvlrP1UMHXeL5LSvfq4nh9DJ7pHsoLrs8C1lX7ZR+FKhVNdnrO4/xvyh
         f7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYfSGA701uEri5oskhA0CC3T23IE6Bc7x6lhtxVbIfM=;
        b=s7xR+HY+neVJDZIv/X12ZSFJCcnVfev1H90p/XTXwwUJjrWHhgUADuGdos8KXF+A9h
         HnGEG0Tr1uAOnGIOkE8lEz5jqgHE7IC2DOKn/DDTy2GEOPSl9iB9yfDuwiNg7yueGW2n
         nT8Mdm1hlbfuhvs66IpfEvAv8gNbn81ZFpJcAqi7zR4XUJzs3V+qZ4LwZBvE1iiKYHdN
         I76NukNgUFggc5NkAf8e2f76tXR1zGvW/mJrzK1Y2WsBUhgIZhZRfvU6mAYLkAtx0zgq
         KlqsUrPkl2SsVh3cNAAOMOBVZVnlmLdw6HzNb+c29VPJ2yi09DtEtp0In6JCxSRZXJec
         ogGw==
X-Gm-Message-State: AOAM532nniqw6iCezbHQ3xqDx5wq1rCNVnZCN3WQKJqx6gZrMGr+3wt+
        6lcwn+XcFpkNRngTr2sF+dY=
X-Google-Smtp-Source: ABdhPJw2rn0Al1HCM93KYRTnJe1l1L3T/2y42RIXzt8fizgKZQorrzENB7kezUC9iCoWsuD3NX132A==
X-Received: by 2002:ac8:6ec2:: with SMTP id f2mr5553976qtv.309.1590705482033;
        Thu, 28 May 2020 15:38:02 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id e16sm6717624qtc.71.2020.05.28.15.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:38:00 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 1/5] devmap: Formalize map value as a named
 struct
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200528001423.58575-1-dsahern@kernel.org>
 <20200528001423.58575-2-dsahern@kernel.org>
 <CAEf4BzZPbndT3daoSt_z6cH=CPJSdH5yMhpR2gDbmeQUacWAyg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cd8da493-90be-3d23-fb57-f699c66bfb7f@gmail.com>
Date:   Thu, 28 May 2020 16:37:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZPbndT3daoSt_z6cH=CPJSdH5yMhpR2gDbmeQUacWAyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 1:01 AM, Andrii Nakryiko wrote:
> On Wed, May 27, 2020 at 5:15 PM David Ahern <dsahern@kernel.org> wrote:
>>
>> From: David Ahern <dsahern@gmail.com>
>>
>> Add 'struct devmap_val' to the bpf uapi to formalize the
>> expected values that can be passed in for a DEVMAP.
>> Update devmap code to use the struct.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>>  include/uapi/linux/bpf.h       |  5 ++++
>>  kernel/bpf/devmap.c            | 43 ++++++++++++++++++++--------------
>>  tools/include/uapi/linux/bpf.h |  5 ++++
>>  3 files changed, 35 insertions(+), 18 deletions(-)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 54b93f8b49b8..d27302ecaa9c 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3625,6 +3625,11 @@ struct xdp_md {
>>         __u32 rx_queue_index;  /* rxq->queue_index  */
>>  };
>>
>> +/* DEVMAP values */
>> +struct devmap_val {
>> +       __u32 ifindex;   /* device index */
>> +};
>> +
> 
> can DEVMAP be used outside of BPF ecosystem? If not, shouldn't this be
> `struct bpf_devmap_val`, to be consistent with the rest of the type
> names?

sure, added 'bpf_' to the name.

> 
>>  enum sk_action {
>>         SK_DROP = 0,
>>         SK_PASS,
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index a51d9fb7a359..069a50113e26 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -66,6 +66,7 @@ struct bpf_dtab_netdev {
>>         struct bpf_dtab *dtab;
>>         struct rcu_head rcu;
>>         unsigned int idx;
>> +       struct devmap_val val;
>>  };
>>
>>  struct bpf_dtab {
>> @@ -110,7 +111,8 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>>
>>         /* check sanity of attributes */
>>         if (attr->max_entries == 0 || attr->key_size != 4 ||
>> -           attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
>> +           attr->value_size > sizeof(struct devmap_val) ||
> 
> So is 0, 1, 2, 3, and after next patch 5, 6, and 7 all allowed as
> well? Isn't that a bit too permissive?

sure, I should check that it is at least 4-bytes - the existing size of
the values. After that the struct can vary as user and kernel differ.
The key is that newer userspace can not send down a higher value size
than the kernel supports  and older userspace can send fewer bytes
(e.g., 4-byte ifindex only vs 8-byte ifindex + fd). I'll revert this to
v1 where I check for specific known value sizes.

> 
>> +           attr->map_flags & ~DEV_CREATE_FLAG_MASK)
>>                 return -EINVAL;
>>
> 
> [...]
> 

