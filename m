Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB241945A2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 18:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgCZRi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 13:38:58 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:47039 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZRi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 13:38:57 -0400
Received: by mail-ot1-f50.google.com with SMTP id 111so6724315oth.13
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 10:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6HTihWpl0pG4DrMUlQfP4f3o1USwEsENfNnrEPDXYHU=;
        b=FpIUK+P/2CT/M0oc7nKMyz0Tdv7T2NYOUyk5U6utMuLaT/XxpTXz00YfKDucKObd+4
         astE53xSeMCcClbiNOqkZXGpaJXre7zxHU2ojw6WhnpAHyeFUiZvmq/Sg/Q6YawfOKJF
         eI94WGAzYS9dZU/jQuQXs/ioWEZ2TRsPCCUieqlZxIK5EsEyuF4EPVx++tpIXmNj/qO/
         NGduY0+p9wPbMxiGjI8ty1Fub6H6j4jjNkZrLDe2qXUPkEam4ynf5GudgFabzcGiVBVU
         QrZL0mx5+NzMGmAdzwZBl/Yntwh2/xvwUcgmABBdhDdVC703PTFvexiso8JU3Es8QJma
         4lUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6HTihWpl0pG4DrMUlQfP4f3o1USwEsENfNnrEPDXYHU=;
        b=a8SFx3A43DDVAXvzAAv/pWYp8OYkICsNnkrNgzi1/J8mXgtQlVH9Qm2vF7VT7aXHgx
         YmK82ufY1voIpqR5kzXCBFsbCWoHCNy/+P0YslrbNAQiJDxII7SGG8TShXoxOZplxO6f
         w4GMdFJOabCZdItIKcXsv3Kln10NlrprMGy0b+DNaslAttCam8bYY2DgfubMjrjEaI30
         E6sj5UnAD8vchUn505v9kntpXdwfOU2Nd2G8Se0IhIdVn3qk0qtc5oQQhik6R/FzFDeu
         RSZdi3fbG69cOzaL2OC1fU7ZYRBeTIUEoTRSAo51VpZC0zoC7jVAJJ+lhWKVC4HYenc3
         MFrQ==
X-Gm-Message-State: ANhLgQ1IInGE4fl8M81vo8Qzh5tpzkiB1pPU3HlDnq6p5jJX7i8DPbwJ
        mxdZLMTNiy90BRX6iISvD2QAUj73kuHT1gVPpIlUW43yvWI=
X-Google-Smtp-Source: ADFU+vvyJRRFTilpQs+mPyHeVGB0bEkvV4r1cKco9UekMRP4P8fpGp3AHqLL4RwtO/yJxt70QZR7syZ/47+JNGI6RX8=
X-Received: by 2002:a05:6820:221:: with SMTP id j1mr6096904oob.12.1585244336793;
 Thu, 26 Mar 2020 10:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
 <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com> <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
In-Reply-To: <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 26 Mar 2020 10:38:45 -0700
Message-ID: <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 10:07 AM Cong Wang <xiyou.wangcong@gmail.com> wrote=
:
>
> On Thu, Mar 26, 2020 at 7:24 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> >
> > > On Wed, Mar 25, 2020 at 6:43 PM Cong Wang <xiyou.wangcong@gmail.com> =
wrote:
> > > > Are you able to test an experimental patch attached in this email?
> > >
> > > Sure. I'll compile new kernel tomorrow. Thank you for quick patch.
> > > I'll let you know as soon as I have anything.
> >
> > I've compiled kernel with the patch you provided and tested it.
> > However the problem is not solved. It behaves exactly the same way.
> > I'm trying to put some printk into the fq_codel_reset() to test it
> > more.
>
> Are the stack traces captured by perf any different with unpatched?

Wait, it seems my assumption of refcnt=3D=3D0 is wrong even for deletion,
in qdisc_graft() the last refcnt is put after dev_deactivate()...

Let me think about how we could distinguish this case from other
reset cases.

Thanks.
