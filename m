Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FB31BD403
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgD2FeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725861AbgD2FeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:34:03 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BE0C03C1AC;
        Tue, 28 Apr 2020 22:34:01 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c18so1261371ile.5;
        Tue, 28 Apr 2020 22:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=bgRz59ciuPjOtf0UcSjUKXVGufJvLgyAs3Hw1se2dMQ=;
        b=hanGqn5k42N0otY5UJThabd1GHwwsgQ4X09iu3WXq2KV1uRZJG6jxKVqkSLOzeiD65
         7FldGosVDCaqgVRNpFqSXyp+fRxwr9mfuv1b9EiDT05HmiN7YBvfGbJqrxQFbDGUvCcd
         1G83tSjqFKYwe2fBxMFP9b+ZJ2DDEmJrMlf2vlY4KStexsF0dE3ws4TZDeQb51Gm9Cav
         alzXxsoJ0UGRBm2hvO9ZMmzNCJAHyB+Lhg19z9i3U1qlokj9MliGPSihVHUjoJEwZ3/q
         i0U3NmDgYwn99HSaceGaYbaJ9YHy90GFWWfKg2GVKGkF0tEXRgjCp/4Qeo0x8DKOn73I
         fM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=bgRz59ciuPjOtf0UcSjUKXVGufJvLgyAs3Hw1se2dMQ=;
        b=CTtPXnE5cTWIFhf5qkocPO9bD8djlZon7yW1xAyUDqBGIVj4RiGIexklglHX8JIYPG
         gSMtKqI9BL4A5v9KJSe7R0AHhTCqhkZ3XYSqaRlKhJDtwZfMN9PGzd57kxlnTnCsailB
         45sDyn9Jor1rPXnedsdmrs5UEG7hHb9ykuc8vU8nFvAo6eDtrGxAlKMaVTG7QgXEWaIH
         F+GgfBRqqJpsVWaGMiFJmFPdJSFEpNzW0qxhumwaDvNpyPFYi4UFwS3o9wZ1tt8rsS2+
         /LN0JtCGtk3eZAgK/5UeAhrRnSXRgz+M4GMHO2g1NzzprsxMagzZuMsyvi0loO0luGTJ
         Jzaw==
X-Gm-Message-State: AGi0Puawy/s7n00hER3/AhJrrvNU2J+A+3I8+KXZUJdw6vURp+8qUZNV
        tVzvRF8xspvjXLw2up1Wh+8=
X-Google-Smtp-Source: APiQypL81X+5w8zj+RLK5mlG9KyWdsENQStYJ/RFVg/lpForslGY641y5/sRb/Ynjcpt3pakhyDd+g==
X-Received: by 2002:a05:6e02:60f:: with SMTP id t15mr31093285ils.241.1588138441149;
        Tue, 28 Apr 2020 22:34:01 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r14sm538321ilq.11.2020.04.28.22.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 22:34:00 -0700 (PDT)
Date:   Tue, 28 Apr 2020 22:33:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Message-ID: <5ea911c2ecf72_37572ac97b86c5bcf9@john-XPS-13-9370.notmuch>
In-Reply-To: <20200428185719.46815-1-sdf@google.com>
References: <20200428185719.46815-1-sdf@google.com>
Subject: RE: [PATCH bpf-next] bpf: bpf_{g,s}etsockopt for struct bpf_sock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
> 'struct bpf_sock_ops' context in BPF_PROG_TYPE_CGROUP_SOCKOPT program.
> Let's generalize them and make the first argument be 'struct bpf_sock'.
> That way, in the future, we can allow those helpers in more places.
> 
> BPF_PROG_TYPE_CGROUP_SOCKOPT still has the existing helpers that operate
> on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
> on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_CGROUP_SOCKOPT,
> we can enable them both and teach verifier to pick the right one
> based on the context (bpf_sock_ops vs bpf_sock).]
> 
> As an example, let's allow those 'struct bpf_sock' based helpers to
> be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
> we can override CC before the connection is made.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
