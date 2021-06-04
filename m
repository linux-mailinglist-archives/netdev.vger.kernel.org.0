Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA1B39BAE1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhFDO3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 10:29:09 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14349 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhFDO3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 10:29:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622816840; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=z/FEYHbdXTAdYPNP3O2PSNpOBK3TuxAw4rQL7dUJ0M0=; b=RGR5DsDuUR6emjM7TSfKc9aN62q4OX3CCbwv5YqPmv9W5c2qYpmKWzVT78V3iWDQgz8pXKCY
 ZfeOVmBfOiQoZ6go5KvOpga9cQp9KR2dVt0aPMxsSwwm9t/VcTKbq/UaLKVzD9SMAJX1G2A2
 FUiMwAX3EfddBGtBaLK4GV/b6Eo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60ba38278491191eb3daf013 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Jun 2021 14:26:47
 GMT
Sender: kapandey=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 16D18C43460; Fri,  4 Jun 2021 14:26:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from kapandey-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kapandey)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C457BC433F1;
        Fri,  4 Jun 2021 14:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C457BC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kapandey@codeaurora.org
Date:   Fri, 4 Jun 2021 19:56:34 +0530
From:   Kaustubh Pandey <kapandey@codeaurora.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     willemb@google.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        sharathv@codeaurora.org, subashab@codeaurora.org
Subject: Re: Panic in udp4_lib_lookup2
Message-ID: <20210604142633.GA9022@kapandey-linux.qualcomm.com>
References: <eda8bfc80307abce79df504648c60eae@codeaurora.org>
 <a0728eea0f9f2718a6c4bc0f12ba129f1ed411b7.camel@redhat.com>
 <20210513194810.GA25255@kapandey-linux.qualcomm.com>
 <4ba41620dbba70de6e3fed1356fc1910192cd074.camel@redhat.com>
 <20210518142023.GA16017@kapandey-linux.qualcomm.com>
 <da0d68ea162be29d489ad9dec575f8a8558e8e57.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da0d68ea162be29d489ad9dec575f8a8558e8e57.camel@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 08:18:56PM +0200, Paolo Abeni wrote:
