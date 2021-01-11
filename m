Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D452F0B99
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 04:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbhAKDxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 22:53:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726625AbhAKDxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 22:53:13 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10B3hVIE194377;
        Sun, 10 Jan 2021 22:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=CST7vtvA4V4Fve2vL8u1hFx31nH4DkZS1Ob0Sl/tBss=;
 b=A7UHu9FBp0qMMz3YqqoaKVSaWVbM4H2pvdz/BoGCeuMf0+pDD1Fgk/iuQpRO4BIRu++N
 7z5LdqXSFf/6QgkiqUMub6D2oWNhQ+LYsootkGq8BE6VN7Qq6kFDkhPb/MtL0D/Ds6M3
 O1Fl3CwzSo6PXZzFZWCfKR6EVnakS/9mc+L10KwP4G7QDVKPFpgLFLd6sxV7yfWw8NJa
 3TE9BYDFlOJB1+/av+6abm9kw3T6pWetENDAxDKfxuAp1miCbsAUC9zMz4SB7SvWBy4r
 lkGVvp9m2or5EHtr+S1iIHm8hkBSq8hoc0QJhGz4bpWemjmWl+HuIJMettTVfuGBZYoj WA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 360f15r3pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 22:52:30 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10B3q9B4026158;
        Mon, 11 Jan 2021 03:52:30 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 35y448py0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 03:52:30 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10B3qTQh18612690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 03:52:29 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F241CBE04F;
        Mon, 11 Jan 2021 03:52:28 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2877BE051;
        Mon, 11 Jan 2021 03:52:28 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.203.51])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 03:52:28 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id BBEB42E28A0; Sun, 10 Jan 2021 19:52:25 -0800 (PST)
Date:   Sun, 10 Jan 2021 19:52:25 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 5/7] ibmvnic: use a lock to serialize remove/reset
Message-ID: <20210111035225.GB165065@us.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
 <20210108071236.123769-6-sukadev@linux.ibm.com>
 <20210109194146.7c8ac5ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109194146.7c8ac5ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Thu,  7 Jan 2021 23:12:34 -0800 Sukadev Bhattiprolu wrote:
> > Use a separate lock to serialze ibmvnic_reset() and ibmvnic_remove()
> > functions. ibmvnic_reset() schedules work for the worker thread and
> > ibmvnic_remove() flushes the work before removing the adapter. We
> > don't want any work to be scheduled once we start removing the
> > adapter (i.e after we have already flushed the work).
> 
> Locking based on functions, not on data being accessed is questionable
> IMO. If you don't want work to be scheduled isn't it enough to have a
> bit / flag that you set to let other flows know not to schedule reset?

Maybe I could improve the description, but the "data" being protected
is the work queue. Basically don't add to the work queue while/after
it is (being) flushed.

Existing code is checking for the VNIC_REMOVING state before scheduling
the work but without a lock. If state goes to REMOVING after we check,
we could schedule work after the flush?
> 
> > @@ -5459,6 +5464,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
> >  {
> >  	struct net_device *netdev = dev_get_drvdata(&dev->dev);
> >  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
> > +	unsigned long rmflags;
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(&adapter->state_lock, flags);
> > @@ -5467,7 +5473,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
> >  		return -EBUSY;
> >  	}
> 
> > +	spin_lock_irqsave(&adapter->remove_lock, rmflags);
> 
> You can just use flags again, no need for separate variables.

Ok.
> 
> >  	adapter->state = VNIC_REMOVING;
> > +	spin_unlock_irqrestore(&adapter->remove_lock, rmflags);
