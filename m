Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA66F4609
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbjEBOZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbjEBOZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:25:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEDDE5E;
        Tue,  2 May 2023 07:25:01 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342DbOFC015278;
        Tue, 2 May 2023 13:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5uhTulMAzS5MJZnI8I3gWak2PsaOpEGh5VqMTZIowK4=;
 b=Ku71v9XWDnZDodXg6j7zdxfKhTydxhO+20aX9ym18IgYV4PsQcVsI0+DVIAo4vbpcvJm
 jsptSOeo8HgvzAILqJskaDok5xNvqdTb5pUasLDLm9CGhYw++yRuSA9XHSAvdqMuizuk
 z5oumnKE2HT2C1PIl3dzHJeMhVEe8p/zIeuCw7cgprCUsh+e6f4u9TMcU/I5Quq3uWuA
 HMtOD7TRyHsp/VSLjvEaHgbYX3EQmrjS+gY7znEJF/CJXeo9JaiEiBRpIT1Nq43hH7Ia
 cmHGxmQmJL71JZ5dA0K2fKzT/g9gzS8OsXjggmQzjQvqlBcPwyt3GUOK+dOpsabmIP/v fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s3a33n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:40:56 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342DbMnK015082;
        Tue, 2 May 2023 13:39:46 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s3a07q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:39:46 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342BZUhc011904;
        Tue, 2 May 2023 13:38:37 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3q8tv7qhcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:38:37 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342DcYIE19268126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:38:34 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08C5E5804E;
        Tue,  2 May 2023 13:38:34 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 655BF5803F;
        Tue,  2 May 2023 13:38:29 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:38:29 +0000 (GMT)
Message-ID: <18ae04fe-f906-7fce-c560-8268df989c34@linux.ibm.com>
Date:   Tue, 2 May 2023 09:38:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
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
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cfCath4cF-1F5F4rlea0MEy-pmVYAYwq
X-Proofpoint-GUID: zAYM_OqMxiDWZ-V_66ZL0HGVGZw9AHI1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305020115
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 9:28 AM, David Hildenbrand wrote:
> On 02.05.23 15:10, Jason Gunthorpe wrote:
>> On Tue, May 02, 2023 at 03:04:27PM +0200, Christian Borntraeger wrote:
>> \> > We can reintroduce a flag to permit exceptions if this is really broken, are you
>>>> able to test? I don't have an s390 sat around :)
>>>
>>> Matt (Rosato on cc) probably can. In the end, it would mean having
>>>    <memoryBacking>
>>>      <source type="file"/>
>>>    </memoryBacking>
>>
>> This s390 code is the least of the problems, after this series VFIO
>> won't startup at all with this configuration.
> 
> Good question if the domain would fail to start. I recall that IOMMUs for zPCI are special on s390x. [1]

Eh, well what you referenced there never merged.  We will eventually do something like this, but via iommufd.  But right now s390 is still using vfio type1 iommu

> 
> Well, zPCI is special. I cannot immediately tell when we would trigger long-term pinning.

Enabling a zPCI device in a QEMU guest when using zPCI interpretation facilities

> 
> [1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg875728.html
> 

