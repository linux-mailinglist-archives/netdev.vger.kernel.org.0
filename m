Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D495965EB
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 01:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbiHPXPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 19:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiHPXPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 19:15:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F372FFA;
        Tue, 16 Aug 2022 16:15:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GMxlxO026249;
        Tue, 16 Aug 2022 23:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZrE9JMovCrb8mkiopxrtFB0sPA9ltNwJqW6j9NdVX/Y=;
 b=bgyvOFXKIQt7OA24wrvPrNbmoyZ5jpPEzupkiJaZiUL52M3StSojoKE85zVWUuEh551t
 s5t8Sz8QX+cU/76/bC5IAZGGbL7l72rpFFkKFxQTB+ctugk/IBr1OuiR+tBLiTmLY1jf
 etQxq4A62jmplA2HMiepAvIPBXjHsiogWdl8zFKM+ATKbi3TXzEvRXSmfyo4S46FKaMl
 J6oEaZWZ16E9tcFZGNFZe386vCNjUFwL4ZImeo28EcZ5yxPSEjart6oJYcnO9YH8oA+C
 G5v08PUuw0nU/eDOodMq8Wb62VI8hSDJ0FkcftJ4aR65YFVXrl1k536J+1WYFSM7MH8H /g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx2r2fjne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 23:15:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27GMsaRf029034;
        Tue, 16 Aug 2022 23:15:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2d2y84j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 23:15:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Syagn+tlk6p3Az/g50xEyV2Q9wdZboBCN9AXsoIQJ8rcrT3S8n0pNmlNK0pT0vHUroy31H8sRp05YfIgkpr0NOQ8sRyj3dQbsdHrfUVb7kiy9kcwW8gODgi6VKrUizPLyBzt65r+GAQEXltG8FfqJvSXo7ySHFZl2FqezHf3pek0cadLhqKVitj0w0zsqXBlz43xe8xxAGSmRv5gfvgGEuf61Q/xI6Aqo71Ez3sv6VKCchlwekf3ghdxl7jK97uguxRq7/s37MaLElcUytkKXdLahMC/xKUsDTFE1P0J1hpZEflgJSQRLHkEcDIzccLbiFwpQJdimuuBdvU6EIL7Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrE9JMovCrb8mkiopxrtFB0sPA9ltNwJqW6j9NdVX/Y=;
 b=TSUWMjrexMCRwBLjnFOF+hFMcY+9tWb9d4bgpZZGgbnvlmCiyEh5bTHQpBtF0eSNS3Ya3X7nsaGrOPwq5TPHxm+rCnUO9y4YhZskswLPUtIWoN5RkNgcJaQBDGqDQ8xHq8rkSTAUmaUvB1cPNismNRDjmX5MEh6Xa81C+hFXLz4y/0Kj/2njaOa0wevWdPW+PqHv1yLNEPeUdVu74FbgHZa9MCKgxp21NFIit6QNmrsM6cmJ6J5zinblYKVpUFhK9ShYKvsSorMR/moQsfn1Wvma44tQ2vMg7Zf9AeUShHhmriYIcRsK4VP8wDIvDLR2DotFCTphbWJxPQREAMvozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrE9JMovCrb8mkiopxrtFB0sPA9ltNwJqW6j9NdVX/Y=;
 b=xGeHBhqyfNj/xVPn0/JUVuzIaQBjPteGjqjGYAdY2EEjG/QQwtzsxrBDjRjwWoGa6xLoC5WjM42Yc9cgfArmSyVaj+NdHmmB2Q3AVyP7tcuBnriHDSaBzENXDTXn6SV5dRLDplLUD4+D9pbn+LmBUO4fsfsGx9OPhWI9/KeBgfI=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by DM5PR10MB1257.namprd10.prod.outlook.com (2603:10b6:4:f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Tue, 16 Aug 2022 23:15:04 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 23:15:04 +0000
Message-ID: <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
Date:   Tue, 16 Aug 2022 16:14:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:21::13) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4585a6fe-2e79-4635-ae1b-08da7fdd26b3
X-MS-TrafficTypeDiagnostic: DM5PR10MB1257:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0oY34z1Ym03iwRynxfiwmqlXVuwBUuSTmOW5OS0AfC0GhQi04TFmVjmaRP5qqGTmt4AvmaWK6Ngi4uQu27j1Gis6hivbYovYyPE2u4uFYzq276VT4jrEqe+M29+j45ZdXCL2mqFed6s5P/ZU64GkkHs38OTmJ3rmJd/AfiZqX6pasnm9oUO9vwbQkl2CiBhZ6JV0pLbvR7XtokYHFFr2szC/XuSEVp++lqK1yQtvY+OSLIC9Tk3BMoaHV4Kl/1aWfhK6NIRhBS19xteLgMFnIL3xX+BQiRPSfwg5vxoqsaV0otIdWXZ9o31HzL/QdFTYu0QOfhlmBDGP6gBZCKthSSLLwAyai3+b/VBVQl5elKEgcbtU/g3zuMA90+ux6rZi7332RquTAvym/5uL+gGpiwqlXRFYA+2Wvu7EOheq38Wg7mKUPvaiCEHlC+2ZaYPZjNKLcoqVr7HEdLbnSTHCcs8ZkeEdPaG3jGwA5LL+0O0ptPNCBZ91rmP1jKGvSd8nNmmuCWtN9zkVzXr5JqQkfGs01CNXOymZ/6Og6kztyLKn5sEMiNTN8kf64ZHOIsPlaHuls2Tj+315DerIo3zaG5PUX0lmMIzMlhqlnFgrTsUdEYNK7tkULVlhBfezEUT2hbf1LlObejHfpTYoTWXe5caMIFv+2p6KLPRjaHy1zJxuLWq2YpPWdUohAZmMpZ+BH1VfE2pPPa7Vw948Q9lqhmWBWC54r92mm1maLPIIbYlAIp8Rc05lN+at//sTp7lSrAooL6lY8MUaKKcZLwMvz+WNngXMXMzPplHSLkbclt3TMAqKzphUGwbN0CNZaP29Srl18HYNBBFIm7UKdFs4rj1aMiCp+OxB5Q0V28FJY8nf4YYz6wTaMj7lOEXBDVu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(136003)(376002)(39860400002)(396003)(966005)(478600001)(6486002)(2906002)(53546011)(26005)(41300700001)(36916002)(6506007)(6512007)(6666004)(8676002)(66946007)(31696002)(31686004)(36756003)(86362001)(66476007)(316002)(66556008)(38100700002)(186003)(2616005)(4326008)(5660300002)(30864003)(8936002)(83380400001)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3A1bXI0UkhNQlR0YUU5SUZaS0NxMVRmdlRHMW9IUEQ1U284MWR6SGZXQWRW?=
 =?utf-8?B?ZTlKMk1wd3ZIUytxMkV4Mm1BMDRpTGY3aThLYXIyNVZHOXBJS3RPc3h5a1JW?=
 =?utf-8?B?Rm1mRTdIYWl1dU55eHJqUjVHOUtyVTV6N2hrVG1acVM3MGsraE9VUDh4SGxW?=
 =?utf-8?B?Ky9GQjUveW5GejYrTFJQVEhKNlpVSWFOeVN1TGpwZFNkd1gweWhvSUZWcjdD?=
 =?utf-8?B?SHJ3MndvY05nSE9INk5HYkVnU2k1SUhldlM5VVN5WlR4NWNSNlM2Y3hrTXVW?=
 =?utf-8?B?UTJLdkEzc1Q2U3RMV0p0eERReU1JYlVRZ0F0TnlQd1p2RC9BQnJ2SGhuQmk2?=
 =?utf-8?B?Y1YzTzlNU0JHby9UVm5LS2J2RWx4K0YzM3E0UG9OWVM3cEM2dzZIZzQyWTcv?=
 =?utf-8?B?VlYvNVI4K3A2MmppWGowanVaYzBESWUzaVI1cGhDTXB4TlVUZjR2RkJqYzFN?=
 =?utf-8?B?K3RiWkNQUWFYRGJsSHhSbUtKTVEyZUk1cFpBYWlEUThnRnFSTWgrajRwWkhT?=
 =?utf-8?B?M3NmRVNPTGQvZXc1N2FCeDEwUEFuY21zcmE3MlM1UkExL0Y5aUJBeGh3Qk1M?=
 =?utf-8?B?V3FFMWdRZDU3c2xnc29vVmNWd2lZYUdud1VJelVIeFdtS1RTMzhTZnRrazVY?=
 =?utf-8?B?SUIxZWhUS1JQT0JlR2tmRDFyNU1uNjdKMHlnVGRoVFhTYmg4SW9UZmhVMHYx?=
 =?utf-8?B?cGNQeExRQ2IzZ0ViM0hxUG41RWJ1bGNwKzRtdngwaW9OWjlJOFpIWWRCeW1K?=
 =?utf-8?B?Q1FqQWRJbTZ2N2N5NHc5ZGN2TWtlSS9mVUNId080ODNFazRVa0RKZDFyVm9J?=
 =?utf-8?B?eURoSXZSYjZ3TmEya3A3YlkreHZRU3JNTXYxdDZka2NDTnFCTHlFRWZmQ1hD?=
 =?utf-8?B?ekV3WDBpYUxDc09RWk5ObzBsVnNTcVdJWTgrZll6MXhxdkl0MUszaVBYL2tK?=
 =?utf-8?B?dVlSY1lpSlB3QWcxSEo4eFZCOXNRVDJpdUl3TG43bm80ZjVkOVZBMDRQdFpv?=
 =?utf-8?B?VFE2MWxUWGI5WlVacVpySEZWdUZkSWJtUStEUjE0b3RDZ3NPTjJoWlV6YktE?=
 =?utf-8?B?S3RqaDVnenN5U3dYRnRuMkFvUWNTMjJpaVVXQjY2SmxwMlcxNnJWajNaWXpz?=
 =?utf-8?B?NWdPUnhsSk83UVVNTlNRcWc3aVliZmRmb3Y5MlYxb0NzZVN2WU81Ti8vUUli?=
 =?utf-8?B?eVBzVFFPTnZ1T2I1ZEorMExadDRma1lHYkFaZWVkd0l1dytWL280YWg2cTNy?=
 =?utf-8?B?elJJSkhHUGtpOWdMMHl5eVNTSFd0RmQvU2VldmFYcmdLM0FlSWREN2N4VWV3?=
 =?utf-8?B?VHFweitSTTVWUmNrZUpRNnEyZWs3L2xBNmFQZWxDaUxoMTJhbDZ0WDBuWU9v?=
 =?utf-8?B?NVZyLzNzODM4VitHRk5KTW5UNjBoODNQNnV0V0M5alVmTWVnS2x0OER4YzdN?=
 =?utf-8?B?UVlsM29xUGNLam05SEZnN3NzUUJwNzhPM3NWMzZ6WDdEN09OWkJUM3BUTHlS?=
 =?utf-8?B?dXRhd3BlSDFPdkhkM2h0Rk9uL2ovaS92RjhQamFwYlQzenc0bE91eWpycVE4?=
 =?utf-8?B?M3hudTh5OTNGdSt5NndaZ0ZUWWRvbUNMeVZ3QlhOWTRBa0ZZVE9pSG5xREx1?=
 =?utf-8?B?ajNCOE83Rm9IMy85eXZuYmZzbHpOK1hiZmFjbnF2dm9vT0RkOGFhZk9vcis4?=
 =?utf-8?B?V0xyQTVBaytXK1FFUXo5L0F1dTNLQ1pva3lOQkR5MVdaRkZKa1FhUThQY3pi?=
 =?utf-8?B?RWxhTzdpanEyaEt6Y2hUT2labmVKQ0tnckJnd1BLakk5ZVNvVzBhVGVGbGVO?=
 =?utf-8?B?ZDRQMU1KN0xRTFRiVURsTzMzWVJwamJrS2hTY0dRU3dlbEwvUHpHL3cwL2x0?=
 =?utf-8?B?emQzOUE0RDdXMkxKSEZlK29UdUlEWTBvd0xUZTFHQ0FGOXh3R3FoWkNSK0hK?=
 =?utf-8?B?aGdvOTZFNUZYSVdzZDdQaW9TOVh6K0pWL2FQZmp0QUVLMFZLS1ptcVBqMWVj?=
 =?utf-8?B?RUpRMkdDbklXbkhQOVBnLzRwRkJMWCtIVnBDTjUvbkJDYmtjcFZ0Njlqd2lu?=
 =?utf-8?B?M3k5RGlqSUJBWXk0MDBQWDNNLzJBV2xsM1lXTzZ0TmNTRUFSb3BVQk8zYmND?=
 =?utf-8?Q?VrWNczhEmX7y2l36aSziN6pzw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?M2FlVlZ2M0N5TXg4Q3pMdFFsemhzcUlVZEwxVVJMRWVYY2tpWC9hblQxZkNv?=
 =?utf-8?B?eTRLSDBia090RVJ0OTI5OVgyc0lkSk1vYW02UmRlaUtpWi9SNG8yaG5KZHlq?=
 =?utf-8?B?Uy9keElOaFB1S2R3Sy85SjQwMGxRcEJzTWl1enFQNDIrNlR0bUwxSTA1dEZz?=
 =?utf-8?B?NGw4bzBKUHBxdzRPYUt6S2NzTEhrTlFsQ2FQNHpIRjJFeThZcmx0bjJsMHFI?=
 =?utf-8?B?TFNBdzhjRlRUNm0rUXNmYngrdG00WWVmNjRLcHNnd1VLNzExNFl1TXI3bU1s?=
 =?utf-8?B?ejVDMzFWYnZaMkdmdnNtRUY0MEF2MWIwLzdaRi9jSnFzRkM5REZoZjRZK1BV?=
 =?utf-8?B?emhCaUgrT1BMY3Njay9rR0FDaG5Xbjkza2xxWEZkZ0cvUks1b09KSGhFR0hz?=
 =?utf-8?B?S3FNQnJkdEcxR0pFWXFsRjJuckI2cVpjWEtyd0hGSmk3S0tmNHRla2ZLL2w3?=
 =?utf-8?B?emhlSU5QMG5vekFKL1ZMT0QxQXJvRkVNUTNDTEJaY2NydlViS1RUR3lBTVda?=
 =?utf-8?B?azRSSmxHcnpLT0JxZVFsRm1nd1VIYmRpSEdEVkJhQUNRN3BZaTF6RUl1c1Bl?=
 =?utf-8?B?SUtONUgrUEhLNkt0OVYxTUt6eU52TExVTlQ0N1VBMjBiaURPR2pPY3BxbG0w?=
 =?utf-8?B?TnBBNE1FUVRabnJ6dm0rbE5mYVhrOHhGZUNZd1lPcDE1M3pqUE9WYlhUOUNZ?=
 =?utf-8?B?YnQ4UGtSZWxWNWk0S3hUMVprK1BBMzhUNFYreTA3RS82c2lNM05Hc0FWU2pa?=
 =?utf-8?B?Q1lOdldPZzdJODltT2dCZjZoT0h0M3dyaTJxVEgyRjNNWkRBdTY0N3kvNFRN?=
 =?utf-8?B?R09PSnh5YTRkZ2t6Y3h3SGkwS1ozU280TysreXczSHBkRjc5a3ZnWkM3UEky?=
 =?utf-8?B?TDhMUjk3ZHEvRCtQOWlYSDMzRWVIVXhaRmhScWpVUUZ1TXNPWTdQdmE1TjdP?=
 =?utf-8?B?RURXL21VcUtXeUtXb2QzRlQ4cFZmM2tQMkVCZTlpNUxSdEppY3ZwYlVMRUQ0?=
 =?utf-8?B?M3VYNEZoak5UZXFGaWZVeUkrS0dqZnBzMk9QaFBNYlh5UHVwMDlEUHhsZktz?=
 =?utf-8?B?TDYxbXBjQmdFcnNyUXVPdHd4ZVNRSk02eDhzQklLSUxtd3hrU1VvR3htK0Vp?=
 =?utf-8?B?TEFBNDIrRnZ6OThLTWlhMTFWSnhadkIyYW5Nd244QkZOMWFVSGhFRm53NDBh?=
 =?utf-8?B?WllmK2VsTnR5NGY4S2IvYUQvNTFza1drS2FmM0liWCtwSkxUMWNqZFd0WmY5?=
 =?utf-8?B?eDc5MjJyTkJ0djcySGplOUhaWFZLanNab05yQTdiY0sxKytBUmJiMWE1TnhC?=
 =?utf-8?B?a1pTN0xuVmRnQ2ZIdFUvMDBwNVRPS2ZUbnMxWTRpbHh3LzhsenNOSUU1UVh6?=
 =?utf-8?B?R1NrWW53U2QxNytMNkxFL1UvS1hnd1dxY0NIaS8xRDY2WGh6aVpTL0RySFB0?=
 =?utf-8?B?b21VTHJwdU9OQSt2YTc2M2NxMDBlblhJWFlTa29JNVJCN2R4ZHcxMW53Qlhy?=
 =?utf-8?B?SitHVVlHRzlyNURJVnVhRjQ2VGVvbmJmZGxNMkR1elFkUHlxNFpKQ1VjNnQr?=
 =?utf-8?Q?7oNlBcGr6lF49rRS1BMtLNS0PIh/aFiMI1MkGQQDO6hBuW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4585a6fe-2e79-4635-ae1b-08da7fdd26b3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 23:15:04.1406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erH/KxFKiiM8YhuRz4PAwIWuVL/6hyVAiQOpQhRH/o1RbU1xHqFqvPvqLxcWeUApQBdxQq+HdpHDdS0lv2w/2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160084
