Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD6264534F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 06:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiLGFM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 00:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGFMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 00:12:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FB354779
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 21:12:21 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B72Q66i002852;
        Wed, 7 Dec 2022 05:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=X0TU3HZD7bytoEkSFYaKa2wQp3UkGpYqLQDs2ib9awA=;
 b=oejl1Xl/4P7ZCT6sQxQTp+elsLQfeZZSH466FT0hHuIWoDcpzxYUb+MVwiGXavwPhkh9
 GlMK1igMyMJ800/2YG+6Abn1w53z6jhAvxR7F2/C7Qnq6PoH0bRNFwSMpRG1apXoYF9h
 7qHA18LL+AfZFBULv9cePl1UQN7aJJmCX2IB1oB8eRS/BHmRxS4mqA5FuEaFBg4DlOhy
 lXTN/R/FYko1P9BoSaL8XztxwnYWRbEojpgX03rna3OrslpFyuagapLZqQagDLjIuBs7
 N/X9o6EjDVcyQYsj1Duifd6UHkeMx+A42zUSLGR6n2eA4od8NuNq+oJcwdxkY1NK8vSF iA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yb3ha5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 05:12:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B72VF2e032200;
        Wed, 7 Dec 2022 05:12:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7vr6d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 05:12:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gy6OJ01agttwuWkb2Zzq9NQlp/X4aeCfGcAe26DZfAUCCse3V0JtTUsxNsnlvulRZqkn9Yc0L7K6tBitRY6E6AG97y/yuyWqLKz3yjBC222fPFwwYSK2nDKXl6b4SxoqlnmOQc6tj87niUNxtaR0CCtjtDGJL2JM9WQYauuLb9cOy1Ay2usOg8mAB4sjXD0k06wtv4Hbupcpsr2e69Af4l/6QnrcKoR0cz08QzY15XxT26kTHb7XeDMs3mmnYUMqByjXEipOKL7WDMkf+2xz0SecIRGDILUE6MOfNj+QA127t37GazVHVR95HBi69EUYECfNoz3ny2idV1BYl7Cz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0TU3HZD7bytoEkSFYaKa2wQp3UkGpYqLQDs2ib9awA=;
 b=hGfinlF9w6pjBf1OmLQwtYdDLomybdYFnN+elcJJyU6fF+VUsumqETxYZsWTPrHSD5g0S0RyllUoeTtMf6eAEEFJarnG5YRCWc+FM+2yF4IqSpgvqnKhxxLSmSB5XmkqiQdKGqTt2R3xJTlzHCSyFm1DYpdbC6/GLkyyAJDJWIfg7ZNmpRSh9cuzPNGrr2tKGoK6J9hm8cfZQud8eQWF2Qe9cet7V4VowCq5GO0cqiQfMq0XuXCZzD50Key209qmixOpgrWJTKqoSGUuLckwL7NWzJ6Vz+cD6u0sXJdMWYzlZ12nEY6FNWvw7tyssgf9/REeG7/iXg7qpPNVigXPHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0TU3HZD7bytoEkSFYaKa2wQp3UkGpYqLQDs2ib9awA=;
 b=IM2skV293KP7C4wwgnwju+eL8pFFCoYopD12d9ibearN8mWug+iJTKqd7TzzmyqCKjbcCcr/ElXUu4nhoGTo5Z2sD8rUP6H+1katM2npua696VMMRMidWZeS7EudmG7WmlT1Fa+1wYArm6gaDru06StLqTl9SNSh/Ayzo9N/pVE=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by CO6PR10MB5588.namprd10.prod.outlook.com (2603:10b6:303:147::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 05:12:06 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5%2]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 05:12:06 +0000
Message-ID: <716ae134-f7d9-95d5-5dd4-25434aa01b40@oracle.com>
Date:   Tue, 6 Dec 2022 21:12:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        eperezma@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
References: <20221117033303.16870-1-jasowang@redhat.com>
 <84298552-08ec-fe2d-d996-d89918c7fddf@oracle.com>
 <CACGkMEtLFTrqdb=MXKovP8gZzTXzFczQSmK0PgzXQTr0Dbr5jA@mail.gmail.com>
 <74909b12-80d5-653e-cd1c-3ea6bc5dbbde@oracle.com>
 <CACGkMEs7EGUsJ8wtZsj7GEMD9vD6vJNVRUu1fcwUWVYpLUQeZA@mail.gmail.com>
 <d4a85c3b-ab0b-a900-06a9-25abdf264e97@oracle.com>
 <CACGkMEsN7H4=DqyNWrwLhd+zdfhiYohyB7GmUi8iUH73Z9KxYA@mail.gmail.com>
 <153061e3-4623-38f5-c1b6-3177fc01fcec@oracle.com>
 <CACGkMEsdC8hfRoCM9bbNRtAbgEPF5FdzfGSoP-OpQ4sckkOMTw@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEsdC8hfRoCM9bbNRtAbgEPF5FdzfGSoP-OpQ4sckkOMTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|CO6PR10MB5588:EE_
