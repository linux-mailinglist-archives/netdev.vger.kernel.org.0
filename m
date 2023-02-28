Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8346A5EDA
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 19:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjB1Sho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 13:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1Shn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 13:37:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC3621282;
        Tue, 28 Feb 2023 10:37:41 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SHmNLW027972;
        Tue, 28 Feb 2023 18:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=E4vLYHn5+muNXpB+DuhGrT5rOn/ajMyCNdy6BAyMlgA=;
 b=FmH0RIcS+6O+Nl4bNs1HZSJbV2dlS8XWGQEzKCMmU7UeXtDxvKy3RXLysszGHdVUFHUX
 okHURavgZZ1sG36NuOmLm8F1AeU18kV17sApHNfG1vg1iSwFwGCkzbc8SUCnnoRzFrFO
 tBLEASkOT8VfxrO2Ml0qnrLqnwoAlNXyQuQhPeFttVFiUBW8stkr/2VeM0crxVtoL4jc
 z6Yh29yc2FSVrhDjSbrASv+wigQxkNWZGooln2mUwU6UDWAk9JCMrP994Cra2MNtiAxl
 qN8Exo6cylBlKm3JxP2zjMY6ZVsEW3EKjt52tvgGv3RQ0dAQRCPrspgtm5UoEm38KB6R IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1ny21uh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 18:37:28 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SHmON1028192;
        Tue, 28 Feb 2023 18:37:27 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1ny21ugp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 18:37:27 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31RNV9Q2021296;
        Tue, 28 Feb 2023 18:37:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3nybbyth86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 18:37:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SIbLfI590394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 18:37:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 413D82004B;
        Tue, 28 Feb 2023 18:37:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A1B20049;
        Tue, 28 Feb 2023 18:37:20 +0000 (GMT)
Received: from osiris (unknown [9.171.64.87])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Feb 2023 18:37:20 +0000 (GMT)
Date:   Tue, 28 Feb 2023 19:37:19 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net v2] net/smc: fix application data exception
Message-ID: <Y/5J30kmv1cPc7nE@osiris>
References: <1676529545-32741-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676529545-32741-1-git-send-email-alibuda@linux.alibaba.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jg0w_04plgICG-S-7JHveK1cZn1hxG5q
X-Proofpoint-ORIG-GUID: il7R5c62d3eiLbuJBovPh_j-YILtXwAv
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_15,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=704 spamscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280154
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:39:05PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> There is a certain probability that following
> exceptions will occur in the wrk benchmark test:
> 
> Running 10s test @ http://11.213.45.6:80
>   8 threads and 64 connections
>   Thread Stats   Avg      Stdev     Max   +/- Stdev
>     Latency     3.72ms   13.94ms 245.33ms   94.17%
>     Req/Sec     1.96k   713.67     5.41k    75.16%
>   155262 requests in 10.10s, 23.10MB read
> Non-2xx or 3xx responses: 3
> 
> We will find that the error is HTTP 400 error, which is a serious
> exception in our test, which means the application data was
> corrupted.
> 
> Consider the following scenarios:
> 
> CPU0                            CPU1
> 
> buf_desc->used = 0;
>                                 cmpxchg(buf_desc->used, 0, 1)
>                                 deal_with(buf_desc)
> 
> memset(buf_desc->cpu_addr,0);
> 
> This will cause the data received by a victim connection to be cleared,
> thus triggering an HTTP 400 error in the server.
> 
> This patch exchange the order between clear used and memset, add
> barrier to ensure memory consistency.
> 
> Fixes: 1c5526968e27 ("net/smc: Clear memory when release and reuse buffer")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
> v2: rebase it with latest net tree.
> 
>  net/smc/smc_core.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index c305d8d..c19d4b7 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1120,8 +1120,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
>  
>  		smc_buf_free(lgr, is_rmb, buf_desc);
>  	} else {
> -		buf_desc->used = 0;
> -		memset(buf_desc->cpu_addr, 0, buf_desc->len);
> +		/* memzero_explicit provides potential memory barrier semantics */
> +		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
> +		WRITE_ONCE(buf_desc->used, 0);

This looks odd to me. memzero_explicit() is only sort of a compiler
barrier, since it is a function call, but not a real memory barrier.

You may want to check Documentation/memory-barriers.txt and
Documentation/atomic_t.txt.

To me the proper solution looks like buf_desc->used should be converted to
an atomic_t, and then you could do:

	memset(buf_desc->cpu_addr, 0, buf_desc->len);
	smp_mb__before_atomic();
	atomic_set(&buf_desc->used, 0);

and in a similar way use atomic_cmpxchg() instead of the now used cmpxchg()
for the part that sets buf_desc->used to 1.

Adding experts to cc, since s390 has such strong memory ordering semantics
that you can basically do whatever you want without breaking anything. So I
don't consider myself an expert here at all. :)

But given that this is common code, let's make sure this is really correct.
