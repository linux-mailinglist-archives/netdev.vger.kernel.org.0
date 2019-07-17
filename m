Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF86B2E2
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389051AbfGQAa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:30:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbfGQAa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:30:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0T5DW086898;
        Wed, 17 Jul 2019 00:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+OmuX5IMIfqkKElSKCZFFVvvAf/NERvIolG+tzD78/M=;
 b=k6LZW+9K7+TsmuWNKKqOC4AdhAxz8+IFXcy4d2D0s6fPCNmiq0NCgHv83SwK+amIHyOo
 7kPlc0RKY1YZ4ptEMzuoLMkNuVLaI26h6vfJitnhkztpBtFoIF/f+PyjIonLFPbxRNfi
 +O4O+1+6iV7GucxGuvEnSil+jAQKbWQ+gZZFdC1rivVHGj4aYveXormXL2INRSoqNR5O
 iXFQBcwKTtTKUDPx3wCxO/DlpiApkGmzKZcCDmw5lylXXd5KBkcfDfnF/SbchhTeb0PP
 99geX5GhAPz8nEjwjIIfv3Bq+nrF5Mrn+GoTGVefRyoPxr4zeRLrfVryVwl+p7Nf7Fnt fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tq78pqfeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:30:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0SAdG192559;
        Wed, 17 Jul 2019 00:28:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2tq4du7e1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jul 2019 00:28:49 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H0Snkj193501;
        Wed, 17 Jul 2019 00:28:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tq4du7e1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:28:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6H0SmkM010024;
        Wed, 17 Jul 2019 00:28:48 GMT
Received: from [192.168.86.192] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 00:28:48 +0000
Subject: Re: [PATCH net v3 6/7] net/rds: Keep track of and wait for FRWR
 segments in use upon shutdown
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <28ded44a-bce9-8632-d7e8-fe843140658e@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <ab50c07c-ed8c-c747-89b9-32cac2146645@oracle.com>
Date:   Tue, 16 Jul 2019 17:28:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <28ded44a-bce9-8632-d7e8-fe843140658e@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170004
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 3:29 PM, Gerd Rausch wrote:
> Since "rds_ib_free_frmr" and "rds_ib_free_frmr_list" simply put
> the FRMR memory segments on the "drop_list" or "free_list",
> and it is the job of "rds_ib_flush_mr_pool" to reap those entries
> by ultimately issuing a "IB_WR_LOCAL_INV" work-request,
> we need to trigger and then wait for all those memory segments
> attached to a particular connection to be fully released before
> we can move on to release the QP, CQ, etc.
> 
> So we make "rds_ib_conn_path_shutdown" wait for one more
> atomic_t called "i_fastreg_inuse_count" that keeps track of how
> many FRWR memory segments are out there marked "FRMR_IS_INUSE"
> (and also wake_up rds_ib_ring_empty_wait, as they go away).
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
