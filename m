Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526A36427D0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiLELu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiLELun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:50:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6401A066;
        Mon,  5 Dec 2022 03:50:42 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5B068P024161;
        Mon, 5 Dec 2022 11:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=5UrPZIJUJCQ6mDYoumWlJ05UmmZBMStz8IOR/GF9Ob4=;
 b=mGBLiw1IscWBSCmLn5fdc0r0hxtfsMCA1XG7MyStI8mCzcK4SPeQZzoOk/wo5ZIfgIwx
 qVpX9iOaljMgH33PdE4ezu+iPVLlPXJmEEw6K7DIYvoz87q9LFX1iviw5UKzYb8b5Pdp
 dQ6O24327x2VKQMnQF+dxuWb/Vk1LYSSlZBX3XGJKno4X5dz4/Hh8PImrGMhb2zqkVm+
 z+jJzS/24+K2dui6WHgyHIB0J5Y7bcXyYPYGXmXCEulmBV+/CXyMbG1VSqqjZnaxm/DN
 NHQR2UqoWEenRvZHbtVvDrjbvH+FxCv6iI0i2TQu8FOp0N2FfSxdGtsHFrXeJBm4Li+F Nw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g7cj41j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 11:50:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B5Bo0mH030081;
        Mon, 5 Dec 2022 11:50:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3m7x38ttdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 11:50:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B5BoZXD66781470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Dec 2022 11:50:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF5574C044;
        Mon,  5 Dec 2022 11:50:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 575644C040;
        Mon,  5 Dec 2022 11:50:35 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.179.8.35])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  5 Dec 2022 11:50:35 +0000 (GMT)
Date:   Mon, 5 Dec 2022 12:50:33 +0100
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     ye.xingchen@zte.com.cn, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] s390/qeth: use sysfs_emit() to instead of
 scnprintf()
Message-ID: <Y43bCVaVTlcDKbMt@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <202212051152565871940@zte.com.cn>
 <bf5e2905-d37e-7f54-ea2c-b75f2b921679@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf5e2905-d37e-7f54-ea2c-b75f2b921679@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bVHpYlLL9cvHMZ-lLxHQGXWHXa12_VAP
X-Proofpoint-ORIG-GUID: bVHpYlLL9cvHMZ-lLxHQGXWHXa12_VAP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=915
 clxscore=1011 impostorscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212050094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 12:38:59PM +0100, Alexandra Winter wrote:
> 
> 
> On 05.12.22 04:52, ye.xingchen@zte.com.cn wrote:
> > From: ye xingchen <ye.xingchen@zte.com.cn>
> > 
> > Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> > should only use sysfs_emit() or sysfs_emit_at() when formatting the
> > value to be returned to user space.
> > 
> > Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> > ---
> >  drivers/s390/net/qeth_l3_sys.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
> > index 1082380b21f8..65eea667e469 100644
> > --- a/drivers/s390/net/qeth_l3_sys.c
> > +++ b/drivers/s390/net/qeth_l3_sys.c
> > @@ -395,7 +395,7 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
> >  	}
> >  	mutex_unlock(&card->ip_lock);
> > 
> > -	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
> > +	return str_len ? str_len : sysfs_emit(buf, "\n");
> >  }
> > 
> >  static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
> > @@ -614,7 +614,7 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
> >  	}
> >  	mutex_unlock(&card->ip_lock);
> > 
> > -	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
> > +	return str_len ? str_len : sysfs_emit(buf, "\n");
> >  }
> > 
> >  static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,
> There are more instances of scnprintf in s390/net that can be replaced by sysfs_emit. 
> We are already working on that. 

It seems this particular fix misses scnprintf() to sysfs_emit()
conversion within same very functions just few lines above.

> But thanks for improving those two.
> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
