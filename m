Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893034B9730
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiBQDu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:50:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiBQDu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:50:58 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA83C0506;
        Wed, 16 Feb 2022 19:50:45 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y5so3887952pfe.4;
        Wed, 16 Feb 2022 19:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5lo5ue+D8Yew+rC5es036sB2FIuEPsOWNEla8KsMGFU=;
        b=FIlDhQgmieQltq761voGIlwdkyFaegGEJxyOmbJE9dTmPmT8CBcjSrjiAKQopMMirw
         5/KzyA1EgoXUYvnAjV4B9RJ1VHLmxbChM6ZNM5sVY36Z+3RjWnYivdRIYtzdof+Dl296
         PgzDzkgAN+6mvoRiE527SEFbVF6VfZAiP1kOaXeyGmL3TkPKfds6pTsxgv2gL0jTzKPb
         kEmYsla8im6z19GD6CVifuegGRE4pwkSvXC78+jXMG3+YWHgXTZHSOCfKmAjbuyhcanE
         74CjBUm7dbwM+0xDT/Ok2RyYKFO7z87Zq5oJJl1r9uAo4EKX3KAPBwhmuP/6LGt9kkC6
         aZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5lo5ue+D8Yew+rC5es036sB2FIuEPsOWNEla8KsMGFU=;
        b=kdrjlE3EBcHj9f+gmGIbtNLgd6aY3d1/rQIvj38aCCONydgGkTasD9pFm+vbbKbAS4
         RJnUbecypbPDsK4boG8CM/ksD2aTJNqtZAYRKL7ch4YJng5Sjdy9byLmvLFK/D3uRIen
         JZMsvrRZ3E9HIfIiX3Gy2k7Q9tQ+9eAhtG2UEecNkabhwT8PI9NpeZ/RHIDsq3QOPoO/
         A3opHaY3lhK/4dPN351Sfim37lPWyTisK7nGGvByZqmjwtDTOyMrdYHfbrwhqSxNSYtn
         euV8CJ3Eu/zGt4n55sU5ireCSapla4LpCXSWFH2dut4gitLafGGJzaFAVuoltqlOdrV8
         B2Ow==
X-Gm-Message-State: AOAM530ovawYGayWlKA1OINAj/+qM5moEriFGhr0Zxd/W/Lbu+e1Q5ZO
        RtuZhE5vy8iExXuWtBiyCyk=
X-Google-Smtp-Source: ABdhPJzvfEZnBeQBNo88o8FHNIkyccOveUIeYjqgU/9nTkzfC4uCGrIX+urPoeFzLdlUnmBftP9I/w==
X-Received: by 2002:a63:4542:0:b0:340:e43c:3783 with SMTP id u2-20020a634542000000b00340e43c3783mr908836pgk.509.1645069844837;
        Wed, 16 Feb 2022 19:50:44 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3a48])
        by smtp.gmail.com with ESMTPSA id a38sm32788600pfx.121.2022.02.16.19.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 19:50:44 -0800 (PST)
Date:   Wed, 16 Feb 2022 19:50:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next v2 0/3] bpf: support string key in htab
Message-ID: <20220217035041.axk46atz7j4svi2k@ast-mbp.dhcp.thefacebook.com>
References: <20220214111337.3539-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214111337.3539-1-houtao1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 07:13:34PM +0800, Hou Tao wrote:
> Hi,
> 
> In order to use string as hash-table key, key_size must be the storage
> size of longest string. If there are large differencies in string
> length, the hash distribution will be sub-optimal due to the unused
> zero bytes in shorter strings and the lookup will be inefficient due to
> unnecessary memcmp().
> 
> Also it is possible the unused part of string key returned from bpf helper
> (e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
> the lookup will fail with -ENOENT (as reported in [1]).
> 
> The patchset tries to address the inefficiency by adding support for
> string key. There is extensibility problem in v1 because the string key
> and its optimization is only available for string-only key. To make it
> extensible, v2 introduces bpf_str_key_stor and bpf_str_key_desc and enforce
> the layout of hash key struct through BTF as follows:
> 
> 	>the start of hash key
> 	...
> 	[struct bpf_str_key_desc m;]
> 	...
> 	[struct bpf_str_key_desc n;]
> 	...
> 	struct bpf_str_key_stor z;
> 	unsigned char raw[N];
> 	>the end of hash key

Sorry, but this is dead end.
The v2 didn't fundamentally change the design.
The bpf_str_key_desc has an offset field, but it's unused.
The len field is dynamically checked at run-time and all hash maps
users will be paying that penalty though majority will not be
using this feature.
This patch set is incredibly specific solution to one task.
It's far from being generic. We cannot extend bpf this way.
All building blocks must be as generic as possible.
If you want strings as a key then the key must be variable size.
This patch doesn't make them so. It still requires some
predefined fixed size for largest string. This is no go.
Variable sized key means truly variable to megabytes long.
The key would need to contain an object (a pointer wrap) to
a variable sized object. And this object can be arbitrary
blob of bytes. Not just null terminated string.
We've been thinking about "dynamic pointer" concept where
pointer + length will be represented as an object.
The program will be able to allocate it and persist into a map value
and potentially into a map key.
For storing a bunch of strings one can use a strong hash and store
that hash in the key while keeping full string as a variable sized
object inside the value.
Another approach is to introduce a trie to store strings, or dfa,
or aho-corasick, etc. There are plenty of data structures that are
more suitable for storing and searching strings depending on the use case.
Using hash table for strings has its downsides.
