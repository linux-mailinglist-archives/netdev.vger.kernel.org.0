Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8AD269118
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgINQJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:09:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgINQJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600099730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ia4ewCI4oFF+VxRjo3xc7IuSBeMatuSZAzdFNZ3n8es=;
        b=Pxow0cbavKudhzQ/TEd0qfepacVC/PS7SLEVAQRvGhupVO3qiO9CLAq/eMwFk94FpQAxPF
        zKcS+1Jbr7gACYvxwdQzdqh4y3VQtg+KqLXGz7l9U6cT7CkvcpYCreWmbNhUJpw3sk57Pe
        I5yOqMWpBvnsSUbRvz9SZ9cUvhXjEQ8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516--jHqPXGRPmKyCFa-M-wolQ-1; Mon, 14 Sep 2020 12:08:46 -0400
X-MC-Unique: -jHqPXGRPmKyCFa-M-wolQ-1
Received: by mail-wm1-f69.google.com with SMTP id 189so173976wme.5
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ia4ewCI4oFF+VxRjo3xc7IuSBeMatuSZAzdFNZ3n8es=;
        b=T4791Gcmf6cldqI0b5DfF5tv/xS5uqgWXftH9I09+85hzwp2272UC1q00YndtKbAcA
         YQZJzsD8R4OKR1wFqobqtsyoim0lPvLvAzz6hOeV67cNj17WmuZpTyVw/5yvJJ5/BtWS
         es9demVxKuMOieDW0sc9QVM2CXYqs34nXLyKEmHPn/3s3mtRIUUrX01L/4AbfClQUcLm
         LxPi8Y6qIprjGmKvs1akZOwack52Pg7qboqkIJmxKIp1FxTDJ5PZzMGbVhVKs2VYCmzT
         BY9gCyphsbNd63W0EuTaPKAE4UMMY/dS8L95YSmwFYQz87E96/KB4V8rjaJLb9ANFnO3
         OrKQ==
X-Gm-Message-State: AOAM530rJKP23CYjmiUdeMUT3JQEAD4exdakMnGB3ZBZyhSY37decNgZ
        cSJSHKLjkQEuSfd9mLjsHS/ux+LiSZU4sKDImXKcUrqIbSxPdBpWqZ5yCL6FKdOVRNfpQ0YQztc
        qc9nzywDCacInXjqw
X-Received: by 2002:adf:ec86:: with SMTP id z6mr17050109wrn.109.1600099725016;
        Mon, 14 Sep 2020 09:08:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx59XZFvjJGkQOQQ/Xp1rTDTlbN5frlh+8ObEF+trFc4NjRO84bjSN9y0ME8NW/KtApm95dng==
X-Received: by 2002:adf:ec86:: with SMTP id z6mr17050088wrn.109.1600099724708;
        Mon, 14 Sep 2020 09:08:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t188sm21796643wmf.41.2020.09.14.09.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:08:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 871DC1829CB; Mon, 14 Sep 2020 18:08:43 +0200 (CEST)
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
Subject: Re: [PATCH RESEND bpf-next v3 4/9] bpf: support attaching freplace
 programs to multiple attach points
In-Reply-To: <CAEf4BzZMj0sPisgUZ+3qKvqaAxfzzRNHZTpoR-zuDXvKcY3URQ@mail.gmail.com>
References: <159981835466.134722.8652987144251743467.stgit@toke.dk>
 <159981835908.134722.4550898174324943652.stgit@toke.dk>
 <CAEf4BzZMj0sPisgUZ+3qKvqaAxfzzRNHZTpoR-zuDXvKcY3URQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 14 Sep 2020 18:08:43 +0200
Message-ID: <87imcgz6gk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Sep 11, 2020 at 3:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> This enables support for attaching freplace programs to multiple attach
>> points. It does this by amending UAPI for bpf_raw_tracepoint_open with a
>> target prog fd and btf ID pair that can be used to supply the new
>> attachment point. The target must be compatible with the target that was
>> supplied at program load time.
>>
>> The implementation reuses the checks that were factored out of
>> check_attach_btf_id() to ensure compatibility between the BTF types of t=
he
>> old and new attachment. If these match, a new bpf_tracing_link will be
>> created for the new attach target, allowing multiple attachments to
>> co-exist simultaneously.
>>
>> The code could theoretically support multiple-attach of other types of
>> tracing programs as well, but since I don't have a use case for any of
>> those, the bpf_tracing_prog_attach() function will reject new targets for
>> anything other than PROG_TYPE_EXT programs.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> It feels like using a semi-constructed bpf_tracing_link inside
> prog->aux->tgt_link is just an unnecessary complication, after reading
> this and previous patches. Seems more straightforward and simpler to
> store tgt_attach_type/tgt_prog_type (permanently) and
> tgt_prog/tgt_trampoline (until first attachment) in prog->aux and then
> properly create bpf_link on attach.

I updated v4 with your comments, but kept the link in prog->aux; the
reason being that having a container for the two pointers makes it
possible to atomically swap it out with xchg() as you suggested
previously. Could you please take a look at v4? If you still think it's
better to just keep two separate pointers (and add a lock) in prog->aux,
I can change it to that. But I'd rather avoid the lock if possible...

-Toke

