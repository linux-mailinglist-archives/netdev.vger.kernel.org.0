Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9CB56C229
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbiGHUSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 16:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbiGHUSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 16:18:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0663E5F96
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 13:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 978A862879
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 20:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9521CC341C0;
        Fri,  8 Jul 2022 20:18:29 +0000 (UTC)
Date:   Fri, 8 Jul 2022 16:18:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        quic_jzenner@quicinc.com, "Cong Wang ." <cong.wang@bytedance.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Subject: Re: [PATCH net-next v2] net: Print hashed skb addresses for all net
 and qdisc events
Message-ID: <20220708161828.70d108f2@gandalf.local.home>
In-Reply-To: <CAM_iQpVXs5npkommaZzTTvoPKyjhpPL3ws5DtFGvG+_yYVX4dA@mail.gmail.com>
References: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
        <YroGx7Wd2BQ28PjA@pop-os.localdomain>
        <ad6f3fbc-9996-6fa7-2015-01832b013c98@quicinc.com>
        <CAM_iQpVXs5npkommaZzTTvoPKyjhpPL3ws5DtFGvG+_yYVX4dA@mail.gmail.com>
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

On Sat, 2 Jul 2022 21:36:19 -0700
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> > Matching skbs addresses (in a particular format) helps to track the
> > packet traversal timings / delays in processing.  
> 
> So... how didn't you notice the duplicated addresses with hashed ones?
> It is 100% reproducible to see duplicates with hashed ones.

Yes the hashes are reproducible giving the same address for this exact
purpose (to match like addresses).

I'm not sure if your last sentence was a question or a statement (it did
not end with a question mark).

But I agree with this patch that the trace events that reference the same
address should be consistent in its use of %p and %px, where it uses one or
the other and not mix and match. Because the value itself may not be
important to a trace, but knowing that the value is consistent throughout
the trace with different tracepoints is.

-- Steve
