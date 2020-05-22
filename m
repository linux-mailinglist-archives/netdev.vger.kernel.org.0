Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F641DE303
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgEVJ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:26:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729432AbgEVJ0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:26:30 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M93GrI108994;
        Fri, 22 May 2020 05:26:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31659tjfyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 05:26:00 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04M93QBs109888;
        Fri, 22 May 2020 05:25:59 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31659tjfxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 05:25:59 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04M9KssD002767;
        Fri, 22 May 2020 09:25:58 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 314wxpp392-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 09:25:58 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04M9PuRG44564940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 09:25:57 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA96B6E054;
        Fri, 22 May 2020 09:25:56 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 651216E04C;
        Fri, 22 May 2020 09:25:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.79.190.254])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 22 May 2020 09:25:48 +0000 (GMT)
Subject: Re: [PATCH v2 0/7] Share events between metrics
To:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
References: <20200520182011.32236-1-irogers@google.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <3e8f12d8-0c56-11e9-e557-e384210f15c1@linux.ibm.com>
Date:   Fri, 22 May 2020 14:55:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200520182011.32236-1-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-22_05:2020-05-21,2020-05-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 spamscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220070
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/20 11:50 PM, Ian Rogers wrote:
> Metric groups contain metrics. Metrics create groups of events to
> ideally be scheduled together. Often metrics refer to the same events,
> for example, a cache hit and cache miss rate. Using separate event
> groups means these metrics are multiplexed at different times and the
> counts don't sum to 100%. More multiplexing also decreases the
> accuracy of the measurement.
> 
> This change orders metrics from groups or the command line, so that
> the ones with the most events are set up first. Later metrics see if
> groups already provide their events, and reuse them if
> possible. Unnecessary events and groups are eliminated.
> 
> The option --metric-no-group is added so that metrics aren't placed in
> groups. This affects multiplexing and may increase sharing.
> 
> The option --metric-mo-merge is added and with this option the
> existing grouping behavior is preserved.
> 
> Using skylakex metrics I ran the following shell code to count the
> number of events for each metric group (this ignores metric groups
> with a single metric, and one of the duplicated TopdownL1 and
> TopDownL1 groups):
> 
> for i in all Branches BrMispredicts Cache_Misses FLOPS Instruction_Type Memory_BW Pipeline Power SMT Summary TopdownL1 TopdownL1_SMT
> do
>   echo Metric group: $i
>   echo -n " - No merging (old default, now --metric-no-merge): "
>   /tmp/perf/perf stat -a --metric-no-merge -M $i sleep 1 2>&1 | grep -v "^ *#" | egrep " +[0-9,.]+ [^s]" | wc -l
>   echo -n " - Merging over metrics (new default)             : "
>   /tmp/perf/perf stat -a -M $i sleep 1 2>&1 | grep -v "^ *#" | egrep " +[0-9,.]+ [^s]"|wc -l
>   echo -n " - No event groups and merging (--metric-no-group): "
>   /tmp/perf/perf stat -a --metric-no-group -M $i sleep 1 2>&1 | grep -v "^ *#" | egrep " +[0-9,.]+ [^s]"|wc -l
> done
> 
> Metric group: all
>  - No merging (old default, now --metric-no-merge): 193
>  - Merging over metrics (new default)             : 142
>  - No event groups and merging (--metric-no-group): 84
> Metric group: Branches
>  - No merging (old default, now --metric-no-merge): 8
>  - Merging over metrics (new default)             : 8
>  - No event groups and merging (--metric-no-group): 4
> Metric group: BrMispredicts
>  - No merging (old default, now --metric-no-merge): 11
>  - Merging over metrics (new default)             : 11
>  - No event groups and merging (--metric-no-group): 10
> Metric group: Cache_Misses
>  - No merging (old default, now --metric-no-merge): 11
>  - Merging over metrics (new default)             : 9
>  - No event groups and merging (--metric-no-group): 6
> Metric group: FLOPS
>  - No merging (old default, now --metric-no-merge): 18
>  - Merging over metrics (new default)             : 10
>  - No event groups and merging (--metric-no-group): 10
> Metric group: Instruction_Type
>  - No merging (old default, now --metric-no-merge): 6
>  - Merging over metrics (new default)             : 6
>  - No event groups and merging (--metric-no-group): 4
> Metric group: Pipeline
>  - No merging (old default, now --metric-no-merge): 6
>  - Merging over metrics (new default)             : 6
>  - No event groups and merging (--metric-no-group): 5
> Metric group: Power
>  - No merging (old default, now --metric-no-merge): 16
>  - Merging over metrics (new default)             : 16
>  - No event groups and merging (--metric-no-group): 10
> Metric group: SMT
>  - No merging (old default, now --metric-no-merge): 11
>  - Merging over metrics (new default)             : 8
>  - No event groups and merging (--metric-no-group): 7
> Metric group: Summary
>  - No merging (old default, now --metric-no-merge): 19
>  - Merging over metrics (new default)             : 17
>  - No event groups and merging (--metric-no-group): 17
> Metric group: TopdownL1
>  - No merging (old default, now --metric-no-merge): 16
>  - Merging over metrics (new default)             : 7
>  - No event groups and merging (--metric-no-group): 7
> Metric group: TopdownL1_SMT
>  - No merging (old default, now --metric-no-merge): 24
>  - Merging over metrics (new default)             : 7
>  - No event groups and merging (--metric-no-group): 7
> 
> There are 5 out of 12 metric groups where no events are shared, such
> as Power, however, disabling grouping of events always reduces the
> number of events.
> 
> The result for Memory_BW needs explanation:
> 
> Metric group: Memory_BW
>  - No merging (old default, now --metric-no-merge): 9
>  - Merging over metrics (new default)             : 5
>  - No event groups and merging (--metric-no-group): 11
> 
> Both with and without merging the groups fail to be set up and so the
> event counts here are for broken metrics. The --metric-no-group number
> is accurate as all the events are scheduled. Ideally a constraint
> would be added for these metrics in the json code to avoid grouping.
> 
> v2. rebases on kernel/git/acme/linux.git branch tmp.perf/core, fixes a
> missing comma with metric lists (reported-by Jiri Olsa
> <jolsa@redhat.com>) and adds early returns to metricgroup__add_metric
> (suggested-by Jiri Olsa).
> 
> v1. was prepared on kernel/git/acme/linux.git branch tmp.perf/core
> 
> Compared to RFC v3: fix a bug where unnecessary commas were passed to
> parse-events and were echoed. Fix a bug where the same event could be
> matched more than once with --metric-no-group, causing there to be
> events missing.
> https://lore.kernel.org/lkml/20200508053629.210324-1-irogers@google.com/
> 
> Ian Rogers (7):
>   perf metricgroup: Always place duration_time last
>   perf metricgroup: Use early return in add_metric
>   perf metricgroup: Delay events string creation
>   perf metricgroup: Order event groups by size
>   perf metricgroup: Remove duped metric group events
>   perf metricgroup: Add options to not group or merge
>   perf metricgroup: Remove unnecessary ',' from events
> 

Reviewd-By: Kajol Jain <kjain@linux.ibm.com>
Tested-By: Kajol Jain <kjain@linux.ibm.com> ( Tested it to see behavior with some metric groups in both x86 and Power machine)

Thanks,
Kajol Jain

>  tools/perf/Documentation/perf-stat.txt |  19 ++
>  tools/perf/builtin-stat.c              |  11 +-
>  tools/perf/util/metricgroup.c          | 239 ++++++++++++++++++-------
>  tools/perf/util/metricgroup.h          |   6 +-
>  tools/perf/util/stat.h                 |   2 +
>  5 files changed, 207 insertions(+), 70 deletions(-)
> 
