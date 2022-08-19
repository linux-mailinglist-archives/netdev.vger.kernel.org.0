Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BF45999F2
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 12:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348393AbiHSKjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348275AbiHSKjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:39:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8C07F124;
        Fri, 19 Aug 2022 03:38:57 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JAN17X004661;
        Fri, 19 Aug 2022 10:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=HRTeMWW3i3o/opZMcyPGHs+ShmWqQhyfthD2N/T6Img=;
 b=Ed1Pj4jDIxxZ4lXVHeZT+yyL66LF3ce0+bNUTTYE1Gw6sFg0t73rWpxnuuDi8E0PSXoj
 0pRkHl2h16GqEJlYKpgCXO1Ce7h279pXlRumfbfxedbqhG0hUqpQ8vr/o12yjLEw6UsA
 vTmST1smBItxlGSLJhFemkOA2aS5B0+rLwKofJielgSZmQLXL99mv/RND6Bj2hdLFp/N
 5Tz+DvIhS5mF3tIttVUgP2GxHi67LdtYvK74ZFv068djCrWeAQBnz7M08xz5Bo8HsfKB
 7tjQWQrautqM2o1vhXhL7boY+/Z9pZUfB5wqSy338wS+1LFGc3mGlblzBrlJ1a0TJN9q jA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j28qg89pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:38:53 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27JAa99w026546;
        Fri, 19 Aug 2022 10:38:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3j0dc3as1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:38:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27JAclNj22610196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 10:38:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9256D52051;
        Fri, 19 Aug 2022 10:38:47 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.93.213])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 743235204E;
        Fri, 19 Aug 2022 10:38:47 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1oOzOo-004DLx-Lt;
        Fri, 19 Aug 2022 12:38:46 +0200
Date:   Fri, 19 Aug 2022 10:38:46 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steffen Maier <maier@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] s390: move from strlcpy with unused retval to strscpy
Message-ID: <Yv9oNvet5dMcCDbv@t480-pf1aa2c2.fritz.box>
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZTlR8yj2u-R4cx63QBTd_WcdyhsQOX1J
X-Proofpoint-ORIG-GUID: ZTlR8yj2u-R4cx63QBTd_WcdyhsQOX1J
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:01:01PM +0200, Wolfram Sang wrote:
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.
> 
> Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  drivers/s390/block/dasd_devmap.c | 2 +-
>  drivers/s390/block/dasd_eer.c    | 4 ++--
>  drivers/s390/block/dcssblk.c     | 2 +-
>  drivers/s390/char/hmcdrv_cache.c | 2 +-
>  drivers/s390/char/tape_class.c   | 4 ++--
>  drivers/s390/cio/qdio_debug.c    | 2 +-
>  drivers/s390/net/ctcm_main.c     | 2 +-
>  drivers/s390/net/fsm.c           | 2 +-
>  drivers/s390/net/qeth_ethtool.c  | 4 ++--
>  drivers/s390/scsi/zfcp_aux.c     | 2 +-
>  drivers/s390/scsi/zfcp_fc.c      | 2 +-
>  11 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
> index 4bb7965daa0f..1a9714af51e4 100644
> --- a/drivers/s390/cio/qdio_debug.c
> +++ b/drivers/s390/cio/qdio_debug.c
> @@ -87,7 +87,7 @@ int qdio_allocate_dbf(struct qdio_irq *irq_ptr)
>  			debug_unregister(irq_ptr->debug_area);
>  			return -ENOMEM;
>  		}
> -		strlcpy(new_entry->dbf_name, text, QDIO_DBF_NAME_LEN);
> +		strscpy(new_entry->dbf_name, text, QDIO_DBF_NAME_LEN);
>  		new_entry->dbf_info = irq_ptr->debug_area;
>  		mutex_lock(&qdio_dbf_list_mutex);
>  		list_add(&new_entry->dbf_list, &qdio_dbf_list);
> diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
> index fd2f1c31bd21..df782646e856 100644
> --- a/drivers/s390/scsi/zfcp_aux.c
> +++ b/drivers/s390/scsi/zfcp_aux.c
> @@ -103,7 +103,7 @@ static void __init zfcp_init_device_setup(char *devstr)
>  	token = strsep(&str, ",");
>  	if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
>  		goto err_out;
> -	strlcpy(busid, token, ZFCP_BUS_ID_SIZE);
> +	strscpy(busid, token, ZFCP_BUS_ID_SIZE);
>  
>  	token = strsep(&str, ",");
>  	if (!token || kstrtoull(token, 0, (unsigned long long *) &wwpn))
> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
> index b61acbb09be3..77917b339870 100644
> --- a/drivers/s390/scsi/zfcp_fc.c
> +++ b/drivers/s390/scsi/zfcp_fc.c
> @@ -885,7 +885,7 @@ static int zfcp_fc_gspn(struct zfcp_adapter *adapter,
>  			 dev_name(&adapter->ccw_device->dev),
>  			 init_utsname()->nodename);
>  	else
> -		strlcpy(fc_host_symbolic_name(adapter->scsi_host),
> +		strscpy(fc_host_symbolic_name(adapter->scsi_host),
>  			gspn_rsp->gspn.fp_name, FC_SYMBOLIC_NAME_SIZE);
>  
>  	return 0;
> -- 
> 2.35.1
> 

Those look good to me.

As far as zFCP and QDIO go:

Acked-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
