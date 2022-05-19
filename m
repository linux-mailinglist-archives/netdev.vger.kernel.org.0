Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807D652D9EE
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241859AbiESQMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241083AbiESQMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:12:20 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BD0B0408;
        Thu, 19 May 2022 09:12:16 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id n10so4925313qvi.5;
        Thu, 19 May 2022 09:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hoTmvPXtyx3H4u3Zg8utb7mfNRoYWy4jUno7/0YMY70=;
        b=QU4vYRdK5dCC+NlAE17xdmGaZa42VlKqy2ixfrb5jDTwuCDibubZHwAPDoIPkvWGil
         u/Lxxxe+D91uiWhBcGR6QVGWw7+NrYV7/Su9HOeN/jjIZAyRRvVHOnJZuij1vI8XNVrd
         PHRdTSOC5udVoJcdKHAsFPrwrTUIZTiap7yyzgKOziw5W1b8sxdRzSfq6hSwytewfEuM
         8LXFYtBr01Uz+h8OYq6GfoORMk7ZqJ3TKNseqyTj1avAY1WvfiZxUd7dFqYILiwLu/M8
         jjmwczJ0XieJetUpg03LOZqbpL1z1sweWcbo7D0pJPu3GiFJk0nSHI9CT0AIwuGn1GWf
         2i1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hoTmvPXtyx3H4u3Zg8utb7mfNRoYWy4jUno7/0YMY70=;
        b=0ZNtcrUJaOnuVxKvSBxJ/kbNk/pviI6KRwndaVX0vcwW65SDmvu8/0otHEUen/VEx0
         KvylYiFrlWRis0zurguz7ZtVdzm8Z79vvS8SxJcAoQYpfAniA4++fsJE6yhcOAkpUJjD
         HPZwtQKUAn5xVTwq7JmlK+QSmkrHPZrAypJcIuLRl4z7ZJfTJiXZ8NRrPjpBDnA3HRb/
         eB85J7IPlmhGwO11Tic/ObLtZULJsALDGPLGBOWbqWzXVef4nyKbMCVNdcNDvBPE9j/+
         KZAFu8IflCCsKWDn4rA8kzMUWuubImX2SZMc2NgtzSnjER/+Ik9PBotHLG6kSfTq38qw
         qhMg==
X-Gm-Message-State: AOAM531NefhuHmVSjIqfWXKP2X0fL8BO8omxFj0HSsqX+dgiRM6KnCKv
        MCizIg+hrmoNY7OSP0M2sp1DbI4NE2qOtPAjr8w=
X-Google-Smtp-Source: ABdhPJwSCu8SNKkW70TBPOYRAfUUgpVrzcUatZdXXFWzgqGKW36FPuMXIjJh5ltu9RJ6UyHdfErpYyEVta9wAVmUqt8=
X-Received: by 2002:a05:6214:2245:b0:461:bc38:1f7d with SMTP id
 c5-20020a056214224500b00461bc381f7dmr4629705qvc.63.1652976735222; Thu, 19 May
 2022 09:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
 <CAADnVQ+x-A87Z9_c+3vuRJOYm=gCOBXmyCJQ64CiCNukHS6FpA@mail.gmail.com>
 <6ae715b3-96b1-2b42-4d1a-5267444d586b@bytedance.com> <9c0c3e0b-33bc-51a7-7916-7278f14f308e@fb.com>
 <380fa11e-f15d-da1a-51f7-70e14ed58ffc@bytedance.com>
In-Reply-To: <380fa11e-f15d-da1a-51f7-70e14ed58ffc@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 19 May 2022 09:12:04 -0700
Message-ID: <CAADnVQL9naBBKzQdAOWu2ZH=i7HA1VDi7uNzsDQ1TM9Jr+c0Ww@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
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

On Wed, May 18, 2022 at 8:12 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote=
:
>
> =E5=9C=A8 2022/5/19 =E4=B8=8A=E5=8D=884:39, Yonghong Song =E5=86=99=E9=81=
=93:
> >
> >
> > On 5/17/22 11:57 PM, Feng Zhou wrote:
> >> =E5=9C=A8 2022/5/18 =E4=B8=8B=E5=8D=882:32, Alexei Starovoitov =E5=86=
=99=E9=81=93:
> >>> On Tue, May 17, 2022 at 11:27 PM Feng zhou
> >>> <zhoufeng.zf@bytedance.com> wrote:
> >>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> >>>>
> >>>> We encountered bad case on big system with 96 CPUs that
> >>>> alloc_htab_elem() would last for 1ms. The reason is that after the
> >>>> prealloc hashtab has no free elems, when trying to update, it will
> >>>> still
> >>>> grab spin_locks of all cpus. If there are multiple update users, the
> >>>> competition is very serious.
> >>>>
> >>>> So this patch add is_empty in pcpu_freelist_head to check freelist
> >>>> having free or not. If having, grab spin_lock, or check next cpu's
> >>>> freelist.
> >>>>
> >>>> Before patch: hash_map performance
> >>>> ./map_perf_test 1
> >
> > could you explain what parameter '1' means here?
>
> This code is here:
> samples/bpf/map_perf_test_user.c
> samples/bpf/map_perf_test_kern.c
> parameter '1' means testcase flag, test hash_map's performance
> parameter '2048' means test hash_map's performance when free=3D0.
> testcase flag '2048' is added by myself to reproduce the problem phenomen=
on.

Please convert it to selftests/bpf/bench,
so that everyone can reproduce the issue you're seeing
and can assess whether it's a real issue or a corner case.

Also please avoid adding indent in the patch.
Instead of
 if (!s->extralist.is_empty) {
  .. churn

do

 if (s->extralist.is_empty)
