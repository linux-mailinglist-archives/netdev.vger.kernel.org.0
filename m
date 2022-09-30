Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD635F01CC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiI3Acy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiI3Acw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:32:52 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29867201926;
        Thu, 29 Sep 2022 17:32:51 -0700 (PDT)
Message-ID: <abd188ce-a097-5626-87bf-607495035a66@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664497969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oQQ9UnZcw+7W3tA3dX1+mkDW7xkF2LaunwbyXaFLHbI=;
        b=rpSirTS+cnKO7SC2v5k0ChqWMOLVyXWrd+CX9YMjI6j206K2XJNcleIZ6sx9NCULWyDYIY
        KN7Ebl3xHKFu13TW+CJqhRa/cNqXdtr0jsNd2ZVZG0PNy3E0z/PlgA/LbNzKTJ8GYOdTN0
        AV10GIFGaIuqFGvP7M0USF+G/hnFuNg=
Date:   Thu, 29 Sep 2022 17:32:43 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 bpf-next] net: netfilter: move bpf_ct_set_nat_info
 kfunc in nf_nat_bpf.c
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, nathan@kernel.org, ykaliuta@redhat.com,
        bpf <bpf@vger.kernel.org>
References: <51a65513d2cda3eeb0754842e8025ab3966068d8.1664490511.git.lorenzo@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <51a65513d2cda3eeb0754842e8025ab3966068d8.1664490511.git.lorenzo@kernel.org>
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

On 9/29/22 3:38 PM, Lorenzo Bianconi wrote:
> Remove circular dependency between nf_nat module and nf_conntrack one
> moving bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
> 
> Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
> Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Yauheni Kaliuta <ykaliuta@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - move register_nf_nat_bpf declaration in nf_conntrack_bpf.h
> ---
>   include/net/netfilter/nf_conntrack_bpf.h | 19 ++++++
>   net/netfilter/Makefile                   |  6 ++
>   net/netfilter/nf_conntrack_bpf.c         | 50 ---------------
>   net/netfilter/nf_nat_bpf.c               | 79 ++++++++++++++++++++++++
>   net/netfilter/nf_nat_core.c              |  4 +-

lgtm.  It should have addressed Pablo's comment in v1.  Can the netfilter team 
give an ack for the patch?

