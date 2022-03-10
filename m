Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600854D53EE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 22:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344136AbiCJVxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 16:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344306AbiCJVxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 16:53:10 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F379D194161;
        Thu, 10 Mar 2022 13:52:08 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 3so11827923lfr.7;
        Thu, 10 Mar 2022 13:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKX1kj+QWNu4jooUhEjdLPsSv0lbIRZtaxwWhQNO5zU=;
        b=S8sbH6hvIyT9p5K2EvwdzG6NPFeZAG+EvFW/YKieqg3DVRPFH7Gs2Tor8rWb+N+yj4
         vR/f+Vc7KymW0Gpop/60qdWeGAuq5k4sI59HzvoEBpcMiDX4A0nTLI/KcAz38cI+c+Og
         ilww15YPmDexdWr089bxeOV2tAlOJdr89utxJHdJJoI6J4JEpn6P2491ZnUfHYE+WIKO
         PV0CHsbGFs29mNgvWy/q1ZwM51Gnh9+G57mWIOR9qdWBezbgtpZmrdOHFf847xiFszDS
         GNao9eIK9oBUZ65Ir/zUTnn3vNmgJc4+MRzqmfOJGqoO78i3/+4aCTu3dHQT1oEjGqQX
         y1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKX1kj+QWNu4jooUhEjdLPsSv0lbIRZtaxwWhQNO5zU=;
        b=6EsojCyTpwGYIsWroGBrxICCXJwVLBpLF5swhnpukndupTc0C8QJlTNWFqga6ErZSY
         R0exShuRDt8kGHdJ2RIArud+qg2cd0wtACAtnDD2p6fkMMynJlcgwxd1r9otZZfdHNcT
         gp78lMcwqlHi7c2ZGRd7VbacH3t8O2ccoABkTmWdJvZn3/qcYrJg+AIdtB8g+SvpTxoz
         ebZPTZzyHAu6qTBH286Rshz8WtRfJd+ng0f0FEHrf5a9gNDjIghxp+3N1HQ9lY7iZ4ja
         vJcjsn90Y+/I6eWRQ+dssHa6Ul4xC9n7wOJUAhe0fC7M/zSHQxFdY7RyTrZ1ut54uTtv
         zW0A==
X-Gm-Message-State: AOAM530EkPQlpjZrRsGYgm5lx1eUelHj18YqLbzgbI3WMbp5oGhwBZGC
        Ag022dCdNvtjD/ueQavoKZp0Pb0+LDOUsy6S+Ns=
X-Google-Smtp-Source: ABdhPJyydZq3WdUuGFxaz/FA3/bQVl2u0nG16nADcRRpR7QurvWm8o8nKQ2BEdxm+3s6AWFus0asNevyDEFZBcmWwKo=
X-Received: by 2002:a19:9201:0:b0:443:c317:98ff with SMTP id
 u1-20020a199201000000b00443c31798ffmr4149726lfd.331.1646949127172; Thu, 10
 Mar 2022 13:52:07 -0800 (PST)
MIME-Version: 1.0
References: <20220310161518.534544-1-ytcoode@gmail.com>
In-Reply-To: <20220310161518.534544-1-ytcoode@gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 10 Mar 2022 13:51:56 -0800
Message-ID: <CAJnrk1a7-dhPUCbv__q0JX+QERLB2OAYojdAVd0S50uE5FDQgw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Use offsetofend() to simplify macro definition
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 1:15 PM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> Use offsetofend() instead of offsetof() + sizeof() to simplify
> MIN_BPF_LINEINFO_SIZE macro definition.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>

Acked-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  kernel/bpf/verifier.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
[...]
