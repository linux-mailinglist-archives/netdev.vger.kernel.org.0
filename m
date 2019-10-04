Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C346CC677
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbfJDXXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:23:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40092 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728913AbfJDXXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:23:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so4787436pfb.7
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ije+cDh0+cj1FiZWJYH0ri+Iz81DA2eR1rarcfhe8U=;
        b=TIII39IczALtjOwRvRpcvcGKNJnu8/Lr/AyTaa6nJ2xpTe7dmtm4LBbMqvsE514lkg
         esScLJM5vSbf0Hu9RAITfUat9yxv59nz3ajYdde06yM19HJ/TfMKP4dPlC+cU/SBGGIz
         8Bz6hZp0+1kzBlUzhV44PHomcXnzXxNGTWKppxrekmdg4qu1I8FTG+Lz3q4d/osrQ8Co
         Z49Tu2KnsCGKMZW2I6+fZbj+ZGdrxoLNXJh7czIWa5eeUx8PqiuHiJ+YiHMgMcsZAt1B
         lZVIYLS15BwNUOe9aIXYhaFwOr/WxBYgL9+7/68Vhd0TZOFaReQxRTk8+jWneRgEmHUl
         ODQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ije+cDh0+cj1FiZWJYH0ri+Iz81DA2eR1rarcfhe8U=;
        b=TnoIfR2aCCLpmN4U25GpNMnG/xckFs+WgVL7lUoYR2ZM5MNK8+GjGYRTi/91IdtYo3
         aOMNOwS0TCgjeKl6OFFfFma7XOhjoq+Zi4WvRCyvCCwlHkpyfvzL7BegpfXE5fJQ1KDU
         6JlMUt7iJtQGdd4jrAgIEkoT+aJLkyqLa5rsURdcL/ZhxK5ookZGT99kzT2SkYYp+OkD
         GIL/Q1EQBzUI8zA0N7qIBqmqqH1LnRqRaalPbQlWyYY4ESM+lEllfM00eefppFxtWCzy
         /2r2Km1Edpqv9gVxeQqK5AvF764pcHk3/oUOX3numoLO+PfdMSo3OD1ppLZmuYZXLoPm
         cJTg==
X-Gm-Message-State: APjAAAXjA1X9QyOoPt8wCmZpyq5lqiJOoh1dFg4pCktOSn2zeyKaR7/Q
        nZSQIBkS/DjfRcOm+cDj5hIPuMYgrL8WX+b8UF4=
X-Google-Smtp-Source: APXvYqyhfGhJAzV7vmlcsdf1A4xwzi8201YBuokSOYN/VndY51KQERbQR/s6EGFVxluciQOobA6UebfQ/jsB6v5ulBE=
X-Received: by 2002:aa7:8b13:: with SMTP id f19mr19612582pfd.94.1570231431884;
 Fri, 04 Oct 2019 16:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
 <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com> <CAM_iQpXa=Kru2tXKwrErM9VsO40coBf9gKLRfwC3e8owKZG+0w@mail.gmail.com>
 <20190921192434.765d7604@cakuba.netronome.com> <20191003194525.GD3498@localhost.localdomain>
 <20191004155420.19bd68d2@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191004155420.19bd68d2@cakuba.hsd1.ca.comcast.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 4 Oct 2019 16:23:40 -0700
Message-ID: <CAM_iQpUomr7PkWahew9WkhNnKB7QGg0gTjurccLEwkgh24TARw@mail.gmail.com>
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 3:54 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 3 Oct 2019 16:45:25 -0300, Marcelo Ricardo Leitner wrote:
> > On Sat, Sep 21, 2019 at 07:24:34PM -0700, Jakub Kicinski wrote:
> > > Applied, queued for 4.14+, thanks!
> >
> > Ahm, this breaks some user applications.
> >
> > I'm getting "Attribute failed policy validation" extack error while
> > adding ingress qdisc on an app using libmnl, because it just doesn't
> > pack the null byte there if it uses mnl_attr_put_str():
> > https://git.netfilter.org/libmnl/tree/src/attr.c#n481
> > Unless it uses mnl_attr_put_strz() instead.
> >
> > Though not sure who's to blame here, as one could argue that the
> > app should have been using the latter in the first place, but well..
> > it worked and produced the right results.
> >
> > Ditto for 199ce850ce11 ("net_sched: add policy validation for action
> > attributes") on TCA_ACT_KIND.
>
> Thanks for the report Marcelo! This netlink validation stuff is always
> super risky I figured better find out if something breaks sooner than
> later, hence the backport.
>
> So if I'm understanding this would be the fix?

Of course not, you just break KMSAN again. Please read the original
report.

I will send a patch to use nla_strlcpy() instead, I think it will make
everyone happy here.

Thanks.
