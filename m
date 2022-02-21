Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035844BEB0F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiBUSgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:36:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiBUSgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:36:08 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4182FC76
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:35:43 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id m14so20264376lfu.4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=aS5fwHISjksF1kH4Z52luCV4EMSblZ5592TnFHx6Dys=;
        b=KFCXm5AJ9pQZr8qU4QTrbkqqEgVxTT3rjTbjy6pBLto2Nk8smUu/B53Iz3QxhZ1i8d
         1qzDRAjOucVVOO51XoNDOViSjbwBjqkltx0YkuvYsI7V8+SUmxnJpayY4s1w+lLei862
         jBsso0FKt1t4Jf5mcWPBjAoFGwkWG7DouZE1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=aS5fwHISjksF1kH4Z52luCV4EMSblZ5592TnFHx6Dys=;
        b=u9wyflLxuimVTA+27d5VWzwZvy89EZoyYmtZLd8zWIMwA316WQQ/5C7fzzDiiWkxbS
         hUnodVKi0TsUqv0EeBtCljwnxbd0zKd/SlX4UfteNCxynkkYOji4IUN0v6rWJK8VFTZx
         XUefexvnh1KIH2WcTyF4KHFOThCTT9CSq+Ztp55IVouDVpT6NOLlCe0BQI3f+bOPt6od
         1/5i6rTwE+KuMcqki9rhwbhlR0T+zeWKA4dsoojcaAUNFJBbXh7wNnVlPDVfxITnxtpw
         KgtQs762PCCdn1KQIenF+9q9npDLHE2kJnKLbraofoeNnKTngr7KIrElMki8Zc9NZJpK
         v1jg==
X-Gm-Message-State: AOAM531kJTZBJNCE4By7N7C7MGIZWSwk6W7hN2zvzRjfzap94sfxKQnK
        Qe4Kwiu6yOgG/dLZHb3iSJrwyQ==
X-Google-Smtp-Source: ABdhPJy/40LA2vaguKuxP7Jlu18pnkxxWfJrG85/eQOWm0qTJKJ3lAey17/Vnx3KpE5I1qtOT1y4hA==
X-Received: by 2002:ac2:554f:0:b0:442:ddc3:73e5 with SMTP id l15-20020ac2554f000000b00442ddc373e5mr14615865lfk.64.1645468541582;
        Mon, 21 Feb 2022 10:35:41 -0800 (PST)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id e22sm711813ljk.103.2022.02.21.10.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:35:41 -0800 (PST)
References: <20220209184333.654927-1-jakub@cloudflare.com>
 <20220209184333.654927-3-jakub@cloudflare.com>
 <CAEf4BzaRNLw9_EnaMo5e46CdEkzbJiVU3j9oxnsemBKjNFf3wQ@mail.gmail.com>
 <e0999e46e5332ca79bdfe4d9b9d7f17e4366a340.camel@linux.ibm.com>
 <87fsohea8q.fsf@cloudflare.com> <87wnhq6htx.fsf@cloudflare.com>
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
Date:   Mon, 21 Feb 2022 19:34:50 +0100
In-reply-to: <87wnhq6htx.fsf@cloudflare.com>
Message-ID: <87zgmk2hkz.fsf@cloudflare.com>
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

On Sat, Feb 19, 2022 at 03:37 PM +01, Jakub Sitnicki wrote:
> On Thu, Feb 17, 2022 at 05:11 PM +01, Jakub Sitnicki wrote:
>> On Thu, Feb 17, 2022 at 03:18 PM +01, Ilya Leoshkevich wrote:
>>> On Wed, 2022-02-16 at 13:44 -0800, Andrii Nakryiko wrote:
>>>> On Wed, Feb 9, 2022 at 10:43 AM Jakub Sitnicki <jakub@cloudflare.com>
>>>> wrote:
>>
>> [...]
>>
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Load from remote_port field=
 with zero padding (backward
>>>> > compatibility) */
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val_u32 =3D *(__u32 *)&ctx->re=
mote_port;
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (val_u32 !=3D bpf_htonl(bpf=
_ntohs(SRC_PORT) << 16))
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return SK_DROP;
>>>> > +
>>>>=20
>>>> Jakub, can you please double check that your patch set doesn't break
>>>> big-endian architectures? I've noticed that our s390x test runner is
>>>> now failing in the sk_lookup selftest. See [0]. Also CC'ing Ilya.
>>>
>>> I agree that this looks like an endianness issue. The new check seems
>>> to make little sense on big-endian to me, so I would just #ifdef it
>>> out.
>>
>> We have a very similar check for a load from context in
>> progs/test_sock_fields.c, which is not causing problems:
>>
>> static __noinline bool sk_dst_port__load_word(struct bpf_sock *sk)
>> {
>> 	__u32 *word =3D (__u32 *)&sk->dst_port;
>> 	return word[0] =3D=3D bpf_htonl(0xcafe0000);
>> }
>>
>> So I think I just messed something up here. Will dig into it.
>
> Pretty sure the source of the problem here is undefined behaviour. Can't
> legally shift u16 by 16 bits like I did in the `bpf_ntohs(SRC_PORT) <<
> 16` expression. Will fix.

Proposed fix posted, but forgot to CC Ilya so linking here:

https://lore.kernel.org/bpf/20220221180358.169101-1-jakub@cloudflare.com/
