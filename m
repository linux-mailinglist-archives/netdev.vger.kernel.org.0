Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E6260FC32
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiJ0PoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiJ0Pn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE6F1905F5;
        Thu, 27 Oct 2022 08:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B67A7623B9;
        Thu, 27 Oct 2022 15:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBEBC433D6;
        Thu, 27 Oct 2022 15:43:53 +0000 (UTC)
Date:   Thu, 27 Oct 2022 11:44:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Hao Peng <flyingpeng@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, robh@kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: skb: export skb drop reaons to user by
 TRACE_DEFINE_ENUM
Message-ID: <20221027114407.6429a809@gandalf.local.home>
In-Reply-To: <CANn89i+qp=gmhx_1b+=hEiHA7yNGkfh46YPKhUc9GFbtNYBZrA@mail.gmail.com>
References: <20220902141715.1038615-1-imagedong@tencent.com>
        <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
        <20220905103808.434f6909@gandalf.local.home>
        <CANn89i+qp=gmhx_1b+=hEiHA7yNGkfh46YPKhUc9GFbtNYBZrA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 08:32:02 -0700
Eric Dumazet <edumazet@google.com> wrote:

> This seems broken again (tried on latest net-next tree)
> 
> perf script

Do you also have the latest perf and the latest libtraceevent installed?

-- Steve

>             sshd 12192 [006]   200.090602: skb:kfree_skb:
> skbaddr=0x2fa000400000 protocol=7844 location=0x2fa000001ea4 reason:
>          swapper     0 [030]   200.497468: skb:kfree_skb:
> skbaddr=0xba00400001 protocol=65535 location=0x9080c62800000000
> reason:
>  kworker/30:1-ev   308 [030]   200.497476: skb:kfree_skb:
> skbaddr=0xba00400001 protocol=65535 location=0x9080c62800000000
> reason:
>          swapper     0 [009]   200.957881: skb:kfree_skb:
> skbaddr=0x2fa400400000 protocol=12195 location=0x2fa400002fa3 reason:
>          swapper     0 [026]   201.515769: skb:kfree_skb:
> skbaddr=0xb600400001 protocol=65535 location=0x9080c62800000000
> reason:
>  kworker/26:1-mm   276 [026]   201.515797: skb:kfree_skb:
> skbaddr=0xb600400001 protocol=65535 location=0x9080c62800000000
> reason:
>  kworker/26:1-mm   276 [026]   201.515802: skb:kfree_skb:
> skbaddr=0x2f9f00400000 protocol=12189 location=0x2f9f00002f9d reason:
>          swapper     0 [030]   201.521484: skb:kfree_skb:
> skbaddr=0xba00400001 protocol=65535 location=0x9080c62800000000
> reason:
>  kworker/30:1-ev   308 [030]   201.521491: skb:kfree_skb:
> skbaddr=0x2fa100400000 protocol=12192 location=0x2fa100002fa0 reason:
