Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B591B4CB15A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245308AbiCBVfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245094AbiCBVfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:35:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D1DB4665A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646256887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5WupCZ6aFmy9XKTwO56vm8BsGbMlpzmFfI9+PMks/QM=;
        b=SCU86IDPU8JpUKNClxgaJJULkaHNWeI/OchJhR/YQFjBm/ED5an4KVM0SPbsbZf7TvBV/O
        gM8a4pe5eanbKq3Hlo7aktuQCbuIgP+RoH+/yin5NnmkrFbScjTA6rDtC2HkPFFKVYSlu1
        8wE4+1nbZYvpRMzQpeDgJ5h7Gpouhaw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-HnwIryLeODidM7a8iGGr7A-1; Wed, 02 Mar 2022 16:34:46 -0500
X-MC-Unique: HnwIryLeODidM7a8iGGr7A-1
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso1681546edt.20
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 13:34:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=5WupCZ6aFmy9XKTwO56vm8BsGbMlpzmFfI9+PMks/QM=;
        b=agDcVFlSB2RP9tw5zY28NM2l2a3vmEVqBwxZENN8WROdVZIK0ikrCNsJZP+EMYzZpa
         dnDnsnwbWvTjkc9ssVfzlqYWV30jjI3evT04oKKRu7BjMObdQirfEXhe/XXG5CWA4o99
         ah1SJMztKAVnir5mYmI0vMqDpAhGgIqf5hCHaW1w4rRDoEO4jY1kFoYFhdsihgOlRVYq
         hweUZR4bOy93SONd/qKPFzIe4a2AtAaQkCol+bNXehgXbLT9ia/AQCKGct/WTziPfCi0
         4s9ylVtGUU3l4EuWh1AfRBk7fK2hEDb3vRBFJ/zKiwMx3qoUvl0j6iwKW8BqZRM95GCN
         ftdA==
X-Gm-Message-State: AOAM533iDPMq14EpxnxFXJkvxR9yzU9IapAEQSpUVRDfL1weXzTOy+bo
        A0XvbqMkZAGk+7N8h3t8T/HRVvGN4JohA/JfipHGAqkh36YV7PY3u0yame/mYd0q0zgzuKAsXC6
        s8jZu3qKP3goR/fib
X-Received: by 2002:a17:907:3e19:b0:6da:86b9:acc with SMTP id hp25-20020a1709073e1900b006da86b90accmr1238125ejc.655.1646256884070;
        Wed, 02 Mar 2022 13:34:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcayKVAMFXQkrG7XvksKP1j+QP+060buGhwLWrqFAmSuFl4FDYRfszoadjhe+++DTe9PMNQg==
X-Received: by 2002:a17:907:3e19:b0:6da:86b9:acc with SMTP id hp25-20020a1709073e1900b006da86b90accmr1238062ejc.655.1646256882831;
        Wed, 02 Mar 2022 13:34:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o7-20020a17090608c700b006cef23cf158sm31871eje.175.2022.03.02.13.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:34:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 44E70131929; Wed,  2 Mar 2022 22:34:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 2/5] Documentation/bpf: Add documentation
 for BPF_PROG_RUN
In-Reply-To: <20220302190440.t5cvezlkg7ynajam@ast-mbp.dhcp.thefacebook.com>
References: <20220218175029.330224-1-toke@redhat.com>
 <20220218175029.330224-3-toke@redhat.com>
 <20220302190440.t5cvezlkg7ynajam@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Mar 2022 22:34:41 +0100
Message-ID: <87bkyodoni.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Feb 18, 2022 at 06:50:26PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> This adds documentation for the BPF_PROG_RUN command; a short overview of
>> the command itself, and a more verbose description of the "live packet"
>> mode for XDP introduced in the previous commit.
>
> Overall the patch set looks great. The doc really helps.

Great, thanks!

> One nit below.
>
>> +- When running the program with multiple repetitions, the execution wil=
l happen
>> +  in batches, where the program is executed multiple times in a loop, t=
he result
>> +  is saved, and other actions (like redirecting the packet or passing i=
t to the
>> +  networking stack) will happen for the whole batch after the execution=
. This is
>> +  similar to how execution happens in driver-mode XDP for each hardware=
 NAPI
>> +  cycle. The batch size defaults to 64 packets (which is same as the NA=
PI batch
>> +  size), but the batch size can be specified by userspace through the
>> +  ``batch_size`` parameter, up to a maximum of 256 packets.
>
> This paragraph is a bit confusing.
> I've read it as the program can do only one kind of result per batch and
> it will apply to the whole batch.
> But the program can do XDP_PASS/REDIRECT in any order.
> Can you make "the result is saved" a bit more clear?

Yeah, re-reading it now, I see what you mean; will try to make it
clearer...

-Toke

