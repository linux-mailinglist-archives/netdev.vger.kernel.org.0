Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2124C49AE37
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378909AbiAYIiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450992AbiAYIe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:34:57 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E04C061797;
        Mon, 24 Jan 2022 23:09:19 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id h30so16014482ila.12;
        Mon, 24 Jan 2022 23:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZE2YFUru8FR40UTsaSGVu70UsGKWyzv/vsfS5wBE5n8=;
        b=OymIyE3/6kDdKlZpeNtY4OqtMwyEmsh8/OauNsCCR98rVaeP7CnDU2JL/KZgU97Tpa
         9frENrCsYcBgbc1XPqDH5rY25YpD5+PUDJqfM3xQNR/mgE+DAZo4Ckm+nQKnvjZ4xadk
         T4d4AaAEJyPRXivAHjB4O7pZzFnoPw3CfvEXlB3zozLhExdK988hfNmdVcnXnIxKUhuk
         0/3Y+PJ3b3DlVMfzvXsfT+6d99GRCIwqTt2VfPsWOqNSd/KidAc1pGVtVJdOtXou5BYW
         dQ8av+/YMT5KvJzxw0HW6MuB+/QCfe+2NQKOIuM1DIZsfxlnJrwnlF1Z+bGH3X94m4LB
         Sq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZE2YFUru8FR40UTsaSGVu70UsGKWyzv/vsfS5wBE5n8=;
        b=PQXiPazmreV06z8tE1Lz8vzi15SV9eZQKOaRF0eCA8Fq9894amh+uSJ0jpw0D31alp
         2Y6ioc21wqCcwea6XMLNhsV/Uir2dhclYLuzYgNvSvfSUAmMd6AgLueVKiW0J0ff6wxh
         NB4LgvuYB8Jzo9m5MOKBbXXUYDafu3DH6v+9Cg3VZiOjpKFvR56rcHx4oMtbraDrAiQW
         JpUamJZgui2FHjD0R5Pkq47wmsni/QVDRNMjlYkjalTamnTVz5NiO/UMvUTJ9A/0+d3a
         prWOgXrlEE4P2BGDAptbdUmKatxmtR5kPLWby+8bG/vYPWCdLp8cpTuZHOxeTkP5ACzN
         Q/1w==
X-Gm-Message-State: AOAM530tYofWIoJ5GSOYXCIa381lcQChKP6T31UbUgvoHodHg1gDtjdl
        XvMTFIfc9yH+Lk42qSz4mSw=
X-Google-Smtp-Source: ABdhPJyeZplFmcrnv2J7MTtptkHFSzaLHMGGCDk70YMsi710Dx1be9AmNMaoUDNVSvzzvBgskqhz5Q==
X-Received: by 2002:a05:6e02:19c8:: with SMTP id r8mr11481044ill.136.1643094559007;
        Mon, 24 Jan 2022 23:09:19 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id ay35sm1534392iob.3.2022.01.24.23.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 23:09:18 -0800 (PST)
Date:   Mon, 24 Jan 2022 23:09:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <61efa217db564_274ca2089e@john.notmuch>
In-Reply-To: <20220124151146.376446-5-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-5-maximmi@nvidia.com>
Subject: RE: [PATCH bpf v2 4/4] bpf: Fix documentation of th_len in
 bpf_tcp_{gen,check}_syncookie
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie expect the full length
> of the TCP header (with all extensions). Fix the documentation that says
> it should be sizeof(struct tcphdr).
> 
> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Not sure I would push doc fixes at bpf tree, would be fine to go
through bpf-next. But change looks good.

Acked-by: John Fastabend <john.fastabend@gmail.com>
