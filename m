Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA656BBDCA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjCOUMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCOUM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:12:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0889C12CC0;
        Wed, 15 Mar 2023 13:12:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FJn4MA019890;
        Wed, 15 Mar 2023 20:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=gpaCRdJVQzXSVP8YC4+INRDF+ZkppA/xp6BNBbpmTWA=;
 b=vjGvprr+mYAr1M2x2WMuDuD06q7EG/Gws2JCK5HKwwzuFRZNusMfyvtJQtTq0OJCZdfC
 vC3fa2odmfU7zl1JZG6r1clgwZedx8eocEV0xpvasMrF/d/7O5Yz+7fwvQJtkJmKSSdr
 OZaHw53Yl3WkrJB8hovo50OFM29WqxdRdZ+6WK1NEJsE9IFtYE97+5rRJsPWdSmONMgD
 wmRNjtuTIeLb+4aK7zFAO+j5oV85rmNvKt+j6ja6807nlRkjRrV8uQhP/HEpH8W5y2tc
 Dud3dZtsr3j4D5L1AcY6GbSwyIzISg/5QRQOywwa+denpJxDc58EQg6o7tAxNM8FhOlQ 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2u32bwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 20:12:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FJXpWJ001387;
        Wed, 15 Mar 2023 20:12:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2m3vgvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 20:12:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV92S5Z6i6i1r3zRwXCfERf+jzkaqkYBTcA7JYM1DttltVyhdC7F+3txMVrAgx9VS+P7vsphxeptDQ311yvnXwYi/8r5D9e9fIkEWAHwVDpiFB/U8PwEUJ7TYSXxNLxMTA/JfAffTeJKToc3rFlzhuDjDqUXn767BPDCcI4SFx+Z1qhfoeS5Vv09K5a1DNmI0PVb+3uU7lLtObuycYoEuOj9LvkFYG8aun0dYIsh6Y1giEZDATM60qkD4bGIKfEyw2johl/pq8nGVwVWFrMj0pEVdp1GG9Vr2dhkBdUs9tguMFZuqPIMK6rHWf2RT9r90geTiwk7nPiuNX964FonzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpaCRdJVQzXSVP8YC4+INRDF+ZkppA/xp6BNBbpmTWA=;
 b=Mdygk/BbX3h+QuW9PI6KyJT8cqYbGYXAeVaxcGYGKEya8din4g0meZpkBl4NURJtibyMOe/V+FXs+x2mrEJpnsPKIR+5QbfwQfcIiekzkyDPUJa6FzSaqBHAnE1iUNNDQgtUBiu+RccgfMBUv81vTxrCYEQlzXa7nqQRzRtOprMHuv3FVVMVper8ahqhTIy3NUD+ycsGTT0kjZPogqHcOXMTZ1Nm8BZKdg3P+APrQDwnup/FSJDCYZmLdIE0PVacXqWUKXYh+0s/F+XH3XpP21zNQvBkzpmZ9ZKfJ/cKjucga2xufMFjMtreAZsSpMaT8L6Qgg2xr/ui0y6dX4u1LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpaCRdJVQzXSVP8YC4+INRDF+ZkppA/xp6BNBbpmTWA=;
 b=X+pQgBW1aBmFi/1JGXvSolEKvVzTrVQ8kuMOr2NsgU0jSx4nJKW0Oud3lpoS10XCpK8JKcQvrYAB/mSJjdHHo8Pnh71S9nNWYSkHbdpPB+8dr0UqEZeT/A//ZAulBxumZXWabZW/MO4HHFsWD2J1JjBxyGF0gZ/Wv5G74ilc/rE=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 20:12:01 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 20:12:01 +0000
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
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Topic: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Index: AQHZU53jvr0f3jRxyk20sGUEtokB+a75b4CAgAAhVuCAAb3ZgIAA7SeAgAALmgCAAAYfgA==
Date:   Wed, 15 Mar 2023 20:12:01 +0000
Message-ID: <D1BAB522-682D-436D-B542-C4444918189F@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
 <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
 <20230313172441.480c9ec7@kernel.org>
 <BY5PR10MB41295AF42563F023651E109FC4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
 <20230314215945.3336aeb3@kernel.org>
 <F553A86D-966E-4EE4-83FB-DB42CD83E81B@oracle.com>
 <20230315125004.5b203529@kernel.org>
