Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259A1475F76
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhLORiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbhLORiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:38:12 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE72C061574;
        Wed, 15 Dec 2021 09:38:11 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b7so18266568edd.6;
        Wed, 15 Dec 2021 09:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wHSJEvMaIsTc7h8la2YQGbQodwQPApyf7+yKRFnENBc=;
        b=SvfxzpsSVLXLCVbHRcbcFqim4+B8PHmRbgdhfb3ZkOA6mSuf81cmjdAy20H6QU0VxC
         HZDWkzGV00rcnyCeTpaQTt4s8y/GWRilVHP0foY/JH+XfdOqIg3aZPprZWVb3tInSpfp
         tu8lRgcN/vpsCzi6YSwJCdukNAgStQhgGRRyXkwa23Ji+uOkRdUHEqQSITp/VUFxFiuY
         6MzlvhnyDoeOoFE9oMseORKmecnGojMzr+99on6yVmkikK6YB1M27uKqrIMFJWo1cBlq
         z0fyT00pedHwXgZhtU1bk1Uyn2MtxdRNicc0PhufPqyfPMsVj6xWKMKoWw6DVh2brELS
         vQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wHSJEvMaIsTc7h8la2YQGbQodwQPApyf7+yKRFnENBc=;
        b=7VaU/xqlSFPpbJgV3hndfAME1jO1w5bwRngwTcYpvhSxx29bmT98idMeq3rjA2JPnu
         mBlbA6CxZNGmCX6M04TcsLjUMY1da8QPxultcSF3sxasJHl6eecowy1k4WK1zLYME1zL
         nwJlG9Mb029lsvwMBqjv40FzWtP69N3vPWGjV0sNpLT/COJYsU/bxp3TQ9hrP3GxvudK
         DwzP0+yPagFOwMJIcraimuP3AhvyhXsFj5qNQWCTY4LCO+eGMBzsTqOBJi1IVbKCynzU
         E5duKo19Fm7048z5qcObtL9YD9ovaAIRNyrGCO9OoF2HbWLIL4k+c5uZ73ANbpGtgiGT
         zZ/g==
X-Gm-Message-State: AOAM531TgQK2Whi36VR5ZMcpU2AqHXHZtF2n+p9Jh7eAXPvxzN+IBMnA
        aK/EvTnySIxPnR3b2f8/euc=
X-Google-Smtp-Source: ABdhPJwPUrVkuRn/jLs6O1tnQcz+kCgl1GjfXkTsJh49QFe6B89Oftb8NzEjD/DNLWecFav6qeoOPA==
X-Received: by 2002:a17:906:7191:: with SMTP id h17mr11600753ejk.643.1639589890530;
        Wed, 15 Dec 2021 09:38:10 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1364085edb.59.2021.12.15.09.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:38:10 -0800 (PST)
Message-ID: <6406f753-180a-7896-6df2-c187cb0e975f@gmail.com>
Date:   Wed, 15 Dec 2021 17:38:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <20211215084044.064e6861@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211215084044.064e6861@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 16:40, Jakub Kicinski wrote:
> On Wed, 15 Dec 2021 14:49:18 +0000 Pavel Begunkov wrote:
>> +static inline bool
>> +__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
>> +				 enum cgroup_bpf_attach_type type)
>> +{
>> +	struct bpf_prog_array *array = rcu_access_pointer(cgrp_bpf->effective[type]);
>> +
>> +	return array == &bpf_empty_prog_array.hdr;
>> +}
>> +
>> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
>> +({									       \
>> +	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
>> +									       \
>> +	!__cgroup_bpf_prog_array_is_empty(&__cgrp->bpf, (atype));	       \
>> +})
>> +
> 
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index e7a163a3146b..0d2195c6fb2a 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1161,6 +1161,19 @@ struct bpf_prog_array {
>>   	struct bpf_prog_array_item items[];
>>   };
>>   
>> +struct bpf_empty_prog_array {
>> +	struct bpf_prog_array hdr;
>> +	struct bpf_prog *null_prog;
>> +};
>> +
>> +/* to avoid allocating empty bpf_prog_array for cgroups that
>> + * don't have bpf program attached use one global 'bpf_empty_prog_array'
>> + * It will not be modified the caller of bpf_prog_array_alloc()
>> + * (since caller requested prog_cnt == 0)
>> + * that pointer should be 'freed' by bpf_prog_array_free()
>> + */
>> +extern struct bpf_empty_prog_array bpf_empty_prog_array;
> 
> mumble mumble, this adds more "fun" dependencies [1] Maybe I'm going

Header dependencies? It's declared right after struct bpf_prog_array,
and the other member is a pointer, so not sure what can go wrong.


> about this all wrong, maybe I should be pulling out struct cgroup_bpf
> so that cgroup.h does not need bpf-cgroup, not breaking bpf <-> bpf-cgroup.
> Alexei, WDYT?
> 
> [1] https://lore.kernel.org/all/20211215061916.715513-2-kuba@kernel.org/
> 

-- 
Pavel Begunkov
