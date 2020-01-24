Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2F3148EC9
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392245AbgAXToH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:44:07 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55507 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390664AbgAXToG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:44:06 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so257286pjz.5;
        Fri, 24 Jan 2020 11:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=raVWSvS9XFHbPPEUPPq10mdG0WqVl1OCni/0Sjj02+I=;
        b=otjafZ5/VEduhylPUceHLNPCA26p0zakAAG+Jm8wG22jex4RiPcjbb7HvguOiHw1PT
         nJ+GU4qSA11OQw7nOp5ldLkmpRskL0OgZV4WOWUQM/U106bqb2xhqzYbbbk/PJavauqD
         /Xm6jnE8H7TOE4UTns7QJJyKwi58MjzWpJUWqjSr1/nptoGpGzABpRdgqWiSwh1EgoIq
         A1Ng/zKlgYPxhd2UZ7WtfFJv/+hYVpzJph1XpArtNFkDTVySdioMxA2rZMv9/kMuaGQy
         0h75uGvX2F3qhDjfgSAMx2R1RBhqG7W717ZhUJ9Q3mBtmlc9OH1UMd3p4op9wkq7T21p
         itiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=raVWSvS9XFHbPPEUPPq10mdG0WqVl1OCni/0Sjj02+I=;
        b=I4m7MA/sb5kwxrqyVPGUdsCbm0p1woc1cFEINHY+hgz4VcpcTM/RhuL2HZs6Cyf5Y4
         JErLDfE/c9FTboo7SPKkG/B4HlUnau5zDn1vzIcJWslp4t0zmXDUZyXNv+qXrFtOcvrQ
         rQSlmQtwNyzJZhdaDmkuR362IticGKLJX/gOEGnWfbnzR9OhKSrwUCTRorZL7fuad0TJ
         GB8S6mC73jzI7Shpcs38O9x+sTmrivjHxL5/CUWqxG0CrPZ6rFF8nrLhfF0oMNe1exFb
         ktrXcjmLchq1W911ao4b2u1Q3ApAjrZ11WXwAObxc5n103X4RDuIxm9sc4DZhuG1p5Ar
         4yQQ==
X-Gm-Message-State: APjAAAXGEFs9kkQiyss/I3WKzUADm3Qu2zzPySTzpzc/A4V6PYr+Px6z
        3VPE9WgxCHUSGzRXapdQLFg=
X-Google-Smtp-Source: APXvYqwXFZrODteEJ/PTPSR4e4qIlOJx6rbQxDoYgmvjh/h89tdZD6pQ/yDsE8mIeQfb4qqiOMrCxg==
X-Received: by 2002:a17:902:bc85:: with SMTP id bb5mr5119218plb.208.1579895046013;
        Fri, 24 Jan 2020 11:44:06 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m3sm7091461pfh.116.2020.01.24.11.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 11:44:05 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:43:57 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5e2b48fd34d98_551b2aaf5fbda5b834@john-XPS-13-9370.notmuch>
In-Reply-To: <20200123165934.9584-2-lmb@cloudflare.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-2-lmb@cloudflare.com>
Subject: RE: [PATCH bpf 1/4] selftests: bpf: use a temporary file in
 test_sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Use a proper temporary file for sendpage tests. This means that running
> the tests doesn't clutter the working directory, and allows running the
> test on read-only filesystems.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  tools/testing/selftests/bpf/test_sockmap.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 

Agree nice bit of cleanup. We should merge this in bpf-next though
considering its late in the bpf tree.

Acked-by: John Fastabend <john.fastabend@gmail.com>
