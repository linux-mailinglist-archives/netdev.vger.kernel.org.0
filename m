Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033EE4ED146
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 03:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352289AbiCaBYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 21:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiCaBYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 21:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DB12E9C4;
        Wed, 30 Mar 2022 18:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F216191D;
        Thu, 31 Mar 2022 01:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F382C340F0;
        Thu, 31 Mar 2022 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648689778;
        bh=NWJILtetxPEKc8/hlIa004NMQJu2a/09BnjLlYqqPg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TyE9YM8MKt+M9uNRj+xDC1911Vd7uLDQyOJTzDhJxYSeWbYABBlwTTn6Se5xFhxxf
         XaOU6ancOjgWR7UeOYLsbm95v+lrz1Z6LvpF44is7BXZGQdQYsoRDfKDeB1bNepQiS
         z8mt2pz7CVUZ1KJQqUjFxihCtq5ckqzE+f9mu9UF2xdIwOLVvx9owww3cMPjeXfDPH
         pzGgGhi0aP5d4aUVAZTDQkC9WkrO96fJm0NROoLjYK5iq1l2glisJxf4O7AVIfryUJ
         MQRCjbXgVzGvvk99R3VlsnxcueZqIwh1075rCrvbm965BcXqMP/W6BiouOInJs66eV
         7w5S/hkUI16Ow==
Date:   Thu, 31 Mar 2022 10:22:53 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tracing: do not export user_events uapi
Message-Id: <20220331102253.8793580dbc02c93dd897e52a@kernel.org>
In-Reply-To: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
References: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

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
> -- 
> 2.20.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
