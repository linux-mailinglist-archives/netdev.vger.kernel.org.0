Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB75759A2
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 04:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiGOCq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 22:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiGOCq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 22:46:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F4565D52;
        Thu, 14 Jul 2022 19:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0A29B82A63;
        Fri, 15 Jul 2022 02:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E37C34114;
        Fri, 15 Jul 2022 02:46:48 +0000 (UTC)
Date:   Thu, 14 Jul 2022 22:46:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <20220714224646.62d49e36@rorschach.local.home>
In-Reply-To: <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-4-song@kernel.org>
        <20220713203343.4997eb71@rorschach.local.home>
        <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
        <20220714204817.2889e280@rorschach.local.home>
        <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
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

On Fri, 15 Jul 2022 02:04:33 +0000
Song Liu <songliubraving@fb.com> wrote:

> > What I'm suggesting is that a DIRECT ops will never set IPMODIFY.  
> 
> Aha, this the point I misunderstood. I thought DIRECT ops would always
> set IPMODIFY (as it does now). 

My fault. I was probably not being clear when I was suggesting that
DIRECT should *act* like an IPMODIFY, but never explicitly stated that
it should not set the IPMODIFY flag.

The only reason it does today was to make it easy to act like an
IPMODIFY (because it set the flag). But I'm now suggesting to get rid
of that and just make DIRECT act like an IPMDOFIY as there can only be
one of them on a function, but now we have some cases where DIRECT can
work with IPMODIFY via the callbacks.

-- Steve
