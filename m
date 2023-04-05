Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D946D7F5A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238394AbjDEO0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbjDEO0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:26:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C224259D6
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 07:25:55 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335D2UFu000450;
        Wed, 5 Apr 2023 14:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xf92hihKaEhFAsEmzOi3HSj5vnCmYVBcAdkGeEG7IDc=;
 b=zbAKcz0Z/Ae5QChgrOrlTn+1OPRUoLefIoK7Ih5KCwxP2YbbguJsMAXxwdWRpZTuWsm3
 JhaqzE5463+zpgRY5/aaNDi7PRZ9lB/+M72I56Ymfhuv0SJmfoopG284ccXuNwblFJJt
 wMfyHjhY32gZMZcZ+uy73mvrJTz3YbwlXi8eJ/mrkAWcF6wg563VLTNISDvkdEnbxzJz
 bhjB5YfJSNOANG+DZx3bjIxI3jN2aLGmrMFoFxwP+ZFc/60ceaxzy7Sw5sGA4RirzDX1
 sssOd5MldFn9rVur0H4imTYRvf/WR1RC5eEjoEH5NikBOavW2rhh+N5cDqu6G93RQbBN 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbhc0jbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 14:25:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 335DUAif027787;
        Wed, 5 Apr 2023 14:25:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ppturdnq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 14:25:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdkYjR+iMR2i6vO5fRYpOL8SZa0yF3bQUv1AFwR+93h7PFSm5E1BlLdoWt3w7+Ou3yGUI5+9ymuWUe7fS3A14K2xWjQtXqflvI9wTZUWV9hqhsVNmp5b21x7OTGltAhc0hxN4jE9ZbmqNT16e9in9fmTw6bE9l5Fvq7/6hzAZeQF0hCuvMTEuXBM7QchqE4OqN55Ot8mRFMDBqyhH6N8PUIFWwUX6zRdxsg3DE8KvdOm3t9wLqC2RWABZjZ+D6EmAf0bzglXf+n1eiH3J3eRDWoeVJ4SBGidWCMqFaEZt0PeIJ7AJo5cxY0rNE74ufS6vR0PzdTIllGqC8gbdROjjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xf92hihKaEhFAsEmzOi3HSj5vnCmYVBcAdkGeEG7IDc=;
 b=MKDxBB9kP7AGFNASWiMz/hsULijvnPZ6G1+uOe/eJTO58tcNS3DtbxFqyw9qjBHshOtzzI+nHEfPSV42GhDY9BqCK43L9AwTRiGySFso5C6oj5fEuElyEtDJyLxIvq/s+L4Gt4GWC8CK9QYjRDkN9f6msTL1GDWS3Bq2TPZcBioCsYCQKgjON4TWFppS6DPQlYkLd+uKNUgs1pL+E7F4n6985vRzB842Q5jwa3V+PTPnFVs6IYJuYHc8yoswmhDpHDUBFRJaklLc62uIBVkErDs6Y88vP8qKWmZBB6l6vNCCSqH8CY1e7jS0FoW/JJUZXdShXBGKzOL8oOxT5jCrlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xf92hihKaEhFAsEmzOi3HSj5vnCmYVBcAdkGeEG7IDc=;
 b=QcK6AJiYNHpqscJahNZCupDVKcB5+qJvKU1nRWUFGBBA1giE+8yxdnSSwS8YWIjapwWUi3yjNY/a+QQW6bcjQfgvYv8lkivTf/hQ3RRTfs9hRItHG4EvaPhPN9dREIhlXxo8eXqCvqxgF5npodHE5UJqQYLoNdxiq2fCFwPRKCA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Wed, 5 Apr
 2023 14:25:38 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%7]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 14:25:37 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "\"kernel-tls-handshake@lists.linux.dev\\\"
        <kernel-tls-handshake@lists.linux.dev>, John Haxby
        <john.haxby@oracle.com>\"@mx0b-00069f01.pphosted.com" 
        <"kernel-tls-handshake@lists.linux.dev\" <kernel-tls-handshake@lists.linux.dev>, John Haxby <john.haxby@oracle.com>"@mx0b-00069f01.pphosted.com>
Subject: Re: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZZlySHnrWBVVuSE6PrOQpkUIzqK8b3OoAgAAFyQCAAA2QgIAA1/KA
Date:   Wed, 5 Apr 2023 14:25:37 +0000
Message-ID: <30125584-BB17-4727-B202-3D661625845D@oracle.com>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
 <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
 <20230404172318.58e4d0dd@kernel.org>
 <D178AE57-68B8-4C63-8211-1F745ACC44D3@oracle.com>
 <20230404183233.78895cf2@kernel.org>
