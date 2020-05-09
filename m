Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB301CBE23
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgEIGpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgEIGpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:45:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E696CC061A0C;
        Fri,  8 May 2020 23:45:40 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q124so1939564pgq.13;
        Fri, 08 May 2020 23:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z5YwzXDO2wr4NdgAQEK2OLWbJWnD0XZQ+LroAMbjKBI=;
        b=drSdq+VnJZ2Ez7DszCXKTAZJjtjTGW/SEExiJ4AElgFBQxydLTOAvLdz82ctGVPqAg
         20vT+/++U3HqnctlRR+EpjX3VOTdDbdnrcql+44MmHk4hl5O8R2yl2oh6V7oC8uMIo5u
         ljn7dJ4jDEAeDQ4zu6eqyB2oW2zqQhf/wafg0Pu6vcoZSBMTRJmRVNFNNXW2QrW3njKN
         9R66P8oi1REQvs7na6y0fASCKJFQgsqb7U0TV3d6cbHv2yknngPfi5npFbWT4ZDNdYzD
         MVnf/9x3sEJrUckEe0kx1+whxHwq2CF842kdn4WANFb8XJ/4cEKOEVjY7pTI1/6HH5YF
         oIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z5YwzXDO2wr4NdgAQEK2OLWbJWnD0XZQ+LroAMbjKBI=;
        b=UPsiPOWWHz2H5i0Bu7J0o2yWywJV33maeP/QhJu7H0v/6inNuP5CzvUvnC/ZfBNE9i
         n/7csM8YbUaAo4+zNKNE86qoQ8iC4Zio9x4SrFN7mBbj8lhlDQHHAhyHEd2q8K9ipj96
         RzGvSGUofS7Z2N1CJmdHZbAnehiBfiJc7kQEpcYvgoBe+KPsELzwKvOVnU7r1fkpFVGr
         5wKOIMBndfgtIVPi5k9taLQpDusR8QabayGCTqBIGeVZ5icYfOoyMEjk82v6Ibg01wfc
         j715FKrWRvnrnCDpyp4If6C3D7Bls2+JzzAzKmZLbFmg3UF0UsugNkwKFOPNGOUBF6dM
         Pv/w==
X-Gm-Message-State: AGi0PuZyEUDrGCwdwnXDg/p0QK96WrEqkWcIn+t7V4MfUW6qP9EEBMEC
        NAP2VDkU4IhBtmvaAeABehc=
X-Google-Smtp-Source: APiQypLocseS27AE3Gkh6ABthIP0T5m7WOtu89Q31DK7gG6cPiIlcLSkoGHD6s/wYX0DCRhM8C5UYQ==
X-Received: by 2002:a63:f809:: with SMTP id n9mr5456305pgh.355.1589006740271;
        Fri, 08 May 2020 23:45:40 -0700 (PDT)
Received: from kernel-dev-lenovo ([103.87.56.89])
        by smtp.gmail.com with ESMTPSA id k5sm3978916pjl.32.2020.05.08.23.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 23:45:39 -0700 (PDT)
Date:   Sat, 9 May 2020 12:15:31 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Qian Cai <cai@lca.pw>, Dmitry Vyukov <dvyukov@google.com>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        syzbot <syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "paul E. McKenney" <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 ipmr_get_table
Message-ID: <20200509064531.GA7563@kernel-dev-lenovo>
References: <000000000000df9a9805a455e07b@google.com>
 <CACT4Y+YnjK+kq0pfb5fe-q1bqe2T1jq_mvKHf--Z80Z3wkyK1Q@mail.gmail.com>
 <34558B83-103E-4205-8D3D-534978D5A498@lca.pw>
 <20200507061635.449f9495@canb.auug.org.au>
 <20200507062601.7befefa6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507062601.7befefa6@canb.auug.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 06:26:01AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Thu, 7 May 2020 06:16:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi Qian,
> > 
> > On Tue, 28 Apr 2020 09:56:59 -0400 Qian Cai <cai@lca.pw> wrote:
> > >  
> > > > On Apr 28, 2020, at 4:57 AM, Dmitry Vyukov <dvyukov@google.com> wrote:    
> > > >> net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!    
> > > 
> > > https://lore.kernel.org/netdev/20200222063835.14328-2-frextrite@gmail.com/
> > > 
> > > Never been picked up for a few months due to some reasons. You could probably
> > > need to convince David, Paul, Steven or Linus to unblock the bot or carry patches
> > > on your own?  
> > 
> > Did you resubmit the patch series as Dave Miller asked you to (now that
> > net-next is based on v5.7-rc1+)?
> 
> In any case, I have added the 2 commits in this series to my fixes tree
> from today - I will remove them when some other tree has a solution
> applied.
> 

Hi Stephen

I'll follow up with David regarding this patch series.

Thanks
Amol

> -- 
> Cheers,
> Stephen Rothwell


