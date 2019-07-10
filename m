Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE2C64842
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfGJOYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:24:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfGJOYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:24:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AENcsx076102;
        Wed, 10 Jul 2019 14:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=sFSrUubrz7IO1l9677tNCeD1pgIVCMovvEX9FXEYhMk=;
 b=jpsFWmr27mTxZajOcHjuRAc99iZn9oCbA7nwtQWMh9AcaUAdKVDiahbHfnxyUCH+oLGa
 YPwvyQzdTA/xYi6TQ2JfArmzdu/CRBCtpIliE40iFGcJqDCKhw/wFEfwJd/nB0r8uHWu
 7EU3tIbFZ5W4JFdnb4B8uigjjqZsfd8lJzTNyLLyNo2+nmmUZQ1GKQAZv4knE3dc6wUj
 vLLUBYiMdrv9vzCA4j6Gce7VQkN9UJF8STPU2fE5gcv3o232gINyv3i9PNChRz5Ybvql
 spNNliuhq6EClGIsbYnDGNVvvXUiNcbf5v3kRDmyhCfQnG6i7bjddqBchrNwyWeWFVkB RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9qtenc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:24:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AENGAo001898;
        Wed, 10 Jul 2019 14:24:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tnc8sw1td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:24:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6AEOcTg027194;
        Wed, 10 Jul 2019 14:24:38 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jul 2019 07:24:38 -0700
Subject: Re: [net][PATCH 5/5] rds: avoid version downgrade to legitimate newer
 peer connections
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, davem@davemloft.net
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
 <1562736764-31752-6-git-send-email-santosh.shilimkar@oracle.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <d9f096a8-a5d7-1e91-ea87-ad0593c49f18@oracle.com>
Date:   Wed, 10 Jul 2019 22:26:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562736764-31752-6-git-send-email-santosh.shilimkar@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/10 13:32, Santosh Shilimkar wrote:
> Connections with legitimate tos values can get into usual connection
> race. It can result in consumer reject. We don't want tos value or
> protocol version to be demoted for such connections otherwise
> piers would end up different tos values which can results in
> no connection. Example a peer initiated connection with say
> tos 8 while usual connection racing can get downgraded to tos 0
> which is not desirable.
>
> Patch fixes above issue introduced by commit
> commit d021fabf525f ("rds: rdma: add consumer reject")
>
> Reported-by: Yanjun Zhu <yanjun.zhu@oracle.com>
> Tested-by: Yanjun Zhu <yanjun.zhu@oracle.com>

Thanks. I am OK with this.

Zhu Yanjun

> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> ---
>   net/rds/rdma_transport.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index 9db455d..ff74c4b 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -117,8 +117,10 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>   		     ((*err) <= RDS_RDMA_REJ_INCOMPAT))) {
>   			pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
>   				&conn->c_laddr, &conn->c_faddr);
> -			conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
> -			conn->c_tos = 0;
> +
> +			if (!conn->c_tos)
> +				conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
> +
>   			rds_conn_drop(conn);
>   		}
>   		rdsdebug("Connection rejected: %s\n",
