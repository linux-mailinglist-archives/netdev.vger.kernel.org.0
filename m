Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7DC4B5771
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356689AbiBNQwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 11:52:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349606AbiBNQwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:52:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FBC66514F
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644857553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dP8eN32n1fiHxfiddr1V4rwBMWajCg3fmMVlkZbIQQY=;
        b=ft1MreFBZjUQeJWydaUJzU96uvvJAn3cCCqH9032NtNOo59HasIZhjiK2aq7XzBEWj2NSQ
        JNOiRERr1jiziZ2+wCvkoOK8vOk5i8XQmc7hsu4EvVk7en85++VXvNsVWB51ErRi3CKn6n
        ec5g05Ph9M9YeZAKMAWyIZ6mSc8YUxY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-a-aTj4X1PBOEB3i9EBUojA-1; Mon, 14 Feb 2022 11:52:32 -0500
X-MC-Unique: a-aTj4X1PBOEB3i9EBUojA-1
Received: by mail-ej1-f71.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so6102235ejk.16
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:52:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dP8eN32n1fiHxfiddr1V4rwBMWajCg3fmMVlkZbIQQY=;
        b=CfA8MoxcdiKMK5+iDFjGjIAYN7IAbSM5Tl6kLNy2JPUcHF6uJYzpnA5BQ2taMJ4uj5
         NHjM/+eb17uvYz4vtMNSPKUf/0pWqJr5dp6FOUoJoVzTmteXKVPnlVif/KPTEe2HxMRQ
         tu05LZHJM5GDfaruyqt3FCU/+qUqZ+E5o+Xr7WAA1pn+Q4SViM+P+wmtfgzlmzZ/+T02
         pqs8h738k15Vr8gzVE7pGW1ZhVcDDQRE1kW+J1XwIM/EJCgj9YCb6rymSMy+ERuB5LXR
         zKNZlfE8VaKQhK4AxrFyYNSjGu9ehjyx0BcUJTIFpkH+th1KcU02dL5dWeLypd4044W0
         qL/A==
X-Gm-Message-State: AOAM533ntmQUXn7QlU3Ajt/P8AQtdGqy5f5It4fM3HLEDTVktsuqw+4d
        WR7g+KSYlP9Hqs80ka/LTsLpXH3JCLasisKPPgyZOl2hgTmSXNRnqYLnOKGXMQhJOUgolQJX6dm
        5WM6yEn07Sc+mjnQt
X-Received: by 2002:a05:6402:d41:: with SMTP id ec1mr527042edb.196.1644857549239;
        Mon, 14 Feb 2022 08:52:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyYq9uIsI/I6522dStfHliGP44+7CT0Kuo/G2z03byX2cX9GlXvpxjtLgsgwapGLtrqqKLb4Q==
X-Received: by 2002:a05:6402:d41:: with SMTP id ec1mr526879edb.196.1644857547235;
        Mon, 14 Feb 2022 08:52:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m5sm4686264ejl.198.2022.02.14.08.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 08:52:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5E12512E281; Mon, 14 Feb 2022 17:52:25 +0100 (CET)
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
In-Reply-To: <CAEf4BzZO=v8DJkPWibygAy6KAP5fWQZ_00XyKP_kVmpCxVH_Ag@mail.gmail.com>
References: <20220211234819.612288-1-toke@redhat.com>
 <CAEf4BzYURbRGL2D-WV=VUs6to=024wO2u=bGtwwxLEKc6pmfhQ@mail.gmail.com>
 <87h7927q3o.fsf@toke.dk>
 <CAEf4BzZO=v8DJkPWibygAy6KAP5fWQZ_00XyKP_kVmpCxVH_Ag@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 14 Feb 2022 17:52:25 +0100
Message-ID: <87a6et75me.fsf@toke.dk>
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

> On Sun, Feb 13, 2022 at 7:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Fri, Feb 11, 2022 at 3:49 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> When receiving netlink messages, libbpf was using a statically alloca=
ted
>> >> stack buffer of 4k bytes. This happened to work fine on systems with =
a 4k
>> >> page size, but on systems with larger page sizes it can lead to trunc=
ated
>> >> messages. The user-visible impact of this was that libbpf would insis=
t no
>> >> XDP program was attached to some interfaces because that bit of the n=
etlink
>> >> message got chopped off.
>> >>
>> >> Fix this by switching to a dynamically allocated buffer; we borrow the
>> >> approach from iproute2 of using recvmsg() with MSG_PEEK|MSG_TRUNC to =
get
>> >> the actual size of the pending message before receiving it, adjusting=
 the
>> >> buffer as necessary. While we're at it, also add retries on interrupt=
ed
>> >> system calls around the recvmsg() call.
>> >>
>> >> v2:
>> >>   - Move peek logic to libbpf_netlink_recv(), don't double free on EN=
OMEM.
>> >>
>> >> Reported-by: Zhiqian Guan <zhguan@redhat.com>
>> >> Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
>> >> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> ---
>> >
>> > Applied to bpf-next.
>>
>> Awesome, thanks!
>>
>> > One improvement would be to avoid initial malloc of 4096, especially
>> > if that size is enough for most cases. You could detect this through
>> > iov.iov_base =3D=3D buf and not free(iov.iov_base) at the end. Seems
>> > reliable and simple enough. I'll leave it up to you to follow up, if
>> > you think it's a good idea.
>>
>> Hmm, seems distributions tend to default the stack size limit to 8k; so
>> not sure if blowing half of that on a buffer just to avoid a call to
>> malloc() in a non-performance-sensitive is ideal to begin with? I think
>> I'd prefer to just keep the dynamic allocation...
>
> 8KB for user-space thread stack, really? Not 2MB by default? Are you
> sure you are not confusing this with kernel threads?

Ha, oops! I was looking in the right place, just got the units wrong;
those were kbytes not bytes, so 8M stack size. Sorry for the confusion :)

-Toke

