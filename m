Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9C41A15F8
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 21:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDGTai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 15:30:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34164 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDGTai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 15:30:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037JSF8w158130;
        Tue, 7 Apr 2020 19:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SbQe82vHs13pDd9LLSs8DskFa5zQn9QZR3OLcQuV52k=;
 b=sL1XyPJd/DIpcenknFdHOXkcd0mayJOs1MBfeyzTgztVOblftK+mLAQb+MIIHC2sbVPf
 v+0ntXlaZ6ttIgkgfTiPIehjf7UK7886+QFMD11u287icjWVE9S9dmOkBPrRGAamQSU+
 48MpbkgjmZzJR3SF/KoS1yjCmOcrLQnrHSWF8+bf50yG8xJmmUnr5s0IFNr0FUgB5BiN
 c7qFPRzLrJozIXi75uS1o2qqe1hrm2s7HVQIojpLCZU5YHioLUId3kxQmidJ7W8tj08o
 1bFONZ+6yuNdVS7f+0ORUzPKZPK7SjrLO/g2rqlJ58KlHAVCz6S456z4At3mveGdk7Ed 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 308ffdd251-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 19:30:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037JQUZL086081;
        Tue, 7 Apr 2020 19:30:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 30839u6hrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 07 Apr 2020 19:30:29 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037JUTtO096203;
        Tue, 7 Apr 2020 19:30:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30839u6hqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 19:30:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 037JUSrM006077;
        Tue, 7 Apr 2020 19:30:28 GMT
Received: from [10.159.145.213] (/10.159.145.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 12:30:27 -0700
Subject: Re: [PATCH net 2/2] net/rds: Fix MR reference counting problem
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>, netdev@vger.kernel.org,
        sironhide0null@gmail.com
Cc:     davem@davemloft.net, rds-devel@oss.oracle.com
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
 <a99e79aa8515e4b52ced83447122fbd260104f0f.1586275373.git.ka-cheong.poon@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <96f17f7d-365c-32ec-2efe-a6a5d9d306b7@oracle.com>
Date:   Tue, 7 Apr 2020 12:30:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a99e79aa8515e4b52ced83447122fbd260104f0f.1586275373.git.ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/20 9:08 AM, Ka-Cheong Poon wrote:
> In rds_free_mr(), it calls rds_destroy_mr(mr) directly.  But this
> defeats the purpose of reference counting and makes MR free handling
> impossible.  It means that holding a reference does not guarantee that
> it is safe to access some fields.  For example, In
> rds_cmsg_rdma_dest(), it increases the ref count, unlocks and then
> calls mr->r_trans->sync_mr().  But if rds_free_mr() (and
> rds_destroy_mr()) is called in between (there is no lock preventing
> this to happen), r_trans_private is set to NULL, causing a panic.
> Similar issue is in rds_rdma_unuse().
> 
> Reported-by: zerons <sironhide0null@gmail.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
Thanks for getting this out on the list.

Hi zerons,
Can you please review it and see it addresses your concern ?

Regards,
Santosh
