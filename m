Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4810C59D
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 10:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfK1JHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 04:07:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39531 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbfK1JHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 04:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574932023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fc+1aWU1n7L4x+QFUaTGUrJ8QZV6jxVGyjTh715dkvk=;
        b=MNJzXv5Xs4Tnawu6ekTk/NGZXTFeiebbGGK0qgqXwsu+c8DRa075AxlGH6dH+nY2SpQDw9
        /OadUeaF0ybFhI1yDW4viQCW46q8AjHftmHr/5J7Xhe3XMqPe6C1rvu0ns/J1Ig/+sP3Da
        VU0HQoIHEWIEV1/qDFENYa1Xd2EGEl0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-aNC-ObKsOfq-vZ0GBnULXw-1; Thu, 28 Nov 2019 04:07:01 -0500
Received: by mail-lj1-f198.google.com with SMTP id d16so4840948ljo.11
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 01:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DvrocL/1GRTCvaXxuQQF+aHOAoWJJA60RMKFIr0Cm60=;
        b=VrwEl1Fw5h3FM7IAH3HRehEc45LaZOqWvYQMPOZ51Vih7UuNbIJF7Ha0gm4RWqQEOH
         ti/qVbIgg+vDyT+EO0DOSGUcSSFMyyDcLvaUBjBGnXCfs4DPeqRJut31NycA6695qejW
         uaH+bON8LO5AC/aJWnhSetf9miJG8FrHnlozXpRgn0gU1/9c1E0m80t6+MQCdWPmfr/e
         /XX+sU5EE2BqkKwEeT25aTjTDbC1L5CVtf6yMGcQ45ir/m7lQ8HbjWh1C+OS8AF5hkuu
         SK8mqOZHY8sqhYUbCwlSsmvXkP6j7eK0xIqoTfGfvtds/pty4Q/9LBugO22ILdi0XEGe
         lkbQ==
X-Gm-Message-State: APjAAAXqAImVa/MKU4BQurAVqf5b/Jns++IHuGlnPedS3dPRkf6MCPdG
        e5Ioqwy+jpxYnDh6QWClo+V5n0GoaIAa4kjLNIxuIGTfowGDx8PRuhBjpAJLPEWi3t6N24SQIRx
        pe/yPoio0yL4+DW5H
X-Received: by 2002:a2e:914d:: with SMTP id q13mr7972518ljg.198.1574932019916;
        Thu, 28 Nov 2019 01:06:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwW+RawCEjX/SrVq5qTek4AHlvFYFzQbz7nhztA0ZhJ3BUPtFzw7uzugqmhWCO8ANdZ6bOJqQ==
X-Received: by 2002:a2e:914d:: with SMTP id q13mr7972501ljg.198.1574932019671;
        Thu, 28 Nov 2019 01:06:59 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o26sm8079173lfi.57.2019.11.28.01.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 01:06:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2377C1818BE; Thu, 28 Nov 2019 10:06:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
In-Reply-To: <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
References: <20191127094837.4045-1-jolsa@kernel.org> <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 28 Nov 2019 10:06:57 +0100
Message-ID: <87o8wwwery.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: aNC-ObKsOfq-vZ0GBnULXw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Nov 27, 2019 at 1:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>
>> hi,
>> adding support to link bpftool with libbpf dynamically,
>> and config change for perf.
>>
>> It's now possible to use:
>>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
>>
>> which will detect libbpf devel package with needed version,
>> and if found, link it with bpftool.
>>
>> It's possible to use arbitrary installed libbpf:
>>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/tmp/libb=
pf/
>>
>> I based this change on top of Arnaldo's perf/core, because
>> it contains libbpf feature detection code as dependency.
>> It's now also synced with latest bpf-next, so Toke's change
>> applies correctly.
>
> I don't like it.
> Especially Toke's patch to expose netlink as public and stable libbpf
> api.

Figured you might say that :)

> bpftools needs to stay tightly coupled with libbpf (and statically
> linked for that reason).
> Otherwise libbpf will grow a ton of public api that would have to be stab=
le
> and will quickly become a burden.

I can see why you don't want to expose the "internal" functions as
LIBBPF_API. Doesn't *have* to mean we can't link bpftool dynamically
against the .so version of libbpf, though; will see if I can figure out
a clean way to do that...

-Toke

