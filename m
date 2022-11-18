Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E901262F98D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242431AbiKRPlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242352AbiKRPlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:41:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0AB78D4B;
        Fri, 18 Nov 2022 07:41:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96084B8244F;
        Fri, 18 Nov 2022 15:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E359AC433B5;
        Fri, 18 Nov 2022 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668786063;
        bh=R4xBJmP/myMQ0Kip18TRQGWMGPC+256bduAJsZzqgm8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Pt0nEkiYP3Ivn4a4HL4M+vbconKZ7ATVzTHnVeCQ+LegKL8X286/oC1lyMsME/OXW
         ZMbTuE2qFVQLMuF8va+AOyLbVPqK30Yu74zham5+Guz2H9iplrRwJvZk2Is293TSPD
         Skuk3pPei4Cuitu/21dNYeFzCwmxHf7v59A+7rRRAxJE6dirbxk9Ksfgz/IFX7j6xF
         tpu6JsI5ZPCdgloE6dPrd09m5fsG22G+Wyl0onBDvdhzivzrtHmy7kfgJoE0jqoS+j
         x+zKiG91/B9E/11/sPBgiRXd2CMmtjSTAlm1xjUE/xgVSZcw2IqTkxjYikZ4zsPMWw
         x/ux5+87roo7Q==
Message-ID: <ebac6d76-6d6f-85e4-769c-b7e62c84e47b@kernel.org>
Date:   Fri, 18 Nov 2022 08:41:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] ipv4/fib: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20221118042142.never.400-kees@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221118042142.never.400-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/22 9:21 PM, Kees Cook wrote:
> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
> 
> Replace zero-length array with flexible-array member in struct key_vector.
> 
> This results in no differences in binary output.
> 
> [1] https://github.com/KSPP/linux/issues/78
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/ipv4/fib_trie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

