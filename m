Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754EC5EEA13
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 01:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiI1XUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 19:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiI1XUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 19:20:40 -0400
Received: from mail-pj1-x1063.google.com (mail-pj1-x1063.google.com [IPv6:2607:f8b0:4864:20::1063])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F13D2A722
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:20:36 -0700 (PDT)
Received: by mail-pj1-x1063.google.com with SMTP id u12so5097988pjj.1
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:references:message-id:subject:cc:to
         :from:date:dkim-signature:x-gm-message-state:from:to:cc:subject:date;
        bh=P+xjXaurwhtJmqmMf0PJEzjAO1MMXyc/q6GQ8sS6wLs=;
        b=ppvbygbgb1Lw/TH+4F+kn/xyyFeIUb5VByZffpnE/3K6xTFjXGinFR+mZ2CxPuHcoU
         8wLJ4WPEVEg13ZFiXKceoT40Z317gX9xnfsk92uloCCxoYISFaTHCYSiQMqssfDAM3Ai
         5RY5Q8mVIqd+JLbgW3Sdpk8730vjAaIQeJefwd+6jc0j3M1b+UFau4zUG7Z7KseIAfSK
         CyV8yYl93aX2qtzwI00hEC6jWmpOK0/Fu8JuP6Mih780g/o61BNitoA5iEm6Ce4diFuc
         PkVc11v7+g033eKtCgYY9mB8m7UzXacmEkAdAhVxoZEHzvae9Zxzn4UQlvChI+NQqDSi
         fjCg==
X-Gm-Message-State: ACrzQf1qFknoJkwoSuCQrleUU95to4koMokU7I8qslHMB9cBWdxncn2A
        oPyGHK2nCa0pxrxwvxvySIKadwNQrrpEpnVVduqgGd4CiqR5
X-Google-Smtp-Source: AMsMyM4Psc2ub1XLhg771C+RWiqbj5BvQWHnC6aLQRGXvnUrNmcInm+SYK4mMjkHMWwToI5/HHnXGWMgS48Z
X-Received: by 2002:a17:903:11cf:b0:178:a8f4:d511 with SMTP id q15-20020a17090311cf00b00178a8f4d511mr410333plh.72.1664407235579;
        Wed, 28 Sep 2022 16:20:35 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id u11-20020a170902714b00b0016ee647ca85sm223889plm.93.2022.09.28.16.20.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Sep 2022 16:20:35 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.71.70])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 23A60301BD94;
        Wed, 28 Sep 2022 16:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-B; t=1664407235;
        bh=P+xjXaurwhtJmqmMf0PJEzjAO1MMXyc/q6GQ8sS6wLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKAGIolPTBrjq14fjU+yv8WHtOnQNJEyyjVWQRvq230g1uiLby3q4VxaAWbqI31jP
         np9Jthr79J0qp/NGRmhzcT7gBnApItlwuM+igi7XdudHhMYVFqa7NWHMxAYYhAzPH7
         04jcvxWW0K/W7AHNaqgn8WEMnNO5C+gXumZQ19Ic=
Received: from kevmitch by chmeee with local (Exim 4.96)
        (envelope-from <kevmitch@arista.com>)
        id 1odgLx-000WEQ-2s;
        Wed, 28 Sep 2022 16:20:33 -0700
Date:   Wed, 28 Sep 2022 16:20:33 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: new warning caused by ("net-sysfs: update the queue counts in
 the unregistration path")
Message-ID: <YzTWwf/FyzBKGaww@chmeee>
References: <YzOjEqBMtF+Ib72v@chmeee>
 <166435838013.3919.14607521178984182789@kwain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166435838013.3919.14607521178984182789@kwain>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 11:46:20AM +0200, Antoine Tenart wrote:
> Quoting Kevin Mitchell (2022-09-28 03:27:46)
> > With the inclusion of d7dac083414e ("net-sysfs: update the queue counts in the
> > unregistration path"), we have started see the following message during one of
> > our stress tests that brings an interface up and down while continuously
> > trying to send out packets on it:
> >
> > et3_11_1 selects TX queue 0, but real number of TX queues is 0
> >
> > It seems that this is a result of a race between remove_queue_kobjects() and
> > netdev_cap_txqueue() for the last packets before setting dev->flags &= ~IFF_UP
> > in __dev_close_many(). When this message is displayed, netdev_cap_txqueue()
> > selects queue 0 anyway (the noop queue at this point). As it did before the
> > above commit, that queue (which I guess is still around due to reference
> > counting) proceeds to drop the packet and return NET_XMIT_CN. So there doesn't
> > appear to be a functional change. However, the warning message seems to be
> > spurious if not slightly confusing.
>
> Do you know the call traces leading to this? Also I'm not 100% sure to
> follow as remove_queue_kobjects is called in the unregistration path
> while the test is setting the iface up & down. What driver is used?

Sorry, my language was imprecise. The device is being unregistered and
re-registered. The driver is out of tree for our front panel ports. I don't
think this is specific to the driver, but I'd be happy to be convinced
otherwise.

The call trace to the queue removal is

[  628.165565]  dump_stack+0x74/0x90
(remove_queue_kobject)
[  628.165569]  netdev_unregister_kobject+0x7a/0xb3
[  628.165572]  rollback_registered_many+0x560/0x5c4
[  628.165576]  unregister_netdevice_queue+0xa3/0xfc
[  628.165578]  unregister_netdev+0x1e/0x25
[  628.165589]  fdev_free+0x26e/0x29d [strata_dma_drv]

The call trace to the warning message is

[ 1094.355489]  dump_stack+0x74/0x90
(netdev_cap_txqueue)
[ 1094.355495]  netdev_core_pick_tx+0x91/0xaf
[ 1094.355500]  __dev_queue_xmit+0x249/0x602
[ 1094.355503]  ? printk+0x58/0x6f
[ 1094.355510]  dev_queue_xmit+0x10/0x12
[ 1094.355518]  packet_sendmsg+0xe88/0xeee
[ 1094.355524]  ? update_curr+0x6b/0x15d
[ 1094.355530]  sock_sendmsg_nosec+0x12/0x1d
[ 1094.355533]  sock_write_iter+0x8a/0xb6
[ 1094.355539]  new_sync_write+0x7c/0xb4
[ 1094.355543]  vfs_write+0xfe/0x12a
[ 1094.355547]  ksys_write+0x6e/0xb9
[ 1094.355552]  ? exit_to_user_mode_prepare+0xd3/0xf0
[ 1094.355555]  __x64_sys_write+0x1a/0x1c
[ 1094.355559]  do_syscall_64+0x31/0x40
[ 1094.355564]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

>
> As you said and looking around queue 0 is somewhat special and used as a
> fallback. My suggestion would be to 1) check if the above race is
> expected 2) if yes, a possible solution would be not to warn when
> real_num_tx_queues == 0 as in such cases selecting queue 0 would be the
> expected fallback (and you might want to check places like [1]).

Yes this is exactly where this is happening and that sounds like a good idea to
me. As far as I can tell, the message is completely innocuous. If there really
are no cases where it is useful to have this warning for real_num_tx_queues ==
0, I could submit a patch to not emit it in that case.

>
> Thanks,
> Antoine
>
> [1] https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L4126
