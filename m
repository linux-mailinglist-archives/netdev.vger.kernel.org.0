Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272FA58F294
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 20:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiHJSze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 14:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiHJSzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 14:55:32 -0400
X-Greylist: delayed 966 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Aug 2022 11:55:31 PDT
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB29460536
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:55:31 -0700 (PDT)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 27AHFkBD014114
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 19:39:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=lrplgh+HneJYYLrW2vIE00XYQQxldxaMg4oFpbRN0yg=;
 b=RypngIxrL9SlYl7/Yh4lvpY73feVTlDoctIzRmb4dZIlJs3VlGGWHY9YDX09h/pvAw07
 fHDuOhPH9PXcZDRyeo7OaWc//fFCunloG8pvZPsKjqvkT5R1anaTmnJxycqOTrOLZPQw
 nHT7L0wGXyrEWbfAFELMnlguGeTXkr73n1QQDuod4tl8FyfvfbCVnyMM4SpjB2sWvKs9
 p2kqN/r+YhKvGRacXu31jNLYzxPD7W/0f0XjRuuNDhmQM6/i4k+SAH7rExGDiXR53bpw
 152tsUI+IMI2d2ONU1RlLLC6fE9BKJIF/T2GIALlPMkTqGNP2FIpliFeNnln3ErsM7+k ww== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 3huwsj91j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 19:39:25 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 27AG9XGA018773
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 14:39:24 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.200])
        by prod-mail-ppoint8.akamai.com (PPS) with ESMTPS id 3huwu656ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 14:39:24 -0400
Received: from ustx2ex-dag4mb4.msg.corp.akamai.com (172.27.50.203) by
 ustx2ex-dag4mb5.msg.corp.akamai.com (172.27.50.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Wed, 10 Aug 2022 11:39:23 -0700
Received: from ustx2ex-dag4mb4.msg.corp.akamai.com ([172.27.50.203]) by
 ustx2ex-dag4mb4.msg.corp.akamai.com ([172.27.50.203]) with mapi id
 15.02.1118.009; Wed, 10 Aug 2022 11:39:23 -0700
From:   "Dhupar, Rishi" <rdhupar@akamai.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Gero, Charlie" <cgero@akamai.com>
Subject: Question - bind(2) to local route on main routing table
Thread-Topic: Question - bind(2) to local route on main routing table
Thread-Index: AQHYrOiCrRVDk80IFEab1gFzPiaxjg==
Date:   Wed, 10 Aug 2022 18:39:23 +0000
Message-ID: <E8A2F333-5CE3-473C-AFF0-1B7660A9BFF2@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.27.118.139]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0702810E9A453541AECB8356BC3A4DDB@akamai.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_08,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=515 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100056
X-Proofpoint-ORIG-GUID: _sNJzZ-bP0FNCErWJMDLKjMbWmda40aF
X-Proofpoint-GUID: _sNJzZ-bP0FNCErWJMDLKjMbWmda40aF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_08,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 suspectscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=428 clxscore=1011 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100056
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCldlIHJlY2VudGx5IGRpc2NvdmVyZWQgYW4gaW5jb25zaXN0ZW5jeSBpbiB0aGUgYmVo
YXZpb3Igb2YgYmluZCgyKSB3aXRoIHJlc3BlY3QgdG8gYSB0eXBlIGxvY2FsIHJvdXRlIGJlaW5n
IGFkZGVkIHRvIHRoZSBtYWluIHRhYmxlLiANCg0KSSB3YXMgYWJsZSB0byB0cmFjayBkb3duIHRo
ZSBpc3N1ZSBhbmQgaXQgYXBwZWFycyBpdCB3YXMgaW50cm9kdWNlZCBpbiB0aGlzIGNvbW1pdFsx
XSB3aGljaCBtZXJnZWQgdGhlIGxvY2FsIGFuZCBtYWluIGZpYiB0cmllcyBmb3IgcGVyZm9ybWFu
Y2UgYW5kIHdoaWNoIGFyZSB0aGVuIGxhdGVyIHVubWVyZ2VkIG9uY2UgdGhlIFJQREIgaXMgbW9k
aWZpZWQuDQpbMV0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aWQ9MGRkY2Y0M2Q1ZDRhMDNkZWQxZWUzZjZi
M2I3MmEwY2JlZDRlOTBiMQ0KDQpTeW5vcHNpczogYSB1c2VyIGNhbiBiaW5kKDIpIHRvIGFueSBh
ZGRyZXNzIHdpdGhpbiB0aGUgcHJlZml4IG9mIGEgdHlwZSBsb2NhbCByb3V0ZSB0aGF0IGhhcyBi
ZWVuIGFkZGVkIHRvIHRoZSBtYWluIHJvdXRpbmcgdGFibGUNCg0KU2hvcnQgZXhhbXBsZSBvbiBh
biB1bnRhaW50ZWQgVWJ1bnR1IDIyLjA0IG1hY2hpbmUNCiQgaXAgcm91dGUgYWRkIGxvY2FsIDEu
Mi4zLjQvMzIgZGV2IGxvIHRhYmxlIG1haW4NCiQgbmMgLW4gLXMgMS4yLjMuNCAtbCAtcCA5OTk5
ICAgICAgICAgICAgICAgICAgICAgICMgU3VjY2VlZHMNCiQgaXAgcnVsZSBhZGQgdGFibGUgMTAw
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICMgVGhpcyBjYW4gYmUgYW55IGNoYW5nZSB0byBS
UERCDQokIG5jIC1uIC1zIDEuMi4zLjQgLWwgLXAgOTk5OQ0KQ2FuJ3QgZ3JhYiAxLjIuMy40Ojk5
OTkgd2l0aCBiaW5kIDogQ2Fubm90IGFzc2lnbiByZXF1ZXN0ZWQgYWRkcmVzcw0KDQpOb3RlOiBU
aGlzIGFsc28gaW1wYWN0cyBpbXBsaWNpdCBiaW5kIGJlaGF2aW9yIHdydCB0byBzeXN0ZW0gY2Fs
bHMgc3VjaCBhcyBjb25uZWN0KDIpLg0KDQpEb2VzIHRoaXMgd2FycmFudCBmdXJ0aGVyIGludmVz
dGlnYXRpb24gYW5kL29yIHBvc3NpYmx5IGEgcGF0Y2ggdG8gZGlzYWxsb3cgdGhpcyBiZWhhdmlv
cj8NCg0KUmVnYXJkcywNClJpc2hpIERodXBhcg0KDQoNCg==
