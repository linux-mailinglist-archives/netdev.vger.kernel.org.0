Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4256010EEEC
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfLBSJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:09:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41351 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727453AbfLBSJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575310141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4ecEttM3yApxyxrsr44NMQb+oeialaWZ1R4NWHga6Y=;
        b=WZhxTDuDjU0wiZug6+8AoXZKGF5uYFMkTOeBHxYfqKTp+utizSJzN9MTVRKIilfeTyR0BN
        8FVkgqdgRSkh+UEocQII3nu6K52HJ3t5qVLKCZxYzL32zc+8VRHh2FgTvUF340N/JoMB/l
        fTu2YeRuVK6uwZQwRLOZqNTEIf1CpmE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-TQji6zNfNRKtNplL8pQPNg-1; Mon, 02 Dec 2019 13:08:57 -0500
Received: by mail-lj1-f200.google.com with SMTP id y18so55410ljj.16
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 10:08:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R3A1rQuYRQ18AFn43+yCBqk/Ud+1TsgtYotLFNawFuU=;
        b=H1ORRyzqQVv6wSPZk42P4PvtEkEQnPLETRz/hduCgrGY4T8onDC0U+JNy3m1nLPR/N
         T52nS79y73/2eImzU5p6vHwttN2B7OfUMeNgVb9+MSeDHrll+Zyrk5IUpz/y5vUxrh9q
         hk5AHw0HNG8Pfb9mS+22GNGxXvWJLNpv8Wza3s+tP7SC7rlN5b3JTWTzAd5U//ltCVCe
         uJtINN6jIFfab8NyFfOO5nOefdZqFbaa0UDB2NfTX4FW6mIzQGA1UcLTdjPME6VqUUdC
         8lItJeg/UW7zgOu+iW8hAjPqG72vQhrphHo0ewZqNSvyly35rPH1+95ws8YGlrMFILPc
         DOkA==
X-Gm-Message-State: APjAAAVtkXJzYZ3S8sD5b29UG/oDZNKn699ZU8xQ/A5+ek6uFq2os5/e
        //s+5BtZbkBQai9g4uLBHrVjhSW45NvH2ARILDBBfS9oyHBUKXdr9YlPfgt5ikxEfBErFRR712i
        ByrW9u7uLYjBpkKgl
X-Received: by 2002:ac2:5931:: with SMTP id v17mr202404lfi.166.1575310135583;
        Mon, 02 Dec 2019 10:08:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqw+ErVGcirRgq/taxG0hc0PK3IZELxdIQ1H+CTFmxm/d8vQkPE9sNJgKnUenWoxN34oySG/8A==
X-Received: by 2002:ac2:5931:: with SMTP id v17mr202380lfi.166.1575310135338;
        Mon, 02 Dec 2019 10:08:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v2sm148047ljv.70.2019.12.02.10.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:08:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AE3941804D1; Mon,  2 Dec 2019 19:08:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
In-Reply-To: <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
References: <20191127094837.4045-1-jolsa@kernel.org> <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Dec 2019 19:08:52 +0100
Message-ID: <87zhgappl7.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: TQji6zNfNRKtNplL8pQPNg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>
>> hi,
>> adding support to link bpftool with libbpf dynamically,
>> and config change for perf.
>>
>> It's now possible to use:
>>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
>
> I wonder what's the motivation behind these changes, though? Why is
> linking bpftool dynamically with libbpf is necessary and important?
> They are both developed tightly within kernel repo, so I fail to see
> what are the huge advantages one can get from linking them
> dynamically.

Well, all the regular reasons for using dynamic linking (memory usage,
binary size, etc). But in particular, the ability to update the libbpf
package if there's a serious bug, and have that be picked up by all
utilities making use of it. No reason why bpftool should be special in
that respect.

-Toke

