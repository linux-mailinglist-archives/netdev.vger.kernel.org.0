Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457712A2E95
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgKBPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgKBPrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:47:12 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04914C0617A6;
        Mon,  2 Nov 2020 07:47:12 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id s24so8564067ioj.13;
        Mon, 02 Nov 2020 07:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EJo4Lc1lqAgthYLdSr5xKFb0sp4iI0l39NPBNmW46vs=;
        b=GPv3O9DByzQZdM0BsLH9NYfXEDcMS6Um8cZXdmaIvLMxZM+7sIAl6JYljeQVk25dLm
         lF0eVzmWuMuMM7CU4Wef14YNStS0/FTSSpEKh8js1HJlREOfoPFK4v2b1L8I+Uykrp6d
         q4ALeD00+GIIRMeyypLLCphf5SqukYazP7DuzFlP3XzZW/rgLk2y/cR0kaPxaTVS9PT5
         x3MZT51TtvBLdbYcjcQKJHpqEXt/m6BNsxPw2SGy9eMuTxtMWjtpIrZzOxRiqK1HqlyC
         PT13bSatCRKSl3Xskf1w5v7uqKNkvLMMP4aaL0krNld90NlNMWyZVokLevLc19S1ZTl3
         6aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EJo4Lc1lqAgthYLdSr5xKFb0sp4iI0l39NPBNmW46vs=;
        b=NlUBZhx7K7wA9PD2CxAWwogZJy69AFP/HXiEspA3235xe/uZkzny43V2QkK2V65ANe
         0U3AygGKqj/xlDHoytz8rb8xjqFTIB9/zljTBu5bLkx3wI1cofsVPA3jAQnQcltgXXFJ
         syVFmkJT343Mwd+d8PfRxpTaOVLbeqUHMonPPQ4An4dm5rPCCp2z+IIWTkXjsgr5ick4
         3mvJ5ZrS5xL6WzP+3NzySn+VjUGSc/4/m3XndeL3zckZe54j8wabm1hNOqfTZT4xYMS+
         4ZHYRd0yAs+tdHr6nb8TgnSR9otFUtMf8CoM2JAm2RfQvH9cwfAPh9e1b+guu9PyO8F3
         1pbA==
X-Gm-Message-State: AOAM533/V+GjvmZ1nLYCjQpeclEevzSNojAV8KonHg+7JKuKgS8OrOtR
        41PRzKq8Fz9CrlQi9Lnan8k=
X-Google-Smtp-Source: ABdhPJzMJCi9ifw/mE34R3OQrB2zJvTNG9MolOcgzcfeXczJ2hW9xPuvfG3sd9VG6838T2KgWpRfLQ==
X-Received: by 2002:a02:5e84:: with SMTP id h126mr12207031jab.128.1604332031403;
        Mon, 02 Nov 2020 07:47:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id v88sm11255235ila.71.2020.11.02.07.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 07:47:10 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
Date:   Mon, 2 Nov 2020 08:47:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201029151146.3810859-1-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 9:11 AM, Hangbin Liu wrote:
> This series converts iproute2 to use libbpf for loading and attaching
> BPF programs when it is available. This means that iproute2 will
> correctly process BTF information and support the new-style BTF-defined
> maps, while keeping compatibility with the old internal map definition
> syntax.
> 
> This is achieved by checking for libbpf at './configure' time, and using
> it if available. By default the system libbpf will be used, but static
> linking against a custom libbpf version can be achieved by passing
> LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
> abort if no suitable libbpf is found (useful for automatic packaging
> that wants to enforce the dependency).
> 
> The old iproute2 bpf code is kept and will be used if no suitable libbpf
> is available. When using libbpf, wrapper code ensures that iproute2 will
> still understand the old map definition format, including populating
> map-in-map and tail call maps before load.
> 
> The examples in bpf/examples are kept, and a separate set of examples
> are added with BTF-based map definitions for those examples where this
> is possible (libbpf doesn't currently support declaratively populating
> tail call maps).
> 
> At last, Thanks a lot for Toke's help on this patch set.
> 

In regards to comments from v2 of the series:

iproute2 is a stable, production package that requires minimal support
from external libraries. The external packages it does require are also
stable with few to no relevant changes.

bpf and libbpf on the other hand are under active development and
rapidly changing month over month. The git submodule approach has its
conveniences for rapid development but is inappropriate for a package
like iproute2 and will not be considered.

To explicitly state what I think should be obvious to any experienced
Linux user, iproute2 code should always compile and work *without
functionality loss* on LTS versions N and N-1 of well known OS’es with
LTS releases (e.g., Debian, Ubuntu, RHEL). Meaning iproute2 will compile
and work with the external dependencies as they exist in that OS version.

I believe there are more than enough established compatibility and
library version checks to find the middle ground to integrate new
features requiring new versions of libbpf while maintaining stability
and compatibility with older releases. The biannual releases of Ubuntu
and Fedora serve as testing grounds for integrating new features
requiring a newer version of libbpf while continuing to work with
released versions of libbpf. It appears Debian Bullseye will also fall
into this category.

Finally, bpf-based features in iproute2 will only be committed once
relevant support exists in a released version of libbpf (ie., the github
version, not just commits to the in-kernel tree version). Patches can
and should be sent for review based on testing with the in-kernel tree
version of libbpf, but I will not commit them until the library has been
released.

Thanks for working on this, Hangbin. It is right direction in the long term.
