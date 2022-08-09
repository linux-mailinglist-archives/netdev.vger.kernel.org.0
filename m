Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E8A58D15D
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbiHIA24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiHIA2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:28:54 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3604CCE1C;
        Mon,  8 Aug 2022 17:28:53 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s11so13208171edd.13;
        Mon, 08 Aug 2022 17:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=fZU856xU3vO5bowNaIN0ry5UjNZrSsJJt3QJFhHCZPg=;
        b=IszRJ6lrSW2ArTZf6uvjNMo3SOEOjP/U00RmsClrzYFpMrykrXPS66h5loKEGKjpDe
         fNtV/YQQuAEV49sIaq98FZDYs4KjtMXIcAlM5e/bPGFPn+HneA2yY1kmTZJvuqL+w1eA
         qg/LHJqQZ0BzsaFZdpKOIpFPkDHflEd7pJ5B6+Sw2w2SwGb7Uwp2DJ2dzW65h+07F1Cv
         XdR2IsyIO0thPFNMDcS5Q+utcMVea7xQfRAN9iO0/pgmBVOWxKMIoC8jJdFqhXxWG6TL
         9S4d0hcXnBaD9qvlIHpDwUoiv4HuQfyenKH5USKS18KaLU6YmA5vG3gD6FusPcd8Yuta
         A0DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=fZU856xU3vO5bowNaIN0ry5UjNZrSsJJt3QJFhHCZPg=;
        b=mrRKpXt0Ql/Y/7ZV+gn1CeXd57jXYM2v6aE1BfoCk55TKJuGizro0ojCDS+OQgE7v1
         XzG/9UzuP4eunglDhcvhSWl4Lmmd6PvxEnGAXhFEKqvd/wA9Mcq/SpnJLXjM0dOM/7oP
         byWXKwJvJB2tIUXjBJE33n1EjelfY665nNUSgkQpqZGoxJp7rM4Tp8QSP2UzgYZYrwIC
         V/nki3evY7ofbxA7SpzSt0fHTJ1ILIF8MxbiPlXdNzuVexZfPxw1ZhL2DSwDn98pgSYs
         yOe24N6IXM/JMwGpX/qJGSOnfQ5d3ARy9eVEiMVq2Ftcz4w99gqE2H01e0nmxka6+u0w
         1aRw==
X-Gm-Message-State: ACgBeo3Uv//RuVlTeLxeV+bzEyInlY1VtTpCDlpOkJaVSlExE7TrMx8t
        5p6uXgeu0TZwJsmA+LdBW8b4velB0XUNack+Edc=
X-Google-Smtp-Source: AA6agR4bmav2ZzxZ31jLXkd0ueDjXX0xVsuz2MRugS1OhQfk7TyAC15j/VTIRHlY2qZdRZzCA1Zfb9y8aG7pgseHmA8=
X-Received: by 2002:a05:6402:24a4:b0:440:8c0c:8d2b with SMTP id
 q36-20020a05640224a400b004408c0c8d2bmr8047196eda.311.1660004931743; Mon, 08
 Aug 2022 17:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220606103734.92423-1-kurt@linutronix.de> <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
 <87pmhj15vf.fsf@kurt> <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
 <87edxxg7qu.fsf@kurt> <CAEf4BzZtraeLSP4wcNk7t4sqDK6t2HVoo57nkUhVVLNCWe=JfA@mail.gmail.com>
 <87k07o1pfw.fsf@kurt>
In-Reply-To: <87k07o1pfw.fsf@kurt>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Aug 2022 17:28:40 -0700
Message-ID: <CAEf4BzZmoEn+ARbW+mt4k=68+YJqkUELAFPMAjHN893YL3B9OA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Wed, Aug 3, 2022 at 11:40 PM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> On Wed Aug 03 2022, Andrii Nakryiko wrote:
> >> +void test_tai(void)
> >> +{
> >> +       struct __sk_buff skb = {
> >> +               .tstamp = 0,
> >> +               .hwtstamp = 0,
> >> +       };
> >> +       LIBBPF_OPTS(bpf_test_run_opts, topts,
> >> +               .data_in = &pkt_v4,
> >> +               .data_size_in = sizeof(pkt_v4),
> >> +               .ctx_in = &skb,
> >> +               .ctx_size_in = sizeof(skb),
> >> +               .ctx_out = &skb,
> >> +               .ctx_size_out = sizeof(skb),
> >> +       );
> >> +       struct timespec now_tai;
> >> +       struct bpf_object *obj;
> >> +       int ret, prog_fd;
> >> +
> >> +       ret = bpf_prog_test_load("./test_tai.o",
> >> +                                BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
> >
> > it would be best to rely on BPF skeleton, please see other tests
> > including *.skel.h, thanks
> >
>
> Ah, nice. Adjusted the test case accordingly. Will post v2 after the
> merge window. Thanks!

We don't close bpf-next during the merge window, so feel free to send v2 early.