In-Reply-To: <20230315125004.5b203529@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|CO1PR10MB4563:EE_
x-ms-office365-filtering-correlation-id: 14f3ef02-ad9b-4402-81e0-08db25918a02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jGA/+r13aV/CQPSzOOi9N/gzWz3Z1XPkqAQbocwgprjYC7+j8YgnC+gRbbhSz+4DzDbl58Z+R/dmcBP0iV+nGNauTVMfRgb79d7h3I5KI2Bio5cpYV8tnn3Hf1Ko+Go6oEWgXGQ4Sdvqy6zRl4SXxrIfcF9pLD0f37i1z0hBKI4UlGHxQW8C1UlYVUaE5qHdefePjBQmmkoNuWSEgyKbpj1xDAyE5qre8ju4Bf9OCk8NcSsGg7mh8o038DUG+dP19khIdURGirJvNwdFHYN+AhC+HiObN8I+DdSCD7gNclHx/O9nX9t8EYrRfQtkXvvYWOKwbl44qo5FnJ+OcCwrDQfAO/51iyjf0WxaN5dzRxrsibhlg/0CQAvri4DbaIx37Db7oExDtpEbW+O5m3vpghfPFpZy4vxOuoqc/TpozFen7Eo9o288LFz0RfX/bVXpzFH51+uvDx5bg6FMsTDCDOkEiFPrNh/IMfZKOXKf7Vv1Mn+3n6mdEvxfckgsNJCckZFdci2vMG4hRWI/31t7Zwb4wZB6ZskxFvLPZAq10nXkTaKKfN3K3xnWHmH62PaiZqo5duA5y1kmqhUBsK0lFrRT4MtNM3FkK6KKWwls93Xu4a6lwuBr21gYKbTaY5LubMBAKAN/4c0vk0VRldnLp+L4OFOU+kRBOH2NACOBFOhfxLSWqm2Yaxj/zt8rVG6SOqSYGqFpL+7rZm9QifNZibgNh7b56XU/qMJWDi275uc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199018)(8936002)(66946007)(91956017)(76116006)(6916009)(64756008)(4326008)(8676002)(66556008)(66446008)(66476007)(41300700001)(33656002)(36756003)(86362001)(38100700002)(7416002)(5660300002)(38070700005)(122000001)(6512007)(6506007)(2906002)(478600001)(83380400001)(6486002)(71200400001)(186003)(316002)(2616005)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmZLczZvRmFjV3BDdGxTWmxaRGNaTGFqcm1lWVEyOGtvVklxTmFvSkdnSjNv?=
 =?utf-8?B?R3lsMWdTVDRVc3FyYzRZbWJlSzIvdGh2VGphaG82WS9PMU4zUkY3d2xDdG1U?=
 =?utf-8?B?clJoUXRDREZZWm9UMDZuaU9ha0k5TkRQeURDQjE4RjE0UVhYakpjdm9MVHps?=
 =?utf-8?B?eVl6VWhYbVQza1hkbUI5ZEhZWTIzb3ZHZFBndjZEL1FGcUVMWmlldVpSTUFB?=
 =?utf-8?B?SXJoOXFIOEcvc3ltYVVEUXB1WlZGVlNXSmRqNGlRbXBBN0lPemdxNURlWDB3?=
 =?utf-8?B?RjBNcHhJTG5ZVWdWMUcyZ2hkcFJ1MC9PZEdjcHVOY3hZSHdJWFlVTnJ6WGQ1?=
 =?utf-8?B?VVVRWkZEcDhOWlpLVE1WQzNzZmdNeGJiOEZrdEsvNmJ2dUJqTXY4bVU5R2ti?=
 =?utf-8?B?bjgyeVBUaWFsMFVVbGtXWmpRNkwwS3NoeFdETXB5UHdmVjNVd3V5YU1ST3lM?=
 =?utf-8?B?L3k2Qlkxd3NweDN6V3dOZHZIV2ozRGU4Rk5zQjJKVGpvV0xlN3RpRUNmQlNU?=
 =?utf-8?B?Sm93dHl2TFZ5bTZSSnRhMFB0ZmZydUJyMDQ3RFIzSVJ5Q1B4OHB4cWZyUjhN?=
 =?utf-8?B?N09mRmdNNE8zNHlOM3c1dGorNU4zNXJjNjkrSndXREtqZGlwb1JiOHhoWGFz?=
 =?utf-8?B?aTE2REo5ZGZHUTI2cFdyaFNBNUVsNjlRWkorTTdDTmJsZGM3NUxVQVY4RWNP?=
 =?utf-8?B?eXhmTmJEeVY4eVJwbmNKSXpOMWhMajMwbDM1QmptWHpaSytOZTJIcmRhSWVS?=
 =?utf-8?B?ZldUMFhnRWFmQnJNMG5xYlc3Yit3TGJ2WU9uOXgvRktYWFM3TGt3RmEyZUht?=
 =?utf-8?B?ZEZrMTFGOUhnTU9Bd1p0V2dNMVVmQkx1a2k4cUEyclNzTHdQUU1HRzNocm1y?=
 =?utf-8?B?cERLenZtZFZJWTBOSVZTOHMyd0FMeXBoTURPT2djNjRvM29YeE9aKzQ0VElF?=
 =?utf-8?B?NVI1M3V6NlYxYkJNNDgzTUZvQ2R0RDQraXplTXlLQ08yQ1JreEpUSGlTZlB5?=
 =?utf-8?B?czNCUzVHVWtjTEgyRHRpOEQ5MDVCcnd2VWlQT3QvbmovUGNTNnhTV3JsZmlH?=
 =?utf-8?B?UnE1dXdZelBRazJnSk8za1JsaEh3OHZZWGRZQjJFeDRVWVFnMDZ4UGpEaVZo?=
 =?utf-8?B?ckJEYXIyb04vWE1oYzhXbW0vQW9uZ1ZuRlZ5M1FLN2VXUHhHWFhrdmg5aWRs?=
 =?utf-8?B?N0NXMzlheFd4NXp5L2tEM1RLcFFCaFRxYmd5VytPVGpRbHRQRkdIRHRHWDEw?=
 =?utf-8?B?QmRubWwxWmVkZC9VSmI5cUlLYkU0WC9LRWdyaDNUeStCWmxISzh6aVk5a3Yr?=
 =?utf-8?B?eENPcys2YWd4UVlWT3dNTnlubFkyTnRQMWpjVnp1NkhSd0VZSUdxaklJeVFu?=
 =?utf-8?B?ek83Q2FQQVF0NC8yRk4vbWh4UHk3ZERoZk1QMExEaEpYNmxiandQVGhzRW5t?=
 =?utf-8?B?K1RMbjNJSUFiVFVYZmxQS3lDMW91b2xrZFpNVnFFMTRTdVdzWTl5YzRWbUY2?=
 =?utf-8?B?WVVIVUtHNTRNRmFUSXM4TDNBWEFnZjhvQVhNcWs1c1BwbitlRU5PcmUyV2lS?=
 =?utf-8?B?aldCQ21OYXR1SURFWE8zUXlCSTFQNnBLWVloazFLMUkxQXRwUzBrZ0tZOEYw?=
 =?utf-8?B?Z1U4Q25JTE9DOEV3VVk0SDdKbGxPT3F3SDZpTzV1U29LKytHNkNrY1BtSWFQ?=
 =?utf-8?B?UzR2VFFTb0dBdDBhd0dkdkVJZUtvVkFTeFpDekJwdmFxdVdrYkFVQWRQbm9s?=
 =?utf-8?B?NUlmR2RyN1NOWkRib3VNZVJXakJtaVlhbDhIN0RnOFNNTVBXdFNhcUdIcERH?=
 =?utf-8?B?TmpBWGxXM1oxTWlPc1lOVGZBaEFNU05MSVZubG5DZ25LbVBUcGMvZnM3aW5w?=
 =?utf-8?B?c2tzaERlMExrQmRxeDl5Q25BNDhrUm5HMm9qbDcwWEErR2tITWNaMUNkSnV0?=
 =?utf-8?B?clNxbkdwellvN2RQTjhJdG5BOER6OFcwT0hkY3hUV1orZ1JGN1RzeXRKUHRm?=
 =?utf-8?B?aFZFS2pxRVl1Rllkc3FUeEExSlVWeFhEMjZIdjNQU1NtM3FHSVNoU0tvN1Q4?=
 =?utf-8?B?bERuWUwrVHJvSDlkaUp2NWtDaHNIRDZWWXdqT25CelZLSWhKcU9IemJjRkxu?=
 =?utf-8?B?WDJMYjJJK1ZPVXZ3cS90UFRmK1lFVGlyY2hpZ25MbDkwMXI5N250Wno4UzFE?=
 =?utf-8?Q?l18wHbCTps/VE1EztOKdXJ3KU1q+mF+AjUS15zRAmv6a?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D542D9CDFBE844283CCA0E1045DB004@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bDBJVDI0eC90MzZTMEYzYndFVEtIMUZIUVlmWThNaVl5Z3lEUEx1TjdrOVRT?=
 =?utf-8?B?QUdocWFxc1NmUDArVXM4SEFXa3V6ZThpUVcrWHFLNVdpdDFuUU4wNWdwV2g4?=
 =?utf-8?B?OGxkRVV6MmEyblVoOEs3Mlppblh4TStORjh5YW1Id21IV2xsaTdiRnZWbHR5?=
 =?utf-8?B?dTBScW11UnNwRGdBWlNFdWJFU0pORXFlUndXYWIycTJJK25uNkNIdDNsMWRm?=
 =?utf-8?B?cVpUVHczbTRmV0NublUzOURoMW81WmovcTBndC96ZmJKQnpVbEt6ckhMaFRh?=
 =?utf-8?B?cWZKaXF1Q2RCeVBBUG93dnUrYzI4VVZ0MEFiNmpCZ2pndVlpSHZjU3Y3RXpH?=
 =?utf-8?B?ZjZlRDJ5Z3pxempjZ2RQSEFKVnFKTXJtQWZUS25VZUFCS3F6WGFrQWNlNENq?=
 =?utf-8?B?dVVTdE5Id3pLWWNpS0kvdGNtTUZKQVV2Tmg3ZUsxTHlsQ3VzRzJ6VThVakpZ?=
 =?utf-8?B?dktINzcwSWh5R284ZEZUQ2xrcEt5ay8wM2hWalV6aENvbkd1ei9FRFJEOFM0?=
 =?utf-8?B?ZEFhSTFTRms1akZ4cFF5Q3Z3eG05U1E2cXkxd211RU1ENEhFSGdVVG5EK2J3?=
 =?utf-8?B?VlZJSmVTVUlVSXQ2V1VKMDJ5NnlOTmQ2WEV4amlqOGlWOThmeEFiMVVKVE05?=
 =?utf-8?B?eGY4NCs5UWx3bUh4a3JWdEgvM1pjS1JtWDJDSzNmWUIveTdmOEhYa0Z2WWdi?=
 =?utf-8?B?ZDAybVBUc0FVbFN3eURmbzd4MU0vMkRLcTIyY09vbmMyNDZub2tITXJmUCtY?=
 =?utf-8?B?b0c4TkRPLzk1bXQyUktuaUJ5c2R0VW5ncnY1cGFXV3owYmViSTFhYmxJS3Uz?=
 =?utf-8?B?SStjcHpldUJWWGdXZUxZaVQ0VHdVRVJqOXYyU0FmMDJrRUdyMTJ1TmlCM2Zi?=
 =?utf-8?B?a2hpdGd6aXY2Ynpib3FiVWdwMk1sRDVYd1FqZ0RUUktwYUJNUW1RY1NSVFpW?=
 =?utf-8?B?TVVCL2ZCQit0MXJLM3hvSWU0YXErajE0LzVBcm5lOHpJa0hhYzdlZFQ1aHBq?=
 =?utf-8?B?ZmlnNVZxSmtheWNGQjh4Y0ZRKzdQQXdiTkFheXRCQVU0ODZWNEphNjVFY1kv?=
 =?utf-8?B?ZERuVTlXNUJuZ1ZZK3BXYzhMZnQ5bmZISnJsMi9IUVUzY2ZKbXBZUG9qQmNx?=
 =?utf-8?B?Z3lSZGhucXVBU1RPSDdoRlZmQ2pGK1lDU0pZR1V2cGQ0a0kyVkZFUmhJVmJQ?=
 =?utf-8?B?MjdMNWtuNkNJcVNqOHVnbnFCTnVYUmxEaUVpb2RDaWNQOEpYdVRYYW1mN0Nh?=
 =?utf-8?B?R2hkbjBnY0Q0STl2cU1rdHRZSjNNTEdjVXM0cVk3ZHdnOUNuZkZXZlM2eUMw?=
 =?utf-8?B?amJiOEJlS25ZNEpwRVU1cUptc3hSRUYyRnVYbGF3N2FUM2FvbXN6Z1RWell5?=
 =?utf-8?B?Skdmd2dNc0JqR1doUUh4eHJqZ28wemFVaU9Ma3ZzQ2xCNjM0eGx1TGkwNThF?=
 =?utf-8?B?TnpBT1FhVi9lTmFhZDhKUS9hOEE5MmJmNUZBWjVBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f3ef02-ad9b-4402-81e0-08db25918a02
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 20:12:01.8650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZnZdMPWwVqy9GhTCa1tt9dbXdICHNrBbF0eXXw3zvu/TZ95EFMEI18i13Ru/GmkKNOKUNFBUVw91J1yYYlRCqpRotyB/67CThxsqXbYsN1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_11,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150167
X-Proofpoint-ORIG-GUID: w3_METgp3F4_4wc2Afp-a-FEuGJeEqsD
X-Proofpoint-GUID: w3_METgp3F4_4wc2Afp-a-FEuGJeEqsD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiANCj4+IFRoZSB1bmJpbmQgY2FsbCB3aWxsIG5vdCB3b3JrIGJlY2F1c2UgaXQgaXMgZm9y
IHRoZSBjYXNlIG9mIGFkZGluZyBhbmQgZGVsZXRpbmcgZ3JvdXAgbWVtYmVyc2hpcHMgYW5kIGhl
bmNlIGNhbGxlZCBmcm9tIG5ldGxpbmtfc2V0c29ja29wdCgpIHdoZW4gIE5FVExJTktfRFJPUF9N
RU1CRVJTSElQIG9wdGlvbiBpcyBnaXZlbi4gV2Ugd291bGQgbm90IGJlIGFibGUgdG8gZGlzdGlu
Z3Vpc2ggYmV0d2VlbiB0aGUgZHJvcCBtZW1iZXJzaGlwICYgcmVsZWFzZSBjYXNlcy4NCj4+IFRo
ZSBub3RpZmllciBjYWxsIHNlZW1zIHRvIGJlIGZvciBibG9ja2VkIGNsaWVudHM/IEFtIG5vdCBz
dXJlIGlmIHRoZSB3ZSBuZWVkIHRvIGJsb2NrL3dhaXQgb24gdGhpcyBjYWxsIHRvIGJlIG5vdGlm
aWVkIHRvIGZyZWUvcmVsZWFzZS4gQWxzbywgdGhlIEFQSSBkb2VzIG5vdCBwYXNzIGluIHN0cnVj
dCBzb2NrIHRvIGZyZWUgd2hhdCB3ZSB3YW50LCBzbyB3ZSB3aWxsIG5lZWQgdG8gY2hhbmdlIHRo
YXQgZXZlcnl3aGVyZSBpdCBpcyBjdXJyZW50bHkgdXNlZC4NCj4gDQo+IEkgdGhpbmsgdGhhdCBh
ZGRpbmcgdGhlIG5ldyByZWxlYXNlIGNhbGxiYWNrIGlzIGFjY2VwdGFibGUuDQo+IEkgaGF2ZW4n
dCBzZWVuIHlvdXIgdjIgYmVmb3JlIHJlcGx5aW5nLg0KDQpUaGFua3MsIHNvIEkgd2lsbCB3YWl0
IGZvciB5b3VyIGNvbW1lbnRzIG9uIHYyIGJlZm9yZSBzZW5kaW5nIHVwZGF0ZWQgcGF0Y2guDQoN
Cj4gDQo+PiBBcyBmb3IgdXNpbmcgc2tfdXNlcl9kYXRhIC0gdGhpcyBmaWVsZCBzZWVtcyB0byBi
ZSB1c2VkIGJ5IGRpZmZlcmVudCBhcHBsaWNhdGlvbnMgaW4gZGlmZmVyZW50IHdheXMgZGVwZW5k
aW5nIG9uIGhvdyB0aGV5IG5lZWQgdG8gdXNlIGRhdGEuIElmIHdlIHVzZSBhIG5ldyBmaWVsZCBp
biBuZXRsaW5rX3NvY2ssIHdlIHdvdWxkIG5lZWQgdG8gYWRkIGEgbmV3IEFQSSBmdW5jdGlvbiB0
byBhbGxvY2F0ZSB0aGlzIG1lbWJlciwgc2ltaWxhciB0byByZWxlYXNlLCBiZWNhdXNlIGl0IHNl
ZW1zIHlvdSBjYW5ub3QgYWNjZXNzIG5ldGxpbmtfc29jayBvdXRzaWRlIG9mIGFmX25ldGxpbmss
IG9yIGF0IGxlYXN0IEkgZG8gbm90IHNlZSBhbnkgY3VycmVudCBhY2Nlc3MgdG8gaXQsIGFuZCBm
dW5jdGlvbnMgbGlrZSBubGtfc2sgYXJlIHN0YXRpYy4gQWxzbywgaWYgd2UgYWRkIGFuIGFsbG9j
YXRpb24gZnVuY3Rpb24sIHdlIHdvbuKAmXQga25vdyB0aGUgZmlyc3QgdGltZSB0aGUgY2xpZW50
IHNlbmRzIGl04oCZcyBkYXRhICh3ZSBuZWVkIHRvIGtub3cg4oCcaW5pdGlhbOKAnSBpbiB0aGUg
cGF0Y2hlcyksIHNvIHdlIHdpbGwgbmVlZCB0byBhZGQgYSBuZXcgZmllbGQgaW4gdGhlIHNvY2tl
dCB0byBpbmRpY2F0ZSBmaXJzdCBhY2Nlc3Mgb3IgYWRkIGEgbG90IG1vcmUgaW5mcmFzdHJ1Y3R1
cmUgaW4gY25fcHJvYyB0byBzdG9yZSBlYWNoIGNsaWVudOKAmXMgaW5mb3JtYXRpb24uDQo+IA0K
PiBBbHJpZ2h0LCBJIGd1ZXNzIHdlIGNhbiByaXNrIHRoZSBza191c2VyX2RhdGEsIGFuZCBzZWUg
aWYgYW55dGhpbmcNCj4gZXhwbG9kZXMuIE5vcm1hbGx5IGhpZ2hlciBwcm90b2NvbCB3cmFwcyB0
aGUgc29ja2V0IHN0cnVjdHVyZSBpbiBpdHMNCj4gb3duIHN0cnVjdHVyZSBhbmQgdGhlIHNrX3Vz
ZXJfZGF0YSBwb2ludGVyIGlzIGZvciBhbiBpbi1rZXJuZWwgdXNlcg0KPiBvZiB0aGUgc29ja2V0
IChpLmUuIGluIGtlcm5lbCBjbGllbnQpLiBCdXQgImNsYXNzaWMgbmV0bGluayIgaXMgYWxsDQo+
IGxlZ2FjeSBjb2RlIChuZXcgc3Vic3lzdGVtIHVzZSB0aGUgZ2VuZXJpYyBuZXRsaW5rIG92ZXJs
YXkpIHNvIHRyeWluZw0KPiB0byBkZWNvZGUgbm93IHdoeSB0aGluZ3MgYXJlIHRoZSB3YXkgdGhl
eSBhcmUgYW5kIGZpeGluZyB0aGUgc3RydWN0dXJlDQo+IHdvdWxkIGJlIGEgbWFqb3IgZWZmb3J0
IDooDQoNCk9rLCB0aGFua3MhDQoNCg==
