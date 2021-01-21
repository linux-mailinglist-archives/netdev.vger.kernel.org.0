Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E72FEC51
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbhAUNvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:51:42 -0500
Received: from mail.wangsu.com ([123.103.51.227]:54808 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729990AbhAUNta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 08:49:30 -0500
Received: from XMCDN1207038 (unknown [59.61.78.236])
        by app2 (Coremail) with SMTP id 4zNnewB3_dUQhglgloAAAA--.199S2;
        Thu, 21 Jan 2021 21:48:01 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'Yuchung Cheng'" <ycheng@google.com>,
        "'Neal Cardwell'" <ncardwell@google.com>
Cc:     "'Netdev'" <netdev@vger.kernel.org>,
        "'Eric Dumazet'" <edumazet@google.com>
References: <1611139794-11254-1-git-send-email-yangpc@wangsu.com> <CADVnQykgYGc4_U+eyXU72fky2C5tDQKuOuQ=BdfqfROTG++w7Q@mail.gmail.com> <CAK6E8=e1sdqntpLzeaGKhFB_DhhcNrJmPBQ3u9M44fSqdNTg_Q@mail.gmail.com>
In-Reply-To: <CAK6E8=e1sdqntpLzeaGKhFB_DhhcNrJmPBQ3u9M44fSqdNTg_Q@mail.gmail.com>
Subject: Re: tcp: rearm RTO timer does not comply with RFC6298
Date:   Thu, 21 Jan 2021 21:48:06 +0800
Message-ID: <022d01d6effc$0ccd0c50$266724f0$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQHseN1+7zYacLg+xDbjQEUA7cnGOAH+ZpDuAhn1Hdip5jCfoA==
X-CM-TRANSID: 4zNnewB3_dUQhglgloAAAA--.199S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZryxZw45Cw4ktry5Wr1xXwb_yoW8Kw45pF
        WxKa97KF4kJF4xCan2vw1kur10qrW3Jr48XFyqk3429asrKryfXr4fJayIgFW7Cw4UAr1Y
        vrWjqFZxXFs8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkCb7Iv0xC_tr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj64x0Y40En7xvr7AKxVWU
        JVW8JwAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_Xr4l42xK82IYc2Ij64vIr41l
        42xK82IY6x8ErcxFaVAv8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUOoGHUU
        UUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 2:59 AM Yuchung Cheng <ycheng@google.com> wrote:
> 
> On Wed, Jan 20, 2021 at 6:59 AM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Wed, Jan 20, 2021 at 5:50 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > >
> > > hi,
> > >
> > > I have a doubt about tcp_rearm_rto().
> > >
> > > Early TCP always rearm the RTO timer to NOW+RTO when it receives
> > > an ACK that acknowledges new data.
> > >
> > > Referring to RFC6298 SECTION 5.3: "When an ACK is received that
> > > acknowledges new data, restart the retransmission timer so that
> > > it will expire after RTO seconds (for the current value of RTO)."
> > >
> > > After ER and TLP, we rearm the RTO timer to *tstamp_of_head+RTO*
> > > when switching from ER/TLP/RACK to original RTO in tcp_rearm_rto(),
> > > in this case the RTO timer is triggered earlier than described in
> > > RFC6298, otherwise the same.
> > >
> > > Is this planned? Or can we always rearm the RTO timer to
> > > tstamp_of_head+RTO?
> > >
> > > Thanks.
> > >
> >
> > This is a good question. As far as I can tell, this difference in
> > behavior would only come into play in a few corner cases, like:
> >
> > (1) The TLP timer fires and the connection is unable to transmit a TLP
> > probe packet. This could happen due to memory allocation failure  or
> > the local qdisc being full.
> >
> > (2) The RACK reorder timer fires but the connection does not take the
> > normal course of action and mark some packets lost and retransmit at
> > least one of them. I'm not sure how this would happen. Maybe someone
> > can think of a case.

Yes, and it also happens when an ACK (a cumulative ACK covered out-of-order data)
is received that makes ca_state change from DISORDER to OPEN, by calling tcp_set_xmit_timer().
Because TLP is not triggered under DISORDER and tcp_rearm_rto() is called before the
ca_state changes.

> >
> > My sense would be that given how relatively rare (1)/(2) are, it is
> > probably not worth changing the current behavior, given that it seems
> > it would require extra state (an extra u32 snd_una_advanced_tstamp? )
> > to save the time at which snd_una advanced (a cumulative ACK covered
> > some data) in order to rearm the RTO timer for snd_una_advanced_tstamp
> > + rto.
> 
> also there's an experimental proposal
> https://tools.ietf.org/html/rfc7765
> 
> so Linux actually implements that in a limited way that only applies
> in specific scenarios.
> 
> >
> > neal

Thank you for answering my questions.

