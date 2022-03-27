Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3234E8B19
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 01:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbiC0Xjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 19:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiC0Xjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 19:39:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAA839695;
        Sun, 27 Mar 2022 16:38:01 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22RGLKSd015033;
        Sun, 27 Mar 2022 23:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=h95MFuu8sCAF14Vk8T1CrSX1DuS3vetOlCQOwB3NF3c=;
 b=M/+sK3vWL7tczAy+s1Fr7A1oQrsK7JnMSCYSGY1Xar7VhPq1iO9ZJtgpjmYnj3N38JyB
 LCTpX7FIXHAK7Bs03A0SZOgJezgpsHHFbDe82M2D2K6dHOkPZfciTCP3mbuWVOmxIsQZ
 sBiNixZCJF/K4bT51NVfFmkMYgPa3Wx5A7y5AorSc+f6Spp2Px4KRdssnuTF6cHkMoxk
 prYdnoebgaWoViNYdC7b8Z1/7mDaK2uaSirx4C5KBqGXBtvqdyJ+TOJeBkctvhmZ0GiF
 S3grr3r471l1vPCIDiicZFn+nQRDv06/0djF5TERVZVOPG7XLkLxKpUaQP3PPBAcL1rY aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c75e8n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 23:37:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22RNbcl8030943;
        Sun, 27 Mar 2022 23:37:38 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c75e8mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 23:37:38 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22RNXdct008881;
        Sun, 27 Mar 2022 23:37:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf8tm50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 23:37:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22RNPfW751249414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Mar 2022 23:25:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C542A405B;
        Sun, 27 Mar 2022 23:37:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895ADA4060;
        Sun, 27 Mar 2022 23:37:33 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.73.54])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 27 Mar 2022 23:37:33 +0000 (GMT)
Date:   Mon, 28 Mar 2022 01:37:31 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Message-ID: <20220328013731.017ae3e3.pasic@linux.ibm.com>
In-Reply-To: <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
        <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
        <20220324055732.GB12078@lst.de>
        <4386660.LvFx2qVVIh@natalenko.name>
        <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com>
        <878rsza0ih.fsf@toke.dk>
        <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
        <20220324163132.GB26098@lst.de>
        <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
        <871qyr9t4e.fsf@toke.dk>
        <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
        <20220327054848.1a545b12.pasic@linux.ibm.com>
        <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OSzpZhsxcohLhiONuYpU9uEnBhRgngDG
X-Proofpoint-ORIG-GUID: Vl2OIL7aro33yfgdzaQOHVrw_skELrle
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-27_09,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203270146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Mar 2022 22:06:15 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Mar 26, 2022 at 8:49 PM Halil Pasic <pasic@linux.ibm.com> wrote:
> >
> > I agree it CPU modified buffers *concurrently* with DMA can never work,
> > and I believe the ownership model was conceived to prevent this
> > situation.  
> 
> But that just means that the "ownership" model is garbage, and cannot
> handle this REAL LIFE situation.
> 
> Here's the deal: if somebody makes a model that is counter-factual,
> you have exactly two choices:
> 
>  - fix the damn model
> 
>  - live in a la-la-land that isn't reality
> 
> Which choice do you pick?

I pix "fix the dam model". This email of mine was supposed to discuss how
the model can be fixed:
https://www.spinics.net/lists/linux-wireless/msg222442.html

> 
> And I'll be brutally honest: if you pick the la-la-land one, I don't
> think we can really discuss this any more.

I completely agree. Never intended to pick the la-la-land one.

> 
> > But a CPU can modify the buffer *after* DMA has written to
> > it, while the mapping is still alive.  
> 
> Yes.
> 
> But you are making ALL your arguments based on that "ownership" model
> that we now know is garbage.

Sorry, I'm not very knowledgeable when it comes all the different
hardware out there.

> 
> If you make your arguments based on garbage, the end result _might_
> work just by happenstance, but the arguments sure aren't very
> convincing, are they?

No it is not. I have to admit, I did see some value in talking about the
model that is described by the current documentation for two reasons:
1) Not everybody has great knowledge of all the hardware out there, and
there might be people other than me, who based their work on that broken
model. And thus wrote code that is correct within the broken model,
but not correct within the fixed mode. Does not see to be the case here,
but I was not able to tell.
2) To fix the model, we have to understand both reality and the model.
Or we have to replace it with an entirely new one.

> 
> So let's make it really clear that the arguments must not be based on
> some "ownership" model that you just admitted cannot handle the very
> real case of real and common hardware.
> 
> Ok?

Sure. It was never my intention to base my argument on false assumptions.

> 
> >  For example one could do one
> > partial read from the device, *after* the DMA is done,
> > sync_for_cpu(DMA_FROM_DEVICE), examine, then zero out the entire buffer,
> > sync_for_device(DMA_FROM_DEVICE)  
> 
> So the result you want to get to I can believe in, but your sequence
> of getting there is untenable, since it depends on breaking other
> cases that are more important than your utterly broken hardware that
> you don't even know how much data it filled.
> 

