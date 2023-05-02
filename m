Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67C86F4676
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbjEBO50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjEBO5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:57:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D95213B;
        Tue,  2 May 2023 07:57:23 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342Ee516012859;
        Tue, 2 May 2023 14:54:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=32y/nZeIEZmOi40iSqF/tJSaM/6yk3pyClxTBL1CuRM=;
 b=pzEkjajBsqQK2aUX4AyPJSGIOPFiAn65gKlCk/dI1aTd9VrKwFHbRV9BZ+5JV9BIYe9c
 TP5qassSUSpB5UHJ8PgfOd+IQpT/k5BctPPOPd+F3r7/cW51wWM+xdKpfqCaSFizH/0l
 dt4+trmvVscrWQnQbqHeZb7T1Oa8cWzSkRnY8kvKz4zEkeD31h8xzy8cklCk1Rqqex4A
 2BCpqLQODg+LWaFcdxR7tcdJ5VJL6KHipFlBUh8A+UCsiJLRTDhKj/DzJs2ENZPhVg4L
 Y1bX9wfihMhkVbTTh/eYJi/vA3ZPyKkQe0JdxY/TIFCghNBCM71NTm0bU6wurcJCr+9D SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb43shfdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 14:54:50 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342EomgO020546;
        Tue, 2 May 2023 14:54:48 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb43shf8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 14:54:48 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342DWDbf011286;
        Tue, 2 May 2023 14:54:44 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3q8tv7uskc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 14:54:44 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342Ese1H23920954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 14:54:40 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76AAD5804E;
        Tue,  2 May 2023 14:54:40 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDAD958056;
        Tue,  2 May 2023 14:54:35 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 14:54:35 +0000 (GMT)
Message-ID: <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
Date:   Tue, 2 May 2023 10:54:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
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
        "Theodore Ts'o" <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
References: <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
 <ZFEYblElll3pWtn5@nvidia.com>
 <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CxJFWMTr1AwlmvE516RFOxxqp85_cQ7r
X-Proofpoint-ORIG-GUID: uXjpuXEqJyPIOFcBwIU_BPTS0bXnzkZb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_09,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=842 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020124
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 10:15 AM, David Hildenbrand wrote:
> On 02.05.23 16:04, Jason Gunthorpe wrote:
>> On Tue, May 02, 2023 at 03:57:30PM +0200, David Hildenbrand wrote:
>>> On 02.05.23 15:50, Jason Gunthorpe wrote:
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
>>>>
>>>> Which, again, makes it weird/wrong that this KVM code is pinning it
>>>> again :\
>>>
>>> IIUC, that pinning is not for ordinary IOMMU / KVM memory access. It's for
>>> passthrough of (adapter) interrupts.
>>>
>>> I have to speculate, but I guess for hardware to forward interrupts to the
>>> VM, it has to pin the special guest memory page that will receive the
>>> indications, to then configure (interrupt) hardware to target the interrupt
>>> indications to that special guest page (using a host physical address).
>>
>> Either the emulated access is "CPU" based happening through the KVM
>> page table so it should use mmu_notifier locking.
>>
>> Or it is "DMA" and should go through an IOVA through iommufd pinning
>> and locking.
>>
>> There is no other ground, nothing in KVM should be inventing its own
>> access methodology.
> 
> I might be wrong, but this seems to be a bit different.
> 
> It cannot tolerate page faults (needs a host physical address), so memory notifiers don't really apply. (as a side note, KVM on s390x does not use mmu notifiers as we know them)

The host physical address is one shared between underlying firmware and the host kvm.  Either might make changes to the referenced page and then issue an alert to the guest via a mechanism called GISA, giving impetus to the guest to look at that page and process the event.  As you say, firmware can't tolerate the page being unavailable; it's expecting that once we feed it that location it's always available until we remove it (kvm_s390_pci_aif_disable).

> 
> It's kind-of like DMA, but it's not really DMA.  It's the CPU delivering interrupts for a specific device. So we're configuring the interrupt controller I guess to target a guest memory page.
> 
> But I have way too little knowledge about zPCI and the code in question here. And if it could be converted to iommufd (and if that's really the right mechanism to use here).
> 	
> Hopefully Matthew knows the details and if this really needs to be special :)

I think I need to have a look at mmu_notifiers to understand that better, but in the end firmware still needs a reliable page to deliver events to.
 

