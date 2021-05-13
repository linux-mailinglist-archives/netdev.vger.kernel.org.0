Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6451037FE65
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 21:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhEMTtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 15:49:50 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:34702 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhEMTtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 15:49:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620935320; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=lQO0RCHWml9zY1kqusQI3qED402cVNIgEBT+/jCzMRc=; b=PCDxQ2UfrHmgmP+n2HlLcuCFpI+RzCJ0MNgpsfVwYLxdqmaQ19OM8QTcLexQJ5evcXLGlSeg
 1h2qS+QPTBCbgJmUPTPFeF9+QVML/JUfNRGfk/3AH8JhtzPwdW/ilp9Ue+5cCg5WmE7APf/s
 l/CiwvNlQLSh/1kFR8ce8dCY6aE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 609d82897bf557a012b72f4f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 13 May 2021 19:48:25
 GMT
Sender: kapandey=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BC353C43217; Thu, 13 May 2021 19:48:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from kapandey-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kapandey)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8DB5CC433D3;
        Thu, 13 May 2021 19:48:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8DB5CC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kapandey@codeaurora.org
Date:   Fri, 14 May 2021 01:18:11 +0530
From:   Kaustubh Pandey <kapandey@codeaurora.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     willemb@google.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        sharathv@codeaurora.org, subashab@codeaurora.org
Subject: Re: Panic in udp4_lib_lookup2
Message-ID: <20210513194810.GA25255@kapandey-linux.qualcomm.com>
References: <eda8bfc80307abce79df504648c60eae@codeaurora.org>
 <a0728eea0f9f2718a6c4bc0f12ba129f1ed411b7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0728eea0f9f2718a6c4bc0f12ba129f1ed411b7.camel@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 10:05:37AM +0200, Paolo Abeni wrote:
