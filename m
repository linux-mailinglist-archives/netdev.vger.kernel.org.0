Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75CB3145BF
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBIBlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:41:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhBIBk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:40:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191Iiub014074;
        Tue, 9 Feb 2021 01:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+3szoXBjhoBk3unShQfs5KbxILfC0Tye/k/kPTftsVc=;
 b=snBKL3zpUctmWeQ07kCAm0MAVDMV9kzkCI8SdBVabrPPZZz8rRL1o4mMxMYFuIil9fW2
 /zeQ3yK17DugEDjH9vn0coAMn5Zp6V8erjiSJAQ7RtkPKAA3rH8W8sxf4X2aR6VrA/2+
 3wLtBQ16S+4dNb81p8Qyzl/cDs6ijuXL+xpmFv1VWzjWlAx5/ggQeh2CV16MVuyJbLT1
 mML+2uh/PgxY0+AfU9xNKyKCesSnNiHaZAfmb5++P4jK/7lrHnOrZ+5KqbHu2b8CAi7O
 iYegv1B8C206l8PHOaHt/xkMSsOuognHplOEC7sfhYN4/LYDufmw/0ydY/3y5b1D2jfZ cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36hjhqny37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 01:40:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191K7Ka155341;
        Tue, 9 Feb 2021 01:40:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3030.oracle.com with ESMTP id 36j4pn1up4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 01:40:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsFrNLTr67vTOywiQHSdiOEqFrWUnsbIzl1rxbOfYi+ukMDd9Latwdjf6jFoatcLbFFFsZV19JVnTxPpn9pRddxZPGMGttVrepJAYV/pKqMKjf9fFIAIpTkNMpLb27VCDljaqEyue3hmwx3mmWCN39EUSZe8p1Y3wjB3IxtGEaqX7od31+/hwovAkJXpsAGtiyWn2ASVQwEI90XsJBwuNHBkdAKXooQmRKxiC6pZc9sVTriOLejuctep3nLXuyfH+8NIfcIYjJ0li7b+3GgnlYkl6dwU2hzvnHUWejHyA3Aypkxkv9dKbijjH/0idxv1F96P9iyTPt+SOik5VgBf8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3szoXBjhoBk3unShQfs5KbxILfC0Tye/k/kPTftsVc=;
 b=YQ6YG0tWK4QicWUkKv1xrVPowj4+ckkcvlz64AlEyN1ouAcJCu8rnrln2+kC4lp/nzvt8i/WlOb4M3VJwRkjN5m/e3SD9rC/AS1v3k7OebqwmOLuWZdkX9x3WMdVOnvyPuZ/daiBLmLU903egbDEPGv+qn2elL+pQieHXS0L52OY0PDWBfIc2bWugS0m9glfZdHM3b4Vwk0HrhtkzodF2lnfBNEPsEvJEP3VGcfHPhZ3+YMRDVoEMbSMq8CshpZW6ZUdnun/gg0KOfsNJEhgWyDD/T+iXbYDMkiyawMIUFxW5EKkpMLNfbSThGJedohAf1b+N2jEDaq+894LHhJ63w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3szoXBjhoBk3unShQfs5KbxILfC0Tye/k/kPTftsVc=;
 b=vLOM+q25ja1l8J9Kfd/hDh25EtEThV62x92tUf1dps7opAad8hHl2JPvnbWCHtVg7LJh87pWZAGRfM0VzYr7mAe9xG5p7ekWw64WJwzY7dTwDA6hkPY5RGJ+EbU8PWzhyMVmnIaJ0Z9Tml7EZ6ubSfZd4jEm+VrOUh+BDplAXBI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3173.namprd10.prod.outlook.com (2603:10b6:a03:153::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 01:40:05 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 01:40:05 +0000
Subject: Re: [PATCH 3/3] mlx5_vdpa: defer clear_virtqueues to until DRIVER_OK
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-3-git-send-email-si-wei.liu@oracle.com>
 <20210208054816.GC137517@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <460e414c-afab-842a-a278-16dbb2eed656@oracle.com>
Date:   Mon, 8 Feb 2021 17:40:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210208054816.GC137517@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: BYAPR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::21) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by BYAPR07CA0008.namprd07.prod.outlook.com (2603:10b6:a02:bc::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 9 Feb 2021 01:40:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6838f9d2-a75f-423d-97ad-08d8cc9ba023
X-MS-TrafficTypeDiagnostic: BYAPR10MB3173:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3173F000E046229EAB9905BCB18E9@BYAPR10MB3173.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4A8DrSvhekOHcr4rA0Oof66PgPI+xHYITr5PWAHyondkNZfLHfHd0YSj4slU3+ydfJwnW5bVulktMYw7Sf/JLSjlYC0m7gon1/+u5jAto4GTkSWT7KzsL0yx5m5y9iR+thaCql+w2WtRoQJ/+TaFqtlKk2cOo7f07Cni1r/knBgEfsiYoCo8A9iFwyV4tF7qVXpaSKpsbAYMPZspliQWwhA5ChktAAdtwq+i+F3idBGaOTVzTd1R8hgDycB69D9t4dJhMfzPhMvHR6uMZMKuGzB8Tc/0z0zuCrM4zpa0WGysQ8bxgcNUv5BBkv0BdyGAtYr1hF2bPXrfqtKPKwsI4K1S+l0/P/HWD48giuMYuauHkjHN7oFjjrepsZMVBsHWyxhIDWMCxyEykVZhGF3i3ChMdkarbwUuT3hu9ayRyxlKrvqPXX6RX8aDmlO/bKedtTdi1FWvrT9tT14Rc57QWJponUi3JMmf2MucaP72lFbuQPySJl68k/R05r+YqSsixDbzdnozBHBaSO32hioPwpXmS34srpZ6UyLzyY2kP35JDF39qubqhJkxhUnY4RmBHkDRZizFoeJWp+8lqL5lUYCIQCB/tXCeSlbO3QmB170=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39860400002)(136003)(36756003)(6486002)(16526019)(2906002)(31686004)(316002)(186003)(16576012)(8676002)(8936002)(83380400001)(31696002)(5660300002)(86362001)(26005)(478600001)(4326008)(956004)(2616005)(6916009)(36916002)(66946007)(53546011)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?czEycDFZMDFhUndsQXBzajdvczVsMXk0d2FNNXBCVmtCRklQNHlORUU1UWFj?=
 =?utf-8?B?SmhzMEFoWm91N1ZyWEFxQkhKY3hZWk5qZFZTRUc0VlRsd3M5N05HSTZFSlFo?=
 =?utf-8?B?ZWs0UVFXZkdQaytGaXRLb09aN2pDTUdiOFZUNFBSb29rQXJjRUxBS3AxN2l2?=
 =?utf-8?B?RENOQ29XSXNpQXVzRHREOEY0WWlhV0xpc0hjQ2RnWmpUZFhzOVhaRG8rdmVT?=
 =?utf-8?B?dDB4OXRwSjQrRHlKenZPdDBlY2lyT2s1MkE5ajJ5ZXJZN1NoR3hVNllNZEQ1?=
 =?utf-8?B?aVY0Nkd4YmxwNGZzU1RFSUZOUFNGRmtSQ3NpUzJobzBvaTliZUEydlk4NjJE?=
 =?utf-8?B?cyt3TE1XMEtVUzllK3VtVWJwQ1pScHBkcUZMd2c5VmcxUXJnT2hoSEl5aHEz?=
 =?utf-8?B?c2t4OGMzaVBnUFZacDJ4M1dRMXB4WnRKb3JpcGlaNVpVVi8wWnRBa1NERHFI?=
 =?utf-8?B?Z2NSd3hpLytlWUh6czFET2hWa1N6TkJOV2Q4RzFGcU5Tek45UXdhQ1ZjN2FJ?=
 =?utf-8?B?UllwK2g5akQ1RnExSExvTFYrY21pdU9wRnNUd1NxS3RGWjdteGt6eFJJcG4z?=
 =?utf-8?B?RmJtZlIrWWlrQmdmVk9MZkdUejRwZktIeGNFUVhxdUc3TW9BL3k0dzZpaXVt?=
 =?utf-8?B?UTVscllNZ1hNOTM4dnJmV3B5eWRJaHEvU1E3cEZGaElBWVoyTlpUdUl1NG5Z?=
 =?utf-8?B?V2dIYzVXczRoTm1LN1JlK0d0M2lrbERxTGZkVnRlTVFNdFJRaFBqaUlsUXN2?=
 =?utf-8?B?SGl2YXVoRXFmNzduSGZPOTZPZjROSThrYkx0MVh4b3JXQ2MzaEtJTm5RSUtu?=
 =?utf-8?B?a2tNdVIzd2JNSm9TVThpQUFua2VCQUdkNE0zSCswL3o3ZHJRWlpuRDVxRnY0?=
 =?utf-8?B?aEFFeUtQWVNSMTZHWEJVUTNHdUwzOE92cFdXWloreWIwTktJSndWVldhSDhv?=
 =?utf-8?B?K2I0Z0NHMnVlb0xjR3dZV3A2Nkw2M0VVRGFNcXJnSWNXdDllRHllN0pOOVFs?=
 =?utf-8?B?cVVxWHRYWTBQNE9BcWJ2dGRGZmlrNnRMbVU0TDVrYWFodG1BK21OQ0M1Yitu?=
 =?utf-8?B?eHZiaERUVHY0K1RMWTh2YXAzZlZmZkJVOVA2aW04ZG94bUFUY3doU3hPaGFn?=
 =?utf-8?B?cG9ldVpEQWJpdjZwUytEWFlGVWhpWExIUzNSdUpsZElDSW1HdDR1UVRUN3dp?=
 =?utf-8?B?OGtrNjdiUkZIaVZaMFBBZmlsZDNPVFg4cGFZei9hcEVDVWRhd3Q1Q2gxMDR3?=
 =?utf-8?B?NEltSnZCdFljbEFsS0dyeWJaQk1OejBsbkdrS3h1UkVOTzVOakx4NWdMSUlW?=
 =?utf-8?B?VEYrSi9zc0lKMDMyK1BqUjl1eE4rRWxwZWxBWUFiMkt3MGxQUUw0bVQ4Rk9Q?=
 =?utf-8?B?cnp2TFZzRWZsbCsxUW5tcHNEM0MwNFRLRDRCVnI3aitleHJyU1VzcjBJa1ps?=
 =?utf-8?B?RkdqZnFHQ3BkWXZncG9qdHBDUEM4T3o0OHRFUUlhNmxVNmVmVmJaWGY1R2xY?=
 =?utf-8?B?emppYUVlUzMrM1l6ZG9GVWNwTnZ0czh1cjdIQkVieGl6cnNnR3drSTFkWUdB?=
 =?utf-8?B?UFl6QkVzaG5VczRxYlR4VXBuMWR6Y0NNSURjL3l5R2pVakpDSThaN3ZzTFpD?=
 =?utf-8?B?MExXaWhaYzUzZ3pWUHVrcnI2ajQwVnB3V2thdnJjZWd6d1VyS3NMNGZtZXA3?=
 =?utf-8?B?cGV5MVZKdFJma0RYZ3ZXa21VcXpTK2tsNWFNdXJzVFJTR0ZzUXdDOWVySmxR?=
 =?utf-8?Q?pJAIGI5ZNTurrrwmDrJvdd9zNvaEe/xk+PRL58z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6838f9d2-a75f-423d-97ad-08d8cc9ba023
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 01:40:05.2419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nIS6gJv1d8AA4JZM8bxsWBWz527CfqTkpKFOZhqWbVAmlQ79gO/zip+zgb/qNseu+PHe+5/gBPekk2S/3MJxWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3173
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2021 9:48 PM, Eli Cohen wrote:
> On Sat, Feb 06, 2021 at 04:29:24AM -0800, Si-Wei Liu wrote:
>> While virtq is stopped,  get_vq_state() is supposed to
>> be  called to  get  sync'ed  with  the latest internal
>> avail_index from device. The saved avail_index is used
>> to restate  the virtq  once device is started.  Commit
>> b35ccebe3ef7 introduced the clear_virtqueues() routine
>> to  reset  the saved  avail_index,  however, the index
>> gets cleared a bit earlier before get_vq_state() tries
>> to read it. This would cause consistency problems when
>> virtq is restarted, e.g. through a series of link down
>> and link up events. We  could  defer  the  clearing of
>> avail_index  to  until  the  device  is to be started,
>> i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
>> set_status().
>
> Not sure I understand the scenario. You are talking about reset of the
> device followed by up/down events on the interface. How can you trigger
> this?
Currently it's not possible to trigger link up/down events with upstream 
QEMU due lack of config/control interrupt implementation. And live 
migration could be another scenario that cannot be satisfied because of 
inconsistent queue state. They share the same root of cause as captured 
here.

-Siwei

>
>> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>> ---
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index aa6f8cd..444ab58 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1785,7 +1785,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>   	if (!status) {
>>   		mlx5_vdpa_info(mvdev, "performing device reset\n");
>>   		teardown_driver(ndev);
>> -		clear_virtqueues(ndev);
>>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>   		ndev->mvdev.status = 0;
>>   		++mvdev->generation;
>> @@ -1794,6 +1793,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>   
>>   	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
>>   		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>> +			clear_virtqueues(ndev);
>>   			err = setup_driver(ndev);
>>   			if (err) {
>>   				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
>> -- 
>> 1.8.3.1
>>

