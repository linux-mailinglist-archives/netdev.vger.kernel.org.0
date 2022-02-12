Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78434B325D
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351872AbiBLBQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:16:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbiBLBQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:16:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57118D83
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 17:16:03 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BNK2KV019101;
        Sat, 12 Feb 2022 01:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pIZpUNpiTnFyYNUN/V6p0EXBoCeERbXRYaRb1aWdW5c=;
 b=o2C/9BOQn4IeCGeb7nA8u/OKOGp6utWyZbK/c/jJHXwL81L46K0s4fG/kqYxQ/jGkEdU
 l4chEFKD50BFesIgS1Xb4f8r8wWtTQCAM0ucyAi9U3EnWv9Jn6zMMw3jF/sCr5rtxzz+
 cAGo7SmmFaxFMexmdT4GZefkl5dC5BqsyEItzly2HyBfWI9FA1j+inWdh6dogNv9LM7c
 MDGa8dqvdQKjtlOzZ+Zz3LD/5AFVgFZs+CisGPc9iQEebjMjbKI6JWQAHVeE0H2jOaXq
 fFTD8jGgdpi8VR6zMoz2Ln59PAN4B1nFFsELGnkP8whH9qk6sQOKnTU6fbdkf3Pf8msg XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5gt4ag7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 01:15:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21C17iUZ003184;
        Sat, 12 Feb 2022 01:15:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3020.oracle.com with ESMTP id 3e1jpypr8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 01:15:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtKF6gNSfCKA1fZh9Yq9nFI6c2/8wyJ4As5aOH4Q9shfIJ1yv03vhTqHNt41lIGOLEAI7Wn2wDRSlrlIrCzvziTSimixQtUsUC02eSrUX+OWasUsF2XrmyGxzewQCkC8QGhLzrO4KGjdmgd+l3dOqvU5xrqbqsKc25b4s6t958X0My4oTH1VnT5hbVg5ehA38WRxjECb2VQ/KqbDAxzqIy9xxse6tAdwh50TBe+2nHevsbsXF6TR8UaD7/hug9VSmV/SFYa/AYssn951hs8BY/LHfrabf9qrC1z/oRizvEsEyyFzi/D7ElepH9Pi0X+6S5XaVcqjivUIZ5Fpd4NahA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIZpUNpiTnFyYNUN/V6p0EXBoCeERbXRYaRb1aWdW5c=;
 b=m4QVgQn4PzQ+YCedip656Fnpvc+CytUiTG7KL3vHGVhRBov2MlhmLBXw8axEP0Tzi6/uEu4m2G1pp9DIejArth5OrYITovskUq5YNge08t9bQncV3RSke/HVmdGoG+AnehGf+VvbrHIQe8h3W2EuSlBrpTejyWmoj5trJdMYYmmTFDE4aSaFpBnq9IWCEOq6CKs4QJL7pO0NRg6S27lblF2+c+zm1lzTY3y8e3wKqPG7PdYo/zzAolXcTsLPLF0S+q8cQw4seFHe23kcGoQcIDOIHoewPT47Qrbl75gtiKdFQCqQT06YLf5zAlUNkJpY2uS5Ci5+dctBKRMURYuzAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIZpUNpiTnFyYNUN/V6p0EXBoCeERbXRYaRb1aWdW5c=;
 b=SAE8QiWETQVrmYrJJNrhoqcvuhshGrF0QECUO1ujX0v25i+3jyw5UPgAgLJKLOJm6se7qWTqLPo4iQ+WCCUqmUp08Csi+CHROsP7zWzKmlspu/AD3Gace1NHJM1d+Bet1DadtW3XWUTToLnJLqFk2sIDXl2WflNhNw0D8nUCJ/I=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB2438.namprd10.prod.outlook.com (2603:10b6:a02:aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sat, 12 Feb
 2022 01:15:55 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd%6]) with mapi id 15.20.4975.015; Sat, 12 Feb 2022
 01:15:55 +0000
