Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA843E06F4
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbhHDRvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbhHDRvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:51:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3992C061799;
        Wed,  4 Aug 2021 10:50:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so9927660pjs.0;
        Wed, 04 Aug 2021 10:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UBg423yx32A1qO4m1utyUDRqy/ul+Eqo8Zka5xgwqa0=;
        b=ghdtmD1sDvLYG1dGFNfSvjKModtvS3BXqFvv1opCp5yU9rR8u10EjvSFOHCtaFb1rQ
         rGH0JZOujXN+imECE3RMlpyO/pedLKDOEAKbJGSc/TvJm5ee063zbuZUHmz5mUHlug6f
         bJDDc/Sy+Sp3LF/nP/Fe4lkcy7EiRjjPTSKRmoqfKh+0YrfDvuiKQcRPgKE/+zYQhz/X
         u4rICXJbnnYaPrs8sbnmAUz+QkJlXYnkf+qXYAgeRw3Wd9WZHQ4oZ+4OVfu/qwiuomjn
         6x30dJPXnbhiqZBvTGvsdgUJ8gQCi8qNYc23Cn262ZJ8jHrulG5Hw0aJnufLnkglyyZY
         cVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UBg423yx32A1qO4m1utyUDRqy/ul+Eqo8Zka5xgwqa0=;
        b=UsoFdxd07M0VaECQb3ST9EQq781yFx6CM4s7OoINQv7PatSDkfXwOpIQCqzZ644SbA
         pZHVVe1OhKTUCMqtNMYs8PPiBJvtafamUQiztKCdxYiuCukBv4MSWfCLhIP9RmOTnJFF
         6dh5ev2XEX7m8hhD9PP/33GdykX26eebl6eb51E7/xsLZuCvh3LEroETA9+D1IV/XTwm
         nrD8D3FDm8zcf7F4OuP7/NBjtvreX66WwcddsGtsbifjHfEvu6qNL47LNAuxYhKYtX2y
         7e9+1m4U3W9Mo3fPkKgKvMIBapL3spHlp5bK5NbAGfTxKgVemJBGTQ1US0hDacLChtRx
         O0Pg==
X-Gm-Message-State: AOAM531a5/Qly8vurQ1GMd5kOwU6nBzaUZp8pBKQnex+ZJhmgdIDyhx6
        /9rfoMPCfr4tksGkHvWiVWt6fsLRW2P+dvwtil/44jK4Vsg=
X-Google-Smtp-Source: ABdhPJwFCIZ/GJHp2dPMuOHwQcylFMLbuhLGTITuPt96w+fdzKmRLOXA+duG1rQArJPTxeV3nlJx6rb799CpjN3W5ac=
X-Received: by 2002:a63:154a:: with SMTP id 10mr212645pgv.428.1628099448194;
 Wed, 04 Aug 2021 10:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
 <672e6f13-bf58-d542-6712-e6f803286373@iogearbox.net> <CAM_iQpUb-zbBUGdYxCwxBJSKJ=6Gm3hFwFP+nc+43E_hofuK1w@mail.gmail.com>
 <e2a8ac28-f6ee-25e7-6cb9-cc28369b030a@iogearbox.net>
In-Reply-To: <e2a8ac28-f6ee-25e7-6cb9-cc28369b030a@iogearbox.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 4 Aug 2021 10:50:37 -0700
Message-ID: <CAM_iQpU-Z5qQOW=0FV4uXo__EDmyMqycgiuyykfHD8TN+-xZ-w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net/sched: sch_ingress: Support clsact
 egress mini-Qdisc option
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 1:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/3/21 2:08 AM, Cong Wang wrote:
> > On Mon, Aug 2, 2021 at 2:11 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> NAK, just use clsact qdisc in the first place which has both ingress and egress
> >> support instead of adding such hack. You already need to change your scripts for
> >> clsact-on, so just swap 'tc qdisc add dev eth0 ingress' to 'tc qdisc add dev eth0
> >> clsact' w/o needing to change kernel.
> >
> > If we were able to change the "script" as easily as you described,
> > you would not even see such a patch. The fact is it is not under
> > our control, the most we can do is change the qdisc after it is
> > created by the "script", ideally without interfering its traffic,
> > hence we have such a patch.
> >
> > (BTW, it is actually not a script, it is a cloud platform.)
>
> Sigh, so you're trying to solve a non-technical issue with one cloud provider by
> taking a detour for unnecessarily extending the kernel instead with functionality
> that already exists in another qdisc (and potentially waiting few years until they
> eventually upgrade). I presume Bytedance should be a big enough entity to make a
> case for that provider to change it. After all swapping ingress with clsact for
> such script is completely transparent and there is nothing that would break. (Fwiw,
> from all the major cloud providers we have never seen such issue in our deployments.)

Well, it is both non-technical and technical at the same time.

The non-technical part is that it is really hard to convince people from
other team to restart their services just for a kernel change, people are just
not happy to take risks.

The technical part is the bad design of clsact. It is too late to complain,
but it should not create two _conceptual_  qdiscs (actually just one struct
Qdisc) at the same time. If it only created just egress, we would
not even bother changing ingress at all. Sigh.

Thanks.