> On Tue, 2021-05-18 at 19:50 +0530, Kaustubh Pandey wrote:
> > On Thu, May 13, 2021 at 11:18:53PM +0200, Paolo Abeni wrote:
> > > On Fri, 2021-05-14 at 01:18 +0530, Kaustubh Pandey wrote:
> > > > On Thu, May 13, 2021 at 10:05:37AM +0200, Paolo Abeni wrote:
> > > > > Hello,
> > > > > 
> > > > > On Wed, 2021-05-12 at 23:51 +0530, kapandey@codeaurora.org wrote:
> > > > > > We observed panic in udp_lib_lookup with below call trace:
> > > > > > [136523.743271]  (7) Call trace:
> > > > > > [136523.743275]  (7)  udp4_lib_lookup2+0x88/0x1d8
> > > > > > [136523.743277]  (7)  __udp4_lib_lookup+0x168/0x194
> > > > > > [136523.743280]  (7)  udp4_lib_lookup+0x28/0x54
> > > > > > [136523.743285]  (7)  nf_sk_lookup_slow_v4+0x2b4/0x384
> > > > > > [136523.743289]  (7)  owner_mt+0xb8/0x248
> > > > > > [136523.743292]  (7)  ipt_do_table+0x28c/0x6a8
> > > > > > [136523.743295]  (7) iptable_filter_hook+0x24/0x30
> > > > > > [136523.743299]  (7)  nf_hook_slow+0xa8/0x148
> > > > > > [136523.743303]  (7)  ip_local_deliver+0xa8/0x14c
> > > > > > [136523.743305]  (7)  ip_rcv+0xe0/0x134
> > > > > 
> > > > > It would be helpful if you could provide a full, decoded, stack trace
> > > > > and the relevant kernel version.
> > > > > 
> > > > > > We suspect this might happen due to below sequence:
> > > > > 
> > > > > Some email formatting made the "graph" very hard to read...
> > > > > 
> > > > > > Time                                                   CPU X
> > > > > > 
> > > > > >                                     CPU Y
> > > > > > t0                                inet_release -> udp_lib_close ->
> > > > > > sk_common_release -> udp_lib_unhash
> > > > > > inet_diag_handler_cmd -> udp_diag_destroy -> __udp_diag_destroy ->
> > > > > > udp_lib_rehash
> > > > > 
> > > > > ... but it looks like udp_lib_close() is missing a
> > > > > lock_sock()/release_sock() pair. Something alike:
> > > > > ---
> > > > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > > > index 360df454356c..06586b42db3f 100644
> > > > > --- a/include/net/udp.h
> > > > > +++ b/include/net/udp.h
> > > > > @@ -209,7 +209,9 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
> > > > > 
> > > > >  static inline void udp_lib_close(struct sock *sk, long timeout)
> > > > >  {
> > > > > +	lock_sock(sk);
> > > > >  	sk_common_release(sk);
> > > > > +	release_sock(sk);
> > > > >  }
> > > > > 
> > > > >  int udp_lib_get_port(struct sock *sk, unsigned short snum,
> > > > > ---
> > > > > 
> > > > > could u please give the above a spin in your testbed?
> > > > > 
> > > > > Thanks!
> > > > > 
> > > > > Paolo
> > > > > 
> > > > > 
> > > > Hi Paolo,
> > > > 
> > > > Pls find full backtrace:
> > > > [136523.743141]Unable to handle kernel paging request at virtual address
> > > > 00000c08ff000820
> > > > 
> > > > [136523.743147]Mem abort info:
> > > > [136523.743150]  ESR = 0x96000004
> > > > [136523.743154]  EC = 0x25: DABT (current EL), IL = 32 bits
> > > > [136523.743157]  SET = 0, FnV = 0
> > > > [136523.743159]  EA = 0, S1PTW = 0
> > > > [136523.743162]Data abort info:
> > > > [136523.743164]  ISV = 0, ISS = 0x00000004
> > > > [136523.743167]  CM = 0, WnR = 0
> > > > [136523.743170][00000c08ff000820] address between user and kernel
> > > > address ranges
> > > > [136523.743174]Internal error: Oops: 96000004 [#1] PREEMPT SMP
> > > > [136523.743218]pstate: a0c00005 (NzCv daif +PAN +UAO)
> > > > 
> > > > [136523.743226]pc : udp4_lib_lookup2+0x88/0x1d8
> > > > [136523.743229]lr : __udp4_lib_lookup+0x168/0x194
> > > > 
> > > > [136523.743232]sp : ffffffc039a9b600
> > > > [136523.743234]x29: ffffffc039a9b610 x28: 0000000000000000
> > > > [136523.743237]x27: 0000000000000000 x26: ff000c08ff0007f0
> > > > [136523.743239]x25: ffffffe1e2319b40 x24: 0000000073737272
> > > > [136523.743242]x23: 0000000000003500 x22: 0000000000000000
> > > > [136523.743244]x21: 000000000000a622 x20: 000000000000001a
> > > > [136523.743246]x19: 00000000ffffffff x18: ffffffc02b6d7098
> > > > [136523.743249]x17: 0000000000000000 x16: 0000000000000000
> > > > [136523.743251]x15: 0000000000000000 x14: 0000000000000000
> > > > [136523.743254]x13: 0000000000000000 x12: ffffff81d8e30000
> > > > [136523.743257]x11: 0000000000000fff x10: ff000c08ff0007f0
> > > > [136523.743259]x9 : ff000c08ff000808 x8 : 0000000000000000
> > > > [136523.743261]x7 : ffffff81d8e3e6a0 x6 : 0000000000000000
> > > > [136523.743263]x5 : 000000000000001a x4 : 000000000000a622
> > > > [136523.743266]x3 : 0000000000000000 x2 : 0000000000003500
> > > > [136523.743268]x1 : 0000000073737272 x0 : ffffffe1e2319b40
> > > > [136523.743271]Call trace:
> > > > [136523.743275] udp4_lib_lookup2+0x88/0x1d8
> > > > [136523.743277] __udp4_lib_lookup+0x168/0x194
> > > > [136523.743280] udp4_lib_lookup+0x28/0x54
> > > > [136523.743285] nf_sk_lookup_slow_v4+0x2b4/0x384
> > > > [136523.743289] owner_mt+0xb8/0x248
> > > > [136523.743292] ipt_do_table+0x28c/0x6a8
> > > > [136523.743295] iptable_filter_hook+0x24/0x30
> > > > [136523.743299] nf_hook_slow+0xa8/0x148
> > > > [136523.743303] ip_local_deliver+0xa8/0x14c
> > > > [136523.743305] ip_rcv+0xe0/0x134
> > > > [136523.743309] __netif_receive_skb_core+0x9d0/0xd74
> > > > [136523.743313] __netif_receive_skb+0x50/0x17c
> > > > [136523.743316] netif_receive_skb_internal+0xa0/0xd8
> > > > [136523.743318] netif_receive_skb+0xec/0x1e4
> > > > 
> > > > Kernel version used is 5.4
> > > > 
> > > > Derived from your suggestion I think below change might be more suited
> > > > here:
> > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > index f87c9f7..a5dd0e5 100644
> > > > --- a/net/core/sock.c
> > > > +++ b/net/core/sock.c
> > > > @@ -3210,7 +3210,9 @@ void sk_common_release(struct sock *sk)
> > > >          * A. Remove from hash tables.
> > > >          */
> > > > +       lock_sock(sk);
> > > >        sk->sk_prot->unhash(sk);
> > > > +       release_sock(sk);
> > > 
> > > The above will cause deadlock on protocol rightfully calling
> > > sk_common_release under the socket lock (e.g. sctp).
> > > 
> > > Could you please test the change I suggested in your testbed?
> > > 
> > > Thanks
> > > 
> > > Paolo
> > > 
> > Hi Paolo,
> > 
> > I picked up your change and with that it get stuck in udp_destroy_sock
> > trying to do lock_sock_fast.
> > 
> > Can you guide for next steps here?
> 
> I'm sorry for the high latency. 
> 
> It's a bit tricky as we can't easily acquire the socket lock on close
> with a wider scope.
> 
> Can you please try this one?
> 
> Thanks!
> 
> Paolo
> ---
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 055fceb18bea..0d6205726abf 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2607,6 +2607,7 @@ void udp_destroy_sock(struct sock *sk)
>  {
>  	struct udp_sock *up = udp_sk(sk);
>  	bool slow = lock_sock_fast(sk);
> +	sock_set_flag(sk, SOCK_DEAD);
>  	udp_flush_pending_frames(sk);
>  	unlock_sock_fast(sk, slow);
>  	if (static_branch_unlikely(&udp_encap_needed_key)) {
> @@ -2857,10 +2858,17 @@ int udp_abort(struct sock *sk, int err)
>  {
>  	lock_sock(sk);
>  
> +	/* udp{v6}_destroy_sock() sets it under the sk lock, avoid racing
> +	 * with close()
> +	 */
> +	if (sock_flag(sk, SOCK_DEAD))
> +		goto out;
> +
>  	sk->sk_err = err;
>  	sk->sk_error_report(sk);
>  	__udp_disconnect(sk, 0);
>  
> +out:
>  	release_sock(sk);
>  
>  	return 0;
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 199b080d418a..2984ec43b9aa 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1598,6 +1598,7 @@ void udpv6_destroy_sock(struct sock *sk)
>  {
>  	struct udp_sock *up = udp_sk(sk);
>  	lock_sock(sk);
> +	sock_set_flag(sk, SOCK_DEAD);
>  	udp_v6_flush_pending_frames(sk);
>  	release_sock(sk);
>  
> 
Hi Paolo,
Apologies for delay.

I picked up this patch and tried reproducing the panic.
I never observed the panic with this patch. Seems to work perfectly
fine.

Can you pls raise a formal patch for this?

Thanks,
KP
