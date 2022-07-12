Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742E457198C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 14:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiGLMMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 08:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiGLMMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 08:12:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86459A2748;
        Tue, 12 Jul 2022 05:12:33 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y4so9839474edc.4;
        Tue, 12 Jul 2022 05:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=x8vbORy8AywCk74uHTCMgrubWrqNjgE54NvBTflmqeQ=;
        b=lDdMdVlHaW4FTt4h6EPFFJOkMu4eBuqh7YTIMQkOpmd1/Dcqnk4/m0SlBx8zsHZMOL
         AMpiJfMvyGR02QZAqd0gOgVijpKjjZwMm8mQf0OFGQZCVB+m1vJpKkh9Sq1HvQyURKT9
         6F4WkeUX7wHpdR0hLQK/11AeP61lWH3fVzttMgk1IeHgaEgrJYcboYFj4/LdNN5g4A0l
         eRCYnOrw/0nougLMRBZtYhOuMWAJfuB6Vrw797mU62yYZt+2ypAhc0hF9S+k8aGc7E1P
         i8fM2jHQEJEQ0QS75rLpA0DG7s6ZR3wKlGUzoJ+36tGfvUNFr7IDZf7gacVKCbBSTS+Z
         5TyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=x8vbORy8AywCk74uHTCMgrubWrqNjgE54NvBTflmqeQ=;
        b=wXa+uUwnauzGeu0pjsqJfPFOly6fYspvWJ3klGt8T0XI0rS59KMZgExWmzZG6H08Vi
         wjIwI63b6Xd8JAP/FYWkIJp91o39Xd9czO6N0W9lcIzxbxFCD/eqe5KEdZfIw3KAZ+EL
         aUwqEtMkWbwTwCuZXQL8UdoEWWykyUt+k30ieiRMaHcEZ7kVyHR/AyFtGUlLZzuB3ov0
         xSA8j26FNtP2/3HR+fqBLqAODE+QianWCd0uMd7qngZS+nVhWQEY4tQDZpMxYoLLofsM
         BDHkAH34gyf+913IuksrAo7JJBeD0Rn9YHpjD2eGd3oxi45gKAzgL/BIwz1lvFe0JN7p
         LM5g==
X-Gm-Message-State: AJIora8s5YiZdsV8kULQu2stgIDsZL/4dcrlvH/CuhF+EqTx5mWkTMaM
        Js4688lAgIaA693V1JapupALdxQxNQ8XBQlE
X-Google-Smtp-Source: AGRyM1vMaBRbetrGziGmHjw4jnpO6SgNv63VjmyfuIrj6XwxYuSd3piScPouwVPvs+C6J5YdAuy3hw==
X-Received: by 2002:aa7:cd86:0:b0:43a:26e3:d333 with SMTP id x6-20020aa7cd86000000b0043a26e3d333mr32029196edv.178.1657627952055;
        Tue, 12 Jul 2022 05:12:32 -0700 (PDT)
Received: from krava ([151.14.22.253])
        by smtp.gmail.com with ESMTPSA id s17-20020a056402037100b00437938c731fsm5937897edw.97.2022.07.12.05.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:12:31 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 12 Jul 2022 14:12:26 +0200
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
Subject: Re: [PATCH bpf-next] mptcp: Add struct mptcp_sock definition when
 CONFIG_MPTCP is disabled
Message-ID: <Ys1lKqF1GL/T6mBz@krava>
References: <20220711130731.3231188-1-jolsa@kernel.org>
 <6d3b3bf-2e29-d695-87d7-c23497acc81@linux.intel.com>
 <5710e8f7-6c09-538f-a636-2ea1863ab208@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5710e8f7-6c09-538f-a636-2ea1863ab208@tessares.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 11:06:38AM +0200, Matthieu Baerts wrote:
> Hi Jiri, Mat,
> 
> On 11/07/2022 23:21, Mat Martineau wrote:
> > On Mon, 11 Jul 2022, Jiri Olsa wrote:
> > 
> >> The btf_sock_ids array needs struct mptcp_sock BTF ID for
> >> the bpf_skc_to_mptcp_sock helper.
> >>
> >> When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
> >> defined and resolve_btfids will complain with:
> >>
> >>  BTFIDS  vmlinux
> >> WARN: resolve_btfids: unresolved symbol mptcp_sock
> >>
> >> Adding empty difinition for struct mptcp_sock when CONFIG_MPTCP
> >> is disabled.
> >>
> >> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >> ---
> >> include/net/mptcp.h | 4 ++++
> >> 1 file changed, 4 insertions(+)
> >>
> >> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> >> index ac9cf7271d46..25741a52c666 100644
> >> --- a/include/net/mptcp.h
> >> +++ b/include/net/mptcp.h
> >> @@ -59,6 +59,10 @@ struct mptcp_addr_info {
> >>     };
> >> };
> >>
> >> +#if !IS_ENABLED(CONFIG_MPTCP)
> >> +struct mptcp_sock { };
> >> +#endif
> > 
> > The only use of struct mptcp_sock I see with !CONFIG_MPTCP is from this
> > stub at the end of mptcp.h:
> > 
> > static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock
> > *sk) { return NULL; }
> > 
> > It's normally defined in net/mptcp/protocol.h for the MPTCP subsystem code.
> > 
> > The conditional could be added on the line before the stub to make it
> > clear that the empty struct is associated with that inline stub.
> 
> If this is required only for this specific BPF function, why not
> modifying this stub (or add a define) to return "void *" instead of
> "struct mptcp_sock *"?

so btf_sock_ids array needs BTF ID for 'struct mptcp_sock' and if CONFIG_MPTCP
is not enabled, then resolve_btfids (which resolves and populate all BTF IDs)
won't find it and will complain

btf_sock_ids keeps all socket IDs regardles the state of their CONFIG options,
and relies that sock structs are defined even if related CONFIG option is disabled

if that is false assumption then maybe we need to make btf_sock_ids values optional
somehow

jirka
