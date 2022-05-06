Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDC951CDBB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 02:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387503AbiEFARh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 20:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387465AbiEFARe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 20:17:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105E750B2F;
        Thu,  5 May 2022 17:13:52 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245M2pK2003197;
        Fri, 6 May 2022 00:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=SaCvlo62Y0mbNxGVaoty4LRK6rhNma/WwiRi++Rk5k4=;
 b=wU71IuQbkEJNQEecrYS3gDVvAT9i2gZsPuln39Jzh6tuAa9WYF93OWGEeK9+cKwLCa9J
 qu2pG3X61NAUF2UgvKwwXesnl3WkPd6fEFFwFZ5aDBUC3W7whKlg4ZM0TQ1q0mWDnCEy
 t3xIGPPraq7j+rqT+5/ipdRdlKIrD+9BWVc7ZC+ZpwJLzAuxw85YZidtNrqhwI7vgrLB
 2uFE8MYFewtzVYIuzZ9WamhFshtaes/RlpWZoABvj5tF2MbSqxqEzuEmmyVcTzg8/tFt
 WJtFmfU7/hg1r2WP/eAGcdeMPQrePEsoHPwEt8ryNFbJc/KGnfih5K015tCHTG74OrL3 Fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0avevw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 00:12:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2460BaWH035627;
        Fri, 6 May 2022 00:12:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a7p9kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 00:12:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Etj+rlCgq6lRjOBYJxSV4BvChtY2RFq2WOG3WKI4UC73EKB775eASAaySBLOprtvW8UbS6ZWiLhBKRCLb72QanMQSTn3L9tDzVlUcj6Yzt0wN1bcel1vwE13es/QsqmzOaPFdtzVR+lJxlLrTzCc9d/FmwYHk9tzLyViLZARZ2Xvfz7AKIglVgrrorMUwGckJNtoa2H1zPgQvsA/VtSZo0rOPfRwnrYSkYTSwxg3VQMSic8f6BuCe3fmIBro3/s+mPD7SqkDrJigfsLLfzwRj/ObsCWT8VCnP2wZ7lh0eCZvgD//WWIrM2gdm2+oXAmg3NxVA+yS7cRCusVO04ofSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SaCvlo62Y0mbNxGVaoty4LRK6rhNma/WwiRi++Rk5k4=;
 b=EwIaY3JWc7VjJebEq2AGG9QQuJdVNQowWLMQkpcNACYWZE+Ey4gpJDtGZaIzNAKNbjQ6rsnAEy1t3p8c5nFdWi8jkAdhb61UbUU/KhwLWlisxke9O0thWeCNuHeV0a2FTG/3i3tkRoQNreWRDF/73bHLiz0kkA2UAidOyt6K3aXVTOwps7us+atrUNeBN45nx2N6QDLytklxVR5BtGulazxOO4BpEzow6kmrW514t+UaUVPHoKk31XYCKicB+UfxIStv+30GjUeVMTBNwDGY10bp3W8iEuN1RipwWS85pvzoqJwLi0Wc5FE+zA6W/eBuEavg6KUh4mGZzyS6012r/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaCvlo62Y0mbNxGVaoty4LRK6rhNma/WwiRi++Rk5k4=;
 b=Vzw1PNNqjKmr37LRPuhfltu0CUt3DgJefzvsZbAdiZQ/84MdTTyjDumowYlJ/pLidEvo1PCAUSLoLIWVTtZSTYUktf3528WUuifgZfxyquwxDYTJW427o1IMV/pJJ8hs4dUF1BAWjTUAFfKUg0i7rfPjsphv7D0nqsumeZUgbSU=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BN8PR10MB3153.namprd10.prod.outlook.com (2603:10b6:408:c1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Fri, 6 May
 2022 00:12:29 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::125:f19d:8eaf:b8e4]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::125:f19d:8eaf:b8e4%3]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:12:29 +0000
