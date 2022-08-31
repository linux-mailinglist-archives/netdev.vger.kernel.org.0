Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284795A7E4E
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiHaNKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiHaNKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:10:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C41253000
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:10:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5DeSeoL42KzzHlCug4aMYJ148MKN3EKtd+Y3d/8VD8A/5OsPeIUjO+3d0B58Es9tEew5/2tyA5sdHbHipWjj0YYbH/MusVmdTwkDplibP4qIzVvIpKSXYEj8f7gd8v3/kPrvs/Gpl6FfQVnIicrtXp9njUgmIMl+8sHZ8QkjhsEoe1YIp1p7vPS4Og9A4CltulkYXkf7oxuQWU1V613z4BWkZawvhNTa61rVPCXH7A/yaL3mOO68g7T04tQIW7rSWetpM1R1qFpj+EMCifFEYqJo/7rVhSfI6rPVcPNzwzkaeDQNvJ1fWwZFbeAnJ8aiPCvQdHFTJDk9xrEHAiAlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FK8j+JRTd0zuexWyOG1/enYtBEP3gNaO/UN1Zq/gJOY=;
 b=lVLEYAi4f4htVS9LZQnxb7OIwv2nGGFa0KKen3tsNO6SkQeLah25n/By6twEmKZTW81a/fnWbyVZ21kNPDkSoFzxZjw5p74TTQ3UfZ5CJAyEJMu/ITYaMEGf6T3/bSjlIqezOtOEHqVJhBGKE37fSEMyhbvo+Zx5ChX4AlUb4D2FOibXPY6Z5nYuQ0bmXmSGMYNkF3e9nuN9JkDTe8SNMNREoPlKRPUCflBKAsKZz4p1lh1+ORkgJnnWdskvVU0AEumdPcfWxSO+UNp8o3QdNBQ9afAODptGzUAr7dsOCevzSrfey9janQpBdjpPgYGEGvXt42QhGBBP/t2EPlrp3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FK8j+JRTd0zuexWyOG1/enYtBEP3gNaO/UN1Zq/gJOY=;
 b=uZnbfDJ6/22yXUEseQHjf8/jzLwNPgcW3+Zss1jzY/5+QKDZORuuoBcpwFiYCwTsEtKwAgDtdnBj2DiNJOlkEoHXiI758Mi7x6jDAfIlep9KCX7n3MoECCkYy30LZV19FBz9W68HauOoUpjnzQGIIqIUi8/jUESMeVoaOz4uBX66N/c9BFGIS2vEE4EsoN/jxUqixtAkDSAB2MxJODsHhUZoSaez87llPECTT9x2RFlxNgXD4RfWCSUjjnZbB7hW7q4KsQg7vmj+MHQWxCou1jRXz5zHJWCP85m41fsZBH3BIdiflyOBu3ciH0u5KYUd2GRdmiqVS+NEgg1XAPWTgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 13:10:36 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::e52a:9fc5:c7f0:7612]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::e52a:9fc5:c7f0:7612%6]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 13:10:36 +0000
Message-ID: <8f60e5ab-dfba-0e02-5d7f-ebd6bebf2572@nvidia.com>
Date:   Wed, 31 Aug 2022 21:10:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [virtio-dev] Re: [PATCH RESEND v4 1/2] virtio-net: introduce and
 use helper function for guest gso support checks
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        kuba@kernel.org, sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20220831130541.81217-1-gavinl@nvidia.com>
 <20220831130541.81217-2-gavinl@nvidia.com>
 <20220831090721-mutt-send-email-mst@kernel.org>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <20220831090721-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0170.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::26) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aae5e620-b6eb-4f83-ef8e-08da8b5230fb
