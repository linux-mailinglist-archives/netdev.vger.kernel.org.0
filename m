Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63A78F043
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfHOQQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:16:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOQQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 12:16:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGDWRd184373;
        Thu, 15 Aug 2019 16:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OkMXRsF4mDAdzvH3/kAdilVCSMv7mJzK/Hgh4U/ioh8=;
 b=m1sZIs7rgOtalL9bfFLc1vfI0QG9a5gASpiMaB6NDKsFEmxm0O6atb26quTMmySJltV5
 Yy0+50mRrrjAk1y1k+6MKGfc1dlWOARnkIEyDLyT6DxWANuLcfnmO2+wjHEIAU69zXg9
 iU+8Jrvm0iwUb9I+LEJ6ytSBEXXFjco1254HRiorgLSdYxqm0FDMNWQQYNXG+09J1LiI
 l7Sn7shn+tFGO7/dwi+q9dKuNQijCzsSP9BpOaaTnvKiQYndEbHNQrVf1LycXYvAYwaP
 MMLafAXP8i4CWi8rehhSppUBZWzF94MunfCTV0ABlCYzeEWiIKrl68w9s+iEkwb8TDN5 XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqugfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:16:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGDDvZ094667;
        Thu, 15 Aug 2019 16:16:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ucgf16rbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:16:43 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FGDUBA096548;
        Thu, 15 Aug 2019 16:16:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ucgf16raf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:16:43 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FGGgZf016397;
        Thu, 15 Aug 2019 16:16:42 GMT
Received: from [10.159.249.63] (/10.159.249.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 09:16:42 -0700
Subject: Re: [PATCH net-next v2 1/4] RDS: limit the number of times we loop in
 rds_send_xmit
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
 <90b76f24-d799-5362-df53-19102d781e3e@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <60c48651-a910-ad82-f8f5-1af188f43009@oracle.com>
Date:   Thu, 15 Aug 2019 09:16:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <90b76f24-d799-5362-df53-19102d781e3e@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150159
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/19 7:42 AM, Gerd Rausch wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Fri, 3 Feb 2012 11:07:54 -0500
> 
> This will kick the RDS worker thread if we have been looping
> too long.
> 
> Original commit from 2012 updated to include a change by
> Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> that triggers "must_wake" if "rds_ib_recv_refill_one" fails.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Thought I acked V1 series.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
