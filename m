Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E9422B35B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgGWQVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:21:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36439 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726632AbgGWQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 12:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595521275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xm8Gwy5ngihHCS6QCYYSXxX1Hk7bq+Zu3h9/fGUbCOg=;
        b=dRC2jnqEDssOUwu53adwAoLB+Nqx/WYaUan3YjzYiNX7keznCrkSJ7TTBbnQKyqQQlfQPa
        +f+jE34Mp00/WWXYeL/k0pNKVTMa2Ejuu56b9YIkKTh0/mq2XBLd42fa03gw18K/BhRrfA
        /w8xlOnzBVhRQF1Uffs2+7qc56Xdg/4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-PUgzzvvaNI2flZg36P2bwA-1; Thu, 23 Jul 2020 12:21:05 -0400
X-MC-Unique: PUgzzvvaNI2flZg36P2bwA-1
Received: by mail-qv1-f71.google.com with SMTP id dl10so3880640qvb.20
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 09:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Xm8Gwy5ngihHCS6QCYYSXxX1Hk7bq+Zu3h9/fGUbCOg=;
        b=IjPtlsdlsmdyHcnqggLb5nbMAjHF7mB+R/48BeE4cMO/RtROHL+Wd1QSXBcDtYXbZN
         mrpw1gGhCZmxWn+9sb3/DFxlzDJb4HCLSvB9V4Z/TP0k9kCM3qrXD1QVHjfJC0FdY7vz
         hT+n14/vZsSU2yLjKtULPQ27GhMB1rGUWp3wvV6spTB8i5V2ig5khLCeVkJNs1sxMNVT
         XotdcI2sUseimYBpY3VSr7lo/D2O3y0wqscrrqC5WvGhqqrL+wKjXl7OZ/J6g+IKAvzO
         228xuoA2N1bChJ4giEi2WQWw9qVD+T5NEzyCV6j8qujlv3bTDTZcrrwuxinOXxJRhmfB
         VxQg==
X-Gm-Message-State: AOAM531FRwCsj7Pga93Y3sDHPR0qROLAHcL+2R3ys2TTdBWR5AYjNgQU
        CPyNjo9ZOBCuaWdVrpS/0qWiotA3DeVxMTpeLGCGspT2EruPpW5zq6XNpkNOamR1sE7ojM5FTyO
        R+yXNUaD/rfWCroVl
X-Received: by 2002:a37:6d47:: with SMTP id i68mr6113282qkc.74.1595521263841;
        Thu, 23 Jul 2020 09:21:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaX6ObApGhH0vkIFqvVT8seNfWZRsfMGlpKQFK3E141apDdMNGSGfgch9WELF3Pab7cuqbqA==
X-Received: by 2002:a37:6d47:: with SMTP id i68mr6113249qkc.74.1595521263624;
        Thu, 23 Jul 2020 09:21:03 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id j31sm2785738qtb.63.2020.07.23.09.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 09:21:03 -0700 (PDT)
Subject: Re: [PATCH] bpf: BPF_SYSCALL depends INET
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will@kernel.org>, krzk@kernel.org,
        patrick.bellasi@arm.com, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20200723141914.20722-1-trix@redhat.com>
 <CAADnVQJYsqosZ804geM1Urrz73+z1fMZu1w76KN-847S3CL+nQ@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <85785371-f0e9-5c85-959f-b9830b4eb06a@redhat.com>
Date:   Thu, 23 Jul 2020 09:20:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJYsqosZ804geM1Urrz73+z1fMZu1w76KN-847S3CL+nQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/23/20 8:27 AM, Alexei Starovoitov wrote:
> On Thu, Jul 23, 2020 at 7:19 AM <trix@redhat.com> wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> A link error
>>
>> kernel/bpf/net_namespace.o: In function `bpf_netns_link_release':
>> net_namespace.c: undefined reference to `bpf_sk_lookup_enabled'
>>
>> bpf_sk_lookup_enabled is defined with INET
>> net_namespace is controlled by BPF_SYSCALL
> pls rebase. it was fixed already.
>
I guess it hasn't shown up in linux-next yet.

As i rebase every day, i'll get it evently.

Sorry for noise.

Tom

