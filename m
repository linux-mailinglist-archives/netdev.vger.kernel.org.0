Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EEA23A3F5
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHCMS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 08:18:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgHCMS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 08:18:26 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 073C3cka095492;
        Mon, 3 Aug 2020 08:18:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32pd7v8a4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 08:18:16 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 073C3hQd095610;
        Mon, 3 Aug 2020 08:18:16 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32pd7v8a3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 08:18:16 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 073CFsRK000313;
        Mon, 3 Aug 2020 12:18:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 32n01825m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 12:18:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 073CIBNo55705918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Aug 2020 12:18:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3892A4C040;
        Mon,  3 Aug 2020 12:18:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0DD84C046;
        Mon,  3 Aug 2020 12:18:10 +0000 (GMT)
Received: from oc5311105230.ibm.com (unknown [9.145.63.67])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Aug 2020 12:18:10 +0000 (GMT)
Subject: Re: [Linux-kernel-mentees] [PATCH net] net/smc: Prevent
 kernel-infoleak in __smc_diag_dump()
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <20200801194440.246747-1-yepeilin.cs@gmail.com>
From:   Ursula Braun <ubraun@linux.ibm.com>
Message-ID: <7f07ed70-25eb-7eee-fac6-cc2226ef01e7@linux.ibm.com>
Date:   Mon, 3 Aug 2020 14:18:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200801194440.246747-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_10:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/20 9:44 PM, Peilin Ye wrote:
> __smc_diag_dump() is potentially copying uninitialized kernel stack memory
> into socket buffers, since the compiler may leave a 4-byte hole near the
> beginning of `struct smcd_diag_dmbinfo`. Fix it by initializing `dinfo`
> with memset().
> 
> Cc: stable@vger.kernel.org
> Fixes: 4b1b7d3b30a6 ("net/smc: add SMC-D diag support")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Reference: https://lwn.net/Articles/417989/
> 
> $ pahole -C "smcd_diag_dmbinfo" net/smc/smc_diag.o
> struct smcd_diag_dmbinfo {
> 	__u32                      linkid;               /*     0     4 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	__u64                      peer_gid __attribute__((__aligned__(8))); /*     8     8 */
> 	__u64                      my_gid __attribute__((__aligned__(8))); /*    16     8 */
> 	__u64                      token __attribute__((__aligned__(8))); /*    24     8 */
> 	__u64                      peer_token __attribute__((__aligned__(8))); /*    32     8 */
> 
> 	/* size: 40, cachelines: 1, members: 5 */
> 	/* sum members: 36, holes: 1, sum holes: 4 */
> 	/* forced alignments: 4, forced holes: 1, sum forced holes: 4 */
> 	/* last cacheline: 40 bytes */
> } __attribute__((__aligned__(8)));
> $ _
> 

Thanks, patch is added to our local library and will be part of our
next shipment of smc patches for the net-tree.

Regards, Ursula

>  net/smc/smc_diag.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index e1f64f4ba236..da9ba6d1679b 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -170,13 +170,15 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	    (req->diag_ext & (1 << (SMC_DIAG_DMBINFO - 1))) &&
>  	    !list_empty(&smc->conn.lgr->list)) {
>  		struct smc_connection *conn = &smc->conn;
> -		struct smcd_diag_dmbinfo dinfo = {
> -			.linkid = *((u32 *)conn->lgr->id),
> -			.peer_gid = conn->lgr->peer_gid,
> -			.my_gid = conn->lgr->smcd->local_gid,
> -			.token = conn->rmb_desc->token,
> -			.peer_token = conn->peer_token
> -		};
> +		struct smcd_diag_dmbinfo dinfo;
> +
> +		memset(&dinfo, 0, sizeof(dinfo));
> +
> +		dinfo.linkid = *((u32 *)conn->lgr->id);
> +		dinfo.peer_gid = conn->lgr->peer_gid;
> +		dinfo.my_gid = conn->lgr->smcd->local_gid;
> +		dinfo.token = conn->rmb_desc->token;
> +		dinfo.peer_token = conn->peer_token;
>  
>  		if (nla_put(skb, SMC_DIAG_DMBINFO, sizeof(dinfo), &dinfo) < 0)
>  			goto errout;
> 
