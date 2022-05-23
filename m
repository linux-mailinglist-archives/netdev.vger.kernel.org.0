Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17E53142E
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbiEWOAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236746AbiEWOAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:00:09 -0400
X-Greylist: delayed 349 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 May 2022 07:00:06 PDT
Received: from fx301.security-mail.net (smtpout30.security-mail.net [85.31.212.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED4F57144
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 07:00:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx301.security-mail.net (Postfix) with ESMTP id CE2B624BD0EF
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 15:54:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1653314054;
        bh=34Qcx+eXpznya3ISA10FdYiEoy+o4oxfTzJFeFXnca0=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=kAG2oV1pb+2GdACivQB7xCNZ12wWB7G1vMa7HvsqeTFRw1iSrfVUuUyvf7nkgTxZP
         YEcKlqgOafew6wtVkI2s1FQAMVpHbQtYQRf12zVxELKun7vndoNtuEqHBTDhu4dLoI
         jvBkBDHK5kp044ZlTyTpi7qL5injhQOBQeDR5vyQ=
Received: from fx301 (localhost [127.0.0.1]) by fx301.security-mail.net
 (Postfix) with ESMTP id D6C2E24BD0E5; Mon, 23 May 2022 15:54:13 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx301.security-mail.net (Postfix) with ESMTPS id 2568F24BD135; Mon, 23 May
 2022 15:54:13 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id CF98827E04AF; Mon, 23 May 2022
 15:54:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id B6DD727E04AE; Mon, 23 May 2022 15:54:12 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 ayFr4JZweHRw; Mon, 23 May 2022 15:54:12 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id 9F8CD27E04AA; Mon, 23 May 2022
 15:54:12 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <12ebe.628b9205.24fe3.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu B6DD727E04AE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1653314052;
 bh=RAMYZ7Rdu8+cQ6sitpfptQv3zfgoe6iL//7NJ2Ne2Kw=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=hzv91elaDR8By/ITOQC+uUAtfXkAvqd7MPI1mUIJjolTxGT3OGvWsRp2IyMQrKri8
 3hO+tFDNLmv/+MgmYoMdc1JdRmD1snXs6Rb/VxUlHPBnIwDKQWLGA8ZgMmGowvP/GF
 0EdY4N94wWdTwnVHcbICyoEuIGMSIACYNTD3Dr9cZ3Cjfi0+PdbkxQzwuWlVBCSKe7
 KHKbe0x1UVeO0p9YEx6orqh5fZF0N0g6Iq9R/3zGaI4hWL/+GbT64vctfTf817OpJO
 UVdZpzvK9DPW6n4FixDio4Rm6hvXOGDSSOTcOsNR0nG34T4/fFFr/OLvrM4KvPwv8a
 wCYHnpzIxXPKw==
Date:   Mon, 23 May 2022 15:54:12 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     linyunsheng <linyunsheng@huawei.com>
Cc:     davem <davem@davemloft.net>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>
Message-ID: <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
In-Reply-To: <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
Subject: packet stuck in qdisc : patch proposal
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary=secu_31ddccd55f21c6496cf27dca2e43ce7d_part1
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF100
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc : patch proposal
Thread-Index: BWJfWWTsecw42QWFFBsP1/XAO+Fkzw==
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This message is in MIME format.

--secu_31ddccd55f21c6496cf27dca2e43ce7d_part1
Content-Type: text/plain; charset=utf-8

Hi Yunsheng, all,

I finally spotted the bug that caused (nvme-)tcp packets to remain stuck in the qdisc once in a while.
It's in qdisc_run_begin within sch_generic.h : 

smp_mb__before_atomic();
 
// [comments]

if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
	return false;

should be 

smp_mb();

// [comments]

if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
	return false;

I have written a more detailed explanation in the attached patch, including a race example, but in short that's because test_bit() is not an atomic operation.
Therefore it does not give you any ordering guarantee on any architecture.
And neither does spin_trylock() called at the beginning of qdisc_run_begin() when it does not grab the lock...
So test_bit() may be reordered whith a preceding enqueue(), leading to a possible race in the dialog with pfifo_fast_dequeue().
We may then end up with a skbuff pushed "silently" to the qdisc (MISSED cleared, nobody aware that there is something in the backlog).
Then the cores pushing new skbuffs to the qdisc may all bypass it for an arbitrary amount of time, leaving the enqueued skbuff stuck in the backlog.

I believe the reason for which you could not reproduce the issue on ARM64 is that, on that architecture, smp_mb__before_atomic() will translate to a memory barrier.
It does not on x86 (turned into a NOP) because you're supposed to use this function just before an atomic operation, and atomic operations themselves provide full ordering effects on x86.

I think the code has been flawed for some time but the introduction of a (true) bypass policy in 5.14 made it more visible, because without this, the "victim" skbuff does not stay very long in the backlog : it is bound to pe popped by the next core executing __qdic_run().

In my setup, with our use case (16 (virtual) cpus in a VM shooting 4KB buffers with fio through a -i4 nvme-tcp connection to a target), I did not notice any performance degradation using smp_mb() in place of smp_mb__before_atomic(), but of course that does not mean it cannot happen in other configs.

I think Guoju's patch is also correct and necessary so that both patches, his and mine, should be applied "asap" to the kernel.
A difference between Guoju's race and "mine" is that, in his case, the MISSED bit will be set : though no one will take care of the skbuff immediately, the next cpu pushing to the qdisc (if ever ...) will notice and dequeue it (so Guoju's race probably happens in my use case too but is not noticeable).

Finally, given the necessity of these two new full barriers in the code, I wonder if the whole lockless (+ bypass) thing should be reconsidered.
At least, I think general performance tests should be run to check that lockless qdics still outperform locked qdiscs, in both bypassable and not-bypassable modes.
    
More generally, I found this piece of code quite tricky and error-prone, as evidenced by the numerous fixes it went through in the recent history. 
I believe most of this complexity comes from the lockless qdisc handling in itself, but of course the addition of the bypass support does not really help ;-)
I'm a linux kernel beginner however, so I'll let more experienced programmers decide about that :-)

