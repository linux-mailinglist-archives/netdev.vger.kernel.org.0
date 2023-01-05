Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF5465EEA2
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjAEOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjAEOVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:21:05 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFDF44C5E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 06:21:02 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 305AVMgF027091;
        Thu, 5 Jan 2023 14:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=jan2016.eng;
 bh=v7BX8JNkNPsjMuIfz9r5tihi1hRNVgbLDsrREFV/Xpg=;
 b=bX65k4m2Tssg1wKBg+2giVtkTX9P1F18w8fGoE0j+OwGwZNbAcNPEG2XYRDZEhKAUYN0
 emev7SoOAGqh0UW/7P7O2JeFyr9GGQfjZ/AagxojDWNYv6VQYocp0ADguSR8xr+mWU7f
 f2v/lsyTCZcNPUL9gIQPMFStkTl8pv/N6xelDd3cOweLCnoiykT7G6Z8wL/EyvDozQV5
 Pul3wEe/K8wmDfFld8aG3olDRGGRBBcTV4Arps+qipth2qLAzxyktkWCZ2uW9SZ7/r78
 H5gt7rW1M/TKelmGi3F0hBlKmBQrUTrsjtJGE364QaCFmXlV5Gt1rlDhXoOKiib+sMdu 9g== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050102.ppops.net-00190b01. (PPS) with ESMTPS id 3mtb1r8rrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:21:00 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 305BE4Of012360;
        Thu, 5 Jan 2023 09:21:00 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.24])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3mwwgarkxr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 09:21:00 -0500
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.221.201) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Thu, 5 Jan 2023 09:20:34 -0500
From:   Max Tottenham <mtottenh@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <johunt@akamai.com>, <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] tc: Add JSON output to tc-class 
Date:   Thu, 5 Jan 2023 09:20:12 -0500
Message-ID: <20230105142013.243810-1-mtottenh@akamai.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.28.221.201]
X-ClientProxiedBy: usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=300 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050113
X-Proofpoint-ORIG-GUID: qXfPCRFX-4J69sZ4PuoQ5Co6XDhopT9-
X-Proofpoint-GUID: qXfPCRFX-4J69sZ4PuoQ5Co6XDhopT9-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1031 suspectscore=0 mlxlogscore=294 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050113
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-sending my original patch rebased to current main branch. 
Looks like it got dropped somewhere along the way.


