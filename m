Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD84E727C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbfJ1NQA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Oct 2019 09:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfJ1NP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 09:15:59 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A3A183F3D
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 13:15:59 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id s30so2189519lfo.9
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 06:15:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vjNtaWXzYQYyO8/vxi1Mscz2AA+NYniSnjak3yf+ka0=;
        b=PhgulhW4d+L0y78VPtctkNBns8uXarf2nFvKFlDra/EIP9ct/CV2f4mTu/gGGFJf56
         RVp0bzgz3938NKU9x4zFz7eVImRgxS4POA0ZqXHmsMosi7W8mrbmEgFTpVJsZvwzbPy/
         P0CxfAg+38qogVbwSsuaF1NlxiwiE06qznWgv7DJbJ4bO7Iz2HjihdSYHSTj1cwAgVye
         IJN7mUEI0bSw4ZyDyFgIeZu9FwlfWKIAV0hH7sjlpMBqL9bkOGKS01tGtucTC8NuHxgi
         XNFjDJ0Py9xpWRgnZMcg8ouQLHMgmjh52RvSQ+C776Ox42xmQ9eKYr3Mre2kI44qkpIR
         PNIw==
X-Gm-Message-State: APjAAAUJn7W0EKo12fEMkW+MDtu5u7+xJN6GT+imd1hkBZWLHRXWZhzX
        3DoYqhkDOGPtjxRR4THoYC5i4TaYo2hexPMH9djnDhLBg/3Cr2TEjetg5GSUzNwkBCPOu8G8xmY
        jv+b4Xxc7Z2SQrZ6V
X-Received: by 2002:a19:c7d3:: with SMTP id x202mr7932582lff.127.1572268557977;
        Mon, 28 Oct 2019 06:15:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwGIt65mCxNJVDQOyNX2zDzBS+yqjzOl0BiO2TOQDbfJ06SZNvNsTmpP9PJhkdPfeL/kiKrJw==
X-Received: by 2002:a19:c7d3:: with SMTP id x202mr7932567lff.127.1572268557816;
        Mon, 28 Oct 2019 06:15:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id x1sm10131396lff.90.2019.10.28.06.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 06:15:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 15B291800E2; Mon, 28 Oct 2019 14:15:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map pinning
In-Reply-To: <20191028140624.584bcc1e@carbon>
References: <157220959547.48922.6623938299823744715.stgit@toke.dk> <157220959980.48922.12100884213362040360.stgit@toke.dk> <20191028140624.584bcc1e@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 28 Oct 2019 14:15:56 +0100
Message-ID: <87imo9roxf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Sun, 27 Oct 2019 21:53:19 +0100
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testing/selftests/bpf/progs/test_pinning.c
>> new file mode 100644
>> index 000000000000..ff2d7447777e
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
>> @@ -0,0 +1,29 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <linux/bpf.h>
>> +#include "bpf_helpers.h"
>> +
>> +int _version SEC("version") = 1;
>> +
>> +struct {
>> +	__uint(type, BPF_MAP_TYPE_ARRAY);
>> +	__uint(max_entries, 1);
>> +	__type(key, __u32);
>> +	__type(value, __u64);
>> +	__uint(pinning, LIBBPF_PIN_BY_NAME);
>> +} pinmap SEC(".maps");
>
> So, this is the new BTF-defined maps syntax.
>
> Please remind me, what version of LLVM do we need to compile this?

No idea what the minimum version is. I'm running LLVM 9.0 :)

> Or was there a dependency on pahole?

Don't think so...

-Toke
