Return-Path: <netdev+bounces-194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C4E6F5D68
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDF291C20F49
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4033027712;
	Wed,  3 May 2023 17:58:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3377D29A8
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 17:58:54 +0000 (UTC)
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CFA5593
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:58:36 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
	by mx0b-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343ENQAP029082
	for <netdev@vger.kernel.org>; Wed, 3 May 2023 18:34:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=1fI3uMhB/INJ/YwK51dWP4sQoUUhGgvVgjNPVBrHDXQ=;
 b=dB6MmcH92zOqh3QdWYyHfX8G3zIVxOeBmXM+ohzaPWp16EpPTaixTdqN+FTJXo+c3NL0
 FRJB3unayAxN2SG9mLygWZLUgCxfj43hSBq3dVeOwXlC7nZtJRfYVqgqo09Zc2JuqQDc
 xa5LSdUH0tpTRsbHGbB3/TucqVbpsWxnOC//3yg3JuCbqqEHLGRAPHfdo9Hi9R9hkc5g
 vCIsAbeg3seRwphpXCIzX3ABxy6FrgjfgOuaAZYPDWX1pVQNH9pWgajPO6Q2Arx3pt33
 l5Nfq6k0cFWe3m1J45Vv1SFevylrJhdsouroPOzGyK9Xq4xRhbPkPragYY2WPITjczrb mA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
	by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3q8r423m6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netdev@vger.kernel.org>; Wed, 03 May 2023 18:34:25 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
	by prod-mail-ppoint1.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 343HPST1014001
	for <netdev@vger.kernel.org>; Wed, 3 May 2023 13:34:25 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.24])
	by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3q8xjyhs0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netdev@vger.kernel.org>; Wed, 03 May 2023 13:34:24 -0400
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.222.198) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 3 May 2023 13:34:24 -0400
From: Max Tottenham <mtottenh@akamai.com>
To: <netdev@vger.kernel.org>
CC: <johunt@akamai.com>
Subject: [RFC PATCH iproute2] Add ability to specify eBPF pin path 
Date: Wed, 3 May 2023 13:33:48 -0400
Message-ID: <20230503173348.703437-1-mtottenh@akamai.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.28.222.198]
X-ClientProxiedBy: usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_12,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=306 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305030150
X-Proofpoint-ORIG-GUID: GKAATOQK58eBw_X7qfXw0YlFK8goomnd
X-Proofpoint-GUID: GKAATOQK58eBw_X7qfXw0YlFK8goomnd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_12,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=305
 mlxscore=0 spamscore=0 clxscore=1011 adultscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030150
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


We have a use case where we have several different applications composed of
sets of eBPF programs (programs that may be attached at the TC/XDP layers),
that need to share maps and not conflict with each other.

For XDP based programs, we are using the xdp-loader from the xdp-tools
project[1], it exposes an option to set the 'pin-path' for a given program.
However, programs loaded via tc don't appear to have that ability, all I have
found is the use of LIBBPF_PIN_BY_NAME or the older
PIN_OBJECT_NS/PIN_GLOBAL_NS, but those don't let the user specify the path.

I've whipped up a quick patch to be able to pass along a 'pin_path'  similar to
the xdp-loader. I don't know if this is the *right* approach so I'm more than
happy to be pointed in the right direction.


Thanks

Max

[1] https://github.com/xdp-project/xdp-tools/tree/master/xdp-loader
 



