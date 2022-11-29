Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCE363C7B5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbiK2TBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbiK2TBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:01:10 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C64F59
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:00:03 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id u10-20020a17090a400a00b00215deac75b4so10353043pjc.3
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YrIwK5afTQO/qKn0v/ZglneBEpq38VdgdU3mQcxlua4=;
        b=EBjGumsrY5Y5QyAnSraQ55klyb/pQXqKTxNShaOM1O5rJik2ldrYH4KRR8RH+E4JCo
         gAvD8Qeb/he2WS8XgAb6peWZHaP34pqdV46cv9RUDaZ6cHxVC3y8of9uRM51QB7ce0jJ
         eHoJDAZH0L5MYqb1AfKTtFKxYR7W/w8aMZy/Mi4dsg2mGIYZUGzAbE4e/g7fEUebpOrE
         yc9o+cOJMT2+BeBOajcj5XPbcF6eBJyfv4qN6IzcQxJLBTlmBoiNPjOSzMecrIthAJrv
         kFpJMp4v6u8YH84d124t5XA0+9ogrVIHdLD62SIDe59KHo9IerPTk1G51CLaDbuopb7m
         y7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YrIwK5afTQO/qKn0v/ZglneBEpq38VdgdU3mQcxlua4=;
        b=mDa0/eTUIYUBsm5Cm1NEroxl+GaZYhjriAs3tkE9/q9J14NAkMG0tHKi6VQOPpN+Xn
         Z9AuearVB0dbMngZ+uBHjJMpkNF6FvOZ45R/t6OFIs60iYc31CRel3lH7cH5PK3d2OCy
         riLM8oYabu0Jo9txE7qtXt6emMenpsrj8aLJ0JL3JgZ4vmdgaTXoO36jpYS0QlSVZ+0Q
         +oQJg25vQg7uUhBbsWIXBpsnNxscF/pko4sGMs2KVEroSm4lrlRU2l6e21/dYvQ5d0gI
         rz3TO7eMXxu988soIPonWCdVmKe/nxoSTjZWu2xq8JP2+et4JbeKvEIHbVBGCXf5KZRo
         xcgg==
X-Gm-Message-State: ANoB5plhcFKm0R3JS5hbF7uTpfZNb/4yi/w8mBMx8c+hVUVYD32fBA2D
        rPrURShM7V3aj8pvAZgMncwD8DI=
X-Google-Smtp-Source: AA0mqf6yaLWhuR8bIayxNbDI4HnwARh6uJn9P5nMloOp9WGH7Slq6WE/y5Au7kTMPq7oL4gy269oPxw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:ce90:b0:187:19c4:373a with SMTP id
 f16-20020a170902ce9000b0018719c4373amr50967842plg.163.1669748402714; Tue, 29
 Nov 2022 11:00:02 -0800 (PST)
Date:   Tue, 29 Nov 2022 11:00:01 -0800
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
Mime-Version: 1.0
References: <20221129070900.3142427-1-martin.lau@linux.dev>
Message-ID: <Y4ZWsXKTKgm/e7P8@google.com>
Subject: Re: [PATCH bpf-next 0/7] selftests/bpf: Remove unnecessary
 mount/umount dance
From:   sdf@google.com
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, "'Alexei Starovoitov '" <ast@kernel.org>,
        "'Andrii Nakryiko '" <andrii@kernel.org>,
        "'Daniel Borkmann '" <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28, Martin KaFai Lau wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>

> Some of the tests do mount/umount dance when switching netns.
> It is error-prone like  
> https://lore.kernel.org/bpf/20221123200829.2226254-1-sdf@google.com/

> Another issue is, there are many left over after running some of the  
> tests:
> #> mount | egrep sysfs | wc -l
> 19

> Instead of further debugging this dance,  this set is to avoid the needs  
> to
> do this remounting altogether.  It will then allow those tests to be run
> in parallel again.

Looks great, thank you for taking care of this! Since I'm partly to
blame for the mess, took a quick look at the series:

Acked-by: Stanislav Fomichev <sdf@google.com>

> Martin KaFai Lau (7):
>    selftests/bpf: Use if_nametoindex instead of reading the
>      /sys/net/class/*/ifindex
>    selftests/bpf: Avoid pinning bpf prog in the tc_redirect_dtime test
>    selftests/bpf: Avoid pinning bpf prog in the tc_redirect_peer_l3 test
>    selftests/bpf: Avoid pinning bpf prog in the netns_load_bpf() callers
>    selftests/bpf: Remove the "/sys" mount and umount dance in
>      {open,close}_netns
>    selftests/bpf: Remove serial from tests using {open,close}_netns
>    selftests/bpf: Avoid pinning prog when attaching to tc ingress in
>      btf_skc_cls_ingress

>   tools/testing/selftests/bpf/network_helpers.c |  51 +--
>   .../bpf/prog_tests/btf_skc_cls_ingress.c      |  25 +-
>   .../selftests/bpf/prog_tests/empty_skb.c      |   2 +-
>   .../selftests/bpf/prog_tests/tc_redirect.c    | 314 +++++++++---------
>   .../selftests/bpf/prog_tests/test_tunnel.c    |   2 +-
>   .../bpf/prog_tests/xdp_do_redirect.c          |   2 +-
>   .../selftests/bpf/prog_tests/xdp_synproxy.c   |   2 +-
>   7 files changed, 178 insertions(+), 220 deletions(-)

> --
> 2.30.2

