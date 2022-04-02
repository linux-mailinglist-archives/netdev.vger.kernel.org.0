Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7A64F068A
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 00:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiDBWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 18:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349735AbiDBWEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 18:04:24 -0400
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5DA1104;
        Sat,  2 Apr 2022 15:02:31 -0700 (PDT)
Received: from [2c0f:f720:fe16:c400::1] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nalpA-0001KM-Cw; Sun, 03 Apr 2022 00:02:24 +0200
Received: from [192.168.42.201]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nalp7-0000Ow-Nr; Sun, 03 Apr 2022 00:02:22 +0200
Message-ID: <59762d2f-d4e3-c748-5d41-ef3be85537ed@uls.co.za>
Date:   Sun, 3 Apr 2022 00:02:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>
References: <E1nZMdl-0006nG-0J@plastiekpoot>
 <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
 <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
 <CANn89iKSFXBx9zYuBFH4-uS3UzAUW+fY7d5aiUkfOa1DdbHDxQ@mail.gmail.com>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <CANn89iKSFXBx9zYuBFH4-uS3UzAUW+fY7d5aiUkfOa1DdbHDxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/04/02 15:20, Eric Dumazet wrote:

> Great. This confirms our suspicions.
>
> Please try the following patch that landed in 5.18-rc
>
> f2dd495a8d589371289981d5ed33e6873df94ecc netfilter: nf_conntrack_tcp:
> preserve liberal flag in tcp options

Will track this down and deploy in the next day or two.  Thank you, Neal
and Florian for all the assistance!

As an aside, would really like to engage with someone that can assist on
the known congestion w.r.t. Google services in JHB, so if you're willing
- or can get me in contact with the right people, please do contact me
direct off-list (we've alleviated the issue by upgrading out IPT but
would like to understand what is going on, can provide ticket references).


Kind Regards,
Jaco

>
> CC netfilter folks.
>
> Condition triggering the bug :
>    before(seq, sender->td_maxend + 1),
>
> I took a look at the code, and it is not clear if td_maxend is
> properly setup (or if td_scale is cleared at some point while it
> should not)
>
> Alternatively, if conntracking does not know if the connection is
> using wscale (or what is the scale), the "before(seq,
> sender->td_maxend + 1),"
> should not be evaluated/used.
>
> Also, I do not see where td_maxend is extended in tcp_init_sender()
>
> Probably wrong patch, just to point to the code I do not understand yet.
>
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> b/net/netfilter/nf_conntrack_proto_tcp.c
> index 8ec55cd72572e0cca076631e2cc1c11f0c2b86f6..950082785d61b7a2768559c7500d3aee3aaea7c2
> 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -456,9 +456,10 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
>         /* SYN-ACK in reply to a SYN
>          * or SYN from reply direction in simultaneous open.
>          */
> -       sender->td_end =
> -       sender->td_maxend = end;
> -       sender->td_maxwin = (win == 0 ? 1 : win);
> +       sender->td_end = end;
> +       sender->td_maxwin = max(win, 1U);
> +       /* WIN in SYN & SYNACK is not scaled */
> +       sender->td_maxend = end + sender->td_maxwin;
>
>         tcp_options(skb, dataoff, tcph, sender);
>         /* RFC 1323:
