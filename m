Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6AC26CE02
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 23:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIPVIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 17:08:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726298AbgIPVID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 17:08:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600290474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/54H5boGPOw6PIuMrJAthQBR69fhyyzb/6j3eNXf2IE=;
        b=CUz2dJvtqZajCT527/gwmDpjZur1cZ+bUf2WpFV3JK3CkhtUp6Mgj8hRzuypdzTTAdoo57
        W0v2yIRnVDOKkDeu0aoSHdEuH4CcCoz81K7M0ObixDf1/q1RHh65VYDFrR+fstczGin1bg
        2ZKLryoK1Uv5lYNc83Yn9QFalx1sMmQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-zYsqCCUoNMqy52uNvP09aQ-1; Wed, 16 Sep 2020 17:07:51 -0400
X-MC-Unique: zYsqCCUoNMqy52uNvP09aQ-1
Received: by mail-wr1-f72.google.com with SMTP id v5so3000758wrs.17
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 14:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/54H5boGPOw6PIuMrJAthQBR69fhyyzb/6j3eNXf2IE=;
        b=cS0YvKgbkELvIbwwz04d8A25BNsPfY1xHA34Xsq5nCMu93eqr52LugS90XVjvKuOEk
         GFxeaXH4xXIC21AKE37EWUU1bq8wZpcNnMnW2GSBkNVGPKzeWu04T48ULa7vfosAnozt
         N3GwRe6ko5PnjXtP8Zkze2IcyeBYJPcOCPUUCBH+HVqkIudDBTsvXp7ZJetquXQ0Kygh
         p6GzZS14WvmeMVtRKpC3/3u5BCtFFroE/bs6EzJ093TgqjgBboLj7tF8LaY3GW8T2rVa
         dJo3iWZuees++MKaT8f7ww/a0KziU2TDmkpS2zDmhzkWJY2E1TRj9m5RzBhcC/Es8gWU
         iBAg==
X-Gm-Message-State: AOAM530qmCgsA4TqPnjZEMLTL0mAJDzXJQVdaB9G0sdObVbq4Cc3svWI
        El5R9rfp6H71hc+LlnrCmmVAeFdbPnWkEWIIExXfzj5LMhfSMU6RFzdBvTx0lROJOQG/dy7dPHR
        AuNAUaAHeTdh+h02j
X-Received: by 2002:a5d:6291:: with SMTP id k17mr28325422wru.130.1600290470609;
        Wed, 16 Sep 2020 14:07:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRIpLByKR9vlbbyb4rveY1q0jSfOuRdwKkvCTSqfg5buShe2kGa0NkbbkTrTS5aEe33zZZeg==
X-Received: by 2002:a5d:6291:: with SMTP id k17mr28325397wru.130.1600290470314;
        Wed, 16 Sep 2020 14:07:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w81sm7606143wmg.47.2020.09.16.14.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:07:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2DDAE183A90; Wed, 16 Sep 2020 23:07:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 2/8] bpf: verifier: refactor
 check_attach_btf_id()
In-Reply-To: <CAEf4BzbAsnzAUPksUs+bcNuuUPkumc15RLESu3jOGf87mzabBA@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017005916.98230.1736872862729846213.stgit@toke.dk>
 <CAEf4BzbAsnzAUPksUs+bcNuuUPkumc15RLESu3jOGf87mzabBA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Sep 2020 23:07:49 +0200
Message-ID: <87tuvxph0a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> The check_attach_btf_id() function really does three things:
>>
>> 1. It performs a bunch of checks on the program to ensure that the
>>    attachment is valid.
>>
>> 2. It stores a bunch of state about the attachment being requested in
>>    the verifier environment and struct bpf_prog objects.
>>
>> 3. It allocates a trampoline for the attachment.
>>
>> This patch splits out (1.) and (3.) into separate functions in preparati=
on
>> for reusing them when the actual attachment is happening (in the
>> raw_tracepoint_open syscall operation), which will allow tracing programs
>> to have multiple (compatible) attachments.
>>
>> No functional change is intended with this patch.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> I almost acked this, but found a problem at the very last moment. See
> below, along with few more comments while I have enough context in my
> head.

Right, will fix, thanks!

> BTW, for whatever reason your patches arrived with a 12 hour delay
> yesterday (cover letter received at 5am, while patches arrived at
> 6pm), don't know if its vger or gmail...

Ugh, sorry about that. I think it's an interaction between vger and the
Red Hat corporate mail proxy - it's really a mess. I'll try switching my
patch submissions to use a different SMTP server...

-Toke

