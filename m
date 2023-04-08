Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28586DBCD2
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 21:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjDHTr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 15:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHTrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 15:47:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF8519B7;
        Sat,  8 Apr 2023 12:47:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 338IwQK5022411;
        Sat, 8 Apr 2023 19:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=A1g9sX6QPFvom+4UP0jSLiIcqRtVbpRO5Ld9aMsMAPc=;
 b=SOW+gO45EP7/4Us2g+a34VOI44yL910w9eAxIdLrI9X/LSta0XCRS/vC6yXptQ/JIKH0
 3zgVIaBG4FreO3RNC+3+RQkMVTwgBffmkznoJbh1a7VuhHTjfq2FyVJDOYrQ6rgQ9Vzl
 hCWf6qHtgTqjjEIZCHRIsRcCokMfiUcRmwzPmGswnPqk0AHz+jy08x0w7Z4FLSVuF/Jm
 sQF5HQK1Wg5s4h5c4AKvpGl29shMiJ33NtUFfAZ4idbtmn6uoYG4kW1G6tIxsISAgdPI
 UUfmYqHt6i2d6jIcR2TqcharcKnZUjpqafz0a9PCyGD0gwvHN4OOKKDE63U+7/XI8M4l 5g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq0peq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 19:47:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 338ISUef010748;
        Sat, 8 Apr 2023 19:47:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ptxq2edbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 19:47:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=istATO59UPdSMqodLbGhTzabqwhZCPvaDUUJ7bCCvkiSvkNOl9L5BlEfs/kXCfbCUVbGW/8WqK5wW4C9mrOpLLAhwmcFFB/BWxo4quBDfBU5QkDXsWsa57n0eMxzBsoy8Mf3Hg4y+nr+IMIYQ04C8/+bndM94JPuiEDa0kfXTGfVs5lyY0TakcTlDQ1Py7VKhNolS4zLIkZepvwaNNRRRpWre/L2EwRHlM+SYUYSmkXryf9NSBGLqQwkOOEuurdEy5DBtmBol/XTOtY3yS3ORxL9lTFI7J5OcYuHgXF5ZXGVs9gJxkMbxV8R11M7BQQTgIB9iQUNSV5Wp5dW0dIWWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1g9sX6QPFvom+4UP0jSLiIcqRtVbpRO5Ld9aMsMAPc=;
 b=ZaZTR/wI5gqeOAGk/bClXhPGXJOsrmhfBZXMZAjCLFtu1XtsAVdfKul7P5WDqgj9w2A4V4GgdNQYK+sgFMUmiELfyyRjNYnhJFO3U1v4bpnTiSqlObQFpRep/FxLGQXFPNl+6R1K54dgBTQmz/SOihHPq7uHG9H7zNBHKuJj9b1xfQMN7qKIzV8e4e/Qw3miKq4CR72sMmXC4bHrZVK50N6RjTkb7Uzh8hoVcq4ED6iNNq5X7XzXzIFCP6igxEhfl8ldb61oGW/1hfwjFhRIuTFP3joz4DTfZRFBtf1N2R/AQnKi3ePWfgLIJB6h421ARcz1eKK7oObBERUbz3sypA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1g9sX6QPFvom+4UP0jSLiIcqRtVbpRO5Ld9aMsMAPc=;
 b=qlih3bLKWkNdTnPkCBlBJH57RMgNUi67LjBKHurAB1tRyD4S2o/jGbEprwUS++cHah15fAfx4ttDFBB3xcFE46tM5+Kw3oSDu3591F63/DmjFTNMtv570mjAZNwsyNDP4zadTThI9QlZ1B8ZJkvbAZgu82N8iy0kJypEmuIj8+A=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DS7PR10MB5056.namprd10.prod.outlook.com (2603:10b6:5:3aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 19:47:03 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00%8]) with mapi id 15.20.6254.033; Sat, 8 Apr 2023
 19:47:03 +0000
