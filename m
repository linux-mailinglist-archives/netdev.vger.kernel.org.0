Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44A46F49E1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjEBSpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEBSps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:45:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F911E73;
        Tue,  2 May 2023 11:45:46 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342Ielmu020038;
        Tue, 2 May 2023 18:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y5zlNEwOG2ptRaoZlX8s256Y2ftpFkpYD9yVgsF0Q28=;
 b=ciPQzlbQ2rl3+1dUFCETd8dc5/GXxssBrbewrHBqTWF1M71UEFxCv3sBwmYux9LCiaqp
 vYlxBJ5L9ymErmtVhV2vw0AK/1RUfBOkp58J4jDog8J+kPzVcCRAZPbAmZ3kY137aqUW
 1a1r8PO7iDmnzJ3wio9rkgd3XYETKP5MPrxYpuz9l/9fboeN26lYhvTmYpM43VRsCyCL
 VSRatTmA29wduAFqdIO1pFM38wMMSTwvhq3UHZ73MM3N/ocb+aXIpqhAub69V/Dyon+d
 BXBoQWlNcmMYpfdmX8RBCLZBHmUvnsLPTCqb/KAIQCR8lYVhLeMwMqVwX/eES/cq1bxP VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb767sk1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 18:45:10 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342IfQG8022079;
        Tue, 2 May 2023 18:45:10 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb767sk0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 18:45:09 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342Hthea003792;
        Tue, 2 May 2023 18:45:08 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3q8tv7rs0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 18:45:08 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342Ij5NV44368258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 18:45:05 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB0185803F;
        Tue,  2 May 2023 18:45:04 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 711F358068;
        Tue,  2 May 2023 18:45:01 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 18:45:01 +0000 (GMT)
Message-ID: <ce86e956-173f-848a-a1f3-f102134ccd94@linux.ibm.com>
Date:   Tue, 2 May 2023 14:45:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <cover.1683044162.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2LCoG5Unst8UUEzla8ABjD356N8l43rZ
X-Proofpoint-ORIG-GUID: cSQj8we2iuCB-VjCHpIHGE97SoRPJ3ys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_10,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1011
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 mlxlogscore=733
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020160
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 12:34 PM, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.
> 
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
> 
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.
> 
> For example, consider the following scenario:-
> 
> 1. A folio is written to via GUP which write-faults the memory, notifying
>    the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>    the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>    direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>    (though it does not have to).
> 
> This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
> pin_user_pages_fast_only() does not exist, we can rely on a slightly
> imperfect whitelisting in the PUP-fast case and fall back to the slow case
> should this fail.
> 
> v7:
> - Fixed very silly bug in writeable_file_mapping_allowed() inverting the
>   logic.
> - Removed unnecessary RCU lock code and replaced with adaptation of Peter's
>   idea.
> - Removed unnecessary open-coded folio_test_anon() in
>   folio_longterm_write_pin_allowed() and restructured to generally permit
>   NULL folio_mapping().
> 

FWIW, I realize you are planning another respin, but I went and tried this version out on s390 -- Now when using a memory backend file and vfio-pci on s390 I see vfio_pin_pages_remote failing consistently.  However, the pin_user_pages_fast(FOLL_WRITE | FOLL_LONGTERM) in kvm_s390_pci_aif_enable will still return positive.  

