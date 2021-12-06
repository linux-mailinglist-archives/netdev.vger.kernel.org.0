Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5DB46A586
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348382AbhLFTXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348367AbhLFTW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:22:58 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7805AC061746;
        Mon,  6 Dec 2021 11:19:27 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id j21so11334840ila.5;
        Mon, 06 Dec 2021 11:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZaQxkKeJd0tXRMJEXWjgYG+9FDOgizwyR3HGi44/I6g=;
        b=n+sV/7qyhiOLFy/wNxZrmNJ1NW4dpFZ8sbYd0477/KDRP5kOexpEBYb1h5Ozy30Dmy
         1j17V4GAcrEqi/R28mkdJ5pMKu0lym8IKru7UMFJ39yvaMKfc7yrD1t9k4FcxoIzLB0D
         78He4lcX6cp9Pf5iHf82Cp/vWyEBW7nl8zbnW+rxdNNQeRz/WS6lOHyUIAXGj6cUadcR
         s/E0PrLTtT8sHexoJsOqgmfCt/lQ+EIbg3CU/EYjJpCNVAww4PZqBc7bkOSaKMUCnMVE
         sR/ntBQlwRamgrQJsFEdMsJhC9havc6HY42a0W2zfHtJG3SAoFWvntlFZy7IzXSJ7B1g
         iEEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZaQxkKeJd0tXRMJEXWjgYG+9FDOgizwyR3HGi44/I6g=;
        b=EBch7l0FoxG+6DbAE2XfOh7aAj0j8vuEKjo3FGb4HDH7Yg3NT+R7hCsk984xQbnDJm
         r1s9kKszbMBQnKe7rFgSRv0Q6vdJzkJZzWdxU1QYZL5DgXKuxG2LGQv36c7MppBGNCBZ
         25hjV0IWAJlSE3qYN5VzxvpPGfdfTWL+8BRuT759gSnCeEnCHzqQrToI1jonm45ZfDAU
         kYPZnNLzArY59cEKNE8saMiuWi7F98Z+f3Bi4eQHOB1KZxi2FXZreEvXG0F3Y1Qa7qjO
         FoJexHtXvd2p2pqoyz+sKVUJeLV+aqUv9lKGOPlJslPUiN6nP+9nV8WVbo4UtcZZehzi
         51UQ==
X-Gm-Message-State: AOAM5302IheQrAcNeFjvL/JNTkpl+nQnw/CaeQ4ur4BrdpfUzJP9qads
        VqGlk5djZyWns4m3Cjgr70Q=
X-Google-Smtp-Source: ABdhPJzlKlBNkrmjgf80NaSvg79RxA5c5VyskcoaYe9zXM5JlI6rJCa8LS95DMXftg6nF5Zt0s6hew==
X-Received: by 2002:a05:6e02:1baa:: with SMTP id n10mr30728331ili.117.1638818366932;
        Mon, 06 Dec 2021 11:19:26 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id 10sm8455412ilx.42.2021.12.06.11.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:19:26 -0800 (PST)
Date:   Mon, 06 Dec 2021 11:19:18 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Message-ID: <61ae6236ded56_c5bd208df@john.notmuch>
In-Reply-To: <20211204140700.396138-2-jolsa@kernel.org>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-2-jolsa@kernel.org>
Subject: RE: [PATCH bpf-next 1/3] bpf, x64: Replace some stack_size usage with
 offset variables
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> As suggested by Andrii, adding variables for registers and ip
> address offsets, which makes the code more clear, rather than
> abusing single stack_size variable for everything.
> 
> Also describing the stack layout in the comment.
> 
> There is no function change.
> 
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
