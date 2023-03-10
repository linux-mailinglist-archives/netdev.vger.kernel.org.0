Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDADD6B4F55
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCJRpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 12:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjCJRpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 12:45:33 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97C22118;
        Fri, 10 Mar 2023 09:44:53 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o12so23601649edb.9;
        Fri, 10 Mar 2023 09:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678470251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nw6FXVHVhxWpoDwXXU/vxXbQhWMCn+ZT5LXvjilgTxo=;
        b=TrYbT1xaTRkCFBdYYcQxmXX8wMzaqofpM2inQbD78kSJVIELRQDIBc1znKTQHy4Uzf
         HjV5t787vafak3nSR7Ck8PCoBf8T4fnDJc/n63yyLoOqMmjJppoOvsWJ6zoq1ejs9lF1
         ifzbJm4hNe898pxtm05pBq+m0gnMH5ZsxgXRf0ixCekV87uA6RyAgetDAkKfDyhnz0R8
         VfiUMt0YSrRIm5JDF9kXYjWeq8jFTOiiceJP2kVS4xsopeBUsUcjoXo0dQJAD3POXqu5
         80sTe4kBECoWdjL6WJTECwiz1l4u9l4Vo9zQmYKw7ZvOoAfL0MGjUsMGh0WqltLnmiqV
         mlyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678470251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nw6FXVHVhxWpoDwXXU/vxXbQhWMCn+ZT5LXvjilgTxo=;
        b=lzg/qfTTXzC4aBzJOLyayU+8ChctKTk+Sqoer66LWWFHosahBvM0Q+5EOWT0tq1Wuj
         hLmMrB9a1Ua7LWJxXNlt77ZuXOqEu8o8qXgfyaaNy2U948vrUKArgOFr3MJOs5UnJQ2b
         +epLpW9lULx+0YGxJMzDq/ecbMK+1IFqtTcdWe0/5w0Vb2BWaji+/BBXcN9HBxyVW+Wk
         VvuJJ/eis8dpt6/G5uiw4aZvpqiDQ/VjRsJlQx9Ersf4TZ01VS9FI6YnQJZee7jlso3o
         VjO5Nn9KvBqUE0Qkqpu3ijTbbzy0A9geDtaEWpla/GB36FpJrPlqaDqI+SugydkihPxa
         iXMg==
X-Gm-Message-State: AO0yUKXNJ00inuq2aiuF5PBLc5Rgj4q3ObRY6IC3ykyqER3+fR1LB0Yr
        elkZUI4bMoabHY0YT+BQSiev2NsSQ3YpqarG24g=
X-Google-Smtp-Source: AK7set+ya5grnf2ETGMqbnuUzVygrRq6tXXtdaNcQwJFQmZ8HsSse8w+VynIHROS4s4KyTn63s5KypZI1GEHMSJxhC0=
X-Received: by 2002:a50:ce42:0:b0:4bf:5981:e5cc with SMTP id
 k2-20020a50ce42000000b004bf5981e5ccmr1650110edj.3.1678470251170; Fri, 10 Mar
 2023 09:44:11 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-11-joannelkoong@gmail.com> <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
 <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com>
 <20230308015500.6pycr5i4nynyu22n@heavy> <CAJnrk1Y1ONmEJpwDqGzCUmyrkDf9s_HpDhR5mW=6fNKM6PiXew@mail.gmail.com>
 <c27727cfabced2b9207eabbba71bed158ca35eec.camel@linux.ibm.com>
 <CAJnrk1Za8KaAq4=v7X=YEHRu5jc3upR059AcY9eanr-v_9VSqg@mail.gmail.com>
 <67a28d535a91396a20e7fb5ff4c322395c947eb8.camel@linux.ibm.com> <CAKH8qBvv5EkKvMuZV_k9GWA+rAgx=M4ndiQDn5Jg8h0Qtc5SLg@mail.gmail.com>
In-Reply-To: <CAKH8qBvv5EkKvMuZV_k9GWA+rAgx=M4ndiQDn5Jg8h0Qtc5SLg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Mar 2023 09:43:59 -0800
Message-ID: <CAADnVQKUqagMC3ELf9mW+RwQsxogtFFJ7fQNp9btq-Hcd9O+ag@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 9:12=E2=80=AFPM Stanislav Fomichev <sdf@google.com> =
wrote:
>
> >
> > and I'm wondering whether you meant bpf_prog_dev_bound_match(), and
> > whether it protects against the ABA problem, i.e., if
> > __bpf_offload_dev_netdev_unregister() is called twice, and we get
> > aux->offload and aux->offload->netdev at the same addresses?
>
> Yes, the comment is talking about bpf_prog_dev_bound_match during attach =
time.
> When __bpf_offload_dev_netdev_unregister races with our prog load
> (which is being loaded for some specific netdev),
> bpf_prog_dev_bound_match check during attach time should render this
> program un-attach-able / unusable (since the original netdev, for
> which this prog has been loaded, is gone).
>
> But going back to s390 issue: so basically, rewriting imm for kfuncs
> early in the verifier prevents jit from being able to call
> bpf_jit_find_kfunc_model? Did I get that correctly?
> Adding kfunc_desc seems like a nice hack, but I liked your previous
> series which pushed that imm resolution down to the jits better :-(

Me too. All I was saying is to do without hacking through all JITs.
More or less what v2 version was doing instead all-arch change in v3.