X-MS-TrafficTypeDiagnostic: LV2PR12MB5727:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eyb7wCUVI9odd7XnJlNGBWWLCDpIPJ8P2h0f03CE/i08FPrVwNNSmXv1OxBOBteNRABslBiGjW8Wy+VsA61NF7v/cU5FAS5JYTBxY76b4lQIGg1APKmNQCtzs6o9GjGHo2pNpHIr46a/y5NNzwpFpUZcYaPW5ZNMMmt6IR4lWaiB7WfIFyv9Uod8DyLdhRfddriSCgUUEnaUH81q2vuRIY7HtzVFKGDL9w+vetopxJbcaoEVbiIC73Vqlp0hB2ETXx5bJtb7dDmNIn5FFKRsb8OzIqzU7FVSTEVx8/pKTwnXLSA2qFUpKu5sQrqapaalfTAejuf/xbhgvUEIFI7CSDMtqGURApr0T9ynbU2fBMM++QgFD4A67CYx3OZ4c4QDoR8FDpnF9xlhqBJtsLgGarZs1CcaPuyO8HqgS3Em+fq+mVaa/BuZbqOjJ71WBwUxwwRy56ad9bbbdRB8bHoug6Zv78R9YX1mXggs15x1P5Gd/I7q09N3R82cwobUx16L3lNYrjtUHOwU4XUz2LI6ZkHjZ7B8VbMeflhCH2wMRGiTXQfLbHRzAwqR8QwSDuVGepojH/sjkz/L8CK/ZRQc35emLhrmerUvdRRVtgAUOE8B4tZZH19Tw2RdSeScZc0Fv6lhnh+g70oscGSgavAtUDGMhIHWDJr/g08CmboxG5QD6UK+8tWlqCbEOIGAQ74cUHP5VQULZRXiFaIjFh5iHEFm3YEJBrh6yEU+OVLj3N74UJnXbMgTGxuTx4BMkEgvH4zsAIjCA6H4PcrILeA+9b09jcmkeo/AqlTnPHo42s0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(7416002)(31686004)(8676002)(4326008)(66476007)(66556008)(66946007)(54906003)(316002)(6916009)(6666004)(6506007)(53546011)(41300700001)(6486002)(26005)(6512007)(478600001)(38100700002)(2616005)(86362001)(186003)(31696002)(5660300002)(36756003)(2906002)(8936002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2E0MzlDTkhkZnZycTVNNVFxTGk0cUZoRTc1QUUraTM1K2NOWTZjZjIxUUFy?=
 =?utf-8?B?d2JSczFIOFF6YXBIMUNiMXY1Umo5aEZyWmJKdEd3cGlUdm9VNFdlcEFmRWQx?=
 =?utf-8?B?Y3NQZndzRVlualJpeTRRY2tsVXVMV3luWm1mQURXbC9ldy9oWHNSeDRkY3gx?=
 =?utf-8?B?WVhhb3hLc3ZyMWZqL05TVzVWbFJKTkRuWmpFMFFvaGU5OHE3ajB2QjdWSWxS?=
 =?utf-8?B?Nm9CTk91UG5RTFFKUG1IUlVjblhRUnBhMjJmdU1YK0tOWjlwTjlkc3p5YUNx?=
 =?utf-8?B?b1Q3REo2TXVNakk3SmlKTHdWbGYvajV4b3R4djVCQk5iVEsySzBOWG5mUVlB?=
 =?utf-8?B?M1IwN1VwZGJKVkl0d2N3bldWMjhJY05Xb3Y3NnZOQ3BNeW5adDVIVnJ4U2pG?=
 =?utf-8?B?U2Z4S1p2b3FjeG4wN1h3dlF2SkZLdSs3T3Rwb0xXWXJXSGZJaFNNNkUzbDVK?=
 =?utf-8?B?Q0QzKzQxVDZlazRkaDNJQzJHOU1hamlUK0N5cWsvMDQyTW5jU2VmTXovMWNq?=
 =?utf-8?B?Q0IzODVXa3hFVlhNZVJPckFRMklZZm50R3llSVZmVVdvazZndTdxY1E5WWhC?=
 =?utf-8?B?MTl4NlIwOU9ZRm4rS3dwOGhsRms0M0RuUllWS3hBdXI4bUlwRWRIS0lxMFZO?=
 =?utf-8?B?VHpnRm1XczI4YzBrL2d1M2o3Mjg0MDg3RlpTTTFjaG1JQWxEUWE5M09HOGRx?=
 =?utf-8?B?dFBFWkplSlRBQU5CcUNSR3c1aWRDR1AzZW1YZFAzMWxPSlQ3TEFMa21jV1dj?=
 =?utf-8?B?U05DQmV1alNMc043b3J1QXBxcXVEYW9lYmxRRTFZVmNsNExIMStCMWxQUVNB?=
 =?utf-8?B?L0tXSHpxNVdYTUoxZStEZUMzV1ZnWEk4QWsxTmpLVHRtQUFaMDViN3BSYTNm?=
 =?utf-8?B?YTZHUnNLYjcvNVlhNUJla0tEVGFDVVMyUzNqYWNkSWYxQ2lIaDBvV2Y0SzJE?=
 =?utf-8?B?NFZjeW1zSEI0WWpsTjhBTWx4d3hFbU9qUGo3V1d1dW1mcFNXMFhzbHg5UTBX?=
 =?utf-8?B?OVZpdDF2ZkZEL0tzeDliRDBrblUzamt2ajNHRkdpcjU4eWdmZjkxYnFrMm16?=
 =?utf-8?B?cm5mUXkwSWoyei9wVE9kc1BOM0ZFT3Z3VW04ajRiV2h0ekNpNGZuUDV6VDBn?=
 =?utf-8?B?Z2RUTXdYUmxCU1FkUFpzcndBcXlmSDlnOU91dEtqQ2FrVkc3RXN1Rmt2L1B6?=
 =?utf-8?B?UnBmcW1oT0pudHoxcVBHM29OUlBtZDA4aHIyMU01K1pTaGdhN1ZwbVJyejB1?=
 =?utf-8?B?MFdEUndRTC9jY3JwcjlrbzlmZWJpenY0QTNFVWZOM1A3WWNISnhkcFpHU1VD?=
 =?utf-8?B?TzNSMWRFQWF3Uit1dE16Z05sNnNUbFVQSDhUcWZ4aHFSbmpBVlRDUC9vaGhY?=
 =?utf-8?B?L0R3VGpIR0tDcm5KWTRIZlpqQjgwdC9VczIrVmZMM1cvcWFPelpxaGVycHdX?=
 =?utf-8?B?alJrbmFidXcrSkp6OGY1U3JNYnJxbUpNMW9UUTFGL3dUS3lCSFIwUldkeWFm?=
 =?utf-8?B?K1FwSHZEVlNlY2ZjUXJkb3RjclZ2ZXdUc0xyemJtMGFkaThiN0wrZi93Ujho?=
 =?utf-8?B?SGg2OWs0enl1aFMzR0hxbFFWYzBhOHp2RzVCcjZGZFZvSm1tZ1owRmJIQlJl?=
 =?utf-8?B?WDkyYlJvOUFVVERKNzZHbTFkR28wTFhmUmtFTGtrYjRxZDE0cGdDd2VZUjkz?=
 =?utf-8?B?eVRIMEZRcktKaVMwV2J1VERMWU8vU2JYTDV3S1FMK1YzL2lOMXBmeUVBQzZB?=
 =?utf-8?B?cGZmMWFyN2Y4SERFN2U5ZDRYYVI4Vm9sdkRGZ0ZNR1ZDM1V0ZDdLZ3ZZWmlq?=
 =?utf-8?B?K1I0STBqcWwyS1NyYXFGVzRLMnUzeWkrSk1maDhxcExtaDY1T2JnYTl1Z09U?=
 =?utf-8?B?Y0dRWHFQOVUyYmhzcEJhMU1ENE5JT0FrNFJBaEN0NGE3TXRMcmd6WVM4Sk5R?=
 =?utf-8?B?R1ZNMnA1Z0pFK1NPcEYrbDVTbDN1NTlhK212QTJxdVA2Y0l3ZDE1K0Q1ZXUx?=
 =?utf-8?B?MkZ1enI5clM1dWY5alRRcnRrcnFnYTd2eXRjbm1lMUNQVDh4RzFjWWlLblZ3?=
 =?utf-8?B?R2tNazlkZTlnTEh4Tk93Nkxlc0U0WHhQWlVYb3cyYzhBNnhPL0x4T0J4SE0w?=
 =?utf-8?Q?0FqdavFTn1pywxuTGg+5+WvXU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae5e620-b6eb-4f83-ef8e-08da8b5230fb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 13:10:35.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxskryySqSnw9Ml/2Aq5swne7YMN1lVE4koymxsYaCIQI3t7B6eMbJlaGOwBhBsM0yhz/fcE4X8Bv9KIgJCpeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5727
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/2022 9:08 PM, Michael S. Tsirkin wrote:
> External email: Use caution opening links or attachments
>
>
> On Wed, Aug 31, 2022 at 04:05:40PM +0300, Gavin Li wrote:
>> Probe routine is already several hundred lines.
>> Use helper function for guest gso support check.
>>
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
>> ---
>> changelog:
>> v1->v2
>> - Add new patch
>> ---
>>   drivers/net/virtio_net.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 9cce7dec7366..e1904877d461 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
>>        return 0;
>>   }
>>
>> +static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
>> +{
>> +     return (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>> +             virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
>> +             virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>> +             virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
>> +}
>> +
> fine but can we please drop the outer ()?
> they are necessary with if but not with return.
ACK
>
>
>>   static int virtnet_probe(struct virtio_device *vdev)
>>   {
>>        int i, err = -ENOMEM;
>> @@ -3777,10 +3785,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>>        spin_lock_init(&vi->refill_lock);
>>
>>        /* If we can receive ANY GSO packets, we must allocate large ones. */
>> -     if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>> -         virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
>> -         virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
>> -         virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
>> +     if (virtnet_check_guest_gso(vi))
>>                vi->big_packets = true;
>>
>>        if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>> --
>> 2.31.1
>
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
>