Message-ID: <20fc5043-71a0-0401-fbda-ade0a8192c04@oracle.com>
Date:   Sun, 9 Apr 2023 01:16:49 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net] net: wwan: iosm: Fix error handling path in
 ipc_pcie_probe()
Content-Language: en-US
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
 <8f47aa3a-9b71-6788-6d75-ccd96dcdb419@oracle.com>
 <ZDHA0uTelrk1BDb7@corigine.com>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <ZDHA0uTelrk1BDb7@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::6) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DS7PR10MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: 01d199bd-619a-47c6-46ef-08db386a0664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GKO8RmnQiImyus5o38bA/zTypjcvbMcn9fVlYt/nVCxftuRCUyKuJ0foh2Vs/bLjPkX2VnR3szq8ATCa7y3b6PzvlBUhWc5dH6P0JBN2WUN0ZbYy2yLqtchjXRLlABnZwQCA1B8XdpvtLll0paH0x2Ye+43hJUeEQGZbK7NGO5HPDWoMUcFe6EE/cB6yfQPt7mPYl5D1DOs5rw4AKD/sQbcZBVg8wj+SlqQPbOBcsRqs6Wt9pgC+cD1F7wQookbWBWKF7j7S8wjweVtMjWF/g2rZ+QhylBXXF0egRD4quNQBfs6MnnmxORwFpT67DDY486ze+TLhBAK8OUin2yMnHaztGFiddfvDwiksul6v7dgBllfI8rXKMDIWqZK9Y4d5QEBfeFhggT7hra7jIi4jME8ofqmmzxiuULctr1A7seXBt9cmOAzRjDHgqU3u+1Zg8gvh7SffVev1JrNfRIYwhV/xn4o1OOYlvLBw0OodjVPieKYtz8yIoucFKsxF5AWt6mSYz6cRQPyAh0zB1fOnWjFgZHu15nPJW0+xOjVAgO6GBEHBYe45bKfAGo2mD1WcBRJp1bMvwahixOIk92Cn/5lubZh3/Gw0FWI8XdnYonXhM5gBqSvVIj8UJgLd5fLkYMjTNTKhcYkVfyd91wEEPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199021)(31686004)(478600001)(86362001)(31696002)(83380400001)(36756003)(38100700002)(2616005)(107886003)(6666004)(6486002)(2906002)(316002)(186003)(53546011)(6512007)(6506007)(26005)(7416002)(66476007)(8676002)(6916009)(41300700001)(8936002)(5660300002)(66556008)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2d6aDBocXdaQ21UM3RRbG9uVlFmemZCVlNrMVpQa2hkWVRNcXN4WEJ2UWtm?=
 =?utf-8?B?Z09DSUlYVFRIS0I3M0xpMVNvdS9PY2tPU0J2bXpQd1l2Y1NZOXpWMlgxZHEv?=
 =?utf-8?B?WGpOV2xNY1A4SEh5aG04ZWdCZTNPWkZFeWFvUXNvN21odlc2cFhJVU5wRGxk?=
 =?utf-8?B?VFpmUEVxWXNSSzZpOXpwZmFFSGJJQUJHUHc5NXdpcFNpWlhsSVY4Z0l5d1Vu?=
 =?utf-8?B?VzFRSGVFYUlxbitJVVM3cVd1OHJuK0h0NmN6SFR1SVJ0dElJSE83K3N4QTNj?=
 =?utf-8?B?LzBHQzA1ck8zbFk5SVN5dy9VV1RvRkRQQW1pU1BRV2taOEQ2TWpCc2l4N3ZM?=
 =?utf-8?B?azcyRUlWcEtERXExQnlRZk9pYkk3aGNQRlVOQWxGbjNRYWNST242cEsvb2dx?=
 =?utf-8?B?U1B0VjdSOTNac2h1VVJUNmxuR0duZkxYektpQjBYYVVVLy9xQTZlL29rUTZG?=
 =?utf-8?B?Z1VNVWJvUHFGZFgyWjBJejNlRHBFb3BSK3BnVTVKWHMrQmdQOFlhMURhQUI5?=
 =?utf-8?B?ZUQ1WE5yYzhHTVBFUTYrdGdHTHMySExLOFpXZDMxK294WDFKSjVGUlg2cWhK?=
 =?utf-8?B?SGE0KzRvS1hkOE0weklBUVlzTjR0YmthUm1HYWdhc0djVVpCdjg4N0xxYXFS?=
 =?utf-8?B?M1g0MzJGVTNHd1ZKTXJzL1ZGNTBYZFpDSGpaOTZRb1NUKytxZnUwQmRTdHNZ?=
 =?utf-8?B?QWxCdERkakNyZ0tycWdOVGlhZHBEaTVJUTFBVUkrWWJhWlE1MlR5aHpXNEY3?=
 =?utf-8?B?SGpQbDFiUXFDckZjY3h6TzdXb2xFV2c0VVVFUmRYQ1dMbHNUMTc3YzY3Q0ph?=
 =?utf-8?B?cW56bGxWYWdMamlOeXdUOVFQTmYrRGxEZmIvWnRUZ0U0WUVBRXk2RGJrZThT?=
 =?utf-8?B?VkRETE16cElJeFRLek1sZ3VxRGtOWFJYMDVZVVpPallSS0M3SVB3cGdTdXND?=
 =?utf-8?B?K3hKUUt5ZVlMWHVFblA5cVlYZnlXMjlac3VFb3N2anhoK2ZpcnBydWpKaTFX?=
 =?utf-8?B?VDcwMlVFdkg5TXFJUnFhOWEvZnBKODg2a2hLSS9XVi9UeUxpOVVDSkxtSG9E?=
 =?utf-8?B?YmtUcWZjcWNLSnRMNldvSUhTSG1XL0tBeVAzMFVheklRcSszR3pNVFkxNTF4?=
 =?utf-8?B?WTZ6cWdkUXZ6cERDSm9rc2xCeXlRU1EycC8vRWJoTnFxZkc4Q2VwY0NJb3Qx?=
 =?utf-8?B?UkpNUnZCcllCeUFTRFVlZFU2NDd6TEx2YWtCNklkL096WWRqVE4yU0F4c2gz?=
 =?utf-8?B?djN6Z2hPRG1oV2lXMHI3c1JpaWFTUG1DTTYyOFVpNUZDWmFXL2RBTUEwY1Az?=
 =?utf-8?B?TVdMdDVuc3RoN0x5UE9nbWl6OEVZb3JHTUdrR2lEdE1kM1hTNGIrem5pOUY2?=
 =?utf-8?B?NndFc1QwQU1SQWVzZjNFaUVtWWlsMFJvZDFFYkpJQmVHOTRyV01UcjZSUVVR?=
 =?utf-8?B?RlBaV0pWOUlkbGw4UWxpaWFUM2xCZUt1OGZ3ZEk4VHczWUsrMmNYMWhsN2VS?=
 =?utf-8?B?Z2djeWFNdVVpVVc3aXdMUERlZ2lBTUNOSlZlOXF2aHVUR3pFR3pISVJsY1hM?=
 =?utf-8?B?TVNoeUJFS0RZVmRxdTNuTkoxMEhkYkxIK2V5bkJLckd1NXpNSW9nV1doTUg2?=
 =?utf-8?B?a0F0dFhFbFQ0RjZkR1pBcFVjeE1TaExXY29STHFJNlVmTmNZdHI1NzkxNUxl?=
 =?utf-8?B?YWthaTZSQkF6RDg3eHZJOHN4SmhmcjhPQkMwZVNjdisxRGIwYmpDb3RjM3Jk?=
 =?utf-8?B?Y0JzMEVQRWNoN1BDdTlNQVVMRGJhSHIrV1B6TWhwckQvZmE5R1U5WVdyOU91?=
 =?utf-8?B?NmlxM0UwSDAxWDQxV1hMNXV5THpvL1lSWmVKcFQ2YVdFNW5vNzRjL2Q1WFdj?=
 =?utf-8?B?K1RMdmdCY2xoaGRVbzVHS24yUzVsbmlaNW42OUUvN0NzSURVQjhRTkdsUkJR?=
 =?utf-8?B?THNNUWlGNEhIb2N5TTNqZDVZMVJNOHVaMkZYYkUxVTBac1hiRVR3bFFKR1kw?=
 =?utf-8?B?MUFQcWowT1dzRVJQQTJBSEFnQ3psTFR6REJZSGpRZytIaXdQdGhPRk5CVGhC?=
 =?utf-8?B?djREcEQ2eTUvMk16dDJYOXNaNkFxKzQrTloxQU51UVlkMlduQzdiOThMUTk3?=
 =?utf-8?B?MTNVV0NpV0F6d3JTckRlTHVXZkE3cnN5MG8yUTlPZHpWd0N3akpGeGVycVBJ?=
 =?utf-8?Q?nqYRcY1+JP+nEdNZvwE81YY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dDgvSkI4T056Zlp1NUoxSE1aQkJ2WnVUYUc3R1dRR0FJVEw1cmhFR3llYXlU?=
 =?utf-8?B?VlhMcXNTa1QzcDJJY1NoaXFqR3I0WFJuU3g2OVM0SXVra0VRK3p2NWhPdGZz?=
 =?utf-8?B?MUtiWEJUNnlpMnhnVUczS1FkKzkwZ1dTeTNhUjNicis3ZUVxRDdKeXJlQ0hk?=
 =?utf-8?B?akQ1NXJSK2tFM21FQnpGdzQ4dTMrdkVtbVJpL0IxQ3JOaUQzSmFST3c3YWZh?=
 =?utf-8?B?U1FYeWQ2ek8rQ21iYnNhV3loLytlOVNqMzlVVmdkdmp3UkNKVjRoamtYZ0lV?=
 =?utf-8?B?b2xVWjQ4SGpGakZiNVlIYU5Pem1MeDFzNElveTRnekV2U3hOTHNzdkFoME5h?=
 =?utf-8?B?ZE1mTkg2VWVhTUxRL3BHR2lqcmRGQ0dPNUMrbjJkeG5sQ0ZWVXI0aUFyUlhz?=
 =?utf-8?B?YittNXJ5clVlVzNCUzJOMi9lQlF0L1l3YnlBa2NTV1J1RGNhUEc1MktxUk00?=
 =?utf-8?B?TEVaUXlFdXN1R2E5UnJzajd6TVlrd3FDblFQL2pJTXRyTzZLMEdaaG92cUQ2?=
 =?utf-8?B?RmlWZVA1SnNpUGVEOEU0L0pNUU1QQ3RBcTlSaXBlbHJmSHZSbGtZQ2tWdFV5?=
 =?utf-8?B?a0dpYXdyTnF1cFBRY2taSVU3ekVieFdFUG1uREdLbDUxazM2YjI5Vk5VUDkx?=
 =?utf-8?B?d1JhQWlCRnJkVGhhVmlMME9XTmlEbThsTUo5MFZySlNSODJoNGdmSWM4ZWpv?=
 =?utf-8?B?V1RSS2doMVZydGxoR0xlT0E0N1VlVDJFM0g4dy9xTlFOYkJ0NWJwWWxnVFhU?=
 =?utf-8?B?U0FqVkl5SG1mRWFpTXdMK3czMGE0YXZ6ckRYZURrQ2VDZlEwR1NzczlFOG81?=
 =?utf-8?B?d29OYVdDa2ZoZzFrQWFUMnhEL3EzZmd1QWhlc3pDUkQyOGlhcHAzdFhkQ3Rs?=
 =?utf-8?B?Z3JhK1FHUkZuUklzcWFtTkF5UTNsQ2hqcDAweWhkM2d6UHY0K2JCdjQ5cVhs?=
 =?utf-8?B?aVBDcWxSdFR3R0ZBdmYxRVprVXJVWmdFeVFnTWp1WTFXUitWUFlTWVJLbGIy?=
 =?utf-8?B?THZ1QXVoc1FPQ0JpRytoSjJ3T0U4WkI1NzhLWTNFOGNaR2ZSejdSSWpWTW9w?=
 =?utf-8?B?VHRrSzlSNUR1dGltdEx1LzNFa2pVbklNbW5kOENvWGlyL1crbVdCUlBuSlBv?=
 =?utf-8?B?U0R1NWZRNm9WVVEwWjhOSVRLQmhNclcvVERsRlpudUNHQXNnRktiL0UwaWlD?=
 =?utf-8?B?Y1pnOWQ2N2xKRUxDQ1RuczBhYlV5emxQWEZIS3VSTGRTOUZiRkdQTU5tMEQv?=
 =?utf-8?B?U1ZHUXR4Wkk5aE9TZG5OWlVyUlVsNEY3SmpxVm5KNXhFNTVXMXQ5YVRic2tz?=
 =?utf-8?B?VDJNUzNwYjk0RlBidWZjTFRxamtaVkd0K0owdWdTRkt3NGVweG5YaGpRTmtC?=
 =?utf-8?Q?Y7Vjs3buZ1SBA13jZUESewHMJPHKCLP4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d199bd-619a-47c6-46ef-08db386a0664
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 19:47:03.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q2/jNd7NF9tE4C/vuiyCU5MzIrphN8R4bKagcViYMBQbsfaVYYmO8X25TrGYyzbJdBehke/Mx5tLVOkpOl0FIlvT7seAwRdp/Y0izL5riWm1tm/x4llyhvwdOxrqCIfL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5056
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-08_10,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304080178
X-Proofpoint-GUID: -l6CWMRrmOy9e3HEvlj_XpXz3Ry7nYOP
X-Proofpoint-ORIG-GUID: -l6CWMRrmOy9e3HEvlj_XpXz3Ry7nYOP
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

