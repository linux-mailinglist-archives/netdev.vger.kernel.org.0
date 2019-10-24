Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABC6E3B61
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504143AbfJXSzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:55:17 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:35526 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504111AbfJXSzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 14:55:16 -0400
Received: by mail-il1-f195.google.com with SMTP id p8so13698515ilp.2;
        Thu, 24 Oct 2019 11:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2jIZ3P8SxC61SeUyKQQ+E+2OIhkUpA8TOkD/mduVVcI=;
        b=AcHR0SlzTBIqSSa1VISld28KgVkOH8Upse82N/gZAO3JhnDZRnL+0KaTg8uMciXIrj
         uzkAJAfm4p99zZ2eKl5x5l0lykkdiIyOjD5/XO380DmN/gK4sdzbZssEZHYrIwcz9CWN
         STPriGVbzDvGlNqqVsI2cDGMzUzYu2keYdU6+1ASn2Nj7TPkIRnkHJO9xAze07VxqivP
         DTlyH26ttUCYO9Vm6ymxLdVjZrDBu8HGH3ERTqJJIGpd9olkNQjBj38/dRQ/7P08KwF2
         0siyYRj0egK6MbOiLLo3MPANMv6Z4/IZXjtbt8AFG+NYKv9Zw7IHjv7dRIiF4X8jjp2/
         NXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2jIZ3P8SxC61SeUyKQQ+E+2OIhkUpA8TOkD/mduVVcI=;
        b=sfV72CxONvo8CYsZd2TU5QkbssyoHZWRutfOWgAYcXXiM+XecrXPbN9ftf792Bqsbb
         T+GNhI9J5kWnKbpfDSSYriqfgHiyxfw8nF0KT5m2DO4RBDgjnOaMQZJ6BCdvqVRkddMj
         R0nNqAH7F4aOIGHQEStKfTyeisr0CdAnOLE7SyAKJdVQhLwnuK3CoiVI1QsSnpoM07rW
         qGnie0dGbMyEvDzdR0WvAxv3pbBYPQI6s7x/jJ4/VkDWTxZDmF7wyQ6waL90ZNb9DkfY
         cl+e2dH/HpUnpNsLLOSh8Us7UQpFKRB/vNSemXXULKTXXaBvYlduZV9FIA6X7LkFfTBD
         e5BQ==
X-Gm-Message-State: APjAAAWMeDcIEDwQETFG+TC7dqlyTw62a/xPLDBBAf5Ra+J4uAEYYnJi
        85gef6rZaNENgDSKJ1RnaY0=
X-Google-Smtp-Source: APXvYqyY2fTID2j64DIo2eZveuvMWNs/3p0uSWBq9Muubhj2u7fdfzuc5peePzWtTHF2chr437YXRw==
X-Received: by 2002:a92:4514:: with SMTP id s20mr49367450ila.232.1571943314243;
        Thu, 24 Oct 2019 11:55:14 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s70sm844412ili.13.2019.10.24.11.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 11:55:13 -0700 (PDT)
Date:   Thu, 24 Oct 2019 11:55:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <5db1f389aa6f2_5c282ada047205c012@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzbBoE=mVyxS9OHNn6eSvfEMgbcqiBh2b=nVmhWiLGEBNQ@mail.gmail.com>
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
 <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
 <20191022072023.GA31343@pc-66.home>
 <CAEf4BzbBoE=mVyxS9OHNn6eSvfEMgbcqiBh2b=nVmhWiLGEBNQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Tue, Oct 22, 2019 at 12:20 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On Mon, Oct 21, 2019 at 10:07:59PM -0700, John Fastabend wrote:
> > > Andrii Nakryiko wrote:
> > > > On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > > > > kprobes programs on older kernels.
> > > >
> > > > My main concern with this is that this code is born bit-rotten,
> > > > because selftests are never testing the legacy code path. How did you
> > > > think about testing this and ensuring that this keeps working going
> > > > forward?
> > >
> > > Well we use it, but I see your point and actually I even broke the retprobe
> > > piece hastily fixing merge conflicts in this patch. When I ran tests on it
> > > I missed running retprobe tests on the set of kernels that would hit that
> > > code.
> >
> > If it also gets explicitly exposed as bpf_program__attach_legacy_kprobe() or
> > such, it should be easy to add BPF selftests for that API to address the test
> > coverage concern. Generally more selftests for exposed libbpf APIs is good to
> > have anyway.
> >
> 
> Agree about tests. Disagree about more APIs, especially that the only
> difference will be which underlying kernel machinery they are using to
> set everything up. We should ideally avoid exposing that to users.

Maybe a build flag to build with only the older style supported for testing?
Then we could build, test in selftests at least. Be clear the flag is only
for testing and can not be relied upon.

> 
> > Cheers,
> > Daniel