I've made sure that, with this patch, no stuck packets happened any more on both v5.15 and v5.18-rc2 (whereas without the patch, numerous occurrences of stuck packets are visible).
I'm quite confident it will apply to any concerned version, that is from 5.14 (or before) to mainline.

Can you please tell me :

1) if you agree with this ?

2) how to proceed to push this patch (and Guoju's) for quick integration into the mainline ?

NB : an alternative fix (which I've tested OK too) would be to simply remove the

if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
	return false;

code path, but I have no clue if this would be better or worse than the present patch in terms of performance.
    
Thank you, best regards,

V



--secu_31ddccd55f21c6496cf27dca2e43ce7d_part1
Content-Type: text/x-patch;
 name*0=net_sched_fixed_barrier_to_prevent_skbuff_sticking_in_qdisc_backlog.;
 name*1=patch
Content-Disposition: attachment;
 filename*0=net_sched_fixed_barrier_to_prevent_skbuff_sticking_in_qdisc_back;
 filename*1=log.patch

commit 917f7ff2b0f59d721d11f983af1f46c1cd74130a
Author: Vincent Ray <vray@kalray.eu>
Date:   Mon May 23 15:24:12 2022 +0200

    net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog
    
    In qdisc_run_begin(), smp_mb__before_atomic() used before test_bit()
    does not provide any ordering guarantee as test_bit() is not an atomic
    operation. This, added to the fact that the spin_trylock() call at
    the beginning of qdisc_run_begin() does not guarantee acquire
    semantics if it does not grab the lock, makes it possible for the
    following statement :
    
    if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
    
    to be executed before an enqueue operation called before
    qdisc_run_begin().
    
    As a result the following race can happen :
    
               CPU 1                             CPU 2
    
          qdisc_run_begin()               qdisc_run_begin() /* true */
            set(MISSED)                            .
          /* returns false */                      .
              .                            /* sees MISSED = 1 */
              .                            /* so qdisc not empty */
              .                            __qdisc_run()
              .                                    .
              .                              pfifo_fast_dequeue()
     ----> /* may be done here */                  .
    |         .                                clear(MISSED)
    |         .                                    .
    |         .                                smp_mb __after_atomic();
    |         .                                    .
    |         .                                /* recheck the queue */
    |         .                                /* nothing => exit   */
    |   enqueue(skb1)
    |         .
    |   qdisc_run_begin()
    |         .
    |     spin_trylock() /* fail */
    |         .
    |     smp_mb__before_atomic() /* not enough */
    |         .
     ---- if (test_bit(MISSED))
            return false;   /* exit */
    
    In the above scenario, CPU 1 and CPU 2 both try to grab the
    qdisc->seqlock at the same time. Only CPU 2 succeeds and enters the
    bypass code path, where it emits its skb then calls __qdisc_run().
    
    CPU1 fails, sets MISSED and goes down the traditionnal enqueue() +
    dequeue() code path. But when executing qdisc_run_begin() for the
    second time, after enqueing its skbuff, it sees the MISSED bit still
    set (by itself) and consequently chooses to exit early without setting
    it again nor trying to grab the spinlock again.
    
    Meanwhile CPU2 has seen MISSED = 1, cleared it, checked the queue
    and found it empty, so it returned.
    
    At the end of the sequence, we end up with skb1 enqueued in the
    backlog, both CPUs out of __dev_xmit_skb(), the MISSED bit not set,
    and no __netif_schedule() called made. skb1 will now linger in the
    qdisc until somebody later performs a full __qdisc_run(). Associated
    to the bypass capacity of the qdisc, and the ability of the TCP layer
    to avoid resending packets which it knows are still in the qdisc, this
    can lead to serious traffic "holes" in a TCP connexion.
    
    We fix this by turning smp_mb__before_atomic() into smp_mb() which
    guarantees the correct ordering of enqueue() vs test_bit() and
    consequently prevents the race.

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9bab396c1f3b..0c6016e10a6f 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -191,7 +191,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		 * STATE_MISSED checking is synchronized with clearing
 		 * in pfifo_fast_dequeue().
 		 */
-		smp_mb__before_atomic();
+		smp_mb();
 
 		/* If the MISSED flag is set, it means other thread has
 		 * set the MISSED flag before second spin_trylock(), so

--secu_31ddccd55f21c6496cf27dca2e43ce7d_part1--


