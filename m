Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C48A5AB7D1
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiIBRyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 13:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiIBRyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:54:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A5AA45F;
        Fri,  2 Sep 2022 10:54:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 282GCZWT024305;
        Fri, 2 Sep 2022 17:53:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7rIrqKHn4sgx0zXRFJ68htMrnY1ZfIuR+4I501kFb2M=;
 b=HDBx9RakPq3JlS1CofnSe5XZ1k4YPQ5sI0rggnl4hajEBiTpUd2lIjtGMyC0OVxnrgWo
 JERzHngOJcwlfuLbg4rVYRyxD0OdZHIDBtoCADSepCdggqU/P+HwR/rr5fiQGQHn2/iA
 4naEhAwHn1s00/SknWCIihTP8UClPJUiQ5utz1oI1u8Sx3hIhooTdc29cKtPSWwnOujh
 ip1MtqdM6vwrkjEJucL+S4WfauJiys5LFx+1M7N4t3tf3Xsvc2yXNzz12SVqeCjJx2fI
 5VMwBPMmvLSBFJfO5c10R3n0DzeHdjru2NnJygKoogJKjadW6VTbmX1jf44kFT05BbCx 5g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b5a7jcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Sep 2022 17:53:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 282FYwQZ036824;
        Fri, 2 Sep 2022 17:53:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jarpccq8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Sep 2022 17:53:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdSt1dSM90SQDoSN/UabshgahtSOQHPv5G3Qh8YAoalJYrH4dKbmNK0uzliAr8wYOioo8/ATEQIUEerrYBjeKS5ryGTCOhhq44VUaJtpGi1KtCXKT3dm1qWM1HdlFiFcH6MzbbqVjcMFf+81G3MwhYqHXItU7GSC2pNrz6/JHiYDzyIVFSJDivgCkiG7o52pyzl+UkFEtNCwX03E7nIZntLKpxQ6CBnFRwEBjtZYPv/xy5VqKh0HBQ26kPqgI4ZjpcxN0V45qQiTCN9QgeaVA504J8fq4hQkdKCH47XXOD/VOwVb4ALT47BD7XEVg9mfKDENE6/6g2Wg0otmQy3YAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rIrqKHn4sgx0zXRFJ68htMrnY1ZfIuR+4I501kFb2M=;
 b=G2gw3hNS0Ewxl/9W7tv+QIEWLNI/EyUerQhhC+G0R3Rv5x9X7ELoiSF5VjBj2Y65u+sNcFf0o1iWQ32O4mhExsNiOeufuyPZPuIfy3i31ZT14NxHqo4i1z8XNL4+WWAfVVbF831dmu4Azp6lES6J/2+ZjaiJODRW2KFzQRnZSf4m/AJbCzXyVN+O8QCD1QWb5aYSgkig2u0WmocznDEHFHxAcytpw7F9Exn7BhnJvheP2AxOy/m/spoeeXyNO5SSy5VtNLnBnwGOeSoE8HpuPbndv9kbHjvzMN99l9mgJuiYW97hv52qYtoi/pVXHh+hoJHypTI2pTM2N9+Ppm24pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rIrqKHn4sgx0zXRFJ68htMrnY1ZfIuR+4I501kFb2M=;
 b=xULuavx6NnSeQPp9kZusfHQ5+Iox4OKl+gSxMgRMTDBOMO/vMBYaErY6BPMk6HqyRXOuiIlnMxIPUichyD1oo66U9UKB2Ijl5xT0ejKXwbenyL033SBj5o5K/8NgbzNlSaCovV9jhvtrIASU1tvbLeMhFL6Q1crDCsDfZe+iElQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5329.namprd10.prod.outlook.com (2603:10b6:208:307::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 17:53:49 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189%6]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 17:53:49 +0000
Message-ID: <ab6cee88-b4a2-5e37-0741-7012ca502ee2@oracle.com>
Date:   Fri, 2 Sep 2022 18:53:43 +0100
Subject: Re: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, leonro@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
References: <20220901093853.60194-1-yishaih@nvidia.com>
 <20220901093853.60194-5-yishaih@nvidia.com>
 <20220901124742.35648bd5.alex.williamson@redhat.com>
 <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
 <20220901143625.4cbd3394.alex.williamson@redhat.com>
 <YxE9a8Kw5Vv3T/pz@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <YxE9a8Kw5Vv3T/pz@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0074.eurprd07.prod.outlook.com
 (2603:10a6:207:4::32) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86b7124a-ecbf-4355-1a17-08da8d0c173d
