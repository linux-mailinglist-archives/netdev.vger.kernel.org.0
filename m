Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D12123F769
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 13:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHHLoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 07:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgHHLoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 07:44:05 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3581FC061756;
        Sat,  8 Aug 2020 04:44:05 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m22so4782991ljj.5;
        Sat, 08 Aug 2020 04:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=g+BRSz9BzyexYllSrwwZQNLWlHY2AU0uIR/ZntSlMEE=;
        b=YV0vp5vnjmrVGkML1kfCdA32bWBzvZ1IfYaEAQZm6uqsRQT5etHUxTyPd7M1MnGw0p
         MsbuigX3XtP69o/ZIALOViqpPxIHWD0SqIhoAjzrUvZLxw0hTcfTmMDld1d8sJtM8rLU
         JDVd5ZH96AgaD95oNY44sz3fvbL3LGIdlJI8/vzcFDXbJPvTTUZR5vAsdNBt+5b8UYhL
         M/w2dEajh8fvCo2fOiKL0fpD80SPww1WoZTRpay3pOslCuGCPcoqWXwv50nKqEZJTmqO
         po1X/3Fq+XwW2LhP35xtohr2vG8g0Z6qH6P4WtPXA7+w+4iXB8BLfSSZ+GrvNq3/SBh5
         /AxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=g+BRSz9BzyexYllSrwwZQNLWlHY2AU0uIR/ZntSlMEE=;
        b=P/1uqG0OSeeKvDE9HLxQubVWyDioncS4RFTABJKrLQVE6JhiiWOKr7lkBCFhzVxhbx
         psVsTbnC/eIQAPd8i9cBXUlUvRK/4ndRUVX6QvN1BkAZTg9R3TUdD697uQ814AHvEnHh
         gt+i+I9YCNK77lAtwxbhvrUnqKGf0ly1yv5ODvhV3R2dyZTnGAu+PPmYhsbURAbLJypI
         BmAQYu+QbRfXDA4XDi3FCtH6pwArn+qDYDp5gI1uOHcE3BsNKwKyc/V7tBJscGmAr+Gg
         WPkRnixChldz0bjtgcchN+lcBvoM/iNnoGBVc5ihTBkf39VMcTpUrZSPuSB1II0Qdp+c
         fZzg==
X-Gm-Message-State: AOAM532Mt6wlfw1Bizy/MeSE8fdxeHOCmvqunxBid2khe7/za+WJKa10
        UmNcTvwDYME3kkU6Vd4KtWI=
X-Google-Smtp-Source: ABdhPJzynEhbjJzM30ynswTZ/CgxHMLrccHOAuBTVwzv3q2DxGgXfIBAL6+mi+S0purPYiGXJSvILQ==
X-Received: by 2002:a2e:7211:: with SMTP id n17mr8081474ljc.165.1596887043602;
        Sat, 08 Aug 2020 04:44:03 -0700 (PDT)
Received: from pc636 (h5ef52e31.seluork.dyn.perspektivbredband.net. [94.245.46.49])
        by smtp.gmail.com with ESMTPSA id h6sm5563764lfc.84.2020.08.08.04.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 04:44:02 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Sat, 8 Aug 2020 13:44:00 +0200
To:     Johan =?utf-8?B?S27DtsO2cw==?= <jknoos@google.com>
Cc:     paulmck@kernel.org, Joel Fernandes <joel@joelfernandes.org>,
        Gregory Rose <gvrose8192@gmail.com>, bugs@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
Message-ID: <20200808114400.GA15974@pc636>
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com>
 <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72>
 <CA+Sh73O25w4ktkvnxTpjckX857C7ACqZmrSLyM-NgowADpt-yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+Sh73O25w4ktkvnxTpjckX857C7ACqZmrSLyM-NgowADpt-yA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Aug 7, 2020 at 3:20 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Fri, Aug 07, 2020 at 04:47:56PM -0400, Joel Fernandes wrote:
> > > Hi,
> > > Adding more of us working on RCU as well. Johan from another team at
> > > Google discovered a likely issue in openswitch, details below:
> > >
> > > On Fri, Aug 7, 2020 at 11:32 AM Johan Knöös <jknoos@google.com> wrote:
> > > >
> > > > On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com> wrote:
> > > > >
> > > > >
> > > > >
> > > > > On 8/3/2020 12:01 PM, Johan Knöös via discuss wrote:
> > > > > > Hi Open vSwitch contributors,
> > > > > >
> > > > > > We have found openvswitch is causing double-freeing of memory. The
> > > > > > issue was not present in kernel version 5.5.17 but is present in
> > > > > > 5.6.14 and newer kernels.
> > > > > >
> > > > > > After reverting the RCU commits below for debugging, enabling
> > > > > > slub_debug, lockdep, and KASAN, we see the warnings at the end of this
> > > > > > email in the kernel log (the last one shows the double-free). When I
> > > > > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitch:
> > > > > > fix possible memleak on destroy flow-table"), the symptoms disappear.
> > > > > > While I have a reliable way to reproduce the issue, I unfortunately
> > > > > > don't yet have a process that's amenable to sharing. Please take a
> > > > > > look.
> > > > > >
> > > > > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > > > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-callback handling
> > > > > > e99637becb2e rcu: Add support for debug_objects debugging for kfree_rcu()
> > > > > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() work
> > > > > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_todo
> > > > > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> > >
> > > Note that these reverts were only for testing the same code, because
> > > he was testing 2 different kernel versions. One of them did not have
> > > this set. So I asked him to revert. There's no known bug in the
> > > reverted code itself. But somehow these patches do make it harder for
> > > him to reproduce the issue.
> 
> I'm not certain the frequency of the issue changes with and without
> these commits on 5.6.14, but at least the symptoms/definition of the
> issue changes. To clarify, this is what I've observed with different
> kernels:
> * 5.6.14:  "kernel BUG at mm/slub.c:304!". Easily reproducible.
> * 5.6.14 with the above RCU commits reverted: the warnings reported in
> my original email. Easily reproducible.
> * 5.6.14 with the above RCU commits reverted and
> 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 reverted: no warnings
> observed (the frequency might be the same as on 5.5.17).
> * 5.5.17: warning at kernel/rcu/tree.c#L2239. Difficult to reproduce.
> Maybe a different root cause.
> 
If you can reproduce it, maybe enabling CONFIG_KASAN will detect something?
It can detect out-of-bounds and use after free bugs.

Thanks.

--
Vlad Rezki
