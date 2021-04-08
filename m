Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48938357C1C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 08:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHGE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 02:04:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29612 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229815AbhDHGEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 02:04:24 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 138640cS153843;
        Thu, 8 Apr 2021 02:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=E4kW5qiC1G19Tcah0djQrFFFo9sQnSHU3eehOzrbrdM=;
 b=VFDLtTX4gi08b3dXDm9RUHYS7MhfyWehRnRCloZHBJtLNaW9HGTcABD0f4bPyGVIjWys
 YdLVQ3fu4wcLyFz26Tofw3IlyBRlIKKHwFlYMBnKU2JHw2r7VSl+nkjbk5n0o9+VIOq3
 OaKUa9qWyTSwDBO84/xtgPFpyA6S8PwyRuPCyi/VaSNqdGCLcCUJTjDB9yNqNeCWUPBP
 WjL3PWcFR4DYAbaWk/sL7Fr0nchz1f3KQJMc1YB0rklaldOHwywBWDCZRTVyY7DtZMuf
 sEPbS2q85umkiql0GwIjxVJ20ZBz1cyrUgN6RFUaEzv1H5A/QGgf2lZNkIh9iAe5eXam rQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvmg6dd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 02:04:10 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13861gp1004347;
        Thu, 8 Apr 2021 06:04:03 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 37rvc45khc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 06:04:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 138642FO30081460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Apr 2021 06:04:02 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECD97C6063;
        Thu,  8 Apr 2021 06:04:01 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7C59C6055;
        Thu,  8 Apr 2021 06:04:01 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.180.17])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Apr 2021 06:04:01 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id D30D92E1830; Wed,  7 Apr 2021 23:03:58 -0700 (PDT)
Date:   Wed, 7 Apr 2021 23:03:58 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ljp@linux.ibm.com,
        ricklind@linux.ibm.com
Subject: Re: [PATCH] ibmvnic: Continue with reset if set link down failed
Message-ID: <20210408060358.GA2341445@us.ibm.com>
References: <20210406034752.12840-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406034752.12840-1-drt@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6UY2zjMULlzcJe17VtVdz1JZlAPvy004
X-Proofpoint-ORIG-GUID: 6UY2zjMULlzcJe17VtVdz1JZlAPvy004
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_02:2021-04-08,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104080042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dany Madden [drt@linux.ibm.com] wrote:
> When an adapter is going thru a reset, it maybe in an unstable state that
> makes a request to set link down fail. In such a case, the adapter needs
> to continue on with reset to bring itself back to a stable state.
> 
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Given that the likely reason for set_link_state() failing is that the
CRQ is inactive and that we will attempt to free the CRQ and re-register
it in ibmvnic_reset_crq() further down, I think its okay to ignore the
error here.

Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
