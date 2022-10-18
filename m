Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140E7602F3D
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJRPLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 11:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJRPLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 11:11:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F141868A5;
        Tue, 18 Oct 2022 08:11:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IF6YBu010713;
        Tue, 18 Oct 2022 15:11:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IeTbFhUNkNs/q6jQFENQ4qg4Yy9Z8X9Pz3/Uov/ew5U=;
 b=aA9moSjk5AQKlK5PVymAnRaZEw/eTo/2WBTaDn9OrdASkbpgrxKRYYTlU6i010sZmskz
 KBZ9XCFLBSoP52l1y3sBU8UQ9cL4T8fuEe9r1Eb7fKBBOLq7RBid3zOa6FeAzHBVGAAf
 mVDkUqbQmobGZGObNFCkeDwRFtI7AoFYNHnHgCZ48lxmWX1YfsHVH/h5kZzBL3J97E5O
 Ht5G/so4nfcYZb7Z8AaXJtffW6P93ULyfGO0M6VCy1+zOvzCgNP6Sw/QYqPiYQ+W51/d
 q66xEKMB9gKKt04i7kIHv5f3qQzcifQfpJMzhQ5OnWktppypwR4e+T0Y+tc/XDLD2ZPZ 1Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k9vta49h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 15:11:26 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29IEpaNG030321;
        Tue, 18 Oct 2022 15:11:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3k7m4jc6uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 15:11:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29IFBrwO53084652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 15:11:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE090A4057;
        Tue, 18 Oct 2022 15:11:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA17CA4051;
        Tue, 18 Oct 2022 15:11:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Oct 2022 15:11:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 88EB6E0133; Tue, 18 Oct 2022 17:11:20 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     dxu@dxuuu.xyz
Cc:     bpf@vger.kernel.org, jolsa@kernel.org, kuba@kernel.org,
        martin.lau@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using 92168
Date:   Tue, 18 Oct 2022 17:11:20 +0200
Message-Id: <20221018151120.1435085-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221004144603.obymbke3oarhgnnz@kashmir.localdomain>
References: <20221004144603.obymbke3oarhgnnz@kashmir.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YMmqkhJWn9SFomlgZwi4HGP7esy4hDG8
X-Proofpoint-GUID: YMmqkhJWn9SFomlgZwi4HGP7esy4hDG8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_05,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=745 impostorscore=0 malwarescore=0 mlxscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

chiming in. I also see that on s390x with 6.1-rc.

latest greates pahole does seem to fix this for me on s390 with gcc, but 
with clang I still see this.

Christian
