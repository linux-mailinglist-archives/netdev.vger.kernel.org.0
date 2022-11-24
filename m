Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE581636EE7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 01:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKXAWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 19:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKXAWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 19:22:39 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E371183A
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 16:22:37 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id j26so107031qki.10
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 16:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nu3y1oldhrXGGz2CE0ALsd3V0V6fQ+XFV1XvQvd+KMs=;
        b=WkjX+6VBX5SNz1lYR27kfvaZwL5tyeJMjwuWHCxXs/VVzQmg+2hmBla07bAlzboOD+
         Q7iWGBAv6XYVfhe2Y/pzT+/0SennWzJAYtMKUJEbqS5NaNkpSMOoOAQRefKxvVJuHVl4
         v1h+S/cgjjxL2tKfcEP1ildeQqz0SYT2GJSSl1lCpBJiSnQZSoG381zaUgzbBOQgusQC
         wQU2pfW1xYTrwvuj6KvF2lTtDcogqx9YntPA5ivhqCU7aHt7g/5XgUZCBJPElamnVRGs
         +hn4i2Zq0moEyT536cCURtCSO0kkZQ2P//pS1MPKBIKQBww7UCWHOqlu/XAHrKKlHvpm
         ISzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nu3y1oldhrXGGz2CE0ALsd3V0V6fQ+XFV1XvQvd+KMs=;
        b=TPJbWptNKMdTu4/ceQoSsXLFmT28Zw7wyqE41KSTeHTGXn7q8zgcohtUym9TZciGxA
         ywnA7un/aFuNAJKYuUPlu9Nqt6aaHS+B11gTrL0ewmE7G4X1WFwlK/KOVUlqu4l7m0sj
         nkRptkW6yCA8MRz0oFsgPfac+QNqPoslTDzacCt87sOsuGx/m2osWehWxLoXBbIdin45
         e6nwyxmcfiuqRbmBod2FN195tq0pLVLz3pDBmu4DMZwmAUHY8w9A3Y3fMjV9o9wbjsXf
         yL+09/ZKIhIgbZWd1Wg9T3E/099MRudymMTr9HsC90m/REs1+DDNFBBCviF9UrYtwThR
         +SYA==
X-Gm-Message-State: ANoB5pkI0m7rw0ajFTY8tdsEsC6K6nB2NDi4C1Pt6WqtWz3H6sLHFYkn
        SqlHdhil14zPeYLpOKFIsa13bw==
X-Google-Smtp-Source: AA0mqf7FO7iMH/gayxVExvVO7VRIeDKAdeX2kAYpzMWARz8tjTV2SgcnrNcNqKklVV0Olg/odoMjZw==
X-Received: by 2002:a37:444b:0:b0:6e1:b888:bbf9 with SMTP id r72-20020a37444b000000b006e1b888bbf9mr26362956qka.680.1669249356807;
        Wed, 23 Nov 2022 16:22:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id j3-20020a05620a288300b006fc2cee4486sm1918240qkp.62.2022.11.23.16.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 16:22:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oy00h-00BxJy-5K;
        Wed, 23 Nov 2022 20:22:35 -0400
Date:   Wed, 23 Nov 2022 20:22:35 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Bernard Metzler <bmt@zurich.ibm.com>
Cc:     wangyufen <wangyufen@huawei.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com>,
        Leon Romanovsky <leon@kernel.org>, chenzhongjin@huawei.com,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>
Subject: Re: [syzbot] unregister_netdevice: waiting for DEV to become free (7)
Message-ID: <Y365S5s5qRQvm8m0@ziepe.ca>
References: <00000000000060c7e305edbd296a@google.com>
 <CACT4Y+a=HbyJE3A_SnKm3Be-kcQytxXXF89gZ_cN1gwoAW-Zgw@mail.gmail.com>
 <Y3wwOPmH1WoRj0Uo@ziepe.ca>
 <ecc8b532-4e80-b7bd-3621-78cd55fd48fa@huawei.com>
 <2f54056f-0acf-e088-c6cc-9ffce77bbe24@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f54056f-0acf-e088-c6cc-9ffce77bbe24@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 05:45:53PM +0800, Guoqing Jiang wrote:
> But it is the caller's responsibility to destroy it since commit
> dd37d2f59eb8.
> 
> > The causes are as follows:
> > 
> > rdma_listen()
> >   rdma_bind_addr()
> >     cma_acquire_dev_by_src_ip()
> >       cma_attach_to_dev()
> >         _cma_attach_to_dev()
> >           cma_dev_get()
> 
> Thanks for the analysis.
> 
> And for the two callers of cma_listen_on_dev, looks they have
> different behaviors with regard to handling failure.

Yes, the CM is not the problem, and that print from it is unrelated

I patched in netdevice_tracker and get this:

[  237.475070][ T7541] unregister_netdevice: waiting for vlan0 to become free. Usage count = 2
[  237.477311][ T7541] leaked reference.
[  237.478378][ T7541]  ib_device_set_netdev+0x266/0x730
[  237.479848][ T7541]  siw_newlink+0x4e0/0xfd0
[  237.481100][ T7541]  nldev_newlink+0x35c/0x5c0
[  237.482121][ T7541]  rdma_nl_rcv_msg+0x36d/0x690
[  237.483312][ T7541]  rdma_nl_rcv+0x2ee/0x430
[  237.484483][ T7541]  netlink_unicast+0x543/0x7f0
[  237.485746][ T7541]  netlink_sendmsg+0x918/0xe20
[  237.486866][ T7541]  sock_sendmsg+0xcf/0x120
[  237.488006][ T7541]  ____sys_sendmsg+0x70d/0x8b0
[  237.489294][ T7541]  ___sys_sendmsg+0x11d/0x1b0
[  237.490404][ T7541]  __sys_sendmsg+0xfa/0x1d0
[  237.491451][ T7541]  do_syscall_64+0x35/0xb0
[  237.492566][ T7541]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Which seems to confirm my original prediction, except this is siw not
rxe..

Maybe rxe was the wrong guess, or maybe it is troubled too in other
reports?

Jason
