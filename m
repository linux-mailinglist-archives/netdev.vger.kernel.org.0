Return-Path: <netdev+bounces-5536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7125712070
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8015428168C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B294753BD;
	Fri, 26 May 2023 06:48:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDD020E6;
	Fri, 26 May 2023 06:48:16 +0000 (UTC)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10758125;
	Thu, 25 May 2023 23:48:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-2535edae73cso547565a91.2;
        Thu, 25 May 2023 23:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685083694; x=1687675694;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXMDaU9rZq6MJiyUvYrQQfTTjdS1c/VwlqVbFDmnFHw=;
        b=pPsoAJfp42YmeqcWPOvA19YhVI3la6Zanvh4UKdHzedmBAGaPa1xi455B6Ku8pfEdc
         refljePnvLJAeKvp215TiVemtPIFFwgBQWLMK80W+Ms/lVQT7fzdt/CdYuAF0L8UZowt
         9bAF4DIKWkebfD9C4Fj9VgcIRkRRr5XH6uAf1twAx9URwwp16ZQSNKNops69hMSJrhmc
         jXNnwVvDzeILzV90pyp1tsPuAewHdoXsghabQLPlPYpB5ufG5yKtztBIM8fTSZ83pG+z
         iIwv7vLcY7W/0Qx/Mtl6UugIzNISZlPv/1f+EXORUKqohOe8Q6MxSOpf7UfLL1ZhPnPB
         0iCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083694; x=1687675694;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sXMDaU9rZq6MJiyUvYrQQfTTjdS1c/VwlqVbFDmnFHw=;
        b=PncN0T/OQo/H2MmdhvdY0+bKV75hFj4tixSZIq1Vy/ywJQBPnWEwQZLB08CoZ+n2cG
         bnp8M4DS3Mf1JXjr5et24qyvhtFvNkcWsNOILQwPMD472Yu74+IuqkibeoZ/YZN1dwCg
         EDMWPtiM7PxxTxmT7RQx+f9KwYk6/9hiTqpGfYmMDhyKJxmvAieg4cMax/b9xN9qECB6
         YF4eYhCf7F7D0qPhaD+dpAeCpark81TfKITaEABdURChD1xhUERATUqUiFUtxXLnjo5E
         2WWtB7AClTEZVk82vDTDi/rSeHVDow7S2jq5UbcuMSb9alFiFCkv9cedSUBGo1NFAi77
         44Rw==
X-Gm-Message-State: AC+VfDwmaXqOjPpttL4PJtoJ1PwE/7Mfsaf+cEpziNAwwKPPKi+dUISG
	fSJpIa2Pqwty54Dv/uhcKX4=
X-Google-Smtp-Source: ACHHUZ6r85pJJu9IiHTvnDIDwfFxLWGAl926CckF3Z2Xb+cCJJV1hCmWOdnYJdULJyOAMeyDNFAiSg==
X-Received: by 2002:a17:90b:2344:b0:255:7a60:bce6 with SMTP id ms4-20020a17090b234400b002557a60bce6mr1224656pjb.40.1685083694418;
        Thu, 25 May 2023 23:48:14 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:17de:b2c5:b0ad:62a7])
        by smtp.gmail.com with ESMTPSA id cx18-20020a17090afd9200b002555689006esm3980915pjb.47.2023.05.25.23.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:48:13 -0700 (PDT)
Date: Thu, 25 May 2023 23:48:12 -0700
From: John Fastabend <john.fastabend@gmail.com>
To: Louis DeLosSantos <louis.delos.devel@gmail.com>, 
 bpf@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, 
 Stanislav Fomichev <sdf@google.com>, 
 razor@blackwall.org, 
 Louis DeLosSantos <louis.delos.devel@gmail.com>
Message-ID: <6470562cac756_2023020893@john.notmuch>
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
 <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
Subject: RE: [PATCH 1/2] bpf: add table ID to bpf_fib_lookup BPF helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Louis DeLosSantos wrote:
> Add ability to specify routing table ID to the `bpf_fib_lookup` BPF
> helper.
> 
> A new field `tbid` is added to `struct bpf_fib_lookup` used as
> parameters to the `bpf_fib_lookup` BPF helper.
> 
> When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` flag and the
> `tbid` field in `struct bpf_fib_lookup` is greater then 0, the `tbid`
> field will be used as the table ID for the fib lookup.
> 
> If the `tbid` does not exist the fib lookup will fail with
> `BPF_FIB_LKUP_RET_NOT_FWDED`.
> 
> The `tbid` field becomes a union over the vlan related output fields in
> `struct bpf_fib_lookup` and will be zeroed immediately after usage.
> 
> This functionality is useful in containerized environments.
> 
> For instance, if a CNI wants to dictate the next-hop for traffic leaving
> a container it can create a container-specific routing table and perform
> a fib lookup against this table in a "host-net-namespace-side" TC program.
> 
> This functionality also allows `ip rule` like functionality at the TC
> layer, allowing an eBPF program to pick a routing table based on some
> aspect of the sk_buff.
> 
> As a concrete use case, this feature will be used in Cilium's SRv6 L3VPN
> datapath.
> 
> When egress traffic leaves a Pod an eBPF program attached by Cilium will
> determine which VRF the egress traffic should target, and then perform a
> FIB lookup in a specific table representing this VRF's FIB.
> 
> Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
> ---
>  include/uapi/linux/bpf.h       | 17 ++++++++++++++---
>  net/core/filter.c              | 12 ++++++++++++
>  tools/include/uapi/linux/bpf.h | 17 ++++++++++++++---
>  3 files changed, 40 insertions(+), 6 deletions(-)
> 

Looks good one question. Should we hide tbid behind a flag we have
lots of room. Is there any concern a user could feed a bpf_fib_lookup
into the helper without clearing the vlan fields? Perhaps by
pulling the struct from a map or something where it had been
previously used.

Thanks,
John

