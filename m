Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6166514D7
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 22:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiLSV0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 16:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbiLSV0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 16:26:00 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581E713F4C
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 13:25:59 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s5so14753168edc.12
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 13:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=VBjJ79Li+19olF9JIBuSJx8A0CD1eF08+x5dB8eVY6M=;
        b=NXSGaaiFIZ/755l+85qbe9udZMDpo3XLxoqxstgsYE1uXgxwC27dSWIjHaM6ITKelF
         hCYO2WdHwHv32xuOgQMscezEyVxVso3lCNOrQGpH3QbaFFF1qW2gbw7UOyfM0Jy7eMdm
         irvDbOJKlsXaLQjVfqSq4t/yCHHAci+tTCy8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBjJ79Li+19olF9JIBuSJx8A0CD1eF08+x5dB8eVY6M=;
        b=JfWqUcix3MZe+x9yXg1MnlW2wOwFpJSTzwJ4aR/bLZKVNWZ05dYFV6U1kiSsncc85e
         J39tPT+Bzb2e9EQI4No6n96wmk/ZkbS/A3q8ZcXX41wkoHpjcGMpr75dpQVrBpuo2/Rk
         thXbFXyeURiNzB7qYaXJcuAW4fkbT5uF5aSNDZRbXs4e2DoOAQIMZiINoHxg7V8ipHkG
         FBl0i4sSAwAyUwnfrVOmrc+EILS4YN64SzxYbbWha/UGwJlzxrR2+WKb5Z/UlW+na0DG
         ZvghDDE9B5n215nEHFn9hX/ppfNijKeP8AMj79ZFKeS8E2eu3A+rp50IxAp2ahGTzjFB
         hK3Q==
X-Gm-Message-State: ANoB5pmxplUwpXzRl60csJmlADI8lhSK3k28V7E9p5IBq2v8Bap27xcX
        No050rjqm0C/RgJrAhAYDmW0Zg==
X-Google-Smtp-Source: AA0mqf49zRLsKvp2wA6Q+Eh8UxabGhvHGWP3sQu9x/ECwcseQqoo3DSWr9vdZOBlcV5YzEKskhpcPw==
X-Received: by 2002:a05:6402:12c9:b0:46c:55ef:8d50 with SMTP id k9-20020a05640212c900b0046c55ef8d50mr35881426edx.24.1671485157804;
        Mon, 19 Dec 2022 13:25:57 -0800 (PST)
Received: from cloudflare.com (79.184.201.14.ipv4.supernova.orange.pl. [79.184.201.14])
        by smtp.gmail.com with ESMTPSA id pw18-20020a17090720b200b007bd1ef2cccasm4733940ejb.48.2022.12.19.13.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 13:25:57 -0800 (PST)
References: <20221218051734.31411-1-cehrig@cloudflare.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Christian Ehrig <cehrig@cloudflare.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kui-Feng Lee <kuifeng@fb.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        Paul Chaignon <paul@isovalent.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpf: Add flag BPF_F_NO_TUNNEL_KEY to
 bpf_skb_set_tunnel_key()
Date:   Mon, 19 Dec 2022 22:24:39 +0100
In-reply-to: <20221218051734.31411-1-cehrig@cloudflare.com>
Message-ID: <87edsvjdaz.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 18, 2022 at 06:17 AM +01, Christian Ehrig wrote:
> This patch allows to remove TUNNEL_KEY from the tunnel flags bitmap
> when using bpf_skb_set_tunnel_key by providing a BPF_F_NO_TUNNEL_KEY
> flag. On egress, the resulting tunnel header will not contain a tunnel
> key if the protocol and implementation supports it.
>
> At the moment bpf_tunnel_key wants a user to specify a numeric tunnel
> key. This will wrap the inner packet into a tunnel header with the key
> bit and value set accordingly. This is problematic when using a tunnel
> protocol that supports optional tunnel keys and a receiving tunnel
> device that is not expecting packets with the key bit set. The receiver
> won't decapsulate and drop the packet.
>
> RFC 2890 and RFC 2784 GRE tunnels are examples where this flag is
> useful. It allows for generating packets, that can be decapsulated by
> a GRE tunnel device not operating in collect metadata mode or not
> expecting the key bit set.
>
> Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
