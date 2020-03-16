Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E45186FFA
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 17:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732111AbgCPQZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 12:25:31 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:34549 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731998AbgCPQZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 12:25:30 -0400
Received: by mail-vs1-f66.google.com with SMTP id t10so11709325vsp.1;
        Mon, 16 Mar 2020 09:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pnwZXZ1du5ptGIP0RI92ZrcWO3bFITyegjW7Cfo9dTs=;
        b=gEZGx5bMMtb5FZgdhnZhL6el3Q/sHueQ8j+MOyNe7o3aqNKRTQ4WD1/MPqW0QS6pW7
         fIGtAVtkMRZZjD9BNSzW7lvrbYZh5binYY/cmUVrTIRmvRqKrzEr34njU9PsRbpDVb6V
         P7gox4FnHBdgp14Vojg4c0X6va7mB1nrbIzei3L5AGQeo0SAUwfbA/zIF+/OEWZ2H026
         RwZFc6aNkGSnw0PmK+ulffrt+D6iqYzSt5veA7NzKKP+DTkJsZJCZZsF8G0mcrUUggtu
         fgc/vxcWsmu+MczxD+5IvQJ/eLA/VjtuJHuqF+8Uw5m0cqsDl9IbJD5QNI//6Ia//OTC
         TzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pnwZXZ1du5ptGIP0RI92ZrcWO3bFITyegjW7Cfo9dTs=;
        b=EclGDFKpbMXYLvnvEFF1XTLgQb9Xh/3akPZfBO5HBZyusCeVS+fJQtSMa9tRWOwfPb
         zBL9yvSlsYdDV0+x5McpsJ2mm/ZP39Kd9mgDpyA+OMGNJUaQSukk1o3CadiHrhb3I88A
         fMRyS9MOvcZBJfMb6pzIIZrsJhrYY5fHFRkem1hsDWEzYKUDnbCSVkihI8gFP9umJm/6
         cABY+fhzEX74aWM4USYzZc5Lg3NQ+uyG1e/LOveSZ7a9vAymbor/Lj6XnCPJz3Q3TeIy
         0oLpUkOHN5e8SlCHgFzXImwBlXIcUADzIMGxCwi4DIYBCKWKTW8qJ5whgi309Cg6ktfk
         yUFQ==
X-Gm-Message-State: ANhLgQ1Sp1IiOWQyDuRbRKmRv/X6h+K7hCup4uFHl+Bz7++u2Jxv8vJb
        E/LwaFp0lwSrCbvsAvFwPPTjf0JS72iLmehDmXw=
X-Google-Smtp-Source: ADFU+vuShf577fz3GdMt08NSgjX9+ul39fkPKoJ1CyYXIzbNjuHgQaTE+keZ0kQzIysq+q5PgR2DhLHmZyonKHmccAA=
X-Received: by 2002:a67:3201:: with SMTP id y1mr439544vsy.54.1584375927711;
 Mon, 16 Mar 2020 09:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000088452f05a07621d2@google.com> <000000000000cc985b05a07ce36f@google.com>
 <202003100900.1E2E399@keescook> <20200316155119.GB13004@willie-the-truck>
In-Reply-To: <20200316155119.GB13004@willie-the-truck>
From:   Qiujun Huang <anenbupt@gmail.com>
Date:   Tue, 17 Mar 2020 00:25:16 +0800
Message-ID: <CADG63jDcuBNOVRoRX7oi1YmwuN0g7jpvDB4yNdOxwc13hvoNxA@mail.gmail.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
To:     Will Deacon <will@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>,
        ardb@kernel.org, davem@davemloft.net, guohanjun@huawei.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        mingo@kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 11:52 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Mar 10, 2020 at 09:01:18AM -0700, Kees Cook wrote:
> > On Tue, Mar 10, 2020 at 02:39:01AM -0700, syzbot wrote:
> > > syzbot has bisected this bug to:
> > >
> > > commit fb041bb7c0a918b95c6889fc965cdc4a75b4c0ca
> > > Author: Will Deacon <will@kernel.org>
> > > Date:   Thu Nov 21 11:59:00 2019 +0000
> > >
> > >     locking/refcount: Consolidate implementations of refcount_t
> >
> > I suspect this is just bisecting to here because it made the refcount
> > checks more strict?
>
> Yes, this is the commit that enables full refcount checking for all
> architectures unconditionally, so it's the canary in the coalmine rather
> than the source of the problem.

Yes, I tracked it down. And sent out a fix:
https://lore.kernel.org/netdev/1584330804-18477-1-git-send-email-hqjagain@gmail.com

>
> Will
