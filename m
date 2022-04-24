Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F250D023
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 08:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbiDXHCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 03:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiDXHCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 03:02:00 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF70E1A61E4;
        Sat, 23 Apr 2022 23:59:00 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 9C2E7C01C; Sun, 24 Apr 2022 08:58:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650783537; bh=d1VjK1xtkmP9URRCXEubGmmd5y56XLQCRFwZdbrT84s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2EEFaDHKB74Y41gspMjN58AfcMH0nOu581BoBWpuRMtCruEUbfUBzJ667erlgE77y
         OfpaY0jpdZlOUM+sYPdaUx4oY+QnXWN/Cfir8QJUNb1NGMZ2ZNZcvZkizEHHz4X3uw
         qybPYksS394xjitQHLWWvyILQsd64C+P3jv5d6kNJqd+yCHxPVgTY8YP5ZmHlw7sw/
         X/dobP2ssY70GowhEU3ip3N6ua5CAkaZA+OHngQ+mYXAvNPmKICkEhJGYiQER9akcI
         d+wkCTbPcEE52gOs5iN1ykpdBFj2V8TQ5/TGUH+Z+8gb2F3M8o8D9khmeMVjzR28Tj
         dq12z9n4x1t+Q==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id DC08BC009;
        Sun, 24 Apr 2022 08:58:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650783537; bh=d1VjK1xtkmP9URRCXEubGmmd5y56XLQCRFwZdbrT84s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2EEFaDHKB74Y41gspMjN58AfcMH0nOu581BoBWpuRMtCruEUbfUBzJ667erlgE77y
         OfpaY0jpdZlOUM+sYPdaUx4oY+QnXWN/Cfir8QJUNb1NGMZ2ZNZcvZkizEHHz4X3uw
         qybPYksS394xjitQHLWWvyILQsd64C+P3jv5d6kNJqd+yCHxPVgTY8YP5ZmHlw7sw/
         X/dobP2ssY70GowhEU3ip3N6ua5CAkaZA+OHngQ+mYXAvNPmKICkEhJGYiQER9akcI
         d+wkCTbPcEE52gOs5iN1ykpdBFj2V8TQ5/TGUH+Z+8gb2F3M8o8D9khmeMVjzR28Tj
         dq12z9n4x1t+Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0fdac319;
        Sun, 24 Apr 2022 06:58:50 +0000 (UTC)
Date:   Sun, 24 Apr 2022 15:58:35 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 1/4] tools/bpf/runqslower: musl compat: explicitly link
 with libargp if found
Message-ID: <YmT1GxK1HimY2Os9@codewreck.org>
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
 <20220424051022.2619648-2-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220424051022.2619648-2-asmadeus@codewreck.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dominique Martinet wrote on Sun, Apr 24, 2022 at 02:10:19PM +0900:
> After having done this work I noticed runqslower is not actually
> installed, so ideally instead of all of this it'd make more sense to
> just not build it: would it make sense to take it out of the defaults
> build targets?
> I could just directly build the appropriate targets from tools/bpf
> directory with 'make bpftool bpf_dbg bpf_asm bpf_jit_disasm', but
> ideally I'd like to keep alpine's build script way of calling make from
> the tools parent directory, and 'make bpf' there is all or nothing.

Well, it turns out runqslower doesn't build if the current kernel or
vmlinux in tree don't have BTF enabled, so the current alpine builder
can't build it.

I've dropped this patch from my alpine MR[1] and built things directly
with make bpftool etc as suggested above, so my suggestion to make it
more easily buildable that way is probably the way to go?
[1] https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/33554


Thanks,
-- 
Dominique
