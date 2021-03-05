Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4362532F370
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 20:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCETFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 14:05:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17498 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229562AbhCETFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 14:05:38 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125J2fPa178066;
        Fri, 5 Mar 2021 14:05:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ENdV/7ghGeicSnyFh4L3pv88y4xyuowno6d9fEDiUk8=;
 b=BEIj2AGHyUkwphy3yeLmjYr6Iwrbousa5QFXHj7YIHnubZmsQb5rflNUwO80JWPtV4YB
 f2GrNQ0AYImJ1EBLI7VECNOn6sVFl+lbuOkJRZOuSctFX2HFwsTpbvSe3upYrFu+5csJ
 fqPVZFJaONCUdoZMJPB1U4DMFU9JNJN69Uli+rmmCClVuNgtm7kKE/2AzUpZ5yqYuj/6
 1pcYJ3FGfBH5vGWZnTh28C7ycCl6/M4/rh4Oogimuv5FECDx3VDmcNjjoC6GIcs7+Spa
 gZmV/6CpBTDwBsdB91EqnOIEj+to5b6inFJvYlNlmEZq3negeDvEWE6DEkc7X3/rdM+v sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373sdt1m41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 14:05:35 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 125J3S22184398;
        Fri, 5 Mar 2021 14:05:35 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373sdt1m3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 14:05:35 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 125Iv6KT020110;
        Fri, 5 Mar 2021 19:05:34 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 371qmv84c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 19:05:34 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 125J5XHf24052142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 19:05:33 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45D71AC05E;
        Fri,  5 Mar 2021 19:05:33 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F87EAC05B;
        Fri,  5 Mar 2021 19:05:33 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.156.62])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Mar 2021 19:05:33 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 7FFF62E0ED6; Fri,  5 Mar 2021 11:05:30 -0800 (PST)
Date:   Fri, 5 Mar 2021 11:05:30 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dany Madden <drt@linux.ibm.com>, tlfalcon@linux.ibm.com
Subject: Re: [RFC PATCH net] ibmvnic: complete dev->poll nicely during
 adapter reset
Message-ID: <20210305190530.GB1411314@us.ibm.com>
References: <20210305074456.88015-1-ljp@linux.ibm.com>
 <20210305184157.GA1411314@us.ibm.com>
 <CAOhMmr6cbrnX_j3Hgwpbgt_Ou7UtkgJRToCTjuq5hTPPjrwnrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhMmr6cbrnX_j3Hgwpbgt_Ou7UtkgJRToCTjuq5hTPPjrwnrw@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_13:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=974 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [lijunp213@gmail.com] wrote:
> On Fri, Mar 5, 2021 at 12:44 PM Sukadev Bhattiprolu
> <sukadev@linux.ibm.com> wrote:
> >
> > Lijun Pan [ljp@linux.ibm.com] wrote:
> > > The reset path will call ibmvnic_cleanup->ibmvnic_napi_disable
> > > ->napi_disable(). This is supposed to stop the polling.
> > > Commit 21ecba6c48f9 ("ibmvnic: Exit polling routine correctly
> > > during adapter reset") reported that the during device reset,
> > > polling routine never completed and napi_disable slept indefinitely.
> > > In order to solve that problem, resetting bit was checked and
> > > napi_complete_done was called before dev->poll::ibmvnic_poll exited.
> > >
> > > Checking for resetting bit in dev->poll is racy because resetting
> > > bit may be false while being checked, but turns true immediately
> > > afterwards.
> >
> > Yes, have been testing a fix for that.
> > >
> > > Hence we call napi_complete in ibmvnic_napi_disable, which avoids
> > > the racing with resetting, and makes sure dev->poll and napi_disalbe
> >
> > napi_complete() will prevent a new call to ibmvnic_poll() but what if
> > ibmvnic_poll() is already executing and attempting to access the scrqs
> > while the reset path is freeing them?
> >
> napi_complete() and napi_disable() are called in the earlier stages of
> reset path, i.e. before reset path actually calls the functions to
> freeing scrqs.

Yes, those will prevent a _new_ call to poll right?

But what if poll is already executing? What prevents it from accessing
an scrq that the reset path will free?

> So I don't think this is a issue here.
