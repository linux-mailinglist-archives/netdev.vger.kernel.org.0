Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE1D53A442
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350965AbiFALiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiFALiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:38:12 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FAD1402B;
        Wed,  1 Jun 2022 04:38:11 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u12so3138708eja.8;
        Wed, 01 Jun 2022 04:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lgS1YFKqi2uJamBMChe9mVllG2N97UqDarRjzfMsUHA=;
        b=k3AZWD76xz4xvkaZhjc5Lihx1Q8j5csqqFFCXPOgzynZ/ZJfptD505c242PQNC/kHo
         G1c1IrXEAY+ON8jBfBf6OK0vsb/SYYrdXMv0TXuj1TgnC10vaCfYWOH5tBiFcfIqXPP9
         NP0L4l7Xyb+NrOnJF69Be+jLaHTnHXhHLD7wDfoOx44uvVvMhvUdaI4pAwNIwV4gmbSL
         pvHKj63AaYFegrF10wTl//I4FSdbbuK2tKGjdg4QB7mvdDeSqAW5lttLAm5oi/QFapIM
         XyjBye5KnRWmXfqzNsn7dL1y80T6M/t11gwfsE20rgtN2FLUMB9o7ZAPALLB3cgU0kGb
         +sjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lgS1YFKqi2uJamBMChe9mVllG2N97UqDarRjzfMsUHA=;
        b=RQyiuZNTyQ/nfd+MYIOMoqQPLYeSKx+FKFjJvxiUEEycyviyPL9/1lf5cTWmZo92KG
         Wd0U9H+x3rXjFZYJET4nRB+rgbHATbAAav/v29Xu/GXFrpk2T2JrqxrkRNsghnDwG1KX
         cOudNG43ZikL8uWwTud+VJivRFiiLExvzHr3lqlrsEo2ewKcZ+l+eXB4k+fp63WMlJzD
         x/ukGLwwQ3o2lfd4HPffpC3ebej0bM8hGGZyd3pRGPH6irGhW5KR5xByGT+Z3MssqbRM
         0a6en+PSnULioCkzmyH4JkJMxBjKk5cdu9hcohQvnjmtT4UgDYVUTbGwKS95m8tvdL+t
         3vgA==
X-Gm-Message-State: AOAM530HbIJTMkYlaaTQYBQVhPFse8moH1RmHzXoPuHlRbmogWCQhNh1
        3gMkViBZy306M6NNAo3slQLZHuCsxPh9+JfO6TE=
X-Google-Smtp-Source: ABdhPJzpyud0gjdD8atnNWym6HYdwiRdif+39wJ5pJ94vMsLOYcyoez7mgdupUeOn085sMyyJKlTcdmzLABlsLkb3QQ=
X-Received: by 2002:a17:907:7da5:b0:6fe:d818:ee49 with SMTP id
 oz37-20020a1709077da500b006fed818ee49mr44795116ejc.58.1654083489501; Wed, 01
 Jun 2022 04:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com>
 <20220601084149.13097-3-zhoufeng.zf@bytedance.com> <CAADnVQ+qmvYK_Ttsjgo49Ga7paghicFg_O3=1sYZKbdps4877Q@mail.gmail.com>
 <041465f0-0fd3-fd39-0dac-8093a1c98c00@bytedance.com>
In-Reply-To: <041465f0-0fd3-fd39-0dac-8093a1c98c00@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jun 2022 13:37:57 +0200
Message-ID: <CAADnVQ+cCoH=DAoyLGtJ5HvdNVgFBgTW=wCHs1wvFQuwyhcWOw@mail.gmail.com>
Subject: Re: Re: [PATCH v4 2/2] selftest/bpf/benchs: Add bpf_map benchmark
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
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

On Wed, Jun 1, 2022 at 1:17 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>
> =E5=9C=A8 2022/6/1 =E4=B8=8B=E5=8D=885:53, Alexei Starovoitov =E5=86=99=
=E9=81=93:
> > On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> w=
rote:
> >> +struct {
> >> +       __uint(type, BPF_MAP_TYPE_HASH);
> >> +       __type(key, u32);
> >> +       __type(value, u64);
> >> +       __uint(max_entries, MAX_ENTRIES);
> >> +} hash_map_bench SEC(".maps");
> >> +
> >> +u64 __attribute__((__aligned__(256))) percpu_time[256];
> > aligned 256 ?
> > What is the point?
>
> I didn't think too much about it here, just referenced it from
> tools/testing/selftests/bpf/progs/bloom_filter_bench.c
>
> >
> >> +u64 nr_loops;
> >> +
> >> +static int loop_update_callback(__u32 index, u32 *key)
> >> +{
> >> +       u64 init_val =3D 1;
> >> +
> >> +       bpf_map_update_elem(&hash_map_bench, key, &init_val, BPF_ANY);
> >> +       return 0;
> >> +}
> >> +
> >> +SEC("fentry/" SYS_PREFIX "sys_getpgid")
> >> +int benchmark(void *ctx)
> >> +{
> >> +       u32 key =3D bpf_get_prandom_u32() % MAX_ENTRIES + MAX_ENTRIES;
> > What is the point of random ?
> > just key =3D MAX_ENTRIES would be the same, no?
> > or key =3D -1 ?
>
> If all threads on different cpu trigger sys_getpgid and lookup the same
> key, it will cause
> "ret =3D htab_lock_bucket(htab, b, hash, &flags); "
> the lock competition here is fierce, and unnecessary overhead is
> introduced,
> and I don't want it to interfere with the test.

I see.
but using random leaves it to chance.
Use cpu+max_entries then?
