Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5506D265D3C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgIKKAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:00:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbgIKKAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 06:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599818405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WVo1WRAmc/BugDM1RHuU1sFqZsCYyVX+oKm++p7MNtE=;
        b=CpVhF2SkiQkVwWU19TUL/mmgnfXUe/YYJ6xRUKddKCKhER9xE8BzoK2a0UFktVdQ0gJfxe
        6VDbk4xYZ789ZEMfe1CJXLnsnLqwlObY5yjgmF8Emtf5cbv4aEaABRVechwqD80mkHJQnW
        KGrcA2OLvnd2Hz/T3Kfz83CExBdr2cE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-8Mgmv3s9MMWFbRlKLJxicQ-1; Fri, 11 Sep 2020 06:00:04 -0400
X-MC-Unique: 8Mgmv3s9MMWFbRlKLJxicQ-1
Received: by mail-wm1-f71.google.com with SMTP id a144so1157444wme.9
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 03:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=WVo1WRAmc/BugDM1RHuU1sFqZsCYyVX+oKm++p7MNtE=;
        b=nbM8cWpfksJGgwSXwUD3sHdWAo/FihVIN7t88ds7wb4Q4dHUj6L5mzfk0nM5I3AAUn
         UQ3PCkbqs/xe+nE8rZ+pf1ULslMQoPDJfv/aYbnSv4iHXcl6AP/z8sYNSkNzadyGWqSs
         0e0v6l4n29SUrBvbAur+b05WTeqevIV9VWad4IqGahkVyGNUOCSEKyghKe+AI4MV/CGk
         ZRTeFNINleC3pQlguttKc3vKdd6a0Bd8HsoD1vk9bKJjAsL1xPPNhRa064t4dKreE6+E
         NayNy/YFN0FXaeFmNxiPjWRQYz5daFkR9YQIPDR7fiV0zMtu5SXjJIj+V7moZkOlZ1XN
         gWDw==
X-Gm-Message-State: AOAM532OrMHe3J2cNBt7aMLKWU+epTYTSGvauOYg4UprYUM8LMrMfb5t
        7Vv87dxEQ7RpX59n2SIMGY5qIdySJp9XrKdW0p0Znsx7V8xdPLZX/F2Ioh0GJ3/Qnnq3NuO7sTt
        IcVSnoiXCJtOFqwo/
X-Received: by 2002:a5d:610d:: with SMTP id v13mr1192061wrt.23.1599818402848;
        Fri, 11 Sep 2020 03:00:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9Kzlf3JnagLklLcTXO7nPbBxKi78Wtsma6YzImQPJ5hRP6cUR+eePi1QhB11DY29QoqylAA==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr1192019wrt.23.1599818402496;
        Fri, 11 Sep 2020 03:00:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f1sm3751336wrt.20.2020.09.11.03.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 03:00:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B50FF1829D7; Fri, 11 Sep 2020 12:00:01 +0200 (CEST)
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
Subject: Re: [PATCH bpf-next v3 1/9] bpf: change logging calls from
 verbose() to bpf_log() and use log pointer
In-Reply-To: <CAEf4BzZ-K7Myp7_2a==ic5y+TRCFL4Gf4gGWwqm8yAb0icOi5g@mail.gmail.com>
References: <159974338947.129227.5610774877906475683.stgit@toke.dk>
 <159974339060.129227.10384464703530448748.stgit@toke.dk>
 <CAEf4BzZ-K7Myp7_2a==ic5y+TRCFL4Gf4gGWwqm8yAb0icOi5g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Sep 2020 12:00:01 +0200
Message-ID: <87d02sbplq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Sep 10, 2020 at 6:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> In preparation for moving code around, change a bunch of references to
>> env->log (and the verbose() logging helper) to use bpf_log() and a direct
>> pointer to struct bpf_verifier_log. While we're touching the function
>> signature, mark the 'prog' argument to bpf_check_type_match() as const.
>>
>> Also enhance the bpf_verifier_log_needed() check to handle NULL pointers
>> for the log struct so we can re-use the code with logging disabled.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> Only 4 out of 9 emails arrived, can you please resubmit your entire
> patch set again?

Sure, done :)

-Toke

