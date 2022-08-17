Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9775978EA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241719AbiHQVaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241766AbiHQVaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 17:30:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C764390C56;
        Wed, 17 Aug 2022 14:30:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a7so26797366ejp.2;
        Wed, 17 Aug 2022 14:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1WahhERX691CESd1ffbJud3Y+oZ8wMt9XQmOZisGAO4=;
        b=Qe9HJqjJVkpt9ngOfi1SC4JuyFO279d6GmPGr+m7JUf5xARUiAYC82F8IYAoMRWUuH
         Ick6Mncg5vhH1GPIkrgWo0M3oeah3nV7VGow9GlBeWAwGf+ptHvRze9Viu7DtJLqzEyq
         CdbFGYMxHNVCCc3G2N/Xi6DssMJwvB5vrLa4dGm6j/oitdez+dT5fwD6PZxMXsvMObTS
         gJHBo4eqg3dVCiio9YPKDBRvAe3YEttVP3X0KAJ1jA06JCwWql7+8EuLhq3JuX/N5w0O
         +Tz9RP5geRhjqgeApy/HhGtteAUCvkF7Rob7w9WBr/ymI91naRV0C5rMz3Bjw1i+UiTE
         yvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1WahhERX691CESd1ffbJud3Y+oZ8wMt9XQmOZisGAO4=;
        b=Ku0H0BW1ly9Ul5dyGBXjn1SFfNu4t3imCAqcu6umXyZ0ToXgHrMLN7bnrNr0chUyJw
         cTKxqMOXbJupBisn2gLi5QQg8p521LC7Jx+CI8uFPESY69l+EHzywrOdUObYdYiEgLEe
         l25J/X8r30smy2n6y+9Ei4mo+NjX8/XFBKAfZxibIhBj5AAgcXTLjgM4BAVsn4FaGhsO
         UWyikRPDRq8OaAp888WAtIOawmKGKW9VH8IvgxN8hp9o15p07V67piFKdJxlFREH49Tp
         Mf9EadQ13ttVNRuGw0M+sicnhPTx+Akb7ZKaDEQdure26IDZ1XutAPrXWa2O8VV2r+tS
         YiEg==
X-Gm-Message-State: ACgBeo3Gf2oE9kw4lgD+k9UadN7z05F+0AULaaK8l+bInIgDVxfMvLc0
        cTGpb0gyxP85RNPk3Qskv8rEVkUOQWgzr/rka3o=
X-Google-Smtp-Source: AA6agR4CMlusqqwkMYPqZBWzDqnHs10L6iaVvsd1N80IUKEqJWg8pd0K6sV2lnzisB10uvUvY41yjFw1xWJS629TJC4=
X-Received: by 2002:a17:907:272a:b0:731:4699:b375 with SMTP id
 d10-20020a170907272a00b007314699b375mr17814804ejl.633.1660771813165; Wed, 17
 Aug 2022 14:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660761470.git.dxu@dxuuu.xyz> <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
In-Reply-To: <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Aug 2022 14:30:01 -0700
Message-ID: <CAADnVQ+G0Hju-OeN6e=JLPQzODxGXCsP7OuVbex1y-EYr6Z5Yw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to nf_conn:mark
To:     Daniel Xu <dxu@dxuuu.xyz>, Martin KaFai Lau <martin.lau@linux.dev>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, Aug 17, 2022 at 11:43 AM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> +/* Check writes into `struct nf_conn` */
> +int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> +                                  const struct btf *btf,
> +                                  const struct btf_type *t, int off,
> +                                  int size, enum bpf_access_type atype,
> +                                  u32 *next_btf_id,
> +                                  enum bpf_type_flag *flag)
> +{
> +       const struct btf_type *nct = READ_ONCE(nf_conn_type);
> +       s32 type_id;
> +       size_t end;
> +
> +       if (!nct) {
> +               type_id = btf_find_by_name_kind(btf, "nf_conn", BTF_KIND_STRUCT);
> +               if (type_id < 0)
> +                       return -EINVAL;
> +
> +               nct = btf_type_by_id(btf, type_id);
> +               WRITE_ONCE(nf_conn_type, nct);
> +       }
> +
> +       if (t != nct) {
> +               bpf_log(log, "only read is supported\n");
> +               return -EACCES;
> +       }
> +
> +       switch (off) {
> +#if defined(CONFIG_NF_CONNTRACK_MARK)
> +       case offsetof(struct nf_conn, mark):
> +               end = offsetofend(struct nf_conn, mark);
> +               break;
> +#endif
> +       default:
> +               bpf_log(log, "no write support to nf_conn at off %d\n", off);
> +               return -EACCES;
> +       }
> +
> +       if (off + size > end) {
> +               bpf_log(log,
> +                       "write access at off %d with size %d beyond the member of nf_conn ended at %zu\n",
> +                       off, size, end);
> +               return -EACCES;
> +       }
> +
> +       return NOT_INIT;

Took me a long time to realize that this is a copy-paste
from net/ipv4/bpf_tcp_ca.c.
It's not wrong, but misleading.
When atype == BPF_READ the return value from
btf_struct_access should only be error<0, SCALAR_VALUE, PTR_TO_BTF_ID.
For atype == BPF_WRITE we should probably standardize on
error<0, or 0.

The NOT_INIT happens to be zero, but explicit 0
is cleaner to avoid confusion that this is somehow enum bpf_reg_type.

Martin,
since you've added this code in bpf_tcp_ca, wdyt?
