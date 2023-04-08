Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA846DBC5F
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 19:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjDHRm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 13:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHRm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 13:42:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB52AF12;
        Sat,  8 Apr 2023 10:42:56 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 338GS6I4029784;
        Sat, 8 Apr 2023 17:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=sdpJEoiATGiQqMKJtih2bXfT34ielY46VKCc6F8M5Bc=;
 b=gcKD1A4gVQ8yW+ikj6Hcqq9INWT8HY9sVLxxGKmi2cIslyWBRq8G8ExKEfLmyJlfp0D/
 j+Hcmr/FygNWrvDXRudG0u7ry2TFxeSlm+q+hwQjl2888qCz1Xfd49971BmLsgqz1Zle
 4K+KiLFP/Eax7wcckTf0JtSCaPqH/MZTvasBnaeOwugwTRqmynGWOwm4rGHn83uJSAhA
 1/EKzLCAaFtVDBPLytYSGbP0ugG9MlCcalq7UdGlPlcT8BZKymFEHmCs2ztp6xZjyYEQ
 gdGnvA4KJk0gy3v3/0c+vcvT1OesuXE3Mv63No1ha+KfBgPBGf7RbPaz9YBosFwgMIgj Ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bw8mp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 17:42:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 338HUsS9021180;
        Sat, 8 Apr 2023 17:42:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ptxq2kc1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 17:42:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7egoQs146ngtubYTiSqIWiANlIyqmhfnsg970vmhvw6eCYkQLLZVfZ/Rj9HjuVUCHfX4SeoZZHFoGEMVT68tBtNJi5jYGUkdfNNK9H7KYXBpKEZhUDxJJbl7Txw/IThAYnQhQNv8eWztrLzLn/O1ukDxiinolU/fB9s2Y1BT/R00QCya5DZq91Lo8Y3BUBJu/HbqvdY2hag+e+7roOeZO0dB5S4T1hilpM14JyMMFjh62wMgoF7U0GYuOJNDz+w2ol6W+CqNCrNxyz0Gxf2dQq/iXswHHVUVHOGwKgFhvJEL61cmSnlynxMwwSVzBFiyVpKdZvj4AAFKXYwIk1Dvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdpJEoiATGiQqMKJtih2bXfT34ielY46VKCc6F8M5Bc=;
 b=i3SE0Dxi4OK1N4rDZwR2uN2D4iuFJj2dxsI0um5RMyTVkSM1ymSkY2M3N7DYrwezNGt79oeidLutLkIF2wB2hczsdXiHndYEyA9e9cGeJYPx7yDb/b/CGqhaQbS5qB8efn4lFNxdh4amzjayuRGN5hS2vFvCmdjziKybsHLObDQqKcCuB1VhUFD219eA3ZxBnS/hWdwq8HdKcwnYPvh/obd2Vk7wvXVw1uKCFcFw/pgemiRxmOO3PNn0ZVAFzt7N8kfHEV8RmaPRA1XgEpIvKyhfoalCnCY1ghjjNFatiUmUc/+Y48Wq9zxzJETo0Q322TT6Uw0H0I+nVtw+B7/tyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdpJEoiATGiQqMKJtih2bXfT34ielY46VKCc6F8M5Bc=;
 b=ajSlu5G3V/fyWNWJMVuEoyFOilDl+6f5laB77CJ/2hYJMXVA/X8DO5ZY76rcJ/mEngzUl4G9+FMDPa9sfmjy117WEM10oqlmqpiINApHRX7gfJkqqYBSMOkh27j+WmNqYD1O78lxppAYyfD9317ZFGbom1+9OkjC3V6fo5n2ijM=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB5770.namprd10.prod.outlook.com (2603:10b6:510:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Sat, 8 Apr
 2023 17:42:37 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00%8]) with mapi id 15.20.6254.033; Sat, 8 Apr 2023
 17:42:37 +0000
