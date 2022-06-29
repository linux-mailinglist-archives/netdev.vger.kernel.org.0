Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B51855FE43
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 13:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiF2LL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 07:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiF2LLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 07:11:25 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3AB36B5B
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:11:24 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id t17-20020a1c7711000000b003a0434b0af7so6812563wmi.0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1PKyxZ1uu6yvDN2EF68ZfrLkCE2pPZtrlvwd7rslqbM=;
        b=L5QoSoybpVAjT7lZHQv69jquCs6gYVFWBSvengc9LLBR+jPmDZfPZCZ22vsU8G8Xep
         wMFyLE4Xg3NteSvv2nmjIjvj3XTz5MaL3GvgUwO0Cayj21olJWupfzZRJuARUd6bc4/E
         Gaz0xBV8oIithR99taSxUw8y+7s1yxC4Nkq4F5kjSmYpUzG97av3k+fKBTqTgghYNboB
         K4d9ox/KAz0Z1EWBSCqO0gIyzSlYP6xuVJbgHBt5JOBj4NPGDM4qHKkq3iOZyQt5tl3A
         RPfRzjoiMlZq9x4VDCLiRUFn/hoC8FHAn3HOLzrBlcWSWUJWSthZZp0IqVlAT8nu/2Sr
         /VCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1PKyxZ1uu6yvDN2EF68ZfrLkCE2pPZtrlvwd7rslqbM=;
        b=OLTB7pykmtGaGAF1ckHHV1xVmqVikBGKQHzyRj1gLujJwcGfcR12z7VBxQsOnIcdCE
         iXf4JxjqQ1+c0tdr17V1E4kNQ2LhL/R3YGCpw75oI8J91d08GNQlziY8S05NVxp45gzs
         /1SBEt7zYwpZ/R+tcHVGhQJ3TkjlvNx7o2/I2OLELM8wQzGBOnIyn9I+kVnOvIlSiM2d
         7pYkf/ACtqgdT1G6lOovBFNIZd18cv1AJr1DEG8ZNrqkBrGaHgxGIksi6lmdSBQRSsDH
         knrKRjtcdgeIA9gqg+5DGqDEr3fKNpSfOwNkXwOefrP6HgRcdHce6DnhFpf9jTqEfVcF
         Bhig==
X-Gm-Message-State: AJIora8ZmePAp6XZb9glpDils12UNdBg/qfq9gDWxVYqr89zM4ndSXEE
        0O/GIIJ+/ace+Ni+WSbafHq63g==
X-Google-Smtp-Source: AGRyM1uqzk5GfuDS8rJdDcVdXRoYqCZ4s9Yum9tkp7m7T+GZj30tfIsi7QLN3U1eRFWtLy77ZTR3oQ==
X-Received: by 2002:a05:600c:34cc:b0:39c:832c:bd92 with SMTP id d12-20020a05600c34cc00b0039c832cbd92mr3036148wmq.24.1656501082432;
        Wed, 29 Jun 2022 04:11:22 -0700 (PDT)
Received: from [192.168.178.21] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id g21-20020a7bc4d5000000b0039c587342d8sm2819557wmk.3.2022.06.29.04.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 04:11:21 -0700 (PDT)
Message-ID: <d224244e-8fe7-d169-dc5d-f5b62ec81a9e@isovalent.com>
Date:   Wed, 29 Jun 2022 12:11:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH bpf-next] bpftool: Probe for memcg-based accounting before
 bumping rlimit
Content-Language: en-GB
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220628164529.80050-1-quentin@isovalent.com>
 <CAKH8qBvzZvHoUpkVPXN-v=XrvdPQ-1tEJOcd=PrGosHbY7+KdA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAKH8qBvzZvHoUpkVPXN-v=XrvdPQ-1tEJOcd=PrGosHbY7+KdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2022 18:53, Stanislav Fomichev wrote:
