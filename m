Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544A04E35CD
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbiCVAyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiCVAyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:54:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD8635A83;
        Mon, 21 Mar 2022 17:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7FFEB818E8;
        Tue, 22 Mar 2022 00:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02F2C340E8;
        Tue, 22 Mar 2022 00:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647910400;
        bh=co2AhEZBjrG0YC8cOCHbNUYbB/sH2wrgeISR4+AdtrY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=owNgB45nvPnEVhNdk6DfAYDry+J5nUgh9BueEj/WtSG16MFT1Yc+ni1nd5/H8lYCk
         w9O2DbXO84otWrSv6bSVgF0xoatXaqLPFgGaUphCSUO1onSe888tK7HfFY+sWb7DEv
         7XPNOWnyiapwcWSguHqFt6oAm9W7XWWcb6X7tEC6xEKNQCXwClLHgsLwMHoRMWmxlu
         lgnYLWuXnx3IN8Nu8MJS4R7fC859s+nlwA13pmWb/JkPzv0HRD39533HhkYTMBwRAi
         M6Ayd1SyQsy6LiyS52mY5iWGYVMm+E5t4lRIFvjUGW1RmchtNDkhxe+UPnPBDSUBLv
         gygesIdSdx06w==
Date:   Tue, 22 Mar 2022 09:53:15 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next 0/2] bpf: Fix kprobe_multi return probe
 backtrace
Message-Id: <20220322095315.3753d18ef8b3dfb69e0a995d@kernel.org>
In-Reply-To: <20220321070113.1449167-1-jolsa@kernel.org>
References: <20220321070113.1449167-1-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 08:01:11 +0100
Jiri Olsa <jolsa@kernel.org> wrote:

> hi,
> Andrii reported that backtraces from kprobe_multi program attached
> as return probes are not complete and showing just initial entry [1].
> 
> Sending the fix together with bpf_get_func_ip inline revert, which is
> no longer suitable.

OK, this series looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> 
> thanks,
> jirka
> 
> 
> ---
> [1] https://lore.kernel.org/bpf/CAEf4BzZDDqK24rSKwXNp7XL3ErGD4bZa1M6c_c4EvDSt3jrZcg@mail.gmail.com/T/#m8d1301c0ea0892ddf9dc6fba57a57b8cf11b8c51
> 
> Jiri Olsa (2):
>       Revert "bpf: Add support to inline bpf_get_func_ip helper on x86"
>       bpf: Fix kprobe_multi return probe backtrace
> 
>  kernel/bpf/verifier.c    | 21 +--------------------
>  kernel/trace/bpf_trace.c | 68 +++++++++++++++++++++++++++++++++++++-------------------------------
>  2 files changed, 38 insertions(+), 51 deletions(-)


-- 
Masami Hiramatsu <mhiramat@kernel.org>
