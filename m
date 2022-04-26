Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA7250ED42
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 02:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbiDZAPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 20:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239460AbiDZAPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 20:15:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C2F4551A;
        Mon, 25 Apr 2022 17:12:29 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id bg9so14636852pgb.9;
        Mon, 25 Apr 2022 17:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/h+je+UV3pdLxVUQYhtb1w1rwM7UTRsxV2ZAcdTkJt8=;
        b=ULXNiYwWF+0DYTrE3sD9xgN1oIrNDqx6x9ecrTHdI97UDwZcdnUbhKMEai84979yoi
         CMuDhlhFdUPoqJDBCAc6qT1Wu12hIVFcxF9U96DgRyGCBq34NgZkavrBvJ2r7dc3JuGM
         2ocX2ivvDPwlFylroyxMC6CDPiSsiqShrgveGfzR571j2lGr9N+EgrTpGkOV5VSIFaIZ
         ufQDVyi6bngIZEZab0PHAlyjIFtaef2X5MuQAgg54xvUzZwMrT+KwkMVosBAq+9rkAYF
         VqBZcD/1/Kbb4Xl0y0Snl2Bb+ea5sEpVxGbwgP7SaQahy9EPniuJqW0qOHX6c/hOQ0wj
         +4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/h+je+UV3pdLxVUQYhtb1w1rwM7UTRsxV2ZAcdTkJt8=;
        b=t0S6fs7NRZdboD3E4nyjinq0PpkrtMZ3Q+czDKvQCMkeBmP+LFLJw6ekcyXnNp+Hdv
         VLfDEIoLghd9ugxeK2gnWDDfJ5bE91VynpCCrzGFVtq8JSKu0xn2MHz0TiUq7SgOwowP
         HG7Gzz/Znpxru5qVy3NTBJ4er1Xb5bhy2bxr28Uqq82tV1uao1DAfR6Lx2Yy/hICOQVL
         SMn5wqGuyXfSNROELaKWlVrcCNRHJJtevzvA/L11Y+L0JzAFQ7+F/CaGh+6rcAQ7eqXW
         eLVR8fqN6IdPDY7RJneNppYYhHoETzQlPyikolwOM8BQDy0UdSR6WEp2XGaEYUb6a0YS
         SyXA==
X-Gm-Message-State: AOAM532alXIgG6z3uUcxKmvnmgmRmRkSzQscQ9MQTsRrqElKl7R6A4M6
        wI6Zcp2V0r9EdRfqlaGzxmc=
X-Google-Smtp-Source: ABdhPJwEHbgxhHTTDTogRgZTNF422cv5BKYdqyM+WwhAXHYeYi4RNxsESEXkqW4cnydMdKJQVMGiCQ==
X-Received: by 2002:a63:1d54:0:b0:3ab:754f:be08 with SMTP id d20-20020a631d54000000b003ab754fbe08mr3105721pgm.80.1650931948439;
        Mon, 25 Apr 2022 17:12:28 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::5:438a])
        by smtp.gmail.com with ESMTPSA id a18-20020a631a12000000b003aaedc4af99sm8079565pga.67.2022.04.25.17.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 17:12:27 -0700 (PDT)
Date:   Mon, 25 Apr 2022 17:12:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v6 5/6] bpf: Add selftests for raw syncookie
 helpers
Message-ID: <20220426001223.wlnfd2kmmogip5d5@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220422172422.4037988-1-maximmi@nvidia.com>
 <20220422172422.4037988-6-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422172422.4037988-6-maximmi@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 08:24:21PM +0300, Maxim Mikityanskiy wrote:
> +void test_xdp_synproxy(void)
> +{
> +	int server_fd = -1, client_fd = -1, accept_fd = -1;
> +	struct nstoken *ns = NULL;
> +	FILE *ctrl_file = NULL;
> +	char buf[1024];
> +	size_t size;
> +
> +	SYS("ip netns add synproxy");
> +
> +	SYS("ip link add tmp0 type veth peer name tmp1");
> +	SYS("ip link set tmp1 netns synproxy");
> +	SYS("ip link set tmp0 up");
> +	SYS("ip addr replace 198.18.0.1/24 dev tmp0");
> +
> +	// When checksum offload is enabled, the XDP program sees wrong
> +	// checksums and drops packets.
> +	SYS("ethtool -K tmp0 tx off");

BPF CI image doesn't have ethtool installed.
It will take some time to get it updated. Until then we cannot land the patch set.
Can you think of a way to run this test without shelling to ethtool?
