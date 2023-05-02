Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38D26F44B3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjEBNIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbjEBNIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:08:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582474EF7;
        Tue,  2 May 2023 06:08:35 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D2odX022163;
        Tue, 2 May 2023 13:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7PCr1N/EjWKnahBlpl4nl2gOWjUa3NEE8IjxvTGFxBw=;
 b=VdGyKI2j9nTO+3BdG91tF7qF7l8tPxInJeZBYgR1Sf1zulpIQqQmpZBizcR90tI/kc6s
 qM7191nEWSL6SqFA/z7vDND5mLh6/09VwMZRWADxmPCEl7Eo0lM4h1MslvjG2h2VjkYC
 H5tL26yy00yXyVEs3G7HSw7JQI0NOOGHU64JvIUKNpt0ugA7kySfWLA29s6hDVM71m/p
 CyklVkVXjBBUHsufo+EthC/MQmzIAUiF6ohrvyd5WR7KHTduwWFKtnJ8zE5mVIOPfCo2
 hVGuBGKPPNS3xsnm76pnh+pjfpZRa2KkWdO6dH9DJ5FoSOD6UR/MFrQBPwVIs60er3+p /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb1whacbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:05:57 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D1tDi018540;
        Tue, 2 May 2023 13:05:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb1whaakm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:05:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 341LC9BH005173;
        Tue, 2 May 2023 13:04:31 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6skm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:04:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D4TbW6161140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:04:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECEC320043;
        Tue,  2 May 2023 13:04:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 152E720040;
        Tue,  2 May 2023 13:04:28 +0000 (GMT)
Received: from [9.152.224.114] (unknown [9.152.224.114])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:04:28 +0000 (GMT)
Message-ID: <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
Date:   Tue, 2 May 2023 15:04:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dOx1PHet-0DbZwbqQupqZRedOeMRQ9_W
X-Proofpoint-GUID: iQ0gyAqn2SKIN_VY8tZq1VPkc8H_DRzV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=822 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305020108
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 02.05.23 um 14:54 schrieb Lorenzo Stoakes:
> On Tue, May 02, 2023 at 02:46:28PM +0200, Christian Borntraeger wrote:
>> Am 02.05.23 um 01:11 schrieb Lorenzo Stoakes:
>>> Writing to file-backed dirty-tracked mappings via GUP is inherently broken
>>> as we cannot rule out folios being cleaned and then a GUP user writing to
>>> them again and possibly marking them dirty unexpectedly.
>>>
>>> This is especially egregious for long-term mappings (as indicated by the
>>> use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
>>> we have already done in the slow path.
>>
>> Hmm, does this interfer with KVM on s390 and PCI interpretion of interrupt delivery?
>> It would no longer work with file backed memory, correct?
>>
>> See
>> arch/s390/kvm/pci.c
>>
>> kvm_s390_pci_aif_enable
>> which does have
>> FOLL_WRITE | FOLL_LONGTERM
>> to
>>
> 
> Does this memory map a dirty-tracked file? It's kind of hard to dig into where
> the address originates from without going through a ton of code. In worst case
> if the fast code doesn't find a whitelist it'll fall back to slow path which
> explicitly checks for dirty-tracked filesystem.

It does pin from whatever QEMU uses as backing for the guest.
> 
> We can reintroduce a flag to permit exceptions if this is really broken, are you
> able to test? I don't have an s390 sat around :)

Matt (Rosato on cc) probably can. In the end, it would mean having
   <memoryBacking>
     <source type="file"/>
   </memoryBacking>

In libvirt I guess.