> Hello,
>
> On Wed, 2021-05-12 at 23:51 +0530, kapandey@codeaurora.org wrote:
> > We observed panic in udp_lib_lookup with below call trace:
> > [136523.743271]  (7) Call trace:
> > [136523.743275]  (7)  udp4_lib_lookup2+0x88/0x1d8
> > [136523.743277]  (7)  __udp4_lib_lookup+0x168/0x194
> > [136523.743280]  (7)  udp4_lib_lookup+0x28/0x54
> > [136523.743285]  (7)  nf_sk_lookup_slow_v4+0x2b4/0x384
> > [136523.743289]  (7)  owner_mt+0xb8/0x248
> > [136523.743292]  (7)  ipt_do_table+0x28c/0x6a8
> > [136523.743295]  (7) iptable_filter_hook+0x24/0x30
> > [136523.743299]  (7)  nf_hook_slow+0xa8/0x148
> > [136523.743303]  (7)  ip_local_deliver+0xa8/0x14c
> > [136523.743305]  (7)  ip_rcv+0xe0/0x134
>
> It would be helpful if you could provide a full, decoded, stack trace
> and the relevant kernel version.
>
> > We suspect this might happen due to below sequence:
>
> Some email formatting made the "graph" very hard to read...
>
> > Time                                                   CPU X
> >
> >                                     CPU Y
> > t0                                inet_release -> udp_lib_close ->
> > sk_common_release -> udp_lib_unhash
> > inet_diag_handler_cmd -> udp_diag_destroy -> __udp_diag_destroy ->
> > udp_lib_rehash
>
> ... but it looks like udp_lib_close() is missing a
> lock_sock()/release_sock() pair. Something alike:
> ---
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 360df454356c..06586b42db3f 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -209,7 +209,9 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
>
>  static inline void udp_lib_close(struct sock *sk, long timeout)
>  {
> +	lock_sock(sk);
>  	sk_common_release(sk);
> +	release_sock(sk);
>  }
>
>  int udp_lib_get_port(struct sock *sk, unsigned short snum,
> ---
>
> could u please give the above a spin in your testbed?
>
> Thanks!
>
> Paolo
>
>
Hi Paolo,

Pls find full backtrace:
[136523.743141]Unable to handle kernel paging request at virtual address
00000c08ff000820

[136523.743147]Mem abort info:
[136523.743150]  ESR = 0x96000004
[136523.743154]  EC = 0x25: DABT (current EL), IL = 32 bits
[136523.743157]  SET = 0, FnV = 0
[136523.743159]  EA = 0, S1PTW = 0
[136523.743162]Data abort info:
[136523.743164]  ISV = 0, ISS = 0x00000004
[136523.743167]  CM = 0, WnR = 0
[136523.743170][00000c08ff000820] address between user and kernel
address ranges
[136523.743174]Internal error: Oops: 96000004 [#1] PREEMPT SMP
[136523.743218]pstate: a0c00005 (NzCv daif +PAN +UAO)

[136523.743226]pc : udp4_lib_lookup2+0x88/0x1d8
[136523.743229]lr : __udp4_lib_lookup+0x168/0x194

[136523.743232]sp : ffffffc039a9b600
[136523.743234]x29: ffffffc039a9b610 x28: 0000000000000000
[136523.743237]x27: 0000000000000000 x26: ff000c08ff0007f0
[136523.743239]x25: ffffffe1e2319b40 x24: 0000000073737272
[136523.743242]x23: 0000000000003500 x22: 0000000000000000
[136523.743244]x21: 000000000000a622 x20: 000000000000001a
[136523.743246]x19: 00000000ffffffff x18: ffffffc02b6d7098
[136523.743249]x17: 0000000000000000 x16: 0000000000000000
[136523.743251]x15: 0000000000000000 x14: 0000000000000000
[136523.743254]x13: 0000000000000000 x12: ffffff81d8e30000
[136523.743257]x11: 0000000000000fff x10: ff000c08ff0007f0
[136523.743259]x9 : ff000c08ff000808 x8 : 0000000000000000
[136523.743261]x7 : ffffff81d8e3e6a0 x6 : 0000000000000000
[136523.743263]x5 : 000000000000001a x4 : 000000000000a622
[136523.743266]x3 : 0000000000000000 x2 : 0000000000003500
[136523.743268]x1 : 0000000073737272 x0 : ffffffe1e2319b40
[136523.743271]Call trace:
[136523.743275] udp4_lib_lookup2+0x88/0x1d8
[136523.743277] __udp4_lib_lookup+0x168/0x194
[136523.743280] udp4_lib_lookup+0x28/0x54
[136523.743285] nf_sk_lookup_slow_v4+0x2b4/0x384
[136523.743289] owner_mt+0xb8/0x248
[136523.743292] ipt_do_table+0x28c/0x6a8
[136523.743295] iptable_filter_hook+0x24/0x30
[136523.743299] nf_hook_slow+0xa8/0x148
[136523.743303] ip_local_deliver+0xa8/0x14c
[136523.743305] ip_rcv+0xe0/0x134
[136523.743309] __netif_receive_skb_core+0x9d0/0xd74
[136523.743313] __netif_receive_skb+0x50/0x17c
[136523.743316] netif_receive_skb_internal+0xa0/0xd8
[136523.743318] netif_receive_skb+0xec/0x1e4

Kernel version used is 5.4

Derived from your suggestion I think below change might be more suited
here:
diff --git a/net/core/sock.c b/net/core/sock.c
index f87c9f7..a5dd0e5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3210,7 +3210,9 @@ void sk_common_release(struct sock *sk)
         * A. Remove from hash tables.
         */
+       lock_sock(sk);
       sk->sk_prot->unhash(sk);
+       release_sock(sk);

--

Previously I was trying to share this anlaysis:

Time |		CPU[X]		               |		CPU[Y]
____________________________________________________________________________
     |				               |
 t0  | inet_release                            | inet_diag_handler_cmd
     |	udp_lib_close                          |  udp_diag_destroy
     |	 sk_common_release                     |   __udp_diag_destroy
     |     udp_lib_unhash                      |    udp_lib_rehash
____________________________________________________________________________

 t1  | if(sk hashed)                           |  if(sk hashed)
     |   sk_del_node_init_rcu                  |
     |   hlist_del_init_rcu(udp_portaddr_node) |
____________________________________________________________________________

 t2  |                                         |    if(hslot2 != nhslot2)
     |                                         |       hlist_del_init_rcu(udp_portaddr_node)
     |                                         |       hlist_add_head_rcu(udp_portaddr_node)
____________________________________________________________________________

 t3  | sk is freed here                        |

 Pls let me know your views on this.

 Thanks
 KP
