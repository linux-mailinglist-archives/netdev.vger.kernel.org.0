Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0944B3BFF
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 16:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiBMPSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 10:18:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbiBMPSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 10:18:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C0F85C37A
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 07:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644765475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EU0aBUqG+RdRFWk7yiQfXhjL54RqsubwuXU5pneRySc=;
        b=EzHKOqr2pPva6CrGy1XyLenicPuJc1bOlj5gC+UYlqU6+lyssU5BKEgN8vbuC6V0T53ciN
        VHlf3CO0x9z/29k5+9joHlc5sxV2DOHfnuVIQLaSlTvP8GBHJIxQcj6T+I4CbX30Hv3Yr3
        irUr9WitBAaqsxaDB2Sg8guvo1RR3Cg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-Wl2l4k5ZMFy8l0PihulUWA-1; Sun, 13 Feb 2022 10:17:52 -0500
X-MC-Unique: Wl2l4k5ZMFy8l0PihulUWA-1
Received: by mail-ed1-f70.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso8628130edt.20
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 07:17:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EU0aBUqG+RdRFWk7yiQfXhjL54RqsubwuXU5pneRySc=;
        b=PhnRk6e4d47wsq8BJx7nW93DcodhICP65FjdAVIf2jN6WAxE5BwXgI5pV9F1TpvdmZ
         eIMv9lBN0ow9eCd7/lt+jnC5j2qU0T6sQPAxo4DgebttEw0Z1glyEPXoz5BXA1nE5Pqb
         0j5fa4Z65juoF3YQdBurKQd8TrDMJSYNZY8YaEyMNS465FCCXo0ahSt1HGKlHgNhzKHV
         j9t7l31Pwqzwi3e7Cap5kXwnLJ3SjhM0GgNcH85FKx9ASK7+ObWSby/IlfJN6bN5r2IW
         nw9Z7dc60+YbHaUiK/vZAPPEMVG1ouBuDMfhH+vBkJXEDbIS3cOmPS6EIfqNM0oZhVRF
         JBYw==
X-Gm-Message-State: AOAM530F8g6GzzM8sUJvKvp0x5HjAvLNJLc6tcviiMTc7tqlrvFSXsFa
        4MQRygYLAdaOtctR0bizWb3t/b0fA7hYLsuws9bpSrVpb+iSwWsin4uIcZ34Gy1cIw7s7+JO2vo
        KdHfN8mRmMNrBdz34
X-Received: by 2002:aa7:d406:: with SMTP id z6mr11607261edq.66.1644765470269;
        Sun, 13 Feb 2022 07:17:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRv21PC9qBN2ndh1MgmPCJg6IqIv0t1Ag19zVpEkFQRZEl5LeCLTHRzpIsu1qiF9mdf4oxQQ==
X-Received: by 2002:aa7:d406:: with SMTP id z6mr11607165edq.66.1644765468966;
        Sun, 13 Feb 2022 07:17:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p19sm4805068ejx.30.2022.02.13.07.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 07:17:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 441D61031B1; Sun, 13 Feb 2022 16:17:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Zhiqian Guan <zhguan@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2] libbpf: Use dynamically allocated buffer
 when receiving netlink messages
In-Reply-To: <CAEf4BzYURbRGL2D-WV=VUs6to=024wO2u=bGtwwxLEKc6pmfhQ@mail.gmail.com>
References: <20220211234819.612288-1-toke@redhat.com>
 <CAEf4BzYURbRGL2D-WV=VUs6to=024wO2u=bGtwwxLEKc6pmfhQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 13 Feb 2022 16:17:47 +0100
Message-ID: <87h7927q3o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Feb 11, 2022 at 3:49 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> When receiving netlink messages, libbpf was using a statically allocated
>> stack buffer of 4k bytes. This happened to work fine on systems with a 4k
>> page size, but on systems with larger page sizes it can lead to truncated
>> messages. The user-visible impact of this was that libbpf would insist no
>> XDP program was attached to some interfaces because that bit of the netl=
ink
>> message got chopped off.
>>
>> Fix this by switching to a dynamically allocated buffer; we borrow the
>> approach from iproute2 of using recvmsg() with MSG_PEEK|MSG_TRUNC to get
>> the actual size of the pending message before receiving it, adjusting the
>> buffer as necessary. While we're at it, also add retries on interrupted
>> system calls around the recvmsg() call.
>>
>> v2:
>>   - Move peek logic to libbpf_netlink_recv(), don't double free on ENOME=
M.
>>
>> Reported-by: Zhiqian Guan <zhguan@redhat.com>
>> Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
>> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> Applied to bpf-next.

Awesome, thanks!

> One improvement would be to avoid initial malloc of 4096, especially
> if that size is enough for most cases. You could detect this through
> iov.iov_base =3D=3D buf and not free(iov.iov_base) at the end. Seems
> reliable and simple enough. I'll leave it up to you to follow up, if
> you think it's a good idea.

Hmm, seems distributions tend to default the stack size limit to 8k; so
not sure if blowing half of that on a buffer just to avoid a call to
malloc() in a non-performance-sensitive is ideal to begin with? I think
I'd prefer to just keep the dynamic allocation...

-Toke

