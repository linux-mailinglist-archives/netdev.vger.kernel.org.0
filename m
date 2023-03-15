Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2356BBCF6
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjCOTI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjCOTI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:08:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D0153291;
        Wed, 15 Mar 2023 12:08:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FHEFMu007812;
        Wed, 15 Mar 2023 19:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=aAwGO4JTSLPUaDZ5l9W88hS0g8lzGTmsa3KudFR+Kq0=;
 b=kmQVvDFp506rsZSiSQ8nct7PsrVyxnHh96zLirW0MIWaMv8p7dvJb38JI6ZWdvamFo27
 MEaOfLDTxGfpLffxdorg2YXKDpyijE6eNGJLRcN5wR5tgpZkZ9YhanuxIcbFN0PbYq+M
 I6c2XtcM/zbQRmMHgAbyIfmoMnQEK/Z496hUVO0a/GfH4GuCZ7uoXXSNwYPTAFNwoZIP
 0rR84eBAzE0SWowAI+4puPQHHOoPNJtR0TU0RX6cSu0Jl5/Fmbu2ol8NrQAxSU+C0GVB
 kx/9qZmjk5cOmX45aLnfpSj1Byy5/ebGRJY6DcSVjvf8RIEaSwnBUUXQVvEKdLJmYeyu AA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2bta7h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 19:08:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FIt66u001418;
        Wed, 15 Mar 2023 19:08:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2m3t914-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 19:08:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5oaXJS2oOcBkgbdIPsr65deV6iTvKWQ4Uixpal7gr+nRN3Ul7kog5nFwH999DvVQDHWCInqnrufuXue3QwfGd0xIRj7BsawzJh83iVB8tEgZPZTt5AKUE+Prdg1JvfzjlJv9ZqloqwkcW6MVbJ5vcMEZW/2QOh+m7ILR8SAI5uzvi2bNTJocU4fFLRJP4K5im8Dx72khxK8+qeYiWULN1neKgpYl3H+rRL3u/EAjEWbE96iyqBi1Blsyln6u6ttlERU1kHK/rC4eemPEOQVVeg7wMY+Vd8ELs/r26ZYBg2bce+AKj7zTKljhKQk+4KwJFkQcV5UtVvOzj1AKHncxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAwGO4JTSLPUaDZ5l9W88hS0g8lzGTmsa3KudFR+Kq0=;
 b=K/Bf54H28gqaxkKO2gb4mvMisnRg+Hv8VkMoWDudHeQeWMi04aMACiAj8KCITNfN2Rn2Um8FKVYJTG0U4SncfP/qOdsc4NqtOJYI/lWzBRmjElaFs4n4hMUXp/xvD84lNml2/EzqvMYvYWVVDxh70+eIAOvqmAannntAmfwU/MGjpmPUa91viH96qyvBv2hEi50/6aSuDEX6HTPNpkAJeKNIYOvPG96G+k+/XjTRhOjsbgWMeFpprI1H4E78hXSbwXw43M33vcDVU0UHqM87PhidCklGZBxCD5EJPRUrzTl0GIyL0S4kEzkK4FsvPrX/8EChZFLKUf88CVTY/vApZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAwGO4JTSLPUaDZ5l9W88hS0g8lzGTmsa3KudFR+Kq0=;
 b=jOVyoSqgC0yejg0kqzwmIGIVuSSBr43mZci6I3o4OqyHM4KBZJad8VvDTPRjbSJpkebMEM+nVHkGlKyl8SnzLROgxEuuJjPiwqPc3h4XKJj1W+nJs81yfnxoFERKFnUO5tcqT8Ml7YJRe3ujObxc8QVzs1yBt6L0LJUAMjHypSU=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by SA1PR10MB7664.namprd10.prod.outlook.com (2603:10b6:806:38e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 19:08:35 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 19:08:35 +0000
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Topic: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Index: AQHZU53jvr0f3jRxyk20sGUEtokB+a75b4CAgAAhVuCAAb3ZgIAA7SeA
Date:   Wed, 15 Mar 2023 19:08:34 +0000
Message-ID: <F553A86D-966E-4EE4-83FB-DB42CD83E81B@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
 <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
 <20230313172441.480c9ec7@kernel.org>
 <BY5PR10MB41295AF42563F023651E109FC4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
 <20230314215945.3336aeb3@kernel.org>
In-Reply-To: <20230314215945.3336aeb3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|SA1PR10MB7664:EE_
x-ms-office365-filtering-correlation-id: 43eb627d-90e1-4428-b9cc-08db2588ace4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BsY9GiPWWh42kqSVhiflDpv9XmQ1SMITVguaSPY/zuA4KJ+4kDVpYbN1hyWYUFnyNgt3FPYuk1zccQUmfinVldN4+eHJdDGxLqx2e8r4LU0jaX9b4ZVYXY0r6T5uw8iiSFw3RoyEd6/vBxVsMuR9gtz8qgAuagwbI4qGZMBTfX6N5RIGQQGB1k2a4xa51S7E7HHInXb1sU5JLnD3A+DUwGkOVYrTT0MjLLaK7pdileEBZz+PyXFESnlIv1TGZnbbfakIrl1f+TPJbxrK99sMUXqS05vvuFmAEf6kAObQJDwRzcOZY6sEUxk9xWU84/zqUx4Y9fCd1jIIXBQZRRHq4C8qcjeec+Q7PXehvkECGDkCrwTfw2yNT2OfP8inm8XDG8SCue5cDV5g6zvMIpYESFW9q9LCsjsCt48iHNz9s3HKZs5Zco3sp3wjgw2ZucHHYSNaYlYOPZl8WHmNDe9WQALXhXIxlORGy66TAnm0gvPXc0F8NTPH8p/fDibDIqXdxcDMD4qhMfvk3dlOkutwi0WBaVlYYkXGzCis3zS+XSmANuvcdoyRgGL1GmvNnco7w3HHnX/RdUKWOZjz5hDxHhSdst1w604VeXM7draH0yeAhp472pa8ODYJqaDPD5enYHspoobR3ByDMpQVGn290ZsVM7w+TIfrKznY4mAU3ivO/T4jurWqxblp4jnV0OPYtIV1HzOQ2n+PuQzVZ8Ad0gVMitunYPr4hM/r7LqjPXM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199018)(8936002)(7416002)(5660300002)(41300700001)(4326008)(6916009)(33656002)(86362001)(36756003)(38070700005)(122000001)(38100700002)(2906002)(2616005)(6512007)(53546011)(6506007)(478600001)(83380400001)(186003)(6486002)(107886003)(8676002)(71200400001)(64756008)(66556008)(66476007)(66446008)(66946007)(76116006)(91956017)(54906003)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDF1UkpYSVcvdTZlYXhkNGI5U1hhU0JaWWFLUU5sOTU0Vm91Q0ltSDJKLzVC?=
 =?utf-8?B?ajhVOUJkd3M2UVpRR2ZkWTZyQURSUjVMRWhTSVIyb1E0MG5LdXZuZ09LRjF1?=
 =?utf-8?B?Zy8zeXNKOTZWRnR4SjZ1dGNLcEpuNGVPOThpTWx1VDJKaUFiSnVBK0pkS2ps?=
 =?utf-8?B?RElXU2dlNTR0ZHh0dlYzR2pUbUUwd2pDMm5UZ3pXekJKcDdlb3pMOFc2Ulo0?=
 =?utf-8?B?L0JaS3gvR2VpM3dBblc3bWdNbEY4eGVwV2JRblF1YW9NY2h2MFpmZDg1NmRm?=
 =?utf-8?B?NmNMemFNcUk1aDhZMjFTQmZ6QUZoamx3TWxiR2gwR0FaWWFKOUVsYU5tM2tv?=
 =?utf-8?B?bjhWUlhjeWtUN1NTMXNLckY2cGdmVWliaFlvY2tkNVAvL0l3blVsdGVFM1ND?=
 =?utf-8?B?U2czeUNvdEhKWnZwTDRDZTFtYmp6U2ZPVE9wRGdTZE10RHRjVHVrYUYxaFBl?=
 =?utf-8?B?NEFqL2t0czNJUzkwSzYyWlBaaTVWTWhNNHBaUStzekVmQUVHNjZyaE1mdkdq?=
 =?utf-8?B?WERsU05LaW1LU2M3SWRuamF2bkVFb2hKR2F4QnM2UVhYd2YvdjhLQ2srNEs1?=
 =?utf-8?B?eFBVV2NrM3VpblAyOTZ1dmxjNTV0Si9ka2trVmh5UlgrbU1Md3VrSTkrNXBC?=
 =?utf-8?B?N0Nnb0dSTXJ3VmRscmFYSWRzSGUvdzNxeVhXV25ib09rQVYxOXFwM09kTmlN?=
 =?utf-8?B?bUdzVFQrTUlmVmlZMUp4aGxFOEpiMWhFSmh2eU92azNqRUFHQ0xhYTNFNDNa?=
 =?utf-8?B?VUQ2UWRadXVuT2R5SVk5dzhPKzRMNWdRQ1ZtS3V3N1FnNHhMOVBUMEo5N0dS?=
 =?utf-8?B?QStBMkQzR3lYS2w2N3F5dUNoRWJ5Y0JOTmEzSjdwN3c1RWFnbzNnR1JCcmkz?=
 =?utf-8?B?c1FxN1IxZ2ZvOUpGbkZDK3ZWYWZWYStYNWwxVHJYVEVRaUJGUXBFR0JYblRy?=
 =?utf-8?B?QzJtSVdTdGZQSENGTFB2QVpkNlpyQWZ3c3hMZ3J4TlFZem9oLzZZMzVMSjNG?=
 =?utf-8?B?d21XUDhGWi8rK09vRnRCNXIyUzJteVA3KzBpVmFvYTZGL2VqcGpxVUpLS3Vk?=
 =?utf-8?B?NEhiSFA0RjQyQy9yOGZjZGNXMUZVaHh4SUJPSGgvR2lHcVlocmpUN1hxVFF6?=
 =?utf-8?B?S0JLN3VlNzhSS1NlaElKSEE3b21RWXh1aGZ3M1RManhNRllMR1lLQnlzSXE5?=
 =?utf-8?B?RnI3a2trRXorZ1F4Y2lRSkNOSnBFNDJ4V0RRTm5VK1JLeUxVWjU5V0tIWnpD?=
 =?utf-8?B?VkdzckpBS0FzTHZKUndkVEJ2SkRHVEIwZ3l2N0hWVXpCQnk4aHpiYjJtSVNJ?=
 =?utf-8?B?aCszYlJsRVNuWE1xdUhCT2dKMi9heGc3d01tMGdxMi9jSmZwRFlyTUtuU3VN?=
 =?utf-8?B?T2ZGWW95M3BGV2ZkUWlQWXZiemJxNHhVMXFQRnRub2tMcnJGaDhYaUxNZG93?=
 =?utf-8?B?WnVHL1d4cGpUM2YvTEdxeWxIVWNVZFB5a0loVUJOMXFjejRvaWtzOXpGeWFx?=
 =?utf-8?B?dGU5bkI0eFdOWDVDaHNTS2dhb0NadnkzY3VaSFJIbkNHZzNXV2ROTzFKRlB1?=
 =?utf-8?B?eGlPY0VMR2NXSU81bmJmck14MGFRZjJEeTFzbm9ieXhNcVJyWHpHMDBhbG5o?=
 =?utf-8?B?TkVPN3d6Q0J3ZDZYMlBtdWZkTk1WL2t3dlZFMkt4ZkZmTi9saWFyNmN2Qitj?=
 =?utf-8?B?OTBQczM5bWE5TkNFV1NodDEyTE1aYnNXc29YVmRJTDNTZlRtL09ScmZ5cEVT?=
 =?utf-8?B?VS9SSnNySGRiUDQ4dk93SGF4TXk4VXovU0lXTGMzWHg4UWtRZVZ5Mi9tNStF?=
 =?utf-8?B?eVhzQXkvbnhOaUxPN0tNTlNONDQwUDlydGtzS0JiMWRodzUyVzFTRFA1c3Ry?=
 =?utf-8?B?b0hLUG5NdkY1aEI4QlRhaGJGWk5xemZMeEM3OGVwSEFBR25QbHhKSUw0MWNT?=
 =?utf-8?B?Ui9FaElKOGUreW1PamVZcGVweUtSbVpHdTJMRVlzaFVnbDE3T1d2UzJqUDdo?=
 =?utf-8?B?WkdEeEJyWTQ3WlZpb1JlOFI2TVp3QlZMWjdHc1lhWkVVeDEzT3RudUtuSHpK?=
 =?utf-8?B?bWRXbXROK3lNY3I5ZHdnMkhESHJtZ1RsWnJoQkhZdW9URm1TdVNmMVBZb2Nt?=
 =?utf-8?B?THVBQnZvV2FtMkFPdlBZa0N0czhjRDJwSDBGVnJPWG1OK1hrSyszalB4NGxz?=
 =?utf-8?Q?B6BuZ6VwAOw8VNpIb/uX1Z/TfEbeJjY+0nlDJttgXDKd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0C612E8C9E4D243A1D3037E66F2F1AD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cHlhOGswTTVTazFvUjdtbDExMllDRVBJSzFwOFRpUmdGcU1PWWVpU0pHREdq?=
 =?utf-8?B?N0NsM28rb3ZRWTBtaUJZbGZOeDd0RHkrT0VrMTZ0T05mdWE0ODFSUEdybUo0?=
 =?utf-8?B?VElaMlluaXY3RVc3N3JVRHdMenlZWGxmd3Zld3JxV09sYms5MXkyWGRXak9Z?=
 =?utf-8?B?RU9DMkNmemFReit0aW5Wc0g0aTdCZEJxajBrWEZQcm1wQkV4MUV3NDM3UmpO?=
 =?utf-8?B?MGw3dzZET3ZJT0puTUpwMllRTVhXQUlGZzU2NVNTRS8wNEV5NUlBY0ZCV3dB?=
 =?utf-8?B?WDlLeVBuV1ZIa0RFWmdja0VoN2NWaENCR3I0NTNsQitWTS92MGNPbTdBWHBF?=
 =?utf-8?B?cE9hbERyVU43dGQ5WWJkMjNLbGpYZXk0a1hMbXVCM254b3R1UWtoV0pEYTcx?=
 =?utf-8?B?RTFCb0ZHSUtHaHdWVDhFdlNsMVp6QWljQUhRVnRDOTVlQVZPbTNmZXdxMkVF?=
 =?utf-8?B?YW1LQ0kycnVLU0FPdnJkenlSWGJPT0pQZHFCb0VJUitZYzQvVytqOG9TL3FL?=
 =?utf-8?B?TGtobFpKSnJ4SkE4TTd2NTVsTWR6MnlCb1dkUHphY3FHSDBnS1JqSUFGbjhN?=
 =?utf-8?B?Z2FZS0lkWTV3YlpkeXlRUXpISkY4bXpodWpQS2RpUytMY0Erb0FNcTJRWEgx?=
 =?utf-8?B?UHpvNldEU2ZIclphemw1SEV6SjN2dElGMTh5aGhGdlc1OWNUQStJVVFIN094?=
 =?utf-8?B?SW5qYm9yVTBEelVaYWtBS3VVQko5MFN6VG5RaGhPcWM2MDZwTFlKTHh3eGFO?=
 =?utf-8?B?RWl3VExXRDFlaGJ0ZUtSVWZDOWxTb29wN0Vqa3ZKcGhYbU5haTYxeFh6SzVT?=
 =?utf-8?B?c3FWRGZSU05CVDZKVWxZMEpVd2xxb0JqaktPeW9sZTJhRHlOZkRJZ3AvYnE1?=
 =?utf-8?B?QjhwRGtlR1RRRmFGV1JvQTdRb1d0N0pqS1cxbnFuSXBCSC95WW5hWUZVZndI?=
 =?utf-8?B?Qmtpb2xGQkVJU0tkVWJycnZoQmVtYVpyNWRzMXlla1B1VDdJcmlOUHEvV1pD?=
 =?utf-8?B?cXVsY3hvQjFNY3RKbExzREE3NFIrUEJRNXBjcU5OK0hXdkkzT09xMStaMzVC?=
 =?utf-8?B?aHFUUzNvcndKRUZ6cjhONnduYlVVSHBNUTRNeEpJZE1lVFJFVWpIT3d1YzlE?=
 =?utf-8?B?MkxTam1NKy9FVjJkN3djbm5uVk9JT05xRDNLYzRpb0dBcHUvbWdlSHlCMncy?=
 =?utf-8?B?VnAyZ0hTd0F4RUtsemkyZkViaXl3UHNmQnB0YkNLaUk0ZXlMbkxwK3NCVkh4?=
 =?utf-8?B?ZDZsd2pFSS9WTW1ObG0yNTJzejZ6cHNVd0pZM1RnY2EvbVBMYXZzYXJrdjA4?=
 =?utf-8?B?M0p2UC90Rk9Lbis4M3kyb0J3czVwTzJzVmtVeUhRekdqNjkzVEwxaXRTdjJX?=
 =?utf-8?B?Mk1JOElmR2t2bUk1dlA5RXVqRTNHQWVlSFk2NlJyUkNFSk9pMzZWZWZIRVZQ?=
 =?utf-8?B?NXRTSEpjZzVjTVhsWE1qMXdkSEZrTTdoQXlMZ0tBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43eb627d-90e1-4428-b9cc-08db2588ace4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 19:08:34.9351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RbzPWj0j7nnzJSIS1hCXDQOxsmwNeywYxg+//fHl6isEN90omNqTwVYeuc/A7HPPZjeDMw1EYy0nuAfYSR3hP1b/uve/yBvWZOyyuoS+KsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_10,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150161
