Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8666BDC2CB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408165AbfJRKbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:31:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38979 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729479AbfJRKbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 06:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571394679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RyWTDv2opN/j8TOXO1IF6a5hFBLZbgfuyG4kY3TepQo=;
        b=O1BYRkQ/UzHNahJMb1AizmRt8Rt1mdrrlQxshGOwBEXvAqSsrixxIi51Y8b7cN2rg5F1U/
        gazn0C8VKhB+dfcS/TXREpnRaWjEauake+uz4eXzolm0JoiPaL91d1wcfLn09GakJyWEgr
        8rj3WMXchSsC8ZULx1mbqIUM5ds3U/Q=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-bYe1HDDPO_S-fd1ov_vXug-1; Fri, 18 Oct 2019 06:31:15 -0400
Received: by mail-lf1-f69.google.com with SMTP id o2so24560lfb.12
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 03:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RyWTDv2opN/j8TOXO1IF6a5hFBLZbgfuyG4kY3TepQo=;
        b=IRz+EhYzgj/mFuM+7MsRScIgLemwfUpiOoz0W7W9SF+e2BpVYZT1hhQaT3lEdYs835
         K7PtZkrWElA1kBL7zGqnDdaunAds9lAMksDiWQHBA2eYrGwR6xxsBdwEcpnNv/COrwN2
         tdyYYyb6KRrAvr5iPpU3HRY0q8mGTe8spinUiEuxsOtaRapJrVgxrZtjKVm7LdjfSVR8
         byeXYHz16QejQvo+vNX1Qx3Es64TPBBN+c1yCvDRZ/XMQliF7/qvSxnaZ8y6zErikjXP
         JzBeFizW7ScYQOpiHCBibMqkSs8mkiVQV1zczYyUU2bxPQKE/rKSd/SUl6TW8AuKd0o/
         w/OA==
X-Gm-Message-State: APjAAAWfmK6G4AmURmfC6aVjePbH4iEmf2xu4ImeCNMiyFoTdAV3hy0K
        G95s74UwDzNS+u/4JJO287rZCFlElLuGoBNFG13oa2DyGNztTHSuNbY4vRlaLMYKkf5F5FCigF9
        NRGKHxZiFMhp6YbTg
X-Received: by 2002:a19:f018:: with SMTP id p24mr5669099lfc.51.1571394674220;
        Fri, 18 Oct 2019 03:31:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwXJquEiTp7cR5TCatXHt0waFvN649XaDhE7Bk4m1v1YrayJKyZgT850zi36wQxiZQsy+Xk6w==
X-Received: by 2002:a19:f018:: with SMTP id p24mr5669091lfc.51.1571394674045;
        Fri, 18 Oct 2019 03:31:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id q124sm2584065ljb.28.2019.10.18.03.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 03:31:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 78D721804C9; Fri, 18 Oct 2019 12:31:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH bpf] xdp: Handle device unregister for devmap_hash map type
In-Reply-To: <CAEf4BzbshfC2VXXbnWnjCA=Mcz8OSO=ACNSRNrNr2mHOm9uCmw@mail.gmail.com>
References: <20191016132802.2760149-1-toke@redhat.com> <CAEf4BzbshfC2VXXbnWnjCA=Mcz8OSO=ACNSRNrNr2mHOm9uCmw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Oct 2019 12:31:11 +0200
Message-ID: <87mudye45s.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: bYe1HDDPO_S-fd1ov_vXug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Oct 16, 2019 at 9:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> It seems I forgot to add handling of devmap_hash type maps to the device
>> unregister hook for devmaps. This omission causes devices to not be
>> properly released, which causes hangs.
>>
>> Fix this by adding the missing handler.
>>
>> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devic=
es by hashed index")
>> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  kernel/bpf/devmap.c | 34 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>>
>
> [...]
>
>> +
>> +               while (dev) {
>> +                       odev =3D (netdev =3D=3D dev->dev) ? dev : NULL;
>> +                       dev =3D hlist_entry_safe(rcu_dereference_raw(hli=
st_next_rcu(&dev->index_hlist)),
>
> Please run scripts/checkpatch.pl, this looks like a rather long line.

That was a deliberate departure from the usual line length, actually. I
don't think it helps readability to split that into three lines just to
adhere to a strict line length requirement...

-Toke

