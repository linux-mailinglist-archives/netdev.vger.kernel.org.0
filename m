Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EDE588567
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 03:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiHCB1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 21:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiHCB1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 21:27:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73729205E0
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 18:27:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2730i7WN015726;
        Wed, 3 Aug 2022 01:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HXf0EFRR3QaJlvp5veO7yUtGiMYlQ/lrv+h86OJq7bY=;
 b=1nRT+JbRdytQNaoUEKvXsYEt1IPn/bF4vEnn7TP4bPhZt6SGO/6QyHM3yGMvicgSYjUZ
 +RTumnZ6n2bJpUAMcYAeCpMCXBDFlsDKqGU/MJ0ESrl0bB2OUU5rsi8zwiR8+iq6c0pM
 O2EhSl/wpucNXA+rrHlF7PrAnsyT0zCbdu5gwTbifsWN2usc2uthJ5MkBjBRcrA+8r1C
 tWzhxnxUjtSsHALfYOlh/k95wioMj66qvF4y2HeonHx9AGWmPw+S/3XkFAmko7Z+I4Jv
 52D8vftHE3iJ0DOj7+RNZDy9oPAxhOlkXCfCvBPLMFl97FjeVbmqgEm1DRbnyFld16oR WA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu810hy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 01:26:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 272NZD7K014202;
        Wed, 3 Aug 2022 01:26:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu32wetp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 01:26:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOspsPJ2xKdqQt9y7IsXYpuFYjBjOLQqn3hiVOGl25FT3VD6tRwoLul5KC3C2bfDew5UL79wQAM4h/mhwnNlIuLrk6EVYVvPedcdEGD0urLlGnm7savo9YIfVoqpFSX0mAzDRYHBXCnCbiBlyRyFBBVjGG3arWBS9hRSqrjwtt70NriC3VXEwos0C1vFEdMc2K/BDKwuJ6AOf7eLHJkOcgoQSSd50sG7/CZ3e3zyDFYMIkovr8HX1eYPA2c+11IX5Lj6d/+27mlTGvSKVSFofUXbW33WbNQjfGB7/tJSezIr0G5UMSTLhIY+BljOzAps8F5UV4wFMyUa58yYvgMjsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXf0EFRR3QaJlvp5veO7yUtGiMYlQ/lrv+h86OJq7bY=;
 b=ebQ6+Ln1peFN4KSZeEL8/Kw/4Yvda077VniwMGy9JMFEq69ZtjIaKgvfKprolWu7n4MgxC7tykOxXrYHRRIjpsifjWEoK7gzuhu47VD8i//BN6H1iSESL/9LWomd+ybj8Ce+AoOVE/N/i/3qutf56+6vINlfNtzOZlC2GaZ7991XiYHWedwUXPpY1/95qFdqx6S2cRwifc9op2pm2nHxcROtGd2wrltq5ikL7uAYzVsXjTKKwPc5DyqQ2x8gTJfrn33B3Of+mK+AyZshCU5k4gZLf6+du737vv2Hi0kkpC2xtQZAmcIuXHuvjDGe8WWP63x+QVPO4YHSlmxg6uysgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXf0EFRR3QaJlvp5veO7yUtGiMYlQ/lrv+h86OJq7bY=;
 b=gKUjRwfHlMREmZHBHWGWmz88OIB0aC6q8F1aL8kHetveXEgouZTKKpvSIxzJ1BT3pPi3kim6MP9406TZfe2ZgwUS7aZdAxcBfG2jUPz0hFdU/yFprBo52lrQ/XBTHXtIb1tvre7QJp6fWFPu6eKtL4rpTVGlAjBa8/utc50CtXY=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 3 Aug
 2022 01:26:54 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 01:26:54 +0000
