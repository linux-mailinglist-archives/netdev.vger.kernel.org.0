Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18D9A418E
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 03:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfHaBtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 21:49:23 -0400
Received: from nwk-aaemail-lapp01.apple.com ([17.151.62.66]:56104 "EHLO
        nwk-aaemail-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726640AbfHaBtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 21:49:23 -0400
X-Greylist: delayed 8530 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2019 21:49:22 EDT
Received: from pps.filterd (nwk-aaemail-lapp01.apple.com [127.0.0.1])
        by nwk-aaemail-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id x7UNQNb2001359;
        Fri, 30 Aug 2019 16:26:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : date : from :
 to : cc : subject : message-id : references : mime-version : content-type
 : in-reply-to; s=20180706;
 bh=LixwibEP/yqPnNU2umc4HGiiRe/orh0Gh+sk4qO70uU=;
 b=RvHOVMlGXjdSeG6IWzYiSpXowMkfMMDBqrg4FiISCm7LucMkQZfH/yR3PCdFHyg5ebkn
 Qf79AlOSmx9xC9dPUGlAz2f40n4L5etTClZ3aQK916VMU4r8RxFAutPr3cS/BqSbMreD
 2wFXmCYvBslK5isDb2JCqdi6Z3X6ThKruRjgQ1MZvzu7Fvs/M5YzL6DsArd4mzlM3Bf6
 B6sNAkfH/Rke9Uecgm48q8vPA8jTn5TBlW0KIHzX1ou9XN7dmG84lpl7ExPpdYAjmzm2
 SZWKEadW3JTp3rzk/pwxxZQ725f1ltOgDgnZV1e4w/FaKfytauIiQXC2NO0OAFljKdW9 +A== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp01.apple.com with ESMTP id 2uk468x8gd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 30 Aug 2019 16:26:59 -0700
Received: from nwk-mmpp-sz11.apple.com
 (nwk-mmpp-sz11.apple.com [17.128.115.155]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PX200EDBP4XEFA0@ma1-mtap-s03.corp.apple.com>; Fri,
 30 Aug 2019 16:26:58 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz11.apple.com by
 nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PX200500NY36700@nwk-mmpp-sz11.apple.com>; Fri,
 30 Aug 2019 16:26:57 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 498c98f31a1a945d3e62d378b426440f
X-Va-E-CD: 1007b2352e9c51e74c70d135e26719cd
X-Va-R-CD: 1b0c5b5b5444ecadc68bb8a16b096ca5
X-Va-CD: 0
X-Va-ID: 69c4cfbc-426d-4fc9-b05d-7ebb7443069e
X-V-A:  
X-V-T-CD: 498c98f31a1a945d3e62d378b426440f
X-V-E-CD: 1007b2352e9c51e74c70d135e26719cd
X-V-R-CD: 1b0c5b5b5444ecadc68bb8a16b096ca5
X-V-CD: 0
X-V-ID: c82d65eb-5c18-4c79-93f4-7cd62b0c5cbe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-08-30_09:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PX200GU7P4X1O80@nwk-mmpp-sz11.apple.com>; Fri,
 30 Aug 2019 16:26:57 -0700 (PDT)
Date:   Fri, 30 Aug 2019 16:26:57 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc:     Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        matthieu.baerts@tessares.net, aprout@ll.mit.edu,
        davem@davemloft.net, edumazet@google.com, jtl@netflix.com,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        ncardwell@google.com, sashal@kernel.org, ycheng@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Message-id: <20190830232657.GL45416@MacBook-Pro-64.local>
References: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
 <20190824060351.3776-1-tim.froidcoeur@tessares.net>
 <400C4757-E7AD-4CCF-8077-79563EA869B1@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <400C4757-E7AD-4CCF-8077-79563EA869B1@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_09:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 24/08/19 - 15:05:20, Jonathan Lemon wrote:
> 
> 
> On 23 Aug 2019, at 23:03, Tim Froidcoeur wrote:
> 
> > Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
> > triggers following stack trace:
> >
> > [25244.848046] kernel BUG at ./include/linux/skbuff.h:1406!
> > [25244.859335] RIP: 0010:skb_queue_prev+0x9/0xc
> > [25244.888167] Call Trace:
> > [25244.889182]  <IRQ>
> > [25244.890001]  tcp_fragment+0x9c/0x2cf
> > [25244.891295]  tcp_write_xmit+0x68f/0x988
> > [25244.892732]  __tcp_push_pending_frames+0x3b/0xa0
> > [25244.894347]  tcp_data_snd_check+0x2a/0xc8
> > [25244.895775]  tcp_rcv_established+0x2a8/0x30d
> > [25244.897282]  tcp_v4_do_rcv+0xb2/0x158
> > [25244.898666]  tcp_v4_rcv+0x692/0x956
> > [25244.899959]  ip_local_deliver_finish+0xeb/0x169
> > [25244.901547]  __netif_receive_skb_core+0x51c/0x582
> > [25244.903193]  ? inet_gro_receive+0x239/0x247
> > [25244.904756]  netif_receive_skb_internal+0xab/0xc6
> > [25244.906395]  napi_gro_receive+0x8a/0xc0
> > [25244.907760]  receive_buf+0x9a1/0x9cd
> > [25244.909160]  ? load_balance+0x17a/0x7b7
> > [25244.910536]  ? vring_unmap_one+0x18/0x61
> > [25244.911932]  ? detach_buf+0x60/0xfa
> > [25244.913234]  virtnet_poll+0x128/0x1e1
> > [25244.914607]  net_rx_action+0x12a/0x2b1
> > [25244.915953]  __do_softirq+0x11c/0x26b
> > [25244.917269]  ? handle_irq_event+0x44/0x56
> > [25244.918695]  irq_exit+0x61/0xa0
> > [25244.919947]  do_IRQ+0x9d/0xbb
> > [25244.921065]  common_interrupt+0x85/0x85
> > [25244.922479]  </IRQ>
> >
> > tcp_rtx_queue_tail() (called by tcp_fragment()) can call
> > tcp_write_queue_prev() on the first packet in the queue, which will trigger
> > the BUG in tcp_write_queue_prev(), because there is no previous packet.
> >
> > This happens when the retransmit queue is empty, for example in case of a
> > zero window.
> >
> > Patch is needed for 4.4, 4.9 and 4.14 stable branches.
> >
> > Fixes: 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
> > Change-Id: I839bde7167ae59e2f7d916c913507372445765c5
> > Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
> > Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Reviewed-by: Christoph Paasch <cpaasch@apple.com>
> 
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

just checking in, if the patch is getting picked up for -stable ?

(I don't see it in the stable-queue)


Thanks,
Christoph


