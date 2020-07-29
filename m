Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D915F232146
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 17:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgG2PMT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 11:12:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbgG2PMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 11:12:18 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TEjuAP092815;
        Wed, 29 Jul 2020 11:11:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32k9quma4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 11:11:41 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06TEkdNv095864;
        Wed, 29 Jul 2020 11:11:40 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32k9quma3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 11:11:40 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06TF57dH000488;
        Wed, 29 Jul 2020 15:11:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 32gcr0k5um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 15:11:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06TFBZN832309758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 15:11:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFCE34C040;
        Wed, 29 Jul 2020 15:11:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD7AE4C058;
        Wed, 29 Jul 2020 15:11:29 +0000 (GMT)
Received: from [9.85.87.197] (unknown [9.85.87.197])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 29 Jul 2020 15:11:29 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 1/5] perf record: Set PERF_RECORD_PERIOD if attr->freq
 is set.
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
In-Reply-To: <20200728160309.GC374564@kernel.org>
Date:   Wed, 29 Jul 2020 20:41:27 +0530
Cc:     Jiri Olsa <jolsa@redhat.com>, Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        David Sharp <dhsharp@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C534B006-3EF4-4DAB-B3D8-2944257000AC@linux.vnet.ibm.com>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-2-irogers@google.com> <20200728154347.GB1319041@krava>
 <20200728160309.GC374564@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_10:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 28-Jul-2020, at 9:33 PM, Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> Em Tue, Jul 28, 2020 at 05:43:47PM +0200, Jiri Olsa escreveu:
>> On Tue, Jul 28, 2020 at 01:57:30AM -0700, Ian Rogers wrote:
>>> From: David Sharp <dhsharp@google.com>
>>> 
>>> evsel__config() would only set PERF_RECORD_PERIOD if it set attr->freq
>>> from perf record options. When it is set by libpfm events, it would not
>>> get set. This changes evsel__config to see if attr->freq is set outside of
>>> whether or not it changes attr->freq itself.
>>> 
>>> Signed-off-by: David Sharp <dhsharp@google.com>
>>> Signed-off-by: Ian Rogers <irogers@google.com>
>> 
>> Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> So, somebody else complained that its not PERF_RECORD_PERIOD (there is
> no such thing) that is being set, its PERF_SAMPLE_PERIOD.

Hi Arnaldo

Thanks for adding in that correction.

Athira
> 
> Since you acked it I merged it now, with that correction,
> 
> - Arnaldo
> 
>> thanks,
>> jirka
>> 
>>> ---
>>> tools/perf/util/evsel.c | 7 ++++++-
>>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>> 
>>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>>> index ef802f6d40c1..811f538f7d77 100644
>>> --- a/tools/perf/util/evsel.c
>>> +++ b/tools/perf/util/evsel.c
>>> @@ -979,13 +979,18 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
>>> 	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
>>> 				     opts->user_interval != ULLONG_MAX)) {
>>> 		if (opts->freq) {
>>> -			evsel__set_sample_bit(evsel, PERIOD);
>>> 			attr->freq		= 1;
>>> 			attr->sample_freq	= opts->freq;
>>> 		} else {
>>> 			attr->sample_period = opts->default_interval;
>>> 		}
>>> 	}
>>> +	/*
>>> +	 * If attr->freq was set (here or earlier), ask for period
>>> +	 * to be sampled.
>>> +	 */
>>> +	if (attr->freq)
>>> +		evsel__set_sample_bit(evsel, PERIOD);
>>> 
>>> 	if (opts->no_samples)
>>> 		attr->sample_freq = 0;
>>> -- 
>>> 2.28.0.163.g6104cc2f0b6-goog
>>> 
>> 
> 
> -- 
> 
> - Arnaldo

