Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A79451F809
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 11:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiEIJ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 05:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiEIJEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 05:04:49 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023BE18D4CB
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 02:00:55 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o12-20020a1c4d0c000000b00393fbe2973dso10370684wmh.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 02:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cJUtWrNcJevpr3SPVYzI2c58KXCUrUKYBk0PTaZE/04=;
        b=IUv2bwsBlcU8ig0fVoZgPoDNNE/ZWF3i7dHyS3L9q9+uRpBKduBfGRuquL8suTvGsn
         wZipe0cjilfWE2Qttn/7kIG3DzmpP1jhsN3WZ0NXaf8s7VwUyZ8FrRozNVQU6cNdiYWW
         FmHl9FmfC372G3NrYSNRAn/mxIjhUFVIdk3yGoVKF4pPDxPytIXIU1p6BPoX9tYuccBk
         JI7shVGr0z93ujl0gO9YnCNkdn+kf87IWsFuH2+LbMDtNDkZEXe8BZi1VSQ0JaJB5x3X
         jz78eF2baZzdPzHNe3fnQubY0HPT8oG4RkPC+56jzouuWd6gQdbnmAyo+cSNHU+fiYXp
         J8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cJUtWrNcJevpr3SPVYzI2c58KXCUrUKYBk0PTaZE/04=;
        b=r3Beg+XAjsMfV77cA6sDdwSWy7WZsnNauG7PlAzWrMThZ3heoOQS6iNyen/wqDph+o
         D2J7eCv//B5RY3HiyMvrfB1Z6mzdLQlKjQc+ajfC8iYoC0IotWB5bP66T1l6iYk/Evps
         tiuS4xtemHirqAHlplgIp4Hwp3jR+pbY3fZESLIWk/+EtqKLinIERf32NwX3EizKyuVn
         0RCVBffAuFsR9ANAg+6L3+Uk1xWo2BuHX/vmfy2mRSv4BtEme4uYm2ZZ6+C7RpxjbhLA
         C+msjTGMYYKCIxGvOFKXRAjjbqf31LSHakI4l909vH+Vff5/tchUjtnvalwZ5D+rT69X
         4c+w==
X-Gm-Message-State: AOAM533MAQBMx82eMivVBzFSRXLjm33J1+ZkQWOo0FIoGpDFj2dPXIUs
        NTlh8qftIuIRYCnxA6HqRVCQLA==
X-Google-Smtp-Source: ABdhPJyYG03hLpuI/X2biEtwUkDYqKdlHxNjjNqonRg80Zz2wpTjzHYyPlxgSr6VCZjUJrcayiwtgw==
X-Received: by 2002:a05:600c:1d9d:b0:394:7d22:9bdd with SMTP id p29-20020a05600c1d9d00b003947d229bddmr13473079wms.111.1652086850495;
        Mon, 09 May 2022 02:00:50 -0700 (PDT)
Received: from [10.44.2.26] (84-199-106-91.ifiber.telenet-ops.be. [84.199.106.91])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b0020c5253d8f0sm10801990wrq.60.2022.05.09.02.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 02:00:50 -0700 (PDT)
Message-ID: <8afe6b33-49c1-5060-87ed-80ef21096bbb@tessares.net>
Date:   Mon, 9 May 2022 11:00:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH bpf-next v3 5/8] selftests: bpf: test
 bpf_skc_to_mptcp_sock
Content-Language: en-GB
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
 <20220502211235.142250-6-mathew.j.martineau@linux.intel.com>
 <CAEf4BzY-t=ZtmU+6yeSo5DD6+C==NUN=twAKq=OQyVb2rS2ENw@mail.gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <CAEf4BzY-t=ZtmU+6yeSo5DD6+C==NUN=twAKq=OQyVb2rS2ENw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

Thank you for the review!

On 07/05/2022 00:26, Andrii Nakryiko wrote:
> On Mon, May 2, 2022 at 2:12 PM Mat Martineau
> <mathew.j.martineau@linux.intel.com> wrote:

(...)

>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 359afc617b92..d48d3cb6abbc 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -13780,6 +13780,7 @@ F:      include/net/mptcp.h
>>  F:     include/trace/events/mptcp.h
>>  F:     include/uapi/linux/mptcp.h
>>  F:     net/mptcp/
>> +F:     tools/testing/selftests/bpf/bpf_mptcp_helpers.h
>>  F:     tools/testing/selftests/bpf/*/*mptcp*.c
>>  F:     tools/testing/selftests/net/mptcp/
>>
>> diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
>> new file mode 100644
>> index 000000000000..18da4cc65e89
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
>> @@ -0,0 +1,14 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright (c) 2022, SUSE. */
>> +
>> +#ifndef __BPF_MPTCP_HELPERS_H
>> +#define __BPF_MPTCP_HELPERS_H
>> +
>> +#include "bpf_tcp_helpers.h"
>> +
>> +struct mptcp_sock {
>> +       struct inet_connection_sock     sk;
>> +
>> +} __attribute__((preserve_access_index));
> 
> why can't all this live in bpf_tcp_helpers.h? why do we need extra header?

The main reason is related to the maintenance: to have MPTCP ML being
cc'd for all patches modifying this file.

Do you prefer if all these specific MPTCP structures and macros and
mixed with TCP ones?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
