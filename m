Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C3F4DDCB6
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbiCRPZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbiCRPZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:25:15 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494499D4CC
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 08:23:56 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bu29so14718900lfb.0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 08:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=80nAaBJwzuYDgsGCZRiFh3oXIaKXMd0XIU+5D2UsW9A=;
        b=Krdg1CfipGSeEARCltKcVCXVPnYRoji7T+ijtR7XzwKUSod1JL/maCAoTVqX33UX7c
         ZFDpIUY/6XW7spZOraUJy6sab/9ApyYZV06WKry+kF8UdaEKiyaM6YQCBsK3R5ixC416
         pNwV3rr92bw+zBEUqAiE8UtnAFDyD6mqsdaz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=80nAaBJwzuYDgsGCZRiFh3oXIaKXMd0XIU+5D2UsW9A=;
        b=lY9OV5cuEJIALOKWbOAtRbNwS0EzO80aE+JqsQcckvt+2Fx3AgyA1QplMBjzop1Fym
         QaXXr0EW5x7pD328LbMjl3F458rxws0LXHr34dz37lCd5W4Rsd3c6AaKD/PEDo0snlD1
         bI5MLmnG3JFTpGLty6KicGG7xGzH2WkkFtzkKs7trPOOHRbyiNAYzW0QL/+25AxUfi7X
         T+QgJ9kHa2oLYQjXclJjjRM8zwy6DbaeOBVcMDFfOmq6VWQGcbx7gAL+2eWdYaenrVSW
         lN4wQnFL7W0Tq5/Nf3IeV635Vg5rlNWlchQaWXsVv1PnYSotgMoZ0atvbDLsM3GPF4tj
         JvvQ==
X-Gm-Message-State: AOAM532fxNQv2aZCkfJNmeCCMzMa4rlg47zqif2JxPKAh7+U3CZFz3Yn
        hbgEtbspwBYlRSEYfwlQ+StE+Q==
X-Google-Smtp-Source: ABdhPJxH8t4kEU6WJKtrb02RThVcvAsyeqk1/f21rFe2Y3a9eMbPNR6i7oC9hchUfwlqffo6vzgAaA==
X-Received: by 2002:a05:6512:23a1:b0:44a:a29:c6be with SMTP id c33-20020a05651223a100b0044a0a29c6bemr2580684lfv.409.1647617034411;
        Fri, 18 Mar 2022 08:23:54 -0700 (PDT)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0f9c.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id m22-20020a2e7116000000b0024805a43db1sm979153ljc.63.2022.03.18.08.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 08:23:54 -0700 (PDT)
References: <20220317165826.1099418-1-jakub@cloudflare.com>
 <20220317165826.1099418-2-jakub@cloudflare.com>
 <20220318012219.wtrpgaawg4czsqcj@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Treat bpf_sk_lookup remote_port as a
 2-byte field
Date:   Fri, 18 Mar 2022 16:22:57 +0100
In-reply-to: <20220318012219.wtrpgaawg4czsqcj@kafai-mbp.dhcp.thefacebook.com>
Message-ID: <87fsnfz3lj.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 06:22 PM -07, Martin KaFai Lau wrote:
> On Thu, Mar 17, 2022 at 05:58:24PM +0100, Jakub Sitnicki wrote:
>> In commit 9a69e2b385f4 ("bpf: Make remote_port field in struct
>> bpf_sk_lookup 16-bit wide") the remote_port field has been split up and
>> re-declared from u32 to be16.
>> 
>> However, the accompanying changes to the context access converter have not
>> been well thought through when it comes big-endian platforms.
>> 
>> Today 2-byte wide loads from offsetof(struct bpf_sk_lookup, remote_port)
>> are handled as narrow loads from a 4-byte wide field.
>> 
>> This by itself is not enough to create a problem, but when we combine
>> 
>>  1. 32-bit wide access to ->remote_port backed by a 16-wide wide load, with
>>  2. inherent difference between litte- and big-endian in how narrow loads
>>     need have to be handled (see bpf_ctx_narrow_access_offset),
>> 
>> we get inconsistent results for a 2-byte loads from &ctx->remote_port on LE
>> and BE architectures. This in turn makes BPF C code for the common case of
>> 2-byte load from ctx->remote_port not portable.
>> 
>> To rectify it, inform the context access converter that remote_port is
>> 2-byte wide field, and only 1-byte loads need to be treated as narrow
>> loads.
>> 
>> At the same time, we special-case the 4-byte load from &ctx->remote_port to
>> continue handling it the same way as do today, in order to keep the
>> existing BPF programs working.
>> 
>> Fixes: 9a69e2b385f4 ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide")
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  net/core/filter.c | 20 ++++++++++++++++++--
>>  1 file changed, 18 insertions(+), 2 deletions(-)
>> 
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 03655f2074ae..9b1e453baf6d 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -10989,13 +10989,24 @@ static bool sk_lookup_is_valid_access(int off, int size,
>>  	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
>>  	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
>>  	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
>> -	case offsetof(struct bpf_sk_lookup, remote_port) ...
>> -	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
>>  	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
>>  	case bpf_ctx_range(struct bpf_sk_lookup, ingress_ifindex):
>>  		bpf_ctx_record_field_size(info, sizeof(__u32));
>>  		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));
>>  
>> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
>> +		/* Allow 4-byte access to 2-byte field for backward compatibility */
>> +		if (size == sizeof(__u32))
>> +			return off == offsetof(struct bpf_sk_lookup, remote_port);
> nit. The bad "off" value should have been rejected earlier in the
> "if (off % size != 0)" check?

Good catch. That is always true. I will respin.

Thanks for reviewing the patch sets.

[...]
