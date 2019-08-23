Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59A9B4AF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436822AbfHWQkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:40:46 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43331 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436778AbfHWQkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:40:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id h15so9420610ljg.10
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 09:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFSUa3Y0AMEZxxbdvd6exz8oVzNE3ykMfJ+esAb4P1Y=;
        b=in2DAlRHQyVK/4OlE2+sWfVD7qfkyiDW0o3oZp4qJN+yD2t2douwleQR/kx4VCxgZs
         nvjxlE4Iw/XbeIQXYn7t2S7JBpUALBCIr4b22jylw+30ThA1f8p5lQxOTXHkR2hmEVdu
         wiEU7DcWArwWcCoifBgxS0B8UVRboXPybf/tUug4S+Bg//D5RFuHU4c0yny9JaMK2byu
         b5iw/URhcmGPzMQNEIz+4xMcOA3NiL0OkRillazsmH28lKd/hifr5Kh46pumn6yldnWC
         qBfbIAEZlLk9S35AFsFI2EghOZ9O/3J6c0ZdiRCX7Cq9jh2ufKd4XKziDTZWrESL3o1G
         sVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFSUa3Y0AMEZxxbdvd6exz8oVzNE3ykMfJ+esAb4P1Y=;
        b=pZp86CRdOwFcpauLdiiRAVzHrVWs+1U92ImIahG5fa1cvLG1ENEvm6lEdC6cX5j/mM
         xEpkSYB6pjblvgyPjCKdLlvhauEyo9nX/Szm8WeeS52sgjnlJzy7It5V83Q1oI+MZO2N
         uxlcqQGkvozXoJcJnmTYnS8ruNja4j2mhCLznHHoDNsm5WAFD+hB/OhW1YVJIPKkdC1R
         5+7mV/VSpW2LsHuJIJ0ueTJcdvVxKzHJvAdcZXvdb9CfrFO5qlxnSBv6yIWM6i7hbBIW
         eDow+fBVRG2JY9NXweKT06puMOf8UZZibrPdA7tNisJMQ9GzH+aIiC9XmStWK6Qd0Cze
         csMw==
X-Gm-Message-State: APjAAAUOb2SiBDGo33Ub4twCWa+kU+yRoty8YZHe0oeayuLqiHGAZDtW
        Oyva+R2hAGzk7wglRyl8VL6L+Khk5zQRzkMoE30reeb4
X-Google-Smtp-Source: APXvYqxP4TeBkmXbkuInTN3xzojHxeRuObxdxn9p6zrMSNHsUPRmguDvnSCttfXQj4hr8zxU2IgT8JvQ6W7et17aoj0=
X-Received: by 2002:a2e:89da:: with SMTP id c26mr3500013ljk.214.1566578444243;
 Fri, 23 Aug 2019 09:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <1566505070-38748-1-git-send-email-yihung.wei@gmail.com> <CAOrHB_A6Hn9o=8uzHQTp=cttMQsf=dYpobvq7C7_W398sw8UJA@mail.gmail.com>
In-Reply-To: <CAOrHB_A6Hn9o=8uzHQTp=cttMQsf=dYpobvq7C7_W398sw8UJA@mail.gmail.com>
From:   Yi-Hung Wei <yihung.wei@gmail.com>
Date:   Fri, 23 Aug 2019 09:40:34 -0700
Message-ID: <CAG1aQhLkrvVADEtAFcdO+GX03SGx7GMW1YyLVTGrPjiCz1HMyQ@mail.gmail.com>
Subject: Re: [PATCH net v2] openvswitch: Fix conntrack cache with timeout
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 11:51 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Thu, Aug 22, 2019 at 1:28 PM Yi-Hung Wei <yihung.wei@gmail.com> wrote:
> >
> > This patch addresses a conntrack cache issue with timeout policy.
> > Currently, we do not check if the timeout extension is set properly in the
> > cached conntrack entry.  Thus, after packet recirculate from conntrack
> > action, the timeout policy is not applied properly.  This patch fixes the
> > aforementioned issue.
> >
> > Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> > ---
> > v1->v2: Fix rcu dereference issue reported by kbuild test robot.
> > ---
> >  net/openvswitch/conntrack.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > index 848c6eb55064..4d7896135e73 100644
> > --- a/net/openvswitch/conntrack.c
> > +++ b/net/openvswitch/conntrack.c
> > @@ -1657,6 +1666,10 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
> >                                       ct_info.timeout))
> >                         pr_info_ratelimited("Failed to associated timeout "
> >                                             "policy `%s'\n", ct_info.timeout);
> > +               else
> > +                       ct_info.nf_ct_timeout = rcu_dereference(
> > +                               nf_ct_timeout_find(ct_info.ct)->timeout);
> Is this dereference safe from NULL pointer?

Hi Pravin,

Thanks for your review.  I am not sure if
nf_ct_timeout_find(ct_info.ct) will return NULL in this case.

We only run into this statement when ct_info.timeout[0] is set, and it
is only set in parse_ct() when CONFIG_NF_CONNTRACK_TIMEOUT is
configured.  Also, in this else condition the timeout extension is
supposed to be set properly by nf_ct_set_timeout().

Am I missing something?

Thanks,

-Yi-Hung