X-MS-Office365-Filtering-Correlation-Id: bb206ae8-82d9-4c89-2f18-08dad8119546
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N39ZEjuX5DirddpRl8pfF7LRcnjS+fdTPWBs1r1GTJH9geDcW2oMJNFxId2CmOrcFuhcKwEpm9l8uUulu31T+knsFRCWhzWET9+1IF1E6wtwdsDVdSFr6j1nsbAXELa6TFHfrUPhkxkJmfggapv3yTszl3VI/dR1lYTUp0SKZkhMiAXgZFVRfje9gWF1P/gXgpmbAi26dMVLqGkNWoSAAJYGzGLvgpeuu8xiG0O9YfdUdKQVT/vqIHipJSr2jn6yMBO0HvFa0BaYIMLuY9iCMEQnJHufXzfZZxWfqBIncjOPw3Uo4+g8vWEZaaxesNEZDm8OnpQvDKvbad6Cq6kykiMEOGIL2+Tg/OZDH3efUmbxY/RXLQ3JrjNcnF5N7mYm/V2pvbY1Y2CPqF73MHP9fNjRjUNMFwp/psuc5A/txLiL6cvyspZoqJsdQkBdlZXb7LircDu32eaEd3PyXN0VTedzYOUf8f5i/f2AX+rxyWtGfAxU/fIRlqh6NRStfc/WY2411GuB0wVcKrWRlxxhesGVnpOrv4j6R7lHH7cQ90gweXEQVYN0o5KsSeyuYHZNWED+laF87X5dx5be/ME29BsMAwV1PrljM+nzVDfJk+v6yWZ/6EbZO0ZDp/LNj7XAuGO6YZOtA49J0tbNTxuJQsR0JWB116ITmYUuQV8R3TmRHYtIxMU17nr2A+eqnXattwmM0aFYdESSAxsTkqSFKEsWFbmW5T691qXtgdXfzUCJQwSoy65rm517UHGat8pMsBLp3+gVsjCuBs/ePMFlqtf8amGZGpopMgKq8UZvZhygLfkHkF1j4lkxY0/Jmsz5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199015)(41300700001)(53546011)(6506007)(26005)(66556008)(6512007)(6666004)(6916009)(86362001)(316002)(5660300002)(8676002)(66476007)(4326008)(36916002)(66946007)(36756003)(30864003)(6486002)(2906002)(8936002)(966005)(38100700002)(31696002)(66899015)(186003)(31686004)(83380400001)(478600001)(2616005)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUpNTnJpL1FzMmgzVTJpOFNkWkZSaGlTSkIxbmU1bUpQaHN3aktPVjliM3FU?=
 =?utf-8?B?Nis1YUV0Nm8yeEp4bHBKT0l1S2dSZXVwMk5EbjZiZlhGQ0RzZmwrbHg5S1o1?=
 =?utf-8?B?UWtQV2ZEdXp4aXQ2c2RBVzJTT1Q1MmhqTXVPekk4TWM1ek9jblBDZHU1azNa?=
 =?utf-8?B?bkR6RHpuWi9YTnBneTBtcWhuZ2dLSUtiZVAzTzJIZm13bTRuTjZobzlQSVFZ?=
 =?utf-8?B?dzhlWk9jZFRLNjlTZ0pCNHpkcEhpYkF1UFlxdzFzenRrQ0pDaXJETGozcjdZ?=
 =?utf-8?B?ekdYZHlmOXFBNmFJSTVmZFg0ZWR1SzhZM1A5MVFJUFFGbk9zN2twSzVPTmtq?=
 =?utf-8?B?MThVMkRWYnlFVFhPQlhsNkZqSzkwMEl5dHVYaFlScDdPOE5Sd1pmdmswUVNR?=
 =?utf-8?B?QzAwQ2lBUFhzSnkyUkg1OUNzYUpKUnlCM0VqckljeVV4Myt6QmhnUy8yNGlz?=
 =?utf-8?B?WHRqRkpGdEljbkw1a204S24vbTFlT0pUaFh3eGRHbTlwVVhXNnMrbkl1WXNt?=
 =?utf-8?B?ZlNBanNlR3FnNFdqWVZOUzB4K0d5azMyUElJaGc5WThSbHVJbG9LRDRaQWlI?=
 =?utf-8?B?M3pyVlM4VUNDVFhsOFNMVHI2UnpXdmN2U3dYcWhSQ3hXTko1SVZyYkZldjVP?=
 =?utf-8?B?LzU1YmJwWUYyYUNSTnFaRjVNR3duNHZ3akhvck9iRy9MVTcxTmVFcEhCQWg3?=
 =?utf-8?B?WkV6R1Q5Sk5WTmIwWWhGODB3MXBqNm5wVU4zcGZsWVY0TC9va2orY3JFNU03?=
 =?utf-8?B?bjhEN3RoUDBEcUIzenovTklwa2dRSXhtb0VHOGR4eE56REtQMUV2Nm9pUmVT?=
 =?utf-8?B?MnkxOHFDRzVLUXBOWTJEOU5YdThsUUY0SUhkVyt0UlR2VHJpd1NDajdsUHFF?=
 =?utf-8?B?QVZFVjlRQ0dSRjVIZ0pjZEhtTFkzM3ArcVhzL2RYNmxOM0tTbnAvMU4waVBM?=
 =?utf-8?B?ZFlUVzNMNEw2a3lTVDRtZ3dmTjdCdmpBOW9rR2RHcW9LakRDQjZRNWhkMUhR?=
 =?utf-8?B?YXBjL1R0VFF4MXNSamtQQlBwKzJmZGgycEs3Z0sxQ2F3WVZUdG9BaUJsZm1w?=
 =?utf-8?B?amFKS2FzbUU5bS9sYk9FdjFxbjB6R2ZjbmRsODdSMEVXL3FUb3V6NVhuS0tl?=
 =?utf-8?B?WVRXdnl2cUwrTTExYU82TUpObjdDMEl2Yk5tZVkwamViVWNtK3BncUtxTU4z?=
 =?utf-8?B?alBNWHZvV3ZzZjRZSnZCNk5KbjdJU3JGS2tDeTFkdTNzelB4K1NKemZYVFY1?=
 =?utf-8?B?RXYySklFb21QNk5ZNkE1SFJnMlF0QmY1RUlEQnkvRkhrY0VneElhb09jS2hG?=
 =?utf-8?B?TlBJYWtQMVRlejJhV0d6K0hUeVpHc3Z3NnAxT0FlRjQ5aG9ZNTY5RUFhYnRL?=
 =?utf-8?B?RFdUUTV6bmlUMEtRSTdLWjZpQkVEQnFqRFJ1cFNvSXFHWVZ5NFJxNFRaVkFn?=
 =?utf-8?B?Y1FTSng3djdMTWgxMjRTRVhMWUxUeDFvWURxbXpkUVJJcEd0OVRTZ2dUQ2w2?=
 =?utf-8?B?VFJja0pNbERaR0JSK1hJV1pCd0Z2dW5WMDFOR2tFaHJlemZuQmJLWlBpVHpv?=
 =?utf-8?B?UWpDQ2xmeUxybk03N1gzdlU0WTcyWUsxN25USklWcmdRV0JCMHdoL0NRTFhG?=
 =?utf-8?B?MnZ2L1Rzb0FXRjUzaklWcFo5N2RIb3BWQ3hTUndEc2tzMVlhYmNrSTB5Y2RW?=
 =?utf-8?B?VmEzT2svM3ZBT3VxQUJQZit3TjBuWHpBVnpGd2FDWDVuanhkWVBQdmR0b0V3?=
 =?utf-8?B?UWdVMzFmVGFTMStGbGVnVXdQRXVMazRFTnJFNzB2SmxNTkdVRkRZbHdBK3Rr?=
 =?utf-8?B?aFc4UFp1Qnd3UjJIclNkbk1YTGJRYVVQT0VBaVlISmlxWG5MQStLTEVCaUFx?=
 =?utf-8?B?MGcvcS9vSjVoVGhiaUFWYjdGaHJ4T3UwSStqNVovMklHK1pvM2sxaW56RjNF?=
 =?utf-8?B?Z000YytDT25rZk03YlRUSVFvZTllV1JNd29zY0diRzRaZVZwUmtJeWswYTFz?=
 =?utf-8?B?dnRQaTE5MkpCODVLL1hOTlZjbWlCRExjaXA0Rjc2QjBwNEEwL3Fva01PaDFy?=
 =?utf-8?B?UE9oQXpEb3B5bU5pSmJwS1ZqUXJjZlRCYXFKVHB2ZWY1eGxOWExZM1VGRjFR?=
 =?utf-8?Q?3B3OMbXghYrYZO77EjUIFMr/U?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TW54YzQvWTJIWkFRR2dNaC93akd5V2V1VEJvdXZQN2hrRmFpKys4S04vTFNw?=
 =?utf-8?B?QU41UmwrWUtHUFJweHg3ZXBhUVFTZ3J4STBlOXFYQjRVYnVVcU9qRU9pUy9F?=
 =?utf-8?B?TjJRVjFaVllyOXF5Sk1mbTEvRFd3RzFtcnVVeGczRzYyYUFtaWdablJobkNW?=
 =?utf-8?B?bjl5Z2doay8zeDQyQk9CQjg5K3I2elFvYnNveVV5STBJbDZlckRQclRkbExR?=
 =?utf-8?B?Y2tqeUJZNXI0enhsOU1oQ3BhbGJSQjRQeFA0ZTZtaGZvM0lha1MraEpNTDZD?=
 =?utf-8?B?MVNsaXlHdUJweVZDVXd2aTRRaWUxY1JWRWErZ3dZZndXRnlQTEJVVzBNTXR3?=
 =?utf-8?B?elg1NFliaDFMS2szWHMxaXpYQi9GOHBleTZaNCsyMnpYdm1EUCsrWEhSMTVs?=
 =?utf-8?B?TkVHVGcrMzZIcVhNTEZDMG5FeU5BOG1WRXF6c041NHhKUWFxTXA3dytVSUpZ?=
 =?utf-8?B?bjRDVytOVjJMaktIeDdXMldRak9yRTNmRmZCdEp6ZHpkMXJteGM5VVM0K3ln?=
 =?utf-8?B?NGpnQ2pqaTFzVGFIei92ZFRBS0ZhZnBCN0JUQngrZitVWVpkUkpHQVpma1V1?=
 =?utf-8?B?RG9tcEdpSy9QUVNIQmJhTlRqNkZ1cE9wVWlLK0pRNzlnVnE1cSsvL0U1QnBJ?=
 =?utf-8?B?eTlabzlrQk9teU5sMThrSEVBZXA4aXY5L1AzcWV3Wm5rNllxTGU1d0c2NmQ1?=
 =?utf-8?B?UUpqbGJMVHppaDdwTy8yZmlmZG1HU08yVnFXWVlMQlJZblJJOFVQZDk3a2tp?=
 =?utf-8?B?WDB5RXBoWm1xTFptVS9VdWdxazZBdXl3SnpTZ3lQQmEwRVY1ckh0ZEpua2tI?=
 =?utf-8?B?bU9YdFdOekkrWkZYbFp4T1NRYU1ZVyt3Z243MHpEdkNmSGg2SnJjWU9UMHBh?=
 =?utf-8?B?KzhJT1diYWxKMlkyc2Q0RVBmdmdTWHZ3SnRRMnAxSDgzbk1xYm9Hd1o2RGMx?=
 =?utf-8?B?WU5hU3Nmekx4dHhzUVNRdXJBNHA0NEZ1VG1PdGlDb2Z4cTJNM3A4UVhJODVT?=
 =?utf-8?B?UjU5R2oyWTNmZjcyREtBV1ZlbS9tUys3TTdCWWs5Nk1naUFyZTl4SS9RWnZl?=
 =?utf-8?B?L2hyeXNaR2dqZDl6S01jWFhKL2dQQXUzZEQzcmZPbHhxcHNYMFU5aHhObHBD?=
 =?utf-8?B?UWNLYW5IMm4wc2ZQa3hiZ24wazZJL3Y2QnBtNzlEeExtTWVFY0ZoYXRuTENH?=
 =?utf-8?B?SU9vZmIwUkwxZVpCbndCWXR2RGRjeGNLK21mcHhlcWhxOWVpRWdlUXVnakJh?=
 =?utf-8?B?SFJZanRxZU5CN21UTmJGaFZxdzFaQTlPUVZ5YndZclFsVGxtOVhIY2xLMDhF?=
 =?utf-8?Q?6Hb/6vVUzmXCiVzveOA8bKsCLzYcansIuP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb206ae8-82d9-4c89-2f18-08dad8119546
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 05:12:05.8668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6SxDwPdp3Mq4zGDDGty+ZIvNY/yz5HhpDwYpmxwH29RQY7RTkCAzIkFLP+ZP2H4pmHzcsePu11a/Htdg3ukVJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_02,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212070040
X-Proofpoint-ORIG-GUID: VdLbuuG9I9d4EYJmzJf9RrMwJBb0Z2FD
X-Proofpoint-GUID: VdLbuuG9I9d4EYJmzJf9RrMwJBb0Z2FD
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2022 7:14 PM, Jason Wang wrote:
> On Tue, Dec 6, 2022 at 9:43 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 12/4/2022 10:46 PM, Jason Wang wrote:
>>> On Thu, Dec 1, 2022 at 8:53 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>> Sorry for getting back late due to the snag of the holidays.
>>> No worries :)
>>>
>>>> On 11/23/2022 11:13 PM, Jason Wang wrote:
>>>>> On Thu, Nov 24, 2022 at 6:53 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>>> On 11/22/2022 7:35 PM, Jason Wang wrote:
>>>>>>> On Wed, Nov 23, 2022 at 6:29 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>>>>> On 11/16/2022 7:33 PM, Jason Wang wrote:
>>>>>>>>> This patch allows device features to be provisioned via vdpa. This
>>>>>>>>> will be useful for preserving migration compatibility between source
>>>>>>>>> and destination:
>>>>>>>>>
>>>>>>>>> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
>>>>>>>> Miss the actual "vdpa dev config show" command below
>>>>>>> Right, let me fix that.
>>>>>>>
>>>>>>>>> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
>>>>>>>>>            negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
>>>>>>>>>
>>>>>>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>>>>>> ---
>>>>>>>>> Changes since v1:
>>>>>>>>> - Use uint64_t instead of __u64 for device_features
>>>>>>>>> - Fix typos and tweak the manpage
>>>>>>>>> - Add device_features to the help text
>>>>>>>>> ---
>>>>>>>>>       man/man8/vdpa-dev.8            | 15 +++++++++++++++
>>>>>>>>>       vdpa/include/uapi/linux/vdpa.h |  1 +
>>>>>>>>>       vdpa/vdpa.c                    | 32 +++++++++++++++++++++++++++++---
>>>>>>>>>       3 files changed, 45 insertions(+), 3 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
>>>>>>>>> index 9faf3838..43e5bf48 100644
>>>>>>>>> --- a/man/man8/vdpa-dev.8
>>>>>>>>> +++ b/man/man8/vdpa-dev.8
>>>>>>>>> @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
>>>>>>>>>       .I NAME
>>>>>>>>>       .B mgmtdev
>>>>>>>>>       .I MGMTDEV
>>>>>>>>> +.RI "[ device_features " DEVICE_FEATURES " ]"
>>>>>>>>>       .RI "[ mac " MACADDR " ]"
>>>>>>>>>       .RI "[ mtu " MTU " ]"
>>>>>>>>>       .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
>>>>>>>>> @@ -74,6 +75,15 @@ Name of the new vdpa device to add.
>>>>>>>>>       Name of the management device to use for device addition.
>>>>>>>>>
>>>>>>>>>       .PP
>>>>>>>>> +.BI device_features " DEVICE_FEATURES"
>>>>>>>>> +Specifies the virtio device features bit-mask that is provisioned for the new vdpa device.
>>>>>>>>> +
>>>>>>>>> +The bits can be found under include/uapi/linux/virtio*h.
>>>>>>>>> +
>>>>>>>>> +see macros such as VIRTIO_F_ and VIRTIO_XXX(e.g NET)_F_ for specific bit values.
>>>>>>>>> +
>>>>>>>>> +This is optional.
>>>>>>>> Document the behavior when this attribute is missing? For e.g. inherit
>>>>>>>> device features from parent device.
>>>>>>> This is the current behaviour but unless we've found a way to mandate
>>>>>>> it, I'd like to not mention it. Maybe add a description to say the
>>>>>>> user needs to check the features after the add if features are not
>>>>>>> specified.
>>>>>> Well, I think at least for live migration the mgmt software should get
>>>>>> to some consistent result between all vdpa parent drivers regarding
>>>>>> feature inheritance.
>>>>> It would be hard. Especially for the device:
>>>>>
>>>>> 1) ask device_features from the device, in this case, new features
>>>>> could be advertised after e.g a firmware update
>>>> The consistency I meant is to always inherit all device features from
>>>> the parent device for whatever it is capable of,
>>> This looks fragile. How about the features that are mutually
>>> exclusive? E.g FEATURE_X and FEATURE_Y that are both supported by the
>>> mgmt?
>> Hmmm, in theory, yes, it's a bit cumbersome. Is this for future proof,
>> since so far as I see the virtio spec doesn't seem to define features
>> that are mutually exclusive, and the way how driver should respond to
>> mutually exclusive features in feature negotiation is completely undefined?
> My understanding is that if a driver accepts two mutually exclusive
> features it should be a bug.
It depends on the nature of the specific feature I guess. For e.g. there 
could be two versions of implementation for some device feature, which 
are mutually exclusive. The driver can well selectively ack one of the 
version it supports if seeing both present.

