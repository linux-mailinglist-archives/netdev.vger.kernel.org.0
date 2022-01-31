Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3934A50A2
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 21:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350960AbiAaUzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 15:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344276AbiAaUzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 15:55:35 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26726C061714;
        Mon, 31 Jan 2022 12:55:35 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id w7so18620287ioj.5;
        Mon, 31 Jan 2022 12:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5kNmkiY95htMxis87BZj4aB+Vg+dJl3ZdaQFip6DWEQ=;
        b=pN/17mPsuJOyEEdSt0X/vJqjI6tKLG3hYissQTLdEDU6j/KIS8GTwE37f3c+EbReXX
         vYGV2bFvnJ4Pzb4OyxXcGYHyI0FUb72u0AS9/Qs2Bubo1uc1fnaLrEU54hZNF+MQJKzj
         ZAAb0aD6ATWCj72yPIJsPoFO89t8yWHSGOpW9VlfImiB7fjgJslOYxr7F8O29GNJi7cd
         cu3P3XmxteySIcZiinUadkLcGbNJO5aR++C5hg3IfrTYhs4TLrGjaFl49rqjsme1NOpt
         49ZcafCflw8gPyEdNYMs+DmVrfumfnfICAw4xRqf2NjTIgblyLfOaom2DhOWiLZqQh8h
         bXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5kNmkiY95htMxis87BZj4aB+Vg+dJl3ZdaQFip6DWEQ=;
        b=hsIccTtRp2yt2FLgfUG2O3u6FACemH/jLSKknRsSOgM+kV1uCDr0xLiCQsN/EAZf7/
         d+M9bHB+nZ2PaVcLD7N5VfdAWl3lnuxskCg4pQ+8oQSi/nli6eJ6eutg99bnJSo0DbwS
         lPyXLGPYR9dC+KCiWE/JiR6eWbr1TjSXIDtrFUSnnpyZa8LzXj3T/ikkXZLJnSJ1XyLB
         woiqEJ/4Ej4yki5HySp2FnWMyxCj0UcwZtw/zWCN8R0KVgJ20uWitROjNk+mO3sgfVDK
         X4BQhTBr93u7YRVrkf80VEXW4HOolzmnkLAXvd27lOFfNOpU1yB8TUJ3rbLf3Tea0ntn
         zing==
X-Gm-Message-State: AOAM533mMMjNqHY6G/gedlj5JVOHwnVUCO9DtMAIuA2Bt/S/05JA+7as
        WY8BWTelcIKEujFpA797EhU=
X-Google-Smtp-Source: ABdhPJxV2bsZwcY6SKPRlm+e7F28/YQMTs0Cbp4THTPtNTXW7jrxXM9W7wmeWVqRoPAKLdeQlRoAYA==
X-Received: by 2002:a5e:a906:: with SMTP id c6mr11848811iod.117.1643662534557;
        Mon, 31 Jan 2022 12:55:34 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id x11sm9325508iow.8.2022.01.31.12.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 12:55:34 -0800 (PST)
Date:   Mon, 31 Jan 2022 12:55:25 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Message-ID: <61f84cbddf60a_859720818@john.notmuch>
In-Reply-To: <fefefc43-1912-c1e5-7f50-76f5f68f9386@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-4-maximmi@nvidia.com>
 <61efa17548a0_274ca2089c@john.notmuch>
 <fefefc43-1912-c1e5-7f50-76f5f68f9386@nvidia.com>
Subject: Re: [PATCH bpf v2 3/4] bpf: Use EOPNOTSUPP in bpf_tcp_check_syncookie
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> On 2022-01-25 09:06, John Fastabend wrote:
> > Maxim Mikityanskiy wrote:
> >> When CONFIG_SYN_COOKIES is off, bpf_tcp_check_syncookie returns
> >> ENOTSUPP. It's a non-standard and deprecated code. The related function
> >> bpf_tcp_gen_syncookie and most of the other functions use EOPNOTSUPP if
> >> some feature is not available. This patch changes ENOTSUPP to EOPNOTSUPP
> >> in bpf_tcp_check_syncookie.
> >>
> >> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> >> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > 
> > This came up in another thread? Or was it the same and we lost the context
> > in the commit msg. Either way I don't think we should start one-off
> > changing these user facing error codes. Its not the only spot we do this
> > and its been this way for sometime.
> > 
> > Is it causing a real problem?
> 
> I'm not aware of anyone complaining about it. It's just a cleanup to use 
> the proper error code, since ENOTSUPP is a non-standard one (used in 
> NFS?), for example, strerror() returns "Unknown error 524" instead of 
> "Operation not supported".
> 
> Source: Documentation/dev-tools/checkpatch.rst:

iirc we didn't change the other ones so I see no reason to change this. Its
not great, but anything using it has already figured it out and it is
user facing.
