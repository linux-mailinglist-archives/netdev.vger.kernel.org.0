Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4432B385
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449587AbhCCEA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383617AbhCBL4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:56:40 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D182C061756
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 03:56:00 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id 2so5410139qtw.1
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 03:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x2wS74TM4AizfALT8kxd/HMxnjBfALQbmC8anm8d68E=;
        b=KXElxgfaQy6eVhDGR+xbMcSTry7qKYCP2pOogBHaYAH0871t0KEnkyVTFiVnGCxMNx
         5Fi6FwslIKtGMdwBZvySZ3WdP9W8cxDCvpzKIv31IDHOE6KE3z2XeAVMQzNNmcejCyRg
         hs/Q7PGYZMIYcisXNf37dNgntVZrndYOjQWM+7iHYwOmcM8E0vmReRtnaNFdBhP2VY9D
         3arznmapPSndYNB1iKX6bNqPHAbuIYH1LT+WdOaPbA6BagZfwjPZL0NSLNnqILPiISQg
         EYIerBPWC1DXOnXWpqrA9o4uBgVrj9pDu7sVsOahKQBhbnJy9eUFNqRfkT+sw3JOYGgV
         9PnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x2wS74TM4AizfALT8kxd/HMxnjBfALQbmC8anm8d68E=;
        b=bS8J2YIrlXMQhlliXFinmvdhEQp7gXA37YJKMw/yvf71ZyLCpel7pKKoqaARkskitn
         xT+x6YrRhtglLAG1SGFoUpaiu6aa2miLycJekmlatWEaiYg5pspZz6QmLMj4jKfwdpDl
         OgvcpukDqKTjxxarMKBVgFXcSP98V9nzAS/Ray/VhsrTRlM7tMWYiD4n60/d6zx78iCD
         BgUJYJfUfq2t2fbEba45YIUUdB9XS6RHAXuxTY8Jtzt14srv4mkB1yF7DmfKiVsv6b+K
         q8rc0c9xBnWAaRDfMpl/mQNpRzrhf17y6XZ7xZjXfEp8lLD7aG4RvjS+l/91lABWPEes
         IA6A==
X-Gm-Message-State: AOAM533r3fZJgPgURxidL+zBASMD13SO6sSYzA1Ycr2DxZgBJ+INtKiA
        y1l7p0+k0to9/c/35cAFbPUEisdE0GorwYHGvDZ0oQ==
X-Google-Smtp-Source: ABdhPJylDznA6rJTx2enwk+UXwNUHm49QotCLfmKiKlZIn6soRH2Ky1WqNuSdklYHGcVu++rxAk8eYmVzFMRm3OQ/nQ=
X-Received: by 2002:ac8:3876:: with SMTP id r51mr11965163qtb.43.1614686159085;
 Tue, 02 Mar 2021 03:55:59 -0800 (PST)
MIME-Version: 1.0
References: <20210128024316.1425-1-hdanton@sina.com> <20210128105830.7d8aa91d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <60139ef4.1c69fb81.8d2f9.f26bSMTPIN_ADDED_MISSING@mx.google.com>
 <CACT4Y+Z7152DKY=TKOUe17=z=yJmO3oTYmD66Qa-eOmV+XZCsw@mail.gmail.com> <603e0005.1c69fb81.e3eed.6025SMTPIN_ADDED_MISSING@mx.google.com>
In-Reply-To: <603e0005.1c69fb81.e3eed.6025SMTPIN_ADDED_MISSING@mx.google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 2 Mar 2021 12:55:47 +0100
Message-ID: <CACT4Y+Zv-p56cbs3P7ZEUXdYaN7jXB4AELG5=S19wVH4kj3a9g@mail.gmail.com>
Subject: Re: [PATCH] netdevsim: init u64 stats for 32bit hardware
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com" 
        <syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 10:06 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Mar 2, 2021 at 16:40 Dmitry Vyukov wrote:
>
> >I hoped this would get at least into 5.12. syzbot can't start testing
>
> >arm32 because of this.
>
>
>
> Or what is more feasible is you send a fix to Jakub today.

So far I can't figure out how to make git work with my Gmail account
with 1.5-factor auth enabled, neither password nor asp work...
