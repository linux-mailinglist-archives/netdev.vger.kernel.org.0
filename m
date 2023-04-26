Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85616EFE11
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 01:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242758AbjDZXmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 19:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbjDZXmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 19:42:07 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1FE2715;
        Wed, 26 Apr 2023 16:42:06 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-18ef8e9aa00so980348fac.1;
        Wed, 26 Apr 2023 16:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682552525; x=1685144525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MRVDi1kbibKLZUZ4oONNkFD/814ytulXtGQ2n8Dlnpw=;
        b=ZDMOXbzPRMvDWZ+K2ZrLEQ2u6bgFR0pNtpgktbA5WsvE1ZBBzHMrsH7p9Zxpt/l0p7
         2Lg+oPJKkpLEaTUlRKOul3Dhm6WHmSF+fGaqclD7vybRGJ40F8J87UqyD3gAJZn6DTkR
         N4AsYLZEyn+JUglYpp37uRzum7hyxCB9ZZmaYT5juaOEOximRgPIrxisxY+xOyxtTqNi
         M3GBaS6Zq4cd83YpssIeN89zQZJAiFnzX43qqeVRZ8kPX2DKyZjYi6iUMOhttrGpoayF
         JnmJpDH6jZs8jThgmaBwRdaYE2zpJHEjz/W/7a2lAWCo3tKvcdUG9iuRqUp1mRBsxLxF
         3YHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682552525; x=1685144525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRVDi1kbibKLZUZ4oONNkFD/814ytulXtGQ2n8Dlnpw=;
        b=H2F0E0EBJ4BVDlNZlewbRFuXUMc2Zxk3VKATCW8U5i+smfEUH81+IuCzxjG7ChhEM5
         F0hIEHF40qnrby5WAWn0sC79g9GML3pmE29N92PYPCiZy7vRKc5IcROfz/PhZgY/Ko7C
         iinQevWyTFjdvNsC2ryPp+WH8df7UqT1xSKAgMwqupeqatDZHMjjRbVrYeB74blFmuVA
         Vl/vmkOtX7tdEDL7rkVs56Bo3cfQNxYsAvic4qUYXy6RQfZazrO1Ivfh1XcIhFV3zTFB
         snaWK/HEcUnrWQKGxD7HITPt2GzupLnfX2zBvglApfj8GMFFhhlSU4lwEKG8xjDuzgBj
         3nVg==
X-Gm-Message-State: AAQBX9evYc/We8pdJtcbcWefIoamFxVVDtRhnw67FxJ3sCU8aGhVaUJ2
        cTUoVCSuNJsGJdNXIjUpqw==
X-Google-Smtp-Source: AKy350Z2NxcqJlpFeQbEJ2g/uhlcLcXVwR4PzkuAFd9Q9hzQ7fgpWk+SDJZfQEYfKGOHlDUonH48zw==
X-Received: by 2002:a05:6870:80cc:b0:188:1096:246f with SMTP id r12-20020a05687080cc00b001881096246fmr15024879oab.29.1682552525241;
        Wed, 26 Apr 2023 16:42:05 -0700 (PDT)
Received: from bytedance ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id y10-20020a544d8a000000b0037b6f5d6309sm5085364oix.2.2023.04.26.16.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 16:42:04 -0700 (PDT)
Date:   Wed, 26 Apr 2023 16:42:01 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, peilin.ye@bytedance.com,
        yepeilin.cs@gmail.com, vladbu@nvidia.com, hdanton@sina.com
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Message-ID: <20230426233657.GA11249@bytedance>
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org>
 <ZCOylfbhuk0LeVff@do-x1extreme>
 <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
 <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
 <20230417230011.GA41709@bytedance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417230011.GA41709@bytedance>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc: Vlad Buslov, Hillf Danton

Hi all,

On Mon, Apr 17, 2023 at 04:00:11PM -0700, Peilin Ye wrote:
> I also reproduced this UAF using the syzkaller reproducer in the report
> (the C reproducer did not work for me for unknown reasons).  I will look
> into this.

