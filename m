Return-Path: <netdev+bounces-147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E116F571F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3C791C20E90
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAE4BA55;
	Wed,  3 May 2023 11:26:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1A146AC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:26:37 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DEC44A1;
	Wed,  3 May 2023 04:26:34 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343BKDmg014939;
	Wed, 3 May 2023 11:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tN/6/ojBDjGfUZIYYy6VieH+LClC7elDYOoimNAuvGQ=;
 b=bmAY8L1QXG+5DBuyCXVsv6/uVGjos0QGyomsZZgAi0qqsFRJSIseQR4WZwEiXB0JGY9P
 lrWBsqdrHu7Qa79Ge501sDNP1KS2Sm5hOUl5ufWTPTyeU0mNZWwZ+KfhqUTTnbi/U0D4
 6ESjBvrG1Jyqt2Sm41Yc9EXm0CFZiUni7857dkJIyFTJOeVOdNWGki6Sbh+aw90JAnK2
 heKoI0JRfG2+Ic2k3jP77siFBYPwCVMBvb/3V1PLbBpVyqH/ISNSMhm9VILLMVJwino9
 PcVoKHJMaGHez23EqHEeCP4C0ETOC/BASBIaq1Tmitif0JPh92G0Jf9SC21YFn295D8Z ew== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbpn503yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 11:25:19 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 343BOED1028588;
	Wed, 3 May 2023 11:25:17 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbpn503w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 11:25:17 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
	by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3438xskL009972;
	Wed, 3 May 2023 11:25:13 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
	by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3q8tv8148w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 11:25:13 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343BPAQC37355840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 May 2023 11:25:10 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D06258060;
	Wed,  3 May 2023 11:25:10 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB1125804E;
	Wed,  3 May 2023 11:25:03 +0000 (GMT)
Received: from [9.160.35.135] (unknown [9.160.35.135])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 May 2023 11:25:03 +0000 (GMT)
Message-ID: <80e3b8ee-c16d-062f-f483-06e21282e59c@linux.ibm.com>
Date: Wed, 3 May 2023 07:25:03 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes
 <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila
 <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Peter Xu <peterx@redhat.com>, "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <20d078c5-4ee6-18dc-d3a5-d76b6a68f64e@linux.ibm.com>
 <1b34e9a4-83c0-2f44-1457-dd8800b9287a@redhat.com>
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <1b34e9a4-83c0-2f44-1457-dd8800b9287a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HOrfLyMo8HgxagrM7LF2KsfFcEL250P9
X-Proofpoint-ORIG-GUID: LlOt6N30KORomTgFjYXhnYnyMpIYAh6q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_06,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=552 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030093
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/3/23 3:08 AM, David Hildenbrand wrote:
> On 03.05.23 02:31, Matthew Rosato wrote:
>> On 5/2/23 6:51 PM, Lorenzo Stoakes wrote:
>>> Writing to file-backed mappings which require folio dirty tracking using
>>> GUP is a fundamentally broken operation, as kernel write access to GUP
>>> mappings do not adhere to the semantics expected by a file system.
>>>
>>> A GUP caller uses the direct mapping to access the folio, which does not
>>> cause write notify to trigger, nor does it enforce that the caller marks
>>> the folio dirty.
>>>
>>> The problem arises when, after an initial write to the folio, writeback
>>> results in the folio being cleaned and then the caller, via the GUP
>>> interface, writes to the folio again.
>>>
>>> As a result of the use of this secondary, direct, mapping to the folio no
>>> write notify will occur, and if the caller does mark the folio dirty, this
>>> will be done so unexpectedly.
>>>
>>> For example, consider the following scenario:-
>>>
>>> 1. A folio is written to via GUP which write-faults the memory, notifying
>>>     the file system and dirtying the folio.
>>> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>>>     the PTE being marked read-only.
>>> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>>>     direct mapping.
>>> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>>>     (though it does not have to).
>>>
>>> This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
>>> pin_user_pages_fast_only() does not exist, we can rely on a slightly
>>> imperfect whitelisting in the PUP-fast case and fall back to the slow case
>>> should this fail.
>>>
>>> v8:
>>> - Fixed typo writeable -> writable.
>>> - Fixed bug in writable_file_mapping_allowed() - must check combination of
>>>    FOLL_PIN AND FOLL_LONGTERM not either/or.
>>> - Updated vma_needs_dirty_tracking() to include write/shared to account for
>>>    MAP_PRIVATE mappings.
>>> - Move to open-coding the checks in folio_pin_allowed() so we can
>>>    READ_ONCE() the mapping and avoid unexpected compiler loads. Rename to
>>>    account for fact we now check flags here.
>>> - Disallow mapping == NULL or mapping & PAGE_MAPPING_FLAGS other than
>>>    anon. Defer to slow path.
>>> - Perform GUP-fast check _after_ the lowest page table level is confirmed to
>>>    be stable.
>>> - Updated comments and commit message for final patch as per Jason's
>>>    suggestions.
>>
>> Tested again on s390 using QEMU with a memory backend file (on ext4) and vfio-pci -- This time both vfio_pin_pages_remote (which will call pin_user_pages_remote(flags | FOLL_LONGTERM)) and the pin_user_pages_fast(FOLL_WRITE | FOLL_LONGTERM) in kvm_s390_pci_aif_enable are being allowed (e.g. returning positive pin count)
> 
> At least it's consistent now ;) And it might be working as expected ...
> 
> In v7:
> * pin_user_pages_fast() succeeded
> * vfio_pin_pages_remote() failed
> 
> But also in v7:
> * GUP-fast allows pinning (anonymous) pages in MAP_PRIVATE file
>   mappings
> * Ordinary GUP allows pinning pages in MAP_PRIVATE file mappings
> 
> In v8:
> * pin_user_pages_fast() succeeds
> * vfio_pin_pages_remote() succeeds
> 
> But also in v8:
> * GUP-fast allows pinning (anonymous) pages in MAP_PRIVATE file
>   mappings
> * Ordinary GUP allows pinning pages in MAP_PRIVATE file mappings
> 
> 
> I have to speculate, but ... could it be that you are using a private mapping?
> 
> In QEMU, unfortunately, the default for memory-backend-file is "share=off" (private) ... for memory-backend-memfd it is "share=on" (shared). The default is stupid ...
> 
> If you invoke QEMU manually, can you specify "share=on" for the memory-backend-file? I thought libvirt would always default to "share=on" for file mappings (everything else doesn't make much sense) ... but you might have to specify
>     <access mode="shared"/>
> in addition to
>     <source type="file"/>
> 

Ah, there we go.  Yes, I was using the default of share=off.  When I instead specify share=on, now the pins will fail in both cases.

