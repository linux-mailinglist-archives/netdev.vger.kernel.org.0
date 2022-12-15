Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6926564D915
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiLOJym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiLOJyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:54:11 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB7F220EE;
        Thu, 15 Dec 2022 01:53:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD6GznkGP6FLT71whf84N4NqvH/QG876M+wvzVqPd14GC9ZbxPekanteDq3QvJj2ZGhvcU8lxp4M2I4hQQf273oECEgZjp8CfblKX2L5dDuI+6nKwwpqDHocjVCLRvW2WJxU5vy5hlWUQai4ymynzDIIOlqyGF4MlRbrJ5ccD33lsnK3XYLArasqLRsQo67X7D45385yoH/Jqf83e96gy3AfIw2ujtf91gxHt0onNbsKQvW2lu+pZPvBL9MVaUSTdR9Qi4+2SY1KxUFxMNdsfiKj0TXvveyYNXLjun6BarNu/gd/v6uLj30AptmI17c8u/g+/mQOVUDBCpOAqDuSKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wj3N/ETYsa+XeY1CADTKmXZDY09pqwURm6Jf4UDxdYU=;
 b=eEHkizyAO5sa6qrNcMctf83v+hwpLHHq+eVN90OCzeBYmgd7fRXTUR11WpXGv8LSk7qJT6Qo/ZlGY2gedOrQDbeDd8QZAocYTh7RzLiN5ipgdNlT1tzWgIv0X8wyEqRCBvXQsT0RJuo5OQe8ShtCDWocwHbtw2lwX0GT8gVx67ovtAcywlStjTlf3LkeWxdq75BxyCJnoh1wdiq6XqhnpCLONKDnreCvK3rYZNQSTBH3juNdiM8hs5ACiLXU/wCGRkUH5JBbnSHc2WTcSEWzwrSrEbVOJ0onOKUyc7zEOtpJpA/AvVu2p4V8j/lv5ER8fEt9OnathpXa9bMs80Pvcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj3N/ETYsa+XeY1CADTKmXZDY09pqwURm6Jf4UDxdYU=;
 b=C8Y7juaDM3A7FpzVrNlB9/JeLroqiYx7IVdx8fixZHzlOj374Q1bUYGzVyk3svsi4zUtShOoAcVBuByxqXqX//gpJTHdZ5b4KwFtv5sdwKPWgPzG89h/6P2qNOkKny1Es9qII1qsTmjGIE4E7nL2ksu4cDOu/+xHMmspUaP3sLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by IA1PR12MB7686.namprd12.prod.outlook.com (2603:10b6:208:422::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 09:53:43 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b%9]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 09:53:43 +0000
