Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33C36F46F7
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbjEBPV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbjEBPVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:21:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9A930FA;
        Tue,  2 May 2023 08:21:13 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342F6tap025185;
        Tue, 2 May 2023 15:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hj/s3lR6nyUy7ypNUNRgynKQ3Lb4T+V5ldc2OLzY79g=;
 b=n0wSkVDp2ncJdEUX4yvqIhZ3wk3W9ANXK1sSt0SqsFg5rur8tzwQFyagFz5f5fW+Wo7S
 E96G1QcuZ2/fBCiG44qbmvNBD3WCZwa2dJDoNdunzRt2CmFItiEFDmTzr3OIK5FDxojp
 9nuFk1Ta/Tjec50WIQaII8yHRXvvxYXHLVQaRyTW5izOToLr/fIR4JE10aq3wm3hg6Sn
 qrA490r03JbeDtArVhHiEEBG+TtpIjKkwURBo4zC4K497oaPBuAMQT4+WMd6N1wvbdgM
 Q3rBjMRZLgxK+SehqplsYG+31Zwe7h6D0da4j/vIHI4DATOYuLQAlwmx2orw68HqV4rr Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s3dfc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 15:20:34 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342F7LOY027877;
        Tue, 2 May 2023 15:20:33 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s3dfar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 15:20:33 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342DOa5S005193;
        Tue, 2 May 2023 15:20:31 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3q8tv83wsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 15:20:31 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342FKSsB31195544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 15:20:28 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB10D58062;
        Tue,  2 May 2023 15:20:27 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C6A15803F;
        Tue,  2 May 2023 15:20:23 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 15:20:23 +0000 (GMT)
Message-ID: <e59f14d0-4fbf-b8e4-bdf0-19eac3db540f@linux.ibm.com>
Date:   Tue, 2 May 2023 11:20:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
References: <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1d4c9258-9423-7411-e722-8f6865b18886@linux.ibm.com>
 <1f3231c0-34b2-1e78-0bf0-f32d5b67811d@redhat.com>
 <25b7aa40-fad0-4886-90b2-c5d68d75d28b@lucifer.local>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <25b7aa40-fad0-4886-90b2-c5d68d75d28b@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rfLAjTTulw13fKXOtGjGnm_aAOkuBqYu
X-Proofpoint-GUID: oVBVbBc-uzNloCzKkffN5Y7ublV-eC2P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_09,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=611 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305020128
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 11:19 AM, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 05:09:06PM +0200, David Hildenbrand wrote:
>> On 02.05.23 15:56, Matthew Rosato wrote:
>>> On 5/2/23 9:50 AM, Jason Gunthorpe wrote:
>>>> On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
>>>>>> Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
>>>>>
>>>>> Okay, so IIRC we'll fail starting the domain early, that's good. And if we
>>>>> pin all guest memory (instead of small pieces dynamically), there is little
>>>>> existing use for file-backed RAM in such zPCI configurations (because memory
>>>>> cannot be reclaimed either way if it's all pinned), so likely there are no
>>>>> real existing users.
>>>>
>>>> Right, this is VFIO, the physical HW can't tolerate not having pinned
>>>> memory, so something somewhere is always pinning it.
>>>
>>> I might have mis-explained above.
>>>
>>> With iommufd nesting, we will pin everything upfront as a starting point.
>>>
>>> The current usage of vfio type1 iommu for s390 does not pin the entirety of guest memory upfront, it happens as guest RPCITs occur / type1 mappings are made.
>>
>> ... so, after the domain started successfully on the libvirt/QEMU side ? :/
>>
>> It would be great to confirm that. There might be a BUG in patch #2 (see my
>> reply to patch #2) that might not allow you to reproduce it right now.
>>
> 
> Yes apologies - thank you VERY much for doing this Matthew, but apologies, I
> made rather a clanger in patch 2 which would mean fast patch degrading to slow
> path would pass even for file-backed.
> 
> Will respin a v7 + cc you on that, if you could be so kind as to test that?
> 

Sure, will do!

