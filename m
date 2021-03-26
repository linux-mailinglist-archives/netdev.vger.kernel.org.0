Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5927134AB3B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhCZPPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:15:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230377AbhCZPOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616771694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4v95rX3kYO1IVqQdy9Phz6DaDgdigU99BqQjGC1b0N0=;
        b=MROSNXggPP+acz7XVFyUdzUVMWcH2r1hKCpAsy9/IFiKozmqdGZaPhSqJ+x6QDGGqnPBm7
        ae8E5Afs9+52tS60IaB4bkAx0D7L7M+hx6Pa8wjO+G8TSu2ikLoSSAKL+txiKOUmcdd69Q
        bvXeoIj6OsE76n/TKjf1oUXIWlwd5BI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-mD9EnBNlPkioawwqX06BZA-1; Fri, 26 Mar 2021 11:14:41 -0400
X-MC-Unique: mD9EnBNlPkioawwqX06BZA-1
Received: by mail-ed1-f71.google.com with SMTP id o24so4565940edt.15
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4v95rX3kYO1IVqQdy9Phz6DaDgdigU99BqQjGC1b0N0=;
        b=o0I/PTvtmmD4ebsmH5GnKu4mNmHOr7PEp3sWgEUOJsF/ZcsjUiF8HQcLze3fxkA1bJ
         c4zaFq0rqQSrfgyRosFeKPxsDblUGlQbi1PrRIfHBPgDUYdl63awYEgAjmWPxu9SVb92
         wpS8gYDrK9UaIVhaB15BC4HNe+6Dw468exKXkg2xfmiSIjEMEQUPjFhkiF80hcLFrcOG
         CcncEpfAAWDPSvrKur/iEgzjj5eqmBtJUDqJ+tpLsTkfNELpVucW/zvnJNEaMJ1hdZ41
         jcTSq8XkIIv+y/qTgeQFH9FdyhEPL3yYm1PFdN1MQT8TUFf8b/k4Jf2aKy98GbnC5/rQ
         R+Qg==
X-Gm-Message-State: AOAM532VvCoDJOGkAGjO7o7JwSrRBPxNeVBXaQHA7eCSSshNN2W8XDkr
        gixVCVl/GtsCt9/PnwtTevWvzjjDXRhnoQPRqHFbWvkbkWHhr1DMQCJcXhzXWw8fwAoVhiHh6Tm
        b7nqAwD7sWXffcbx0
X-Received: by 2002:a05:6402:1d92:: with SMTP id dk18mr15486249edb.161.1616771679734;
        Fri, 26 Mar 2021 08:14:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrkXa5nFOq0SwV4oG09lvBVwVp7oTNme95X134MZ7AUrfy3NhoAommku4Afk7qZZBsmAvwgg==
X-Received: by 2002:a05:6402:1d92:: with SMTP id dk18mr15486192edb.161.1616771679404;
        Fri, 26 Mar 2021 08:14:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q10sm4349651eds.67.2021.03.26.08.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:14:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ECE321801A3; Fri, 26 Mar 2021 16:14:37 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@fb.com>, Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 03/14] bpf: Support bpf program calling
 kernel function
In-Reply-To: <22ef1556-cebf-e1c9-8a83-251c08a1b465@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <20210325015142.1544736-1-kafai@fb.com> <87wntudh8w.fsf@toke.dk>
 <20210325230940.2pequmyzwzv65sub@kafai-mbp.dhcp.thefacebook.com>
 <87ft0icjhe.fsf@toke.dk> <22ef1556-cebf-e1c9-8a83-251c08a1b465@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Mar 2021 16:14:37 +0100
Message-ID: <877dluc5gi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <ast@fb.com> writes:

> On 3/26/21 3:11 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Martin KaFai Lau <kafai@fb.com> writes:
>>=20
>>> On Thu, Mar 25, 2021 at 11:02:23PM +0100, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
>>>> Martin KaFai Lau <kafai@fb.com> writes:
>>>>
>>>>> This patch adds support to BPF verifier to allow bpf program calling
>>>>> kernel function directly.
>>>>
>>>> Hi Martin
>>>>
>>>> This is exciting stuff! :)
>>>>
>>>> Just one quick question about this:
>>>>
>>>>> [ For the future calling function-in-kernel-module support, an array
>>>>>    of module btf_fds can be passed at the load time and insn->off
>>>>>    can be used to index into this array. ]
>>>>
>>>> Is adding the support for extending this to modules also on your radar,
>>>> or is this more of an "in case someone needs it" comment? :)
>>>
>>> It is in my list.  I don't mind someone beats me to it though
>>> if he/she has an immediate use case. ;)
>>=20
>> Noted ;)
>> No promises though, and at the rate you're going you may just get there
>> first. I'll be sure to ping you if I do start on this so we avoid
>> duplicating effort!
>
> That's great!
> Curious what use cases you have in mind?

Accessing conntrack data from XDP. Needed for OVS, and for building an
XDP-based forwarding fast-path that shares state with the regular kernel
stack. Details TBD, obviously, but we've been blocked on not having
access to anything in modules from BPF, so seeing that there's now a
path to that is delightful! :)

-Toke

