Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE772FFFC0
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbhAVKFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:05:30 -0500
Received: from mail.wangsu.com ([123.103.51.227]:33367 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727786AbhAVKDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 05:03:07 -0500
Received: from XMCDN1207038 (unknown [59.61.78.236])
        by app2 (Coremail) with SMTP id 4zNnewD3_q6LogpgP5MBAA--.260S2;
        Fri, 22 Jan 2021 18:01:48 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'Neal Cardwell'" <ncardwell@google.com>
Cc:     "'Yuchung Cheng'" <ycheng@google.com>,
        "'Netdev'" <netdev@vger.kernel.org>,
        "'Eric Dumazet'" <edumazet@google.com>
References: <1611139794-11254-1-git-send-email-yangpc@wangsu.com> <CADVnQykgYGc4_U+eyXU72fky2C5tDQKuOuQ=BdfqfROTG++w7Q@mail.gmail.com> <CAK6E8=e1sdqntpLzeaGKhFB_DhhcNrJmPBQ3u9M44fSqdNTg_Q@mail.gmail.com> <022d01d6effc$0ccd0c50$266724f0$@wangsu.com> <CADVnQy=jwBHg_Pf+puzxTCOCKxZJU2uThAuXU9CtkWFxtqU69w@mail.gmail.com>
In-Reply-To: <CADVnQy=jwBHg_Pf+puzxTCOCKxZJU2uThAuXU9CtkWFxtqU69w@mail.gmail.com>
Subject: Re: tcp: rearm RTO timer does not comply with RFC6298
Date:   Fri, 22 Jan 2021 18:01:53 +0800
Message-ID: <028901d6f0a5$9cb75920$d6260b60$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQHseN1+7zYacLg+xDbjQEUA7cnGOAH+ZpDuAhn1HdgCGs6QXQFkbtZxqcsV0CA=
X-CM-TRANSID: 4zNnewD3_q6LogpgP5MBAA--.260S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF15ZrW5KrWDWFWUKw15Arb_yoWrJF45pF
        W3KFs7tr4kJryxCwn2qw1kZr1vqryfJr1UXa4DKryUu3sFgrySqr4UK3y2gFW7ur4kCr1Y
        vFWUtrW3Xan8Z37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkCb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj64x0Y40En7xvr7AKxVWU
        JVW8JwAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l
        42xK82IY6x8ErcxFaVAv8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUSPrcDU
        UUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 11:51 PM Neal Cardwell <ncardwell@google.com> wrote:
> 
> On Thu, Jan 21, 2021 at 9:05 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > On Thu, Jan 21, 2021 at 2:59 AM Yuchung Cheng <ycheng@google.com> wrote:
> > >
> > > On Wed, Jan 20, 2021 at 6:59 AM Neal Cardwell <ncardwell@google.com> wrote:
> > > >
> > > > On Wed, Jan 20, 2021 at 5:50 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > > > >
> > > > > hi,
> > > > >
> > > > > I have a doubt about tcp_rearm_rto().
> > > > >
> > > > > Early TCP always rearm the RTO timer to NOW+RTO when it receives
> > > > > an ACK that acknowledges new data.
> > > > >
> > > > > Referring to RFC6298 SECTION 5.3: "When an ACK is received that
> > > > > acknowledges new data, restart the retransmission timer so that
> > > > > it will expire after RTO seconds (for the current value of RTO)."
> > > > >
> > > > > After ER and TLP, we rearm the RTO timer to *tstamp_of_head+RTO*
> > > > > when switching from ER/TLP/RACK to original RTO in tcp_rearm_rto(),
> > > > > in this case the RTO timer is triggered earlier than described in
> > > > > RFC6298, otherwise the same.
> > > > >
> > > > > Is this planned? Or can we always rearm the RTO timer to
> > > > > tstamp_of_head+RTO?
> > > > >
> > > > > Thanks.
> > > > >
> > > >
> > > > This is a good question. As far as I can tell, this difference in
> > > > behavior would only come into play in a few corner cases, like:
> > > >
> > > > (1) The TLP timer fires and the connection is unable to transmit a TLP
> > > > probe packet. This could happen due to memory allocation failure  or
> > > > the local qdisc being full.
> > > >
> > > > (2) The RACK reorder timer fires but the connection does not take the
> > > > normal course of action and mark some packets lost and retransmit at
> > > > least one of them. I'm not sure how this would happen. Maybe someone
> > > > can think of a case.
> >
> > Yes, and it also happens when an ACK (a cumulative ACK covered out-of-order data)
> > is received that makes ca_state change from DISORDER to OPEN, by calling tcp_set_xmit_timer().
> > Because TLP is not triggered under DISORDER and tcp_rearm_rto() is called before the
> > ca_state changes.
> 
> Hmm, that sounds like a good catch, and potentially a significant bug.
> Re-reading the code, it seems that you correctly identify that on an
> ACK when reordering is resolved (ca_state change from DISORDER to
> OPEN) we will not set a TLP timer for now+TLP_interval, but instead
> will set an RTO timer for rtx_head_tx_time+RTO (which could be very
> soon indeed, if RTTVAR is very low). Seems like that could cause
> spurious RTOs with connections that experience reordering with low RTT
> variance.
> 
> It seems like we should try to fix this. Perhaps by calling
> tcp_set_xmit_timer() only after we have settled on a final ca_state
> implied by this ACK (in this case, to allow DISORDER to be resolved to
> OPEN). Though that would require some careful surgery, since that
> would move the tcp_set_xmit_timer() call *after* the point at which
> the RACK reorder timer would be set.
> 
> Other thoughts?
> 
> neal

I think this fix is necessary. Actually, we also fixed this issue on our branch recently
when we fixed an issue where the TLP timer might not fire(Point 1 below),
by calling tcp_set_xmit_timer() after tcp_fastretrans_alert() and 
then removing FLAG_SET_XMIT_TIMER from ack_flag when the RACK 
reorder timer is set. 

This repair has two additional benefits according to my understanding:
(1) When ca_state changes from DISORDER to OPEN, the TLP timer can be activated,
otherwise, the sender can only wait for the RTO timer when it is app-limited.
(2) Reduce the xmit timer reschedule once per ACK when the RACK reorder timer is set.

I'll send this fix later, I'm not sure whether there is a more elegant way. : )

