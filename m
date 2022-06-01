Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B6A53A593
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 14:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353077AbiFAM7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 08:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiFAM7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 08:59:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ECF11162;
        Wed,  1 Jun 2022 05:59:34 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251C1ME9017371;
        Wed, 1 Jun 2022 12:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=66cj72qWa420n6emi4QsTozK10KFr6QW/aMACc/IsC4=;
 b=k0PE2oVRwYewMMl4r6pCh7MAesrPiH9lRca2UeyBjzgp5ci7Wa3uqkAPiEDQXEvBgvEu
 4yfWXnlY5ta0DPt2Wjr/YSTr5jCnwz9i+a0o3rDtggOTHZ54DeXQusWcf61tDQcfgwYB
 7N9HZBXN4/zjRCNqaeeC0VDGOn23xlfVohO+WB+EJWLOJzK4/gnYrbarR/SB3ph0f9IW
 42b5y9me3cTlW1YqdXkT5ypuEXOKRKmQVfZ4CspHa6MB7oFfy+rBZJMntNEnGVNDDkOE
 dp2XhMxAbarrVPNtU1rAfIgXhakNHJ6Xvc51keCJVXXHXfE+fy3U/khAWilQRa/2bvjF lg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge5aevc8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 12:59:18 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251CoiPA021220;
        Wed, 1 Jun 2022 12:59:18 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 3gd1ad0au9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 12:59:18 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251CxHO67013306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 12:59:17 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BCE1124058;
        Wed,  1 Jun 2022 12:59:17 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B12AD124053;
        Wed,  1 Jun 2022 12:59:16 +0000 (GMT)
Received: from [9.211.56.150] (unknown [9.211.56.150])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jun 2022 12:59:16 +0000 (GMT)
Message-ID: <d4ee8702-46c7-2419-40f7-b8d9709741df@linux.vnet.ibm.com>
Date:   Wed, 1 Jun 2022 07:59:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 3/6] scsi: ipr: fix missing/incorrect resource cleanup in
 error case
Content-Language: en-US
To:     Chengguang Xu <cgxu519@mykernel.net>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
 <20220529153456.4183738-4-cgxu519@mykernel.net>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <20220529153456.4183738-4-cgxu519@mykernel.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2erhlMD9EfkOHm_SO_Xt_703KUfPLYW3
X-Proofpoint-ORIG-GUID: 2erhlMD9EfkOHm_SO_Xt_703KUfPLYW3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_03,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=944
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010057
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

