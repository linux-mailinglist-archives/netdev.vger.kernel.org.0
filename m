Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A6C582186
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 09:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiG0Hut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 03:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiG0Hur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 03:50:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB80F28702
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 00:50:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R7C2Dr030020;
        Wed, 27 Jul 2022 07:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZoXHW5xjCyNy7eTS4/KKBqsmACn27brQZCb/CsEEjjE=;
 b=EDUOEXNKAjAsQJCsaR0nidumAhXYsKdyn1TV/TbFAJqv8LP8PgmfSpCiFIOsasqfvO/h
 Lpv72Ub7jIEqafehFpAl4vaByFXyq+ZtPQ5UvsBEYUkI2g1Tm29YSgJE6TBIry0cTIPL
 9eYv3XMyJgKntUR6+Z6wOABEr/7CEZ7BG44JQKPDFQfs2/XFlNapcTUocWlEfWuYekdY
 gupvAx1fzHkjr5VKl+oyrAUc3Cn9QLNJnTxMOySNetJBoqZfrKXbuQE0NVN82XcpuQf9
 e/r0w2lEd6HkvDTOeGIdl2Lzw8H4xm8Y5Tz0zrizkUN1gQ4jBiT/ArC2KoNsD13obgUL sw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9hsrv7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 07:50:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R7NwND017671;
        Wed, 27 Jul 2022 07:50:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh651kvns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 07:50:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWmzRUwtHlUa9dqi+Vju3qyCaolm8Cu3X2IsbUMYOajTvsOdn/pNSUix4gD+E10DJAm4DdR4dIxEIKzLyIu4GmhUm/RTo1FGUvyWi7tECZRrt5A40iJ3petQCThfil7SdaO+68wdiWv/4LA+i3XQPbBtyeWK1gyY+eroq7CQtz48rxpGpfASKCOHzE/qvtW0Ug2Cr6RVR8FdLSIGHdzjSZSD8CaIPNKBKTF9dZzr+FWo1k96qSCn55VlZoLp0DzujWyQypIc3OJtKH9WLXWFQXPtx80fRCm9gxr40ULXrwD5SjJU+g3VQs7UgdruXs1hDHwj2xjAm+/9FvgjRBo7uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoXHW5xjCyNy7eTS4/KKBqsmACn27brQZCb/CsEEjjE=;
 b=VxtDD5zqSOlF1eVHq/llXkR17S8plMRfxTw6gWBZMj3yMsDRmwwEQO2iMhac0kE/PrxYNYUN5AMl+3p++mPU5gMzdMk2VoW245dQYR2wUpbC+d5LWTYKrm9IMJtpZT3axXT7G1Q86TurIFggoLTnWKZiZ7Jh9o4xzsziZH1ujLzC5TrFDMN9RfP/EnRHbn7/LtVN8Q/o6Wxd6GPE0HL+tIt8UIjTLE2pXH72qz8bJv0wqhiDDxAgmuAulBs53hXFfx7Ji78bKzoqTBfC477j0oFL42YyKmd34WWBth3+RzvYOWVb5/680xIgMIgvHWVLnHTlx+EhwDkq2Dq0MlXtSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoXHW5xjCyNy7eTS4/KKBqsmACn27brQZCb/CsEEjjE=;
 b=ezh7bFaAAJlZNwaDnPF6XjHGsP14cDO1cqMVsIePrnqcBYFeza+kY0SLJ+2Jmn9iW2+keZHForVeHLkJ3zf5atlqss0yzNiQnJOlXMlWzRdTT1vAT1tsry7hgw7qOvQNXzbiwQZK7wte4H4DJm4RP0OgHlFRMEk885ZI6tGE3lo=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SN4PR10MB5573.namprd10.prod.outlook.com (2603:10b6:806:204::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Wed, 27 Jul
 2022 07:50:36 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803%4]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 07:50:36 +0000
Message-ID: <66291287-fcb3-be8d-2c1b-dd44533ed8b3@oracle.com>
Date:   Wed, 27 Jul 2022 00:50:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
References: <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220727015626-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR08CA0038.namprd08.prod.outlook.com
 (2603:10b6:4:60::27) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14a9aa4b-959e-4e93-1b0d-08da6fa4b105