In-Reply-To: <20230404183233.78895cf2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB4654:EE_
x-ms-office365-filtering-correlation-id: 2ba42fa7-1bcd-44d4-ebd5-08db35e1a072
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qcx5xD7HkxsnXhN2aTRE0uYRlta2mCI6Xk/lyIT/wcyTY+XSaLbQcCo8B+rvEhsdPmjkiH3k35+5B75eoQnOwKpKwAxvnu3o+yGR3eQd0ICIunG/V+rE5YOyGmH7eOvh8bs9iG7rtZ07xq5qcv4ItdIfjgha8+G6o794ZbIVqiY4KmAW7iqjV42pqGE0QB5QhtfkMGzBn2X/oqahA8KqFWG+VfeI/ZuDl+zTJz2J8EL7r4DfqmLshh1nw6/Wv9El1Tz3JZVIVR+2xj9fgQoallaHhoMRUWH9SaTRzp6baCjxWiJ8jMy9eu+quo86D4GUuCWHinYIyeIKHLPwdn2cbDgQJa7zZF5s2FQiJdlwQ3s2r2gYBGmvBtI/rZuMnZyKZAIToP/XBxC/sjq4sNS/RzOtEFniFK/EN6/4XJt3oMuYUN7O25RMamf9IZDNPUugql8u8LNwULQHiPaXQIFG5Ra5/ltEN9xY7Ed450qK8QcAyluct0uUiAZGkBa7rYBkIT81qrpH29L4Rmd7OxBwrvwTJUW8zFbCFBHKfYOEml3Pf24xYYxjSPz9eEG6ZSBE7RZ3cJezlypGPvLVgYbnlg8psmhLnzRmrKGsG88q08LY1qty5/w+nLKjYoMm7HFkUH7TEV/IsgV4ZweEekwYJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199021)(478600001)(8676002)(4326008)(66476007)(6916009)(66446008)(64756008)(26005)(5660300002)(6506007)(7416002)(8936002)(316002)(54906003)(38070700005)(6486002)(41300700001)(122000001)(91956017)(38100700002)(71200400001)(66556008)(76116006)(66946007)(2906002)(83380400001)(66899021)(6512007)(107886003)(53546011)(2616005)(86362001)(33656002)(186003)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDJjbkpKSStUSjNGdTZuTkdiV254Z3pJTTgwNTd4dE1iQjZvVUhvN3JEeXc1?=
 =?utf-8?B?cTJkRE5PRGY1ZC9UVzRaMCtHMVFGTUZmRUlsUHFBSjRPcWJzL2JaK3pUa0xh?=
 =?utf-8?B?U2R6Y29IbWhaaGdjVmZnNllDRko3U1pzODlYQTFseTY3aEgreUczWHZQYzBO?=
 =?utf-8?B?SElmNmRhK1RaR3BvbzR3RWhBbHFFTG1ZMnhYSXVkMWZKcFJOTkZER3J0TUh5?=
 =?utf-8?B?S2JUV2lNZVZSNkZ0WjVUTG1CbUxJazcrSTFhL1FURkxZMGgyTE9GMjk5SzFa?=
 =?utf-8?B?c0grVGpxWjlzN0prQllSRm5JSXVrbnlibkszSHNzTzRtdjVVa3lCZ3BKb0dL?=
 =?utf-8?B?bkRjaDN5Myt4QnQyOU9iaWp5dmZjVmFvc2pGOGtoYXRiQ21Dalg3OWVjd0JN?=
 =?utf-8?B?YXZqNCs5K1V0MnR3MEZhMk1YSlUrVEw5R21LNEFkUE9wRzFzR0ZraHZxenRB?=
 =?utf-8?B?cWV6SG9BOVZRKzAvMGp4UUF0dnVXUnRKN2tIVlRhVzB5WTNVYVNDMG16YkJm?=
 =?utf-8?B?MmxNa2RrQ216Vm9FWWszcEdJdUZQUGVXUUJKbDVCanYxTm4xcVRzczk5T1J2?=
 =?utf-8?B?YmlzWHpzTFh4WGdOaUJLQ3N3UWdNMjRmZGN1ZjFmQ1FZdHVnMnQzaHlDUkYw?=
 =?utf-8?B?cUdVSUlNLzllZG1WSFdWNlJONHNaU1Ftb3FKZm5odUovVnptTHZGN2lmNXQr?=
 =?utf-8?B?VDlML1c4UVBDdHF2b2ZFRjU4c1FKM3VYYjNST1loaXFsdzZ4Z3NUYTdKTzBp?=
 =?utf-8?B?VWVQZ1Z2VjViRitPRGVzQ1hUb3pLeUJXaEhpSndQK3RzSnNYbVBXS21UOXBm?=
 =?utf-8?B?ZE51bkVlbUVYSFJZMkgvWmVNek5KcFNXN1FhZnVCYm1UQW9mMHF4OGY0Y2Yy?=
 =?utf-8?B?a1BQVHlSaG9IUjRkR0ZGUzFTZGsrRWJUKzlZL1oyMVdmbmg3ZUZ6NUJjalhJ?=
 =?utf-8?B?TmxzRm8xYVI2akE2WU5HMVU2bW9CVm10cjJhWk9oaDZTWEdrZURRVVRZdWNv?=
 =?utf-8?B?eE5XNjQ2YTV3U2lUZFBweFU0S1ZSY1IwbnkyU3Q0TkdUaFlreThmVDdyS2p5?=
 =?utf-8?B?eDd5ZjV3SkFOWVpvOGI0L29OM2NvS25nVDhMZ2RUbld4TC9hSzkyNVRvTFd1?=
 =?utf-8?B?ZUxwRms3ai9RTzJkZGJYYm1uV0pxVEpPZHdnS3RMSndsZDRzaWdIUzN3RFE4?=
 =?utf-8?B?L1NsVkFJVkFla1dQMTQ5VEJSMStiaGdZQk91cmRIWTBWYXg1TTljN3YwNGtu?=
 =?utf-8?B?alVGOS9FTEFkT1VrWC9EclRoUGMxUDN1UzN1NWpZSTBicDVzL0NmRldaeHU5?=
 =?utf-8?B?TngyV1hiSnhUWmFHVkU4SEl2czhKcUVjNVN3UXVPSC9VbzVSTGxacHI2UzRS?=
 =?utf-8?B?bGZ1NFlrR2N0S1BCS1kreFVEK0N6UTFqSHdMZDM2MGVjKzQrbFhGbnNEMS9R?=
 =?utf-8?B?dUsrOGJJOVducU9kd1pnNitSUDM1V0tWVXlVYTFEODJOTW1CbTMzR3lFTmxs?=
 =?utf-8?B?dWJhbFBYc0VJTU93RlJzYk9WM3Bqd2lqTmh1QkFwMGQ1OVJWb0VReXNhZUxR?=
 =?utf-8?B?NjJZTWNjbTRDOVpFdmEvbXlEd2k5REk3QXNQRlA3OFFVYTlRR1JOR1hyc0ZO?=
 =?utf-8?B?M0VXcDFBMWV3OGtYdXJOaTNPbjBENTJTSzJ0L2ttaDQvbno2QXhkelovaWpQ?=
 =?utf-8?B?Z2pNdjk2V1hmbFZESEJFbGt1bVhqb2tYZENnTmZ0OTJ1T3VCQlJRVkN4dGE4?=
 =?utf-8?B?Q1NJN1Z2bEI4UVB4N0tvSC9DZVppd0dJaDcybzI5dVZraWlWaWZPOGxjd0ov?=
 =?utf-8?B?T0tDaVFRZVVFK3FZckZ4WDBxYVMzdmpGLzZ0UVlXNDg4YlJXTkQ3NXR5NWpo?=
 =?utf-8?B?YWNQOU8rVjdGdmJOY0txekErNDlaVkZaTjY2OWFZQzBJUzVsbjBjUVE2K2d4?=
 =?utf-8?B?NGpSMUhuLzVFTWlLcXloTHQrZDFNSHZKYjZMYTR2bkFjVjlGREhNVWhhYVV2?=
 =?utf-8?B?aU8zdWVMYk1wRExEcWN3VzUzL3hkMjBXNzlnc0VyaERvdUFNb2FkaFFxTFl6?=
 =?utf-8?B?cG95TVp2QmpWVDQzdnpPdXloRTFUZUJVZkdweEFFUnlCOXdqYWJYSzFhYzJN?=
 =?utf-8?B?YUZWaE9FNFhpZVA5cjBCVzBJMFdoeGE5UEcvbnA5cG9EOEsxM2dvOTZ3L0k0?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFC0A17A7A8305478C8D8EF791295399@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UEFwZDRlTEJONERtenVlaVJrb0UwNExSZUdFSExEOTNreHRXczVXanN5UFhm?=
 =?utf-8?B?ZGJFZldsWCtELzVNZUlITDdqbHFaYXcxTlFJRXNXblBzRUptL1gzbEZORDU4?=
 =?utf-8?B?OHZYdEp1MFR3SGN6VTlTQXFKckRDTm1GVEQ2NE9qUU9RSEJHajIwcE1PRWhV?=
 =?utf-8?B?N2VTR0JKN2Q3SWQxMmJJMCtERTdKUm9ZdzBrM3UvVFpGd0p4SXY0NkU3ZHow?=
 =?utf-8?B?c01nbi9UVGxNUFZDZFdGa0ZOYXg2K211WVlUUjFic0lPMWh4RGhCTlliejdE?=
 =?utf-8?B?SGJQTDhaOG10WXRHWUFqQ3V3VzhIQlZISG0rOGNLZ3hlMDhoRkRvNC9wbzg3?=
 =?utf-8?B?Mm90Q3B6Uk1JaG9ja1F2RzdSNk90MG1MNFZHR05LMmFLM3NxWk5ZbS9wNUU3?=
 =?utf-8?B?cFl3UDU0cmF0UW9nZjArSSt1UWFqUkt1RFVyVWJWN1BRWmNMNUxOU1EzYytZ?=
 =?utf-8?B?Y3QwMkZPcE1qeFZKZ01ZTGthdjd2SWNwUGkvYkM3S2lmWWp6cXhLUFp4Rlgv?=
 =?utf-8?B?Yi9Yejd2d1NmRVhpb3RGWWhrQnMzTTNaMFFBRGo1SG9za1k1UFQ1ZDg4dzZw?=
 =?utf-8?B?Smhoay9rQm1uYTNJWkxUMXRvWlVMcG9qWVQzMXlONDkzUExIeklOTDNvVjV2?=
 =?utf-8?B?ckpxZjM2L3FYbkNqY3U1bkJ5SHpacXV5eC9PK1VZM0F3dVlLY3lqaDI4SWVO?=
 =?utf-8?B?bkE4MWVucHErU1dPTXUvZFlTNUxvR1NxcTdub3dQc0wyMEZuU3BCQVpycWMz?=
 =?utf-8?B?UXpFeVcrZlE4RHgvN0VUMWxDSDVRT2tTWDFWdUtwWGtESjNiNUxYSUNGekFS?=
 =?utf-8?B?QzNCSWpmbWM0RFB6RkJGUEQyNXpTckZBQjV5ZHhvU256ZE9CSmpiS1FhUFhP?=
 =?utf-8?B?dm5PZERKUmZWMnh5WEFtYVhVV3pUbldaRy9oUEcyUGZQQUZCeCsvU2ZXZkNj?=
 =?utf-8?B?bVZQdmtoRnJJejg2MS9nblRWSDh3WUxCdzF0U0hEOEptdWFuZ1g0Tmh1Y2Fx?=
 =?utf-8?B?MlRlcVFLRTJ3a21vTUM4Q2dsM0xuelJhMGhvd3g2aTlhbXNoc1lteXNRczJj?=
 =?utf-8?B?TTZrbFpKK1psWXlNd2k5UDNHSEd1U0Z2NndpYnNSSEgzUTNURVpCMC9PREY4?=
 =?utf-8?B?aEpzRXVaL3c2bE5PSGlwR3pFcU9RZjhPRGJKUHI1V0NFa2I2aHRYNXBZeC84?=
 =?utf-8?B?S01DdGVBK1Nldk93Y0lIcEpRNFU0TXJTVkl1QTNPTS9XamkzbGRTdjBVeTVQ?=
 =?utf-8?Q?p5+da1P1daMGtGZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba42fa7-1bcd-44d4-ebd5-08db35e1a072
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 14:25:37.8519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QSgUOxg1JFX0C8NAraff+hcDX122KBOM9zPNr3/70g+wwmBb7eDu9j0aT2h/LkDGYuzIjp9EBLgkldi8VW1fPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_09,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304050130
X-Proofpoint-GUID: 1nNIguK3bvj285epiAAuhZ5YyFOfNCAT
X-Proofpoint-ORIG-GUID: 1nNIguK3bvj285epiAAuhZ5YyFOfNCAT
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXByIDQsIDIwMjMsIGF0IDk6MzIgUE0sIEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gV2VkLCA1IEFwciAyMDIzIDAwOjQ0OjExICswMDAw
IENodWNrIExldmVyIElJSSB3cm90ZToNCj4+PiBPbiBNb24sIDAzIEFwciAyMDIzIDE0OjQ2OjAy
IC0wNDAwIENodWNrIExldmVyIHdyb3RlOiAgDQo+Pj4+ICtpbnQgaGFuZHNoYWtlX25sX2RvbmVf
ZG9pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgZ2VubF9pbmZvICppbmZvKQ0KPj4+PiAr
ew0KPj4+PiArIHN0cnVjdCBuZXQgKm5ldCA9IHNvY2tfbmV0KHNrYi0+c2spOw0KPj4+PiArIHN0
cnVjdCBzb2NrZXQgKnNvY2sgPSBOVUxMOw0KPj4+PiArIHN0cnVjdCBoYW5kc2hha2VfcmVxICpy
ZXE7DQo+Pj4+ICsgaW50IGZkLCBzdGF0dXMsIGVycjsNCj4+Pj4gKw0KPj4+PiArIGlmIChHRU5M
X1JFUV9BVFRSX0NIRUNLKGluZm8sIEhBTkRTSEFLRV9BX0RPTkVfU09DS0ZEKSkNCj4+Pj4gKyBy
ZXR1cm4gLUVJTlZBTDsNCj4+Pj4gKyBmZCA9IG5sYV9nZXRfdTMyKGluZm8tPmF0dHJzW0hBTkRT
SEFLRV9BX0RPTkVfU09DS0ZEXSk7DQo+Pj4+ICsNCj4+Pj4gKyBlcnIgPSAwOw0KPj4+PiArIHNv
Y2sgPSBzb2NrZmRfbG9va3VwKGZkLCAmZXJyKTsNCj4+Pj4gKyBpZiAoZXJyKSB7DQo+Pj4+ICsg
ZXJyID0gLUVCQURGOw0KPj4+PiArIGdvdG8gb3V0X3N0YXR1czsNCj4+Pj4gKyB9DQo+Pj4+ICsN
Cj4+Pj4gKyByZXEgPSBoYW5kc2hha2VfcmVxX2hhc2hfbG9va3VwKHNvY2stPnNrKTsNCj4+Pj4g
KyBpZiAoIXJlcSkgeyAgDQo+Pj4gDQo+Pj4gZnB1dCgpIG1pc3Npbmcgb24gdGhpcyBwYXRoPyAg
DQo+PiANCj4+IGZwdXQgb2YgLi4uIHNvY2stPmZpbGU/IERPTkUgc2hvdWxkbid0IGRvIHRoYXQg
aWYNCj4+IGl0IGNhbid0IGZpbmQgdGhlIHNvY2sncyBtYXRjaGluZyBoYW5kc2hha2VfcmVxLg0K
PiANCj4gSG0sIHNvdW5kcyBvZGQuIHNvY2tmZF9sb29rdXAoKSByZXR1cm5zIGEgc29jayB3aXRo
IGluY3JlbWVudGVkDQo+IHJlZmVyZW5jZSBjb3VudCwgc28gaWYgdXNlciBzcGFjZSBwYXNzZXMg
YSByYW5kb20gZmQgdW5yZWxhdGVkIA0KPiB0byBhbnkgcmVhbCByZXF1ZXN0IC0gd2UnbGwgYnVt
cCB0aGUgcmVmY291bnQgb2YgdGhhdCBmZCBhbmQNCj4gcmV0dXJuICBhbiBlcnJvci4gU28gdGhl
IHJlbGF0ZWQgZmlsZSBpcyBnb2luZyB0byBnZXQgbGVha2VkLg0KPiBXaGF0IGRpZCBJIG1pc3M/
IPCfpJTvuI8NCg0KTWFrZXMgc2Vuc2UsIGdvdCBpdC4gSSdsbCBhZGQgc29tZXRoaW5nIGhlcmUu
DQoNCg0KPj4+PiArIGVyciA9IC1FQlVTWTsNCj4+Pj4gKyBnb3RvIG91dF9zdGF0dXM7DQo+Pj4+
ICsgfQ0KPj4+PiArDQo+Pj4+ICsgdHJhY2VfaGFuZHNoYWtlX2NtZF9kb25lKG5ldCwgcmVxLCBz
b2NrLT5zaywgZmQpOw0KPj4+PiArDQo+Pj4+ICsgc3RhdHVzID0gLUVJTzsNCj4+Pj4gKyBpZiAo
aW5mby0+YXR0cnNbSEFORFNIQUtFX0FfRE9ORV9TVEFUVVNdKQ0KPj4+PiArIHN0YXR1cyA9IG5s
YV9nZXRfdTMyKGluZm8tPmF0dHJzW0hBTkRTSEFLRV9BX0RPTkVfU1RBVFVTXSk7DQo+Pj4+ICsN
Cj4+Pj4gKyBoYW5kc2hha2VfY29tcGxldGUocmVxLCBzdGF0dXMsIGluZm8pOw0KPj4+PiArIGZw
dXQoc29jay0+ZmlsZSk7DQo+Pj4+ICsgcmV0dXJuIDA7DQo+Pj4+ICsNCj4+Pj4gK291dF9zdGF0
dXM6DQo+Pj4+ICsgdHJhY2VfaGFuZHNoYWtlX2NtZF9kb25lX2VycihuZXQsIHJlcSwgc29jay0+
c2ssIGVycik7DQo+Pj4+ICsgcmV0dXJuIGVycjsNCj4+Pj4gK30gIA0KPj4+IA0KPj4+PiArIC8q
DQo+Pj4+ICsgKiBBcmJpdHJhcnkgbGltaXQgdG8gcHJldmVudCBoYW5kc2hha2VzIHRoYXQgZG8g
bm90IG1ha2UNCj4+Pj4gKyAqIHByb2dyZXNzIGZyb20gY2xvZ2dpbmcgdXAgdGhlIHN5c3RlbS4N
Cj4+Pj4gKyAqLw0KPj4+PiArIHNpX21lbWluZm8oJnNpKTsNCj4+Pj4gKyB0bXAgPSBzaS50b3Rh
bHJhbSAvICgyNSAqIHNpLm1lbV91bml0KTsNCj4+Pj4gKyBobi0+aG5fcGVuZGluZ19tYXggPSBj
bGFtcCh0bXAsIDNVTCwgMjVVTCk7ICANCj4+PiANCj4+PiBObyBpZGVhIHdoYXQgdGhpcyBkb2Vz
ICh3aGF0J3MgbWVtX3VuaXQ/KSwgd2UnbGwgaGF2ZSB0byB0cnVzdCB5b3UgOikgIA0KPj4gDQo+
PiBQYW9sbyByZXF1ZXN0ZWQgdGhhdCB3ZSBsaW5rIHRoZSBwZW5kaW5nX21heCBsaW1pdCB0bw0K
Pj4gdGhlIG1lbW9yeSBzaXplIG9mIHRoZSBzeXN0ZW0uIEkgdGhvdWdodCBmb2xrcyB3b3VsZA0K
Pj4gYmUgZmFtaWxpYXIgd2l0aCB0aGUgc2lfbWVtaW5mbygpIGtlcm5lbCBBUEkuDQo+PiANCj4+
IFdoYXQgZG9lcyBpdCBuZWVkPyBBIGJldHRlciBjb21tZW50PyBBIGRpZmZlcmVudCBhcHByb2Fj
aD8NCj4gDQo+IEkgdGhpbmsgY29tbWVudCB3b3VsZCBiZSBnb29kLiBBcmUgeW91IGNsYW1waW5n
IHRvIDEvMjV0aCBvZiBhbGwNCj4gYXZhaWxhYmxlIHBhZ2VzPyBUaGUgcmVxdWVzdCB0YWtlIHVw
IGFib3V0IGEgcGFnZT8NCg0KQXMgdGhlIHNpZ24gc2V6LCBpdCdzIGFuIGFyYml0cmFyeSBjYXAu
IEkganVzdCBwaWNrZWQgYQ0KZm9ybXVsYSB0aGF0IGdhdmUgYWJvdXQgMTAgcGVuZGluZyBlbnRy
aWVzIG9uIG15IHRpbnkNCnRlc3Qgc3lzdGVtLg0KDQpBcyBhbHdheXMsIHN1Z2dlc3Rpb25zIGFy
ZSB3ZWxjb21lLg0KDQotLQ0KQ2h1Y2sgTGV2ZXINCg0KDQo=
