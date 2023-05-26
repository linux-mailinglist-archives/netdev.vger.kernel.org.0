Return-Path: <netdev+bounces-5726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D87A71292B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C13B11C21088
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFA1261E0;
	Fri, 26 May 2023 15:10:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30060848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:10:12 +0000 (UTC)
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3FB189
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:10:10 -0700 (PDT)
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
	by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34QBFNRQ020742;
	Fri, 26 May 2023 16:10:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=BpmdxD4r3hzb4FEs1cpN/+xmjgunAM9T7EjQkd7miO8=;
 b=l7S4juJ7WaHbYXg9SALhvOCQUvZAi8tetyhvwcihFGi/os71qBajG2eqSy3VgFR57lxk
 l2MhWieHRpuSEjmkRomLx2XYlnREnuxVGSStfSVKEzVwj7e4X6joi1mMMQIV+8EsmVYO
 cmSdIgreuqP5AV6YIxmCozcHsh1FPGxG7CintDj8g/JryudqO9bseRKfS9iFfl1vUQqS
 2BulMMlh51B4negDIfqXsyXdjYWwQc5dL81aha6XYL+R3eSO5L1jgEDsHLM2Z4Os57KV
 4V53Q7y5bUo21sGWJXlrAoPzTr8QOff4sRoIPYl00o0KRPsQ93aVwaVtqE/NmHrh0Krh 5A== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
	by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3qpp8r7t4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 16:10:08 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 34QESpVY015014;
	Fri, 26 May 2023 08:10:07 -0700
Received: from email.msg.corp.akamai.com ([172.27.91.24])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3qpv698jxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 08:10:07 -0700
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.222.198) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 11:10:07 -0400
From: Max Tottenham <mtottenh@akamai.com>
To: <netdev@vger.kernel.org>
CC: <stephen@networkplumber.org>, <johunt@akamai.com>,
        Max Tottenham
	<mtottenh@akamai.com>
Subject: [RFC PATCH v2 iproute2 0/1] Add ability to specify eBPF map pin path
Date: Fri, 26 May 2023 11:09:20 -0400
Message-ID: <20230526150921.338906-1-mtottenh@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230503173348.703437-1-mtottenh@akamai.com>
References: <20230503173348.703437-1-mtottenh@akamai.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.28.222.198]
X-ClientProxiedBy: usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_06,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=376 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260127
X-Proofpoint-GUID: i_i_g5pD4Hxp92cqQgyuXZ_xOwuRNaJC
X-Proofpoint-ORIG-GUID: i_i_g5pD4Hxp92cqQgyuXZ_xOwuRNaJC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_06,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 mlxlogscore=427
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260128
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
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


Changes since V1:

 * Remove debug code.
 * Update man page.

Max Tottenham (1):
  tc/f_bpf.c: Add ability to specify eBPF map pin path

 include/bpf_util.h |  1 +
 lib/bpf_legacy.c   | 11 +++++++++--
 lib/bpf_libbpf.c   | 14 +++++++-------
 man/man8/tc-bpf.8  |  8 ++++++++
 tc/f_bpf.c         |  4 +++-
 5 files changed, 28 insertions(+), 10 deletions(-)

-- 
2.25.1


