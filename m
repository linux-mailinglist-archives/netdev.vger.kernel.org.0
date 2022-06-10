Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A27546F6A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 23:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347212AbiFJVxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 17:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345352AbiFJVxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 17:53:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC651D2AD2;
        Fri, 10 Jun 2022 14:53:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b8so518036edj.11;
        Fri, 10 Jun 2022 14:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x3kzLDMq90kPMmfgMsd3F3XKFSVz7IyfY+w0mOMLfcw=;
        b=Ljoq9MDlXIJKtRtFIImokC9emik9BcAZ378kqBKTHQ0aqq1nuNgXAWTzy4lu1jVohx
         sW0ocJHogKANgxNO+bQMywRBnHRb8AInEXjGwoOBU365FM5lBJL/pXK9eyTzQQ0zQYZh
         OBQUZARHWbozSrliEjhRvsXgYPRmOir9j/PVOrRHRwlCogLxnGSvwYXrantVQGcsZKf/
         0Z14KqFiE/HwYRKsZq5obCbowZSvQQoH7CSd3f3fzMYl/ZPnH0YrtJg2SPm5lex1KLsK
         niNtHzmIkbGKHXehHz0Fak7fvgYm0gn74Buw+Rki+MjA4+2+gYiZpYPwqgJHWYGgYtaX
         CV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x3kzLDMq90kPMmfgMsd3F3XKFSVz7IyfY+w0mOMLfcw=;
        b=3wy5C6CKS0TadSJLj/QKurhm4jfBUuqIJCleUCXmdyG3ZXcD3CFzvxBRJkpsONU9Mn
         Msy7tPXRtuSxO0evztpA9z8RyGV/ZZ9mz9quuppbJupimU9oZvzXopmxAKQpNWYwHjru
         NwqPPjoJvbXIU08burlL/Gmxj/4pckqe9y+KW+2EwX816OIkQAdUheWPH4vPlmYiXqFN
         kSUbIY4yjQZmP2KTBA3k7c2bNAaL46jGpFD6lPT3bleteXIL2xs0de6xg+5wCwglAEEb
         CN8DdJeQN5K0lbRcEdnNfoTMm4BcakGpzTM/M6dgG9xPtza6q4klhrBC8FThTwovUZCh
         jJKA==
X-Gm-Message-State: AOAM533dfp7/aRPnoboJMuTYHJf9BV9vJKgydhF5TiELjgM47ayd9kBF
        lfIa/b1Cx4zXNQFZ+Wo7jmz5hP3b4ng+egqWSMjRkHyH4wo=
X-Google-Smtp-Source: ABdhPJy2kazqq3xLMJXGjIFtHv+B0pZmDKVE87Mbkng6u5Wqya6F/eRz0pZ0ScwW/B3Q8/lL6IgRGkjWHxgqC0rgYeY=
X-Received: by 2002:a05:6402:120b:b0:42f:aa44:4d85 with SMTP id
 c11-20020a056402120b00b0042faa444d85mr44178089edw.338.1654897984407; Fri, 10
 Jun 2022 14:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion> <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion> <87h74s2s19.fsf@toke.dk>
 <2f98188b-813b-e226-4962-5c2848998af2@iogearbox.net> <87bkv02qva.fsf@toke.dk>
In-Reply-To: <87bkv02qva.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jun 2022 14:52:52 -0700
Message-ID: <CAADnVQLbC-KVNRPgbJP3rokgLELam5ao1-Fnpej8d-9JaHMJPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 1:41 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> >> Except we'd want to also support multiple programs on different
> >> priorities? I don't think requiring a libxdp-like dispatcher to achiev=
e
> >> this is a good idea if we can just have it be part of the API from the
> >> get-go...
> >
> > Yes, it will be multi-prog to avoid a situation where dispatcher is nee=
ded.
>
> Awesome! :)

Let's keep it simple to start.
Priorities or anything fancy can be added later if really necessary.
Otherwise, I'm afraid, we will go into endless bikeshedding
or the best priority scheme.

A link list of bpf progs like cls_bpf with the same semantics as
cls_bpf_classify.
With prog->exts_integrated always true and no classid, since this
concept doesn't apply.