Message-ID: <8f47aa3a-9b71-6788-6d75-ccd96dcdb419@oracle.com>
Date:   Sat, 8 Apr 2023 23:12:25 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net] net: wwan: iosm: Fix error handling path in
 ipc_pcie_probe()
To:     Simon Horman <simon.horman@corigine.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        error27@gmail.com, kernel-janitors@vger.kernel.org,
        vegard.nossum@oracle.com
References: <20230408065607.1633970-1-harshit.m.mogalapalli@oracle.com>
 <ZDGJI8Q6lWCJdEMR@corigine.com>
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <ZDGJI8Q6lWCJdEMR@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0207.apcprd04.prod.outlook.com
 (2603:1096:4:187::9) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB5770:EE_
X-MS-Office365-Filtering-Correlation-Id: 469e0cef-afd0-471f-563e-08db3858a417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvdi4At8RvwJk9m8y8ACaLW1xhCtqsDdPwqAzUrIxUmmp+vyVIuPgGAIPOvVcr08zTclCjf3ZDQnBQuj2orVXsS7DSWFpkXxawtKvG/IzLe63UCyj1XRX0bMbYSaNTPANPHkApzx4h/b5yysT4ELf9XIGwFiemYHjj4cXP4pFHQ6eVJ1qmPTXx9wDAK0j2IQeC5Xg1tabeXDg0EL9pBl6Pr6x43KTXTKYwPO7rc7Kb4gipEpCnfQoMfJnPRqPs2HDf5e6z9/qrfR87mjrq/oiOrxyAjm32uIGelyXVoBuqKMXdEZKfRkIvbQUZvHOsudjYXspdwRUpsNiqQ5xxqpB2dBkJpX4k97PoPG2pw5I7fdOdaO2392dT/GU/PCBLx6YXTeVVhb3tzOOF4y1kaLza62uL+vLqtx7OZFKRpHX9vKyBTXoPVmXrINajaF3ajhmZ4eTWOwaRNeVqowgv1esvC0xbht9MvTrfF3rnAg27aradOf959Glrq//L5Ug91CRXjqVhBg+BoUd0x+tmkOzlhb2emXeYmn35Xgh7IkbCvKRyB43Sjkmp7FkxZXLrnIINP3bU5BzY9eOStVQ+EvMgiXReaHg9TI0aEkOSD+SV/OAfOvhgibl/pvX2WiXTAMW5tv4WinbudstJleWuEDaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199021)(31686004)(478600001)(6486002)(6916009)(4326008)(66476007)(41300700001)(66946007)(66556008)(316002)(6666004)(36756003)(31696002)(86362001)(2616005)(6506007)(107886003)(26005)(6512007)(83380400001)(2906002)(8676002)(7416002)(5660300002)(53546011)(186003)(8936002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjFIcHIvK2hNZ0xSTnBvdTFCWExud2ZJVkhhYzFRa2ErR3lxdVRUTG1iV0tD?=
 =?utf-8?B?QlVTRktsMlE4c0t1bmRkOW9PaGNxVVBSalNrSFcwN1lFeTlsR1dFK0E1WXA5?=
 =?utf-8?B?WGI1SGxKeTR0cC9hVDlvRGVaSlNGRGY1bGJzVm9wTFVmUEZBNmVUN1B5ZzAy?=
 =?utf-8?B?aitCamt3eFBGUCtFek81Z3cxL09TTExEOVFPYk5MUFUzQmJ3ZTQzQmgwbjBx?=
 =?utf-8?B?Yi9Bd0VxSHB0RHg0THV6eGNrZUNmWUwwZFFObFZvWFVnY0JmVGxRSkFkRTV3?=
 =?utf-8?B?ZUtzRWFQZStkRUhQWTdaTkd3UmxnSHJFeHZ2KytiQmVMYS9keTliYW1jbk85?=
 =?utf-8?B?SmJ1S3pKdzQ5Vmlwd1EyekNZbUk4VWNJcHRCaXIxM3FtV0o0c29obWE0VHFO?=
 =?utf-8?B?VGdhdnF5dmF4YTg2Y3I3Y2haMit1ekp2VzJGc1JOeG5SS1R2emJhNHdYUHhi?=
 =?utf-8?B?MU1jdmxBMm9PT3pBQTY5dUl1WGg5TFIySHgxUWtpLzVSZWlzSXRxSUIzQzVq?=
 =?utf-8?B?VGZsalZvTXV5TlRocy9YNi9xOWk3SlY4U29nczd0VHM5K21rVEQ4dDUvVGdx?=
 =?utf-8?B?V3F2M3hOdnQ0RU4vT245Qys1czR1UXhOZjVsTnpkLzRweGhYRThDdFhtSXUx?=
 =?utf-8?B?SExSdGk3YmUwc0p1SWZLMEQ5YndkbVlveDhEdVBuS2RscDdxZ1N1MEUzaE82?=
 =?utf-8?B?aVMyQldLc2kvdGp3U2ZVN25zRjI4TmI4WW9icmZGM0N6dWFvSjhpeXluK2tY?=
 =?utf-8?B?aGJYTy8zeExMOTRvdW9QSmw3R0FaSVlaaHFDVDVDSS85U2xTVVJTYzFJQ2d0?=
 =?utf-8?B?aitic3l5cEh2SUF4NHRSK2FjdXJkY1ZYYjdLelIvM0NkOFB1akpkYk9VT3g5?=
 =?utf-8?B?eFhuMGEvRWpIaEdCZXFwa1N0MzJyd2xpblhsVW95L1d0VFBEdEFoS3JxdWxX?=
 =?utf-8?B?QWg5Z1h1Tk8zSnBGckM0V01NWlRDcS9uZmNncGZ4Sk9vQU1NaDR0b1kxN0Rq?=
 =?utf-8?B?THV2UGNvRmp6TWpsd2RNMVZzU1p2WHZNQnBjd0tzY001NVFPL2tNMGoyb01I?=
 =?utf-8?B?TzlvYkVJa1FqRWRxZ0w1Z3o4Z09tMnMzU2IzUzNCSmdYVUhncy9FUHdtNjRH?=
 =?utf-8?B?VkpnbGhjdDkycytHSy9HSTZsR3BLcm56S3RKWENSRVRwR3RKcTU2bjRxWFFU?=
 =?utf-8?B?Q3VKS09oNHBrQ0VuU1ZEWHJ2dTY5b2wzOXJ6QTRyaWpXSDI4Q2xLRnFxeDJk?=
 =?utf-8?B?RnZqUzNwck5QMy9JVC9zRHhIWUQ3T3pMOG9rT0JyUFlsSXdqMnhBK2VpLzBF?=
 =?utf-8?B?R2xYVDJnVDQwZGdzWkNQVW9OV2tzUllEWEJLbHFUeERXTXY4WW5nZG9pWEc4?=
 =?utf-8?B?OU1TbjFKM1laWkxySEgvTVU4aE54V20xL2FWRURNMVprbitteDdBZVFvTmk5?=
 =?utf-8?B?NUNqell4VTF1MStTaG8velJnMnhFT1UzZGtQYWRXSEI3TlpEWi9namRWalJl?=
 =?utf-8?B?MjFaWmIzRmR4UFJvNkVnZ05QS3NSMGVERndOSDFHRjA2eTRGblgwWWgvV3lj?=
 =?utf-8?B?Z1ZSQlduUm85RXBPeE8rcGNHajhucElXaThYVmpqMXJtOW94aiswL0hrM2NB?=
 =?utf-8?B?Q0ZNM0J0SVJodjc1TDdTSXRlZG80UXJWSTFOWmt6NzBVd1hZNmVLYVNFVHhZ?=
 =?utf-8?B?TnJ4YXp1U3ZPV3NISWpNV2l0WDE3OTlUSC9YQjQ4cEpwUVVDZmEvOWVwSHhJ?=
 =?utf-8?B?aWw0dHI3UmQzWEIwK1BNc214N2Q4VHk1aW81cWJLbmRiTDZRUks1bFNEUDNF?=
 =?utf-8?B?RGpSVFdOaTkzZDdueGI5dnNKaHpGNkR0LzZITXIwZW5rYndyMjVtUk1HQTBI?=
 =?utf-8?B?M2pqaldJSnVzVWdjWDBFRmtjZHc5MFdrdm9JUzFpS1ZhYURlR3k1RHNzZFdj?=
 =?utf-8?B?WjA5SjlDdHJoZ29qaE9zd3JkVnZRQ0Q1VnM1ZC9rbkRGNWp1SDZWckVPRVNt?=
 =?utf-8?B?cTVQY3pMWjAxWHBpUEkyVkFNSXN5cDI0Q1o1NkV0VGQ1NlVBRlhzdElpUmNq?=
 =?utf-8?B?V0U5dFEreGROZTUyS2FUVTc1RERkLzNncHFEU3d1OGhJOThQL21MUG5iVjhX?=
 =?utf-8?B?YjlYYzRVckRRK25nNkdFUEJjUXlYSDlwK2JWYlF6OUNGeU41ZGErRm5kZlRE?=
 =?utf-8?Q?f40ZcfNF/jjlKSuGmv1+eCI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NUZwQWFtTjNQVGF0WUhNMnlPK1VtTUVpSXVmRUlTRGJmRHRaa3lZcDVuTkdB?=
 =?utf-8?B?K1BwR05id3ZLSTR5M0ZGYldpUWxieGtHNUdKakd0UDl4Szh1djdpdE5tTnAr?=
 =?utf-8?B?aUhmWGNTUWpVMk96d3RxcVZCR0dtM2t4M20zUlZXb3BySFhzeENqTEg2S2sx?=
 =?utf-8?B?RVdpcklxUkE4MjVQalBUcnRMSlVYUHM1cTB3elFlaUVCR3c2U2cxWStNU1Ju?=
 =?utf-8?B?cGhTUUhZdHVZbmUycExQQ1VsVXRtWkdRYmsvbm0vQzY2VVhLNXliWkViUExE?=
 =?utf-8?B?ZGJFakNOSUxnT0JQb1F4eXZyUzltWExzM0EzQzBGWVc2ejRLSGErNUxLSUlJ?=
 =?utf-8?B?UHdybS8vcHNZLzRhM2YrQjJMRDhIZXhJS1pkNDNKR2lreFB3QU5sUUFaZlU5?=
 =?utf-8?B?SklIMzFqOTJZR3gxWHZ1MW5yMXFCQUt5MlRhdGxJa3RteHI2dFJpbG1uTlJj?=
 =?utf-8?B?UUZ2eng1cWlnbnhvdFdVQTN3dnVNZll5V2EzNXF1QVBWbWQ5QmFLbEFFM3kv?=
 =?utf-8?B?ZG03T0Q3TWdrSUxNT3VZWDZET085NENsMkp2SEs5QnVibTJkaUY5UDVkWmNv?=
 =?utf-8?B?NkZ6NVVaamFyaWNNSnl1NVA2eVlWZjFlOFQ0ajV5L3NrOEJkd1dGOEJTbjVm?=
 =?utf-8?B?YU5tRU5kVHd4Ymx1VFkrckU5UndvZjM5MEJCbCsza3Vtb0JwUzZ0RGxCNEFa?=
 =?utf-8?B?Y04xbW01TS9hcG9jTklrdHZjZVVPR3A0SlJabkZGenkrWFN2SEhnVDZneWRZ?=
 =?utf-8?B?MHBYOVZOUUF3NEN1Lzc5NjQ5S2MvdllqRTVOaDlmM1plaFBKdHM2Wlpza0U3?=
 =?utf-8?B?ckloY0dyZm5aMGtkZlVETG5ZY0s0MFVEcnBaR3ZkT3hGanNmWFQ4T1BRYnBZ?=
 =?utf-8?B?NUNTalEyK0V6cWtPNmxXN3JCdUZmbExRY3FYOVhKNnp3azQ2ZXJicm8wNDdJ?=
 =?utf-8?B?WisvU1pFT2J6Qmxab1dkOFI2cktjdEdqZzdNUllyNTdJalJiL281dlpQTjBo?=
 =?utf-8?B?cW56UGMzaWg1dUN2c2pLWmgxRlFSMGxBVHNEN1JmWGNaUjZaOUcxcVp5VHhw?=
 =?utf-8?B?TDNJQUo1LzhaKyt3RC9TNkxlMm5Jd3pZMjl6djUremFpV1d3YXFWaHJyWE9S?=
 =?utf-8?B?Wi91UHFpTURlTmYrdWJSWEkxS2krZzBvT0dyenFIcTJnWCtpWEt1Z2FLY2xL?=
 =?utf-8?B?V2p2VENxcmJQNURKUFVRbkdhamtZR3NHQzcyNnZpZmRtbWtFVTJ2VVpZWjVW?=
 =?utf-8?B?WTBYbUxib3ZuRmdqOHM2VVpZMVVYUGc0bFZXbWExNVkwVEo3Y2ZDOTRnQjJn?=
 =?utf-8?B?OVF1L2RCeGw2YmRvaWpVL3EzbVMrbFlMR040SHZqQStoTTVmbTZmVHJxSjJT?=
 =?utf-8?Q?huW0NwTTW75G9czTsRpUjGeOI9tNV+r8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469e0cef-afd0-471f-563e-08db3858a417
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 17:42:36.8915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snD0cTiQ9s/0ir9qWNSzzbEd0ej7gDxjfO23LNUUdzGLJQyvnqGTLBegIEmL/HxkWwBYL9ChsOvkKehnveSqVZG8UmM6njxriO6S5cTStEMlrDOaDdG+1zQxDyceOUAk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-08_08,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304080159
X-Proofpoint-ORIG-GUID: SF_o_kFk2kSCPCCSN5W0EsLmYlcZ-L4P
X-Proofpoint-GUID: SF_o_kFk2kSCPCCSN5W0EsLmYlcZ-L4P
X-Spam-Status: No, score=-1.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On 08/04/23 9:02 pm, Simon Horman wrote:
> On Fri, Apr 07, 2023 at 11:56:07PM -0700, Harshit Mogalapalli wrote:
>> Smatch reports:
>> 	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
>> 	warn: missing unwind goto?
>>
>> When dma_set_mask fails it directly returns without disabling pci
>> device and freeing ipc_pcie. Fix this my calling a correct goto label
>>
>> As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
>> it finally returns -EIO.
>>
>> Renamed the goto label as name of the label before this patch is not
>> relevant after this patch.
> 
> nit: I agree that it's nice to name the labels after what they unwind,
> rather than where they are called from. But now both schemes
> are used in this function.

Thanks a lot for the review.
I agree that the naming of the label is inconsistent, should we do 
something like below?

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c 
b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 5bf5a93937c9..04517bd3325a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
         ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
         if (ret) {
                 dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: 
%d", ret);
-               return ret;
+               goto set_mask_fail;
         }

         ipc_pcie_config_aspm(ipc_pcie);
@@ -323,6 +323,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
  imem_init_fail:
         ipc_pcie_resources_release(ipc_pcie);
  resources_req_fail:
+set_mask_fail:
         pci_disable_device(pci);
  pci_enable_fail:
         kfree(ipc_pcie);



-- but resources_req_fail: has nothing in its block particularly.

Thanks,
Harshit

>>
>> Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled")
>> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>> ---
>> This is based on static analysis, only compile tested.
> 
> I agree with your analysis.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
