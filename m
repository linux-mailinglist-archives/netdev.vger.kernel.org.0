Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB454BC8E9
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 15:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242432AbiBSOkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 09:40:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiBSOkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 09:40:15 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DBB70059
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 06:39:56 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id m14so10629533lfu.4
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 06:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=rm17YSrotUSdRJ6BYuD2Ka29woyCrwxkkMypL8/+Zws=;
        b=R+QKwOYklID1n9atX296D0nCwG8KM3fO7//cRNML+HEH+UsM8OG1SL5DkZq0BCAUP8
         2M61zfE1D2iozuGtCmbcMH3zT3/V9en3m+ZgW1MNavcyBHEFx44+uTw8a8cUS8RmKuWj
         qr5bhJ5U0e5HeEzivlsJDga0OFc08Pw2T+9yg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=rm17YSrotUSdRJ6BYuD2Ka29woyCrwxkkMypL8/+Zws=;
        b=bHVS0EIYHhY10OqoFHHNp5EtedH0ADktIV+o5UFRFKDMZYvJv1zBDCqj5N7KWhb2T/
         3UA+COG0B+mrmMitupQAlbe4RE/NBaGagg54hL380gmgvREpO5CUZXFdqSaeYplaAliG
         t4L4I3al/9dAS0R0b/5Ci1KWNQ/5A2YIR9AYxz23Jik9Jo5vcA1ey8MwW0YSKo2wUGOk
         xPj7/rOXZKetOIks9E7RwS3qVC1NgZqC3T7k1aKaYUMoUook6avruDhTP7w4nC+ijN4+
         ij6elxxDmn9CpcdLH/KxKChZ4uP7RQd36ISZU3KNftoEyCcNy7ba++JOZVSLQmFkXF2/
         nXog==
X-Gm-Message-State: AOAM530wziih0pdRPkSU/DnkuAEo6BDQvw1IsayXbi4lVAn9+lBjGPye
        GcM5Q9YZL2C/mKfLACPQRwg7qA==
X-Google-Smtp-Source: ABdhPJymOuYy/bNslmfXFaem6ECNBIlJebCwoNJuz6tFnhk/Bq9TuuigUhywkJVmmTV0bg2FEpbLRw==
X-Received: by 2002:a05:6512:3e0a:b0:43c:8197:af34 with SMTP id i10-20020a0565123e0a00b0043c8197af34mr8338120lfv.141.1645281594928;
        Sat, 19 Feb 2022 06:39:54 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0f9c.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id r11sm666448ljk.40.2022.02.19.06.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 06:39:54 -0800 (PST)
References: <20220209184333.654927-1-jakub@cloudflare.com>
 <20220209184333.654927-3-jakub@cloudflare.com>
 <CAEf4BzaRNLw9_EnaMo5e46CdEkzbJiVU3j9oxnsemBKjNFf3wQ@mail.gmail.com>
 <e0999e46e5332ca79bdfe4d9b9d7f17e4366a340.camel@linux.ibm.com>
 <87fsohea8q.fsf@cloudflare.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: Cover 4-byte load from
 remote_port in bpf_sk_lookup
Date:   Sat, 19 Feb 2022 15:37:01 +0100
In-reply-to: <87fsohea8q.fsf@cloudflare.com>
Message-ID: <87wnhq6htx.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 05:11 PM +01, Jakub Sitnicki wrote:
> On Thu, Feb 17, 2022 at 03:18 PM +01, Ilya Leoshkevich wrote:
>> On Wed, 2022-02-16 at 13:44 -0800, Andrii Nakryiko wrote:
>>> On Wed, Feb 9, 2022 at 10:43 AM Jakub Sitnicki <jakub@cloudflare.com>
>>> wrote:
>
> [...]
>
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Load from remote_port field =
with zero padding (backward
>>> > compatibility) */
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val_u32 =3D *(__u32 *)&ctx->rem=
ote_port;
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (val_u32 !=3D bpf_htonl(bpf_=
ntohs(SRC_PORT) << 16))
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return SK_DROP;
>>> > +
>>>=20
>>> Jakub, can you please double check that your patch set doesn't break
>>> big-endian architectures? I've noticed that our s390x test runner is
>>> now failing in the sk_lookup selftest. See [0]. Also CC'ing Ilya.
>>
>> I agree that this looks like an endianness issue. The new check seems
>> to make little sense on big-endian to me, so I would just #ifdef it
>> out.
>
> We have a very similar check for a load from context in
> progs/test_sock_fields.c, which is not causing problems:
>
> static __noinline bool sk_dst_port__load_word(struct bpf_sock *sk)
> {
> 	__u32 *word =3D (__u32 *)&sk->dst_port;
> 	return word[0] =3D=3D bpf_htonl(0xcafe0000);
> }
>
> So I think I just messed something up here. Will dig into it.

Pretty sure the source of the problem here is undefined behaviour. Can't
legally shift u16 by 16 bits like I did in the `bpf_ntohs(SRC_PORT) <<
16` expression. Will fix.

