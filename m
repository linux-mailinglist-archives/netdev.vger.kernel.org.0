Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F686D6B35
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 20:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbjDDSH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 14:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbjDDSH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 14:07:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8BE5BA0;
        Tue,  4 Apr 2023 11:06:58 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334Dx6xB002554;
        Tue, 4 Apr 2023 18:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9zFJeX7d/Xih4EytaE4d0J5IlLpnQbffKbVcx0UjZMg=;
 b=etdrLTkt1yMlK+QkbO7ehi9Partbv6ZP7/y5klMMNSkZPa/zWJh8aj9G2bG5rVCXWXgp
 YGeR5PB4z2eBY4JqFKxAVKIQkt5B288Ivv4hBrJVv38jMU2+xOOPPpmqdQFq9eZonoVr
 jfP5qX4OpoYr3s8K3OtZqMtZpnKRPp+5IxCpvo2rdygdR3Vvp+9sCu0fcRXl8RBbG3l5
 qNeibUg70SjdgZzuM22vnZ1RNy2OQ7AmygwS1b+D7mjsO9WKiXAl3GIuBChMPA+V4ApT
 iDdvFwE5uvzkiPenXb64dV4mQep8kPHL2J4HOawFcLtBG9B1OHjHyQCs/mKj/rJk359K Cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dpgu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Apr 2023 18:06:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 334HXcLE039448;
        Tue, 4 Apr 2023 18:06:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt26rq5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Apr 2023 18:06:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRIxIzz2uRlBCAMabxmVy3Pn54az0Zm6swLoC00VWNihSlgRHaTe+mMUV1PN8WDHdY2tOnGH2gAA4xUeh4jRYtW28dlTkOmfD1cRKVTekdvy8LIp05Zr4Us3+3UP7bpnKmxPbzkyHgpFYu38U6YNAWbv4EyOZOkM39aqqLX+L+qS16wKFtGDkMNTx3MRjjlQsIYbheGmyEYK51/m7dFIBFix++r+cjLhq3019pVgcKuwJyJfVEjeNstlWW3OedcJ6GPjLa9qfY5JnMX3yv4mOgS5aTr+IVEaolw0bPCSY/w7IJ51rO4lEvdPB03vJY9JUbB/dXAkjHC5yGAyfLk9Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zFJeX7d/Xih4EytaE4d0J5IlLpnQbffKbVcx0UjZMg=;
 b=Jmrt7CIOaE0UEMO83dMqWe8mvzFZQeGJ+8fMZ4mAi+1fHzFE4b86PVy2ey67wLeVbaCQ+qd+KqPDniprCkFXhsc9dy5i0k8pH2RBuoGvihqNfy6orU31WoGPhjTOcyS6GX7CzLy+F8OsFn7p0R/NhDC/Yw40bZ4sKauJ2PZZqluTtJ8rv4bC8MIF09tQT0sCF3S3/3LClEN93kSIysuK/TZkWqp9bPlDbJ5Gr/Fwlatu9nEbVmY7ZL98pNc85vovKaXHhSDpo6IgtsV997TPkdLxAki23Dx62y5YjXKnA7BUgZpe/uWDmTPcSE9gSPxXYIJoqFnE+CU1oB6u5q63ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zFJeX7d/Xih4EytaE4d0J5IlLpnQbffKbVcx0UjZMg=;
 b=JZCwMgrxoPEFE76Ewi5qVDFCBz+x2EkeMH0O6bs+nFI+OZz0C6wbKHM27dm8uC4BSihOPGP1lhMgMdpVTxGJRsjh0DnLFB12ie6aSjcDym9oyCmt+Q2hkqNGLeg4FBcV+iOPlt5gkBiZiTTR2WDlZEoN2tB6Ml9KIYC+WUuGfmA=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 18:06:02 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.034; Tue, 4 Apr 2023
 18:06:02 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAAevWAgALFEQCAAWR6gA==
Date:   Tue, 4 Apr 2023 18:06:02 +0000
Message-ID: <CC331DE1-DB40-43A7-9211-6DE08837F717@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
 <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
 <20230401121212.454abf11@kernel.org>
 <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
 <20230403135008.7f492aeb@kernel.org>