Message-ID: <51789e9b-4080-acb1-8b8b-2cf3f5d6a0f9@oracle.com>
Date:   Fri, 11 Feb 2022 17:15:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     jasowang@redhat.com, lulu@redhat.com
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-3-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220210133115.115967-3-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0378.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::23) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29202ba1-05f4-4eb5-6896-08d9edc537b2
X-MS-TrafficTypeDiagnostic: BYAPR10MB2438:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB24386E088EF0C2E31A84F88EB1319@BYAPR10MB2438.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Di6Bwm17ax4XUa2zJ5Ia4ddtEBfuA/0gx04ejD+Bv+2Yc2uL04m18KZV+zt2fBT0TKhSlGdY2XKggNIUE3gSGwk6+oOV+ZecYC7RacdbgpeCJjgJEX1PtXZcuFaKoRdshpwFOrfSbYHXliaN4+D1wFk9trb3J8Su9kTLw1m4pQND+cXR61k23rK9OM8J1Bb/FlrAI1ahGm7+T+D/XA5CdBz2SwF4N/BlzCUsFuyl0ysgsssZH4TJ/crAN9ymoqY7lQCwdsvmVAIy1rlO0VCNOvKN3dQLLvPoKf55xBNa4/RRAJfBAfQ+BqUWNr1JkUG+kP1krjetUl4F1GZqzjxOsx++cMweFMFUdJnVy76UDVX0reFdVStOPP/0br6kbD7N+3CzeZ4fJtR413emE6q2N42lpFQ3K3VtLmwHhiBwC+KcJkRbw/n9y4Q9Rg/VPT8BUAJz3RqJwHzNjgNMZakZxrp8QCXOmS50K9uzahCmPamJ99YKgB1fJEHCtEh5u/78r2aJxB/6ul5AJ0iRimiPakVvuWdO6JGIjO6li5XKKGt8qL0e6BH7nB8ATgv+2RpQN4L6oozL9rE7o9F/4Dqi3q3qZYSJBfkVik6sMTPYZ9DpjmxFpmxC/sxF89pt7yiyYu8fnxGInipT3uRJXDR4c8ruQZgOsg+11hy4kgbOC96qIkx3u6KTAGb4eZ2igtKKkQE1e9VEmS4vI5qB+24YGbb8tfuiqOAaOrkThtrdB9CTNnmTlzgIfEgFnBBqk/gb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(2616005)(508600001)(66476007)(38100700002)(6512007)(66556008)(4326008)(31686004)(6486002)(66946007)(8676002)(5660300002)(36756003)(6666004)(83380400001)(36916002)(6506007)(86362001)(8936002)(53546011)(2906002)(31696002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW8rdW9hU2tBNDZXbHVJRTJaeWdRanQrSTEzSzdDVmxSVHFHR244ejhZRTZu?=
 =?utf-8?B?M1FQcTNMNmx3UEVnS2xJNWFjdE44b3d4TWxjSW8vM0JmUEdnWjhmRkxFMEZF?=
 =?utf-8?B?Q01jdzhIcEd2enN2UWExVkh0blZNS3VOM1d0dGpxWld0bDU0SlR2RXB3dUEz?=
 =?utf-8?B?cGl4cWM2dFdCWFFyaTVCYm4rQWZOZjFkR0NyTEhNTkdxY0dKUVJJQm1uVjFU?=
 =?utf-8?B?QkdNSzl4QXljS0U5a01VV3gvQjV3S3UzTzRVWk05akwzcTB2WklmM25ZWHU3?=
 =?utf-8?B?T3UzcFRuckZrZC9vc0E4aW50ZjlZWlhiYzJpeTd0bDRUYjhtZ2VvSFpvUFBo?=
 =?utf-8?B?S0lZQUNCdWxKUWhmWEplZUtTd0xmZTBWSWRoZTIvVHE1QWNUaVA1Mmo2aC92?=
 =?utf-8?B?RVZwYWgxeEc3K3dyeDQwaE1SWVlIR0xBRlBQdXplanlTcnc1ZXZzR0o0VzFi?=
 =?utf-8?B?dlJET3RrcHdPK2VFTk0rVlJQZ2pXOXlIQVF1MGhwRlR6VjMrZ2lKa01sV28x?=
 =?utf-8?B?b2h1NWY1NGlTTmNwRlBzVHBGOEU4YnVlTUVHYThNZkkrMkhUODg2ZkQwdUdJ?=
 =?utf-8?B?YmxkUkhSaU93dFN6TGVIVFc2cDJuOTJ0Mm5KZm5Tak54R3Nzc0tzODVLaGpE?=
 =?utf-8?B?NndrNDhpNUIvVXUyNWhOaWJCV1hjK3duUjZBQm4rQ0FJcG5QTE9hNEMwYlpJ?=
 =?utf-8?B?dHJ3S0JDY2grN25Ub2RhRTMzQ3pROHRCQzNOLzB2aFpZWSt5S2thM1d2UzNQ?=
 =?utf-8?B?QitOcFNIemRDekh2M2RuMktUUUhuYmg0NkhPSENGY2J4YmMwdnpraTBNNjlR?=
 =?utf-8?B?TTlCQTdiU2o2OHl4c2I4T3FPYUhUcE1KTytnRnY0a0VFWGxsNW9GWjVlamha?=
 =?utf-8?B?TS94blNtRk12b0pzSmpnUFJmMjhjcW0xS2lQMHdITnk3MjJmeU8wM0dkNUc0?=
 =?utf-8?B?NW8wcGVKT2NLK3FpTzdldk1oTHF0Sk5QS2UyZ2llQ2hibmh2bHVlZGxhOVg3?=
 =?utf-8?B?c1M3Nncwb0MySXNxblI5bFgrTllwaDIyeE91M3N2b1QyVmFlMmtDNWRZeVpq?=
 =?utf-8?B?Vm9tOS9iQitXRU5mYko3emlKSUVvWnVIbk94Z1NXcG1rR0RZN1Zjb0Jmemhn?=
 =?utf-8?B?cnl3QUd2NlFtT2dRT2NJbUR4Zm9sd0Rwemk1ekZHQnRaNkoya3E4WFlXUm4z?=
 =?utf-8?B?SGxHMHk4eE53TlVudjNGckZCUHQ3YzRIZzBmTjVNWHlIWDAwTTlFVDc4cjlZ?=
 =?utf-8?B?b1JKNS80UURCNnIxRnRVQUdUSWN2dHhNNERxT3dRajNvbU0wTFRkekkrVHFa?=
 =?utf-8?B?UG50OElaMU1XZC9CWDZEamRiQitvQ3RmTFhJdWtSNzVkczhzcnd4OWxqd0dM?=
 =?utf-8?B?MGZzZjhscFYySDRvTE9CUzlvSFY4OEdUVTNSSzcrYmZsNDBITmkzZ0xSK1Rh?=
 =?utf-8?B?NFVGLzZtaGFOREgydFcxTXpsYXBUZ3ArTnVWSkgrOC9FMTlKNVRNTlVOUm91?=
 =?utf-8?B?b1pTSFpaQVlHaDgrMXV3cGVSd3A4N3JGOEllQVBQV0lGajE5Y3FCbE9uUHI5?=
 =?utf-8?B?M2IydUwxRW56ajhvN2xKNUVJMzJCUzZRdlZHbXlmUHNTY3JxdkQ5aTNYdVJ3?=
 =?utf-8?B?Sk1ScEVVTnhjQU9Hc1FBZ0dzanlDd0dFcUxQMC9NaGFXZ2wwRUU3eUw0VFFz?=
 =?utf-8?B?ZFZPK1BTVXUzODFTUmZjNFp5QnB3dlhVN0p6d0FvMjBVTGo0YnBsZC9XSGNa?=
 =?utf-8?B?ekpzNVQxRXR4MVpBd1FoL1ZnbnBsU3NUcnNlakZFVGNsT29LRkUwemVGd2lO?=
 =?utf-8?B?NXQ2VUd0Q2pibmtXVE1EaDNIWWVQL2hybmJ5TjBDbmdITjNiT2wwODlhRU1n?=
 =?utf-8?B?M0QwUkVqRUZ2V3FsUFp2dVduYUdiK2dWL2ttdGFKMWVIRkNSMHdYWHR4ZXdW?=
 =?utf-8?B?WlpIQW5NRFVjRTJ3cnJ2NE1WQkhBUkxSMTUreU04WXJKYy9YUWtITSsyR2Zo?=
 =?utf-8?B?NHlDOUQ1RTdybGZ0VFlMRlJmVnBEZHRFcnNoUys0aWZ3TWNNNjVCQytzRkkr?=
 =?utf-8?B?NUFsQVRmazlLRlByUkVoY0dYdHhDbFFZVENjRU9sSW5LZzU1TkYybFgrYWdp?=
 =?utf-8?B?UmhHM1V0Q0dnWG1FclBXUDVSbmNPOHRNcXJ0ZGI2ZHNWS3kvN2c1ZS84QVls?=
 =?utf-8?Q?oDlyFR3rLGK0DyZ0rHYlxKA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29202ba1-05f4-4eb5-6896-08d9edc537b2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 01:15:55.0133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VTp8OgCjCnrNyttDEvCZGOytFCdk2mOTPkKR9nbDOcZiF81wbKOy2QQtiLkHWqvJLLpX174bCU5U7P3uPQUvzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2438
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202120004
X-Proofpoint-GUID: SP4RsfLlvxrCnr0rApFvhaROt9XRuGqA
X-Proofpoint-ORIG-GUID: SP4RsfLlvxrCnr0rApFvhaROt9XRuGqA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2022 5:31 AM, Eli Cohen wrote:
> When reading the configuration of a vdpa device, check if the
> VDPA_ATTR_DEV_NEGOTIATED_FEATURES is available. If it is, parse the
> feature bits and print a string representation of each of the feature
> bits.
>
> We keep the strings in two different arrays. One for net device related
> devices and one for generic feature bits.
>
> In this patch we parse only net device specific features. Support for
> other devices can be added later. If the device queried is not a net
> device, we print its bit number only.
>
> Examples:
> 1.
> $ vdpa dev config show vdpa-a
> vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
>          mtu 1500
>    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
>                        CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>
> 2. json output
> $ vdpa -j dev config show vdpa-a
> {"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false, \
>    "max_vq_pairs":3,"mtu":1500,"negotiated_features":["CSUM","GUEST_CSUM","MTU", \
>    "MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR", \
>    "VERSION_1","ACCESS_PLATFORM"]}}}
>
> 3. pretty json
> $ vdpa -jp dev config show vdpa-a
> {
>      "config": {
>          "vdpa-a": {
>              "mac": "00:00:00:00:88:88",
>              "link ": "up",
>              "link_announce ": false,
>              "max_vq_pairs": 3,
>              "mtu": 1500,
>              "negotiated_features": [
> "CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ", \
> "MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
>          }
>      }
> }
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   vdpa/include/uapi/linux/vdpa.h |   2 +
>   vdpa/vdpa.c                    | 126 +++++++++++++++++++++++++++++++--
>   2 files changed, 124 insertions(+), 4 deletions(-)
>
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index b7eab069988a..748c350450b2 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -40,6 +40,8 @@ enum vdpa_attr {
>   	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
>   	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
>   
> +	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> +
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
>   };
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 4ccb564872a0..7deab710913d 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -10,6 +10,7 @@
>   #include <linux/virtio_net.h>
>   #include <linux/netlink.h>
>   #include <libmnl/libmnl.h>
> +#include <linux/virtio_ring.h>
>   #include "mnl_utils.h"
>   #include <rt_names.h>
>   
> @@ -78,6 +79,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>   	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> +	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>   };
>   
>   static int attr_cb(const struct nlattr *attr, void *data)
> @@ -385,17 +387,120 @@ static const char *parse_class(int num)
>   	return class ? class : "< unknown class >";
>   }
>   
> +static const char * const net_feature_strs[64] = {
> +	[VIRTIO_NET_F_CSUM] = "CSUM",
> +	[VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
> +	[VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
> +	[VIRTIO_NET_F_MTU] = "MTU",
> +	[VIRTIO_NET_F_MAC] = "MAC",
> +	[VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
> +	[VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
> +	[VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
> +	[VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
> +	[VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
> +	[VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
> +	[VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
> +	[VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
> +	[VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
> +	[VIRTIO_NET_F_STATUS] = "STATUS",
> +	[VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
> +	[VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
> +	[VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
> +	[VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
> +	[VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
> +	[VIRTIO_NET_F_MQ] = "MQ",
> +	[VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
> +	[VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
> +	[VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
> +	[VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
> +	[VIRTIO_NET_F_HASH_REPORT] = "HASH_REPORT",
> +	[VIRTIO_NET_F_RSS] = "RSS",
> +	[VIRTIO_NET_F_STANDBY] = "STANDBY",
> +	[VIRTIO_NET_F_SPEED_DUPLEX] = "SPEED_DUPLEX",
> +};
> +
> +#define VIRTIO_F_IN_ORDER 35
> +#define VIRTIO_F_NOTIFICATION_DATA 38
> +#define VDPA_EXT_FEATURES_SZ (VIRTIO_TRANSPORT_F_END - \
> +			      VIRTIO_TRANSPORT_F_START + 1)
> +
> +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
> +	[VIRTIO_RING_F_INDIRECT_DESC - VIRTIO_TRANSPORT_F_START] = "RING_INDIRECT_DESC",
> +	[VIRTIO_RING_F_EVENT_IDX - VIRTIO_TRANSPORT_F_START] = "RING_EVENT_IDX",
> +	[VIRTIO_F_VERSION_1 - VIRTIO_TRANSPORT_F_START] = "VERSION_1",
> +	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ACCESS_PLATFORM",
> +	[VIRTIO_F_RING_PACKED - VIRTIO_TRANSPORT_F_START] = "RING_PACKED",
> +	[VIRTIO_F_IN_ORDER - VIRTIO_TRANSPORT_F_START] = "IN_ORDER",
> +	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ORDER_PLATFORM",
> +	[VIRTIO_F_SR_IOV - VIRTIO_TRANSPORT_F_START] = "SR_IOV",
> +	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_TRANSPORT_F_START] = "NOTIFICATION_DATA",
> +};
> +
> +static void print_net_features(struct vdpa *vdpa, uint64_t features, bool maxf)
> +{
> +	const char *s;
> +	int i;
> +
> +	if (maxf)
This could use a better name. mgmtdevf maybe?
> +		pr_out_array_start(vdpa, "dev_features");
> +	else
> +		pr_out_array_start(vdpa, "negotiated_features");
> +
> +	for (i = 0; i < 64; i++) {
> +		if (!(features & (1ULL << i)))
> +			continue;
> +
> +		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
> +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
> +		else
> +			s = net_feature_strs[i];
> +
> +		if (!s)
> +			print_uint(PRINT_ANY, NULL, " unrecognized_bit_%d", i);
> +		else
> +			print_string(PRINT_ANY, NULL, " %s", s);
> +	}
> +	pr_out_array_end(vdpa);
> +}
> +
> +static void print_generic_features(struct vdpa *vdpa, uint64_t features, bool maxf)
> +{
> +	const char *s;
> +	int i;
> +
> +	if (maxf)
> +		pr_out_array_start(vdpa, "dev_features");
> +	else
> +		pr_out_array_start(vdpa, "negotiated_features");
> +
> +	for (i = 0; i < 64; i++) {
> +		if (!(features & (1ULL << i)))
> +			continue;
> +
> +		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
> +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
> +		else
> +			s = NULL;
> +
> +		if (!s)
> +			print_uint(PRINT_ANY, NULL, " bit_%d", i);
> +		else
> +			print_string(PRINT_ANY, NULL, " %s", s);
> +	}
> +	pr_out_array_end(vdpa);
> +}
> +
It looks like most of the implantation in the above two functions are 
the same and the rest are similar. I wonder if can consolidate into one 
by adding a virtio type (dev_id) argument? You may create another global 
static array that helps mapping VIRTIO_ID_NET to net_feature_strs?

>   static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   				struct nlattr **tb)
>   {
> +	uint64_t classes = 0;
>   	const char *class;
>   	unsigned int i;
>   
>   	pr_out_handle_start(vdpa, tb);
>   
>   	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
> -		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> -
> +		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
>   		pr_out_array_start(vdpa, "supported_classes");
This looks like a minor adjustment to the existing code? Not sure if 
worth another patch though.

>   
>   		for (i = 1; i < 64; i++) {
> @@ -579,9 +684,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
>   	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
>   }
>   
> -static void pr_out_dev_net_config(struct nlattr **tb)
> +static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
>   {
>   	SPRINT_BUF(macaddr);
> +	uint64_t val_u64;
>   	uint16_t val_u16;
>   
>   	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> @@ -610,6 +716,18 @@ static void pr_out_dev_net_config(struct nlattr **tb)
>   		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
>   		print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
>   	}
> +	if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
> +		uint16_t dev_id = 0;
> +
> +		if (tb[VDPA_ATTR_DEV_ID])
> +			dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> +
> +		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> +		if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] && dev_id == VIRTIO_ID_NET)
> +			print_net_features(vdpa, val_u64, false);
> +		else
> +			print_generic_features(vdpa, val_u64, true);
Why the last arg is true? That would output the dev_features line instead.

-Siwei

> +	}
>   }
>   
>   static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> @@ -619,7 +737,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>   	pr_out_vdev_handle_start(vdpa, tb);
>   	switch (device_id) {
>   	case VIRTIO_ID_NET:
> -		pr_out_dev_net_config(tb);
> +		pr_out_dev_net_config(vdpa, tb);
>   		break;
>   	default:
>   		break;

