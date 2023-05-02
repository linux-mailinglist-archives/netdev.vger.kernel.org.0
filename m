Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946526F4968
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbjEBSAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjEBSAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:00:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF0B19A5;
        Tue,  2 May 2023 10:59:59 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342HtCfP018285;
        Tue, 2 May 2023 17:59:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tKOcmURnemGD3X9MwKKbA1wBzSOBFjask02rGsHEkFI=;
 b=pGW42QcU4OvHnRCzuZyz+bp8b0W5Bpprkj+RsYymzNlLzXNDg/gWYkLPY7NhtKi4FA0B
 zHqLzMOPGJfyXTlOBipxG+bC1ot2mXLX87mF76LlXelLTOfgjhykuI8RWrHNAI2rSoOp
 OCuEIUa38azH84QaUER6qhyDyqyWKrkcwjwsj7aMsYFV8+1c8LmKHcKg9YVXFT0VkM41
 8OMzxtH0w/tfs/MZV/h2i9i9HyYgG6EV4T1bfswB0WbCYOaOs7dxviKKGR0IWQCLfH8p
 L9n6UBCmEikHSdghZrXsEkVnoTqJVKAMe64P5f2cXUGp7trdHWfzA2TnEhEg01mvvPsK bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb7bar2y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 17:59:23 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342HwaH5031083;
        Tue, 2 May 2023 17:59:22 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb7bar2wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 17:59:22 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342GGd9D009976;
        Tue, 2 May 2023 17:59:20 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3q8tv7vn30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 17:59:20 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342HxHXd42664280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 17:59:17 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0286D58056;
        Tue,  2 May 2023 17:59:17 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6800558060;
        Tue,  2 May 2023 17:59:10 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 17:59:10 +0000 (GMT)
Message-ID: <2d023b34-643f-33f7-af5e-7e6dce2eed46@linux.ibm.com>
Date:   Tue, 2 May 2023 13:59:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
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
        "Theodore Ts'o" <tytso@mit.edu>
References: <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com> <ZFEtKe/XcnC++ACZ@x1n>
 <ZFEt/ot6VKOgW1mT@nvidia.com>
 <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
 <ZFE07gfyp0aTsSmL@nvidia.com>
 <1f29fe90-1482-7435-96bd-687e991a4e5b@redhat.com>
 <ZFE4A7HbM9vGhACI@nvidia.com>
 <6681789f-f70e-820d-a185-a17e638dfa53@redhat.com>
 <ZFFMXswUwsQ6lRi5@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <ZFFMXswUwsQ6lRi5@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SfvWhzu5WAhhXbJnJtyFvuzAckGDG6lf
X-Proofpoint-ORIG-GUID: uR7mojU5kWzIiwCQMRwlrZc2zx-Sg8rX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_10,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305020151
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 1:46 PM, Jason Gunthorpe wrote:
> On Tue, May 02, 2023 at 06:32:23PM +0200, David Hildenbrand wrote:
>> On 02.05.23 18:19, Jason Gunthorpe wrote:
>>> On Tue, May 02, 2023 at 06:12:39PM +0200, David Hildenbrand wrote:
>>>
>>>>> It missses the general architectural point why we have all these
>>>>> shootdown mechanims in other places - plares are not supposed to make
>>>>> these kinds of assumptions. When the userspace unplugs the memory from
>>>>> KVM or unmaps it from VFIO it is not still being accessed by the
>>>>> kernel.
>>>>
>>>> Yes. Like having memory in a vfio iommu v1 and doing the same (mremap,
>>>> munmap, MADV_DONTNEED, ...). Which is why we disable MADV_DONTNEED (e.g.,
>>>> virtio-balloon) in QEMU with vfio.
>>>
>>> That is different, VFIO has it's own contract how it consumes the
>>> memory from the MM and VFIO breaks all this stuff.
>>>
>>> But when you tell VFIO to unmap the memory it doesn't keep accessing
>>> it in the background like this does.
>>
>> To me, this is similar to when QEMU (user space) triggers
>> KVM_S390_ZPCIOP_DEREG_AEN, to tell KVM to disable AIF and stop using the
>> page (1) When triggered by the guest explicitly (2) when resetting the VM
>> (3) when resetting the virtual PCI device / configuration.
>>
>> Interrupt gets unregistered from HW (which stops using the page), the pages
>> get unpinned. Pages get no longer used.
>>
>> I guess I am still missing (a) how this is fundamentally different (b) how
>> it could be done differently.
> 
> It uses an address that is already scoped within the KVM memory map
> and uses KVM's gpa_to_gfn() to translate it to some pinnable page
> 
> It is not some independent thing like VFIO, it is explicitly scoped
> within the existing KVM structure and it does not follow any mutations
> that are done to the gpa map through the usual KVM APIs.
> 
>> I'd really be happy to learn how a better approach would look like that does
>> not use longterm pinnings.
> 
> Sounds like the FW sadly needs pinnings. This is why I said it looks
> like DMA. If possible it would be better to get the pinning through
> VFIO, eg as a mdev

Hrm, these are today handled as a vfio-pci device (e.g. no mdev) so that would be a pretty significant change.

> 
> Otherwise, it would have been cleaner if this was divorced from KVM
> and took in a direct user pointer, then maybe you could make the
> argument is its own thing with its own lifetime rules. (then you are
> kind of making your own mdev)

Problem there is that firmware needs both the location (where to indicate the event) and the identity of the KVM instance (what guest to ship the GISA alert to) so I don't think we can completely divorce them.

> 
> Or, perhaps, this is really part of some radical "irqfd" that we've
> been on and off talking about specifically to get this area of
> interrupt bypass uAPI'd properly..

I investigated that at one point and could not seem to get it to fit; I'll have another look there.



