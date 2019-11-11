Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C109F7076
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 10:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfKKJY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 04:24:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbfKKJY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 04:24:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573464296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Nj1jXUErntBq71VW4mO6DE48JXy/eVyWGhHD6EUL/w=;
        b=JL7eEtTEiH0JO2ROBnq+E8u6EwcOobu8L0kafeeq4GXaT7Wxpm/Ubgi0hq1vn3Zlsy38HD
        i3rcGr7ScopVWhgWjhsN9w/6VbpYTTgvxwvX2uJcY6vypivmn5Vj0naq5A29lqJ1pYjwKs
        ZM7gfI/huxO3gHD6sHBbfngJ47WwHF8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-AWZAyaH5PJik0xI2QaJLvw-1; Mon, 11 Nov 2019 04:24:53 -0500
Received: by mail-ed1-f72.google.com with SMTP id l1so9814735ede.1
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 01:24:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rK/IE93Ia0gre+In92ABappDCl0/7Lq4UUq1d9yP+l8=;
        b=pPF25sy11u3pfBcVNxV9b97u8Vc05bvSfsg+1iwGbxUDI576L1GucV+uS9WTocm3Mu
         Eqlb6cvBX4jT9XjV4CwSXe3sPGlP2kA6jvFTCMu3itR3g/+E+ZcJeQCH9Rdx4xyclsnU
         Ldb+fpioYTRQ8ndX5noQjS6lE4YsyINHcrBmZ83Y8E5twy9xALd8Si5efk+jZrpzo5e8
         Kf+r3BLbkc9m3f1K5Trw+IH0bTYIEfh/7Mie3KkbPxJbZ8STxXFX3ajCryumJQGa124l
         XuYEf9k5ibmibNYAGY6N7+q80/GBl+CAtM7t9eHnUet7O2LuKaooBQis7vbANscrEjwJ
         SPwA==
X-Gm-Message-State: APjAAAVTx1g162yV5xSLs8gdT7L7n4G3b1q+yIDlOG59Nfj3RBfqvxds
        aYSt/5BbZBKJQfRXSgbaUoGhR1OqwryPHlQbGXKvHeWIEQY18gG0HHfzyold3C0yCkFcZuHwD77
        NzzbiEeAFBlBllFYp
X-Received: by 2002:a17:907:205b:: with SMTP id pg27mr20914426ejb.144.1573464292322;
        Mon, 11 Nov 2019 01:24:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqyY6vIm3jnwFOPQ5+TYCcaRZda+A8DqvSf5r53dbg58NtJln5wV1fGdG9IluCcVLn8vPcWIUw==
X-Received: by 2002:a17:907:205b:: with SMTP id pg27mr20914421ejb.144.1573464292138;
        Mon, 11 Nov 2019 01:24:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id h3sm145062ejp.11.2019.11.11.01.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 01:24:51 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E1A761803C7; Mon, 11 Nov 2019 10:24:50 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <thoiland@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] samples: bpf: fix outdated README build command
In-Reply-To: <CAEf4BzYRqeg5vFm+Ac2TVVeAw=N+qhosy5qF9Dr_ka3hn8DsPg@mail.gmail.com>
References: <20191110081901.20851-1-danieltimlee@gmail.com> <CAEf4BzYRqeg5vFm+Ac2TVVeAw=N+qhosy5qF9Dr_ka3hn8DsPg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 11 Nov 2019 10:24:50 +0100
Message-ID: <87bltircil.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: AWZAyaH5PJik0xI2QaJLvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sun, Nov 10, 2019 at 12:19 AM Daniel T. Lee <danieltimlee@gmail.com> w=
rote:
>>
>> Currently, building the bpf samples under samples/bpf directory isn't
>> working. Running make from the directory 'samples/bpf' will just shows
>> following result without compiling any samples.
>>
>
> Do you mind trying to see if it's possible to detect that plain `make`
> is being run from samples/bpf subdirectory, and if that's the case,
> just running something like `make M=3Dsamples/bpf -C ../../`? If that's
> not too hard, it would be a nice touch to still have it working old
> (and intuitive) way, IMO.

I think it's just the M=3D that's missing. Tentatively, the below seems to
work for me (I get some other compile errors, but I think that is
unrelated).

-Toke


diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 8a9af3ab7769..48e7f1ff7861 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -246,7 +246,7 @@ endif
=20
 # Trick to allow make to be run from this directory
 all:
-       $(MAKE) -C ../../ $(CURDIR)/ BPF_SAMPLES_PATH=3D$(CURDIR)
+       $(MAKE) -C ../../ M=3D$(CURDIR) BPF_SAMPLES_PATH=3D$(CURDIR)
=20
 clean:
        $(MAKE) -C ../../ M=3D$(CURDIR) clean

