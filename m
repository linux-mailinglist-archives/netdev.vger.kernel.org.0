Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0F6332CB
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiKVCNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKVCNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:13:16 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45489264A8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:13:15 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id w9so8486133qtv.13
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dIRhDVWiab3bjDPVgRSMneOqOqqdAB0Fj+0SdzxoeH4=;
        b=K9/WYl+a/zA/3Bl3JMxOy+5d3Ranm4/09Q5QOUYmPL+W0lXz42G8zpyJNGRzMOzdXS
         E4WSrSA1DN2dJD0s+V/3FSjJdyPX9trb4FQbWFaSdL5kQiORd2yX+o3UhWfy0/zonEuF
         QIgy9V6AC47+aRbaCOfW7turbl5LERJRpytgieuUfzmfLUlgA30D8lb/5h6OoezM5MKX
         tmHHi5lZ/2dlKzpE0feihA0xoQsMsqiQDQLK9TVvcviwdLfJR0dKJdiHWZr95ilpWvEI
         /N+Q57aJbsJgU2APNZjNBI3/wphN+7jhTHfREzufA6PWz7pbB98tic7AEiqlJgledR22
         v8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIRhDVWiab3bjDPVgRSMneOqOqqdAB0Fj+0SdzxoeH4=;
        b=0esK03dW5T7AEKbD3tShWtZV4BzFlzZ0k5f2u0gL/I5ht+1mspMaPpl0jaH36c1TLI
         iSfqTjQ6CNf48JOwxlmv5bFzLqEVzEIr0NkxkudPvfsFWl9wqIQ9E4YYscb/41IMhndE
         0ghyci9SdCQo3qItp1knpWjpwislRXkqOVLMjo+VJ82USk0OhE4IE5KdG+rxIDsL5b5a
         kSZ3ru8jO0gfjUMyMF5LjYnzqWd2N8zRoLWjL8JWnBP6DD2UPd/hcPahS7nC5eKCUj8d
         LqNHJkSva/EOLjGPU2VGLphtd9tBA4mymdie53tKSvTSwfinRKTL8AvGjq/ybBuyLzLn
         BN7Q==
X-Gm-Message-State: ANoB5pl3bfjkniXutGFhZ9Xb2PTzSGFWnizcshAwbsuAzKv6FxqOUBP4
        p07uv1JLdggQBC4k8Idc5Xm1wg==
X-Google-Smtp-Source: AA0mqf7ZUnS7zXBNzp66ZG4R9u/uDVqaGTLIoiFUGabn7Ga5y6kCmFkWwhn/fiyH+teiO3jguTs+zg==
X-Received: by 2002:a05:622a:5c8e:b0:3a5:5c9e:d453 with SMTP id ge14-20020a05622a5c8e00b003a55c9ed453mr20810640qtb.403.1669083194399;
        Mon, 21 Nov 2022 18:13:14 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id k7-20020ac84787000000b0039cc7ebf46bsm7463590qtq.93.2022.11.21.18.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 18:13:13 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oxIme-009YhX-R6;
        Mon, 21 Nov 2022 22:13:12 -0400
Date:   Mon, 21 Nov 2022 22:13:12 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com>,
        Leon Romanovsky <leon@kernel.org>, chenzhongjin@huawei.com,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>
Subject: Re: [syzbot] unregister_netdevice: waiting for DEV to become free (7)
Message-ID: <Y3wwOPmH1WoRj0Uo@ziepe.ca>
References: <00000000000060c7e305edbd296a@google.com>
 <CACT4Y+a=HbyJE3A_SnKm3Be-kcQytxXXF89gZ_cN1gwoAW-Zgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+a=HbyJE3A_SnKm3Be-kcQytxXXF89gZ_cN1gwoAW-Zgw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 02:28:53PM +0100, Dmitry Vyukov wrote:
> On Fri, 18 Nov 2022 at 12:39, syzbot
> <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    9c8774e629a1 net: eql: Use kzalloc instead of kmalloc/memset
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17bf6cc8f00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9eb259db6b1893cf
> > dashboard link: https://syzkaller.appspot.com/bug?extid=5e70d01ee8985ae62a3b
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1136d592f00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1193ae64f00000
> >
> > Bisection is inconclusive: the issue happens on the oldest tested release.
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=167c33a2f00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=157c33a2f00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=117c33a2f00000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com
> >
> > iwpm_register_pid: Unable to send a nlmsg (client = 2)
> > infiniband syj1: RDMA CMA: cma_listen_on_dev, error -98
> > unregister_netdevice: waiting for vlan0 to become free. Usage count = 2
> 
> +RDMA maintainers
> 
> There are 4 reproducers and all contain:
> 
> r0 = socket$nl_rdma(0x10, 0x3, 0x14)
> sendmsg$RDMA_NLDEV_CMD_NEWLINK(...)
> 
> Also the preceding print looks related (a bug in the error handling
> path there?):
> 
> infiniband syj1: RDMA CMA: cma_listen_on_dev, error -98

I'm pretty sure it is an rxe bug

ib_device_set_netdev() will hold the netdev until the caller destroys
the ib_device

rxe calls it during rxe_register_device() because the user asked for a
stacked ib_device on top of the netdev

Presumably rxe needs to have a notifier to also self destroy the rxe
device if the underlying net device is to be destroyed?

Can someone from rxe check into this?

Jason
