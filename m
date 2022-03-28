Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F41B4E9624
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242169AbiC1MER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbiC1MEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:04:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E34AA184;
        Mon, 28 Mar 2022 05:02:36 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SBGVe1003281;
        Mon, 28 Mar 2022 12:02:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eopDlAerto5cu8t7VL8uSZexV6d47sbjv0WpEVVN2rU=;
 b=Cu5VpJUCNGXzVkcSJxYEJwsCik8ePrSlSlPkWaTPJPiteXSvT692JkTW4vkesEpt/Qrh
 pVwIjXv9/WVCfu6htCYTDqN8BMKJInzIHP6NKsXB6bfk5cxulFVuVdSm0quOhHuphxOX
 dUCcmP3dZy/ntPuyCvjV4wRYHU7yu+OQsNTfIzSNrUEn2jp2gujrepHGsIpimgNHwCrB
 +aS9cWislnobScISShwC5c2D1YX9IvaYwMojGU4MlWJB4bobg0bAZ7TcNBcN3QLtNVFY
 Z1XjfektwqWVmCFPy0WYSudFWon8dmZDBG6PcqRy4TtxqFrzRBDBU1xdu5UWikEjnVv1 jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3c0f8wk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 12:02:13 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22SBqrwq021727;
        Mon, 28 Mar 2022 12:02:12 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3c0f8wj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 12:02:12 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22SBrN3m021407;
        Mon, 28 Mar 2022 12:02:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3f1tf8ua8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 12:02:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SC273W35651888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 12:02:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1CDB52067;
        Mon, 28 Mar 2022 12:02:07 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.73.54])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 037DC5204F;
        Mon, 28 Mar 2022 12:02:06 +0000 (GMT)
Date:   Mon, 28 Mar 2022 14:02:04 +0200
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
Message-ID: <20220328140205.59c2c1b8.pasic@linux.ibm.com>
In-Reply-To: <CAHk-=whK3z5O4G55cOb2JYgwisb4cpDK=qhM=0CfmCC8PD+xMQ@mail.gmail.com>
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
        <20220328015211.296739a4.pasic@linux.ibm.com>
        <CAHk-=whK3z5O4G55cOb2JYgwisb4cpDK=qhM=0CfmCC8PD+xMQ@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qM3F7YJf-cGX00jEe2OWQrGFmuf7JALY
X-Proofpoint-GUID: -noAAuTabGO02OaibSytSTpo2UpQgv16
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_04,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Mar 2022 17:30:01 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Mar 27, 2022 at 4:52 PM Halil Pasic <pasic@linux.ibm.com> wrote:
> >
> > I have no intention of pursuing this.  When fixing the information leak,
> > I happened to realize, that a somewhat similar situation can emerge when
> > mappings are reused. It seemed like an easy fix, so I asked the swiotlb
> > maintainers, and they agreed. It ain't my field of expertise, and the
> > drivers I'm interested in don't need this functionality.  
> 
> Ok.
> 
> That said, I think you are putting yourself down when you said in an
> earlier email that you aren't veryt knowledgeable in this area.
> 
> I think the fact that you *did* think of this other similar situation
> is actually very interesting, and it's something people probably
> _haven't_ been thinking about.

Thank you!

> 
> So I think your first commit fixes the straightforward and common case
> where you do that "map / partial dma / unmap" case.
> 
> And that straightforward case is probably all that the disk IO case
> ever really triggers, which is presumably why those "drivers I'm
> interested in don't need this functionality" don't need anything else?
> 

I agree.

> And yes, your second commit didn't work, but hey, whatever. The whole
> "multiple operations on the same double buffering allocation"
> situation is something I don't think people have necessarily thought
> about enough.
> 
> And by that I don't mean you. I mean very much the whole history of
> our dma mapping code.
> 

I agree. We are in the process of catching up! :) My idea was to aid
a process, as a relatively naive pair of eyes: somebody didn't read any
data sheets describing non-cache-coherent DMA, and never programmed
a DMA. It is a fairly common problem, that for the very knowledgeable
certain things seem obvious, self-explanatory or trivial, but for the
less knowledgeable the are not. And knowledge can create bias.

> I then get opinionated and probably too forceful, but please don't
> take it as being about you - it's about just my frustration with that
> code - and if it comes off too negative then please accept my
> apologies.

I have to admit, I did feel a little uncomfortable, and I did look for
an exit strategy. I do believe, that people in your position do have to
occasionally get forceful, and even abrasive to maintain efficiency. I
try to not ignore the social aspect of things, but I do get carried away
occasionally.

Your last especially paragraph is very encouraging and welcome. Thank
you!

Regards,
Halil

[..]
