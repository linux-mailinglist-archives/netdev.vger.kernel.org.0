Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC06F456C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbjEBNqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbjEBNqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:46:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360195B87;
        Tue,  2 May 2023 06:46:26 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342Dd2Q0007879;
        Tue, 2 May 2023 13:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=px5fz1lhMlci981JXGzeSbNgqRiYbjczd1JHXYOP/ZA=;
 b=aPR9yx6JmDE6fk+wCxcRdlp3bZBP51g3NhfgmWe2LPsTOzsmnW2AilKJKtdlX3Le77cA
 5BYqSDYgWG/PaR1lcq13EvBHavNlMaEPoRXT0fMjEJYFz332zpFE8R5eIlMKNVgcD4ZX
 gtfnIHaWNeQyIshdg4RZ5o/IIa2/SyYaMekp/EXJ6slAkPog3aULrlur++9fhwpNV/43
 Xjx+DvWbECrUpX2McHZf7iz/4E/naSDZK6c8nKKA2kUWzPhn9bMyMpOOIbeICxMV9RFE
 /ufz6zGpEPikF2CtL50YPCZ7qOwTUA4tgjUsLbQcnFMQ4EJnuTeKHPvyJoXwiVyJV9dU ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb36uh6ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:43:55 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342DdUY7009344;
        Tue, 2 May 2023 13:43:54 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb36uh6e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:43:54 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342DL1Zc026692;
        Tue, 2 May 2023 13:43:52 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3q8tv93fpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:43:52 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342DhnCB14156340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:43:50 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 980DA5804E;
        Tue,  2 May 2023 13:43:49 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ADF75803F;
        Tue,  2 May 2023 13:43:45 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:43:44 +0000 (GMT)
Message-ID: <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
Date:   Tue, 2 May 2023 09:43:44 -0400
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
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EDlDpG77ZR5IQW6YD5-hC-0XpAeIHDNl
X-Proofpoint-GUID: fTJcjKwNHb_cwPrukmedXipjMdSd6keM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020115
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 9:39 AM, David Hildenbrand wrote:
> On 02.05.23 15:36, Jason Gunthorpe wrote:
>> On Tue, May 02, 2023 at 03:28:40PM +0200, David Hildenbrand wrote:
>>> On 02.05.23 15:10, Jason Gunthorpe wrote:
>>>> On Tue, May 02, 2023 at 03:04:27PM +0200, Christian Borntraeger wrote:
>>>> \> > We can reintroduce a flag to permit exceptions if this is really broken, are you
>>>>>> able to test? I don't have an s390 sat around :)
>>>>>
>>>>> Matt (Rosato on cc) probably can. In the end, it would mean having
>>>>>     <memoryBacking>
>>>>>       <source type="file"/>
>>>>>     </memoryBacking>
>>>>
>>>> This s390 code is the least of the problems, after this series VFIO
>>>> won't startup at all with this configuration.
>>>
>>> Good question if the domain would fail to start. I recall that IOMMUs for
>>> zPCI are special on s390x. [1]
>>
>> Not upstream they aren't.
>>
>>> Well, zPCI is special. I cannot immediately tell when we would trigger
>>> long-term pinning.
>>
>> zPCI uses the standard IOMMU stuff, so it uses a normal VFIO container
>> and the normal pin_user_pages() path.
> 
> 
> @Christian, Matthew: would we pin all guest memory when starting the domain (IIRC, like on x86-64) and fail early, or only when the guest issues rpcit instructions to map individual pages?
> 

Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.

However, per Jason's prior suggestion, the initial implementation for s390 nesting via iommufd will pin all of guest memory when starting the domain.  I have something already working via iommufd built on top of the nesting infrastructure patches and QEMU iommufd series that are floating around; needs some cleanup, hoping to send an RFC in the coming weeks.  I can CC you if you'd like.
