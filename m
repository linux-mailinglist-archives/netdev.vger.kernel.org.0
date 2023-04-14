Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53446E242D
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDNNUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjDNNUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:20:15 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DB6120
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:20:14 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l18so17412718wrb.9
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1681478412; x=1684070412;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3+G2cusxN2eA1L5GyGm+EeLwoLT0jo+QBIq2uCh+LWo=;
        b=Oo7lBJAMIOy5sntvD6OkYaMHjTDcnyjLcFmtP6W+DKf3yCOD9tkqKDzou/PGArNoBl
         xhdw1pcMVjJ3YlI2Ew1a7uJzhhHFoFBnGHxHjD3NVuwlgg4O76L76C9lB142sVkew+Af
         wHVstWg7DDZbz4NvdztoGaH1d0KA8x2n511BXx0R62BGUMs1xXNemG5ZDvk9KhUp8cCl
         PK5eQZt0dnY+LfkETvCsmVofRFX8CKph9L336F2OpJNGBBwn2TggxJvo8nVeobUP4ZYZ
         TeLW9Lc9BLxOPEMf8gSYDD5YbHKdXDB+Totak4ndHU3X2U0zzfl5Ek73VvpT2XBVtzJM
         IEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681478412; x=1684070412;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+G2cusxN2eA1L5GyGm+EeLwoLT0jo+QBIq2uCh+LWo=;
        b=XFyIJ+uaXD39uqe2LlQZlwjhqxbFIN+uCikIdw0dGQwPxdeD44ryu7AAPUHyqaMBWr
         Gah4vInImpTxNdZH5w+dAy0rhoqO/62vgSjvYufvjKbnlDuonKauPT4jXMaUX+KdQ7Ya
         jV+P2Gwey5RNCocIpvdJgixXaTTDm1KL+yj3v5pdLInAjtuOBYw9thf6CaAnjzuSHm2Q
         Lk679tsdMgvWo0c+NU+xS1k5ABU+w49VOb8j4BZADtFn7FU6FH8ngyrKy2ZpHxkh7oX9
         teUsS+PFVNtjR+dQWxJrCW4Aj3on0lrMeX+1v3PKWRbmoZKzC3Z/OhMVY7+rNcRUnBqx
         6oOg==
X-Gm-Message-State: AAQBX9f45H6+RPsODib4Z33EjY/GTRkzvjACcs6IfUNb71GLImUnu6Tr
        TM/aY0EAZnOJguV7tH73H6uxZQ==
X-Google-Smtp-Source: AKy350ZUG90NcwZrvpOu4trc+Cibc2I2kMAmY8KSsn8vmA3TiXY0RPX6ycLOjf/XKUatGgidQjy+Iw==
X-Received: by 2002:a5d:6b0b:0:b0:2f4:a040:cda7 with SMTP id v11-20020a5d6b0b000000b002f4a040cda7mr3868571wrw.50.1681478412454;
        Fri, 14 Apr 2023 06:20:12 -0700 (PDT)
Received: from ?IPV6:2a02:8011:e80c:0:d040:969c:6e8e:e95d? ([2a02:8011:e80c:0:d040:969c:6e8e:e95d])
        by smtp.gmail.com with ESMTPSA id bl18-20020adfe252000000b002d7a75a2c20sm3540134wrb.80.2023.04.14.06.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 06:20:12 -0700 (PDT)
Message-ID: <eeeaac99-9053-90c2-aa33-cc1ecb1ae9ca@isovalent.com>
Date:   Fri, 14 Apr 2023 14:20:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH bpf-next v2 5/6] tools: bpftool: print netfilter link info
Content-Language: en-GB
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
References: <20230413133228.20790-1-fw@strlen.de>
 <20230413133228.20790-6-fw@strlen.de>
 <CACdoK4LRjNsDY6m2fvUGY_C9gMvUdX9QpEetr9RtGuR8xb8pmg@mail.gmail.com>
 <20230414104121.GB5889@breakpoint.cc>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20230414104121.GB5889@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-04-14 12:41 UTC+0200 ~ Florian Westphal <fw@strlen.de>
> Quentin Monnet <quentin@isovalent.com> wrote:
>> On Thu, 13 Apr 2023 at 14:36, Florian Westphal <fw@strlen.de> wrote:
>>>
>>> Dump protocol family, hook and priority value:
>>> $ bpftool link
>>> 2: type 10  prog 20
>>
>> Could you please update link_type_name in libbpf (libbpf.c) so that we
>> display "netfilter" here instead of "type 10"?
> 
> Done.

Thanks!

