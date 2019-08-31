Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A26A4155
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 02:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfHaAa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 20:30:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728248AbfHaAa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 20:30:57 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7V0RZZN096220;
        Fri, 30 Aug 2019 20:30:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uqd461v3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 20:30:51 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7V0Re3I096415;
        Fri, 30 Aug 2019 20:30:51 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uqd461v3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 20:30:51 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7V0UOY9031573;
        Sat, 31 Aug 2019 00:30:49 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 2ujvv6wpfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Aug 2019 00:30:49 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7V0UnO429688118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 00:30:49 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51F5F112063;
        Sat, 31 Aug 2019 00:30:49 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1A0C112062;
        Sat, 31 Aug 2019 00:30:48 +0000 (GMT)
Received: from [9.85.180.12] (unknown [9.85.180.12])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 31 Aug 2019 00:30:48 +0000 (GMT)
Subject: Re: [v2] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zdai@us.ibm.com
In-Reply-To: <20190830.133335.323827182628557013.davem@davemloft.net>
References: <1567191974-11578-1-git-send-email-zdai@linux.vnet.ibm.com>
         <CAM_iQpVMYQUdQN5L+ntXZTffZkW4q659bvXoZ8+Ar+zeud7Y4Q@mail.gmail.com>
         <1567195432.20025.18.camel@oc5348122405>
         <20190830.133335.323827182628557013.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 30 Aug 2019 19:30:47 -0500
Message-ID: <1567211447.25082.3.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-31_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908310001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-08-30 at 13:33 -0700, David Miller wrote:
> From: "David Z. Dai" <zdai@linux.vnet.ibm.com>
> Date: Fri, 30 Aug 2019 15:03:52 -0500
> 
> > I have the impression that last parameter num value should be larger
> > than the attribute num value in 2nd parameter (TC_POLICE_RATE64 in this
> > case).
> 
> The argument in question is explicitly the "padding" value.
> 
> Please explain in detail where you got the impression that the
> argument has to be larger?
In include/uapi/linux/pkt_sched.h header:
For HTB:
enum {
        TCA_HTB_UNSPEC,
        TCA_HTB_PARMS,
        TCA_HTB_INIT,
        TCA_HTB_CTAB,
        TCA_HTB_RTAB,
        TCA_HTB_DIRECT_QLEN,
        TCA_HTB_RATE64,    /* <--- */
        TCA_HTB_CEIL64,    /* <--- */
        TCA_HTB_PAD,       /* <--- */
        __TCA_HTB_MAX,
};
/* TCA_HTB_RATE64,TCA_HTB_CEIL64 are declared *before* TCA_HTB_PAD */

For TBF:
enum {
        TCA_TBF_UNSPEC,
        TCA_TBF_PARMS,
        TCA_TBF_RTAB,
        TCA_TBF_PTAB,
        TCA_TBF_RATE64,   /* <--- */
        TCA_TBF_PRATE64,  /* <--- */
        TCA_TBF_BURST,
        TCA_TBF_PBURST,
        TCA_TBF_PAD,      /* <--- */
        __TCA_TBF_MAX,
};
/* TCA_TBF_RATE64, TCA_TBF_PRATE64 are declared *before* TCA_TBF_PAD */

For HTB, in net/sched/sch_htb.c file, htb_dump_class() routine:
        if ((cl->rate.rate_bytes_ps >= (1ULL << 32)) &&
            nla_put_u64_64bit(skb, TCA_HTB_RATE64,
cl->rate.rate_bytes_ps,
                              TCA_HTB_PAD))
                goto nla_put_failure;
        if ((cl->ceil.rate_bytes_ps >= (1ULL << 32)) &&
            nla_put_u64_64bit(skb, TCA_HTB_CEIL64,
cl->ceil.rate_bytes_ps,
                              TCA_HTB_PAD))
                goto nla_put_failure;

For TBF, in net/sched/sch_tbf.c file, tbf_dump() routine:
       if (q->rate.rate_bytes_ps >= (1ULL << 32) &&
            nla_put_u64_64bit(skb, TCA_TBF_RATE64,
q->rate.rate_bytes_ps,
                              TCA_TBF_PAD))
                goto nla_put_failure;
        if (tbf_peak_present(q) &&
            q->peak.rate_bytes_ps >= (1ULL << 32) &&
            nla_put_u64_64bit(skb, TCA_TBF_PRATE64,
q->peak.rate_bytes_ps,
                              TCA_TBF_PAD))
                goto nla_put_failure;

The last parameter used TCA_TBF_PAD, TCA_TBF_PAD are all declared
*after* those attributes.

I am trying to keep it consistent in police part. That's where my
impression is coming from.

Now for suggestion/comment, do you think is it better to add a new PAD
attribute in include/uapi/pkt_cls.h like this:
enum {
        TCA_POLICE_UNSPEC,
        TCA_POLICE_TBF,
        TCA_POLICE_RATE,
        TCA_POLICE_PEAKRATE,
        TCA_POLICE_AVRATE,
        TCA_POLICE_RESULT,
        TCA_POLICE_TM,
        TCA_POLICE_PAD,
        TCA_POLICE_RATE64,      /* <--- */
        TCA_POLICE_PEAKRATE64,  /* <--- */
        TCA_POLICE_PAD2,        /* <--- new PAD */
        __TCA_POLICE_MAX
#define TCA_POLICE_RESULT TCA_POLICE_RESULT
#};
Then use this TCA_POLICE_PAD2 as the last parameter in
nla_put_u64_64bit()? 

Thanks!
                                                                                      


