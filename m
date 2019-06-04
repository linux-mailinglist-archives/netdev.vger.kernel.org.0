Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5A234F2A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFDRmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:42:11 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36303 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfFDRmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:42:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id d21so8632666plr.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IygS5cd4afLZ/eHKi5Vh6iMu/8qrdd2XyzjRxs/VsFA=;
        b=tmKyt2FumcXJ1+CJD8UpDtFqISapiyuM2cs1zIcEDw4QcYZOdDQ6+yhk8wyiCLcQLb
         B69hOrzfF0nMKsqH1eRQWCigxt4B+HutIvp2qmdx83qfyeJZa2qIHP3rf/MV3Gyh6M7K
         mYiPyD5OGhSupCDaSn6mZOk2cooUs5I7efHHYOXy0KUKjCs4WpGO69el2x59sWSzZumq
         sXPgMr2QVrR5qaDTYna+/fTJuAGJaJ6T3griQNZDXbifIg/iw1vvi/63KwFUFilpNVgo
         ZVvNzzvwtSThCi+g86vFMplAAIfiCtBw29Ba6HxSD0XrbjMUz+ea0SBKNKslWV1/w3os
         PaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IygS5cd4afLZ/eHKi5Vh6iMu/8qrdd2XyzjRxs/VsFA=;
        b=Cv25/GPKq4HFmsmpG0oM8xgvnTHOISD9x5TSTcWihYXKR5nalYA9M+OXnFOLShCU4K
         +x2hNyuQ1QFMF7JGnpZSyQRv9tLOHg83ilbgz3yO9pZq6gqBHVbFskIt98/fsqsg/fmM
         6Vz7idF/jSNcdMn/jelrtXZ9EDJ+AoRcNdFpzZoqDCgTl8AgFkyZHQvoKk/d1eyLSAX2
         8TDd5m6yoStHwAhwD6/HKpzXPZkRurTXMDUVjj65t8uP2IEUI+XWMMEuvqO/GeRjofH8
         HsOC6dllkodljvqL8yeM3bqQXYiVy2nCdpcJgd0oXFFduxIqNDyUo3R/7ki+C7PwSyMg
         mJGA==
X-Gm-Message-State: APjAAAWpw45o7jDc37ueCc1cJdDZUdzXZjhCgPjPyrvfAVXINbrtl5zP
        Lyw21mbJvgpeO9kdMQ3GtRoagp5GfYOMUXlgyJs=
X-Google-Smtp-Source: APXvYqwXBKZLYvRYRsxmbvmSS9kiKYWc/QyldzLYJYMuphwSeJOKgXQ0HDSRuALiIM/SakKK9TaCnq8hfWa0nUsy/Bw=
X-Received: by 2002:a17:902:d701:: with SMTP id w1mr32124418ply.12.1559670130198;
 Tue, 04 Jun 2019 10:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com> <a773fd1d70707d03861be674f7692a0148f6bb40.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpW68XR3Y6gyb0zyd3qooCwPHBM1Fm+THcS=migSNsHMzA@mail.gmail.com>
 <e2e02404af5aea5663877db8f9d2e23501e818b8.camel@redhat.com>
 <CAM_iQpURD5Yvr1BwfbTBDbbJdATGSK5PWD7jfP4=NGdgTGnnJw@mail.gmail.com> <b1c6251c-16ab-57a8-222d-1f1f7021a0d5@mellanox.com>
In-Reply-To: <b1c6251c-16ab-57a8-222d-1f1f7021a0d5@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 4 Jun 2019 10:41:58 -0700
Message-ID: <CAM_iQpXwKtT==DU3FhZ+HTc03TV7K0LcYEEXCUb6wTStospV4A@mail.gmail.com>
Subject: Re: [PATCH net v3 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
To:     Eli Britstein <elibr@mellanox.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 1, 2019 at 9:22 PM Eli Britstein <elibr@mellanox.com> wrote:
>
>
> On 6/1/2019 1:50 AM, Cong Wang wrote:
> > On Fri, May 31, 2019 at 3:01 PM Davide Caratti <dcaratti@redhat.com> wrote:
> >> Please note: this loop was here also before this patch (the 'goto again;'
> >> line is only patch context). It has been introduced with commit
> >> 2ecba2d1e45b ("net: sched: act_csum: Fix csum calc for tagged packets").
> >>
> > This is exactly why I ask...
> >
> >
> >>> Why do you still need to loop here? tc_skb_pull_vlans() already
> >>> contains a loop to pop all vlan tags?
> >> The reason why the loop is here is:
> >> 1) in case there is a stripped vlan tag, it replaces tc_skb_protocol(skb)
> >> with the inner ethertype (i.e. skb->protocol)
> >>
> >> 2) in case there is one or more unstripped VLAN tags, it pulls them. At
> >> the last iteration, when it does:
> > Let me ask it in another way:
> >
> > The original code, without your patch, has a loop (the "goto again") to
> > pop all vlan tags.
> >
> > The code with your patch adds yet another loop (the while loop inside your
> > tc_skb_pull_vlans()) to pop all vlan tags.
> >
> > So, after your patch, we have both loops. So, I am confused why we need
> > these two nested loops to just pop all vlan tags? I think one is sufficient.
> After Davide's patch, the "goto again" is needed to re-enter the switch
> case, and guaranteed to be done only once, as all the VLAN tags were
> already pulled. The alternative is having a dedicated if before the switch.

Yeah, I think that can be simply moved before the switch so
that we don't have to use two loops, which should be easier to
understand too.

Thanks.