Message-ID: <a2b2fe74-4633-2911-b953-25fcb8e81665@oracle.com>
Date:   Tue, 2 Aug 2022 18:26:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00889067-50ac-d2cd-675f-748f171e5c83@oracle.com>
 <63242254-ba84-6810-dad8-34f900b97f2f@intel.com>
 <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
 <00e2e07e-1a2e-7af8-a060-cc9034e0d33f@intel.com>
 <b58dba25-3258-d600-ea06-879094639852@oracle.com>
 <c143e2da-208e-b046-9b8f-1780f75ed3e6@intel.com>
 <454bdf1b-daa1-aa67-2b8c-bc15351c1851@oracle.com>
 <f1c56fd6-7fa1-c2b8-83f4-4f0d68de86f4@redhat.com>
 <ec302cd4-3791-d648-aa00-28b1e97d75e7@oracle.com>
 <c77aa133-54ad-1578-aae3-031432cc9b36@oracle.com>
 <CACGkMEuUVicQX87PDCO87pckAg5EMQ9OGura2J35DaR0T=COfw@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEuUVicQX87PDCO87pckAg5EMQ9OGura2J35DaR0T=COfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::11) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c13a2059-3218-4925-9272-08da74ef3fb6
X-MS-TrafficTypeDiagnostic: SA1PR10MB6318:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0gxMTxPEbfKAXBRJQ8E0CTaUgzvTih0OL9zRcvUTfotnud7wz+DEXZDYXT64eETY4GJJ4Avv27l+bsCKZ0i9Rq9Zo96CeZBtiyLu6htZLbSlBCMTkqzGVZIcB693b6sJJWanMhR9dCBsC14g8g/uAWS+/V0UHbei/ZU2s/22Y0DVPNt2o6WMG+uDAeCOpO3e/lLMwNccc7IThYpv9BBZb40E5PXrhRg/dBUs6sHJTLJoseLvcsHFpMB4yip9OTbyzg56eu43jeAl1vP+ZxZz3KfJQFfVpXFMTVOkOmiugPaFYF0fDQP1JTm98Hou28jcTTGc84yXdnA+MGU+aXkn1mWroKe8lEN6VrHHbWFzeq+uxLfx2jCYrjVZ/yMmnvdEcMSYUSO081NSzMuJfZLt9KHSqlXlVxbdLP15X3UKKCly1vmtu0/sNGCQu37yAhCr5J3fb4XUcF04fOH9z73KWKIsb71J06iGnudkJXFG/6Anr+aaUCZysxegudgavKmA6ovgmpTaXMtiSLdoSdAtkPhjA5eFHW5FIbg+oSNhtA7vesNEwfh5WORZ9/fISjI55bSO0KRdEXeW4+nWdVY5hhCBa91216QIpt3jvsGTn4LWvW2tWLMZyTFIpNKcW6MTcgd3tBOIbELOPOURylqJMU1AmOY3Jk36hcoEBhlH8cnj6KDb5RkGcfhr0nP5u9/25NxpsweqQrz3M6CSLIWzWlX3mY9SXXtckmmsjH4fgqwP1BcDsZ/PxtgDMrBsvyPWmTCHR1EQEQ3lbWFSZGGGhZUVtp8oLIRvGtP4Mv3J95ebxYd65KivA7kSc2RQtGyxmHdgdQEc3a3glMBEoD0N+EN+V70Ljk8+T5HMkaTlufg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39860400002)(346002)(366004)(83380400001)(31696002)(38100700002)(186003)(4326008)(36756003)(8676002)(66556008)(66476007)(8936002)(30864003)(5660300002)(31686004)(2906002)(66946007)(6486002)(966005)(6916009)(478600001)(6506007)(316002)(41300700001)(6512007)(26005)(6666004)(53546011)(86362001)(36916002)(2616005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUdLemFSYkF5cEhYYzZsdTc0QlgxNE1QUGE3L3lscjFveU5JQ0NOOG90dzFB?=
 =?utf-8?B?UHF0bnllMGlLa1lyOE5uN0tzQ1U0bEtaSHNPOWhteUp2UUI0a2FqU2hxR294?=
 =?utf-8?B?WFB3ZnQ2RER4eS9SbS9wbEZ3MHc0akF0bmpWN2x3MVNNSHhib3RaVlFmQ0Ns?=
 =?utf-8?B?WDlVSXJodE1PSUZ2UTlXRERyS0kvMW9BOTVKbk5zSzA5eHNnU3NSZ0hydEg3?=
 =?utf-8?B?Qkw0eDlzQ3BpQlpoU0w2cjgvZWZyZHZOY0ZLTXk1a1AxQ0hVcVRENTdheG84?=
 =?utf-8?B?TUx1RmN2S2daYm1WVEF4RXBiTnZ1R1lNZllEOTAyQVVMZlpaYTB0TFZRRm1F?=
 =?utf-8?B?QkxlR3F6UDRxalRiTVVUNEx1VTF0eHV2SUhUbklpNExiWkxGS2ZBbkRXb25M?=
 =?utf-8?B?c2FkMVdwUzVicC9CZGlGSTRIa2U3eVFOVlF4OGdCdlRJSEZJUU9zbTFsakNG?=
 =?utf-8?B?N1RHbGg2dUxNd2phUE9yYXlxWDRvVG5PTzZjb0pvNlJUYUdjRzRZSE9tT1hj?=
 =?utf-8?B?TmxiWUpXbkxaY0xvVGZsT2JVQUhmakttMCtHdGJDaVVYWmF2STMyK3NEamd4?=
 =?utf-8?B?R0YxaW15TmF1bVR1NGRBTWVZcHBGcjVPWkx2UU82Q3M0VE9XeW91OTFCWVI1?=
 =?utf-8?B?MTBWdXNKYllqYU8zbFNycG1Mbk9VSW5pUFZLVDR1b1Yra083OTRDN2xvb1RY?=
 =?utf-8?B?K0w5dkVzTktGZ0NDSktzMjROdnBrQk9obnRzeVJUZHNGekVsOUN2UjNQNHdW?=
 =?utf-8?B?NlgxZzlVZzJ6cFJTVlFlbEk5NDVhY1MxelVBcEhDVHMvRXNrdE9ZQ2wzZGtR?=
 =?utf-8?B?QmlVYzhEdlFCS3JRcEJVYVNkOUNQcnh6TmZLb1lyMGIwcktidnBTOVZkbnBn?=
 =?utf-8?B?MElqZmFBRTR1dmF6WUFsbnVxZGpiWGpES3pjSElLT2FnNE9aNjZ5ekVYUldx?=
 =?utf-8?B?WmFMZHVybnNaOU1XTXk2VVVKd2dObWV0emxNRXNQNXRJZ01HdFlCK1Z5ckph?=
 =?utf-8?B?UkMvdjlrNXBwMGRWSm5IWEFHK3UrS1VESFNVVzYrRVpjK2lWQm9CN3FOaENN?=
 =?utf-8?B?UTZTM0FmaWsrMnV1cmNaOVFteHNjRy9BbVQ2UUdkK0pHWHZQZkFUNUJOSko5?=
 =?utf-8?B?aDVkVVRYdTh2Y1ZpOXE2SE9aUUdkMXVkS0FTM1RlcUpNNDJWYkl5bXhnemhp?=
 =?utf-8?B?KzdVKzhzZ1BENmM5b3AwZzNtbWpFR29DSGtKc3BMSFpyVHpLTmtuOWpxTFJw?=
 =?utf-8?B?NFNmOFpwN3JKL2F3Zkttb1BCMEdxQW8wdTYwWERTOUlaeEJxMGRhQ1lmVW5R?=
 =?utf-8?B?UDlaK2tRV1Y4YTZzNTVlR1RKeWhMSk44eGUxdkw4QjMyN2duU1ltazZObUtX?=
 =?utf-8?B?OGxjMHdBdHBQSHdwc1hPU2Voc3NLT3A2TW1TenFJbFUzdS94enZ6djhtOEE4?=
 =?utf-8?B?UnJQTmkwYkx5cXMzSW1sejRTdEE0aHN0aHBlc3dzbUZkYWpveDF3UzZhZ0d6?=
 =?utf-8?B?NiszNnkzelBYL1VMamJxUTh0T3FSV1BkRm0rb21aUFBSOXM5U2tObHlNVk1l?=
 =?utf-8?B?N1R4aWdmeXBielQ3a3dBVU9uTVVDNDA5VllnOTNIcEh2WWlWZHpUak9xdXNS?=
 =?utf-8?B?c2YyM05IemZJOGtsOXhVZVVHbHV5ZXZHcGJoSWdPZUU4VzkxNjJ0dmlwN0JX?=
 =?utf-8?B?Q3R4NEV2Yy84ZDBDUVphUVlqUUExa1AwcmUwbU1XNWZqS2FWZWRjYnhING5N?=
 =?utf-8?B?Qk9VWjVEbEo3dFpmMndjVWlNOTg5bGo3cS94aXRURk5CRW4yNVB3S0k4MFpF?=
 =?utf-8?B?NmxRMmkzTm83R0ZONWw1WEgzM3hUVTc1cW5zbnY0TVk0eGJ2TGRyaHlwQmdL?=
 =?utf-8?B?SzEyMUM5TjE1VzUrSU9xNFY3T2I5S2VIdTBrQXh6cDVnVjBPSGxIcVh0N0pH?=
 =?utf-8?B?ZHJrUll1YzRDYUw0dXNLSHpRR3NoQW0zOTFYMi92bEM4WnZxZ2ptQUNDVzlK?=
 =?utf-8?B?UGJWTEhyUm9yaXFsa3ZOOVgwbHdFb1RjcEF1Q0JOVUdkbWZYMUd0Qkt0b2F5?=
 =?utf-8?B?YS9XSVgvV2RuZkszN0k5Q2xsUWhrUlpjWDlKbkRVd1lWUlZzZVp5YnJqY1ow?=
 =?utf-8?Q?TRXY/WxFBH58iMNfWOUWptdep?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13a2059-3218-4925-9272-08da74ef3fb6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 01:26:54.3625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EitbRWHKVcx3F+GJjHLcIkKVWKgyYZ628fTarOd2vTGnnfAPeQ7GGYW4qS3P/eoW166s2mKOGrS9nzkHR8GKHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_15,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208030005
X-Proofpoint-ORIG-GUID: UNmC3wKekjR6rW08pYKFdCk4V1leFW71
X-Proofpoint-GUID: UNmC3wKekjR6rW08pYKFdCk4V1leFW71
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2022 11:33 PM, Jason Wang wrote:
> On Tue, Aug 2, 2022 at 6:58 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 8/1/2022 3:53 PM, Si-Wei Liu wrote:
>>>
>>> On 7/31/2022 9:44 PM, Jason Wang wrote:
>>>> 在 2022/7/30 04:55, Si-Wei Liu 写道:
>>>>>
>>>>> On 7/28/2022 7:04 PM, Zhu, Lingshan wrote:
>>>>>>
>>>>>> On 7/29/2022 5:48 AM, Si-Wei Liu wrote:
>>>>>>>
>>>>>>> On 7/27/2022 7:43 PM, Zhu, Lingshan wrote:
>>>>>>>>
>>>>>>>> On 7/28/2022 8:56 AM, Si-Wei Liu wrote:
>>>>>>>>>
>>>>>>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>>>>>>
>>>>>>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>>>>>>> Sorry to chime in late in the game. For some reason I couldn't
>>>>>>>>>>> get to most emails for this discussion (I only subscribed to
>>>>>>>>>>> the virtualization list), while I was taking off amongst the
>>>>>>>>>>> past few weeks.
>>>>>>>>>>>
>>>>>>>>>>> It looks to me this patch is incomplete. Noted down the way in
>>>>>>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>>>>>>           features = vdev->config->get_driver_features(vdev);
>>>>>>>>>>>           if (nla_put_u64_64bit(msg,
>>>>>>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>>>>>>                                 VDPA_ATTR_PAD))
>>>>>>>>>>>                   return -EMSGSIZE;
>>>>>>>>>>>
>>>>>>>>>>> Making call to .get_driver_features() doesn't make sense when
>>>>>>>>>>> feature negotiation isn't complete. Neither should present
>>>>>>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>>>>>>
>>>>>>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill()
>>>>>>>>>>> probably should not show before negotiation is done - it
>>>>>>>>>>> depends on driver features negotiated.
>>>>>>>>>> I have another patch in this series introduces device_features
>>>>>>>>>> and will report device_features to the userspace even features
>>>>>>>>>> negotiation not done. Because the spec says we should allow
>>>>>>>>>> driver access the config space before FEATURES_OK.
>>>>>>>>> The config space can be accessed by guest before features_ok
>>>>>>>>> doesn't necessarily mean the value is valid. You may want to
>>>>>>>>> double check with Michael for what he quoted earlier:
>>>>>>>> that's why I proposed to fix these issues, e.g., if no _F_MAC,
>>>>>>>> vDPA kernel should not return a mac to the userspace, there is
>>>>>>>> not a default value for mac.
>>>>>>> Then please show us the code, as I can only comment based on your
>>>>>>> latest (v4) patch and it was not there.. To be honest, I don't
>>>>>>> understand the motivation and the use cases you have, is it for
>>>>>>> debugging/monitoring or there's really a use case for live
>>>>>>> migration? For the former, you can do a direct dump on all config
>>>>>>> space fields regardless of endianess and feature negotiation
>>>>>>> without having to worry about validity (meaningful to present to
>>>>>>> admin user). To me these are conflict asks that is impossible to
>>>>>>> mix in exact one command.
>>>>>> This bug just has been revealed two days, and you will see the
>>>>>> patch soon.
>>>>>>
>>>>>> There are something to clarify:
>>>>>> 1) we need to read the device features, or how can you pick a
>>>>>> proper LM destination
>>>>
>>>> So it's probably not very efficient to use this, the manager layer
>>>> should have the knowledge about the compatibility before doing
>>>> migration other than try-and-fail.
>>>>
>>>> And it's the task of the management to gather the nodes whose devices
>>>> could be live migrated to each other as something like "cluster"
>>>> which we've already used in the case of cpuflags.
>>>>
>>>> 1) during node bootstrap, the capability of each node and devices was
>>>> reported to management layer
>>>> 2) management layer decide the cluster and make sure the migration
>>>> can only done among the nodes insides the cluster
>>>> 3) before migration, the vDPA needs to be provisioned on the destination
>>>>
>>>>
>>>>>> 2) vdpa dev config show can show both device features and driver
>>>>>> features, there just need a patch for iproute2
>>>>>> 3) To process information like MQ, we don't just dump the config
>>>>>> space, MST has explained before
>>>>> So, it's for live migration... Then why not export those config
>>>>> parameters specified for vdpa creation (as well as device feature
>>>>> bits) to the output of "vdpa dev show" command? That's where device
>>>>> side config lives and is static across vdpa's life cycle. "vdpa dev
>>>>> config show" is mostly for dynamic driver side config, and the
>>>>> validity is subject to feature negotiation. I suppose this should
>>>>> suit your need of LM, e.g.
>>>>
>>>> I think so.
>>>>
>>>>
>>>>> $ vdpa dev add name vdpa1 mgmtdev pci/0000:41:04.2 max_vqp 7 mtu 2000
>>>>> $ vdpa dev show vdpa1
>>>>> vdpa1: type network mgmtdev pci/0000:41:04.2 vendor_id 5555 max_vqs
>>>>> 15 max_vq_size 256
>>>>>    max_vqp 7 mtu 2000
>>>>>    dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS
>>>>> CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>>>>
>>>> Note that the mgmt should know this destination have those
>>>> capability/features before the provisioning.
>>> Yes, mgmt software should have to check the above from source.
>> On destination mgmt software can run below to check vdpa mgmtdev's
>> capability/features:
>>
>> $ vdpa mgmtdev show pci/0000:41:04.3
>> pci/0000:41:04.3:
>>     supported_classes net
>>     max_supported_vqs 257
>>     dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ
>> MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
> Right and this is probably better to be done at node bootstrapping for
> the management to know about the cluster.
Exactly. That's what mgmt software is supposed to do typically.