I'm just thinking we could also maybe print something nicer for the pf
and the hook, "NF_INET_LOCAL_IN" would be more user-friendly than "hook 1"?

> 
>>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>>> index 3823100b7934..c93febc4c75f 100644
>>> --- a/tools/include/uapi/linux/bpf.h
>>> +++ b/tools/include/uapi/linux/bpf.h
>>> @@ -986,6 +986,7 @@ enum bpf_prog_type {
>>>         BPF_PROG_TYPE_LSM,
>>>         BPF_PROG_TYPE_SK_LOOKUP,
>>>         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
>>> +       BPF_PROG_TYPE_NETFILTER,
>>
>> If netfilter programs could be loaded with bpftool, we'd need to
>> update bpftool's docs. But I don't think this is the case, right?
> 
> bpftool prog load nftest.o /sys/fs/bpf/nftest
> 
> will work, but the program isn't attached anywhere.

Let's maybe not document it, then. It may still be useful to check
whether a program load, but users would definitely expect the program to
remain loaded after bpftool invocation has completed. Or alternatively,
we could document, but print a warning.

> 
>> don't currently have a way to pass the pf, hooknum, priority and flags
>> necessary to load the program with "bpftool prog load" so it would
>> fail?
> 
> I don't know how to make it work to actually attach it, because
> the hook is unregistered when the link fd is closed.
> 
> So either bpftool would have to fork and auto-daemon (maybe
> unexpected...) or wait/block until CTRL-C.
> 
> This also needs new libbpf api AFAICS because existing bpf_link
> are specific to the program type, so I'd have to add something like:
> 
> struct bpf_link *
> bpf_program__attach_netfilter(const struct bpf_program *prog,
> 			      const struct bpf_netfilter_opts *opts)
> 
> Advice welcome.

OK, yes we'd need something like this if we wanted to load and attach
from bpftool. If you already have the tooling elsewhere, it's maybe not
necessary to add it here. Depends if you want users to be able to attach
netfilter programs with bpftool or even libbpf.

There are other program types that are not supported for
loading/attaching with bpftool (the bpftool-prog man page is not always
correct in that regard, I think).

I'd say let's keep this out of the current patchset anyway. If we have a
use case for attaching via libbpf/bpftool we can do this as a follow-up.

> 
>> Have you considered listing netfilter programs in the output of
>> "bpftool net" as well? Given that they're related to networking, it
>> would maybe make sense to have them listed alongside XDP, TC, and flow
>> dissector programs?
> 
> I could print the same output that 'bpf link' already shows.
> 
> Not sure on the real distinction between those two here.

There would probably be some overlap (to say the least), yes.

> 
> When should I use 'bpftool link' and when 'bpftool net', and what info
> and features should either of these provide for netfilter programs?

That's a good question. I thought I'd check how we handle it for XDP for
"bpftool net" vs. "bpftool link", but I realised this link type (and
some others) were never added to the switch/case you update in
bpftool/link.c, and we're not printing any particular information about
them beyond type and associated program id. Conversely, I'd have to
check whether we print XDP programs using links in "bpftool net". Maybe
some things to improve here. Anyway.

The way I see it, "bpftool net" should provide a more structured
overview of the different programs affecting networking, in particular
for JSON. The idea would be to display all BPF programs that can affect
packet processing. See what we have for XDP for example:


    # bpftool net -p
    [{
            "xdp": [{
                    "devname": "eni88np1",
                    "ifindex": 12,
                    "multi_attachments": [{
                            "mode": "driver",
                            "id": 1238
                        },{
                            "mode": "offload",
                            "id": 1239
                        }
                    ]
                }
            ],
            "tc": [{
                    "devname": "eni88np1",
                    "ifindex": 12,
                    "kind": "clsact/ingress",
                    "name": "sample_ret0.o:[.text]",
                    "id": 1241
                },{
                    "devname": "eni88np1",
                    "ifindex": 12,
                    "kind": "clsact/ingress",
                    "name": "sample_ret0.o:[.text]",
                    "id": 1240
                }
            ],
            "flow_dissector": [
                "id": 1434
            ]
        }
    ]

This gives us all the info about XDP programs at once, grouped by device
when relevant. By contrast, listing them in "bpftool link" would likely
only show one at a time, in an uncorrelated manner. Similarly, we could
have netfilter sorted by pf then hook in "bpftool net". If there's more
relevant info that we get from program info and not from the netfilter
link, this would also be a good place to have it (but not sure there's
any info we're missing from "bpftool link"?).

But given that the info will be close, or identical, if not for the JSON
structure, I don't mean to impose this to you - it's also OK to just
skip "bpftool net" for now if you prefer.

Quentin