Message-ID: <8cbcebe8-f5af-733a-c8e1-2bf48cd2e972@amd.com>
Date:   Thu, 15 Dec 2022 15:23:25 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 05/11] sfc: implement vdpa device config
 operations
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, netdev@vger.kernel.org,
        eperezma@redhat.com, tanuj.kamde@amd.com, Koushik.Dutta@amd.com,
        harpreet.anand@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221207145428.31544-1-gautam.dawar@amd.com>
 <20221207145428.31544-6-gautam.dawar@amd.com>
 <CACGkMEtzWYftw75U5nTWFLPGZBXWPWqq7POqg=OsWV3htZ1QjA@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEtzWYftw75U5nTWFLPGZBXWPWqq7POqg=OsWV3htZ1QjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::14) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|IA1PR12MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f95808-df7c-4efb-fd5c-08dade824050
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eFV5nq0n/Ym6PpWMvInZISFSNu7CuFF2J1Uf7yTvySokRPWca4//ClcRl0i7KHU2VnngvLXipYztMqGkbOnoGn7IWMk6dvKyOAZ/qMyFPi8W6gvM3zQLMhSBvlHCZznorkfsqhRmG9HuCjCdq8LpI/tA/JGzufcNRpP3q6OhlPrx3kChnzgUj9Ny4kUPkePMa0Qie2psaVuQ2zORmuqi9DLoIyKe5CRZuIo22jrXiYJNbwa2vjUUAPwFRz+DW0jpycjP02UpBnF5XD0WnOt//6fzmQbzyy2pFz61l0qa/+gpxfiPeaRKTZu/L88JMqvxONr9c6O6jkOmcLsS1T8F+cqFsEM7QsXV8bQSt8msLdNtzDyUcnBbaWQg0xQgsE8RvyLnCishu6oSqk0m2C+awR3t93IuGHRYvH65pf5bjktFrGCEe8RThVz+h6o4vZGlKriV9Mr9XWu/iBm+dj75uz4+rjg7AX4HYNzl2SKSRXI9WpoJaLNZq1vQG8+reIJVlIrgKdarILGI66mAmUE44kfRGMMEC8fy+annaO21WJ1tSIcpbIIPRxJ6uCxybNZaLyBRO77j3G3BwST1WZoAM7kqUVI/FXT/pxL+gQdm21ku9QrS/vGzoQWxDs5U8I8rxfVhwfhOTA48AmG9kBVRhWPmMipUgFF2XzPuCO8MLWxgGJ48395CzMZ73eUkpTkQZd0eu5ANPtAZPc/158lCMGyZ7huDiGzbmoH4mShMEh8mKTGjWPlYf7zsUQ1QE1Hy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199015)(31686004)(31696002)(36756003)(83380400001)(38100700002)(186003)(110136005)(2616005)(6512007)(478600001)(6506007)(26005)(6486002)(6666004)(53546011)(6636002)(45080400002)(4326008)(8676002)(7416002)(316002)(8936002)(66476007)(5660300002)(2906002)(30864003)(66556008)(41300700001)(66946007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDlRR2pyd1VHdzVqTkR2aGo2RVlNMG4xdk85cGE5T3ZLUFNUR1pUcFNINk9X?=
 =?utf-8?B?SjEza29ncjQvcWtSMU9qeTdrTHZacTlyU3pJOWhGRHRxV2UwS1MxbDFBaStp?=
 =?utf-8?B?Wmw0QnhidDA4clJCRW9XbEt6Ym55dGdFOXFZWEtuRm55c05iNmhaaHVrakJj?=
 =?utf-8?B?OHRMRTB5eWxteisxM2w0TUtxaWx1MzJKRmpSR1Jmd2FjMXZlZmlnYW12c1kw?=
 =?utf-8?B?cWZGQVc0S2thRHlIaUxzSHNsUTZvalBSc3NkVEZORGprVlgxV2JOTGtRdVRG?=
 =?utf-8?B?WG5sMHd3TVRTeVRaaS8wL1gwZ1NCdENDdFoyMzhWcXoxZXN0Wk5xczdteFU2?=
 =?utf-8?B?d1lxd0I1VE5BZUxjY3k1TWVpS2xUR0lCS1RNblZ3NFIvNmxMRTM2S0R1enpj?=
 =?utf-8?B?R1lKWXZBd24wRXl6bmR6NVFiWnh2ejZyM3poV0JJSHpVblRUZ0IxUWxQMklH?=
 =?utf-8?B?WEdBRnVxcU5MWmJnVkt0L0FpY3VsRTB3UktsdGxOcWRzR0lZSENTT1NneGJE?=
 =?utf-8?B?bDRBbkhLdUZhbnZWekE2dFlpR1BGUk0yOW5wNEtyc2F3ZVFEM3d0dHhzendC?=
 =?utf-8?B?MXpFWU9KdmtFYmpWKzdwTWpEazRRRDl6Q1hpcHhUcVdFbVYwMUtQZzAySTQ5?=
 =?utf-8?B?aHRGbTlENlBKZmkydXZoQ084N2xZQytSUFhDalFaZTJOMkhlZVY0UDRwS0th?=
 =?utf-8?B?dXN4bU16bjE2Y0lWSnE0dmlOY29VRldDTzBGend1eUFRbDlaVVcveGJGMVk2?=
 =?utf-8?B?bHIxenFkY0ZkUTRHNGlKN3NBMHQ4WGpuWHlTK0FTeFN5Unp0Z3VLZVB1djho?=
 =?utf-8?B?VHlqd0xDT2xlQlVLbFoxc1RHQXBLanJqNFhOQ3NWL2JUT2dOTGhWeDhwL2RZ?=
 =?utf-8?B?VlZXN3UwdlJnaHJFWXdlbStISHo3MnZNNE5pMWxwTnRXRm5LOU9PYkwyOHlK?=
 =?utf-8?B?VkFrdjlOb0VjVnNPb1ExN1NzaFZ3R1gvRHVUc09XZFp1MG1TaGNtd1RyWjk2?=
 =?utf-8?B?b3puZ3NzeXQ0RUxDTkVaSkNuWktFc0FNdkN6M2NpMDRhd3Vrak80eU1abllx?=
 =?utf-8?B?UXM4WnhVYkdTUXFyTUQ4b1FNYnVKSzdiYkNVQUZweGljUnN1QWlCd243OWQz?=
 =?utf-8?B?YVhTaUgzTHJmK3lGSURnRElFZlBiWWp5aXVJTTFYR3YyRGErQ1lJRkZ4c2hJ?=
 =?utf-8?B?UHB5dkZSTmFSL2hpRE5sOFBCS2czb3pSVHgvUW5HMjJKUi9UQnJaa1Z2QnMv?=
 =?utf-8?B?TlVBQVB3aEJ2RExZdVdJUG8wZUdRdzlPTUVuME8wMEFiU1c5T1FOa2ZUVU9N?=
 =?utf-8?B?d2YrMi9vUGl1WGtFNlVCWncxbUc2QnlUZk5VNjFtK2o1WnV3Q0JOYWo5YVhH?=
 =?utf-8?B?dFNJdEpQN2lrZ3pkUVV6cWhESUk3bmw5L2JCT1ZTMzZXeXJPLzRyR0o5eHdF?=
 =?utf-8?B?Y2xiK0treVZuR3M4cnZtUXpFeDBXVmJ6ZnRRbStDZE9jRys5NlhvaERZcTFI?=
 =?utf-8?B?YVdOejJQR3BDVlBOMXdWUVRjUUQvbTFiZGxHQkNWTkUxU09mKzhSaFM0M0lZ?=
 =?utf-8?B?ekhRZUUydmNDQTduY2hJSkFnL2ZSTzc1SndLNFFKdXdaMTJudktOTU5QQ0l2?=
 =?utf-8?B?ZjFCOGVmU21LVFA5dW8wUW9xOTVVQkZHdTN1eTFjdk1xSUR4b2ZSeEl5NjZ0?=
 =?utf-8?B?RDRSMktXcFF6T3VyckhxTGZwZHhNMVRwS2ZOaUx2bEQ4RHFFUDR2eW1PV1ln?=
 =?utf-8?B?cmpvNnprUFVaZHZja1ZWeW5OTEtkWC80K0NJY2ZJcWxaL3FwYXVVdWVVVHJ5?=
 =?utf-8?B?V1NCMFY5Rk5TanBUbkZBaExEQzQxTG9TbG9ZenIxcTQxMFlaeHBNNDZ0eE8w?=
 =?utf-8?B?WXZPd2xQMzcvOWNmMTNCbC81aEYrSXJ1WWxxSXRxWjR1Q2JVcERPUnBnVzcy?=
 =?utf-8?B?c1JUM0pJVGljU3cyWTZoV2FYRCtjTnJLZ3FzcEJOTEhYTEo3V0hnL0hhQnBY?=
 =?utf-8?B?a0tmWng1dkdiK2UzNU03ZTc1Z1pwMDUzdmlGSG93NXU0MjZBWW1EcEphRFRw?=
 =?utf-8?B?TlorUTNoT2JwckY1RHNpb2V6S2RPNWxDVmJSMU1JYlM2R2xGN0JjSmF1dHJa?=
 =?utf-8?Q?yUdY/VJcGLn9rPcK/2KTNabUO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f95808-df7c-4efb-fd5c-08dade824050
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 09:53:43.5492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0URLAORYEJBWxiWTNYIlY494OeHUjosB+voLt3g6tlohBwREgY73RI1Vij+Z6xAg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7686
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/14/22 12:14, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, Dec 7, 2022 at 10:56 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> vDPA config operations can be broadly categorized in to either
>> virtqueue operations, device operations or DMA operations.
>> This patch implements most of the device level config operations.
>>
>> SN1022 supports VIRTIO_F_IN_ORDER which is supported by the DPDK
>> virtio driver but not the kernel virtio driver. Due to a bug in
>> QEMU (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.com%2Fqemu-project%2Fqemu%2F-%2Fissues%2F331%23&amp;data=05%7C01%7Cgautam.dawar%40amd.com%7C58787eb502484eeaa6f508dadd9ea016%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638065970623127805%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=cVomPr2aFJBHW7kwzeZJrNHuU6oTYOTV14eOS%2BpeNVc%3D&amp;reserved=0), with
>> vhost-vdpa, this feature bit is returned with guest kernel virtio
>> driver in set_features config operation. The fix for this bug
>> (qemu_commit c33f23a419f95da16ab4faaf08be635c89b96ff0) is available
>> in QEMU versions 6.1.0 and later. Hence, that's the oldest QEMU
>> version required for testing with the vhost-vdpa driver.
>>
>> With older QEMU releases, VIRTIO_F_IN_ORDER is negotiated but
>> not honored causing Firmware exception.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  14 ++
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 148 ++++++++++++++++++++++
>>   2 files changed, 162 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index 83f6d819f6a5..be7650c3166a 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -21,6 +21,18 @@
>>   /* Max queue pairs currently supported */
>>   #define EF100_VDPA_MAX_QUEUES_PAIRS 1
>>
>> +/* Device ID of a virtio net device */
>> +#define EF100_VDPA_VIRTIO_NET_DEVICE_ID VIRTIO_ID_NET
>> +
>> +/* Vendor ID of Xilinx vDPA NIC */
>> +#define EF100_VDPA_VENDOR_ID  PCI_VENDOR_ID_XILINX
>> +
>> +/* Max number of Buffers supported in the virtqueue */
>> +#define EF100_VDPA_VQ_NUM_MAX_SIZE 512
>> +
>> +/* Alignment requirement of the Virtqueue */
>> +#define EF100_VDPA_VQ_ALIGN 4096
>> +
>>   /**
>>    * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>>    *
>> @@ -61,6 +73,7 @@ enum ef100_vdpa_vq_type {
>>    * @net_config: virtio_net_config data
>>    * @mac_address: mac address of interface associated with this vdpa device
>>    * @mac_configured: true after MAC address is configured
>> + * @cfg_cb: callback for config change
>>    */
>>   struct ef100_vdpa_nic {
>>          struct vdpa_device vdpa_dev;
>> @@ -76,6 +89,7 @@ struct ef100_vdpa_nic {
>>          struct virtio_net_config net_config;
>>          u8 *mac_address;
>>          bool mac_configured;
>> +       struct vdpa_callback cfg_cb;
>>   };
>>
>>   int ef100_vdpa_init(struct efx_probe_data *probe_data);
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> index 31952931c198..87899baa1c52 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -10,12 +10,148 @@
>>
>>   #include <linux/vdpa.h>
>>   #include "ef100_vdpa.h"
>> +#include "mcdi_vdpa.h"
>>
>>   static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>>   {
>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>   }
>>
>> +static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
>> +{
>> +       return EF100_VDPA_VQ_ALIGN;
>> +}
>> +
>> +static u64 ef100_vdpa_get_device_features(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u64 features;
>> +       int rc;
>> +
>> +       rc = efx_vdpa_get_features(vdpa_nic->efx,
>> +                                  EF100_VDPA_DEVICE_TYPE_NET, &features);
>> +       if (rc) {
>> +               dev_err(&vdev->dev, "%s: MCDI get features error:%d\n",
>> +                       __func__, rc);
>> +               /* Returning 0 as value of features will lead to failure
>> +                * of feature negotiation.
>> +                */
>> +               return 0;
>> +       }
>> +
>> +       /* SN1022 supports VIRTIO_F_IN_ORDER which is supported by the DPDK
>> +        * virtio driver but not the kernel virtio driver. Due to a bug in
>> +        * QEMU (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.com%2Fqemu-project%2Fqemu%2F-%2Fissues%2F331%23&amp;data=05%7C01%7Cgautam.dawar%40amd.com%7C58787eb502484eeaa6f508dadd9ea016%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638065970623127805%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=cVomPr2aFJBHW7kwzeZJrNHuU6oTYOTV14eOS%2BpeNVc%3D&amp;reserved=0), with
>> +        * vhost-vdpa, this feature bit is returned with guest kernel virtio
>> +        * driver in set_features config operation. The fix for this bug
>> +        * (commit c33f23a419f95da16ab4faaf08be635c89b96ff0) is available
>> +        * in QEMU versions 6.1.0 and later. Hence, that's the oldest QEMU
>> +        * version required for testing with the vhost-vdpa driver.
>> +        */
> I don't see why this comment is placed here?
As the comment was related to VIRTIO_F_IN_ORDER, I thought of adding it 
in config operation related to virtio features handling. But I think 
since it is already added in the commit description, this code comment 
can be removed.
>
>> +       features |= BIT_ULL(VIRTIO_NET_F_MAC);
>> +
>> +       return features;
>> +}
>> +
>> +static int ef100_vdpa_set_driver_features(struct vdpa_device *vdev,
>> +                                         u64 features)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u64 verify_features;
>> +       int rc;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       if (vdpa_nic->vdpa_state != EF100_VDPA_STATE_INITIALIZED) {
> Under which case could we reach this condition? The
> vdpa_device_register() should be called after switching the state to
> EF100_VDPA_STATE_INITIALIZED.
You're right. I'll remove this check as state is set to 
EF100_VDPA_STATE_INITIALIZED soon after vdpa_alloc_device but before 
_vdpa_register_device()
>
>> +               dev_err(&vdev->dev, "%s: Invalid state %u\n",
>> +                       __func__, vdpa_nic->vdpa_state);
>> +               rc = -EINVAL;
>> +               goto err;
>> +       }
>> +       verify_features = features & ~BIT_ULL(VIRTIO_NET_F_MAC);
>> +       rc = efx_vdpa_verify_features(vdpa_nic->efx,
>> +                                     EF100_VDPA_DEVICE_TYPE_NET,
>> +                                     verify_features);
> It looks to me this will use MC_CMD_VIRTIO_TEST_FEATURES command, I
> wonder if it's better to use
>
> MC_CMD_VIRTIO_SET_FEATURES to align with the virtio spec and maybe
> change efx_vdpa_verify_features to efx_vdpa_set_features()?

Yes, it makes more sense to match the function names with the operations 
in virtio spec. However, MC_CMD_VIRTIO_TEST_FEATURES queries if the 
passed set of features is supported and it fails in case either driver 
requests an unsupported feature or misses a feature that device requires.

Hence, it's more of a verification of feature set than applying/setting 
them.

>> +
>> +       if (rc) {
>> +               dev_err(&vdev->dev, "%s: MCDI verify features error:%d\n",
>> +                       __func__, rc);
>> +               goto err;
>> +       }
>> +
>> +       vdpa_nic->features = features;
>> +err:
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return rc;
>> +}
>> +
>> +static u64 ef100_vdpa_get_driver_features(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       return vdpa_nic->features;
>> +}
>> +
>> +static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
>> +                                    struct vdpa_callback *cb)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       if (cb)
>> +               vdpa_nic->cfg_cb = *cb;
>> +}
>> +
>> +static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
>> +{
>> +       return EF100_VDPA_VQ_NUM_MAX_SIZE;
>> +}
>> +
>> +static u32 ef100_vdpa_get_device_id(struct vdpa_device *vdev)
>> +{
>> +       return EF100_VDPA_VIRTIO_NET_DEVICE_ID;
>> +}
>> +
>> +static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
>> +{
>> +       return EF100_VDPA_VENDOR_ID;
>> +}
>> +
>> +static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
>> +{
>> +       return sizeof(struct virtio_net_config);
>> +}
>> +
>> +static void ef100_vdpa_get_config(struct vdpa_device *vdev,
>> +                                 unsigned int offset,
>> +                                 void *buf, unsigned int len)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       /* Avoid the possibility of wrap-up after the sum exceeds U32_MAX */
>> +       if (WARN_ON(((u64)offset + len) > sizeof(struct virtio_net_config))) {
>> +               dev_err(&vdev->dev,
>> +                       "%s: Offset + len exceeds config size\n", __func__);
>> +               return;
> I wonder if we need similar checks in the vdpa core.
Yes, it would be better to have this validation at one place (vdpa 
framework) instead of individual vendor drivers. Although I am not sure 
if the framework can choose the correct config size based on the device 
class.
>
>> +       }
>> +       memcpy(buf, (u8 *)&vdpa_nic->net_config + offset, len);
>> +}
>> +
>> +static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>> +                                 const void *buf, unsigned int len)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       /* Avoid the possibility of wrap-up after the sum exceeds U32_MAX */
>> +       if (WARN_ON(((u64)offset + len) > sizeof(vdpa_nic->net_config))) {
>> +               dev_err(&vdev->dev,
>> +                       "%s: Offset + len exceeds config size\n", __func__);
>> +               return;
>> +       }
>> +
>> +       memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
>> +       if (is_valid_ether_addr(vdpa_nic->mac_address))
>> +               vdpa_nic->mac_configured = true;
> Do we need to update hardware filters?
Yes, it's done in a later patch where filters support is added (sfc: 
implement filters for receiving traffic).
>
> Thanks
>
>> +}
>> +
>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>   {
>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> @@ -24,5 +160,17 @@ static void ef100_vdpa_free(struct vdpa_device *vdev)
>>   }
>>
>>   const struct vdpa_config_ops ef100_vdpa_config_ops = {
>> +       .get_vq_align        = ef100_vdpa_get_vq_align,
>> +       .get_device_features = ef100_vdpa_get_device_features,
>> +       .set_driver_features = ef100_vdpa_set_driver_features,
>> +       .get_driver_features = ef100_vdpa_get_driver_features,
>> +       .set_config_cb       = ef100_vdpa_set_config_cb,
>> +       .get_vq_num_max      = ef100_vdpa_get_vq_num_max,
>> +       .get_device_id       = ef100_vdpa_get_device_id,
>> +       .get_vendor_id       = ef100_vdpa_get_vendor_id,
>> +       .get_config_size     = ef100_vdpa_get_config_size,
>> +       .get_config          = ef100_vdpa_get_config,
>> +       .set_config          = ef100_vdpa_set_config,
>> +       .get_generation      = NULL,
>>          .free                = ef100_vdpa_free,
>>   };
>> --
>> 2.30.1
>>
