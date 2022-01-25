Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A932F49AE3C
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451518AbiAYIjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378799AbiAYIhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:37:01 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76574C0619C4;
        Mon, 24 Jan 2022 23:12:14 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id x3so1337320ilm.3;
        Mon, 24 Jan 2022 23:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Wr6MBiDCqaag82bO8+vycX38s7bu91IDkhXZbPknFdc=;
        b=hq4kgi9ZgN2z8RzzdyYHL1f8FVzmY6gQ5uAvQiq2Inh2o4tkZpKN9P73Wn4F7NBB7x
         gUJ5+io+Lkx7+radIsa+GQp+l47r6a0JAsCejA5WMvQ14VFeUrrLOVmY6f/ACU98650t
         7uD4R4n1KERqw/RfKCzn8eZzCm9pFCUQBZRpYQSU2Fjq+CfA1ghU2nbp1lMGStn3UruC
         eQIpLrvaXB9nz82fq9IIC1hGwsKQG2qqjI26irrgqhuo7Rh7hnJC7SovHZjgw6Yw88ZI
         Ye4+bZJXjNz7TgH3DCWe7UMOryaRrA53jcFgvNi1mtqhi3W3/evGrWPibF2RjSr6CYyz
         YpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Wr6MBiDCqaag82bO8+vycX38s7bu91IDkhXZbPknFdc=;
        b=PCRGcnB0ZEVGH6sj6beVzYOkiuEDS89IzytnsEzpklRYnyLOoiFzw96BMAx1WQsNA8
         P/vOXmcd3p+IWrSrZ2fUbjr2LThrpXOevhwX1nkQtNUwPSB4ZlzNGdWP7VWgGwnwg7Ls
         3l3hSzNB/8N7Tz6y9dsao0L2VgtJXm+Pv4qfujRXQeBMP9GOJKACbCwWb8tc0v9bOvbf
         LhbuntTUXSVVbm0Ga4rxD/fi4KbtS9008xgzfsqmnkQ0dvL/5zRh/nC0b2f6BqkKyBN8
         28RpjebzUNKhxmbxZYFrStXYpYUHspCEy2ZK12xjcwrt+CCq4P95xmeLGkiIGy8WFyDF
         zG5A==
X-Gm-Message-State: AOAM530NRKNFuvTlnj4jzTsOmcrTLtTPg6H0UTD82UYdlWOK/JsfqOFw
        9/+fu0N71P3oV5fB9cwiYoQEomGjmiBumA==
X-Google-Smtp-Source: ABdhPJzIqkUlHv1G/SCFnY20v7/cB/6l6e6kwMzyI3WBGtcg7hYSVlbQ4BA9oDQaaKMvVdKsXBK9ZQ==
X-Received: by 2002:a05:6e02:1b82:: with SMTP id h2mr10086709ili.116.1643094733907;
        Mon, 24 Jan 2022 23:12:13 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id y6sm8800111ilv.6.2022.01.24.23.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 23:12:13 -0800 (PST)
Date:   Mon, 24 Jan 2022 23:12:07 -0800
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
Message-ID: <61efa2c79c9b8_274ca208ca@john.notmuch>
In-Reply-To: <20220124151146.376446-1-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
Subject: RE: [PATCH bpf v2 0/4] Bugfixes for syncookie BPF helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> This series contains generic bugfixes for the syncookie BPF helpers. It
> used to be part of series [1], but has been separated to apply to the
> bpf branch as fixes.

2/4 looks like the only real fix here. I think it would be more effective
to push 2/4 with a selftest and get that out of the way. The others are
nice but could go via bpf-next imo and 3/4 can likely be dropped imo. 

Thanks for the fix.
John
