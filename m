Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A6B4C4DFB
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 19:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiBYSor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 13:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiBYSoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 13:44:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DA918BA6F
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 10:44:13 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PHGPKf006507;
        Fri, 25 Feb 2022 18:44:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=7DgLfAgFSFZJ1FfKoaZAm38fYHQsWMDhwWO+80/60tk=;
 b=Zpl6cWMsAECLVxRgOgM6a5orgVnxG/AVC8ZtunhWtq5oaEXokp0MVsdj3fJRsPxT6GQD
 1h16wTU7HEjzrCOudlOy4X0iukLsNKnRJGdXnu6qTEsOjOZuaijAWg9OtWfxp7WzNYB3
 /daEJQOsc8D0dHkudrVLBRD9rrgLG5KnFYZ0eK3NEqomOHIRE+ObrBO13lhlGcVuGs5X
 KuxM7CMWVh84vI/YrTVImIGuZueGC8nEdiIzwHhtH/FmzpYi7L23J5fQD9sQlf9r81So
 sbxXQAVXoUfEwZFIGBUv0gRs2HgIRfHfEPKEIw2Nlut0fK9bJBArAo08CBilTvP4UakO NA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eew87424p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 18:44:11 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PIhCdn019350;
        Fri, 25 Feb 2022 18:44:10 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3ear6bta10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 18:44:10 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PIi9MU23134574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 18:44:09 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8340B78060;
        Fri, 25 Feb 2022 18:44:09 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07B707805F;
        Fri, 25 Feb 2022 18:44:09 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.160.165.221])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with SMTP;
        Fri, 25 Feb 2022 18:44:08 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 40EDE2E11CC; Fri, 25 Feb 2022 10:44:06 -0800 (PST)
Date:   Fri, 25 Feb 2022 10:44:06 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-internal v2 2/8] ibmvnic: initialize rc before
 completing wait
Message-ID: <Yhkjdup2alWHJCiB@us.ibm.com>
References: <20220225040941.1429630-1-sukadev@linux.ibm.com>
 <20220225040941.1429630-3-sukadev@linux.ibm.com>
 <20220224211556.41874708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224211556.41874708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2kBDJCffNHTLsqOZY4TgYLQC6eSFlKsg
X-Proofpoint-GUID: 2kBDJCffNHTLsqOZY4TgYLQC6eSFlKsg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_10,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxlogscore=847 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Thu, 24 Feb 2022 20:09:35 -0800 Sukadev Bhattiprolu wrote:
> > We should initialize ->init_done_rc before calling complete(). Otherwise
> > the waiting thread may see ->init_done_rc as 0 before we have updated it
> > and may assume that the CRQ was successful.
> > 
> > Fixes: 6b278c0cb378 ("ibmvnic delay complete()")
> 
> As you resend please fix to:
> 
> Fixes: 6b278c0cb378 ("ibmvnic: delay complete()")
> 
> There's a : missing.

Ah sorry.

> 
> Also in patch three make reinit_init_done() non-inline to keep with 
> the netdev recommendations.

I had already resent and the patches were merged this morning.
Will send a patch to drop the inline.

Thanks

Sukadev
