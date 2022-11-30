Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC17463CEF9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiK3F5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbiK3F5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:57:08 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF5C77223;
        Tue, 29 Nov 2022 21:56:56 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id o5so16399736wrm.1;
        Tue, 29 Nov 2022 21:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6w+OdNdRFHbYUVtJA19A47W8lBW0pPewV38NS5DP0eg=;
        b=lkMY4jkWg70EE3fQH7Y0sib3cykd1n1T3kHixPfe86BQgLqVRK1uTXnZ6ZiI4GsAgu
         ozglYdOLC00u0utGIMBkEklWc76MHZ/hajC9tspFxd5XuowHwhEHQk8+rs8tXjBDUTkT
         baGDyq6obFQviCVni1/SG7bCObZpfJAkCtBGh+UMee+YVRjT89nmcx+Tx5zxfF9YB6Q4
         lmBp1J4xjePYoj14v0Fln5WlZanLa+VRF1gm2Vl06X6Wgrmlto6HG+e+1W7rdBZiJr9a
         9p8xwCs/gF+IJyxluR4FvW5hS6F97XOHlnut7Dje3r5JmTq3W57ceHF0TbLGCpOK4lJJ
         OgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6w+OdNdRFHbYUVtJA19A47W8lBW0pPewV38NS5DP0eg=;
        b=Qdwhz0yY2EHkv0jlwHgT0K8C+kLBfCnI9KjPOpi4ZewU67+3lOobGxuGP9o24YMjQa
         MwdbcDxlsGXv88s6yK88s0jdH1UC/PSnGKzT5G9l4+Lf6bnLguSkA/FVC5GtMIdUDhgQ
         hupNx93BoFdxPFlfc9W4M/pINnT879vpdsoWRXRBb1b7lJGHOSYN6GI2N9f2G1PZ2vTf
         bNA3eogMlpoBNA/w2Mx9VK12diCaeiFyh1snuIHFsmyGGHSPD4LZQU3A2ifr4c62adM6
         QmFjWRUjehcr7hXR5hd/Eft6OKOmDnAW9kWqPaoDGpsFcT5/kfroU8y5P6EVBmtRxSmH
         d44w==
X-Gm-Message-State: ANoB5pl7KBijOKfTjQaqx+bMGT+GIy5qfOKmJIqdH9CzJkIq2a51vyxr
        PzANBPmZm/puxTFr4G57Xc0Ots4TmoTqSykTore6X7Tv
X-Google-Smtp-Source: AA0mqf49nwlETYQIm+SAUx75IQEY7QfFc4l75jRTh8XT/+ayBmcLfg4uN2g0DFCyybeUSgiiJqcJdALdpAw96ez/3aU=
X-Received: by 2002:a05:6000:181:b0:241:c6f9:3e5a with SMTP id
 p1-20020a056000018100b00241c6f93e5amr27677332wrx.157.1669787815082; Tue, 29
 Nov 2022 21:56:55 -0800 (PST)
MIME-Version: 1.0
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com> <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com> <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com> <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local> <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
 <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
 <23b5de45-1a11-b5c9-d0d3-4dbca0b7661e@huaweicloud.com> <CAMDZJNWtyanKtXtAxYGwvJ0LTgYLf=5iYFm63pbvvJLPE8oHSQ@mail.gmail.com>
 <8d424223-1da6-60bf-dd2c-cd2fe6d263fe@huaweicloud.com> <CA+khW7hsvueaRRFX3m-gxtW0A7fYEOJLfDTSTVMY-OLn_si1hQ@mail.gmail.com>
In-Reply-To: <CA+khW7hsvueaRRFX3m-gxtW0A7fYEOJLfDTSTVMY-OLn_si1hQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 30 Nov 2022 13:56:18 +0800
Message-ID: <CAMDZJNVEnYeqj1-ZcfJHwz4ZSVBA5H46_jMEkLxRgkgQ4R=Gaw@mail.gmail.com>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Hao Luo <haoluo@google.com>
Cc:     Hou Tao <houtao@huaweicloud.com>, Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 1:02 PM Hao Luo <haoluo@google.com> wrote:
>
> On Tue, Nov 29, 2022 at 8:13 PM Hou Tao <houtao@huaweicloud.com> wrote:
> >
> > On 11/30/2022 10:47 AM, Tonghao Zhang wrote:
> <...>
> > >         if (in_nmi()) {
> > >                 if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
> > >                         return -EBUSY;
> >
> > The only purpose of trylock here is to make lockdep happy and it may lead to
> > unnecessary -EBUSY error for htab operations in NMI context. I still prefer add
> > a virtual lock-class for map_locked to fix the lockdep warning. So could you use
> > separated patches to fix the potential dead-lock and the lockdep warning ? It
> > will be better you can also add a bpf selftests for deadlock problem as said before.
> >
>
> Agree with Tao here. Tonghao, could you send another version which:
>
> - separates the fix to deadlock and the fix to lockdep warning
> - includes a bpf selftest to verify the fix to deadlock
> - with bpf-specific tag: [PATCH bpf-next]
>
> There are multiple ideas on the fly in this thread, it's easy to lose
> track of what has been proposed and what change you intend to make.
Hi, I will send v2 soon. Thanks.
> Thanks,
> Hao



-- 
Best regards, Tonghao
