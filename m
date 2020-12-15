Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6032DAFCB
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgLOPJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:09:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729611AbgLOPJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 10:09:45 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BFF2WU7020881;
        Tue, 15 Dec 2020 10:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=r0PBX5LPJBsbD47eMoyZlxW9UV/WvCEQWeyIO+CX+2Y=;
 b=RfZBLsxDUZDEO6ZJeABHZ0p/w4tkuEAulFpZaKG8DWJazVK1KqHYL2rAtSjfxdVJH/r6
 Qcsk4K+Y8IoIWGdJKokq14vWmj8JFUQg8FJ1nTBHYSzzTgjOJ5q2ORZV4E4nmHQKAGSW
 5daFL8i0DH6VFJUPgqHF2ijpUiyYL6+mqJy9c5E9VM+0EkaVZUxDJPMc88P5079VFKql
 2AnafpF2fkHyadRQr+Ne0c7C2Ft9ritzguQg9VJVCn1qB2kkp+k0UTiHda7GC0/KMN8+
 rIz6lQT+nEVWPZGsSeCbMSvxlG3m49Yk/yM15DUK2OnPnO+PMB5zSGb6qDbCq5fGQEUi Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ewkymapm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 10:08:22 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BFF3RBR029189;
        Tue, 15 Dec 2020 10:08:21 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ewkymant-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 10:08:21 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BFF2puO006607;
        Tue, 15 Dec 2020 15:08:19 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 35d525ruad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 15:08:19 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BFF8Ipd24445244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 15:08:18 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C9A3BE04F;
        Tue, 15 Dec 2020 15:08:18 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80185BE051;
        Tue, 15 Dec 2020 15:08:14 +0000 (GMT)
Received: from li-24c3614c-2adc-11b2-a85c-85f334518bdb.ibm.com (unknown [9.80.199.149])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Dec 2020 15:08:14 +0000 (GMT)
Date:   Tue, 15 Dec 2020 09:08:12 -0600
From:   "Paul A. Clarke" <pc@us.ibm.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH 0/7] Share events between metrics
Message-ID: <20201215150812.GA38786@li-24c3614c-2adc-11b2-a85c-85f334518bdb.ibm.com>
References: <20200507081436.49071-1-irogers@google.com>
 <20200507174835.GB3538@tassilo.jf.intel.com>
 <CAP-5=fUdoGJs+yViq3BOcJa7YyF53AD9RGQm8aRW72nMH0sKDA@mail.gmail.com>
 <20200507214652.GC3538@tassilo.jf.intel.com>
 <CAP-5=fV2eNAt0LLHYXeLMR6GZi_oGZyzz8psErNkbahLQs-VLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fV2eNAt0LLHYXeLMR6GZi_oGZyzz8psErNkbahLQs-VLQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 10:43:43PM -0700, Ian Rogers wrote:
> On Thu, May 7, 2020 at 2:47 PM Andi Kleen <ak@linux.intel.com> wrote:
> >
> > > > - without this change events within a metric may get scheduled
> > > >   together, after they may appear as part of a larger group and be
> > > >   multiplexed at different times, lowering accuracy - however, less
> > > >   multiplexing may compensate for this.

Does mutiplexing somewhat related events at different times actually reduce
accuracy, or is it just more likely to give that appearance?

It seems that perf measurements are only useful if the workload is in a
fairly steady state.  If there is some wobbling, then measuring at the
same time is more accurate for the periods where the events are being
measured simultaneously, but may be far off for when they are not being
measured at all.  Spreading them out over a longer duration may actually
increase accuracy by sampling over more varied intervals.

Or, is the concern more about trying to time-slice the results in a 
fairly granular way and expecting accurate results then?

(Or, maybe my ignorance is showing again.  :-)

PC
