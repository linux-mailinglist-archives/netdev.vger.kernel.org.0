Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D7D666860
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 02:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbjALB05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 20:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbjALB0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 20:26:55 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04269E0DB;
        Wed, 11 Jan 2023 17:26:53 -0800 (PST)
Message-ID: <3f068fde-e746-01b8-2193-358e2bbfdf01@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673486811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Obwq7zl79ARIdU4cPNymP8j/8LdWqtRByWEmKnrHem8=;
        b=IKJAPy22cgxSudi9mOV/2QO3tpKmyV01BJJo1Han0n5PmLFCEzB0f81x1xkL9Y/sHYPjpI
        Z33WiuzuaaGr92i9Yoeqi8JKBkHm8EppeSKHZv8Z6DCc0XiErXiB/J4kte6A/prqk0dXBD
        jfX97AZmJITmdlJeCOpfLVHxzRmdjZM=
Date:   Wed, 11 Jan 2023 17:26:43 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add ipip6 and ip6ip decap support
 for bpf_skb_adjust_room()
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        willemb@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org
References: <cover.1673423199.git.william.xuanziyang@huawei.com>
 <b231c7d0acacd702284158cd44734e72ef661a01.1673423199.git.william.xuanziyang@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <b231c7d0acacd702284158cd44734e72ef661a01.1673423199.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/23 12:01 AM, Ziyang Xuan wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 464ca3f01fe7..dde1c2ea1c84 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2644,6 +2644,12 @@ union bpf_attr {
>    *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
>    *		  L2 type as Ethernet.
>    *
> + *              * **BPF_F_ADJ_ROOM_DECAP_L3_IPV4**,
> + *                **BPF_F_ADJ_ROOM_DECAP_L3_IPV6**:
> + *                Indicate the new IP header version after decapsulating the
> + *                outer IP header. Mainly used in scenarios that the inner and
> + *                outer IP versions are different.
> + *

selftests/bpf failed to compile. It is probably because there is leading spaces 
instead of using tabs: 
https://github.com/kernel-patches/bpf/actions/runs/3890850490/jobs/6640395038#step:11:112

   /tmp/work/bpf/bpf/tools/testing/selftests/bpf/bpf-helpers.rst:1112: 
(WARNING/2) Bullet list ends without a blank line; unexpected unindent.
   make[1]: *** [Makefile.docs:76: 
/tmp/work/bpf/bpf/tools/testing/selftests/bpf/bpf-helpers.7] Error 12
   make: *** [Makefile:259: docs] Error 2

