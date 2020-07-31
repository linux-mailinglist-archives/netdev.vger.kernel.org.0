Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0EC234D5C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgGaVzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGaVzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:55:13 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A708AC061574;
        Fri, 31 Jul 2020 14:55:13 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k23so33045385iom.10;
        Fri, 31 Jul 2020 14:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OySZ5jd2AWLJGW3T8Zhfl3bGRPBRC3R+XzOwEtfX2Rk=;
        b=cMtogEO1rv91QrA4u26UALUV2VBSS6kGyfgryNLVLLpI7LxpEUOL1lQIyz6EZDrcTd
         OnKBsApnK48bzenecse5Sb4GPNLHx086PWZD7dBFaU4T5z4cJq2aDCnxQ8fkyLaq1bD2
         NMd8gEzWEL6CqeHd6Fch0lkRaeclTGAYq2IRG8LA39MJi1hQjpkf+jMVnOl3X3/0Glhm
         bcimx51gH/Tqpr8hkB6MX7aH259xwfIzvPCdmCL6Fljd0EYMr63s0rcWfCvaQbobPfKY
         WFjRmZuQaGca4LY7gm7Fcre2go7x25qN0rL58IBwkceZEW1hWOMiT3FXQu5rpbIGKARB
         Cb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OySZ5jd2AWLJGW3T8Zhfl3bGRPBRC3R+XzOwEtfX2Rk=;
        b=YOgypE0UL5VPtoiEcCRUVI6p6Uu1LpRaXkuewTmhFn0uZGUU0mBQ+3hI/O3FtTSy83
         9eQUNRb62CZMMZzhpp28PLKZB38xyQhBgVgYBnyTfaiMCGHJ89CRAwdOte5vn1rwB+yL
         C6G+VSyxc5UtAOGeMWtXh0DmnuF8mAG461knCosXmLFqUGEP2UFmRIrFnixxG2a/jtI/
         ITDGWjcacX9DxvvvDt3wPTt0oYviY9cWnv3JQKoxJ6zVRMA+PH0gaOOuvB591fbESPZT
         HQuAA8JE8fK66tj4ob4Qh5KdqUzB9+4uY/UY0w6+OioMRkEzsXYUwQ+OPxwQOq5QelAk
         yWhg==
X-Gm-Message-State: AOAM531kS+nq0Tuh2U8l1bXkIG4QmrqC0RcgI3zMWYDHn7MxEX8fdJa4
        HLp9V1Egwdj/1aQ/PiqWg8s=
X-Google-Smtp-Source: ABdhPJz849kS65fAEjJ6I90NWE7pYQBL+xFDaFadqnRbzI3vVJ5ZKopqQ0yxDIHyTaXY/Z2gEMMAtQ==
X-Received: by 2002:a6b:7416:: with SMTP id s22mr5499573iog.160.1596232512627;
        Fri, 31 Jul 2020 14:55:12 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m184sm5176199ioa.12.2020.07.31.14.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 14:55:12 -0700 (PDT)
Date:   Fri, 31 Jul 2020 14:55:03 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5f2493377c396_54fa2b1d9fe285b478@john-XPS-13-9370.notmuch>
In-Reply-To: <20200731204957.2047119-1-andriin@fb.com>
References: <20200731204957.2047119-1-andriin@fb.com>
Subject: RE: [PATCH bpf-next] selftests/bpf: fix spurious test failures in
 core_retro selftest
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> core_retro selftest uses BPF program that's triggered on sys_enter
> system-wide, but has no protection from some unrelated process doing syscall
> while selftest is running. This leads to occasional test failures with
> unexpected PIDs being returned. Fix that by filtering out all processes that
> are not test_progs process.
> 
> Fixes: fcda189a5133 ("selftests/bpf: Add test relying only on CO-RE and no recent kernel features")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
