Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A904B765B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243286AbiBOSvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:51:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiBOSvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:51:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101B8DF11;
        Tue, 15 Feb 2022 10:51:29 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FH3r39003831;
        Tue, 15 Feb 2022 18:51:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=JqSIWggcCJHQmscVf+IYA3BAz++4oaRSvj4lcL1ea2s=;
 b=fiI+4i3zKHRcih3OeDnAYf2MZSqhErLhcTrIV3YmcBzT5dPYBVoNc0JhTUY/o8AEV6/B
 aMl0Z2G2B0KaVTSmJgSWQVIZZLopkvOyQzL0IlHNU6Vf/arOZhpqnGxndIQu9+Tn1j8v
 wYQeG59WuN/Fe4fwmcYR0X/LAE0D0bqKZ4mG5S4K0obkimpFgTwHpR46hjPk4HSHr+70
 Qjb+6AdtxxPv4IPpsIplyqSD2nXrHbxJyoF/htm78Xrpl/hXwaQbwDnXYp44CUcIB/fx
 W1n8rtq2Rei23mQD3r+UqPTr3hBFhdqZS8TRQp88eGySn5dpQALqyZf7Vyg2Kay6rt9e cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e88hghxbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 18:51:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21FIoQqC105968;
        Tue, 15 Feb 2022 18:51:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by userp3020.oracle.com with ESMTP id 3e66bp29p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 18:51:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoyLD/uCV7pa6Wx+VrhJkjUsOxsY8VT+1FqSkxFfXyMxrTW/I3fdiNLLPhzxV5otB6rlhGWTYJu0LYnbbD9CHgW2Nl+PkN4zZQ1H5khimJnBudJ1mPVybx1RslJ4cujMk0vTh1eN6qrGbvDS11GvkAaRkgLzV/gY081ammXgl5SE3vlARl6ARDFgQ0b9SA5ZIUWsaUsyzwgOdfNqnidf6dAb6vDOR6AdUH0vXabxsOfXxRJSC7ElcNCqQhVidplJ44udBO5cvh6tIbx/ed+cMDK1dbP5q28EB+OmdSa+hArzTGEvyqrFTgXTNTmYmAdDSkNzCWWmreAk48DIwkWv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqSIWggcCJHQmscVf+IYA3BAz++4oaRSvj4lcL1ea2s=;
 b=mv8DT8+5UHPwMLFZFgRJ1TSLZkA2UZLUC8B7hOfLhy6uvbGUCc94w64+4bO2MK7bb3xmBkDuJzYxaZoyY4guiChTe/VVjvdeQh7huD0Jksk04FPPrSERT1yPmjbVjht2k6AmYpLvyY9OOHhtEfqokOEKuhKSbPqrX6UCjuPJHPrAhRRaJhhr710NzEmMi3ULoyBV6T8VEUVBuLvKj1/iqsThOgsueFqPnIbTUzmMTy6YGe2TbwrBuO2uDKDO3FNxxpRf8QSxjMlC5x7nzgrHf3IbfBPV4iVVXTpbmEkXn7XksfAYx+xWG6Pk7Gn+o+0g+iuB5WWJtqTyS0RgBD8iCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqSIWggcCJHQmscVf+IYA3BAz++4oaRSvj4lcL1ea2s=;
 b=pcf5qnZqZj83EzTskT2bKVrrwQB4FEfBVb8s7Qde9f80C+tVkOiA4jHhWZ40uMUVb5WgShtY4v6Ojqkfo3K+AokEiJRiFeROmoC6uuhXSDIhGS5sVB5yEdwMRJRnWjBKMOs3ODbwnC4Ongl/8tHKHlSwpehAMqyVk99H5XYZahc=
