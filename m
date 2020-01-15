Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6C13CDAF
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgAOUFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:05:20 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41560 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgAOUFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:05:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so8696907pgk.8;
        Wed, 15 Jan 2020 12:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X1IZlivdX/mCNwgQDENbVrwYXLpQ+1bryukdx2Xrtac=;
        b=G7XbQwBF1/+WT/zbjLvycKfQNBq9wIRpJlvQs/QDIvxrI5R2rVKZLigKe9HwFI6dN1
         Y/kI+NuMjCPtyRMwdHindWoumFR5jx5w1IsLJYvreN3zulSTvY9UAQCg+Qlany9+Ld4u
         TzuTxNMPHKrI3r0uU5UNzKNrs5soBto5MrKFhN1NOF69Y1ppFuNudAY032Ucvs/b6BMH
         yOVbRKyRvxPgfb7EwPSAeRTZdAJnm4601jHe9OSSAGaJYzkoZc/hFSC/ru8eujXHqY6b
         0kUd6RsE8B3mxCF9lLMGP5FYrFyKtroO79gWPbUsaOoeAIjdEx5iYgFs+W10lptIqV99
         i6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X1IZlivdX/mCNwgQDENbVrwYXLpQ+1bryukdx2Xrtac=;
        b=MzPMGVS2m3EvdFiHtNhcrsjfozBRloJLec8hw0EDXQRqC+kDYa9Cstr4g89YQrFvkj
         XNMSSxFgNkZ9LQeQqTQkMCw9C6nUM/wnmJ/eQ6VPd5lXzQXwaiLBUTUIQoftviQPjyL0
         Yd6r9KXFbpQ1Q1lD0Ut01n/N0ELBmA/rGlUl2opmHnsDu63fCh12g60FPXQ4bwxoKgv/
         PXxgCzDH6txPKr29WCddGwEbp5merXBba89OsvnpT4SKYfVRU1vaZUnLCIEeR8W8E4Wx
         7ANY3d6ML71r3zAazBbSmUAO0hLq74+I2uWvPcGhiB1AOmYJ8psilPsC98+hRwTwiw5S
         qoUw==
X-Gm-Message-State: APjAAAWwaGWn3aL0t7bT1r6AF29DZze/57TEq8oe7eyVIjhstv1b0vYU
        bSLtJ/BSONAqtEFsudZy5G0=
X-Google-Smtp-Source: APXvYqzG1jYXB7cjU3XfgWKiDwdoShKf+zC5HaLQtk2KzXzo0TpPDz+s1PXPuA6BJRsMY9uWt5v2bA==
X-Received: by 2002:a63:1f5c:: with SMTP id q28mr32668207pgm.404.1579118719347;
        Wed, 15 Jan 2020 12:05:19 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:e760])
        by smtp.gmail.com with ESMTPSA id a28sm22832924pfh.119.2020.01.15.12.05.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 12:05:18 -0800 (PST)
Date:   Wed, 15 Jan 2020 12:05:17 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH v2 bpf-next] libbpf: support .text sub-calls relocations
Message-ID: <20200115200516.aqfdmzrszevirsfx@ast-mbp.dhcp.thefacebook.com>
References: <20200115190856.2391325-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115190856.2391325-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 11:08:56AM -0800, Andrii Nakryiko wrote:
> The LLVM patch https://reviews.llvm.org/D72197 makes LLVM emit function call
> relocations within the same section. This includes a default .text section,
> which contains any BPF sub-programs. This wasn't the case before and so libbpf
> was able to get a way with slightly simpler handling of subprogram call
> relocations.
> 
> This patch adds support for .text section relocations. It needs to ensure
> correct order of relocations, so does two passes:
> - first, relocate .text instructions, if there are any relocations in it;
> - then process all the other programs and copy over patched .text instructions
> for all sub-program calls.
> 
> v1->v2:
> - break early once .text program is processed.
> 
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Tested with the latest llvm trunk (which points to version 11 already)
and all tests pass.
Applied. Thanks