I agree, and that is is the very reason I said, I'm not against the
partial revert (see
https://www.spinics.net/lists/linux-wireless/msg222326.html)

Hey, I don't even know if there is a single usage of what I described.
In fact I asked the community is this even something legit. What I know,
is that the current (broken) model does allow the scenario.

> And I fundamentally also happen to think that since the CPU just wrote
> that buffer, and *that* write is what you want to sync with the
> device, then that DMA_FROM_DEVICE was just pure fantasy to begin with.
> 

Not sync with the device, but with the memory. And it is supposed to
happen after the DMA has completed, and not while the DMA is ongoing.

But I'm clearly not knowledgeable enough to have this discussion. I'm
afraid if I continue, I will just drag the community down.

> So that code sequence you quote is wrong. You are literally trying to
> re-introduce the semantics that we already know broke the ath9k
> driver.
> 
> Instead, let me give you a couple of alternative scenarios.
> 
> Alternative 1:
> 
>  - ok, so the CPU wrote zeroes to the area, and we want to tell the
> DMA mapping code that it needs to make that CPU write visible to the
> device.

Not make visible to the device but make actually it RAM instead of 
remaining in cache. My most basic mental model is:

+----------------+
|                |        +---------+         +--------+
|     +--------+ |        |         |   DMA   |        |
| CPU | CACHE  | |  <---> |   RAM   |  <----> | DEVICE |
|     +--------+ |        |         |         |        |
|                |        +---------+         +--------+
+----------------+

> 
>  - Ahh, you mean "sync_for_device(DMA_TO_DEVICE)"?
> 
>  - Yes.
> 
>    The "for_device()" tells us that afterwards, the device can access
> the memory (we synced it for the device).
> 
>    And the DMA_TO_DEVICE tells us that we're transferring the zeroes
> we wrote on the CPU to the device bounce buffer.
> 
>    Now the device got those zeroes, and it can overwrite them
> (partially), and everything is fine
> 
>  - And then we need to use "sync_for_cpu(DMA_FROM_DEVICE)" when we
> want to see the result once it's all done?
> 
>  - Yes.
> 
>  - Splendid. Except I don't like how you mix DMA_TO_DEVICE and
> DMA_FROM_DEVICE and you made the dma_alloc() not use DMA_BIDIRECTIONAL
> 
>  - Yeah, that's ugly, but it matches reality, and it would "just work" today.
> 

It is certainly an option. The tricky part is that one is supposed to use
DMA_TO_DEVICE even if the device does not read RAM but only writes it,
and thus the direction of the data flow of the direct memory access (DMA)
is from the device to the memory (RAM).

> Alternative 2:
> 
>  - Ok, so the CPU doesn't even want to write to the area AT ALL, but
> we know we have a broken device that might not fill all of the bounce
> buffer, and we don't want to see old stale bounce buffer contents that
> could come from some other operation entirely and leak sensitive data
> that wasn't for us.
> 
>  - Ahh, so you really want to just clear the bounce buffer before IO?
> 
>  - Yes. So let's introduce a "clear_bounce_buffer()" operation before
> starting DMA. Let's call it "sync_for_device(DMA_NONE)" and teach the
> non-bounce-buffer dmas mapping entities to just ignore it, because
> they don't have a bounce buffer that can contain stale data.
> 
>  - Sounds good.
> 

It is an option.

> Alternative 3:
> 
>  - Ok, you have me stumped. I can't come up with something else sane.
> 

I have tired to in
https://www.spinics.net/lists/linux-wireless/msg222442.html

> Anyway, notice what's common about these alternatives? They are based
> not on some "we have a broken model", but on trying to solve the
> actual real-life problem case.

Yes.
> 
> I'm more than happy to hear other alternatives.
> 
> But the alternative I am _not_ willing to entertain is "Yeah, we have
> a model of ownership, and that can't handle ath9k because that one
> wants to do CPU reads while DMA is possibly active, so ath9k is
> broken".
> 
> Can we please agree on that?
> 

Yes.

AFAIU the main reason we have should postulate the ath9k code is correct,
is that it would be prohibitively expensive not to do so. Because we
can comparatively easily change ath9k, but we can't be sure about other
uses of sync_for_device unless we audit all of them. That does make
perfect sense for me.

IMHO that also means that the whole "ownership" concept is beyond saving,
and that we should rewrite the corresponding parts of the documentation.
Thus my effort at saving it was misguided.

Give how this unfolded, I intend to let the more knowledgeable people
hash out the new model, and avoiding dragging down the community by
being too vocal about my opinion.

For the record, I believe that the partial revert proposed here
https://www.spinics.net/lists/linux-wireless/msg222300.html
would have been a wiser choice, than a complete revert of commit
aa6f8dcbab47 ("swiotlb: rework "fix info leak with DMA_FROM_DEVICE"").
The reason why is in the commit message, and was also pointed out by
Robin.

Regards,
Halil
