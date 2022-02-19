Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6564BC374
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbiBSAbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:31:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239630AbiBSAbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:31:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5470145E1A
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:31:13 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IMNRua009833;
        Sat, 19 Feb 2022 00:31:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RNKBGfDCOMpyQ9bz6iPuxAaf7QQbu8NL8kqLFLh6XWs=;
 b=UipQz5cTEmuKHx+rGYSr0BKm+Ll11wE7wzck9/ZPFQ9KK4YbCNhY0aO+aJu0o3mxS8Uk
 5u5n88dlMTWDHZMTFf2nz5aZeaBEqjpgL1O2Ms3vFxTos92bM7HsNjiSF4dtRkqkehBT
 6NNNHDL2a4kCm8eXX1T6U+R3qFn/mPriwDkfOlCNHYtn3EhBpxDpRf//Y8S2VIp7HX34
 KPPUh1xIjl4nndS0voOW34vuqgbNScU/OHzsYDbXSpiK7LvzfVqNXlmAqn2vuw0gRswN
 c71nLAGRjIQZ7l88NwxfRMD61vDIzeeby0VpiqEx1b1zTLAzQPWP1ZcIv5pLIDqELAHb +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nkdu69f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 00:31:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21J0Geka187162;
        Sat, 19 Feb 2022 00:31:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 3e9brefy7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 00:31:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DISSttt9QvlUaK3l5iBe1oA356SDRJzEFLYZOt0M5ScPZHgMHbwFBjNVSOO1fHSCeKXezh/fyoPh5fOiHVmRCD6xsUwA+6qcEwfeK3HwgfjEmXZRlBw2EuG4nZKUHSMVj4dpbEW1OoqdxgIbVPs/Imodt+R36iM1Qo9gEcnHQyr3EolLu55QEFL5Lb+c273oV/BCJfcD3GkuDdIuvFtm3rqk5MD5QLTtRL18c9RQ0DgJX4wAywbp5I+ioZtB/rGxpLZJg6FPQ4mTD7pTpYbFjn/T9e0N86MkSF6ScaecudP59fhJCP3c2+awqoWSpEf0V+3oP5EAxHX9MdLb3fdwfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNKBGfDCOMpyQ9bz6iPuxAaf7QQbu8NL8kqLFLh6XWs=;
 b=hLbbbozsHFpQht4VQH9QSJfpOWRD0HTC0JSHzNMmSTkRxqha8BEJHWxpxXr6NQauxntVvHL0658X3l3RM/0YSNxnXJdwe3LRwNw1Or5qIeicbfPHogkwIrtWh+fyeVKtXklsGDIjlxCg8SPoTLpeDWOplng5/sdF+XVz+6LijybfjOxShnKhF2DtZ3JsSuUfLjOEgjeBY+DO/Tn9JdfZyP8o0mdyrLoC3Ycegh6iNcvo+2AqE5Sf7J93dW2Esxjz+eCatl9sN4DLTU/v5moUnWI9d3XwHTdpDlGCiJ8cmBungewaKZH9W4jKrLwv4sIAc8ysopNE2Fvzym2rEyFLaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNKBGfDCOMpyQ9bz6iPuxAaf7QQbu8NL8kqLFLh6XWs=;
 b=ulG+N9uBZXxLkWWnOKbEVjOLawTh37X+dUyCcEc1X1AjwNYQ7M7B46ObKxZ6gtOlgEu0eIjwQ2LkZcYLCV3qNaMB4LmPq0Cwdno4xpPQd4UWSVU87bu+qjYUr6S3Ue0PszA1m7Mf9UPdwMGQ4D1k540Q8tMXVrNE0Cfu7ongvr8=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by DM6PR10MB3532.namprd10.prod.outlook.com (2603:10b6:5:17c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Sat, 19 Feb
 2022 00:31:06 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd%6]) with mapi id 15.20.4995.016; Sat, 19 Feb 2022
 00:31:05 +0000
Message-ID: <1cd76162-73eb-4af6-a69b-a351c1c88b46@oracle.com>
Date:   Fri, 18 Feb 2022 16:31:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     jasowang@redhat.com, lulu@redhat.com
References: <20220217123024.33201-1-elic@nvidia.com>
 <20220217123024.33201-3-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220217123024.33201-3-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0182.namprd04.prod.outlook.com
 (2603:10b6:806:126::7) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d421adc-dd7d-4f96-9efe-08d9f33f1d96
