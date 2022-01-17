Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BED84910A2
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 20:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241867AbiAQTZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 14:25:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233567AbiAQTZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 14:25:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642447542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U7zgtcbyOQ2IQF61UyyXlGKr5QTHAhLGBJ9c6uw19tY=;
        b=RvMctataiwi7DfenKA5s5EE6ReTa7Fk/Atfxdbyna1c9xX4MzOmN4kCNrLV40lELtw6W/1
        h9xzTOcttuj5zKkwtsEiDE7T869yI6tUuUxbrfQ87D8CopqZrKLcq09U3iDvODYaN2Emk8
        7qRrZzuA/AvPcb7nbvJuWHJNHzDKxmY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-mqQfbAlaMembjufPWyOEnw-1; Mon, 17 Jan 2022 14:25:40 -0500
X-MC-Unique: mqQfbAlaMembjufPWyOEnw-1
Received: by mail-ed1-f70.google.com with SMTP id s9-20020aa7d789000000b004021d03e2dfso4701497edq.18
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 11:25:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U7zgtcbyOQ2IQF61UyyXlGKr5QTHAhLGBJ9c6uw19tY=;
        b=wRELp4F2nTyekajLG4RMMnPpDtUG832INXtq70YHqV8AtS5/TGHDHn/RZmtTLPFNUZ
         Wk+twNdIqWbQlO9wvXimfeN7nmBQBL5kQJfIDF1kcspIbcXTqN1/ogO2nwM6iwrIBIXI
         4ArOn7obRT2u6cVEtV7FfnGD6oiRompKP3Id/OuLkfcfoxJ9keAaJmeaP3BV6jm0tvWU
         3PxJtxbLFJt2vke94UrTnnw20ZLzPt58+Dk1adFkwOZ1npXI2sh63oDwL7zEHBitdbOL
         A0u7SW7mmrucdFe8wY12eRgA5WldQdr7VjrzhqzNn3v7B00+1e/TFdWMsJtUG047qXQz
         lVbQ==
X-Gm-Message-State: AOAM5313vukcrmBESM2tXbarUOn753cR9hKdT/9y/2pnXmXLrV/0PTLc
        gkxQ/nmkpfEsRwHdGJmO7rq+Euxes8nKKmR8MJnZCt3OvhklEfJScBXC9Vx2WBmBPYHvIZh05yB
        bZep/s9AVYWqQVhr2
X-Received: by 2002:a05:6402:2706:: with SMTP id y6mr22018978edd.308.1642447539431;
        Mon, 17 Jan 2022 11:25:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYVNVfAcgJ2llPu7a/nMc/gn1UUYw9BssoK8m78sMP210nEi4Em2ltbJE5yjxFrlh7blWXyA==
X-Received: by 2002:a05:6402:2706:: with SMTP id y6mr22018950edd.308.1642447539235;
        Mon, 17 Jan 2022 11:25:39 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id u12sm5442243eda.56.2022.01.17.11.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 11:25:38 -0800 (PST)
Date:   Mon, 17 Jan 2022 20:25:37 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jussi Maki <joamaki@gmail.com>, Hangbin Liu <haliu@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] bpf/selftests: Fix namespace mount setup in tc_redirect
Message-ID: <YeXCsTWsvE+a1cld@krava>
References: <20220104121030.138216-1-jolsa@kernel.org>
 <CAEf4BzZK1=zdy1_ZdwWXK7Ryk+uWQeSApcpxFT9yMp4bRNanDQ@mail.gmail.com>
 <Ydabtmk+BmzIxKwJ@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ydabtmk+BmzIxKwJ@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 08:35:18AM +0100, Jiri Olsa wrote:
> On Wed, Jan 05, 2022 at 12:40:34PM -0800, Andrii Nakryiko wrote:
> > On Tue, Jan 4, 2022 at 4:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > The tc_redirect umounts /sys in the new namespace, which can be
> > > mounted as shared and cause global umount. The lazy umount also
> > > takes down mounted trees under /sys like debugfs, which won't be
> > > available after sysfs mounts again and could cause fails in other
> > > tests.
> > >
> > >   # cat /proc/self/mountinfo | grep debugfs
> > >   34 23 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
> > >   # cat /proc/self/mountinfo | grep sysfs
> > >   23 86 0:22 / /sys rw,nosuid,nodev,noexec,relatime shared:2 - sysfs sysfs rw
> > >   # mount | grep debugfs
> > >   debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
> > >
> > >   # ./test_progs -t tc_redirect
> > >   #164 tc_redirect:OK
> > >   Summary: 1/4 PASSED, 0 SKIPPED, 0 FAILED
> > >
> > >   # mount | grep debugfs
> > >   # cat /proc/self/mountinfo | grep debugfs
> > >   # cat /proc/self/mountinfo | grep sysfs
> > >   25 86 0:22 / /sys rw,relatime shared:2 - sysfs sysfs rw
> > >
> > > Making the sysfs private under the new namespace so the umount won't
> > > trigger the global sysfs umount.
> > 
> > Hey Jiri,
> > 
> > Thanks for the fix. Did you try making tc_redirect non-serial again
> > (s/serial_test_tc_redirect/test_tc_redirect/) and doing parallelized
> > test_progs run (./test_progs -j) in a tight loop for a while? I
> > suspect this might have been an issue forcing us to make this test
> > serial in the first place, so now that it's fixed, we can make
> > parallel test_progs a bit faster.
> 
> hi,
> right, will try

so I can't reproduce the issue in the first place - that means without my
fix and with reverted serial_test_tc_redirect change - by running parallelized
test_progs, could you guys try it?

jirka