X-MS-TrafficTypeDiagnostic: BLAPR10MB5329:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83ps/JGohZAmSk/6SuMpYNGBBUrdAwEHG7vFmxKKnfNuMknR0urTSmbxuReW3xbKutkcljwJbC5hdJBRMWwa1YZ3bLTxvm/p6utCdE/nwdH4krSyxy70G3WSWkt0byagkIdlBf9HihbhovuOWP9PbbTkYWmysLdN4GrSC9NbuEQtn3w7lb+3tdvamLVJ/HzL235gM7RwzyzEg8lObMAl49RD+iY0Jh53T+Q2RiOPX7yoTH27qfmcFZpS0vuX66UWBtTSIBmy6YXYdVg4GbqkwW4QMyrY2APZ3BoO2gcWIQyu5uEK6zaeSIPjePWGNvZRua0VB1yaD7HFLmPcbldy2PF8AT+fR15cBYDEEmfnA2PbqhZaymTIbHBhZCzbLZvWvKRpgIVbcAOZvxJJZjAsaYdSEm0HgeV9AcTBwRQq5NvkS5H3fJNfAi8GEKU0S3q+DtSXufFxgbPm/RSOsbNjMbP1WsOxnOjjGWpJKmcOFhvoIE2Cgyl2J7JjJ1T5d1rlNeJtdR7lOEWfePfrfx+Kuje0MDc+qYaYVS/rRRraeFhTmwpBg2Nu8K59xcpbilRyjZ45fdTD3UZUUh4D85s99uHWdnSciiTA2ZVMTqlQogCsWXUnvkZhmYz3/x9ce4ZG2Am7+lngRFtzfjeJxtzWpfqgQa08VF6DqJwfs7JS66PU6U7PYK203qK+IPQSJwQfI7s+t1KTXMaOA0EOR3P8W3f7NVdsXO2bq5SrA6y4e/9XwOla6Nlv0aqnedEvKG/5zXOoWEeZF0GBCmhwKvEUmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(136003)(376002)(396003)(5660300002)(6666004)(7416002)(8676002)(4326008)(86362001)(66476007)(66556008)(66946007)(31696002)(110136005)(478600001)(41300700001)(8936002)(316002)(83380400001)(6486002)(26005)(6512007)(31686004)(2616005)(186003)(6506007)(53546011)(38100700002)(2906002)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDQwT2VXN2hFdjBOV1lLMDVtZkR3d2Q4RjcwbktrcVdZWFRaUFFBOGdtK25u?=
 =?utf-8?B?WVAzR2FDVVp0QkRaZE8rN21wajNuQ2FVUVZmTUJocjNLZEsyRTBpUkY5bDVh?=
 =?utf-8?B?SWZRVnBpdlVSYVRQSkd4QXNvK0dTUjNWWkRrOXZNSTlXd1htWmFzczNuQ2RF?=
 =?utf-8?B?OTB4K0dDT3hRZHNTL3JYY3dEQW9DZm84d1BxYis1eDAwVG9EMnR5cWpWeVY3?=
 =?utf-8?B?U0lVWnRINm95RDFRVjh5KzN4ek4yek04TVhhZzhPUyszVEhnWXlkTGxJVjFt?=
 =?utf-8?B?MDFIK2NwbVpFL1QwVWRZTGhwYi8xMkJQLzVRK3I2VWg5NGtwNWxlcFJ0bnBa?=
 =?utf-8?B?QmVzblZrdW50M3dITXZvN2ZIdUViMjBzeEtCcXljQXZpdTNaNjB1SzFuRnBO?=
 =?utf-8?B?ZWREY1ArcE5Xd2ppNlVwNGFyZFV1SmVJWXdPdzJYSjNRZ0hPRmJXT1lmQmV5?=
 =?utf-8?B?RkNvdnUrR1JsUlFmNEw1aElrU1VrSTU4SHpzcnlDeDZLOXFLelp1SDJSYmVD?=
 =?utf-8?B?dXM3L3ZVQmVydWw2S01DaGtRZXgyRElZTUZIVGUyTzl3SjVoRWFjUVFOQUk0?=
 =?utf-8?B?VVBodVdBMlJwR2xzY2JTTlVMSVBvL08vb0tHcVdSeEptbkxyQkU5SWxTZExt?=
 =?utf-8?B?aStTaXdVWUJ5UmxZWlVwek1sa0RHdVpMbThSaTVYVktZaWljYlNwdFBYWEtp?=
 =?utf-8?B?ZEx5bVJsVWlZb2RKSEVqZEc5NDZTYWhHLzdQZWUvYXBSMmNuQ284bW5OTmFw?=
 =?utf-8?B?azJXK2VYOThVTjJiWGVGZEtRRE96bTE5bjVCUEp5NEFoaExQN3piaUwvMFp0?=
 =?utf-8?B?bSs5aWcyY0hNdE9iSXZnOEQ1akhiQkVnLytjZnBxM0JyRENUb01vYmNTZ04z?=
 =?utf-8?B?ekJZbGRHTG90SG9GKzFJSTFQd2J6Nkgvajd0bGlUK29yMTlrN0pGbVhIZ2c2?=
 =?utf-8?B?ZlZURmFGeGhhK3B3MjhOS0E0VDhtcGhkRlBCb3BlRGNyQndydkwxU3JkMzJF?=
 =?utf-8?B?Rlp3a0xJMU1MY2ZXbWRma1lzSzZGSVdWL0hTaG5aU0x1am5Mc09ueUZ5Q01K?=
 =?utf-8?B?bGdSZm1Jb0lla21sSGdRWG1mdjV2eGxVK1JtUEVyMUdSd2tTc2dHdm5sU3JW?=
 =?utf-8?B?aFNhQXJXMjJFa0ZDUkRGTllIbUd3RnFiSlI1NDROdmVVb1AwMVF6NnVOTFBQ?=
 =?utf-8?B?a1NvVEMxcWhLQWk2aE9nTnIrcnRsdkorVHA5c1ljbVpSc0NLckRSSnVpWU42?=
 =?utf-8?B?czJndE5YbXJWQU9maUR0MFIxSnArR2JTc1VpMzY1dnNpc3RvajNzRmoxYld1?=
 =?utf-8?B?ODNCSW1hMG1vUzY3ZGpyTGttT0hlQlhDRWpsb05LMVNVU3hXRmVpaVFzVlNy?=
 =?utf-8?B?bEUxcWdoVDNkR3MvRlRVbEdHSXlnTVZYWlpZUDRVeGVld01tZUNrU3ljSWl4?=
 =?utf-8?B?QU9LbmoxdVpZQUxNazMyLzFSeTQxbEJUOHMrWXNiSGpLTzVDdWVMdWQrOE0x?=
 =?utf-8?B?ZVBLaHhUYVdHSWtHU09KeVV3M0E0emVlZmRvNnY4SDNOaUlXTW5XRkY0Q2ZG?=
 =?utf-8?B?d1ZVTzBTVzVlOWlzWGpUalZKZW5jVndYdE9oNS90aERReTdKMDVuZ0JXY0Vo?=
 =?utf-8?B?cS82Zm4zd05hUUlaa0RpYVFsM3RWVmVpTWtGbEVSZE1xMjNrVUNmL1VXTWdR?=
 =?utf-8?B?MnhOT3pURHlaOGZtYXA1VzlMYTJmWkV1Nlc2bkNoUEY0UHBobm0rcEwxQlUv?=
 =?utf-8?B?QjZqQmhJcW95OEtmTi9UekxrOVhTaDRJZHZ5Y24yWU1QUUllaldpaGFoUmQy?=
 =?utf-8?B?OERnMWdLeVYyTUYrOHc5SXR4R3BoYk9IWmo2NmdBYnAwdExOb3NxOGg4MnVX?=
 =?utf-8?B?VFQ1RTR0ZU1FOTJidHcwNjVpRWl3QjhReWZnZkpZMXl0T0VyTTh2ZGFPT1Zr?=
 =?utf-8?B?M05YZXNVbGFFYzhjZ2FNblk4VXBLSGJLU1E1ekk2VUtSWnpycWlzVTBmRTEw?=
 =?utf-8?B?eUd3aWRTbDRMN3pCUHEyeHlOZEZxdWhzMkVXd1ZaaWgreUo5Vlg5Vm54K2dI?=
 =?utf-8?B?ODJicFVBdGFqejMxYXNya2lMeEErRmxqQ0FqL0swV21wek9mRXkvSG1NUmhV?=
 =?utf-8?B?bTMxRTlxM3IwMUxQaCtjbG5wUUFMYlRlMUVkYVp6TldvUlRjNE94eXQyczZQ?=
 =?utf-8?B?TlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b7124a-ecbf-4355-1a17-08da8d0c173d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 17:53:49.7225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aaQrncjwH/Rbwi3o4pMDYxalxKBFIQZ0hZVPS6g4Nnn6H48Q/TNOf2zZRdqcNr93aqO1X8jJ0/cX6lSymjMxMrWrp331KvdLWlLKmfOES58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5329
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_04,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209020082
X-Proofpoint-ORIG-GUID: Qwy_OBW-v9ApmwraomLWq1SlcCNhSW5_
X-Proofpoint-GUID: Qwy_OBW-v9ApmwraomLWq1SlcCNhSW5_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/09/2022 00:16, Jason Gunthorpe wrote:
> On Thu, Sep 01, 2022 at 02:36:25PM -0600, Alex Williamson wrote:
> 
>>> Much of the bitmap helpers don't check that the offset is within the range
>>> of the passed ulong array. So I followed the same thinking and the
>>> caller is /provided/ with the range that the IOVA bitmap covers. The intention
>>> was minimizing the number of operations given that this function sits on the
>>> hot path. I can add this extra check.
>>
>> Maybe Jason can quote a standard here, audit the callers vs sanitize
>> the input.  It'd certainly be fair even if the test were a BUG_ON since
>> it violates the defined calling conventions and we're not taking
>> arbitrary input, but it could also pretty easily and quietly go into
>> the weeds if we do nothing.  Thanks,
> 
> Nope, no consensus I know of
> 
> But generally people avoid sanity checks on hot paths
>

