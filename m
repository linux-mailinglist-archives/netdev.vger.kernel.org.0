Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA35710A430
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 19:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfKZSuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 13:50:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26529 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726192AbfKZSuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 13:50:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574794248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0r4KWfIOtxgISfApasmXgGWya0QXrhQe0FmvwJZ3LCk=;
        b=DbQjbtZ6dLNlWnrB7grb///Q7m7FnK0AuzaDMFidDT1GA0lGtTp+pq/aQ24OdYRs3vG859
        lczNQ/pj0g79+6fkvKIcMGS6Ctk3SAox9h3bzYn3ps0usg/jgv7VyicTL8/9wwomJDsYFu
        y0WvKrZy8dIm6ydDfjLSISfb5u5Ejgg=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-1hOK4FovOUO0k469yKaZZA-1; Tue, 26 Nov 2019 13:50:48 -0500
Received: by mail-lf1-f71.google.com with SMTP id m2so4109919lfo.20
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 10:50:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=oJf7PTKEEbEjo8GcSBfvuP8BlJ48R6NcwJ+kR4IpGyQ=;
        b=oVKPnWf12gyggMFO1EVEWSvtqVU4+S36LyRI/dHBoLgITbUUX8qxDXWRbNOUGXQ6C4
         keMyOrltQu7ocACbsUFjhW9lDVstPp2R4bVQthmdQc9T8UwE/IIkjJDWkfte1eTy/6i8
         IGGFIzLcc5BkMT7nO7S24aONJ5hocnDXOjAdLoLLo1iu3iLsxod4GTJLONxgC5Xb56KF
         0e/SkFLGP8CdX3KBb811+ocQer+W2cEh5KlKFefKRqYi5nVYL65p75GJkVqOv80O46VS
         BY/h6TdGi+Lly+Bpqm3ZPTPNXf5qc1/4LKatMze0F22dAb78g4+10yZJi5mUYeUPNNzU
         XrRQ==
X-Gm-Message-State: APjAAAVCX9uXuWOstdo1vPICeBqs+22IOD1vVHfh01xQyWH3i+QwKkvr
        WhEZBb94PaHT3BhorkdrpLRHK9heJkXVIGnC8C2z4hLIshG0KASyBxjJYxTaR2N/46q8tk2aDiU
        uqW13x3UM2ceMFSJC
X-Received: by 2002:a2e:a0ce:: with SMTP id f14mr28710584ljm.241.1574794246177;
        Tue, 26 Nov 2019 10:50:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHUc+oquSTaDm4CLKd9afrY/tGbnKn6DtP9DUe78i1wuycX8Rquk69fvv3hGcR7RNE9dzAcw==
X-Received: by 2002:a2e:a0ce:: with SMTP id f14mr28710563ljm.241.1574794245996;
        Tue, 26 Nov 2019 10:50:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d24sm5904329ljg.73.2019.11.26.10.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 10:50:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2B69C1818C0; Tue, 26 Nov 2019 19:50:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
In-Reply-To: <20191126183451.GC29071@kernel.org>
References: <20191126151045.GB19483@kernel.org> <20191126154836.GC19483@kernel.org> <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 26 Nov 2019 19:50:44 +0100
Message-ID: <87d0dexyij.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 1hOK4FovOUO0k469yKaZZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:

> Em Tue, Nov 26, 2019 at 05:38:18PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n escreveu:
>> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
>>=20
>> > Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho de Melo esc=
reveu:
>> >> Hi guys,
>> >>=20
>> >>    While merging perf/core with mainline I found the problem below fo=
r
>> >> which I'm adding this patch to my perf/core branch, that soon will go
>> >> Ingo's way, etc. Please let me know if you think this should be handl=
ed
>> >> some other way,
>> >
>> > This is still not enough, fails building in a container where all we
>> > have is the tarball contents, will try to fix later.
>>=20
>> Wouldn't the right thing to do not be to just run the script, and then
>> put the generated bpf_helper_defs.h into the tarball?
>
> I would rather continue just running tar and have the build process
> in-tree or outside be the same.

Hmm, right. Well that Python script basically just parses
include/uapi/linux/bpf.h; and it can be given the path of that file with
the --filename argument. So as long as that file is present, it should
be possible to make it work, I guess?

However, isn't the point of the tarball to make a "stand-alone" source
distribution? I'd argue that it makes more sense to just include the
generated header, then: The point of the Python script is specifically
to extract the latest version of the helper definitions from the kernel
source tree. And if you're "freezing" a version into a tarball, doesn't
it make more sense to also freeze the list of BPF helpers?

-Toke

