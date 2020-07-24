Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5E22BC5E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 05:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgGXDK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 23:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXDK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 23:10:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87146C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 20:10:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r12so6107791ilh.4
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 20:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MGZb0/D1LOdK/kVaCExG7R8ZZv+bORNvMUHVKdnLJw0=;
        b=clRsfEj7mobjQlFMTV0WFaGdn/Vkx/Osb2RvqBAuoep/qwkjKNB68OZ0veXJGCBmYv
         uciuXr3gwR+rihMzJ5VdfKvWTbkYn0DAVNRjw31ReImwNWsNRBtebKPum01ZhGwdeDYG
         GzHE7RSd6YJUVebU/Z5Py/n99f1pwPLfs7JoQuGGSS+ty1XWHmy1Ax0gfIXIko2nNrRJ
         i+o4crLsmLYBqjwzfn8zhSuRdlSYBRjA7uk8oaYm2GoSTIwndbcDGCHrO61E4t7A9hE2
         BU0N42Qe24UgrUzGKDJqFWteNJPUJhD0/loxCuS2r3PTEjUDpCDFbXOMpzr1+Mm2JOKO
         FmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MGZb0/D1LOdK/kVaCExG7R8ZZv+bORNvMUHVKdnLJw0=;
        b=MBsm4lRDIOLXaYUQK5L+CMEn18IFymRs96EMZyjDzRe5jiW/27Fs0FFhQAGRONGivK
         fAlrgxtBlFcda9iyhPK4MdZpJ0XmHtvcwIstl8VlAjXiDVm4YJ4TFyom+yHAQjaRi8t+
         NhcnUA8qq5FUPQvYzrtLAqwKz47w1e4JoHMWDYBMLMrTnsX4v36qxc9XmODUTQtquWDQ
         V51rygrd5v06eI1uL1sMlQV6MDFw0eLwMTrtuAPuRjo67M7fcFvK8Dl5dFW9o0lu1y7P
         bCo4O6peEPEtwUzRdsduPQ729Au6Rn6MsJT9EonN9YGKzlzpQnAQdMx8ay6JKrajg8fM
         YiGg==
X-Gm-Message-State: AOAM530PhGE7QhdsMC4+zwdIROMy8AAfLEf3URzycfsK3YkS+aM8+/7W
        6TSWz82k6xWOAiX4FPBF6png95jN5uOoEQdyaGU=
X-Google-Smtp-Source: ABdhPJx2ydkEHVH/awNXFjCwZFODX+oqmflam7ctuwCp7sKY7zshtytlUNw24nYq1fgnJRbxiRGiSPnRnvQ4oRe/Mus=
X-Received: by 2002:a92:d30b:: with SMTP id x11mr8401460ila.175.1595560255404;
 Thu, 23 Jul 2020 20:10:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200721.161728.1020067920131361017.davem@davemloft.net>
 <CALHRZuofbFnE8E-wpdosvKP6m3Ygp=jjcHz9QUn=R3gUbyNmsg@mail.gmail.com>
 <CALHRZupy+YDXjK6VsAJhat0d8+0Wv+SB2p4dFRPVA69+ypC1=Q@mail.gmail.com> <20200723.121345.1943051054532406842.davem@davemloft.net>
In-Reply-To: <20200723.121345.1943051054532406842.davem@davemloft.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 24 Jul 2020 08:40:44 +0530
Message-ID: <CALHRZupBXQqOzWhNH=qDH7w1cNLYrEWLTwt368sBJt4FiJTBWQ@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sgoutham@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, Jul 24, 2020 at 12:43 AM David Miller <davem@davemloft.net> wrote:
>
> From: sundeep subbaraya <sundeep.lkml@gmail.com>
> Date: Thu, 23 Jul 2020 20:29:03 +0530
>
> > Hi David,
> >
> > On Wed, Jul 22, 2020 at 7:34 PM sundeep subbaraya
> > <sundeep.lkml@gmail.com> wrote:
> >>
> >> Hi David,
> >>
> >> On Wed, Jul 22, 2020 at 4:47 AM David Miller <davem@davemloft.net> wrote:
> >> >
> >> > From: sundeep.lkml@gmail.com
> >> > Date: Tue, 21 Jul 2020 22:44:05 +0530
> >> >
> >> > > Subbaraya Sundeep (3):
> >> > >   octeontx2-pf: Fix reset_task bugs
> >> > >   octeontx2-pf: cancel reset_task work
> >> > >   octeontx2-pf: Unregister netdev at driver remove
> >> >
> >> > I think you should shut down all the interrupts and other state
> >> > before unregistering the vf network device.
> >>
> >> Okay will change it and send v2.
> >>
> >
> > For our case interrupts need to be ON when unregister_netdev is called.
> > If driver remove is called when the interface is up then
> > otx2_stop(called by unregister_netdev)
> > needs mailbox interrupts to communicate with PF to release its resources.
>
> If you leave interrupts on then an interrupt can arrive after the software
> state has been released by unregister_netdev.
>
> Sounds like you need to resolve this some other way.

Only mailbox interrupts can arrive after unregister_netdev since
otx2_stop disables
the packet I/O and its interrupts as the first step.
And mbox interrupts are turned off after unregister_neetdev.
unregister_netdev(netdev);
otx2vf_disable_mbox_intr(vf);

Thanks,
Sundeep