Received: from SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14)
 by DM5PR10MB1787.namprd10.prod.outlook.com (2603:10b6:4:9::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Tue, 15 Feb 2022 18:51:05 +0000
Received: from SJ0PR10MB4718.namprd10.prod.outlook.com
 ([fe80::cd19:e61e:1ee2:8216]) by SJ0PR10MB4718.namprd10.prod.outlook.com
 ([fe80::cd19:e61e:1ee2:8216%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 18:51:05 +0000
From:   Sherry Yang <sherry.yang@oracle.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
CC:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "christian@brauner.io" <christian@brauner.io>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2] selftests/seccomp: Fix seccomp failure by adding
 missing headers
Thread-Topic: [PATCH v2] selftests/seccomp: Fix seccomp failure by adding
 missing headers
Thread-Index: AQHYHr0cUDgCAipxpkeOGl2YN9Jl6ayNal+AgAAheACABbIWAIABtTmAgAAHTwCAAAIJgA==
Date:   Tue, 15 Feb 2022 18:51:05 +0000
Message-ID: <05F72E28-AEA3-438C-871A-D6D68E4889DF@oracle.com>
References: <20220210203049.67249-1-sherry.yang@oracle.com>
 <755ec9b2-8781-a75a-4fd0-39fb518fc484@collabora.com>
 <85DF69B3-3932-4227-978C-C6DAC7CAE64D@oracle.com>
 <66140ffb-306e-2956-2f6b-c017a38e18f8@collabora.com>
 <4b739847-0622-c221-33b3-9fe428a52bc0@collabora.com>
 <2f59f86c-dbd7-7dbf-021d-bc62ebbe2a43@linuxfoundation.org>
In-Reply-To: <2f59f86c-dbd7-7dbf-021d-bc62ebbe2a43@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8f5801a-b0ba-4156-5b68-08d9f0b41f2f
x-ms-traffictypediagnostic: DM5PR10MB1787:EE_
x-microsoft-antispam-prvs: <DM5PR10MB1787A53F37C427BA2FB9E1F99B349@DM5PR10MB1787.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fTSOLwlduIX5Qef0w4tVHDlHBUaGyT85wpk11y6xRVF6+dQNG8aoXXPzup+3JprlPF3y6sOh+RMvzypJAoVHBFZPYvjSh3hbJcRi724I/WsfEGRH3taGcYxlBMAvJFAV5W9coi+72GsSgKPMym2W4x2CjJ0QRg1/ycGVmdY17UqPjSAwUL9SL/Ht2yB2FX4rtoElMYMX051a67LvZhZXvRkov7RSj6lH8rYXYCkPWaqVKa9PvgzskNaIFozJ1fCJ6S5aEvB4QOwqnHXvpZDCwL/gT0sQ8/7PUJ3Qz13E9dtTYdORvFPecA7L5aRhBJYEvfuwiIi1L6IW1PM5lLgYXXkuOe0WSjnMCQ6Dhc/QRMjBwymj6H4FVlrUwKuipK/BJLr/o7Oi0mTgYK3NY5Qh9flfmyYyhQBwyU/o2gwKiTxu7sEN7mG7jdve9H/LoBdgplpkEQxHtmVq3+LSvA1mqHfYhwGGh6kqbXeLRfW4+e0iMrEpHwOVW2SHKG77dGgmRqUDlDPXcKkojnlGWMF0d8o0LDhyQCrLKcUH7/pqIaQol46WkrBn/B0k8I4y4fcDRmMBYgaMCteEuaBIEfVTfpQJHZRoV/DXjw4LuUQZbS6IofgvgFi1nbJ9kU6m6ZETyen8PzToH+iz38+91QHQwAXto2Hdw/8f873pECBiJEszVJWCfZ+qjIrGgnZHrvxtQJws3fTVMO4dkn8/Gf3Da763f/gaAbYxVNIXZmujqX8pCro1O8ZmzF2DUUW+mPxMrCHHHVahN34vJ1tk52QEoY0xSxaBb9cWCASuyK+Cp/UFIDz9LdgyoQ5pN+OdLG+hcCl20Yxzu8NIgkHRfwgRFKYsajMfh8sIXykGdX6NchHjbNPAnk2CEDsORWxz6ql9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4718.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(66446008)(2906002)(91956017)(36756003)(66946007)(38070700005)(316002)(186003)(66556008)(2616005)(83380400001)(38100700002)(76116006)(33656002)(86362001)(122000001)(64756008)(66476007)(71200400001)(4326008)(44832011)(7416002)(5660300002)(8676002)(8936002)(6486002)(6506007)(54906003)(508600001)(53546011)(966005)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkE2TEc5S1NsWUVKd1BJMjJsRWdkbFNvKzdFbW44UWNwUmxjZFRNakZRRVhH?=
 =?utf-8?B?OUtCL2dIRzlVUzJmVytQL1J1cnVtVmdzWVFxaTQ5Ykw5dDduelorbnBoVVRo?=
 =?utf-8?B?VzFHSGJHeHBVWE1WdDUvR0M4bHJnVkVKeStpcU9nTWNoaTgxdjl3Q1IxejJR?=
 =?utf-8?B?VGFUR0NiYjh4TG9jRkxmSG5Pb2J5dTRRTGdMdkFXb1ZqTE9HYmJxdW91RVZL?=
 =?utf-8?B?S3NCczlKVmc3M2VMTTBUWjVnaDY4a0dacnMxejJsdWNPQ2VZM2Jtd3dNSDY1?=
 =?utf-8?B?c3VYMXZqMGhTUXFSeEJDVHpTL0RCVE5sd2wxUkg5TFBXSmpiN0hlMTJhTklT?=
 =?utf-8?B?QnFhNmVGVkJSeE9ORE5SQ2lQb01Lb3RrR1EzRmpXNFU4dTZST0FXRmhkU0RN?=
 =?utf-8?B?bVR2NHBvYW52WHRhMldtNnV0QkhaU3BlTVZhRHRMUUtReEdaOUZQVWxWdnVY?=
 =?utf-8?B?VEttcHE5RVMxRFJyV2o0UXFXUmg3ZUFNTHZDcElDekhrV3d3UTY3M1FqbEtx?=
 =?utf-8?B?K0twbW5WUWhWNy9TaGprZW5iRVZrTDBUUmlQNmdZazNHZ1hUVEY1TjlnSGFD?=
 =?utf-8?B?dERzVGJMV1k4ZUE4RjN5TG1DOEFJNHZJSWEwRHNLQ2FyblVDblhJTk9rbzZZ?=
 =?utf-8?B?Y1ZPbUw3bnlQdXdaSnlBNXVNTmlpRVlYbnJaa0NaV29RSnNkODdGckxGTVVh?=
 =?utf-8?B?a2V5YUEwMUxwREdUMmZlY0g2eUpLaDU3dVBrWURFNXRIakhpenRUTXlLaDl4?=
 =?utf-8?B?RXA5WXcwb3J4ejg5VVlENjdxaWlKNmIvWEN1djdlVmh3SU55V09MMTQzdFAv?=
 =?utf-8?B?T0I1OHhxbHo1NDhmZzYwL015VWNwaXhvRWdhcFZ4ell5Sy9vOEZiTnYyLzcr?=
 =?utf-8?B?Q3FXT1dYOHgvdTRtRU5HQ0pINzFmWGlBNzBQY3h3UHo0RWFSR25oMWs0ckdt?=
 =?utf-8?B?eEpVYXNHTHQxTS9ySFNoUzNHbFZkOUJlbFVxL0dzcmhTeFgwQTIvdU5tdFVU?=
 =?utf-8?B?RzRzRnhwWnFTbTJJek9vYS9JREFDZU5sL2VBa3k5WStXdnlsOTJZVHdXTGMr?=
 =?utf-8?B?d0FpZmFXdS8rbUZId2x1eG13TWZLU1ZyZFdsMWxrb0ZGclNmN1RMb2JCY3oy?=
 =?utf-8?B?cGFzTkgxV3IxMEd0SzFsRGgwZXBFeDFuT3Q3QnordDdpeEJUWS9xSThRWjcr?=
 =?utf-8?B?dVJxNjNOVFV1bzFzUWhqTVRjQU1UalVsZVVNUWFMbkpmbnJJb3luU3R5RXh2?=
 =?utf-8?B?SXcxbnAvTGNzWU96RjF5VThtbXZMRVZLcjVZdklzeEYyaW80V2kzQlRNWlBX?=
 =?utf-8?B?V2tQMG5SQW95UlZnYkFzSEs3aHM5bXdTTTZ6K1ZkenJlalNsTWtaNlFWMVVh?=
 =?utf-8?B?NTNYTkVFdGRpWXJ4V2E5K1lWSG9LRTBpWlBmcmxqS3M1VFFYUmUvOEdpQWxO?=
 =?utf-8?B?Yk9CSUovelpOT0gwRkVzVndvbEZSMHlFRjcxOXA0bDl2WUlBWldpeEUvcTg5?=
 =?utf-8?B?MWlEaUtpU3hEcnlhRE1jbWtIbHZjWVNFS29pZGdOWVp2RkxxeHoxbTRLNmgz?=
 =?utf-8?B?MHF4RDlDa3FISEJ3NldRVkRYRDRLdTVCT3M4QVB5SnVLbk1HNXBzYVBrU05a?=
 =?utf-8?B?LzV0UHFBUUFpVTg0V2pkR21vemUyWjltL3dIdjYxK2RxUzNMZ3BjVzhZL0ZE?=
 =?utf-8?B?L1VDN1FTbkcreklkUmoxd3ZOQUU4ZUhQVnV6WFRKSG5NajlZdStyZXBZZE5E?=
 =?utf-8?B?SGMxYzRSRTg1NnM3RDFUb2VRMWg4SzREcGZrVlFHaHhjQlBzTEVoRXJXTVhl?=
 =?utf-8?B?MTZJSWx6QkxMbjc4c1dzUVFobUdSMUttS3FXZ3Q4cXRNRjRQd0xGSldVdlh0?=
 =?utf-8?B?a0ZmYmxmSjhrYTVqWDRYMHNSME5pT2NLcHd6YnpxVWxCWGxGZE5FMmJUbXRq?=
 =?utf-8?B?WEVuY0RCMTJmc0RmTFlEWDl4Z2RSTUNuV0syTERNazVpZy82RkxpRUM3Nk1j?=
 =?utf-8?B?aURveDUxcCswT3QwTkR5S3lqaTVNZCtvUG85U2dQK1JNQUtpRk1FOHNRTG9t?=
 =?utf-8?B?SllJYVdTbnBIcHB5Y1J6dkRDTnB2bXhpb3gwRzF6U2VMR2NTN0tWTGhLUDMy?=
 =?utf-8?B?aGMyNEI5VEFVK0w2eFA2MlIwTjN2RjBIQmJPejRqUHRmUGkwUXhLUzA4T1VZ?=
 =?utf-8?B?bFcvYWs3UndtTUhFKysxeWorZi9RV2hDb3hJREtoOUUrV2FOekNYeUR5QmF1?=
 =?utf-8?B?OWZlRDFOajR4RVE2U1dxVWlUcmFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B58A0D608E555B42AE4276B902B7A3F1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4718.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f5801a-b0ba-4156-5b68-08d9f0b41f2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 18:51:05.4175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: owKvaRYITC+W/hbDOr1P45Gq7gEzDGjNhRSg4DwK2pdPbKNT4OSPZxXaIuRdfu6haznFE8vE9Lyuh6pkNV/F+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1787
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150109
X-Proofpoint-GUID: Wri9X5WJnc7EwtAVpVTOeIMK-TEiMSbU
X-Proofpoint-ORIG-GUID: Wri9X5WJnc7EwtAVpVTOeIMK-TEiMSbU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIEZlYiAxNSwgMjAyMiwgYXQgMTA6NDMgQU0sIFNodWFoIEtoYW4gPHNraGFuQGxpbnV4
Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPiANCj4gT24gMi8xNS8yMiAxMToxNyBBTSwgTXVoYW1t
YWQgVXNhbWEgQW5qdW0gd3JvdGU6DQo+PiBPbiAyLzE0LzIyIDk6MTIgUE0sIE11aGFtbWFkIFVz
YW1hIEFuanVtIHdyb3RlOg0KPj4+Pj4gIi4uLy4uLy4uLy4uL3Vzci9pbmNsdWRlLyIgZGlyZWN0
b3J5IGRvZXNuJ3QgaGF2ZSBoZWFkZXIgZmlsZXMgaWYNCj4+Pj4+IGRpZmZlcmVudCBvdXRwdXQg
ZGlyZWN0b3J5IGlzIHVzZWQgZm9yIGtzZWxmdGVzdHMgYnVpbGQgbGlrZSAibWFrZSAtQw0KPj4+
Pj4gdG9vbHMvdGVzdHMvc2VsZnRlc3QgTz1idWlsZCIuIENhbiB5b3UgdHJ5IGFkZGluZyByZWNl
bnRseSBhZGRlZA0KPj4+Pj4gdmFyaWFibGUsIEtIRFJfSU5DTFVERVMgaGVyZSB3aGljaCBtYWtl
cyB0aGlzIGtpbmQgb2YgaGVhZGVycyBpbmNsdXNpb24NCj4+Pj4+IGVhc3kgYW5kIGNvcnJlY3Qg
Zm9yIG90aGVyIGJ1aWxkIGNvbWJpbmF0aW9ucyBhcyB3ZWxsPw0KPj4+Pj4gDQo+Pj4+PiANCj4+
Pj4gDQo+Pj4+IEhpIE11aGFtbWFkLA0KPj4+PiANCj4+Pj4gSSBqdXN0IHB1bGxlZCBsaW51eC1u
ZXh0LCBhbmQgdHJpZWQgd2l0aCBLSERSX0lOQ0xVREVTLiBJdCB3b3Jrcy4gVmVyeSBuaWNlDQo+
Pj4+IHdvcmshIEkgcmVhbGx5IGFwcHJlY2lhdGUgeW91IG1hZGUgaGVhZGVycyBpbmNsdXNpb24g
Y29tcGF0aWJsZS4gSG93ZXZlciwNCj4+Pj4gbXkgY2FzZSBpcyBhIGxpdHRsZSBtb3JlIGNvbXBs
aWNhdGVkLiBJdCB3aWxsIHRocm93IHdhcm5pbmdzIHdpdGggLUksIHVzaW5nDQo+Pj4+IC1pc3lz
dGVtIGNhbiBzdXBwcmVzcyB0aGVzZSB3YXJuaW5ncywgbW9yZSBkZXRhaWxzIHBsZWFzZSByZWZl
ciB0bw0KPj4+PiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsL0MzNDA0NjFBLTZGRDItNDQwQS04RUZDLUQ3RTg1QkY0OERCNUBvcmFjbGUuY29t
L19fOyEhQUNXVjVOOU0yUlY5OWhRIWU0YWpNSDJIUnpMTlpaRGUzWjFpcUFPN0w4U1ZqcW52cC1h
NU5mVDZJLW1LRDU5eGpBLXpITThUQWZrSk0xVWRjZyQgDQo+Pj4+IEFjY29yZGluZyB0byB0aGlz
IGNhc2UsIGRvIHlvdSB0aGluayB3aWxsIGl0IGJlIGJldHRlciB0byBleHBvcnQgaGVhZGVyIHBh
dGgNCj4+Pj4gKEtIRFJfSU5DTFVERVMpIHdpdGhvdXQg4oCcLUnigJ0/DQo+Pj4gV2VsbCBzYWlk
LiBJJ3ZlIHRob3VnaHQgYWJvdXQgaXQgYW5kIGl0IHNlZW1zIGxpa2UgLWlzeXN0ZW0gaXMgYmV0
dGVyDQo+Pj4gdGhhbiAtSS4gSSd2ZSBzZW50IGEgcGF0Y2g6DQo+Pj4gaHR0cHM6Ly91cmxkZWZl
bnNlLmNvbS92My9fX2h0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWtzZWxmdGVzdC8yMDIy
MDIxNDE2MDc1Ni4zNTQzNTkwLTEtdXNhbWEuYW5qdW1AY29sbGFib3JhLmNvbS9fXzshIUFDV1Y1
TjlNMlJWOTloUSFlNGFqTUgySFJ6TE5aWkRlM1oxaXFBTzdMOFNWanFudnAtYTVOZlQ2SS1tS0Q1
OXhqQS16SE04VEFmazBBVlNiRmckIEknbSBsb29raW5nIGZvcndhcmQgdG8gZGlzY3Vzc2lvbiBv
biBpdC4NCj4+IFRoZSBwYXRjaCBoYXMgYmVlbiBhY2NlcHRlZC4gSXQgc2hvdWxkIGFwcGVhciBp
biBsaW51eC1uZXh0IHNvb24uIFlvdQ0KPj4gc2hvdWxkIGJlIGFibGUgdG8gdXNlIEtIRFJfSU5D
TFVERVMgZWFzaWx5IG5vdy4NCj4gDQo+IFNoZXJyeSwNCj4gDQo+IEkgcHVsbGVkIGluIHlvdXIg
cGF0Y2ggYXMgYSBmaXggYXMgaXMgZm9yIDUuMTctcmM1Lg0KPiANCj4gVXNpbmcgS0hEUl9JTkNM
VURFUyBjYW4gYmUgc2VwYXJhdGUgcGF0Y2ggZm9yIG5leHQgcmVsZWFzZS4NCj4gVGhpcyB3YXkg
dGhlIGZpeCBpcyBnb2luZyB0byBiZSBwdWxsZWQgZm9yIHRoaXMgcmVsZWFzZQ0KPiB3aXRob3V0
IGRlcGVuZGVuY2llcyBvbiBvdGhlciBwYXRjaGVzLg0KPiANCj4gdGhhbmtzLA0KPiAtLSBTaHVh
aA0KDQoNCk9oLCBJIGp1c3Qgc2VudCBvdXQgdjMgcGF0Y2ggYmVmb3JlIEkgcmVjZWl2ZWQgdGhl
IHVwZGF0ZXMuIE9rYXksIEkgd2lsbCBzZW5kDQphIHNlcGFyYXRlIHBhdGNoIHdpdGggS0hEUl9J
TkNMVURFUyBsYXRlci4NCg0KVGhhbmtzLA0KU2hlcnJ5DQoNCg0K
