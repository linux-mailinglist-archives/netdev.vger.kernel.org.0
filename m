Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34360CAF80
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732942AbfJCTpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:45:30 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41486 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732794AbfJCTpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:45:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id d16so5279275qtq.8
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 12:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9vnYEebM/KLyKF755hGT2k/mx49Fw6HZAn0yivggXI8=;
        b=UDcw0CO83TKWUrgy4xSXbkUPNuw9nuXuHKgnU6Im6FKsigi7FnEm2PH48nakRbgL+/
         fiC4sXXqUtaYuPd9TbnIXv8Gnm9vyIJLe8NQ6uKy+FR37RR7Rk55j+fAcfCPFCZlS88n
         mZ7twE1rJ1NMDIivlVHCDDKXzoSlwY6mpQ4i7/n10CzeB48yAF0qE4EsojcAHokmzovX
         kJ/L61PTwhrYlIEfH+a23B3AfFYD6c7w3DnbadzIkgW8I7gEd6u2zstJJ1MCBX+kH7by
         62PbLHmHfTrkgUjZPf2AuAPQ7mgyTYzbamK4otYlXZS0wDebjGd+0O0cYVBC+6C6hKEf
         BtZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9vnYEebM/KLyKF755hGT2k/mx49Fw6HZAn0yivggXI8=;
        b=XQEGxrTgVyHmM+n9p2tygVOON4bW3JEfVwOXYPUDyIvyZdrQy7B9lEfkYNQrvlPVuJ
         gQ2O9cwosvj1IoeFgUtxNw4FlHqLipeXwKY33jOREZwQhVDDB+LpoJk7T3yyLdYioBf/
         4ckBx5aptQjorkJARfb1JsLwrlIB1R9vgqnbXQlaX7VqhpffB6YD6l/Z4Qj5x9o3uwgR
         dZ5hdBikeYIJYGIpEWqoq1rAoermjAv2atkBZ71GBCbd6QewjBRfMgEqTho29z8b4U5u
         DTc/NIxRwUsBZepIN3Dn67cp1/95zPAhh3SNvGNMHJ/RYbLCHhL/+Bu9O1V48g4Pm1DH
         natw==
X-Gm-Message-State: APjAAAWrcXub9adRImk57n9PSrO4Vg0KSxJQk2F0GwGmSYPAt3x9io0r
        n7sL4zlmw5we8+hLdiiLPdc=
X-Google-Smtp-Source: APXvYqxdFEjdcYY0iVH6gKT2oMjLdlqKxcqWmRVKCW/jc+Zv2xXLm1MYblpptiQWMqihxPLUBcb42w==
X-Received: by 2002:ac8:6686:: with SMTP id d6mr2791417qtp.177.1570131929077;
        Thu, 03 Oct 2019 12:45:29 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.85])
        by smtp.gmail.com with ESMTPSA id a14sm2310855qkg.59.2019.10.03.12.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 12:45:28 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CE5ABC07B9; Thu,  3 Oct 2019 16:45:25 -0300 (-03)
Date:   Thu, 3 Oct 2019 16:45:25 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
Message-ID: <20191003194525.GD3498@localhost.localdomain>
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
 <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com>
 <CAM_iQpXa=Kru2tXKwrErM9VsO40coBf9gKLRfwC3e8owKZG+0w@mail.gmail.com>
 <20190921192434.765d7604@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190921192434.765d7604@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 21, 2019 at 07:24:34PM -0700, Jakub Kicinski wrote:
> On Wed, 18 Sep 2019 22:15:24 -0700, Cong Wang wrote:
> > On Wed, Sep 18, 2019 at 7:41 PM David Ahern <dsahern@gmail.com> wrote:
> > > On 9/18/19 5:24 PM, Cong Wang wrote:  
> > > > The TCA_KIND attribute is of NLA_STRING which does not check
> > > > the NUL char. KMSAN reported an uninit-value of TCA_KIND which
> > > > is likely caused by the lack of NUL.
> > > >
> > > > Change it to NLA_NUL_STRING and add a max len too.
> > > >
> > > > Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")  
> > >
> > > The commit referenced here did not introduce the ability to go beyond
> > > memory boundaries with string comparisons. Rather, it was not complete
> > > solution for attribute validation. I say that wrt to the fix getting
> > > propagated to the correct stable releases.  
> > 
> > I think this patch should be backported to wherever commit 8b4c3cdd9dd8
> > goes, this is why I picked it as Fixes.
> 
> Applied, queued for 4.14+, thanks!

Ahm, this breaks some user applications.

I'm getting "Attribute failed policy validation" extack error while
adding ingress qdisc on an app using libmnl, because it just doesn't
pack the null byte there if it uses mnl_attr_put_str():
https://git.netfilter.org/libmnl/tree/src/attr.c#n481
Unless it uses mnl_attr_put_strz() instead.

Though not sure who's to blame here, as one could argue that the
app should have been using the latter in the first place, but well..
it worked and produced the right results.

Ditto for 199ce850ce11 ("net_sched: add policy validation for action
attributes") on TCA_ACT_KIND.