X-MS-TrafficTypeDiagnostic: DM6PR10MB3532:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB35329FB402A4CA702DFBAD54B1389@DM6PR10MB3532.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aehMiD9cp536bZYXRRWOKU0U7IbdBHhLDTXY61w6/LHoFNdE76vuAeYCzKLBElYWMhUn8FW2Fp0PKIRy/7iGqZfjO13MukwVvpnoa+Umim9uWxvJMagkw80BxZnB2aBVii3nFA0qAthLRj/FGXhTigdSIti08diG9EFSBU+WT8QmlmNqknf+kQr4PpclXLLu26GEHtFNOM6+ZV4QynnNRZrLyJbYb2Yper0GqUwyNVfmuM4UdBqqEoKbzrT2estKcr1cyjRaUjRbme9OArmTHoJcd0mFA+kfQaUkmaxpWLCrnOyiEG13fFjPfOP+Lff/LrTy1kCh+V4MK1Nnh4WuC/f3TPcwHH/MkzzK/xLX6FkueWdi8uHovWacxPc6wUZhBp4wjQQNNX4c6Pvh0299s/03TE2dw4/NUcyjL5mTTyD7m+svUD7zWWAQYIfgf5oantHrRr2hjhXBMuUuZOhj6uK4opAJqIKZOZCy7KRQkkOIebANmlCJOLoFZmNmzjREniihh5NT02Ktbo72fDGsJpLO9HeFKe1n/YorF4PUXNc8B5Um7wRhzAKSk+v4A4lb/+wCfMGf8TAM9JvCgTBjNRvENAXeC85N/7DjoGdwg+YIfRuIZXi/i+ptXp9Q1QVwPznU0q9fwIW/MVWqP6b2LkNulbZO68OR68qJVTZ+f4oQC9HJJVkqdGjGxruFIaWJmLVY+w2+FIxgf6fvG3AATprGEmAolJ4bvnrLqAT8CXwBcEoCw7Wb3wDLfI6jPge0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(36916002)(6506007)(2616005)(5660300002)(186003)(8936002)(38100700002)(66476007)(2906002)(66556008)(53546011)(4326008)(8676002)(66946007)(26005)(83380400001)(508600001)(316002)(86362001)(31686004)(6666004)(6512007)(6486002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SE5pV2VGWHNxSzBQR0tsRWVXODFidHAxRjM1N0VwVFYxWGE3aTVVc0lzWjJz?=
 =?utf-8?B?NjZKTzBPbGRTZXF3d0E2Q1JTZWNYMXQyY2orU1pKeDlwL1QzWDV4REpNRUxi?=
 =?utf-8?B?WFcrYWVodXREaFVyVkYwS2FCMzhURVJGVGVta2ZoMjlyVUQxQWdWSVR4VkNw?=
 =?utf-8?B?VG5wQ2FXWEw5THpxM0crRjNOZlZMLzMycU85bllMazlKR2pRZDhqajJXSWtV?=
 =?utf-8?B?SzNZRVRDT1RtUGFmclZ6cXpDL1FtZ0hQZVJTZk5SRlJEYnhvMmJ3dC8rZXlM?=
 =?utf-8?B?c0YzaldqTUdzU3FVdUxNdVVUekR3NWZaRHdRM2FSeU1Cc0RFQnE5bTJ1ajVy?=
 =?utf-8?B?L1NYaWU2R3NZaEN2WG83ZDJqZW9QRldiSGU4L2JVckVmSU9pMkVTbEQ4L2hl?=
 =?utf-8?B?SC9kZFB2ckYxeUZEQzdqR3Y3WGtRejVtbGhJUUFEVE1XYytmV1lqbGNYUXlh?=
 =?utf-8?B?R2hsdDJJNlE1K1k0cDF1K3g5VnlQNmxNWG8zc3hDUG04MXZCWExvNFpESVcv?=
 =?utf-8?B?MUVaamZIR2NLbnk5WFZzcEpqa3BjUWFiazdRamRvWnZaUlZnQ2NXcGVxQ0tS?=
 =?utf-8?B?b2FpM0hhMGFWd1RYSVBLY1pxdFVrNG9RYmorT2lqcmRsUVR4R2pDdTRDTE1x?=
 =?utf-8?B?NVN1Z2RSMHJmTno2dnQvdFkxZnFQT2FYMUNqTVNvdVZGMHJIWjRqUDNia2Fz?=
 =?utf-8?B?RysvdVoxc25NNS9rdEVYWFRsdlR0Rnp1bGhKT3dRSkFjdUI0VkY5YlhKc1VG?=
 =?utf-8?B?QzREeWdTNGs1Q2d2VmpUTWlkaFVnVkpWZ2N1cXRlNUE2MkRucFFJU2RRWDYz?=
 =?utf-8?B?M3JRMVJsNnlmN2ZLR2xReTJZY3A5VDZSSWozNlg0eEpBSS9iWEtXNkIraS8w?=
 =?utf-8?B?VU9IUnFNb1lOTlpRTUU0L1lWY1NQR1IyblV0NFhuaXlzbU9iRVhIbnJCMUtK?=
 =?utf-8?B?MlBSU25FWmwweUdwOEMrNE9nNlBzaXkrUko1dDB0dEhoVXdBSHE0NVVmVVBu?=
 =?utf-8?B?cThiWWtaY1B0cllvNmhrRXBYeS9LRXVpT2tsb3VBT3Q0eUNGempyMkIzMWhJ?=
 =?utf-8?B?eHBKeE51dVpVZmU1eTVMa3VBVXAwZ3o3NHBVTlpHbWNTZjBtNmlJbU04SDVK?=
 =?utf-8?B?OEJ0VWZ3UUI0ZXhUK3NTeXVMQjZWWjZ5SE5XRnNVUDhOT2hoUmFzL01sUExn?=
 =?utf-8?B?RUQ0R2gvbTZFUVU5UW1yMVF1YmVFUENrSTcrZ2U0ZXRSZGRYeUdRQ3IxSzUv?=
 =?utf-8?B?UkZPd3h5UUNTN1JtMnBwY09KRTQ2Sjd5aVR3SElKR3VvenZtdlEyQXpqRFFI?=
 =?utf-8?B?Z1dwVmJlMnpWYXZ2ajdQUzJva3gwRXBXcC9BeFQ5a09MV2toM3lLOGh6aGNZ?=
 =?utf-8?B?U2pHZGExUWM5UU9tOFFYdDJkY2dKejlUMVdrWEJML2FZTGhQOCtEV2djSmJR?=
 =?utf-8?B?a0ZqREQvZ0pKRDBsVUFtdVFRTUVmRDRYTUs3eU9LMkkwNWhkTmg4UnplaTZs?=
 =?utf-8?B?S1FVaTV5QzlRVGpCbEtKSHBBQ0NMOWFnbVBGbDAzUVVDNUhkc2YxV1B6aUZ3?=
 =?utf-8?B?YnUwempWbFk5andqOTdOSGdENjRGMUpWd1VKcnZlZFZucDMybGVHdnFRcWdi?=
 =?utf-8?B?TndNYjh3cytXN2htWDJSMk1Ea1hUcWdyZ3ZxZHk1eGZ4UXBRblloNWtZeitY?=
 =?utf-8?B?eFF0ZGREVGxmMDZxd3RnVEJtSTh4T2o2SkIxeXJ1S2c1a2pmeGNId2pHMFpG?=
 =?utf-8?B?TElKdXZlZVljdEo0NDAyNTF6dmhTcWZ3enluSkhpUEY4c2hOYzM0RWdMTnd3?=
 =?utf-8?B?dmRwVlZpeXNKbGg1ZnREbVVrc3JaQ0RvWTkvbE0zSU9ZSnNhNFo2Z3BBbU91?=
 =?utf-8?B?SFpITVhORzUzVUQ0NytkNVc2UVNibTNvd2owdlhxaGdHM2NwQ1lqNTBCRmZ1?=
 =?utf-8?B?TmdlUGNHbDN3TkhkalFNZTdpY2UwajhSN2lqQkh0Z3BJajMwRURQc2xKZ1BW?=
 =?utf-8?B?Z3RYMHBIZWp6WGp0Vm5pbmJJQnhnaGkwRkFzOS9kdEJuV1ZaSEc2UzV3MTM2?=
 =?utf-8?B?eDV2V01HZ2Z1eGFoVkRyd2lCUXB2VUhVWTlpdkFFWkMzU0Yzbmp0Z3dKdGRi?=
 =?utf-8?B?TzA1SEZDYloyOUhiNGJXNzcvQ1owUVVnVmpOMko5V2tUZlhBbXlDMzB5bDhI?=
 =?utf-8?Q?7iaeQgmgeNhedXTxcJzfqfA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d421adc-dd7d-4f96-9efe-08d9f33f1d96
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 00:31:05.5941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FqpUYLUU/JK7cbwvMXuKhdMD6NUl95CI+TBFi1kaxBoCdBJVSrL96x3Vs7rQr4egfbamneLz3VO/BaiEapsTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3532
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10262 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202190000
X-Proofpoint-ORIG-GUID: b0BvMDRznx0F9hzlQUJBtGJaaNiwLMqS
X-Proofpoint-GUID: b0BvMDRznx0F9hzlQUJBtGJaaNiwLMqS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/2022 4:30 AM, Eli Cohen wrote:
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
> 1. Standard presentation
> $ vdpa dev config show vdpa-a
> vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 2 mtu 9000
>    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
> CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>
> 2. json output
> $ vdpa -j dev config show vdpa-a
> {"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false,\
> "max_vq_pairs":2,"mtu":9000,"negotiated_features":["CSUM","GUEST_CSUM",\
> "MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR",\
> "VERSION_1","ACCESS_PLATFORM"]}}}
>
> 3. Pretty json
> $ vdpa -jp dev config show vdpa-a
> {
>      "config": {
>          "vdpa-a": {
>              "mac": "00:00:00:00:88:88",
>              "link ": "up",
>              "link_announce ": false,
>              "max_vq_pairs": 2,
>              "mtu": 9000,
>              "negotiated_features": [
> "CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ",\
> "MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
>          }
>      }
> }
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
Other than the VIRTIO_F_NOTIFICATION_DATA definition you'd need to 
include from uapi header file, the changes in this patch look good to me 
overall. So,

Reviewed-by: Si-Wei Liu<si-wei.liu@oracle.com>

> ---
>   vdpa/include/uapi/linux/vdpa.h |   2 +
>   vdpa/vdpa.c                    | 108 ++++++++++++++++++++++++++++++++-
>   2 files changed, 107 insertions(+), 3 deletions(-)
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
> index 4ccb564872a0..f60e647b8cf8 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -10,6 +10,8 @@
>   #include <linux/virtio_net.h>
>   #include <linux/netlink.h>
>   #include <libmnl/libmnl.h>
> +#include <linux/virtio_ring.h>
> +#include <linux/virtio_config.h>
>   #include "mnl_utils.h"
>   #include <rt_names.h>
>   
> @@ -78,6 +80,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>   	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> +	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>   };
>   
>   static int attr_cb(const struct nlattr *attr, void *data)
> @@ -385,6 +388,96 @@ static const char *parse_class(int num)
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
> +static const char * const *dev_to_feature_str[] = {
> +	[VIRTIO_ID_NET] = net_feature_strs,
> +};
> +
> +static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> +			   uint16_t dev_id)
> +{
> +	const char * const *feature_strs = NULL;
> +	const char *s;
> +	int i;
> +
> +	if (dev_id < ARRAY_SIZE(dev_to_feature_str))
> +		feature_strs = dev_to_feature_str[dev_id];
> +
> +	if (mgmtdevf)
> +		pr_out_array_start(vdpa, "dev_features");
> +	else
> +		pr_out_array_start(vdpa, "negotiated_features");
> +
> +	for (i = 0; i < 64; i++) {
> +		if (!(features & (1ULL << i)))
> +			continue;
> +
> +		if (i < VIRTIO_TRANSPORT_F_START || i > VIRTIO_TRANSPORT_F_END) {
> +			if (feature_strs) {
> +				s = feature_strs[i];
> +			} else {
> +				s = NULL;
> +			}
> +		} else {
> +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
> +		}
> +		if (!s)
> +			print_uint(PRINT_ANY, NULL, " bit_%d", i);
> +		else
> +			print_string(PRINT_ANY, NULL, " %s", s);
> +	}
> +
> +	pr_out_array_end(vdpa);
> +}
> +
>   static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   				struct nlattr **tb)
>   {
> @@ -395,7 +488,6 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   
>   	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
>   		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> -
>   		pr_out_array_start(vdpa, "supported_classes");
>   
>   		for (i = 1; i < 64; i++) {
> @@ -579,9 +671,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
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
> @@ -610,6 +703,15 @@ static void pr_out_dev_net_config(struct nlattr **tb)
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
> +		print_features(vdpa, val_u64, false, dev_id);
> +	}
>   }
>   
>   static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> @@ -619,7 +721,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>   	pr_out_vdev_handle_start(vdpa, tb);
>   	switch (device_id) {
>   	case VIRTIO_ID_NET:
> -		pr_out_dev_net_config(tb);
> +		pr_out_dev_net_config(vdpa, tb);
>   		break;
>   	default:
>   		break;

