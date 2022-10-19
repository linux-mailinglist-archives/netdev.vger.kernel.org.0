Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4714F6046F9
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiJSNZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiJSNZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:25:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA628129085;
        Wed, 19 Oct 2022 06:11:50 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JC4Awm024288;
        Wed, 19 Oct 2022 12:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PwpSNDQOdPBrNDCSnG37C6FJq+QMd2H/QH1abN8bGVs=;
 b=OCdSW32Y7zShllTmH+Td/iyANBYHXIZlVfxFAcdzori5cq8cUSSEg/p6U3bBMDZky/ag
 crorhfhzq0LvXQuwuCxGpTuyo2WaZCYZ1NdeIeu2bDfyD2oB9+x3vCnHBLTrothf+/0b
 ouDrdgHqyIBTowJK9jyDdWQGYmYswXy8/X6SuoKhseX3WQt9RVKPSMecDYd2+qByerj4
 92XaRRDiEzW7yNhgPQvN5tJAVNxEw668xHC/E8Tcxu26E4HqT0PdjYaePiy9LeF2lCR/
 rYzwLKWkMketNEBFgR7Iwio1+8FBmHxaKwE0CU708KxXGqGWhrcM9iW/iitBdzjAtYJU ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kagwt8jqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 12:16:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JCDt3P029429;
        Wed, 19 Oct 2022 12:16:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kagwt8jpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 12:16:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JC7b92002567;
        Wed, 19 Oct 2022 12:16:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg95ac3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 12:16:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JCGiZs42271092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 12:16:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 583AC42045;
        Wed, 19 Oct 2022 12:16:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41A5D42042;
        Wed, 19 Oct 2022 12:16:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Oct 2022 12:16:44 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E0AB8E023C; Wed, 19 Oct 2022 14:16:43 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     yury.norov@gmail.com
Cc:     agordeev@linux.ibm.com, ajones@ventanamicro.com,
        amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com,
        bigeasy@linutronix.de, bp@alien8.de, caraitto@google.com,
        davem@davemloft.net, edumazet@google.com, guoren@linux.alibaba.com,
        imagedong@tencent.com, jonolson@google.com, kuba@kernel.org,
        kuniyu@amazon.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mst@redhat.com, netdev@vger.kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, torvalds@linux-foundation.org,
        willemb@google.com, borntraeger@linux.ibm.com
Subject: Re: [PATCH] Revert "net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}"
Date:   Wed, 19 Oct 2022 14:16:43 +0200
Message-Id: <20221019121643.2866464-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221017030947.1295426-1-yury.norov@gmail.com>
References: <20221017030947.1295426-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0SPNsqdcHHjo6zUiPdWA6Sa45tpEQptl
X-Proofpoint-ORIG-GUID: llzVULK_HBOmK1ltN1KQfhKP1jh3D7KO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_06,2022-10-19_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 clxscore=1011 priorityscore=1501 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=859 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210190067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

for virtio on s390x.

Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