> On Tue, Jun 28, 2022 at 9:45 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Bpftool used to bump the memlock rlimit to make sure to be able to load
>> BPF objects. After the kernel has switched to memcg-based memory
>> accounting [0] in 5.11, bpftool has relied on libbpf to probe the system
>> for memcg-based accounting support and for raising the rlimit if
>> necessary [1]. But this was later reverted, because the probe would
>> sometimes fail, resulting in bpftool not being able to load all required
>> objects [2].
>>
>> Here we add a more efficient probe, in bpftool itself. We first lower
>> the rlimit to 0, then we attempt to load a BPF object (and finally reset
>> the rlimit): if the load succeeds, then memcg-based memory accounting is
>> supported.
>>
>> This approach was earlier proposed for the probe in libbpf itself [3],
>> but given that the library may be used in multithreaded applications,
>> the probe could have undesirable consequences if one thread attempts to
>> lock kernel memory while memlock rlimit is at 0. Since bpftool is
>> single-threaded and the rlimit is process-based, this is fine to do in
>> bpftool itself.
>>
>> This probe was inspired by the similar one from the cilium/ebpf Go
>> library [4].
>>
>> [0] commit 97306be45fbe ("Merge branch 'switch to memcg-based memory accounting'")
>> [1] commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
>> [2] commit 6b4384ff1088 ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"")
>> [3] https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/t/#u
>> [4] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
>>
>> Cc: Stanislav Fomichev <sdf@google.com>
>> Cc: Yafang Shao <laoar.shao@gmail.com>
>> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  tools/bpf/bpftool/common.c   | 71 ++++++++++++++++++++++++++++++++++--
>>  tools/include/linux/kernel.h |  5 +++
>>  2 files changed, 73 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
>> index a0d4acd7c54a..e07769802f76 100644
>> --- a/tools/bpf/bpftool/common.c
>> +++ b/tools/bpf/bpftool/common.c
>> @@ -13,14 +13,17 @@
>>  #include <stdlib.h>
>>  #include <string.h>
>>  #include <unistd.h>
>> -#include <linux/limits.h>
>> -#include <linux/magic.h>
>>  #include <net/if.h>
>>  #include <sys/mount.h>
>>  #include <sys/resource.h>
>>  #include <sys/stat.h>
>>  #include <sys/vfs.h>
>>
>> +#include <linux/filter.h>
>> +#include <linux/limits.h>
>> +#include <linux/magic.h>
>> +#include <linux/unistd.h>
>> +
>>  #include <bpf/bpf.h>
>>  #include <bpf/hashmap.h>
>>  #include <bpf/libbpf.h> /* libbpf_num_possible_cpus */
>> @@ -73,11 +76,73 @@ static bool is_bpffs(char *path)
>>         return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
>>  }
>>
>> +/* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
>> + * memcg-based memory accounting for BPF maps and programs. This was done in
>> + * commit 97306be45fbe ("Merge branch 'switch to memcg-based memory
>> + * accounting'"), in Linux 5.11.
>> + *
>> + * Libbpf also offers to probe for memcg-based accounting vs rlimit, but does
>> + * so by checking for the availability of a given BPF helper and this has
>> + * failed on some kernels with backports in the past, see commit 6b4384ff1088
>> + * ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"").
>> + * Instead, we can probe by lowering the process-based rlimit to 0, trying to
>> + * load a BPF object, and resetting the rlimit. If the load succeeds then
>> + * memcg-based accounting is supported.
>> + *
>> + * This would be too dangerous to do in the library, because multithreaded
>> + * applications might attempt to load items while the rlimit is at 0. Given
>> + * that bpftool is single-threaded, this is fine to do here.
>> + */
>> +static bool known_to_need_rlimit(void)
>> +{
>> +       const size_t prog_load_attr_sz = offsetofend(union bpf_attr, attach_btf_obj_fd);
> 
> nit:
> Any specific reason you're hard coding this sz via offseofend? Why not
> use sizeof(bpf_attr) directly as a syscall/memset size?
> The kernel should handle all these cases where bpftool has extra zero
> padding, right?

No particular reason. Good point, I'll send a v2 to address this.

Thanks,
Quentin
