Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF96E4ECDF0
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 22:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350961AbiC3UXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 16:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiC3UXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 16:23:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA86B3BA5F;
        Wed, 30 Mar 2022 13:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6384B61637;
        Wed, 30 Mar 2022 20:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABD2C340EE;
        Wed, 30 Mar 2022 20:21:54 +0000 (UTC)
Date:   Wed, 30 Mar 2022 16:21:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel@vger.kernel.org,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing: do not export user_events uapi
Message-ID: <20220330162152.17b1b660@gandalf.local.home>
In-Reply-To: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
References: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
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


Adding the build maintainers.

-- Steve

On Wed, 30 Mar 2022 16:17:55 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> In addition to mark the USER_EVENTS feature BROKEN until all interested
> parties figure out the user-space API, do not install the uapi header.
> 
> This prevents situations where a non-final uapi header would end up
> being installed into a distribution image and used to build user-space
> programs that would then run against newer kernels that will implement
> user events with a different ABI.
> 
> Link: https://lore.kernel.org/all/20220330155835.5e1f6669@gandalf.local.home
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  include/uapi/Kbuild | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
> index 61ee6e59c930..425ea8769ddc 100644
> --- a/include/uapi/Kbuild
> +++ b/include/uapi/Kbuild
> @@ -12,3 +12,6 @@ ifeq ($(wildcard $(objtree)/arch/$(SRCARCH)/include/generated/uapi/asm/kvm_para.
>  no-export-headers += linux/kvm_para.h
>  endif
>  endif
> +
> +# API is not finalized
> +no-export-headers += linux/user_events.h

