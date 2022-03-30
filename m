Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A113E4ECAD2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 19:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349381AbiC3Rju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 13:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344245AbiC3Rjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 13:39:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F47FD4CB8;
        Wed, 30 Mar 2022 10:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E3C2B81DF5;
        Wed, 30 Mar 2022 17:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA82C34110;
        Wed, 30 Mar 2022 17:37:59 +0000 (UTC)
Date:   Wed, 30 Mar 2022 13:37:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tracing: Set user_events to BROKEN
Message-ID: <20220330133758.712768db@gandalf.local.home>
In-Reply-To: <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
References: <20220329222514.51af6c07@gandalf.local.home>
        <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
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

On Wed, 30 Mar 2022 12:54:13 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- On Mar 29, 2022, at 10:25 PM, rostedt rostedt@goodmis.org wrote:
> 
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > After being merged, user_events become more visible to a wider audience
> > that have concerns with the current API. It is too late to fix this for
> > this release, but instead of a full revert, just mark it as BROKEN (which
> > prevents it from being selected in make config). Then we can work finding
> > a better API. If that fails, then it will need to be completely reverted.  
> 
> Hi Steven,
> 
> What are the constraints for changing a uapi header after it has been present
> in a kernel release ?
> 
> If we are not ready to commit to an ABI, perhaps it would be safer to ensure
> that include/uapi/linux/user_events.h is not installed with the uapi headers
> until it's ready.
> 

Linus may say otherwise, but from what I understand is that we can not
break a user space application from one release to the next. That means, the
only way to break something is if it is actually using something in binary
form.

I can not think of a situation where a header file is useful if the API
it's used for is not available. Thus do we really need to hide it? What
applications will use a header file that has no interface for it?

I do not see the need to remove the uapi if the API for that structure is
not available yet.

-- Steve