Message-ID: <51a1761f-9852-d064-05fc-0a98a8304506@oracle.com>
Date:   Thu, 5 May 2022 20:12:20 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 00/21] xen: simplify frontend side ring setup
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-integrity@vger.kernel.org, linux-pci@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20220505081640.17425-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20220505081640.17425-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::20) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14e0a6ac-6d3e-4b08-5c4a-08da2ef51bc6
X-MS-TrafficTypeDiagnostic: BN8PR10MB3153:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB31531B14D2A46A554B4EDB438AC59@BN8PR10MB3153.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xJSu4fd8iWYoSgOLgFOy6ufTMLJ/58x7jaLn/pdT3Fo1pRCKoqywCzViN82fgGcYo7lKu8zPv72fa+b2+CRu0v8ly5dvhf0yh7eavwdPE8YBSjKwb6P2ymriOaoSP/NS4ux/xHoudKgWvYDvLqL4yuaXnXmFkfuueOzq7h1wuDyWqYE+n1uR8pwXzw+Ni1hq7QGtCZY1cgJNlcQDteVfTz49CkOfU5ZoB49wtMGCLKZUC2m/lU9xY6cyyu4xw0RraBn21YyUfwvsJ/W7U47HiUMX3WcH9Uleo6CQ4clA5raPM5bu9IjrdKMitFFyTmtD6WWqwXiH4NBTHlswJrdnXtZZKmsPoUedzVbCkhSfAgzkmEAOscFMYrW8HspYk72RT7bdMk2iM6m9iGDGeKgtb7/xvy4hghQ/onwSiPDT6jHgklyg1eGcQL7KdLWuCP5zN0XsODGJ7p0VS3VIRGfKCWRdKNHzeidZXcfWiopKPiAH4BrSXnHBBIzYmUHl4TNMKOoeVB9Gj8GgPd+4Ikibt5/pU9uiBCVtAw3tMmWDrG6Notmb286qvvEKygLMAYn8w2YaGmNWCJ5MDGSTOBLAdzc2giBDGFdilN1ompRo4xroA6Msykrdg3+98dkq6MMcoPVOi97pni7isEdyi8YWIeG65v+PWzvOAx9PbJ9iiHeqscal+pWg1DnCjhgfQ5kdDZRyDL7DExJB/aGXqPAwcd1dsHuI+6ciPVXvccKA/Lwtvbzez1P+5YAIxvYKvR8SlF5+qB57OBu133XoAPFQJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(31686004)(53546011)(6506007)(6512007)(2616005)(26005)(6666004)(508600001)(186003)(36756003)(6486002)(44832011)(4744005)(5660300002)(54906003)(7416002)(8936002)(86362001)(2906002)(31696002)(316002)(66476007)(66946007)(921005)(66556008)(8676002)(38100700002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bytxaFk4Q0FGZ3RvTFZZOExlOHpOc3dyUzNXKzNOWExOT1d3R0Z0UTN0OU1s?=
 =?utf-8?B?c1lpRTMyZVpPUHNpSFIxQVZOTjhnSmdGTWJCM0txMm9XSUlHUjJSNEtVVGhy?=
 =?utf-8?B?QnNRcVlIYzZOVHM1R0lFQTRaQm8wNnprSCtwWGtvTnVSRjJDemJ2RW1YcHNl?=
 =?utf-8?B?ZW9henBhbkN1NTlrZjRyUHJWNWRpSTZndnpZb3luQUFFTWlyMW1UNmRsUWdZ?=
 =?utf-8?B?dFVZbStXalhxNkFmSEZ1UDQyT3VOb21nUWRhZ1hKT09zNENYQkczYkZNUTFq?=
 =?utf-8?B?Rm1aQzRvOS9NejdDZU1hcDE3dGwzRFp2dytVVTNyZW5ob3gwTlRCZWkwblZa?=
 =?utf-8?B?N0dxRElvMnlUYXd1aGxzYVNEekVrQ0Ywa01ueXBwMk5HQjVmbUt1b3h6KzF3?=
 =?utf-8?B?K2tIL0V1ek1sWXpiY2c1NUhIM1BRQ1JPbDZwSzVnZDFjakF4TDJLdTFpV0hz?=
 =?utf-8?B?OUR1RnZ6QzJOa1NlKzRLdUlqblExMXNTYVhjM1hWZUN2R3NEcDZITkJKaXBa?=
 =?utf-8?B?aHczTXpuS2F2bG15TlJpdWgwQXl4WXhXYk90WkpISmZ1QmExRmM3dlZCUHRQ?=
 =?utf-8?B?U1prSXNBc2lONWQxN3V1elI3cW1yWGFzNDd4d3hQMmZvTktJa2R0VGxtMXo3?=
 =?utf-8?B?VDNESzVLQkhaeWZXL211ZHhCWWUxZkdFbVhBNUNSeXZSY0s3OVFmZng0UWZn?=
 =?utf-8?B?R1BnYlRBbGJkZWd5RUY0alFWZDk0Qy96QmdNZHdGYjRiaVRJdWh0K3lqRDJp?=
 =?utf-8?B?WWRBTStQeW9wOGZxU0VYTVEyYndhQ0MzUU5OYkFiekp0WTBucm9NMEI0MW9J?=
 =?utf-8?B?QVZwaDJEeElIL1ZVaDZFcXJ3eS9XTEdUV2REeHhJZXFBN1doUDBqZVUzQmU1?=
 =?utf-8?B?bjg4RlhKNnRNbEN2UERkL0Fsc0QxditCM3lvNmJoK2ZsaGUxSi83by9wTzNi?=
 =?utf-8?B?SFh4TmFZNkhjUUp3SSszY2Y3ZzBGOG9uamY1bkNPS2Z2Y1F4MXZXME0wak9K?=
 =?utf-8?B?Z3lvdjNiVVMwVmNkbXZYdW93WXZZZDRwYkMvV3BRWkdrODVmOWwyRXVib0Jt?=
 =?utf-8?B?Nm5rY1lkR21BT05QRTA4SE9POVk0VGZkdFIxZ0N3VjRpVWF6Q0x4a2ZyZkho?=
 =?utf-8?B?UDVibWI1d3N5SUVaS1RleCtNSmJRVE1zSnhaV0FIT0Rkb1gxendEOWRQK2ds?=
 =?utf-8?B?TUI4Rm0zS0JOTk9YeFBHUE9YMFdINGJJK2k4bWcyZnRFR3FyMGJRY1ppL3Ru?=
 =?utf-8?B?SVlrdTdnTnFtK1RsL1BEMTF4dGZPMDQybW4rSTdBY1JjeVdPd3VQK2RCc3Ix?=
 =?utf-8?B?ZzhEejQyeERpaitjOEJKZjVjdzVsUG5ac1I2OHRCOXFDVXFrV1VZVVdHcm5S?=
 =?utf-8?B?R2luVlJqUllRVGhwNFowK3lPd1BvNnorZHdrOE91RW9XQWxvWElDdTh1NXBQ?=
 =?utf-8?B?NjdaNC83QkRNbFFyWHhJQU5EM3hGOVZjVWEzek9TVE96TGZPQUtmeldrT0o3?=
 =?utf-8?B?cW9ZeUd0RnMvUDMrR3JLT2VLSjVodEpZc1V3d1dDRnpoL1JsbmJBbGtaTDMw?=
 =?utf-8?B?dXkvb0Z5ZGw2WmhiZUIwTFVJUEF3NnE1SXBKQkEyYkJsZXlZaEoyVFlEcDZY?=
 =?utf-8?B?TURXcEc5WmthUy9jTUlURGJEMExxaFoxUlVsOE9aTlh6LzdyVUxsSXpxbCtz?=
 =?utf-8?B?aXhFMnl2eWlMRzY2d3NMdXR5S21pby9DS1NPQnh0ZCtNTWdFb0x0WmZtcmFn?=
 =?utf-8?B?MUR4SUNhOUhacjErWVRQYnE0OHFoTnNYQW1DUy92OUZxWExpakRWSkVkYU5I?=
 =?utf-8?B?REMwSFZqQ2NzQ2dYdGNkK3Q2SkNSdzRLVEh4YklFZ0Vlb0xOVWNvbXdtWmhV?=
 =?utf-8?B?VUZWb3oxdGZtQzdHbS8rSndRKzBqYXk3MXRyVGtwR3JkUG4vMzdjcG1RS3Fy?=
 =?utf-8?B?V0JoM0xUb3FCbEFIVS9saWg4NVdyU3lVZmw4ZmlTdlhHcG55eXpkWnFmZFVT?=
 =?utf-8?B?NXVIYUhMeGpEby9jaGpDVzNXOGFBckREUWllTVRyZVR1T3EvQ2txN2V2WXZy?=
 =?utf-8?B?eDVSY2Q3TStMTmtueExsZ1NsT0FjV0cvNVArT1FPRDJINW5ETUJuUlBEZnRs?=
 =?utf-8?B?cDZsdWcwSzNUZ3B5TFgzTXB2SzNvRmwxVWwvNGF1SGxUL1FFcEZSaS8wRFB0?=
 =?utf-8?B?NzdzUUpKdG9IR2puWUVORkFFcWVNRUl4dUovMlNkYUVpbWg0cHBaMkdHZmFE?=
 =?utf-8?B?dDM3dUJuSFUxenJVaGRpR0dOb3VwbWVmSFQ0Vk9GUkNzdnp1SmZncXliKzhh?=
 =?utf-8?B?OUN5dVE0QVVqckVWcXJnanRxVEduckVnZTJnTUx2WFhnL3hjWEMxNWRYRHcw?=
 =?utf-8?Q?sdsvwoAp5hbzZW54=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e0a6ac-6d3e-4b08-5c4a-08da2ef51bc6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:12:29.4977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYulAuZhXmK5BaUUYMzlV9HQeCTsYoFltdGk+LDG0YX9O3CRYmG/rGitCA3acrGEhNhjaRQ/jwbjgosZ9KigRlxLMXlok9CDeFxtmfhZRiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3153
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_10:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050153
X-Proofpoint-GUID: XWU0bMd3BhK7XLGpuB-x1jMxs1RfxYRX
X-Proofpoint-ORIG-GUID: XWU0bMd3BhK7XLGpuB-x1jMxs1RfxYRX
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/5/22 4:16 AM, Juergen Gross wrote:
> Many Xen PV frontends share similar code for setting up a ring page
> (allocating and granting access for the backend) and for tearing it
> down.
>
> Create new service functions doing all needed steps in one go.
>
> This requires all frontends to use a common value for an invalid
> grant reference in order to make the functions idempotent.
>
> Changes in V3:
> - new patches 1 and 2, comments addressed
>
> Changes in V2:
> - new patch 9 and related changes in patches 10-18


For the patches that I was explicitly copied on:


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