OK I'm not stagging the check for now, unless folks think I really should.
__bitmap_set() is skipping it much like iova_bitmap_set().

The caller can sanity check and has the necessary info for that,
as the iterator knows the exact range the mapped bitmap covers.

The diff that I just tested is below anyhow, if I am advised against not
having such check.

> Linus will reject your merge request if you put a BUG_ON :)
> 
> Turn on a check if kasn is on or something if you think it is really
> important?

I am not sure about CONFIG_KASAN/kasan_enabled(), as I wouldn't be using any of
the kasan helpers but still it is sort of sanitizing future memory accesses, but
no other ideas aside from DEBUG_KERNEL.

FWIW, it would look sort of like this (in addition to all other comments I got
here in v5). Caching iova_bitmap_mapped_length() into bitmap::mapped->length
would make it a bit cheaper/cleaner, should we go this route.

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index fd0f8f0482f7..6aba02f03316 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -406,13 +406,21 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
 void iova_bitmap_set(struct iova_bitmap *bitmap,
                     unsigned long iova, size_t length)
 {
+       unsigned long page_offset, page_idx, offset, nbits;
        struct iova_bitmap_map *mapped = &bitmap->mapped;
-       unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;
-       unsigned long nbits = max(1UL, length >> mapped->pgshift);
-       unsigned long page_idx = offset / BITS_PER_PAGE;
-       unsigned long page_offset = mapped->pgoff;
        void *kaddr;
+#ifdef CONFIG_KASAN
+       unsigned long mapped_length = iova_bitmap_mapped_length(bitmap);

+       if (unlikely(WARN_ON_ONCE(iova < mapped->iova ||
+                       iova + length - 1 > mapped->iova + mapped_length - 1)))
+               return;
+#endif
+
+       offset = (iova - mapped->iova) >> mapped->pgshift;
+       nbits = max(1UL, length >> mapped->pgshift);
+       page_idx = offset / BITS_PER_PAGE;
+       page_offset = mapped->pgoff;
        offset = offset % BITS_PER_PAGE;

        do {