Thanks,
-Siwei

>
> Thanks
>
>>>>
>>>>> For it to work, you'd want to pass "struct vdpa_dev_set_config" to
>>>>> _vdpa_register_device() during registration, and get it saved there
>>>>> in "struct vdpa_device". Then in vdpa_dev_fill() show each field
>>>>> conditionally subject to "struct vdpa_dev_set_config.mask".
>>>>>
>>>>> Thanks,
>>>>> -Siwei
>>>>
>>>> Thanks
>>>>
>>>>
>>>>>> Thanks
>>>>>> Zhu Lingshan
>>>>>>>>>> Nope:
>>>>>>>>>>
>>>>>>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>>>>>>
>>>>>>>>>> ...
>>>>>>>>>>
>>>>>>>>>> For optional configuration space fields, the driver MUST check
>>>>>>>>>> that the corresponding feature is offered
>>>>>>>>>> before accessing that part of the configuration space.
>>>>>>>>> and how many driver bugs taking wrong assumption of the validity
>>>>>>>>> of config space field without features_ok. I am not sure what
>>>>>>>>> use case you want to expose config resister values for before
>>>>>>>>> features_ok, if it's mostly for live migration I guess it's
>>>>>>>>> probably heading a wrong direction.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Last but not the least, this "vdpa dev config" command was not
>>>>>>>>>>> designed to display the real config space register values in
>>>>>>>>>>> the first place. Quoting the vdpa-dev(8) man page:
>>>>>>>>>>>
>>>>>>>>>>>> vdpa dev config show - Show configuration of specific device
>>>>>>>>>>>> or all devices.
>>>>>>>>>>>> DEV - specifies the vdpa device to show its configuration. If
>>>>>>>>>>>> this argument is omitted all devices configuration is listed.
>>>>>>>>>>> It doesn't say anything about configuration space or register
>>>>>>>>>>> values in config space. As long as it can convey the config
>>>>>>>>>>> attribute when instantiating vDPA device instance, and more
>>>>>>>>>>> importantly, the config can be easily imported from or
>>>>>>>>>>> exported to userspace tools when trying to reconstruct vdpa
>>>>>>>>>>> instance intact on destination host for live migration, IMHO
>>>>>>>>>>> in my personal interpretation it doesn't matter what the
>>>>>>>>>>> config space may present. It may be worth while adding a new
>>>>>>>>>>> debug command to expose the real register value, but that's
>>>>>>>>>>> another story.
>>>>>>>>>> I am not sure getting your points. vDPA now reports device
>>>>>>>>>> feature bits(device_features) and negotiated feature
>>>>>>>>>> bits(driver_features), and yes, the drivers features can be a
>>>>>>>>>> subset of the device features; and the vDPA device features can
>>>>>>>>>> be a subset of the management device features.
>>>>>>>>> What I said is after unblocking the conditional check, you'd
>>>>>>>>> have to handle the case for each of the vdpa attribute when
>>>>>>>>> feature negotiation is not yet done: basically the register
>>>>>>>>> values you got from config space via the
>>>>>>>>> vdpa_get_config_unlocked() call is not considered to be valid
>>>>>>>>> before features_ok (per-spec). Although in some case you may get
>>>>>>>>> sane value, such behavior is generally undefined. If you desire
>>>>>>>>> to show just the device_features alone without any config space
>>>>>>>>> field, which the device had advertised *before feature
>>>>>>>>> negotiation is complete*, that'll be fine. But looks to me this
>>>>>>>>> is not how patch has been implemented. Probably need some more
>>>>>>>>> work?
>>>>>>>> They are driver_features(negotiated) and the
>>>>>>>> device_features(which comes with the device), and the config
>>>>>>>> space fields that depend on them. In this series, we report both
>>>>>>>> to the userspace.
>>>>>>> I fail to understand what you want to present from your
>>>>>>> description. May be worth showing some example outputs that at
>>>>>>> least include the following cases: 1) when device offers features
>>>>>>> but not yet acknowledge by guest 2) when guest acknowledged
>>>>>>> features and device is yet to accept 3) after guest feature
>>>>>>> negotiation is completed (agreed upon between guest and device).
>>>>>> Only two feature sets: 1) what the device has. (2) what is negotiated
>>>>>>> Thanks,
>>>>>>> -Siwei
>>>>>>>>> Regards,
>>>>>>>>> -Siwei
>>>>>>>>>
>>>>>>>>>>> Having said, please consider to drop the Fixes tag, as appears
>>>>>>>>>>> to me you're proposing a new feature rather than fixing a real
>>>>>>>>>>> issue.
>>>>>>>>>> it's a new feature to report the device feature bits than only
>>>>>>>>>> negotiated features, however this patch is a must, or it will
>>>>>>>>>> block the device feature bits reporting. but I agree, the fix
>>>>>>>>>> tag is not a must.
>>>>>>>>>>> Thanks,
>>>>>>>>>>> -Siwei
>>>>>>>>>>>
>>>>>>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>>>>>>
>>>>>>>>>>>>> Users may want to query the config space of a vDPA device,
>>>>>>>>>>>>> to choose a
>>>>>>>>>>>>> appropriate one for a certain guest. This means the users
>>>>>>>>>>>>> need to read the
>>>>>>>>>>>>> config space before FEATURES_OK, and the existence of config
>>>>>>>>>>>>> space
>>>>>>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>>>>>>
>>>>>>>>>>>>> The spec says:
>>>>>>>>>>>>> The device MUST allow reading of any device-specific
>>>>>>>>>>>>> configuration field
>>>>>>>>>>>>> before FEATURES_OK is set by the driver. This includes
>>>>>>>>>>>>> fields which are
>>>>>>>>>>>>> conditional on feature bits, as long as those feature bits
>>>>>>>>>>>>> are offered by the
>>>>>>>>>>>>> device.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only
>>>>>>>>>>>>> if FEATURES_OK)
>>>>>>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>>>>>>
>>>>>>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>>>>>>> And
>>>>>>>>>>>> It should be in format
>>>>>>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if
>>>>>>>>>>>> FEATURES_OK")
>>>>>>>>>>>>
>>>>>>>>>>>> Please use checkpatch.pl script before posting the patches to
>>>>>>>>>>>> catch these errors.
>>>>>>>>>>>> There is a bot that looks at the fixes tag and identifies the
>>>>>>>>>>>> right kernel version to apply this fix.
>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>    drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>>>>>>    1 file changed, 8 deletions(-)
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device
>>>>>>>>>>>>> *vdev,
>>>>>>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>>>>>>        u32 device_id;
>>>>>>>>>>>>>        void *hdr;
>>>>>>>>>>>>> -    u8 status;
>>>>>>>>>>>>>        int err;
>>>>>>>>>>>>>
>>>>>>>>>>>>>        down_read(&vdev->cf_lock);
>>>>>>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>>>>>>> completed");
>>>>>>>>>>>>> -        err = -EAGAIN;
>>>>>>>>>>>>> -        goto out;
>>>>>>>>>>>>> -    }
>>>>>>>>>>>>> -
>>>>>>>>>>>>>        hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family,
>>>>>>>>>>>>> flags,
>>>>>>>>>>>>>                  VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>>>>>>        if (!hdr) {
>>>>>>>>>>>>> --
>>>>>>>>>>>>> 2.31.1
>>>>>>>>>>>> _______________________________________________
>>>>>>>>>>>> Virtualization mailing list
>>>>>>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>>>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!NzOv5Ew_Z2CP-zHyD7RsUoStLZ54KpB21QyuZ8L63YVPLEGDEwvcOSDlIGxQPHY-DMkOa9sKKZdBSaNknMU$
>>>>>>>>>>>
>>>>>>>>>>>

