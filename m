Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE334AFD7A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbiBIT3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 14:29:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiBIT2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:28:30 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B54C1DC72B;
        Wed,  9 Feb 2022 11:28:20 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219HJBxM020526;
        Wed, 9 Feb 2022 11:28:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EwqvrSqLGnu51uynUHDu0tLl7FYydimP92oC62pr4Ec=;
 b=bZFmePZkyu9LrzCUF7t6WxcXu6LaojFoaOlL9Dg8ZJWGqMCf2vrdfGdbv0qlZLqHF+Ek
 IRRjWp4F7ddJ/B/NAWWq2YCcMHCZ7vUl2l3ooQJ5AKUBIl8B0ZjsI1U28Aak5EvsWjfX
 +QTQDWJFsWgWwau479+zvIsMWObrjawjHsY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e4fyk20dh-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Feb 2022 11:28:00 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 11:27:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsLScBQrriHXtJaTWMknVXceLt1Qq0n6ZNKCMSRTMGS1SK+E3FlskZWbaDz6EC60aKUIFVOQ2jYk2BgleaPvoTX1xAA05lgryuL6Xrdlo6JtW9r/veabr0/DjoEKCXYahQv6Q2ahyDeoPcd+oA+2XGH/9T1fBZWeVfQsrygs5pR+8VGkiNVaLyuXeOIqbRuLMFzYSiHSpzsvt3m4sfxGY0TNCKbX2V+rbwiuZCdp6C3HJUVGTvoHVza1aUVqygnUsnh6uV+BZ4kJf5omONfKUgm+kIZEs/kh+9PvP2kxZIJ9TpOtj5G/ZaoDsEldypi9afrudRtMIaESWZ2P98UPwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwqvrSqLGnu51uynUHDu0tLl7FYydimP92oC62pr4Ec=;
 b=nzwh6g+Fi9/eiGTp/RyUwOkzFAKrQCtWsplCiHNfxyF7m4+4Bb6wUgmmcD5zOrU4lEGTboWcY3I1Xan4UtMbxU+e6qcwK704pvxcT5qRquYSargw2aGW9l0R6KHNL5SzDd8kLUofG/yMibxjCr1dEq5mh7A7BxT7HAREBhVkODWr/BuaLbujN3blCz1MkPQIzm7GoI45PPQm8pEe2Vh+5EjDywupoujRR03DZqVYljSBtxZB3dneuWzrOyfbCbKTIojgAqAoGX91HlklbiRIC0mO9pPbMFCL+GAV3L9SDW2cXVOIWcy3BhgOxMJapmMot+TL9k3z+Q65aSD4KWmjvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1647.namprd15.prod.outlook.com (2603:10b6:300:121::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 19:27:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 19:27:58 +0000
Message-ID: <5f0cf759-7472-5627-291b-d087392ab727@fb.com>
Date:   Wed, 9 Feb 2022 11:27:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next] lib/Kconfig.debug: add prompt for kernel module
 BTF