X-Proofpoint-GUID: dFRaFkoGShiBhWWo5g-TDzn6pno0E5oO
X-Proofpoint-ORIG-GUID: dFRaFkoGShiBhWWo5g-TDzn6pno0E5oO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2022 2:08 AM, Zhu, Lingshan wrote:
>
>
> On 8/16/2022 3:58 PM, Si-Wei Liu wrote:
>>
>>
>> On 8/15/2022 6:58 PM, Zhu, Lingshan wrote:
>>>
>>>
>>> On 8/16/2022 7:32 AM, Si-Wei Liu wrote:
>>>>
>>>>
>>>> On 8/15/2022 2:26 AM, Zhu Lingshan wrote:
>>>>> Some fields of virtio-net device config space are
>>>>> conditional on the feature bits, the spec says:
>>>>>
>>>>> "The mac address field always exists
>>>>> (though is only valid if VIRTIO_NET_F_MAC is set)"
>>>>>
>>>>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ
>>>>> or VIRTIO_NET_F_RSS is set"
>>>>>
>>>>> "mtu only exists if VIRTIO_NET_F_MTU is set"
>>>>>
>>>>> so we should read MTU, MAC and MQ in the device config
>>>>> space only when these feature bits are offered.
>>>>>
>>>>> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are
>>>>> not set, the virtio device should have
>>>>> one queue pair as default value, so when userspace querying queue 
>>>>> pair numbers,
>>>>> it should return mq=1 than zero.
>>>>>
>>>>> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read
>>>>> MTU from the device config sapce.
>>>>> RFC894 <A Standard for the Transmission of IP Datagrams over 
>>>>> Ethernet Networks>
>>>>> says:"The minimum length of the data field of a packet sent over an
>>>>> Ethernet is 1500 octets, thus the maximum length of an IP datagram
>>>>> sent over an Ethernet is 1500 octets.  Implementations are encouraged
>>>>> to support full-length packets"
>>>> Noted there's a typo in the above "The *maximum* length of the data 
>>>> field of a packet sent over an Ethernet is 1500 octets ..." and the 
>>>> RFC was written 1984.
>>> the spec RFC894 says it is 1500, see <a 
>>> href="https://urldefense.com/v3/__https://www.rfc-editor.org/rfc/rfc894.txt__;!!ACWV5N9M2RV99hQ!MdgxZjw5sp5Qz-GKfwT1IWcw_L4Jo1-UekuJPFz1UrG3YuqirKz7P9ksdJFh1vB6zHJ7z8Q04fpT0-9jWXCtlWM$">https://urldefense.com/v3/__https://www.rfc-editor.org/rfc/rfc894.txt__;!!ACWV5N9M2RV99hQ!KVwfun0b1Q59Ajp6O7JrB-BuEBSLyQ9e95oGq1cVG_sQIPDL0whI5frx1EGoQFznmm67RsEeJTrUdfYrmZPRFaM$ 
>>> </a>
>>>>
>>>> Apparently that is no longer true with the introduction of Jumbo 
>>>> size frame later in the 2000s. I'm not sure what is the point of 
>>>> mention this ancient RFC. It doesn't say default MTU of any 
>>>> Ethernet NIC/switch should be 1500 in either  case.
>>> This could be a larger number for sure, we are trying to find out 
>>> the min value for Ethernet here, to support 1500 octets, MTU should 
>>> be 1500 at least, so I assume 1500 should be the default value for MTU
>>>>
>>>>>
>>>>> virtio spec says:"The virtio network device is a virtual ethernet 
>>>>> card",
>>>> Right,
>>>>> so the default MTU value should be 1500 for virtio-net.
>>>> ... but it doesn't say the default is 1500. At least, not in 
>>>> explicit way. Why it can't be 1492 or even lower? In practice, if 
>>>> the network backend has a MTU higher than 1500, there's nothing 
>>>> wrong for guest to configure default MTU more than 1500.
>>> same as above
>>>>
>>>>>
>>>>> For MAC, the spec says:"If the VIRTIO_NET_F_MAC feature bit is set,
>>>>> the configuration space mac entry indicates the “physical” address
>>>>> of the network card, otherwise the driver would typically
>>>>> generate a random local MAC address." So there is no
>>>>> default MAC address if VIRTIO_NET_F_MAC not set.
>>>>>
>>>>> This commits introduces functions vdpa_dev_net_mtu_config_fill()
>>>>> and vdpa_dev_net_mac_config_fill() to fill MTU and MAC.
>>>>> It also fixes vdpa_dev_net_mq_config_fill() to report correct
>>>>> MQ when _F_MQ is not present.
>>>>>
>>>>> These functions should check devices features than driver
>>>>> features, and struct vdpa_device is not needed as a parameter
>>>>>
>>>>> The test & userspace tool output:
>>>>>
>>>>> Feature bit VIRTIO_NET_F_MTU, VIRTIO_NET_F_RSS, VIRTIO_NET_F_MQ
>>>>> and VIRTIO_NET_F_MAC can be mask out by hardcode.
>>>>>
>>>>> However, it is challenging to "disable" the related fields
>>>>> in the HW device config space, so let's just assume the values
>>>>> are meaningless if the feature bits are not set.
>>>>>
>>>>> Before this change, when feature bits for RSS, MQ, MTU and MAC
>>>>> are not set, iproute2 output:
>>>>> $vdpa vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false mtu 
>>>>> 1500
>>>>>    negotiated_features
>>>>>
>>>>> without this commit, function vdpa_dev_net_config_fill()
>>>>> reads all config space fields unconditionally, so let's
>>>>> assume the MAC and MTU are meaningless, and it checks
>>>>> MQ with driver_features, so we don't see max_vq_pairs.
>>>>>
>>>>> After applying this commit, when feature bits for
>>>>> MQ, RSS, MAC and MTU are not set,iproute2 output:
>>>>> $vdpa dev config show vdpa0
>>>>> vdpa0: link up link_announce false max_vq_pairs 1 mtu 1500
>>>>>    negotiated_features
>>>>>
>>>>> As explained above:
>>>>> Here is no MAC, because VIRTIO_NET_F_MAC is not set,
>>>>> and there is no default value for MAC. It shows
>>>>> max_vq_paris = 1 because even without MQ feature,
>>>>> a functional virtio-net must have one queue pair.
>>>>> mtu = 1500 is the default value as ethernet
>>>>> required.
>>>>>
>>>>> This commit also add supplementary comments for
>>>>> __virtio16_to_cpu(true, xxx) operations in
>>>>> vdpa_dev_net_config_fill() and vdpa_fill_stats_rec()
>>>>>
>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>> ---
>>>>>   drivers/vdpa/vdpa.c | 60 
>>>>> +++++++++++++++++++++++++++++++++++----------
>>>>>   1 file changed, 47 insertions(+), 13 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>>> index efb55a06e961..a74660b98979 100644
>>>>> --- a/drivers/vdpa/vdpa.c
>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>> @@ -801,19 +801,44 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct 
>>>>> sk_buff *msg, struct netlink_callba
>>>>>       return msg->len;
>>>>>   }
>>>>>   -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>>>> -                       struct sk_buff *msg, u64 features,
>>>>> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 
>>>>> features,
>>>>>                          const struct virtio_net_config *config)
>>>>>   {
>>>>>       u16 val_u16;
>>>>>   -    if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>>>>> -        return 0;
>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
>>>>> +        (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>>>>> +        val_u16 = 1;
>>>>> +    else
>>>>> +        val_u16 = __virtio16_to_cpu(true, 
>>>>> config->max_virtqueue_pairs);
>>>>>   -    val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>>>>       return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, 
>>>>> val_u16);
>>>>>   }
>>>>>   +static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, 
>>>>> u64 features,
>>>>> +                    const struct virtio_net_config *config)
>>>>> +{
>>>>> +    u16 val_u16;
>>>>> +
>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
>>>>> +        val_u16 = 1500;
>>>> As said, there's no virtio spec defined value for MTU. Please leave 
>>>> this field out if feature VIRTIO_NET_F_MTU is not negotiated.
>>> same as above
>>>>> +    else
>>>>> +        val_u16 = __virtio16_to_cpu(true, config->mtu);
>>>>> +
>>>>> +    return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
>>>>> +}
>>>>> +
>>>>> +static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 
>>>>> features,
>>>>> +                    const struct virtio_net_config *config)
>>>>> +{
>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
>>>>> +        return 0;
>>>>> +    else
>>>>> +        return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
>>>>> +                sizeof(config->mac), config->mac);
>>>>> +}
>>>>> +
>>>>> +
>>>>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, 
>>>>> struct sk_buff *msg)
>>>>>   {
>>>>>       struct virtio_net_config config = {};
>>>>> @@ -822,18 +847,16 @@ static int vdpa_dev_net_config_fill(struct 
>>>>> vdpa_device *vdev, struct sk_buff *ms
>>>>>         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>   -    if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, 
>>>>> sizeof(config.mac),
>>>>> -            config.mac))
>>>>> -        return -EMSGSIZE;
>>>>> +    /*
>>>>> +     * Assume little endian for now, userspace can tweak this for
>>>>> +     * legacy guest support.
>>>> You can leave it as a TODO for kernel (vdpa core limitation), but 
>>>> AFAIK there's nothing userspace needs to do to infer the 
>>>> endianness. IMHO it's the kernel's job to provide an abstraction 
>>>> rather than rely on userspace guessing it.
>>> we have discussed it in another thread, and this comment is 
>>> suggested by MST.
>> Can you provide the context or link? It shouldn't work like this, 
>> otherwise it is breaking uABI. E.g. how will a legacy/BE supporting 
>> kernel/device be backward compatible with older vdpa tool (which has 
>> knowledge of this endianness implication/assumption from day one)?
> https://urldefense.com/v3/__https://www.spinics.net/lists/netdev/msg837114.html__;!!ACWV5N9M2RV99hQ!KVwfun0b1Q59Ajp6O7JrB-BuEBSLyQ9e95oGq1cVG_sQIPDL0whI5frx1EGoQFznmm67RsEeJTrUdfYrGq7Vwjk$ 
>
> The challenge is that the status filed is virtio16, not le16, so 
> le16_to_cpu(xxx) is wrong anyway. However we can not tell whether it 
> is a LE or BE device from struct vdpa_device, so for most cases, we 
> assume it is LE, and leave this comment.
While the fix is fine, the comment is misleading in giving readers false 
hope. This is in vdpa_dev_net_config_fill() the vdpa tool query path, 
instead of calls from the VMM dealing with vhost/virtio plumbing 
specifics. I think what's missing today in vdpa core is the detection of 
guest type (legacy, transitional, or modern) regarding endianness 
through F_VERSION_1 and legacy interface access, the latter of which 
would need some assistance from VMM for sure. However, the presence of 
information via the vdpa tool query is totally orthogonal. I don't get a 
good reason for why it has to couple with endianness. How vdpa tool 
users space is supposed to tweak it? I don't get it...

-Siwei


>
> Thanks
>>
>> -Siwei
>>
>>>>
>>>>> +     */
>>>>> +    val_u16 = __virtio16_to_cpu(true, config.status);
>>>>>         val_u16 = __virtio16_to_cpu(true, config.status);
>>>>>       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>           return -EMSGSIZE;
>>>>>   -    val_u16 = __virtio16_to_cpu(true, config.mtu);
>>>>> -    if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>> -        return -EMSGSIZE;
>>>>> -
>>>>>       features_driver = vdev->config->get_driver_features(vdev);
>>>>>       if (nla_put_u64_64bit(msg, 
>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>>>                     VDPA_ATTR_PAD))
>>>>> @@ -846,7 +869,13 @@ static int vdpa_dev_net_config_fill(struct 
>>>>> vdpa_device *vdev, struct sk_buff *ms
>>>>>                     VDPA_ATTR_PAD))
>>>>>           return -EMSGSIZE;
>>>>>   -    return vdpa_dev_net_mq_config_fill(vdev, msg, 
>>>>> features_driver, &config);
>>>>> +    if (vdpa_dev_net_mac_config_fill(msg, features_device, &config))
>>>>> +        return -EMSGSIZE;
>>>>> +
>>>>> +    if (vdpa_dev_net_mtu_config_fill(msg, features_device, &config))
>>>>> +        return -EMSGSIZE;
>>>>> +
>>>>> +    return vdpa_dev_net_mq_config_fill(msg, features_device, 
>>>>> &config);
>>>>>   }
>>>>>     static int
>>>>> @@ -914,6 +943,11 @@ static int vdpa_fill_stats_rec(struct 
>>>>> vdpa_device *vdev, struct sk_buff *msg,
>>>>>       }
>>>>>       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>   +    /*
>>>>> +     * Assume little endian for now, userspace can tweak this for
>>>>> +     * legacy guest support.
>>>>> +     */
>>>>> +
>>>> Ditto.
>>> same as above
>>>
>>> Thanks
>>>>
>>>> Thanks,
>>>> -Siwei
>>>>>       max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>>>>>       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>>>>>           return -EMSGSIZE;
>>>>
>>>
>>
>

