Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503D81B7BD4
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 18:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgDXQjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 12:39:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726849AbgDXQjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 12:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587746393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YP5fQIfakK3kVOUysWonSyI4ix0kqSe5LjhdeJGKKbg=;
        b=PXfgxrMMcHdRsQELOVPz5ww4bWQGOmnITbuXQqdOQo49xM2/GxGrcMLyP4nEG/ctCzxHSJ
        TlWHuTVmGdIFD3HrO0w6O9Gui6ZecLGsgDyHG9VIzU+aT7C4SGiFF0WlFWW0/v9YygJjjE
        VziA153cz6+TP1GVU21ixuTOGd1Zra8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-eftwSSbnOpeUlqPWicQCsQ-1; Fri, 24 Apr 2020 12:39:52 -0400
X-MC-Unique: eftwSSbnOpeUlqPWicQCsQ-1
Received: by mail-lj1-f199.google.com with SMTP id u2so1017632ljg.22
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 09:39:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YP5fQIfakK3kVOUysWonSyI4ix0kqSe5LjhdeJGKKbg=;
        b=tnDj/a5Yf867x4o8KcOuR+8AlPkFmZRE3A6hDBIVdKFOt3otCMrV/Rc79Ktd4Qcq4v
         JuPmkVtRsvsNHjbMCeYZz9Mvpz0x5z9X4cZX1aOZbz4IBgCoUWktXv4lGOd1DojsRjYQ
         MXSNjJjeo2lbYQnMKA5fc49jGGQLdC7NoznsbvX9pEar66pDyxpvy0pPMunTDbsFuln2
         fEPhwbhPftPVwY0yI9uSvOfrsXNyGvz8OwoY2us06cHYUDOVi8OKaxN0KMt4NtHVnbiV
         aZemjHfrXeArr4B0YaLk66UlJgR9UVP9XWbjMP+pntQpOPhtPlAKd5b5Wk2IGo3FbWy0
         c2nA==
X-Gm-Message-State: AGi0PuaMcZo2rkhJ6XeNkHaPK9h6+x+7pgZBGQ+/ZtLYM333Au5Nm+Lj
        +/6QvDrycR48ncQdRbONIEsC5SXdYJzA4btAU8rsuFjX4lTl6KzRnlt2oq1JEV0RA9/lmIQXHjG
        08yu99p/B7g9we9KF
X-Received: by 2002:a05:651c:2002:: with SMTP id s2mr5969535ljo.285.1587746390531;
        Fri, 24 Apr 2020 09:39:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypJjKm8cKsu77YxDHqoUMjAgTZDpwBduorMR+Ez/MNqw2eiSYRbuibCVxz0MW7sPJv0dXLcMRw==
X-Received: by 2002:a05:651c:2002:: with SMTP id s2mr5969519ljo.285.1587746390268;
        Fri, 24 Apr 2020 09:39:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c2sm4763872ljk.97.2020.04.24.09.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 09:39:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 916201814FF; Fri, 24 Apr 2020 18:39:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/10] bpf_link observability APIs
In-Reply-To: <CAEf4BzYFj_DcTkc6+cQ8_uoxw0Aw4f9E-YhFJpY4Ak+B8=Y1Sg@mail.gmail.com>
References: <20200424053505.4111226-1-andriin@fb.com> <87sggt3ye7.fsf@toke.dk> <CAEf4BzYFj_DcTkc6+cQ8_uoxw0Aw4f9E-YhFJpY4Ak+B8=Y1Sg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 18:39:48 +0200
Message-ID: <87imho3kiz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Apr 24, 2020 at 4:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > This patch series adds various observability APIs to bpf_link:
>> >   - each bpf_link now gets ID, similar to bpf_map and bpf_prog, by whi=
ch
>> >     user-space can iterate over all existing bpf_links and create limi=
ted FD
>> >     from ID;
>> >   - allows to get extra object information with bpf_link general and
>> >     type-specific information;
>> >   - implements `bpf link show` command which lists all active bpf_link=
s in the
>> >     system;
>> >   - implements `bpf link pin` allowing to pin bpf_link by ID or from o=
ther
>> >     pinned path.
>> >
>> > rfc->v1:
>> >   - dropped read-only bpf_links (Alexei);
>>
>> Just to make sure I understand this right: With this change, the
>> GET_FD_BY_ID operation will always return a r/w bpf_link fd that can
>> subsequently be used to detach the link? And you're doing the 'access
>> limiting' by just requiring CAP_SYS_ADMIN for the whole thing. Right? :)
>
> Right.

Great! SGTM; thanks for confirming :)

-Toke