Currently, multiple ingress (clsact) Qdiscs can access the per-netdev
*miniq_ingress (*miniq_egress) pointer concurrently.  This is
unfortunately true in two senses:

1. We allow adding ingress (clsact) Qdiscs under parents other than
TC_H_INGRESS (TC_H_CLSACT):

  $ ip link add ifb0 numtxqueues 8 type ifb
  $ echo clsact > /proc/sys/net/core/default_qdisc
  $ tc qdisc add dev ifb0 handle 1: root mq
  $ tc qdisc show dev ifb0
  qdisc mq 1: root
  qdisc clsact 0: parent 1:8
  qdisc clsact 0: parent 1:7
  qdisc clsact 0: parent 1:6
  qdisc clsact 0: parent 1:5
  qdisc clsact 0: parent 1:4
  qdisc clsact 0: parent 1:3
  qdisc clsact 0: parent 1:2
  qdisc clsact 0: parent 1:1

This is obviously racy and should be prohibited.  I've started working
on patches to fix this.  The syz repro for this UAF adds ingress Qdiscs
under TC_H_ROOT, by the way.

2. After introducing RTNL-lockless RTM_{NEW,DEL,GET}TFILTER requests
[1], it is possible that, when replacing ingress (clsact) Qdiscs, the
old one can access *miniq_{in,e}gress concurrently with the new one.  For
example, the syz repro does something like the following:

  Thread 1 creates sch_ingress Qdisc A (containing mini Qdisc a1 and a2),
  then adds a cls_flower filter X to Qdisc A.

  Thread 2 creates sch_ingress Qdisc B (containing mini Qdisc b1 and b2)
  to replace Qdisc A, then adds a cls_flower filter Y to Qdisc B.

  Device has 8 TXQs.

 Thread 1               A's refcnt   Thread 2
  RTM_NEWQDISC (A, locked)    
   qdisc_create(A)               1
   qdisc_graft(A)                9

  RTM_NEWTFILTER (X, lockless)
   __tcf_qdisc_find(A)          10
   tcf_chain0_head_change(A)
 ! mini_qdisc_pair_swap(A)           
            |                        RTM_NEWQDISC (B, locked)
            |                    2    qdisc_graft(B)
            |                    1    notify_and_destroy(A)
            |                                  
            |                        RTM_NEWTFILTER (Y, lockless)
            |                         tcf_chain0_head_change(B)
            |                       ! mini_qdisc_pair_swap(B)
   tcf_block_release(A)          0             |
   qdisc_destroy(A)                            |
   tcf_chain0_head_change_cb_del(A)            |
 ! mini_qdisc_pair_swap(A)                     |
            |                                  |
           ...                                ...

As we can see there're interleaving mini_qdisc_pair_swap() calls between
Qdisc A and B, causing all kinds of troubles, including the UAF (thread
2 writing to mini Qdisc a1's rcu_state after Qdisc A has already been
freed) reported by syzbot.

To fix this, I'm cooking a patch that, when replacing ingress (clsact)
Qdiscs, in qdisc_graft():

  I.  We should make sure there's no on-the-fly lockless filter requests
      for the old Qdisc, and return -EBUSY if there's any (or can/should
      we wait in RTM_NEWQDISC handler?)

  II. We should destory the old Qdisc before publishing the new one
      (i.e. setting it to dev_ingress_queue(dev)->qdisc_sleeping, so
      that subsequent filter requests can see it), because
      {ingress,clsact}_destroy() also call mini_qdisc_pair_swap(), which
      sets *miniq_{in,e}gress to NULL

Future Qdiscs that support RTNL-lockless cls_ops, if any, won't need
this fix, as long as their ->chain_head_change() don't access
out-of-Qdisc-scope data, like pointers in struct net_device.

Do you think this is the right way to go?  Thanks!

[1] Thanks Hillf Danton for the hint:
    https://syzkaller.appspot.com/text?tag=Patch&x=10d7cd5bc80000

Thanks,
Peilin Ye

