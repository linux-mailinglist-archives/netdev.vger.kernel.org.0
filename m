Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F2F1AD218
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgDPVpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgDPVpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 17:45:38 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65E43221F4;
        Thu, 16 Apr 2020 21:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587073537;
        bh=P7wZo1p241YIkVWUglCQI/DNZgi7LsWHvliQUsJOCiQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ueN6cjSBZw8hrgqxJA3wRCKDOs/jOxFe0+8GbHuFbv9TPj9TAbHnl04EV95ffev2F
         TDAJ0ZPP/4TIqJSXpYg8+EuoyU+qQYetzBieYTx5VVcZB8WNZKjIrBSc0eWCgiJ4I5
         dGn8ZdTS6nWrwZn4maz1IAAWG9xzD4pcwBSLifCE=
Received: by mail-lf1-f42.google.com with SMTP id w145so61974lff.3;
        Thu, 16 Apr 2020 14:45:37 -0700 (PDT)
X-Gm-Message-State: AGi0PuZYMdiuyl/yRXwrY3aawl1Vrx0L5adPad/gHjofQxmRNV75s3sP
        zIORpsg8adIv9EKKk+/BYW8u1DAQ+KCJ0qopLws=
X-Google-Smtp-Source: APiQypId2J5XS004aACbFEMKESBsNYQOqsdEX8+LBnY6ZexYneL1r1mJjQCZGJTzGg481xeGI2tDi9ruAXTg+pNKQN8=
X-Received: by 2002:a05:6512:1c5:: with SMTP id f5mr7110378lfp.138.1587073535576;
 Thu, 16 Apr 2020 14:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200416083120.453718-1-toke@redhat.com> <20200416104339.3a8b85c4@carbon>
In-Reply-To: <20200416104339.3a8b85c4@carbon>
From:   Song Liu <song@kernel.org>
Date:   Thu, 16 Apr 2020 14:45:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW76RGkXBDPdWWFsN6xc6_0rUGBEGgwq-xAEtUU4O9y9ow@mail.gmail.com>
Message-ID: <CAPhsuW76RGkXBDPdWWFsN6xc6_0rUGBEGgwq-xAEtUU4O9y9ow@mail.gmail.com>
Subject: Re: [PATCH bpf v2] cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS
 is enabled
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, Xiumei Mu <xmu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 2:11 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 16 Apr 2020 10:31:20 +0200
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
> > When the kernel is built with CONFIG_DEBUG_PER_CPU_MAPS, the cpumap cod=
e
> > can trigger a spurious warning if CONFIG_CPUMASK_OFFSTACK is also set. =
This
> > happens because in this configuration, NR_CPUS can be larger than
> > nr_cpumask_bits, so the initial check in cpu_map_alloc() is not suffici=
ent
> > to guard against hitting the warning in cpumask_check().
> >
> > Fix this by explicitly checking the supplied key against the
> > nr_cpumask_bits variable before calling cpu_possible().
> >
> > Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_=
CPUMAP")
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Tested-by: Xiumei Mu <xmu@redhat.com>
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>
