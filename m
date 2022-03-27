Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D714E8B1E
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 01:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiC0XyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 19:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiC0XyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 19:54:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F8232999;
        Sun, 27 Mar 2022 16:52:37 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22RHp42g020397;
        Sun, 27 Mar 2022 23:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=r7UI6r0vhzHWJ0DdSAPFuEMXckYJbKdBAO1kRHkhc5Y=;
 b=IrGw5fC+bhblv0McpkRKNrHPiWoTbcp7qPAqko9LVIsi27dATC+i4mW+24aPfezh+2VB
 o/wU4wKc0uupGQLqPwCyzrM3I0RCh1BV6FrMuP55zedCCOxTDaEZ6HoAXvURZsHh4wpG
 UmT5jcAnzFsiTCCNtDgb4+ZGnxF3wTWjBomHhdvd74gIleomqmtbOMa/v/fRbuN3HpVm
 k6i7WlPaRN7z+u9H7udlArKTZtIAqRfLevsdPAqg76WD+43qXlWNwMNmejB50hoY0VIP
 ERQKj2aVeoz9ToNspp0PYpFbu6iK+tTin0InNe8EujWosaTgDYL3/J6xFWD6F7ElV5Z6 DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2cm9p13h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 23:52:19 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22RNlYAW008814;
        Sun, 27 Mar 2022 23:52:18 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2cm9p137-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 23:52:18 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22RNlhX7020612;
        Sun, 27 Mar 2022 23:52:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf8tmwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 23:52:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22RNqEFQ50135528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Mar 2022 23:52:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B3584C040;
        Sun, 27 Mar 2022 23:52:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EE6C4C044;
        Sun, 27 Mar 2022 23:52:13 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.73.54])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 27 Mar 2022 23:52:13 +0000 (GMT)
Date:   Mon, 28 Mar 2022 01:52:11 +0200
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
Message-ID: <20220328015211.296739a4.pasic@linux.ibm.com>
In-Reply-To: <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
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
        <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LIQGtJT-sE34r-gI5wfiZS3vQxX3f983
X-Proofpoint-GUID: -qkeLTOVVipiHtnnCpD3cas1qvCNYQSC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-27_09,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203270146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Mar 2022 22:21:03 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Mar 26, 2022 at 10:06 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sat, Mar 26, 2022 at 8:49 PM Halil Pasic <pasic@linux.ibm.com> wrote:  
> > >
> > > I agree it CPU modified buffers *concurrently* with DMA can never work,
> > > and I believe the ownership model was conceived to prevent this
> > > situation.  
> >
> > But that just means that the "ownership" model is garbage, and cannot
> > handle this REAL LIFE situation.  
> 
> Just to clarify: I obviously agree that the "both sides modify
> concurrently" obviously cannot work with bounce buffers.
> 
> People still do want to do that, but they'll limit themselves to
> actual cache-coherent DMA when they do so (or do nasty uncached
> accesses but at least no bounce buffering).

Thanks for the explanation!

> 
> But the "bounce ownership back and forth" model comes up empty when
> the CPU wants to read while the DMA is still going on. And that not
> only can work, but *has* worked.
> 
> You could have a new "get me a non-ownership copy" operation of
> course, 

Yes, https://www.spinics.net/lists/linux-wireless/msg222442.html was
mostly about exploring that idea.

> but that hits the problem of "which existing drivers need it?"
> 
> We have no idea, outside of ath9k.
> 
> This is why I believe we have to keep the existing semantics in a way
> that keep ath9k - and any number of unknown other drivers - happy.

I agree.

> 
> And then for the cases where you want to introduce the zeroing because
> you don't know how much data the DMA returned - those are the ones
> you'll have to mark some way.

I have no intention of pursuing this.  When fixing the information leak,
I happened to realize, that a somewhat similar situation can emerge when
mappings are reused. It seemed like an easy fix, so I asked the swiotlb
maintainers, and they agreed. It ain't my field of expertise, and the
drivers I'm interested in don't need this functionality.

Regards,
Halil

> 
>                   Linus