X-Proofpoint-ORIG-GUID: eDFS6qrexpIRSNeqmy6nPH9Q_Op_EZYO
X-Proofpoint-GUID: eDFS6qrexpIRSNeqmy6nPH9Q_Op_EZYO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDE0LCAyMDIzLCBhdCA5OjU5IFBNLCBKYWt1YiBLaWNpbnNraSA8a3ViYUBr
ZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgMTQgTWFyIDIwMjMgMDI6MzI6MTMgKzAw
MDAgQW5qYWxpIEt1bGthcm5pIHdyb3RlOg0KPj4gVGhpcyBpcyBjbGVhcmx5IGEgbGF5ZXJpbmcg
dmlvbGF0aW9uLCByaWdodD8NCj4+IFBsZWFzZSBkb24ndCBhZGQgImlmIChmYW1pbHlfeCkiIHRv
IHRoZSBjb3JlIG5ldGxpbmsgY29kZS4NCj4+IA0KPj4gQU5KQUxJPiBZZXMsIGl0IGlzLCBidXQg
dGhlcmUgZG9lcyBub3Qgc2VlbSBhIHZlcnkgY2xlYW4gd2F5IHRvIGRvIGl0DQo+PiBBTkpBTEk+
IG90aGVyd2lzZSBhbmQgSSBzYXcgYSBjaGVjayBmb3IgcHJvdG9jb2wgTkVUTElOS19HRU5FUklD
IGp1c3QNCj4+IEFOSkFMST4gYmVsb3cgaXQsIHNvIHVzZWQgaXQgZm9yIGNvbm5lY3RvciBhcyB3
ZWxsLiBUaGVyZSBpcyBubw0KPj4gQU5KQUxJPiByZWxlYXNlIG9yIGZyZWUgY2FsbGJhY2sgaW4g
dGhlIG5ldGxpbmtfc29jay4gSXMgaXQgb2sgdG8gYWRkDQo+PiBBTkpBTEk+IGl0PyBUaGVyZSB3
YXMgYW5vdGhlciBidWcgKGZvciB3aGljaCBJIGhhdmUgbm90IHlldCBzZW50IGENCj4+IEFOSkFM
ST4gcGF0Y2gpIGluIHdoaWNoLCB3ZSBuZWVkIHRvIGRlY3JlbWVudA0KPj4gQU5KQUxJPiBwcm9j
X2V2ZW50X251bV9saXN0ZW5lcnMsIHdoZW4gY2xpZW50IGV4aXRzIHdpdGhvdXQgY2FsbGluZw0K
Pj4gQU5KQUxJPiBJR05PUkUsIGVsc2UgdGhhdCBjb3VudCBhZ2FpbiBnZXRzIG91dCBvZiBzdGF0
dXMgb2YgYWN0dWFsIG5vDQo+PiBBTkpBTEk+IG9mIGxpc3RlbmVycy4gICANCj4+IFRoZSBvdGhl
ciBvcHRpb24gaXMgdG8gYWRkIGEgZmxhZyBpbiBuZXRsaW5rX3NvY2ssIHNvbWV0aGluZyBsaWtl
DQo+PiBORVRMSU5LX0ZfU0tfVVNFUl9EQVRBX0ZSRUUsIHdoaWNoIHdpbGwgZnJlZSB0aGUgc2tf
dXNlcl9kYXRhLCBpZg0KPj4gdGhpcyBmbGFnIGlzIHNldC4gQnV0IGl0IGRvZXMgbm90IHNvbHZl
IHRoZSBhYm92ZSBzY2VuYXJpby4NCj4gDQo+IFBsZWFzZSBmaXggeW91ciBlbWFpbCBzZXR1cCwg
aXQncyByZWFsbHkgaGFyZCB0byByZWFkIHlvdXIgcmVwbGllcy4NCj4gDQoNCkkgaGF2ZSBjaGFu
Z2VkIG15IGVtYWlsIGNsaWVudCwgbGV0IG1lIGtub3cgaWYgdGhpcyBkb2VzIG5vdCBmaXggdGhl
IGlzc3VlIHlvdSBzZWUuDQoNCj4gVGhlcmUgaXMgYW4gdW5iaW5kIGNhbGxiYWNrLCBhbmQgYSBu
b3RpZmllci4gQ2FuIG5laXRoZXIgb2YgdGhvc2UgDQo+IGJlIG1hZGUgdG8gd29yaz8gLT5za191
c2VyX2RhdGEgaXMgbm90IGEgZ3JlYXQgY2hvaWNlIG9mIGEgZmllbGQsDQo+IGVpdGhlciwgZG9l
cyBhbnkgb3RoZXIgbmV0bGluayBmYW1pbHkgdXNlIGl0IHRoaXMgd2F5Pw0KPiBBZGRpbmcgYSBu
ZXcgZmllbGQgZm9yIGZhbWlseSB1c2UgdG8gc3RydWN0IG5ldGxpbmtfc29jayBtYXkgYmUgYmV0
dGVyLg0KDQpUaGUgdW5iaW5kIGNhbGwgd2lsbCBub3Qgd29yayBiZWNhdXNlIGl0IGlzIGZvciB0
aGUgY2FzZSBvZiBhZGRpbmcgYW5kIGRlbGV0aW5nIGdyb3VwIG1lbWJlcnNoaXBzIGFuZCBoZW5j
ZSBjYWxsZWQgZnJvbSBuZXRsaW5rX3NldHNvY2tvcHQoKSB3aGVuICBORVRMSU5LX0RST1BfTUVN
QkVSU0hJUCBvcHRpb24gaXMgZ2l2ZW4uIFdlIHdvdWxkIG5vdCBiZSBhYmxlIHRvIGRpc3Rpbmd1
aXNoIGJldHdlZW4gdGhlIGRyb3AgbWVtYmVyc2hpcCAmIHJlbGVhc2UgY2FzZXMuDQpUaGUgbm90
aWZpZXIgY2FsbCBzZWVtcyB0byBiZSBmb3IgYmxvY2tlZCBjbGllbnRzPyBBbSBub3Qgc3VyZSBp
ZiB0aGUgd2UgbmVlZCB0byBibG9jay93YWl0IG9uIHRoaXMgY2FsbCB0byBiZSBub3RpZmllZCB0
byBmcmVlL3JlbGVhc2UuIEFsc28sIHRoZSBBUEkgZG9lcyBub3QgcGFzcyBpbiBzdHJ1Y3Qgc29j
ayB0byBmcmVlIHdoYXQgd2Ugd2FudCwgc28gd2Ugd2lsbCBuZWVkIHRvIGNoYW5nZSB0aGF0IGV2
ZXJ5d2hlcmUgaXQgaXMgY3VycmVudGx5IHVzZWQuDQpBcyBmb3IgdXNpbmcgc2tfdXNlcl9kYXRh
IC0gdGhpcyBmaWVsZCBzZWVtcyB0byBiZSB1c2VkIGJ5IGRpZmZlcmVudCBhcHBsaWNhdGlvbnMg
aW4gZGlmZmVyZW50IHdheXMgZGVwZW5kaW5nIG9uIGhvdyB0aGV5IG5lZWQgdG8gdXNlIGRhdGEu
IElmIHdlIHVzZSBhIG5ldyBmaWVsZCBpbiBuZXRsaW5rX3NvY2ssIHdlIHdvdWxkIG5lZWQgdG8g
YWRkIGEgbmV3IEFQSSBmdW5jdGlvbiB0byBhbGxvY2F0ZSB0aGlzIG1lbWJlciwgc2ltaWxhciB0
byByZWxlYXNlLCBiZWNhdXNlIGl0IHNlZW1zIHlvdSBjYW5ub3QgYWNjZXNzIG5ldGxpbmtfc29j
ayBvdXRzaWRlIG9mIGFmX25ldGxpbmssIG9yIGF0IGxlYXN0IEkgZG8gbm90IHNlZSBhbnkgY3Vy
cmVudCBhY2Nlc3MgdG8gaXQsIGFuZCBmdW5jdGlvbnMgbGlrZSBubGtfc2sgYXJlIHN0YXRpYy4g
QWxzbywgaWYgd2UgYWRkIGFuIGFsbG9jYXRpb24gZnVuY3Rpb24sIHdlIHdvbuKAmXQga25vdyB0
aGUgZmlyc3QgdGltZSB0aGUgY2xpZW50IHNlbmRzIGl04oCZcyBkYXRhICh3ZSBuZWVkIHRvIGtu
b3cg4oCcaW5pdGlhbOKAnSBpbiB0aGUgcGF0Y2hlcyksIHNvIHdlIHdpbGwgbmVlZCB0byBhZGQg
YSBuZXcgZmllbGQgaW4gdGhlIHNvY2tldCB0byBpbmRpY2F0ZSBmaXJzdCBhY2Nlc3Mgb3IgYWRk
IGEgbG90IG1vcmUgaW5mcmFzdHJ1Y3R1cmUgaW4gY25fcHJvYyB0byBzdG9yZSBlYWNoIGNsaWVu
dOKAmXMgaW5mb3JtYXRpb24uDQoNCkFuamFsaQ==
