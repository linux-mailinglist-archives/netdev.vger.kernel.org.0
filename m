Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF9260A26
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 07:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgIHFgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 01:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgIHFgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 01:36:14 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749F8C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 22:36:12 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y2so14236528ilp.7
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 22:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3lMzmjoRPdH2I7SD3ucUuOLulsT37jkUsavzIliyvs=;
        b=vmnhCMp1Bsrl6d2gLmJ9svwlb3/ILDr0ZHIHDk3K95/gix4sOOjU6ELt3xA+7tY/mh
         wfufYxQrycLZ0lAsxoYrkFBOuYq3e28F2zbM89LMFPYxEeN79lro8LkX+gukAW1TbNVY
         ClpT1wCA/RrNFDGiTjrLIm5sRzm2DuoqUL/8M8g1bN/N0FLcOXXAFOOQvq8t3PTdrYI6
         BbSAK3ijmsu5a5NOInPdp0RPpRm/50o6sL/ZL4lfiFEhwMsWB0g9jUGcbUb00zKjcOOK
         yUkejmeoUk4u/HYK07Wbcq22L2kuUovYDdhzxtdpdTqHlI6qhtRKBBmZ9IalUq/Yuhf/
         VxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3lMzmjoRPdH2I7SD3ucUuOLulsT37jkUsavzIliyvs=;
        b=YAKGmpLI0Q68SyJvxHLihv5T4OPb/7dVfDA6ziDkaGwNZXDWX/Fu25RNNKquzfdZtt
         28LKSuerqndSr6ol7Vxe8hsydaRB1at1TQDbU6ONbQ8aczoig7kO/+s+mHjLynKMoUPW
         3jXJ6IGR82p8f7nAcEcCx4eD1K7YzscSk7BEDLkKxynmy05bysionrh8YzZ7k5FKgRin
         29NPG5af7jdlr3JDgoUeWbdNJbTvknwcDYWRLY3IfhIgpgeARAzmgKb5yEzk/+0b+xJF
         bIOukrC9Gf5m9arsSWDNExPfUznQiQZsafGr7RHaLHOAwkznLxAZhatiAaqQzXjKf9+e
         E4Ng==
X-Gm-Message-State: AOAM530t5dZ67xkR1ShrMM6aFXmxBv5NTbxvyFR3E3oBkYvYNyusJLPZ
        6L02gNwpNjB2DT0RZq+J/YYwP4QToAItEf1yM04GVg==
X-Google-Smtp-Source: ABdhPJwLPPg8/LDEFFHwZ1CmjHzlRoMyoZVj8/Jcs/g/TcIbWGzvPrPGdp2Ix8ADHpEIcdZzotm8yI2Z+JFl8M4w5WI=
X-Received: by 2002:a92:2c0f:: with SMTP id t15mr22144954ile.205.1599543370189;
 Mon, 07 Sep 2020 22:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200903140714.1781654-1-yyd@google.com> <20200907125312.evg6kio5dt3ar6c6@lion.mk-sys.cz>
 <CANn89iKZ19+AJOf5_5orPrUObYef+L-HrwF_Oay6o75ZbG7UhQ@mail.gmail.com> <20200907212542.rnwzu3cn24uewyk4@lion.mk-sys.cz>
In-Reply-To: <20200907212542.rnwzu3cn24uewyk4@lion.mk-sys.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Sep 2020 07:35:58 +0200
Message-ID: <CANn89iKyES49xnuQWDmAbg1gqkrzcoQvMfXD02GEhc2HBZ25GA@mail.gmail.com>
Subject: Re: [PATCH ethtool,v2] ethtool: add support show/set-time-stamping
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "Kevin(Yudong) Yang" <yyd@google.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 11:25 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Mon, Sep 07, 2020 at 06:56:20PM +0200, Eric Dumazet wrote:
> > On Mon, Sep 7, 2020 at 2:53 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >
> > > As I said in response to v1 patch, I don't like the idea of adding a new
> > > ioctl interface to ethool when we are working on replacing and
> > > deprecating the existing ones. Is there a strong reason why this feature
> > > shouldn't be implemented using netlink?
> >
> > I do not think this is a fair request.
> >
> > All known kernels support the ioctl(), none of them support netlink so far.
>
> Several years ago, exactly the same was true for bonding, bridge or vlan
> configuration: all known kernels supported ioctl() or sysfs interfaces
> for them, none supported netlink at that point. By your logic, the right
> course of action would have been using ioctl() and sysfs for iproute2
> support. Instead, rtnetlink interfaces were implemented and used by
> iproute2. I believe it was the right choice.

Sure, but netlink does not yet provide the needed functionality for
our use case.

netlink was a medium/long term plan, for the kernel side at least.
I would totally understand and support a new iocl() in the kernel being blocked.
(In fact I have blocked Kevin from adding a sysfs and advised to use
existing ioctl())

Here we are not changing the kernel, we let ethtool use existing ABI
and old kernels.

I think you are mixing your own long term plans with simply letting ethtool
to meet existing kernel functionality.

>
> > Are you working on the netlink interface, or are you requesting us to
> > implement it ?
>
> If it helps, I'm willing to write the kernel side.

Yes please, that would help, but will still require months of
deployments at Google scale.


Or both, if
> necessary, just to avoid adding another ioctl monument that would have
> to be kept and maintained for many years, maybe forever.

The kernel part is there, and lack of equivalent  netlink support
means we have to keep it for ten years at least.

>
> > The ioctl has been added years ago, and Kevin patch is reasonable enough.
>
> And there is a utility using the ioctl, as Andrew pointed out. Just like
> there were brctl and vconfig and ioctl they were using. The existence of
> those ioctl was not considered sufficient reason to use them when bridge
> and vlan support was added to iproute2. I don't believe today's
> situation with ethtool is different.

I suspect Richard Cochran wrote the 190 lines of code outside of
ethtool because it was easier to not have to convince the ethtool
maintainer at that time :)

We do not have hwstamp_ctl deployed at this very moment, and for us it
is simply much faster to deploy a new ethtool version than having to
get security teams
approval to install a new binary.

Honestly, if this was an option, we would not have even bothered
writing ethtool support.

Now, you want netlink support instead of ioctl(), that is a very
different scope and amount of work.

Thanks.
