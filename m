Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61AA4B8E82
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiBPQuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:50:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiBPQuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:50:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C03528DDE2;
        Wed, 16 Feb 2022 08:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2ECB61B8A;
        Wed, 16 Feb 2022 16:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EFDC004E1;
        Wed, 16 Feb 2022 16:50:05 +0000 (UTC)
Date:   Wed, 16 Feb 2022 11:50:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     menglong8.dong@gmail.com, dsahern@kernel.org, edumazet@google.com,
        davem@davemloft.net, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me, memxor@gmail.com,
        atenart@kernel.org, bigeasy@linutronix.de, pabeni@redhat.com,
        linyunsheng@huawei.com, arnd@arndb.de, yajun.deng@linux.dev,
        roopa@nvidia.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, luiz.von.dentz@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: Re: [PATCH net-next 1/9] net: tcp: introduce tcp_drop_reason()
Message-ID: <20220216115004.5e9dc2b6@gandalf.local.home>
In-Reply-To: <20220216075821.219b911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
        <20220216035426.2233808-2-imagedong@tencent.com>
        <20220216075821.219b911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 07:58:21 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 16 Feb 2022 11:54:18 +0800 menglong8.dong@gmail.com wrote:
> > +static inline void tcp_drop(struct sock *sk, struct sk_buff *skb)
> > +{
> > +	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
> >  }  
> 
> Please make this non-inline. The compiler will inline it anyway, and 
> if it's a static inline compiler will not warn us that it should be
> removed once all callers are gone.

I guess that's no longer true for C files.

  https://lore.kernel.org/all/202202132037.4aN017dU-lkp@intel.com/

-- Steve