X-MS-TrafficTypeDiagnostic: SN4PR10MB5573:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbaRsVQfaJr5cKbYzkPkVlYaN2c61fCfUf7AfpQEXxc5yr3P4oyFSGwgkXSnrPC1EhEKOWMiYr1+FPU2BJ3tt06oJ8dI6uO3FooSmcJHzVqs+dwhgP6O4fFwMj2iWRzCBiS1HXXrpAHVRWfW93QsuITbqZMqZqFT+0Mg5lLmKza7D9qSqQQbARCV4dcHb1Qlcn9usPLVtOZmnoRgy8eS4jyY2WA9AWlcu/X4aNDX+2blKkkaVl8oAEzhoO4pdRxawOP73z7Nz85v2NuC7dnkJqH7JtDJPvnrJPkbQZEERmLUKyAO1KN64WSvSXbAf9HPxxRdxD0OPOXVwVZLCSFKM7knuxAP8X4IMrZn3nnhGEQzhJZybYGNCLhFo1OlB55NQKMjZaz8kmeDYwEmKUiHYFU1KNQW8wuzYiCYZKjuCubZfq3lCmI7dV0yQBN8yKZAn71ARDE1vtquPYEuXiKtzRZuXmfCqxudzlP2uz043UbZpFpVhIa5PvdhZQz0+Nz9zjWFH+e6jdhPq4KIwiVem8C0GRayF4LlvKqKpEMu6ju8okrJ5sc5z69xouod6HWqdBUBjLCDl6S0f8GGZzW4CO7kgbyBh8GvuwqU1EYXj5XcXDCH9LonJP/3BiCdgBs8S2qn9Bf+5l3xqb+M7d3Zssim/tFNY4YEDUZiAPEc3fmmzSjfo1grwZtj2DrduKlcRv9wGK48FgI2KZ5y2c6scokNCYmJ49wIAclBSC+nZYWDYCFZlXv8KQxn5kmC68N5qsf8LV2gOnUnxFTG0+X/P52Hi13XL1SUwROqtUjmgeW12mmlaX8hzfhAJoRpZ5qTG2Iav5SJgmtoEeck3fvjRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(366004)(346002)(376002)(396003)(6666004)(83380400001)(110136005)(36756003)(316002)(54906003)(41300700001)(38100700002)(6506007)(8676002)(5660300002)(66556008)(36916002)(2906002)(478600001)(8936002)(31696002)(4326008)(86362001)(6486002)(2616005)(66476007)(6512007)(26005)(66946007)(31686004)(186003)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1hzQVZybFBvWnRZNjB1QmZGWU9WWlUyM2E0a2RVbFZBZ2RUcXQyUTg4QmFJ?=
 =?utf-8?B?Ync2S2Y0ZHpCWTlEdTZ2ZmFQRXZ1Z0JyajAzM2Y5cGZJMmp6THpoSTA0bDlN?=
 =?utf-8?B?YU92LzJVWDZuV09EakhFaGNTaTJkQ3FGRUYvK3kxSVlNZEpwbGtMYit2c3Bu?=
 =?utf-8?B?eXd1bkhUQWlTSjdPNklueFdFNmdubzBUSU9KMkZSUnFJTUg1c2w5VTZscHpl?=
 =?utf-8?B?RFJOV0RpNkxLVjZGRzA3cVZEV1lvNllaL0VjY1kzOG4vQm1UQVh3d3ZMTnNV?=
 =?utf-8?B?enlYQm5HeGdHaUtqVXJIM0psUytEM2FLQ01pR3Y1OVFZbjhacTlodXhoYi9R?=
 =?utf-8?B?U0ZRb2xDYTFFaE9FQkNqa2ZaYTJzcmJ2VlVaZVRBbURFcU5uR2dVUDEwM3FB?=
 =?utf-8?B?ZnBHcTR2Q053dTZNcGVEc1hpU2ZleXBsNHhLRFJtSHlkd3VGTVcvWUc5eTAy?=
 =?utf-8?B?alRsSXZiRk1sWFdQSlZtVEk5NTdsZ0FieDFNV2FUb1JEMk5XbVYyajArRUww?=
 =?utf-8?B?ODA5VmJkeEFGNVVYd05Mem41QVp5c0xCd3M0OVNvRmVjT0d5VkNnUUpxOXkr?=
 =?utf-8?B?RHdHN2hXamRRRlU1MkMxb25ROG1KajBLdnRSMlFlV2w3S21Hc0dKRUdBamJH?=
 =?utf-8?B?WkkrRTA4TVhtUmtycTZXazJPSzg1MURaelBBMnBqTzBJd3YxMzVkL2gzR1o3?=
 =?utf-8?B?ell2M1huZUM2eGtYQ1pUZXNvdmxZVVpSTGc4d2NiQ0VUU2N2b0c3TG9lYmIv?=
 =?utf-8?B?dWJobmI3bCt4dFVZaU54R0Z5RXpmMXpXZ0ZXOFZOM3QyNGxPZWpYV2JvTXZQ?=
 =?utf-8?B?NnVQeWMxeFlsSnE4cEVMeEJzQ2x2OTJxemp2RkkwUmYvUThlZ0VPTUZYZ1Zq?=
 =?utf-8?B?MzRwWElHa3pweHV1SXpyWElQV0lQMWk5SllhOURkVTVkNTYrOGsxZkdwbXVC?=
 =?utf-8?B?TjZubnBVcmJSSkpKVDNJQVJuM3BaTC85MFl2YkdLS1RKNm5lK3dnVlRzTHVN?=
 =?utf-8?B?NDdHeG5SbGFPYU9SZXVDaHZydXR5YXJSVEpNdEl4dFZqN3hOOFhaRkZkSXkz?=
 =?utf-8?B?Qy9vSmtKYWl6SFM0cG1kTmJ3OEtybitydHVtb2xhdHVvQ2FkdWRRajdFVXB1?=
 =?utf-8?B?OUlWblh2Ujg0VUpwOUlDb1lHN2dNVHRoYlpPLzhPczQ5eXdMbUIycTduRzFh?=
 =?utf-8?B?VC85alpSYk9SdHhScjlHYitpY0J3Z0lFNWhtUWo2cnRYQ2ZtNzl4bFRNMzRz?=
 =?utf-8?B?TVhwRVZkVWlKbU81K28rbk9mR1g0Tjl6MW92MWFpYlpjOXYweFR6V0hBSVBQ?=
 =?utf-8?B?QS9RK2ljNUJlQTV0cXh1Y2xmUVlXSlBJZmVWc0ZYZkZ2K2hrRERQdGtHZXdB?=
 =?utf-8?B?Z3ZOZmJrcVNqSDR2SkVFbEdrb2RSN2duNG5pTGs0M1k1dEYralZaUVMyRHdq?=
 =?utf-8?B?OXhYOVhIbWJvZllpQU1RTTNTUlBkN2RDblZobXhweWRxS09YbisveDJPSTMv?=
 =?utf-8?B?WUJWSjdycDdkT0owL253eTM2OEMwUmRXcm56ZjQ1WU1vQ2JsUUJ2Sld2ZmRa?=
 =?utf-8?B?UEJZOFUzM0t6L2FadzMwZW9oV25WeTNDNzEzMUt5NldNMXp0Tkc1V29IMHh4?=
 =?utf-8?B?VHBFYzhDWUZLRFVuOVkwL2Exd2ViMnUvb01QbWFjTFFoYmpkMTAvWEEvdHBM?=
 =?utf-8?B?TmxFdVRDTDVnK2REQ0wva2NCQ3hFeElBME5kZ3JVN3Y2c1E0NlZBaWlmQmVw?=
 =?utf-8?B?TGUzbjZOd1FYM045dHRZZWNyN0QvRlhoZ25RMGQrb2pPRTlFTlZveWhJbVFG?=
 =?utf-8?B?Zk5LcEsyenJYNUd1ZmErSVNhT0lwcnIvRzg3S2M0YlNXTk9DMFg4Sk0wdVpZ?=
 =?utf-8?B?eG9WZzNrV1VLM1NFL1JzN3RwL3h0dWJxYUgvcjlRQ3pHd01xVWg5Q2NMRmJm?=
 =?utf-8?B?Tis2NlNaa1lrYSt0M2o5VjdlazJqWUVqSUtiTkV1Y1NrVXVJSndsWlpDb1c3?=
 =?utf-8?B?Q0dlVHdtc1JBT0gzNkd2NGJPVEs1UHhUUmVGSkpNelA0blltSUdCWEtoYkZ6?=
 =?utf-8?B?aVdKdTFtdU12YmRIak5seTB3d1RGbDZadUlZeE5qL0Z6dVEyb2lLRzRnczlT?=
 =?utf-8?Q?pFAMQ2/cxM3AUFeP7+jelZU2C?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a9aa4b-959e-4e93-1b0d-08da6fa4b105
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 07:50:36.3286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +KKaTluxR6HpOkJ8yjA6DFJGZq2++NPURZTzYGigm/IPtw6Q5y2EKrVpDDrJLulBsj5q2EXmDIGLDM7u5vB/tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5573
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270029
X-Proofpoint-ORIG-GUID: 4njW8EwyC8Xg1fNwgdiKPb_TMsKebz-v
X-Proofpoint-GUID: 4njW8EwyC8Xg1fNwgdiKPb_TMsKebz-v
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/26/2022 11:01 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>> Sent: Tuesday, July 26, 2022 10:53 PM
>>>
>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
>>>>>
>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>>>>> When the user space which invokes netlink commands, detects that
>>>>> _MQ
>>>>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
>>>>>>> I think the kernel module have all necessary information and it is
>>>>>>> the only one which have precise information of a device, so it
>>>>>>> should answer precisely than let the user space guess. The kernel
>>>>>>> module should be reliable than stay silent, leave the question to
>>>>>>> the user space
>>>>> tool.
>>>>>> Kernel is reliable. It doesn’t expose a config space field if the
>>>>>> field doesn’t
>>>>> exist regardless of field should have default or no default.
>>>>> so when you know it is one queue pair, you should answer one, not try
>>>>> to guess.
>>>>>> User space should not guess either. User space gets to see if _MQ
>>>>> present/not present. If _MQ present than get reliable data from kernel.
>>>>>> If _MQ not present, it means this device has one VQ pair.
>>>>> it is still a guess, right? And all user space tools implemented this
>>>>> feature need to guess
>>>> No. it is not a guess.
>>>> It is explicitly checking the _MQ feature and deriving the value.
>>>> The code you proposed will be present in the user space.
>>>> It will be uniform for _MQ and 10 other features that are present now and
>>> in the future.
>>> MQ and other features like RSS are different. If there is no _RSS_XX, there
>>> are no attributes like max_rss_key_size, and there is not a default value.
>>> But for MQ, we know it has to be 1 wihtout _MQ.
>> "we" = user space.
>> To keep the consistency among all the config space fields.
> Actually I looked and the code some more and I'm puzzled:
>
>
> 	struct virtio_net_config config = {};
> 	u64 features;
> 	u16 val_u16;
>
> 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>
> 	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> 		    config.mac))
> 		return -EMSGSIZE;
>
>
> Mac returned even without VIRTIO_NET_F_MAC
>
>
> 	val_u16 = le16_to_cpu(config.status);
> 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> 		return -EMSGSIZE;
>
>
> status returned even without VIRTIO_NET_F_STATUS
>
> 	val_u16 = le16_to_cpu(config.mtu);
> 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> 		return -EMSGSIZE;
>
>
> MTU returned even without VIRTIO_NET_F_MTU
>
>
> What's going on here?
>
>
I guess this is spec thing (historical debt), I vaguely recall these 
fields are always present in config space regardless the existence of 
corresponding feature bit.

-Siwei