>
> But anyhow it's an example that it is not easy to have forward
> compatibility if we mandating to inherit all features from the
> management device.

Yep, that I agree.
>
>>>> since that was the only
>>>> reasonable behavior pre-dated the device_features attribute, even though
>>>> there's no mandatory check by the vdpa core. This way it's
>>>> self-descriptive and consistent for the mgmt software to infer, as users
>>>> can check into dev_features at the parent mgmtdev level to know what
>>>> features will be ended up with after 'vdpa dev add'. I thought even
>>>> though inheritance is not mandated as part of uAPI, it should at least
>>>> be mentioned as a recommended guide line (for drivers in particular),
>>>> especially this is the only reasonable behavior with nowhere to check
>>>> what features are ended up after add (i.e. for now we can only set but
>>>> not possible to read the exact device_features at vdpa dev level, as yet).
>>> I fully agree, but what I want to say is. Consider:
>>>
>>> 1) We've already had feature provisioning
>>> 2) It would be hard or even impossible to mandate the semantic
>>> (consistency) of the features inheritance.
>>>
>>> I'm fine with the doc, but the mgmt layer should not depend on this
>>> and they should use feature provisioning instead.
>> OK, if it's for future proof to not mandate feature inheritance I think
>> I see the point.
>>
>>>>> 2) or have hierarchy architecture where several layers were placed
>>>>> between vDPA and the real hardware
>>>> Not sure what it means but I don't get why extra layers are needed. Do
>>>> you mean extra layer to validate resulting features during add? Why vdpa
>>>> core is not the right place to do that?
>>> Just want to go wild because we can't expect how many layers are below vDPA.
>>>
>>> vDPA core is the right place but the validating should be done during
>>> feature provisioning since it's much more easier than trying to
>>> mandating code defined behaviour like inheritance.
>> OK, thanks for the clarifications.
>>
>>>>>> This inheritance predates the exposure of device
>>>>>> features, until which user can check into specific features after
>>>>>> creation. Imagine the case mgmt software of live migration needs to work
>>>>>> with older vdpa tool stack with no device_features exposure, how does it
>>>>>> know what device features are provisioned - it can only tell it from
>>>>>> dev_features shown at the parent mgmtdev level.
>>>>> The behavior is totally defined by the code, it would be not safe for
>>>>> the mgmt layer to depend on. Instead, the mgmt layer should use a
>>>>> recent vdpa tool with feature provisioning interface to guarantee the
>>>>> device_features if it wants since it has a clear semantic instead of
>>>>> an implicit kernel behaviour which doesn't belong to an uAPI.
>>>> That is going to be a slightly harsh requirement. If there's an existing
>>>> vDPA setup already provisioned before the device_features work, there is
>>>> no way for it to live migrate even if the QEMU userspace stack is made
>>>> live migrate-able. It'd be the best to find some mild alternative before
>>>> claiming certain setup unmigrate-able.
>>> It can still work in a passive way, mgmt layer check the device
>>> features and only allow the migration among the vDPA devices that have
>>> the same device_feature.
>> Right, that is the scenario in concern which I'd like to get support
>> for, even though it's passive due to incompleteness in previous CLI
>> design (lack of individual device feature provisioning). Once the tool
>> is upgraded, vdpa features can be provisioned selectively on the
>> destination node, matching those on the source.
> This should work, but it probably requires the mgmt layer to collect
> and compare features among the nodes.
Yes. I know libvirt probably won't support this. But it would benefit 
other mgmt software implementation, where each node would have to record 
the initial config attributes in the first place. :)

