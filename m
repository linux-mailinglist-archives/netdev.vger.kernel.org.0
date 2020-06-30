Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DDC20EBAD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 04:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgF3C4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 22:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgF3C4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 22:56:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05685C061755;
        Mon, 29 Jun 2020 19:56:18 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cv18so3643611pjb.1;
        Mon, 29 Jun 2020 19:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W7q2+5HVCtv5eeWz4jRKHnOS3HWL+VbRb2Ed3X03CNk=;
        b=rCRS+xJbQgf1jcWJCuT270yV4UI1ynm8b7XmHawRXJy2pPEyAkOaBQu2YkfqeZPBz9
         JKUsi5xH6T3bY7xjcACaaXSqKAAW9ZwvRiDZpA5E40UjX6CmN2uBzB5OeTPtIZDzfmTn
         IJ5q/5+aVuKSzIlSUdkX5B1sk4Fgom5gWcSnPezs6sT1m4VSmiioU85wUKpVPGJNNL6x
         VO3HET7WRC6x4vcZqdJqoCiX1G3ELmeBjsDV4Bj1gdix9ahqHKivM4uzTNTBmW0COvpo
         Zvd4DRkedi9v2p/S4EUkI6mz7tHTB2byKF5ZUWPKjbHVkl7zhrlUwql+a4aqMguoeMjx
         yGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W7q2+5HVCtv5eeWz4jRKHnOS3HWL+VbRb2Ed3X03CNk=;
        b=MKRACEB4DKYcL53EWdCLYXsf4xuN330gDdQ8l5FvkTnWGnmcOZfmH1KY96I/NiqQO2
         ddAjyKde0hE0+9LHFR0mA3Rn4c22r9YyQSN5iYHCjZ9Fw+i2NNFIGsOF/Bv7vCpPc1xm
         02RJIa1h5Q1+qiNSEmx/Wia/dhFUauWphDDAiaHxymGOB0rqHL69gmXucbVOlxTCwHsT
         U/BKm5YWvqSB/ExB1x3ltaCKcHGVnK0WnYfjefzj3DpaKsPCZxQiqznDCgCRSvWf/EJR
         T2BBA38Mgqc5eBLykXmrpWH7yQtYmLz+zjixyIcBwo2Zorvf+5ZIWR++CR7F/oGOzFxK
         Kq4w==
X-Gm-Message-State: AOAM533St5UK3aFIVeRTiY7YRnCPXye6DA9bcnQY4kq2RKO1DfGrTZPr
        bu0OgiPfBJHfQNIW1PU2qis=
X-Google-Smtp-Source: ABdhPJwANgMJsb+QSVrPHQpLichx9FTQ2lzwB3I7wI0KuN7mswc+ztWtShNPKpOUCzkSw//kHeP8rQ==
X-Received: by 2002:a17:902:469:: with SMTP id 96mr15715171ple.93.1593485777245;
        Mon, 29 Jun 2020 19:56:17 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:140c])
        by smtp.gmail.com with ESMTPSA id e128sm870027pfe.196.2020.06.29.19.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 19:56:16 -0700 (PDT)
Date:   Mon, 29 Jun 2020 19:56:13 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 1/5] bpf: Remove redundant synchronize_rcu.
Message-ID: <20200630025613.scvhmqootlnxp7sx@ast-mbp.dhcp.thefacebook.com>
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
 <20200630003441.42616-2-alexei.starovoitov@gmail.com>
 <CAEf4BzaLJ619mcN9pBQkupkJOcFfXWiuM8oy0Qjezy65Rpd_vA@mail.gmail.com>
 <CAEf4BzZ4oEbONjbW5D5rngeiuT-BzREMKBz9H_=gzfdvBbvMOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ4oEbONjbW5D5rngeiuT-BzREMKBz9H_=gzfdvBbvMOQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 06:08:48PM -0700, Andrii Nakryiko wrote:
> On Mon, Jun 29, 2020 at 5:58 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jun 29, 2020 at 5:35 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > bpf_free_used_maps() or close(map_fd) will trigger map_free callback.
> > > bpf_free_used_maps() is called after bpf prog is no longer executing:
> > > bpf_prog_put->call_rcu->bpf_prog_free->bpf_free_used_maps.
> > > Hence there is no need to call synchronize_rcu() to protect map elements.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> >
> > Seems correct. And nice that maps don't have to care about this anymore.
> >
> 
> Actually, what about the map-in-map case?
> 
> What if you had an array-of-maps with an inner map element. It is the
> last reference to that map. Now you have two BPF prog executions in
> parallel. One looked up that inner map and is updating it at the
> moment. Another execution at the same time deletes that map. That
> deletion will call bpf_map_put(), which without synchronize_rcu() will
> free memory. All the while the former BPF program execution is still
> working with that map.

The delete of that inner map can only be done via sys_bpf() and there
we do maybe_wait_bpf_programs() exactly to avoid this kind of problems.
It's also necessary for user space. When the user is doing map_update/delete
of inner map as soon as syscall returns the user can process
old map with guarantees that no bpf prog is touching inner map.
