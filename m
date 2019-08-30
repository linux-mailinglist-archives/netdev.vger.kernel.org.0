Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3C4A3EBF
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfH3UEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:04:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727992AbfH3UEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:04:01 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UK2As5107973;
        Fri, 30 Aug 2019 16:03:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq6yx6v76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 16:03:56 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7UK3u0G112471;
        Fri, 30 Aug 2019 16:03:56 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq6yx6v6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 16:03:56 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7UJxRoM022635;
        Fri, 30 Aug 2019 20:03:55 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 2ujvv7e445-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 20:03:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UK3rGU38076684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:03:53 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83CBC6E05B;
        Fri, 30 Aug 2019 20:03:53 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EDAF6E050;
        Fri, 30 Aug 2019 20:03:52 +0000 (GMT)
Received: from [9.53.179.215] (unknown [9.53.179.215])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 20:03:52 +0000 (GMT)
Subject: Re: [v2] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zdai@us.ibm.com
In-Reply-To: <CAM_iQpVMYQUdQN5L+ntXZTffZkW4q659bvXoZ8+Ar+zeud7Y4Q@mail.gmail.com>
References: <1567191974-11578-1-git-send-email-zdai@linux.vnet.ibm.com>
         <CAM_iQpVMYQUdQN5L+ntXZTffZkW4q659bvXoZ8+Ar+zeud7Y4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 30 Aug 2019 15:03:52 -0500
Message-ID: <1567195432.20025.18.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-08-30 at 12:11 -0700, Cong Wang wrote:
> On Fri, Aug 30, 2019 at 12:06 PM David Dai <zdai@linux.vnet.ibm.com> wrote:
> > -       if (p->peak_present)
> > +               if ((police->params->rate.rate_bytes_ps >= (1ULL << 32)) &&
> > +                   nla_put_u64_64bit(skb, TCA_POLICE_RATE64,
> > +                                     police->params->rate.rate_bytes_ps,
> > +                                     __TCA_POLICE_MAX))
> 
> I think the last parameter should be TCA_POLICE_PAD.
Thanks for reviewing it!
I have the impression that last parameter num value should be larger
than the attribute num value in 2nd parameter (TC_POLICE_RATE64 in this
case). This is the reason I changed the last parameter value to
__TCA_POLICE_MAX after I moved the new attributes after TC_POLICE_PAD in
pkt_cls.h header.

I rebuilt the kernel module act_police.ko by using TC_POLICE_PAD in the
4 parameter as before, I am able to set > 32bit rate and peakrate value
in tc command. It also works properly.

If the rest of community thinks I should keep using TC_POLICE_PAD in the
4th parameter too, I can change it to TC_POLICE_PAD in the next version.

Thanks!