In-Reply-To: <20230403135008.7f492aeb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|SA2PR10MB4587:EE_
x-ms-office365-filtering-correlation-id: c609d0e0-66c5-40ab-f504-08db35374078
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hAoRfFiMBD+pA0bgloiWvJHYU+gl8nsyklMAtSh2XdkEni64CxjKFdBPcVwFzNqYP3OI/f/pC827DQv6M0PlhuMn0t/IWPLtC6Eit0U4rH5RvNX5jmIkFZSyqNKGmz1lr1jB8POWT6M7ZPhbxlikwJ81MEF/ju01V684xk6fY4RE0e+O7Ip20gC4+AYwNHyB7d3v6bX4sQDmbjbosclPm4829mSj/XEK1oJcRnqC3ll0CpbsaS7ZPrCpBPEzx1RonySsxuB2i04vh+4OwlCo3jc9M+Df84wLenNs3iTXdeBmnDhiltKtu0YU58VU/rgHLp5Z2nrOrhKnZnpintMSe9ag2OaYVDVWsDp9SRW7O+FN4aoLmIGmKC+MFH0r99YJ4WUDs/cA48WzVe2CBTRREDX+LXnTRodzpKOr1n9apNpuvcfEb28vkj1rrCzv3bMdeolwUN7UmwqgnGzLX3m2dfixMd1RbRiLu8TsoZxL0DYZTYVy/kGBhVML4j8UbgwI+TYG5mKhCdZIVNMee+cf7j5XF/jxl+ZBLU+XdhoLzDOGjJW3X2gIbRWASWsT0wXtV6tDK7lMtfw5LgSX2Lh1H5zXXYNFA7yxOxToqifybOWU5tgkLO1csDeI1Fxghwxa1x10nWbXe/ATgOc9gUJBQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199021)(54906003)(316002)(478600001)(76116006)(66946007)(8676002)(66446008)(66556008)(66476007)(64756008)(6916009)(53546011)(71200400001)(4326008)(6486002)(2906002)(5660300002)(8936002)(4744005)(7416002)(38100700002)(41300700001)(122000001)(86362001)(33656002)(36756003)(38070700005)(2616005)(6506007)(6512007)(186003)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AqhHTES4rwp/9lMLzrIuPQZF9rJmB8cRqpBqYTBCGUymD8FJs4WHmbCymBdQ?=
 =?us-ascii?Q?+7nKcgi3LJQOkWeXBpq7/msE6b/ysEYQHQ7t0jmP339j2wm12Xm3sh/OEa7q?=
 =?us-ascii?Q?FEHqpzGL83xfR6CC6HKExmzhO0NHyUJnGzUd4vJff2YyeUqd8dxff2yLiW6X?=
 =?us-ascii?Q?1jxa+xzxv74JigNFWMyW2kS/iw82bhND7sDGYZyD4WRN3MMWeoithjx2QfnO?=
 =?us-ascii?Q?eT6TOLTylX3BGR02WMVbP3JBOfRQIGB37CGIwRTObpEmwvv6QQtz9WbRrAVs?=
 =?us-ascii?Q?/hkHPfPx46RxKo2pUVuEP9d7ip/+13ida0zwL17nHk0rEj4XO5gQ+Ws7yJse?=
 =?us-ascii?Q?Mz6bK7MzoqclyjbLz+WKkFsWx/L+ySP92Rlhzm7kdeXTM0UO0ZqjiWJPAHSl?=
 =?us-ascii?Q?IszDrr8gqsaASwEvFN2/QlkekNmyeVkL9hRfJhSZEBuXatrlHl+3UmGM+g+A?=
 =?us-ascii?Q?rtcHUpEsx/Vzc0QwRVKoJgBcoGkr2/Wyo3cUmZ79dnSFsLWgzQl8tixwPU0B?=
 =?us-ascii?Q?oe5eGumFrbYItXYEC5wAERdSYXHOtH5UzxF/1qy3Yp7OpV6auYzXAraBMC/A?=
 =?us-ascii?Q?Zy2ljgSX+Jy131bx8UU7u7E0A+14Qmi0FQ3lC+5FH+utw4cD+jzQffq8UdV4?=
 =?us-ascii?Q?c8hI1gcIPQb5S2xkTEXG0DlUiKp3eDxqAsJlszCLFXjInWYzb+zv1NJ617as?=
 =?us-ascii?Q?HAD4OtlIAGlca7mSBDr7VHlU4e5z3PTycLPZqtGxSNoh5oGYXuLSz+joro4M?=
 =?us-ascii?Q?mvsnZyS7ZSKeNDCnYOpA26M1TyzmHjuZlyf+8l9iy1mxbY32lNvJ95I7dMVp?=
 =?us-ascii?Q?CXDp0ZCz1LyMN6mFkIv1MpfQrceroxBaLPGkOb1cXJiQtWMNceqx4eT/YumC?=
 =?us-ascii?Q?jfvf9aCyBPH5BHJza/ee2QQThHgteQOVpDCkIXrzq63l0uktpEzRNTtX86Fm?=
 =?us-ascii?Q?49Tb3oIBk/utYFPe8pH2hbh5a5qGu230RNiElweTjbxQHWjpUkUdXEuvjPIr?=
 =?us-ascii?Q?netWhFOENltu8CKr9piBVOobvqxQe3Ibezwglb53MnWxyyvfHvb8yVC1mxmk?=
 =?us-ascii?Q?KR0U3JxGTVLCJe7IyLV5iEppncgZMUygDEdMHAmiERdQdm8jLgid+OG1Vqtx?=
 =?us-ascii?Q?6fpbs5n1X3a/Z/2ryDrwzfiMDr7vqE1DadGgZoVA+23vRBns198fkhc1F57/?=
 =?us-ascii?Q?S7kXN3CUCRAtIKNvKPD9s6AF5UY++odXwic7w5HUDrvq75ctZAzBDvj6y8Fm?=
 =?us-ascii?Q?2AvaZtLT5Hmfj93oCy5fJis4JdrPybJWCFF2QzXaOFghLWXxQ74Z28X2AJCQ?=
 =?us-ascii?Q?RD1hWVXuduGvMVIVya0vFR2t9M/1BBSIhpp++KoGh1ErYyhpZjPoGLDyTrXu?=
 =?us-ascii?Q?K+wuOA9E2AvPtC932mCfXzKR3PLjoOBtvGfrDgBXavd3ptjV8tDbnea9KjXt?=
 =?us-ascii?Q?H71m+qYoq5wbuvB3mOXMxRCb7PPjkOBFjXUJrCxHKORLg6XxwKNUiaM5sOQ5?=
 =?us-ascii?Q?nDw1BT93eXq7S+yB5U8B/Pgrjg+4WrjL0SXSIN7PQzOw2vdKQbVj6XJ6VM2F?=
 =?us-ascii?Q?UyOlqH0LSUaMBRmvB+JQVc8qqy1xfyRGjo4OcTJQXAgrNZyliFC5TkhLijBM?=
 =?us-ascii?Q?VxFHL/wwV93s7apyra2NxRJdfjKNTXUY+mhjBo6absPu?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <45F3923DC3BEAE469F35E1ECD20D89DF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Tl8r2Zhwe/7/LDkHCbluC1AfwDc1TZ2zDDM7BJrXY+eg2f6yJ7z6crg+ADQw?=
 =?us-ascii?Q?j4K7PNws/z7QEEY9giwvgxhe5G/mwGV39NXDmcLEKjsffzHc1Ymth0MLJ4dP?=
 =?us-ascii?Q?gfUz83PWdw2kx0AQEc1+pEsegoxdocQz36kEB6rQEpaYT3WSGhlje8gx1FS5?=
 =?us-ascii?Q?Hf8k9Xw0LMqP+yXJT6t/CvE89OgwhUT+Dxhv/N28rqvlfJwLpfXaMjiW8Wi9?=
 =?us-ascii?Q?V052ifRVzZTlflSq73iN/PEIyR5KTB6b/71HoBh77taHWLEkpLm3tAyc+SsB?=
 =?us-ascii?Q?VviB4BiZYUXkr18uwDSIcIkXYyDeNdHVbui5NAveETMC5MVYBdqo6gHMM8Vr?=
 =?us-ascii?Q?rT+7Ikm77wlPZWh+6ZWcFIBBw3L6VK7r+CShWLqsUXfm3f+22g7iONxPB7I/?=
 =?us-ascii?Q?ZhCJUCE0uvba1ODhTreJxBdN6c7H+6v+5IGX9nhdBevR7UfPOCoWravuB/IJ?=
 =?us-ascii?Q?RNs5/eRtstxEwXTdfsXk6Iz6+jjQHWi6PkVEMr33X6qZIyaS0+2bVU49QArC?=
 =?us-ascii?Q?1bCADxkjxaEHpx89/SfZ51r1tXR+WFOdHIqzRgZyzQz4YCVL4i/Jw6P897/d?=
 =?us-ascii?Q?mmVhaGv+4uArdRUWK8Q8+5UqCkHHjDkN3PM8nr4sK7lAsOQoO9+Jaw1BdrJP?=
 =?us-ascii?Q?yMlHuA5r1iL/oVeK/pfymRk4TLTws28fPlEIeQPWo/v0W4agGysm8RDkS1zw?=
 =?us-ascii?Q?z7TOjp62hZ4zU1sv6idoh421pwqxOyWgig2cGTWc30ScKv0BTtmyQZRIerNd?=
 =?us-ascii?Q?gXV3SfvbaxgwVaSSuL2ZoSPSac5ykXRmr1xOlm2leeHqLx8n9pkQsqULAjHQ?=
 =?us-ascii?Q?rZwLh3xMPykUZLCDXai0V692YHKV1KsMarYnh0/SULPoe/xCdIPYsl2v1hfO?=
 =?us-ascii?Q?6w8S+YyXOHp0r3LbQP3duUFsfup0P3/7yKk+JfW5zmy+8sEZYmG+ZB7Ojg25?=
 =?us-ascii?Q?wuIMJomIZDqQtz/Z5n1z9TadK9/PDbCoAeITke4aYGtRHngcq7nWg4gwNKmL?=
 =?us-ascii?Q?l2NoCfwO2mMIfH9ktbt+b58T5CGnkz/XzZE9JYuWe/FZWWut5LwTCEGTOSCz?=
 =?us-ascii?Q?7EbdOZ05Lp2JNgiO8rFuvTdeAbb7Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c609d0e0-66c5-40ab-f504-08db35374078
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 18:06:02.4018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: huzqmvSMN1E4NF0Va0JOr5+VIvIaOIiKdoDhbaUL96xAOgU9lkBPhVZPw2HZodRqQWrj/vu/rvPpVojz2XFS8TW3fGYiqsPXMah+tvhNRDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_09,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=877 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040165
X-Proofpoint-GUID: GBlXsjiES1VFBa3PSmWFkRJDU9z6xwJX
X-Proofpoint-ORIG-GUID: GBlXsjiES1VFBa3PSmWFkRJDU9z6xwJX
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 3, 2023, at 1:50 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sun, 2 Apr 2023 02:32:19 +0000 Anjali Kulkarni wrote:
>>> Who are you hoping will merge this? =20
>> Could I request you to look into merging the patches which seem ok to
>> you, since you are listed as the maintainer for these? I can make any
>> more changes for the connector patches if you see the need..
>=20
> The first two, you mean? We can merge them, but we need to know that
Yes, even perhaps the first 3:-), since the third one has bug fixes which l=
ooked ok to you?

> the rest is also going somewhere. Kernel has a rule against merging
> APIs without any in-tree users, so we need a commitment that the
> user will also reach linux-next before the merge window :(
Yes, sounds right.
>=20
> Christian was commenting on previous releases maybe he can take or just
> review the last 4 patches?
Sounds fine too. I hope Christian can review these.

Anjali

