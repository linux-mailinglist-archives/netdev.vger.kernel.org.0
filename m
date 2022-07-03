Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4D656474C
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 14:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiGCMsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 08:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGCMsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 08:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DD65FF4;
        Sun,  3 Jul 2022 05:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19BE7612DC;
        Sun,  3 Jul 2022 12:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D831C341C6;
        Sun,  3 Jul 2022 12:48:09 +0000 (UTC)
Date:   Sun, 3 Jul 2022 08:48:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] 9p fid refcount: add a 9p_fid_ref tracepoint
Message-ID: <20220703084808.1d6a9989@rorschach.local.home>
In-Reply-To: <20220702102913.2164800-1-asmadeus@codewreck.org>
References: <20220702102913.2164800-1-asmadeus@codewreck.org>
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

On Sat,  2 Jul 2022 19:29:14 +0900
Dominique Martinet <asmadeus@codewreck.org> wrote:

> This adds a tracepoint event for 9p fid lifecycle tracing: when a fid
> is created, its reference count increased/decreased, and freed.
> The new 9p_fid_ref tracepoint should help anyone wishing to debug any
> fid problem such as missing clunk (destroy) or use-after-free.
> 
> Link: https://lkml.kernel.org/r/20220612085330.1451496-6-asmadeus@codewreck.org
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
> 
> Just resending this single patch of the series as it's the only one
> without a review tag.
> 
> Steven, is it ok to carry it in my tree as is or do I need blessings
> from you or Ingo?

The addition of trace events do belong to the maintainers of where the
trace events go.

> (it depends on the previous patch so I'd carry it in my tree anyway,
> but would be more comfortable with a reviewed-by tag)

Yes, I prefer people Cc me on trace events just so that I can catch
mistakes or find better ways to accomplish what is trying to be done.

Especially for something that does changes like this patch, which are
not just the trivial TRACE_EVENT() trace_*() procedure. Thanks for
Cc'ing me.

> 
> 
> v2 -> v3:
>  - added EXPORT_TRACEPOINT_SYMBOL(9p_fid_ref) to have this work when
>    built as module
> 
> v1 -> v2:
>  - added rationale to commit message
>  - adjusted to use DECLARE_TRACEPOINT + tracepoint_enable() in header
> 
>  include/net/9p/client.h   | 13 +++++++++++
>  include/trace/events/9p.h | 48 +++++++++++++++++++++++++++++++++++++++
>  net/9p/client.c           | 20 +++++++++++++++-
>  3 files changed, 80 insertions(+), 1 deletion(-)
> 

The rest looks fine.

For the tracing point of view:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
