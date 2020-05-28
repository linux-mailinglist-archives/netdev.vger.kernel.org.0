Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B6F1E6FB6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437430AbgE1Wy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437433AbgE1Wyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:54:54 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C062CC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:54:53 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c12so521101qkk.13
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=COzg5we+r4KOybXJiDbSc2VaygyXbFheKWCY9vDoFaw=;
        b=fA+w7ImQtOkpUqhqdbDHYUzUXtWXIfTUJEy0Gk/AZOf9las04DErSUrAvv9ExvGq97
         W0uywNZ7Yh8+JVwhzhL5Xumn1SlAPKHSOR3Y4tkvUPbAB482T58cKmZao2IuDHKVGAg5
         KhuVFH4SLw3D65983le73g7AWNXf71CvF0Y0bvEM1PpSmuk1iad6KqSzvZQ7uVxi3OgS
         17in9HUYDDwL/IljK1Dxn4PPw5Hpphyl+fiwcTYwoqpta2LcxFMjldoEAN4DY54JchS0
         ibkV/Iwv7zefyC0cLPbH7qX0gsP/0DkcrQWM5hlGnGmO+Nu6Ndp9Tqy5MP3+wQyokNay
         1Ufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=COzg5we+r4KOybXJiDbSc2VaygyXbFheKWCY9vDoFaw=;
        b=EwR9H1vop6jVpyRTPbPNounrZvuX4RMKEBhUmfp7Prn80emhhOlNRDAm2NlwdbpCJD
         dlVh1UVZDugZ3I9cjkL+JWhljoIFRsqbmxPDymEzU7zPbCHjFybGro0ZGpHTiV/1z6//
         27JSJe55sqNEcWh9amTRO390yj0HHFvrO6INboh/KK5DyIzeVxIgvrC51GS0KWqEkeN3
         c9jsOeagwP6YY/JaIIaf7rV+Or00sNU100r40McEIYT7IK9aWkHGdSux/p0dWksBn/p4
         8tOwhuVMJXOaBbDIFiVtbjHeUUSWFZwjhQsyl6/qTCT5Eg0uM3eyZakyTEfuuhvwXeGh
         boMA==
X-Gm-Message-State: AOAM532gMcymN/kWBNXiUTRAa3y4TtdYgafwo9o7qRIUhpee3z9Ig+YW
        SkUMuQc2Ot/iHm2lehbw9k0=
X-Google-Smtp-Source: ABdhPJzLlmVNd2KRtpZdaemaTTZijz5u5gO0Y/s9VtBPOrNWg3u1YcHPuysqCVQf3YTWzDaIYw9slg==
X-Received: by 2002:a37:5b47:: with SMTP id p68mr5363465qkb.120.1590706492988;
        Thu, 28 May 2020 15:54:52 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id z185sm5780886qka.79.2020.05.28.15.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:54:52 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 5/5] selftest: Add tests for XDP programs in
 devmap entries
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
 <20200528001423.58575-6-dsahern@kernel.org>
 <CAEf4BzapqhtWOz666YN1m1wQd0pWJtjYFe4DrUEQpEgPX5UL9g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f9386b9a-a059-ffee-7144-57d32be30f3e@gmail.com>
Date:   Thu, 28 May 2020 16:54:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzapqhtWOz666YN1m1wQd0pWJtjYFe4DrUEQpEgPX5UL9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 1:08 AM, Andrii Nakryiko wrote:
>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
>> new file mode 100644
>> index 000000000000..d81b2b366f39
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
>> @@ -0,0 +1,94 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <uapi/linux/bpf.h>
>> +#include <linux/if_link.h>
>> +#include <test_progs.h>
>> +
>> +#define IFINDEX_LO 1
>> +
>> +void test_xdp_devmap_attach(void)
>> +{
>> +       struct bpf_prog_load_attr attr = {
>> +               .prog_type = BPF_PROG_TYPE_XDP,
>> +       };
>> +       struct bpf_object *obj, *dm_obj = NULL;
>> +       int err, dm_fd = -1, fd = -1, map_fd;
>> +       struct bpf_prog_info info = {};
>> +       struct devmap_val val = {
>> +               .ifindex = IFINDEX_LO,
>> +       };
>> +       __u32 id, len = sizeof(info);
>> +       __u32 duration = 0, idx = 0;
>> +
>> +       attr.file = "./test_xdp_with_devmap.o",
>> +       err = bpf_prog_load_xattr(&attr, &obj, &fd);
> 
> please use skeletons instead of loading .o files.

I will look into it.

> 
>> +       if (CHECK(err, "load of xdp program with 8-byte devmap",
>> +                 "err %d errno %d\n", err, errno))
>> +               return;
>> +
> 
> [...]
> 

>> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap2.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap2.c
>> new file mode 100644
>> index 000000000000..64fc2c3cae01
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap2.c
>> @@ -0,0 +1,19 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* program inserted into devmap entry */
>> +#include <linux/bpf.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +SEC("xdp_devmap_log")
>> +int xdpdm_devlog(struct xdp_md *ctx)
>> +{
>> +       char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
>> +       void *data_end = (void *)(long)ctx->data_end;
>> +       void *data = (void *)(long)ctx->data;
>> +       unsigned int len = data_end - data;
>> +
>> +       bpf_trace_printk(fmt, sizeof(fmt), ctx->ingress_ifindex, ctx->egress_ifindex, len);
> 
> instead of just printing ifindexes, why not return them through global
> variable and validate in a test?

The point of this program to access the egress_ifindex with the expected
attached type NOT set to BPF_XDP_DEVMAP to FAIL the verifier checks.


