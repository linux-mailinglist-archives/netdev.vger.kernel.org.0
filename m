Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2948E4B1B07
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346710AbiBKBOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:14:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346696AbiBKBOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:14:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C786E10DF;
        Thu, 10 Feb 2022 17:14:32 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21B0eZ3o013354;
        Fri, 11 Feb 2022 01:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ccqfiidI13/S8tdOCiXk85Byr0HNwjqE4Rreuh86ve0=;
 b=edVAellBDu7yB/N0YM57kpiJtEYjKbnrhS984V6RsEQzPmzGHv8fVfoi+ToF1oU+UwDQ
 eGQqYnWZHy+1G2ZqWnUS3rNeUn3ZxI1YNmIszOE8zJUWnzZf5yh4XIDo5tJgXb4qt3P8
 nvpuakHQHch0D/VHz1vDOTXNUW28PjD0sIpw4bADEWsiK3LJ7lM6HWcotOh5dCA4ahzS
 7hfbENauR5nG7ISHYpwuWqZqzyh9pXOOflsYh5oBd5T2uzsQs3s5wGjczczWTAeJxBZZ
 CCpPWTDD8uekIRI15zYt96NcuWhWT3e8MonPq8ZdjqWZelLpI7o7zDIADjhfTzO9BzIP fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368u2sbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 01:14:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21B1BvFl087172;
        Fri, 11 Feb 2022 01:14:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3020.oracle.com with ESMTP id 3e1jpwhw9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 01:14:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkUlzhubes8Nl0/XnW9uD17QyUHFo5acUdM3/8Moz/ZEkLoF3Re28t1nQ8qhWMeHNO8s7nLxEfZcfsThaI9/WvPkvOU/P+F9wOtJrZw94B2UFOKGrlWrmB+IdEcxuin8VvTHO1eMdfVly6gyzeuV4tc5FIcQJ6vXussj7ljpZfXsC8NF77FnTcGuvkq/XS3zQMcYiJ5rKP573pcz8stbZxYP+li6RbTIiKRlB0deP/CElF+M373VOzExRD50kr2l+/IltGz6U+kvAdsRlWJk+GCcfCWRbf9enZLWEfDYpYxg5S+zlW4ewnj07CbmA5bnOXckCjyGDyoze7HgRZvqOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccqfiidI13/S8tdOCiXk85Byr0HNwjqE4Rreuh86ve0=;
 b=EM2TqCFH5ruwhtEyN2V5ClLRwZMPNZK+sOc/QLRMaWBUg7TWlErgla+IUFIQfpMi7uBpaTVEhNcP2ZS/ot3Pa5V8+AUNWTQ/wCsolFK7fYT5H5/2dcUFiCVxCyuKCncJVlJNmrrpa1nQV4LXcmfvDFCykz090Lt7EhTzZ5xEodJkB8aZdSKBZuPd3vTLujB40YSKabcNt5vRRRIgB34YNubwcPD7MLvLY3yMCWCeIQDQZFEaDM/Vnu+ymNjbw+mUT7TZ9Nv9zQbMT1QLsn6yWXentc0M2YaIqALQJ6+Q3j99sfP30CFCoBe+3Mm99xt6a1ApB+2gdFCgsyV4LXl9Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccqfiidI13/S8tdOCiXk85Byr0HNwjqE4Rreuh86ve0=;
 b=W5KHVds5TBX/Z7UUEQ+p/VP2l7jLHCnSx6qPUZykD8sKgn268uVwD/onQx+fTytLRGvIIO1R3r8KjKYrMNvj9v9tOFaKwnTh8bfO2wyaSwCNCPFtrko4RPK0NxCcQ+t5BZ2Ng+c8tRW1SAMof7vUguvLxg9UD3hEdYi3cNf9a14=
