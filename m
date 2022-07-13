Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC2C5735FA
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiGMMHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiGMMHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:07:23 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3E41034F8;
        Wed, 13 Jul 2022 05:07:22 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8DE1AC022; Wed, 13 Jul 2022 14:07:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657714040; bh=GRD1T0eSpe8mmrBIO5ShPSs/U27oLpkzr10zWXsJ+78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cTViMyUNpB9DifHbqKo2DtbVueNEeoRefSCzGlFBlgi5ty911CTceluyfPl2ZtDbW
         +9lsc8qOYpg/Q7Qn5uPU63QakbFS9/UvNKwxeUmiNPyVcMCy94CV0uVAAQYSNVqyQM
         99uTYtXl8oPM0jntkRFq2PUYJD+Hy8ORFkBpMl2LpSk8owd0eXLp87ZWs/APZ+QVPs
         HaXCOMFkcNGc167UisDrgmTm/E0aJPIT/b3Qhc+yNuWpPb/3i4rgafKDAyG3xGYFTH
         /+GI0OdNeuEtfc/jAZAau56pK+Q1VvGyPNSZfQggpJtpeJ5XLn9ViNqikFYAIvSMwH
         R9/ccp+FilKNg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 92090C009;
        Wed, 13 Jul 2022 14:07:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657714039; bh=GRD1T0eSpe8mmrBIO5ShPSs/U27oLpkzr10zWXsJ+78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7wBfXDU4LL6fkHO2Y/bKgOTIstCZYW3ar1SItDrbH0/DK7hZKUIfvYTP9/MmR6AN
         vtr5C9qJgMl2BrLUJDpIa11+nGtpbKtYr3XCcNispy9DJzWMkfgHUmvFYG1QdrzhMu
         t7VmQJ+zV4loHxBHDc70tAAhuJklntTIrDvTOuJciBd078C1GqQRgLUfK+/UzOcbIv
         nW/WaWCDLNKt2vwpWYgotIY1J4qc4dABKjTpi7W5y3ecWwh354CTR53KvHllo5Q1gJ
         w537AfmQBcXbyBmwzU4dEE4vrZjyWd7W6x1xX1poq4TU62h7gia1shFKOqIa6E2Sq8
         E+ip89lsY422A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 6ead7bcb;
        Wed, 13 Jul 2022 12:07:08 +0000 (UTC)
Date:   Wed, 13 Jul 2022 21:06:53 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v6 21/23] samples/bpf: add new hid_mouse example
Message-ID: <Ys61XcZL4Fh/VQu1@codewreck.org>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-22-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712145850.599666-22-benjamin.tissoires@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Tissoires wrote on Tue, Jul 12, 2022 at 04:58:48PM +0200:
> diff --git a/samples/bpf/hid_mouse.c b/samples/bpf/hid_mouse.c
> new file mode 100644
> index 000000000000..f6e5f09026eb
> --- /dev/null
> +++ b/samples/bpf/hid_mouse.c
> @@ -0,0 +1,150 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Benjamin Tissoires
> + */
> +
> +/* not sure why but this doesn't get preoperly imported */

typo: properly

> +#define __must_check

But more usefully, I don't think it should be needed -- we don't use
__must_check at all in uapi includes; if this is needed that means some
of the include here uses the kernel internal includes and that shouldn't
be needed as they're not normally installed.

Didn't actually try to see but taking the compilation line that fails
and running it with -E will probably show where that must_check comes
from

--
Dominique Martinet | Asmadeus,
just passing by
