Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1351EB8C7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFBJqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgFBJqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:46:18 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5797C061A0E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 02:46:16 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id k11so12099076ejr.9
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 02:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=INWpqCllWxiZN050hQmTrPBqQBX7Ogci0UB7YJjVunM=;
        b=cIVksyRGkCJppF6GPfjQpyYhV0WBlj9r4pRRqwef1l8sqTC0hXetdLH+KxUWAooMzJ
         GgPbfkz7hOu1wfRFU9HLIuVUWskktY85fNjRi/qrWy+yefbVJCgCNujfzHvaRYCGfNO/
         qgJm7JjUBgN7I8ghM1AgBKt7MuRIwWXlLaroY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=INWpqCllWxiZN050hQmTrPBqQBX7Ogci0UB7YJjVunM=;
        b=XKLFRm+FL1s44wTtBJ6rWemkhhmrX/011urObEV2Zq2z+K6WsFHkw7Xcy67iFpVWM3
         nIQuI1KDk1dgrx4yiNlZE93hSL0vA9pbEs/w+QQpdHaJlMeWDoH/bJeO9ymHeT6vpmGW
         xpH7mE7vO+kdgiQF6GzzfoAE1Dia67fC2Pk8s/YmQhbKqJeriuf+Nk5iNznqSGuEFEqF
         YaYNY0MmINCzoXOapDI2p5HldN45rrcaAxfg6s2saZFPGV1SVfAWzeyFAIdbbpTtxcXU
         9mMQ7RTnEArIsW6IEMCM4kddqgSxPGfQb2nAA+gEFEpYmVHpMO6gfniok9WNtLYgATTE
         aodw==
X-Gm-Message-State: AOAM530cq1NB2WmyT4cctvf4sStqAIb+MKqY35LNiRPZ1s12Odv1Xx3N
        YiPJ/ZSf/KigrjCk543IpaH41Q==
X-Google-Smtp-Source: ABdhPJzPo6bX6U0VNh0qdiuApJHPADPVcNTw8Ah6/796S+EpoPaciyJoA37oTIpDPGOkSPQCBHa4rA==
X-Received: by 2002:a17:906:b7cd:: with SMTP id fy13mr23826393ejb.133.1591091175618;
        Tue, 02 Jun 2020 02:46:15 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id di14sm1277383edb.77.2020.06.02.02.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 02:46:15 -0700 (PDT)
References: <20200531082846.2117903-1-jakub@cloudflare.com> <20200531082846.2117903-12-jakub@cloudflare.com> <CAEf4BzbBRNCTxZvtn2s3uN+JG-Z6BpHvgbovi6abaQi6rSeBbQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next v2 11/12] selftests/bpf: Convert test_flow_dissector to use BPF skeleton
In-reply-to: <CAEf4BzbBRNCTxZvtn2s3uN+JG-Z6BpHvgbovi6abaQi6rSeBbQ@mail.gmail.com>
Date:   Tue, 02 Jun 2020 11:46:13 +0200
Message-ID: <87d06h3imy.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 12:42 AM CEST, Andrii Nakryiko wrote:
> On Sun, May 31, 2020 at 1:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Switch flow dissector test setup from custom BPF object loader to BPF
>> skeleton to save boilerplate and prepare for testing higher-level API for
>> attaching flow dissector with bpf_link.
>>
>> To avoid depending on program order in the BPF object when populating the
>> flow dissector PROG_ARRAY map, change the program section names to contain
>> the program index into the map. This follows the example set by tailcall
>> tests.
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  .../selftests/bpf/prog_tests/flow_dissector.c | 50 +++++++++++++++++--
>>  tools/testing/selftests/bpf/progs/bpf_flow.c  | 20 ++++----
>>  2 files changed, 55 insertions(+), 15 deletions(-)
>>
>
> [...]
>
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
>> index 9941f0ba471e..de6de9221518 100644
>> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
>> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
>> @@ -20,20 +20,20 @@
>>  #include <bpf/bpf_endian.h>
>>
>>  int _version SEC("version") = 1;
>> -#define PROG(F) SEC(#F) int bpf_func_##F
>> +#define PROG(F) PROG_(F, _##F)
>> +#define PROG_(NUM, NAME) SEC("flow_dissector/"#NUM) int bpf_func##NAME
>>
>>  /* These are the identifiers of the BPF programs that will be used in tail
>>   * calls. Name is limited to 16 characters, with the terminating character and
>>   * bpf_func_ above, we have only 6 to work with, anything after will be cropped.
>>   */
>> -enum {
>> -       IP,
>> -       IPV6,
>> -       IPV6OP, /* Destination/Hop-by-Hop Options IPv6 Extension header */
>> -       IPV6FR, /* Fragmentation IPv6 Extension Header */
>> -       MPLS,
>> -       VLAN,
>> -};
>
> not clear why? just add MAX_PROG after VLAN?

I wanted to change section names to:

  "flow_dissector/0"
  "flow_dissector/1"
  ...

while keeping the corresponding function names as:

  bpf_func_IP
  bpf_func_IPV6
  ...

For that I needed the preprocessor to know the value of the constant.

>
>> +#define IP             0
>> +#define IPV6           1
>> +#define IPV6OP         2 /* Destination/Hop-by-Hop Options IPv6 Ext. Header */
>> +#define IPV6FR         3 /* Fragmentation IPv6 Extension Header */
>> +#define MPLS           4
>> +#define VLAN           5
>> +#define MAX_PROG       6
>>
>>  #define IP_MF          0x2000
>>  #define IP_OFFSET      0x1FFF
>> @@ -59,7 +59,7 @@ struct frag_hdr {
>>
>>  struct {
>>         __uint(type, BPF_MAP_TYPE_PROG_ARRAY);
>> -       __uint(max_entries, 8);
>> +       __uint(max_entries, MAX_PROG);
>>         __uint(key_size, sizeof(__u32));
>>         __uint(value_size, sizeof(__u32));
>>  } jmp_table SEC(".maps");
>> --
>> 2.25.4
>>