On 09/04/23 1:00 am, Simon Horman wrote:
> On Sat, Apr 08, 2023 at 11:12:25PM +0530, Harshit Mogalapalli wrote:
>> Hi Simon,
>>
>> On 08/04/23 9:02 pm, Simon Horman wrote:
>>> On Fri, Apr 07, 2023 at 11:56:07PM -0700, Harshit Mogalapalli wrote:
>>>> Smatch reports:
>>>> 	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
>>>> 	warn: missing unwind goto?
>>>>
>>>> When dma_set_mask fails it directly returns without disabling pci
>>>> device and freeing ipc_pcie. Fix this my calling a correct goto label
>>>>
>>>> As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
>>>> it finally returns -EIO.
>>>>
>>>> Renamed the goto label as name of the label before this patch is not
>>>> relevant after this patch.
>>>
>>> nit: I agree that it's nice to name the labels after what they unwind,
>>> rather than where they are called from. But now both schemes
>>> are used in this function.
>>
>> Thanks a lot for the review.
>> I agree that the naming of the label is inconsistent, should we do something
>> like below?
>>
>> diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
>> b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
>> index 5bf5a93937c9..04517bd3325a 100644
>> --- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
>> +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
>> @@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
>>          ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
>>          if (ret) {
>>                  dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d",
>> ret);
>> -               return ret;
>> +               goto set_mask_fail;
>>          }
>>
>>          ipc_pcie_config_aspm(ipc_pcie);
>> @@ -323,6 +323,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
>>   imem_init_fail:
>>          ipc_pcie_resources_release(ipc_pcie);
>>   resources_req_fail:
>> +set_mask_fail:
>>          pci_disable_device(pci);
>>   pci_enable_fail:
>>          kfree(ipc_pcie);
>>
>>
>>
>> -- but resources_req_fail: has nothing in its block particularly.
> 
> I think this situation is common when one names the labels
> after where they come from. So I'd say this is ok.
> 
Thanks I have a sent a V2 with this.

> An alternative would be to rename all three of labels after what they
> unwind.

Other functions in this file are using similar labels. So may be we 
could with above diff(V2 patch).

Regards,
Harshit
