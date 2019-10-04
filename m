Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FCDCC6A4
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbfJDXrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:47:09 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:34847 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:47:08 -0400
Received: by mail-qt1-f177.google.com with SMTP id m15so10968772qtq.2
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=47CXNoT/kSH5ycRh7j1vW5rNHN5aWIAEmJwiS7zuX4Q=;
        b=ettzJgmlWoFyRq10V3MYPk/2PWPrdxH7gaqCr/tdTd+YWqzchYofOjbn8Vd/SNjKeP
         1Gge1eRhwByVgZ2F4peDw9Z5MoPkXPX6w6e/mVFPAIP+MIVKgDvGUHOQpG88LbdQGQcf
         YWoeqLMhckQs6F0+IGHcl1jWTQYMW5h9rdQYhZueFZX3A3ozm6q4AWuj3jxr3tXIDImI
         LooYV2j0Gj/MpN7eymc0vX1Qg/gkPTxWU1Q2qC43pk6n63OBorR5roH6IIQorUbnDBAT
         YhaIehusdMq3rk7cYJW5xjbf7fBxTQf2n08ddzgsYOF9CVWR0CihxNYJo7eSBwVyl2Xl
         mAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=47CXNoT/kSH5ycRh7j1vW5rNHN5aWIAEmJwiS7zuX4Q=;
        b=kbWfrgbYkWoV0xW+bclY/lP7tshEDnBAqS/3IPHm0F5AxRxgTvY+Yd4tLcLfnRwMYO
         fPsRNPWa3VgIXhsVrD0OHxobjDGGdoP/i+iNaWGzCX+ERLxhHhToLXwnUYS5SBql4pQK
         8mKgr/2nT038UNRScp9XTFBoLuNO1dal92m5aBvd9RLE9CXX7i8H0LZTDXOqzxqenuBg
         CcgZRLdcBQwuXCMfNLtemB4AI/qyXAJ536zsnfTmnsSsFyeEyyGQn6EmckVkyCsCc7+E
         Y2gyg5rSbGISJzHMwfz++cAbhbC5Qg6S9vkMrqCJYzAuzjvQAYwsZkVhlNAZKjQdVJLw
         2EWw==
X-Gm-Message-State: APjAAAXdPDedSKXm6dPRSFW1rdyMyxKYjLRxqbZ2rfwvTYzdZ70UAWpc
        MJvKe1l+3Nso56UnlYNJTLel3g==
X-Google-Smtp-Source: APXvYqyJyKDlKMaUYl/1d3dSWhDgBjUxV3++XWtrtmmq8ogv5vORznczfr/qaCe5wp5sqVbA+WD6rQ==
X-Received: by 2002:a0c:fdcc:: with SMTP id g12mr16978271qvs.104.1570232827717;
        Fri, 04 Oct 2019 16:47:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 54sm5505867qts.75.2019.10.04.16.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 16:47:07 -0700 (PDT)
Date:   Fri, 4 Oct 2019 16:47:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
Message-ID: <20191004164701.148644ec@cakuba.netronome.com>
In-Reply-To: <CAM_iQpUomr7PkWahew9WkhNnKB7QGg0gTjurccLEwkgh24TARw@mail.gmail.com>
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
        <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com>
        <CAM_iQpXa=Kru2tXKwrErM9VsO40coBf9gKLRfwC3e8owKZG+0w@mail.gmail.com>
        <20190921192434.765d7604@cakuba.netronome.com>
        <20191003194525.GD3498@localhost.localdomain>
        <20191004155420.19bd68d2@cakuba.hsd1.ca.comcast.net>
        <CAM_iQpUomr7PkWahew9WkhNnKB7QGg0gTjurccLEwkgh24TARw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 16:23:40 -0700, Cong Wang wrote:
> On Fri, Oct 4, 2019 at 3:54 PM Jakub Kicinski wrote:
> > On Thu, 3 Oct 2019 16:45:25 -0300, Marcelo Ricardo Leitner wrote:  
> > > On Sat, Sep 21, 2019 at 07:24:34PM -0700, Jakub Kicinski wrote:  
> > > > Applied, queued for 4.14+, thanks!  
> > >
> > > Ahm, this breaks some user applications.
> > >
> > > I'm getting "Attribute failed policy validation" extack error while
> > > adding ingress qdisc on an app using libmnl, because it just doesn't
> > > pack the null byte there if it uses mnl_attr_put_str():
> > > https://git.netfilter.org/libmnl/tree/src/attr.c#n481
> > > Unless it uses mnl_attr_put_strz() instead.
> > >
> > > Though not sure who's to blame here, as one could argue that the
> > > app should have been using the latter in the first place, but well..
> > > it worked and produced the right results.
> > >
> > > Ditto for 199ce850ce11 ("net_sched: add policy validation for action
> > > attributes") on TCA_ACT_KIND.  
> >
> > Thanks for the report Marcelo! This netlink validation stuff is always
> > super risky I figured better find out if something breaks sooner than
> > later, hence the backport.
> >
> > So if I'm understanding this would be the fix?  
> 
> Of course not, you just break KMSAN again. Please read the original
> report.

The fix for the regression. I'm establishing the rest of 199ce850ce11
("net_sched: add policy validation for action attributes") is fine.

I mentioned this brings back the problem KMSAN reported in the part of
the email you cut off. str*cpy is the obvious answer for reimplementing
that fix.

> I will send a patch

Please do.