Content-Language: en-US
To:     Connor O'Brien <connoro@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220209052141.140063-1-connoro@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220209052141.140063-1-connoro@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR10CA0007.namprd10.prod.outlook.com (2603:10b6:301::17)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28a774b3-7d31-4115-73a1-08d9ec024737
X-MS-TrafficTypeDiagnostic: MWHPR15MB1647:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB16475EB1877BD9397573EEE9D32E9@MWHPR15MB1647.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ciwKj7mTvcxLi9A43hizfvcKAtJCMoJ8U0f1z0Q4Fso1UIcu8v7fM11TYVwzgwGQITsJ4mJCyWG0MZ2s6DMfRV/VJbmDa+Y3SFh7U2iL0rr6c9yG1RHUE8mL3AXjUEXLPUfd/87CK/l1Tgn+R/kCFSd+2gJA+kf22WhDkqzBPWyYYqcvAATNucymAUi37iOCIBXWoPjis1WiWu7OjE4QnCGHIAcXLoCLHRcWJD/qV7pfX36B1SW8uwalFeDLiQ0klRtg4M139Ic3JR18ep3ASOksoyVVuVpvENyfZmfKlv0hyRA2i4WnOKMdd9wo6ZKebuRY2TZw29YkQWu3gdsXgS158gYpBVlXHhKlkBIygcB8YCzvnS4IVQAXoc2zi9muii0qCTNZ9pBgzRJ1vNLzE12zVRuPr+bRd+bPx8RRkBwt1NRgE66tWgMeyML9rbAqULyW+XJ/hMzPh3bSlBfd5AWs4TW10OX4fMRPQKlkfByV3qMbopbrswB/a5pfeQnsTMgL/ow8/jysivPwCcnJgzt7t7AdkdlZloP6y3MzBhClns7265pJEbVmmtJZXcBbq5+P+Sshu8Iq8tI8QOCmq1C4bLmbLGgpvuOKkpqoLL6Kk8bpoZ/ntwn4P5Ojyx0aIDWpLRYPwUdCGupzYFqKCCzk5zfbxf53BEVJORnweegRJmsyMsPUQ4lA9r0QhydHrQ4e1gGUNHsmamS0r/aNrGYHxaIu3vSsUPqoRA1QGEVVz4QTqgH/y5JrrsuzLRmJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(52116002)(8936002)(36756003)(2616005)(316002)(54906003)(110136005)(6512007)(6666004)(6506007)(6486002)(31686004)(508600001)(5660300002)(8676002)(31696002)(83380400001)(86362001)(66476007)(66946007)(4326008)(66556008)(186003)(2906002)(4744005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0VrVVZFTmxRRE9uY1pzdm5uaDFmOXptK1NnUmY2anEyYkxmU2Ixd2M3M1RN?=
 =?utf-8?B?eEsvNDkybW9BNmNxL1NRc1NncnBNWk0ySWRQbmY2b0Q3MnNTaWxyL0JGSjJx?=
 =?utf-8?B?T0dnNkMzTlJFRGgxRjlkS2NtdTZmUit0SDgvWUhOWHVKZ2tzajlPYk1hTlND?=
 =?utf-8?B?NnBHOFY3dG40NmgvdGQxR2VWZHh6MFRmMWZYZXFuaXFUZE9NZmtvRGtNVkVU?=
 =?utf-8?B?K2FJTEYvc1VPek1pOTVQUHBSUmtPNlhkdTk4NTRJWkMrV2RhaUNFTks4ZkVs?=
 =?utf-8?B?QVlMSC9iNVVWeTJjQW1oNGZnSkkzdFBITVMySExSTUxXbHdCTjRlblZQMndu?=
 =?utf-8?B?bWhZUGlLcXoyYVhJMUNDajYyblBoZGNUQ1dFR01hQ0FxMUNZRkpwZ1d0OVJ6?=
 =?utf-8?B?akdGTVVoZ1ZmUW9aeTExbTFlTENlUGY5MllkL2NVZTVaVzMyRW8wdytnZGw1?=
 =?utf-8?B?K3RNZklIQy9XRHpmajlJRWpjOGZPaU9QMmN2emZCRW9RcHdSWnYwR0g0bzdW?=
 =?utf-8?B?OEQ2SE5ERVJqVjBjd1oxMm5xdkdDL1ZoNlIrVXNDSWpLNXJISWlzWStZYW1U?=
 =?utf-8?B?bGhZV1pPZmIxVTZOeUxidHk3c3hkekVjLzhQZ2hXclAxL2NuT1E5RTh6Y1Zi?=
 =?utf-8?B?Q0EwbndYUTdTS3ErOThpcmIyNUpibzlDSTB5N1JxV0xvMjJ5OGFGbnFQY3lw?=
 =?utf-8?B?Y3oxYmFHWWo4aTZ3b29pK2lGdzR5Q3VKZC8vWlQ0UE0yMmwrUkF1OTlHRTRk?=
 =?utf-8?B?UldmZDdDOXlvS0JDSUg2eFVwaGd6S3NpSjNZME05OTg5OG4vYUNXSVhKam5U?=
 =?utf-8?B?UndMNHY4ak9oQ2VqcFp0ZXFrRUlaUUhWSURsR3JNRURwTU9reGdjYXUxd3hK?=
 =?utf-8?B?djlFdFExajhmUFdmcENUZjBWUUdUMUgrQ0VDbm02QnFJZmRxcG5KZkxXbkVJ?=
 =?utf-8?B?ajhPSkxKdFhKdmJmWFQ0UjFLRW1TWGs1ZjBlZDJVTTFFdi9KUWt6cjlHUE50?=
 =?utf-8?B?bTl2REpYcW9hREU3UUFBMFVGTmt6TkdQSHBkZ2gvazVWcVNTbGlOR2VlVUEv?=
 =?utf-8?B?UWZFT1ptNmFyK1hYM2FzQkgvM1NhTm5iaGZEYnEwdURxNFk3K1NvdnlseDNV?=
 =?utf-8?B?S2xoZXVFOHVlWkFuMHlnU2greHZOSEVPM1VYVnNxWTgvN2tTQUo3N0tvanVD?=
 =?utf-8?B?RndNbkptOGIyUjAzdytlSEc2c004WkQ5eGs2WmI4UEc4U05tL3VvTmVMTkVa?=
 =?utf-8?B?WXM2eXBkSUJTS1N5OGJxMklKTUlqNTdVT0s1cUthUngxVlN6b0puNkd3QjBz?=
 =?utf-8?B?c1BBYkIxb1N2eHZaYnllQlEveWU3enp5WlhVb2tqeEdMcUNDcDR1OWpiYjJU?=
 =?utf-8?B?QXRray9NWXptbnFDL0FUbk5xbTJRYlZtc2Z2bm9jWW8vWW5MdTI0cFJqUnhV?=
 =?utf-8?B?MGJXRG1CZUkwRXVBTWd6V2oybDQ5d0ZiWEJReWFRTTZ0UE5RY0FRRWhPMVU2?=
 =?utf-8?B?YUxRTW84cndBVmRxL1NQSE1MK0FVTDdQNUdyc3VQWFoyWGdhdTRLY0ZSUWt3?=
 =?utf-8?B?V0FlaExXMWYzWGJnYWtNS3VRMk1iQUtUaHIvSnhjL2hRbVlzNytCY0FjaFlS?=
 =?utf-8?B?THZFM0tMVy81eDV0L3VQbkhqQXh3enFEdFdaNTFaQklwMmF4RzRqSGlCOENZ?=
 =?utf-8?B?bWdPUmtzcDdNc1U3UEFCV1BzS2U5d3RURy92TWNDaHJXUVFZQkM3bGxINUpi?=
 =?utf-8?B?TXVBUFEvU3ZySGY4elZJMEd3M2Q2MXpUaTA0RzJiVUg2U1lYbXhyTnlsZE1i?=
 =?utf-8?B?cFVIOUlHOHNHVitwZjlOalk0QmZoTjBLMkkvWXpYMElVWmVmTDZ4S1JUbEcx?=
 =?utf-8?B?UDhXM094QjZBcGVjUVl1TGZubXJ0dkcrdnhPT0JVTGJ1RWJDUVd5a1lxeUty?=
 =?utf-8?B?QjhyejFmU05LaDhNT2I2b0xDSWwva1VGY0tEMFZwV3JRNTA5VFpqSlBqODQ3?=
 =?utf-8?B?NGtJOU9jaVRSSUJnODdMdFNDK01kSnI2U1JBSTIyK2ZhZUVnT1NEVnJVVm1M?=
 =?utf-8?B?RXY0eDBnV1BCNThrUEtZMWlnV1lPd0NsZHVrclZRT0hjYzl1eHpvNDB5NGJU?=
 =?utf-8?B?Tmw1UFo4U2dBYzBLVFREZFl4QmVqUVp4YjVMNHlTS042dmNpTUZ2eGM5OHpV?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a774b3-7d31-4115-73a1-08d9ec024737
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 19:27:57.9791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVWXVsk5K4BQZXtOekagAYyFqViszxPFsJMvxaknTSmqhPfn3/SNGkfM8rjskpGF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1647
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: yw7Vu2Fb5I2907iE_smqlgfIBDF9AtKn
X-Proofpoint-ORIG-GUID: yw7Vu2Fb5I2907iE_smqlgfIBDF9AtKn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_10,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=928 bulkscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202090103
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/22 9:21 PM, Connor O'Brien wrote:
> With DEBUG_INFO_BTF_MODULES enabled, a BTF mismatch between vmlinux
> and a separately-built module prevents the module from loading, even
> if the ABI is otherwise compatible and the module would otherwise load
> without issues. Currently this can be avoided only by disabling BTF
> entirely; disabling just module BTF would be sufficient but is not
> possible with the current Kconfig.
> 
> Add a prompt for DEBUG_INFO_BTF_MODULES to allow it to be disabled
> independently.
> 
> Signed-off-by: Connor O'Brien <connoro@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