>
>>>    Less flexible than feature provisioning.
>>>
>>>>> If we can mandate the inheriting behaviour, users may be surprised at
>>>>> the features in the production environment which are very hard to
>>>>> debug.
>>>> I'm not against an explicit uAPI to define and guard device_features
>>>> inheritance, but on the other hand, wouldn't it be necessary to show the
>>>> actual device_features at vdpa dev level if it's not guaranteed to be
>>>> the same with that of the parent mgmtdev?
>>> I think this is already been done ,or anything I miss?
>> The kernel patch is not merged yet, preventing the userspace patch from
>> being posted.
> I may miss something, any potiner here?
First the following rename patch has to get in to the kernel:
https://lore.kernel.org/virtualization/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/

then I can post the related iproute patch to include dev_features to the 
output of 'vdpa dev show'.

This initial config series run independently, though the eventual goal 
is to get all of migration compatibility attributes packed in the same 
"initial_config" map.

https://lore.kernel.org/virtualization/1666392237-4042-1-git-send-email-si-wei.liu@oracle.com/
>
>> While the ideal situation is to allow query of
>> device_features after adding a vdpa dev (for e.g. if not 100% inherited
>> from the parent mgmtdev), followed by allowing selectively provision
>> features individually.
> Yes.
>
>>>> That is even needed before
>>>> users are allowed to provision specific device_features IMO...
>>>>
>>>> (that is the reason why I urged Michael to merge this patch soon before
>>>> 6.1 GA:
>>>> https://lore.kernel.org/virtualization/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/,
>>>> for which I have a pending iproute patch to expose device_features at
>>>> 'vdpa dev show' output).
>>> Right.
>>>
>>>>>> IMHO it's not about whether vdpa core can or should mandate it in a
>>>>>> common place or not, it's that (the man page of) the CLI tool should set
>>>>>> user's expectation upfront for consumers (for e.g. mgmt software). I.e.
>>>>>> in case the parent driver doesn't follow the man page doc, it should be
>>>>>> considered as an implementation bug in the individual driver rather than
>>>>>> flexibility of its own.
>>>>> So for the inheriting, it might be too late to do that:
>>>>>
>>>>> 1) no facility to mandate the inheriting and even if we had we can't
>>>>> fix old kernels
>>>> We don't need to fix any old kernel as all drivers there had obeyed the
>>>> inheriting rule since day 1. Or is there exception you did see? If so we
>>>> should treat it as a bug to fix in driver.
>>> I'm not sure it's a bug consider a vDPA device have only a subset
>>> feature of what mgmt has.
>> For example, F_MQ requires F_CTRL_VQ, but today this validation is only
>> done in individual driver. We should consider consolidating it to the
>> vdpa core.
> This needs some balances, the core actually tries to be devince
> agnostic (though it has some net specific code).
Yes, this is already the case today. There has been various 
VIRTIO_ID_NET case switch'es in the vdpa.c code. I think if type 
specific validation code just limits itself to the netlink API 
interfacing layer rather than down to the driver API, it might just be 
okay (as that's already the case).

> One side effect is that it would be very hard for the core to catch up
> with the spec development. With the current code, new features could
> be added without the notice of the core.
I thought at least the vdpa core can capture those validations already 
defined in the spec. For new development out of spec, driver can be a 
safe place to start.


Regards,
-Siwei

>
>> But before that happens, if such validation is missing from
>> driver, we should fix those in vendor drivers first.
> Yes, that's the way. (E.g virtio-net driver has such validation)
>
>>>>> 2) no uAPI so there no entity to carry on the semantic
>>>> Not against of introducing an explicit uAPI, but what it may end up with
>>>> is only some validation in a central place, right?
>>> Well, this is what has been already done right now before the feature
>>> provisioning, the kernel for anyway needs to validate the illegal
>>> input from userspace.
>> Right. What I meant is the kernel validation in vdpa_core should be done
>> anyway regardless of any new uAPI (for feature inheritance for e.g). I
>> guess we are in the same page here.
> Great, I think so.
>
> Thanks
>
>> Thanks,
>> -Siwei
>>
>>>> Why not do it now
>>>> before adding device features provisioning to userspace. Such that it's
>>>> functionality complete and correct no matter if device_features is
>>>> specified or not.
>>> So as discussed before, the kernel has already tried to do validation,
>>> if there's any bug, we can fix that. If you meant userspace
>>> validation, I'm not sure it is necessary:
>>>
>>> 1) kernel should do the validation
>>> 2) hard to keep forward compatibility, e.g features supported by the
>>> mgmt device might not be even known by the userspace.
>>>
>>> Thanks
>>>
>>>> Thanks,
>>>> -Siwei
>>>>
>>>>> And this is one of the goals that feature provisioning tries to solve
>>>>> so mgmt layer should use feature provisioning instead.
>>>>>
>>>>>>>> And what is the expected behavior when feature bit mask is off but the
>>>>>>>> corresponding config attr (for e.g. mac, mtu, and max_vqp) is set?
>>>>>>> It depends totally on the parent. And this "issue" is not introduced
>>>>>>> by this feature. Parents can decide to provision MQ by itself even if
>>>>>>> max_vqp is not specified.
>>>>>> Sorry, maybe I wasn't clear enough. The case I referred to was that the
>>>>>> parent is capable of certain feature (for e.g. _F_MQ), the associated
>>>>>> config attr (for e.g. max_vqp) is already present in the CLI, but the
>>>>>> device_features bit mask doesn't have the corresponding bit set (e.g.
>>>>>> the _F_MQ bit). Are you saying that the failure of this apparently
>>>>>> invalid/ambiguous/conflicting command can't be predicated and the
>>>>>> resulting behavior is totally ruled by the parent driver?
>>>>> Ok, I get you. My understanding is that the kernel should do the
>>>>> validation at least, it should not trust any configuration that is
>>>>> sent from the userspace. This is how it works before the device
>>>>> provisioning. I think we can add some validation in the kernel.
>>>>>
>>>>> Thanks
>>>>>
>>>>>> Thanks,
>>>>>> -Siwei
>>>>>>
>>>>>>>> I think the previous behavior without device_features is that any config
>>>>>>>> attr implies the presence of the specific corresponding feature (_F_MAC,
>>>>>>>> _F_MTU, and _F_MQ). Should device_features override the other config
>>>>>>>> attribute, or such combination is considered invalid thus should fail?
>>>>>>> It follows the current policy, e.g if the parent doesn't support
>>>>>>> _F_MQ, we can neither provision _F_MQ nor max_vqp.
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> -Siwei
>>>>>>>>
>>>>>>>>> +
>>>>>>>>>       .BI mac " MACADDR"
>>>>>>>>>       - specifies the mac address for the new vdpa device.
>>>>>>>>>       This is applicable only for the network type of vdpa device. This is optional.
>>>>>>>>> @@ -127,6 +137,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
>>>>>>>>>       Add the vdpa device named foo on the management device vdpa_sim_net.
>>>>>>>>>       .RE
>>>>>>>>>       .PP
>>>>>>>>> +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
>>>>>>>>> +.RS 4
>>>>>>>>> +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
>>>>>>>>> +.RE
>>>>>>>>> +.PP
>>>>>>>>>       vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
>>>>>>>>>       .RS 4
>>>>>>>>>       Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
>>>>>>>>> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
>>>>>>>>> index 94e4dad1..7c961991 100644
>>>>>>>>> --- a/vdpa/include/uapi/linux/vdpa.h
>>>>>>>>> +++ b/vdpa/include/uapi/linux/vdpa.h
>>>>>>>>> @@ -51,6 +51,7 @@ enum vdpa_attr {
>>>>>>>>>           VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>>>>>>>>           VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>>>>>>>>>           VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>>>>>>>>> +     VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>>>>>>>>>
>>>>>>>>>           /* new attributes must be added above here */
>>>>>>>>>           VDPA_ATTR_MAX,
>>>>>>>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
>>>>>>>>> index b73e40b4..d0ce5e22 100644
>>>>>>>>> --- a/vdpa/vdpa.c
>>>>>>>>> +++ b/vdpa/vdpa.c
>>>>>>>>> @@ -27,6 +27,7 @@
>>>>>>>>>       #define VDPA_OPT_VDEV_MTU           BIT(5)
>>>>>>>>>       #define VDPA_OPT_MAX_VQP            BIT(6)
>>>>>>>>>       #define VDPA_OPT_QUEUE_INDEX                BIT(7)
>>>>>>>>> +#define VDPA_OPT_VDEV_FEATURES               BIT(8)
>>>>>>>>>
>>>>>>>>>       struct vdpa_opts {
>>>>>>>>>           uint64_t present; /* flags of present items */
>>>>>>>>> @@ -38,6 +39,7 @@ struct vdpa_opts {
>>>>>>>>>           uint16_t mtu;
>>>>>>>>>           uint16_t max_vqp;
>>>>>>>>>           uint32_t queue_idx;
>>>>>>>>> +     uint64_t device_features;
>>>>>>>>>       };
>>>>>>>>>
>>>>>>>>>       struct vdpa {
>>>>>>>>> @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
>>>>>>>>>           return get_u32(result, *argv, 10);
>>>>>>>>>       }
>>>>>>>>>
>>>>>>>>> +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
>>>>>>>>> +                          uint64_t *result)
>>>>>>>>> +{
>>>>>>>>> +     if (argc <= 0 || !*argv) {
>>>>>>>>> +             fprintf(stderr, "number expected\n");
>>>>>>>>> +             return -EINVAL;
>>>>>>>>> +     }
>>>>>>>>> +
>>>>>>>>> +     return get_u64(result, *argv, 16);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>>       struct vdpa_args_metadata {
>>>>>>>>>           uint64_t o_flag;
>>>>>>>>>           const char *err_msg;
>>>>>>>>> @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>>>>>>>>>                   mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>>>>>>>>>           if (opts->present & VDPA_OPT_QUEUE_INDEX)
>>>>>>>>>                   mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
>>>>>>>>> +     if (opts->present & VDPA_OPT_VDEV_FEATURES) {
>>>>>>>>> +             mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
>>>>>>>>> +                             opts->device_features);
>>>>>>>>> +     }
>>>>>>>>>       }
>>>>>>>>>
>>>>>>>>>       static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>>>>>>>>> @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>>>>>>>>>
>>>>>>>>>                           NEXT_ARG_FWD();
>>>>>>>>>                           o_found |= VDPA_OPT_QUEUE_INDEX;
>>>>>>>>> +             } else if (!strcmp(*argv, "device_features") &&
>>>>>>>>> +                        (o_optional & VDPA_OPT_VDEV_FEATURES)) {
>>>>>>>>> +                     NEXT_ARG_FWD();
>>>>>>>>> +                     err = vdpa_argv_u64_hex(vdpa, argc, argv,
>>>>>>>>> +                                             &opts->device_features);
>>>>>>>>> +                     if (err)
>>>>>>>>> +                             return err;
>>>>>>>>> +                     o_found |= VDPA_OPT_VDEV_FEATURES;
>>>>>>>>>                   } else {
>>>>>>>>>                           fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>>>>>>>>>                           return -EINVAL;
>>>>>>>>> @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
>>>>>>>>>       static void cmd_dev_help(void)
>>>>>>>>>       {
>>>>>>>>>           fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
>>>>>>>>> -     fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
>>>>>>>>> -     fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
>>>>>>>>> +     fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");
>>>>>>>>> +     fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
>>>>>>>>> +     fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
>>>>>>>>>           fprintf(stderr, "       vdpa dev del DEV\n");
>>>>>>>>>           fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
>>>>>>>>>           fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
>>>>>>>>> @@ -708,7 +734,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>>>>>>>>>           err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>>>>>>>>>                                     VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
>>>>>>>>>                                     VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
>>>>>>>>> -                               VDPA_OPT_MAX_VQP);
>>>>>>>>> +                               VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
>>>>>>>>>           if (err)
>>>>>>>>>                   return err;
>>>>>>>>>

