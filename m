Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585C66F46EF
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjEBPUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjEBPUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:20:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F3B2121;
        Tue,  2 May 2023 08:20:13 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342FEhe5029367;
        Tue, 2 May 2023 15:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V/GvdVySfSsWA0N3QEeFl+4m6R54hVIWKrdbC5AyEtQ=;
 b=eRrNF8+aSndfvKzim1IA2567TNN4PpHVuphKquobKmSvlroUjM7048+5Y8jbLSNSWK46
 cpL2EXnV/pHaCV7fOABe79Aa8ACUKi7CA6FMISKNF7vIcwmGlevnoD7lGkLwHryRoTqW
 AR/jvm2MFm2dFzHB8ft/Wbl5dVRwRSgDl+zq/7oPSJxNlsNmeVVsfBHLct8c/s2qeHck
 xQRDH3qs7gbcotfqdHY8uCZXzGKR+7W8BNRt6ab2R8ceuv9uDxXhyiAuRtBK0OGrcvLP
 ccYFfpC50AMS5iQw+uKtHhmsrAxCZqmqpFQ9q2eRx/NHagCOwtcZ4Mz3UiqOzdmDPrdP nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb50205du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 15:19:38 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342FGRkn006394;
        Tue, 2 May 2023 15:19:37 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb50205cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 15:19:37 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342DhqET006796;
        Tue, 2 May 2023 15:19:36 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3q8tv83xjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 15:19:36 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342FJW6529032994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 15:19:32 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E7C558056;
        Tue,  2 May 2023 15:19:32 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 113ED58054;
        Tue,  2 May 2023 15:19:27 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 15:19:26 +0000 (GMT)
Message-ID: <a3576685-d389-55dc-1eac-fc190f8ea792@linux.ibm.com>
Date:   Tue, 2 May 2023 11:19:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <651bfe55-6e2a-0337-d755-c8d606f5317e@linux.ibm.com>
 <203a8ed7-47fa-0830-c691-71d00517fecb@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <203a8ed7-47fa-0830-c691-71d00517fecb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vnnCp1okX_g5G3U1ACKbZ-SlmxtBdROZ
X-Proofpoint-ORIG-GUID: vBc3zQ3EyUW2J7HM9dD9YpTFTVq8PZA8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_09,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020128
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 10:57 AM, David Hildenbrand wrote:
> On 02.05.23 15:35, Matthew Rosato wrote:
>> On 5/2/23 9:04 AM, Christian Borntraeger wrote:
>>>
>>>
>>> Am 02.05.23 um 14:54 schrieb Lorenzo Stoakes:
>>>> On Tue, May 02, 2023 at 02:46:28PM +0200, Christian Borntraeger wrote:
>>>>> Am 02.05.23 um 01:11 schrieb Lorenzo Stoakes:
>>>>>> Writing to file-backed dirty-tracked mappings via GUP is inherently broken
>>>>>> as we cannot rule out folios being cleaned and then a GUP user writing to
>>>>>> them again and possibly marking them dirty unexpectedly.
>>>>>>
>>>>>> This is especially egregious for long-term mappings (as indicated by the
>>>>>> use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
>>>>>> we have already done in the slow path.
>>>>>
>>>>> Hmm, does this interfer with KVM on s390 and PCI interpretion of interrupt delivery?
>>>>> It would no longer work with file backed memory, correct?
>>>>>
>>>>> See
>>>>> arch/s390/kvm/pci.c
>>>>>
>>>>> kvm_s390_pci_aif_enable
>>>>> which does have
>>>>> FOLL_WRITE | FOLL_LONGTERM
>>>>> to
>>>>>
>>>>
>>>> Does this memory map a dirty-tracked file? It's kind of hard to dig into where
>>>> the address originates from without going through a ton of code. In worst case
>>>> if the fast code doesn't find a whitelist it'll fall back to slow path which
>>>> explicitly checks for dirty-tracked filesystem.
>>>
>>> It does pin from whatever QEMU uses as backing for the guest.
>>>>
>>>> We can reintroduce a flag to permit exceptions if this is really broken, are you
>>>> able to test? I don't have an s390 sat around :)
>>>
>>> Matt (Rosato on cc) probably can. In the end, it would mean having
>>>    <memoryBacking>
>>>      <source type="file"/>
>>>    </memoryBacking>
>>>
>>> In libvirt I guess.
>>
>> I am running with this series applied using a QEMU guest with memory-backend-file (using the above libvirt snippet) for a few different PCI device types and AEN forwarding (e.g. what is setup in kvm_s390_pci_aif_enable) is still working.
>>
> 
> That's ... unexpected. :)
> 
> Either this series doesn't work as expected or you end up using a filesystem that is still compatible. But I guess most applicable filesystems (ext4, btrfs, xfs) all have a page_mkwrite callback and should, therefore, disallow long-term pinning with this series.
> 

The memory backend file is on ext4 in my tests.  A quick trace shows that pin_user_pages_fast(FOLL_WRITE | FOLL_LONGTERM) in kvm_s390_pci_aif_enable is still returning positive implying pages are being pinned.