Received: from SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14)
 by MWHPR10MB1694.namprd10.prod.outlook.com (2603:10b6:301:9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 01:14:05 +0000
Received: from SJ0PR10MB4718.namprd10.prod.outlook.com
 ([fe80::cd19:e61e:1ee2:8216]) by SJ0PR10MB4718.namprd10.prod.outlook.com
 ([fe80::cd19:e61e:1ee2:8216%4]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 01:14:05 +0000
From:   Sherry Yang <sherry.yang@oracle.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
CC:     Shuah Khan <skhan@linuxfoundation.org>,
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
Thread-Index: AQHYHr0cUDgCAipxpkeOGl2YN9Jl6ayNal+AgAAheAA=
Date:   Fri, 11 Feb 2022 01:14:05 +0000
Message-ID: <85DF69B3-3932-4227-978C-C6DAC7CAE64D@oracle.com>
References: <20220210203049.67249-1-sherry.yang@oracle.com>
 <755ec9b2-8781-a75a-4fd0-39fb518fc484@collabora.com>
In-Reply-To: <755ec9b2-8781-a75a-4fd0-39fb518fc484@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d200a3f-00da-4261-f0a5-08d9ecfbcc5a
x-ms-traffictypediagnostic: MWHPR10MB1694:EE_
x-microsoft-antispam-prvs: <MWHPR10MB16945E21D4F08C2B4454BDF29B309@MWHPR10MB1694.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LJBSCMTrGsPH8p1UQpU+aqD0v43VZhDZB0Ru7smlIYRIOJPgpv4RN3jK2lyAARzlfv5G1wm31l4A5wTMwVQ5gQOaXA28eqC+c075DgD3c5lsSbor47jSD9NsiVcQsfR4RxEXE1smmB2UBk2pfgUogIGPUxyJPxW/IeecSY7DhjEzVb7RHXtdeZbIFZNx1330QmrobUru8h2os6lQ/6VUfEceVvVifiV/1WTVSRuzT/qlBJIcUbObxU/exTFBmmSbq9K5unjRenu/CaY6zCyOxy7Zwz3qa5cBbmSr0hIkBU1+j8Uan8IfFffGVpkwy4050eon32g8/eUINsMfTvuC0CZT8yaoST7REHQCMnXL7gMXvdZr23NGkaZQfVQ4lmLU4VnRVyFeuEgqdE674vNPZEHDhL6z3zu/TPCJAttx5laQRHJDbFTv5lt17Zou6F6d3rhOk/ymI8SScgTMTdQ/EWRivHH1u2uEHsECr/WGy9az7wz2b3BxzL3z4tnG33LU6K0LuzskovFe5Md7YlWFjSukTv9aSuoibv8+Hrvpbx1GciDnJlH3vDNbJUDtZh83NQZrmFZKprmVwmJh3/lNAMlJJ9X+hoBqiRvT2irq26gBVHp2vEQUnoCOCvMjO50SOJJb/vHpjPVMO3lAiCzSBMBfqPXrj9uKwB2DfcVfvF37NTk8fKHolWxfuEgWCddjFkKRymxUZo5GKHZ4MFauvQoXivnI2Ba+fw4WIwS38MRXU0lhuyp/W58p47v5zBxC24sWV7GK3Sc9iaSsksR63YhIs/hXo0J3FfkpfBQnIy8OrGjFzTH62LwiR/thw6rXnmXjTaNoHP0QKXy+JdrePw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4718.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(966005)(83380400001)(66946007)(508600001)(76116006)(2616005)(6916009)(54906003)(66476007)(7416002)(38070700005)(4326008)(66556008)(8676002)(186003)(2906002)(8936002)(6486002)(316002)(53546011)(36756003)(33656002)(66446008)(86362001)(6512007)(71200400001)(6506007)(44832011)(64756008)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFRzTW8xb094MEpmQ25RbWI5M1ZtVVp2NFhGZlp5dHp5TlFPQ3pTUXF4ZFgz?=
 =?utf-8?B?MXAvOVZ2ZGdFQ1ZtZWRTeERXSC9Md0t3U2lVbjIxa3I0RTNiSjY3RGY4RzFO?=
 =?utf-8?B?VTIyL3A5SnFKZU5ST2ErSFVabkhlRmRCNC96WVBoZ3ZWUmxLei9OSFdtbXBM?=
 =?utf-8?B?U3hYOWREM0ZUNlo5cjVvMzNuTEwxQ3F3V1diZVMzeGZmNExqRmtzRmtzK1pR?=
 =?utf-8?B?N3Z1eldLbEJtZVMzZVBZaDAwT1RDaVRqd3NiSFdwVXcwUXdwODlxYkMyUTFr?=
 =?utf-8?B?UmMwS2g0blR4M1V0b1UzOGxxbk8wUExkbTZZem1maG5MUWdUUWZBV2RvVWZ2?=
 =?utf-8?B?WmlYN0RtQUdQVXJjbzMrRXNEVE5DbjlkVEpSTWx0RXJnYU5lSC9SbjJMVnRC?=
 =?utf-8?B?cmFZYkdqeFJxSkFvOTFWcUhIUXo2THdML3cvNmROUW1lV2Q0UDBnMC93MFox?=
 =?utf-8?B?akdGNFVJbUIxbGVVMXdxN1dwd1dINE82M1Z6ejA0K1hXamlLZTlpeldGcDA1?=
 =?utf-8?B?bHoxeUZNVVVHQ1Z5K2JVdGk4TzlIN2EyRmI2dVo2VWZxVmZaWEVLbGI5K2ts?=
 =?utf-8?B?YzhCblk3SkVxeXVlRHM1NnkvV21ELzdINDRydE94ZldEbGxMZlp4bWhTeW9s?=
 =?utf-8?B?TEJjcDZxbDJtazYwRlNtQU5iQlE4eDdJeEtIb01SbzRSMFRqRTFqTUltbldW?=
 =?utf-8?B?UEgrMlB3QVZEVWQ1VzUrTDU0QnlsdmVBUGs4SkZmUHhObHNkTFViNy9rMDFZ?=
 =?utf-8?B?OTJDdlcvbWFIMkFTRytOOU81d0pxamRrdWExNTlUd3RhMGluV0VHNEFVNnpq?=
 =?utf-8?B?V3haNlFyUlRRc05BNEsrcFBmMUY5cmJHbVhaNVdZMVBjNkNMVVhTT1ZSa1dr?=
 =?utf-8?B?NWNvQ1p0OFMwSVAxWDFWL0M0WUZ0L2M3anpmd0lJaEJzMHhTMDhrWG9ZSU9x?=
 =?utf-8?B?NmpYZWFxelJ1ZFRIem1DaS9paUR3Kzd4OGFmVHJoRHE2Z0FmcU8zdXBxTjZY?=
 =?utf-8?B?MzRuNUZhNUE5c1I0aUNna3JsamJMOEFvNTlKTzc5N3dOdVk5YkttMm9uSUZD?=
 =?utf-8?B?b3Y3ZXQ0Zm1wOE1McnJmL0hocS9oUUtWUkVVSjVCbHROUlhxZWdTbXBzeUpj?=
 =?utf-8?B?YWtvTE5QSzB2eksveWU2TDBKTkNDb1NVbFNWSWxRUDdyMXM5cEhrbW1UZ25G?=
 =?utf-8?B?NURHU2l2dVJlbVhaUFM5ekpQVmFPQmhxa1VmWmFsWmEzakFkMW0yTFY4MFB3?=
 =?utf-8?B?K3VpcjZkRUg2YUt4NVRsN1hhQVNpdG9od1VHN0Zza0hxemZGL0UzeXpyZXhh?=
 =?utf-8?B?NnRUZThveHA2bU9qbUNZcFdFRHVyVCszdXdSb2hFdnk0TFNjRHZITnBlS1VG?=
 =?utf-8?B?Y05vSnR1dHBGS25rRFY1c1ZOUit5Yk5rZ1g4TjNpek1xNG4yUSs4UlpOUzJl?=
 =?utf-8?B?aWdqMEhxdkZ2ZTdiaVorYXZHcXRBS2h4aFMzRlMyTXFBcWhTakpEQ2J4Snov?=
 =?utf-8?B?aVM4ZDdENGdGU0ZXalo0ZDRvVVNlczNjUytjTVRaK245Z3hJT3ZkYUJxUEpY?=
 =?utf-8?B?S2g4b0pOZ3VCM0VlRVdpS1ZhTEZ1RHo5WUowZDhXZTBDTEdWbDJEVGxIR2dx?=
 =?utf-8?B?NjNuZXJ2eU4wRzU5QnBzNTJOLzE4L1RkUXRwSkUzclM1Z1QvS2czU0VkSFE1?=
 =?utf-8?B?ZDRRV1VVbVYrTVBnL2N6Vng3N0dQdjhXeXJjaXdIcnViL0tWVzc3dTIwbXhV?=
 =?utf-8?B?eDBPR1pDY0pxcHZHU1BGaU5FNXIyOHRJeWY4b3FLY00zMWkxZHNZdEtUVkJz?=
 =?utf-8?B?V0NTNVVXcmR1T0oyN3BqRkk4SzlOdVRIWlZ6L0krMHpsVnlYWFNTK1hXTEM2?=
 =?utf-8?B?QmJBcVl6UlJ6OTJPOUI4VXdoTTZBV2pRa0lhSk5PSWxsUzZIam5RVDU3N3gv?=
 =?utf-8?B?cDJWYVptaWdVODBUREs3ekhZSklrbWg5MkxVWGhPR3pnOER0OVo1NllmejVD?=
 =?utf-8?B?NlFId2xQQ3k5d1lQSTlldENncU9rcjVSRGpJS2c5b01EbkJ0RFRmc2pHWG9y?=
 =?utf-8?B?WjM5czd1Z0cwTlJsQVBlZSs0Q0EzMFpiTTNNRjZUSmUwN1M1dzdJYzRJNlY4?=
 =?utf-8?B?Skt6UXVlM1R4OUhwNDlTYmFkWXhLYzJSVGxLcGVWODZ2elFXK2Y2SkFOTXFm?=
 =?utf-8?B?RzZUK3p1aEswWGZOWitlTmxLc01kdUl1aklqV081QXE3VDFLa3UwQzgxVmYv?=
 =?utf-8?B?U2lvenNsTDZISDJiWitLNFFoZGJRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B71E9299858BEE4E8A055EE9BD59B0FA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4718.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d200a3f-00da-4261-f0a5-08d9ecfbcc5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 01:14:05.7688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CultVxwkPNyi5k8uJqhJl0rPA6r0cKL8CvVypka5Q+TjQdNz4rhoHYR3e0yZYFi6NJndoDxkl1i/48cmF73Nkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1694
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110002
X-Proofpoint-ORIG-GUID: wYVJwHjtl0ySA4Y58LEZ3jCN78bfYm9J
X-Proofpoint-GUID: wYVJwHjtl0ySA4Y58LEZ3jCN78bfYm9J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIEZlYiAxMCwgMjAyMiwgYXQgMzoxNCBQTSwgTXVoYW1tYWQgVXNhbWEgQW5qdW0gPHVz
YW1hLmFuanVtQGNvbGxhYm9yYS5jb20+IHdyb3RlOg0KPiANCj4gT24gMi8xMS8yMiAxOjMwIEFN
LCBTaGVycnkgWWFuZyB3cm90ZToNCj4+IHNlY2NvbXBfYnBmIGZhaWxlZCBvbiB0ZXN0cyA0NyBn
bG9iYWwudXNlcl9ub3RpZmljYXRpb25fZmlsdGVyX2VtcHR5DQo+PiBhbmQgNDggZ2xvYmFsLnVz
ZXJfbm90aWZpY2F0aW9uX2ZpbHRlcl9lbXB0eV90aHJlYWRlZCB3aGVuIGl0J3MNCj4+IHRlc3Rl
ZCBvbiB1cGRhdGVkIGtlcm5lbCBidXQgd2l0aCBvbGQga2VybmVsIGhlYWRlcnMuIEJlY2F1c2Ug
b2xkDQo+PiBrZXJuZWwgaGVhZGVycyBkb24ndCBoYXZlIGRlZmluaXRpb24gb2YgbWFjcm8gX19O
Ul9jbG9uZTMgd2hpY2ggaXMNCj4+IHJlcXVpcmVkIGZvciB0aGVzZSB0d28gdGVzdHMuIFNpbmNl
IHVuZGVyIHNlbGZ0ZXN0cy8sIHdlIGNhbiBpbnN0YWxsDQo+PiBoZWFkZXJzIG9uY2UgZm9yIGFs
bCB0ZXN0cyAodGhlIGRlZmF1bHQgSU5TVEFMTF9IRFJfUEFUSCBpcw0KPj4gdXNyL2luY2x1ZGUp
LCBmaXggaXQgYnkgYWRkaW5nIHVzci9pbmNsdWRlIHRvIHRoZSBsaXN0IG9mIGRpcmVjdG9yaWVz
DQo+PiB0byBiZSBzZWFyY2hlZC4gVXNlICItaXN5c3RlbSIgdG8gaW5kaWNhdGUgaXQncyBhIHN5
c3RlbSBkaXJlY3RvcnkgYXMNCj4+IHRoZSByZWFsIGtlcm5lbCBoZWFkZXJzIGRpcmVjdG9yaWVz
IGFyZS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogU2hlcnJ5IFlhbmcgPHNoZXJyeS55YW5nQG9y
YWNsZS5jb20+DQo+PiBUZXN0ZWQtYnk6IFNoZXJyeSBZYW5nIDxzaGVycnkueWFuZ0BvcmFjbGUu
Y29tPg0KPj4gLS0tDQo+PiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9zZWNjb21wL01ha2VmaWxl
IHwgMiArLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+PiANCj4+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9zZWNjb21wL01h
a2VmaWxlIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvc2VjY29tcC9NYWtlZmlsZQ0KPj4gaW5k
ZXggMGViZmU4YjBlMTQ3Li41ODVmN2EwYzEwY2IgMTAwNjQ0DQo+PiAtLS0gYS90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9zZWNjb21wL01ha2VmaWxlDQo+PiArKysgYi90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9zZWNjb21wL01ha2VmaWxlDQo+PiBAQCAtMSw1ICsxLDUgQEANCj4+ICMgU1BEWC1M
aWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4+IC1DRkxBR1MgKz0gLVdsLC1uby1hcy1uZWVk
ZWQgLVdhbGwNCj4+ICtDRkxBR1MgKz0gLVdsLC1uby1hcy1uZWVkZWQgLVdhbGwgLWlzeXN0ZW0g
Li4vLi4vLi4vLi4vdXNyL2luY2x1ZGUvDQo+IA0KPiAiLi4vLi4vLi4vLi4vdXNyL2luY2x1ZGUv
IiBkaXJlY3RvcnkgZG9lc24ndCBoYXZlIGhlYWRlciBmaWxlcyBpZg0KPiBkaWZmZXJlbnQgb3V0
cHV0IGRpcmVjdG9yeSBpcyB1c2VkIGZvciBrc2VsZnRlc3RzIGJ1aWxkIGxpa2UgIm1ha2UgLUMN
Cj4gdG9vbHMvdGVzdHMvc2VsZnRlc3QgTz1idWlsZCIuIENhbiB5b3UgdHJ5IGFkZGluZyByZWNl
bnRseSBhZGRlZA0KPiB2YXJpYWJsZSwgS0hEUl9JTkNMVURFUyBoZXJlIHdoaWNoIG1ha2VzIHRo
aXMga2luZCBvZiBoZWFkZXJzIGluY2x1c2lvbg0KPiBlYXN5IGFuZCBjb3JyZWN0IGZvciBvdGhl
ciBidWlsZCBjb21iaW5hdGlvbnMgYXMgd2VsbD8NCj4gDQo+IA0KDQpIaSBNdWhhbW1hZCwNCg0K
SSBqdXN0IHB1bGxlZCBsaW51eC1uZXh0LCBhbmQgdHJpZWQgd2l0aCBLSERSX0lOQ0xVREVTLiBJ
dCB3b3Jrcy4gVmVyeSBuaWNlIA0Kd29yayEgSSByZWFsbHkgYXBwcmVjaWF0ZSB5b3UgbWFkZSBo
ZWFkZXJzIGluY2x1c2lvbiBjb21wYXRpYmxlLiBIb3dldmVyLCANCm15IGNhc2UgaXMgYSBsaXR0
bGUgbW9yZSBjb21wbGljYXRlZC4gSXQgd2lsbCB0aHJvdyB3YXJuaW5ncyB3aXRoIC1JLCB1c2lu
ZyANCi1pc3lzdGVtIGNhbiBzdXBwcmVzcyB0aGVzZSB3YXJuaW5ncywgbW9yZSBkZXRhaWxzIHBs
ZWFzZSByZWZlciB0byANCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9DMzQwNDYxQS02RkQy
LTQ0MEEtOEVGQy1EN0U4NUJGNDhEQjVAb3JhY2xlLmNvbS8NCg0KQWNjb3JkaW5nIHRvIHRoaXMg
Y2FzZSwgZG8geW91IHRoaW5rIHdpbGwgaXQgYmUgYmV0dGVyIHRvIGV4cG9ydCBoZWFkZXIgcGF0
aCANCihLSERSX0lOQ0xVREVTKSB3aXRob3V0IOKAnC1J4oCdPw0KDQpUaGFua3MsDQpTaGVycnkN
Cg0KDQoNCg0KDQo=
