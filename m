Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A38210D265
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfK2IZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:25:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726778AbfK2IZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575015900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dvXfLX+3YfaDzm1HU0+ZJqo+B1rhtfnbOz00s1KXV1o=;
        b=Pz11IWA8XkyEwfQp6GtCcNBW4SQ+4RR8f4zNhyyuew7nHLOzp9iBzuz+USPTv8AmHePCrf
        RAXMGnTAYBXDmWxlL9x0qRn9yrWOayf0Z/OTjtGdv0pdHI9aAfXStNmSGm/wjXE3qspr//
        jdJRC2B33WjQzKBzJDkf8aKqMVrWT1I=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-X_LIzVhCPHym8fJAb3g_og-1; Fri, 29 Nov 2019 03:24:57 -0500
Received: by mail-lj1-f200.google.com with SMTP id x24so5360079ljj.4
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 00:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NwdD649wYa06LDGBuYg0DJ+wk3uRgAP3a4OQ+w3b49w=;
        b=It9qPpURudQwzOqJ4ZIOy3Yey5cfWBykjB3xi/PyLsfY414S7+GDLnGm8N5eJiN140
         SHQagQGY8JJQeBaAgWN21lLh/AVGMGCzAdq2hToSYtwUAkzjRdwW2ua9FT0caDElE9ZN
         Ji3At2dDXdp4oLPFGP+/cT+yode/6+0RdKqghQKRkimN7Hxb9U9wCJtrx2HJY5yNbmuJ
         NDNpQbPWNgoVG9mLnBeQWhhIXjK8rWng9g++PUV5YDYyR1D8GKcQPdB9LiybTuCYcWov
         YX8y82ZtBCHYtnGtKd338wHYegv9NRsOjSuFwA0pcFaqA087bF94XZBNKz74G4ahpx7E
         5Maw==
X-Gm-Message-State: APjAAAWYk1XSsbj8lYFVcLa/T512MyD5n6n1V/CPfCpQkZdBbfJwEWC3
        Z+LN1mjlK2zGJ8SahkHI7Gifo7ttgmMScceCWplYqVk/BGnqu9jBbLWOZL3YRVBLz6xA7Y3+jHd
        JGaupiOVb0QjfCqTZ
X-Received: by 2002:a05:651c:1066:: with SMTP id y6mr37587995ljm.96.1575015896260;
        Fri, 29 Nov 2019 00:24:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqzwma2V8Jj7dmJeTFQjNtfe9nb4lzAVxmqseq3Dk5KXkNphde5I1fVA0wzjp/tU6YVbsQkmsA==
X-Received: by 2002:a05:651c:1066:: with SMTP id y6mr37587957ljm.96.1575015895795;
        Fri, 29 Nov 2019 00:24:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k22sm9701193lfm.48.2019.11.29.00.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 00:24:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2A94E1818BD; Fri, 29 Nov 2019 09:24:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH bpf v3] bpftool: Allow to link libbpf dynamically
In-Reply-To: <20191129081251.GA14169@krava>
References: <20191128145316.1044912-1-toke@redhat.com> <20191128160712.1048793-1-toke@redhat.com> <20191129081251.GA14169@krava>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 Nov 2019 09:24:53 +0100
Message-ID: <87v9r3um22.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: X_LIzVhCPHym8fJAb3g_og-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> On Thu, Nov 28, 2019 at 05:07:12PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>
> SNIP
>
>>  ifeq ($(srctree),)
>>  srctree :=3D $(patsubst %/,%,$(dir $(CURDIR)))
>> @@ -63,6 +72,19 @@ RM ?=3D rm -f
>>  FEATURE_USER =3D .bpftool
>>  FEATURE_TESTS =3D libbfd disassembler-four-args reallocarray zlib
>>  FEATURE_DISPLAY =3D libbfd disassembler-four-args zlib
>> +ifdef LIBBPF_DYNAMIC
>> +  FEATURE_TESTS   +=3D libbpf
>> +  FEATURE_DISPLAY +=3D libbpf
>> +
>> +  # for linking with debug library run:
>> +  # make LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/opt/libbpf
>> +  ifdef LIBBPF_DIR
>> +    LIBBPF_CFLAGS  :=3D -I$(LIBBPF_DIR)/include
>> +    LIBBPF_LDFLAGS :=3D -L$(LIBBPF_DIR)/$(libdir_relative)
>> +    FEATURE_CHECK_CFLAGS-libbpf  :=3D $(LIBBPF_CFLAGS)
>> +    FEATURE_CHECK_LDFLAGS-libbpf :=3D $(LIBBPF_LDFLAGS)
>> +  endif
>> +endif
>> =20
>>  check_feat :=3D 1
>>  NON_CHECK_FEAT_TARGETS :=3D clean uninstall doc doc-clean doc-install d=
oc-uninstall
>> @@ -88,6 +110,18 @@ ifeq ($(feature-reallocarray), 0)
>>  CFLAGS +=3D -DCOMPAT_NEED_REALLOCARRAY
>>  endif
>> =20
>> +ifdef LIBBPF_DYNAMIC
>> +  ifeq ($(feature-libbpf), 1)
>> +    # bpftool uses non-exported functions from libbpf, so just add the =
dynamic
>> +    # version of libbpf and let the linker figure it out
>> +    LIBS    :=3D -lbpf $(LIBS)
>
> nice, so linker will pick up the missing symbols and we
> don't need to check on particular libbpf version then

Yup, exactly. I verified with objdump that the end result is a
dynamically linked bpftool with LIBBPF_DYNAMIC is set, and a statically
linked one if it isn't; so the linker seems to be smart enough to just
figure out how to do the right thing :)

-Toke

