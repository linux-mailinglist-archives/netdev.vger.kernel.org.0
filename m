Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701C3A2266
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfH2Rgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:36:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727437AbfH2Rgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:36:35 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7THXtuB003259;
        Thu, 29 Aug 2019 13:36:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2upgfd74qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 13:36:28 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7THZaVl007325;
        Thu, 29 Aug 2019 13:36:28 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2upgfd74pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 13:36:28 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7THUwAE013821;
        Thu, 29 Aug 2019 17:36:27 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 2ujvv75gjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 17:36:27 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7THaQTM31981944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:36:26 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B482FAE062;
        Thu, 29 Aug 2019 17:36:26 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FC97AE060;
        Thu, 29 Aug 2019 17:36:26 +0000 (GMT)
Received: from [9.53.179.215] (unknown [9.53.179.215])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 29 Aug 2019 17:36:26 +0000 (GMT)
Subject: Re: [v1] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zdai@us.ibm.com
In-Reply-To: <7a8a5024-bbff-7443-71b3-9e3976af269f@gmail.com>
References: <1567032687-973-1-git-send-email-zdai@linux.vnet.ibm.com>
         <7a8a5024-bbff-7443-71b3-9e3976af269f@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 29 Aug 2019 12:36:25 -0500
Message-ID: <1567100185.20025.3.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-29 at 10:32 +0200, Eric Dumazet wrote:
> 
> On 8/29/19 12:51 AM, David Dai wrote:
> > For high speed adapter like Mellanox CX-5 card, it can reach upto
> > 100 Gbits per second bandwidth. Currently htb already supports 64bit rate
> > in tc utility. However police action rate and peakrate are still limited
> > to 32bit value (upto 32 Gbits per second). Add 2 new attributes
> > TCA_POLICE_RATE64 and TCA_POLICE_RATE64 in kernel for 64bit support
> > so that tc utility can use them for 64bit rate and peakrate value to
> > break the 32bit limit, and still keep the backward binary compatibility.
> > 
> > Tested-by: David Dai <zdai@linux.vnet.ibm.com>
> > Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
> > ---
> >  include/uapi/linux/pkt_cls.h |    2 ++
> >  net/sched/act_police.c       |   27 +++++++++++++++++++++++----
> >  2 files changed, 25 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> > index b057aee..eb4ea4d 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -159,6 +159,8 @@ enum {
> >  	TCA_POLICE_AVRATE,
> >  	TCA_POLICE_RESULT,
> >  	TCA_POLICE_TM,
> > +	TCA_POLICE_RATE64,
> > +	TCA_POLICE_PEAKRATE64,
> >  	TCA_POLICE_PAD,
> >  	__TCA_POLICE_MAX
> >  #define TCA_POLICE_RESULT TCA_POLICE_RESULT
> 
> Never insert new attributes, as this breaks compatibility with old binaries (including
> old kernels)
Thanks for reviewing it!
My change is only contained within the police part. I am trying to
follow the same way htb and tbf support their 64 bit rate.

I tested the old tc binary with the newly patched kernel. It works fine.

I agree the newly compiled tc binary that has these 2 new attributes can
cause backward compatibility issue when running on the old kernel.

If can't insert new attribute, is there any
comment/suggestion/alternative on how to support 64bit police rate and
still keep the backward compatibility?

> Keep TCA_POLICE_PAD value the same, thanks.


