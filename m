Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2879E2F4093
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393556AbhAMAm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392345AbhAMAlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 19:41:35 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D0WJ4r051398;
        Tue, 12 Jan 2021 19:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=DAtSyzwtxXG0k9oppJhBOgXVNK/QvwvtVpeHD0AMcGI=;
 b=EaGiWWBgJPaSAfy3BSyycLs3z/VS0ZBb2m8rg49G0ig+inJyh8lzhQ0S9WBVMl0NmJAq
 5qaiFbS+JJj3UZPiT/RFhQQZfJwzMT69GGY4S2586QGgBj9rB5Lz2Jz3Mo1Dmn9dBgQ4
 YOPOkODAOzIrCk6x6UCBouOqDdk8sgYio2xA87Kpq1oTcuxluajwzSrb56nZJgWWMQgA
 iyuonSA+SMf/oqVpnjado24UUbAEGdej48LHiGU7YBWnK9XibOoOv7RdyB+aGqqq/s1Z
 hzedeUKtT/+axUEYLsC8qxF9FMgbxcLvjtYFxHByYJnnLeO+/xdn/d5W2He4xJ3oEiFZ vA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361np9h2f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 19:40:54 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D0W0bZ006561;
        Wed, 13 Jan 2021 00:40:53 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 35y4498c65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 00:40:53 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D0eqHi41287956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 00:40:52 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2A84124058;
        Wed, 13 Jan 2021 00:40:52 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E9FD124053;
        Wed, 13 Jan 2021 00:40:52 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.207.168])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 00:40:52 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id CA9A72E288B; Tue, 12 Jan 2021 16:40:49 -0800 (PST)
Date:   Tue, 12 Jan 2021 16:40:49 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 5/7] ibmvnic: serialize access to work queue
Message-ID: <20210113004049.GA216185@us.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
 <20210112181441.206545-6-sukadev@linux.ibm.com>
 <47e7f34d0c8a14eefba6aac00b08fc39cab61679.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47e7f34d0c8a14eefba6aac00b08fc39cab61679.camel@kernel.org>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_21:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed Mahameed [saeed@kernel.org] wrote:
> On Tue, 2021-01-12 at 10:14 -0800, Sukadev Bhattiprolu wrote:

<snip>
> > @@ -5467,7 +5472,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
> >  		return -EBUSY;
> >  	}
> >  
> > +	/* If ibmvnic_reset() is scheduling a reset, wait for it to
> > +	 * finish. Then prevent it from scheduling any more resets
> > +	 * and have the reset functions ignore any resets that have
> > +	 * already been scheduled.
> > +	 */
> > +	spin_lock_irqsave(&adapter->remove_lock, flags);
> >  	adapter->state = VNIC_REMOVING;
> > +	spin_unlock_irqrestore(&adapter->remove_lock, flags);
> > +
> 
> Why irqsave/restore variants ? are you expecting this spinlock to be
> held in interruptcontext ?
> 
> >  	spin_unlock_irqrestore(&adapter->state_lock, flags);

Good question.

One of the callers of ibmvnic_reset() is the ->ndo_tx_timeout()
method which gets called from the watchdog timer.

Thanks for the review.

Sukadev
