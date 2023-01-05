Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A217B65EAE8
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjAEMq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjAEMq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:46:57 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C7148CDB;
        Thu,  5 Jan 2023 04:46:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3NF+fWyJ7x1UIOzEXXx/VfWJ+Safu/+gBl1iSc1j0/L2jiY11dLwTHQUrTPxpWKns6rFHbzL3gW5xV6cOIZ6Ze1WQQaFCvgudGSpd213yPYq9leGLWbXUgYbCd0AzLn9A9hq8hD/QmE4frWXgtbbZEK3C0avk9sj0ay9vJmlDEjgVDuWIot42rdJ/PQ0pXKY5xXyqoJXYWAE8MMKKjDDkLQyeUXCOWgbdZO0X5WeI2s80Ehtu9FvmUFIVVMcbEhCPxM67bycYzTRNPGLo+WSwwY9SVsj9E10FquDruOyLEkQ0p00LZJx2R6lvJ7GBuZFYiyFyXAz5cTM27y1dOm+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnzKO7HzCp68c+m4GUw8mn/l6iR06y2WyHzqr+95nwA=;
 b=BCMSi1NgW+9K1+ILg1BTIfiFexKIc1CXYogAwg9VES9ff2UlFp4nq5N4LoZr9BS9ydkXo7efgLNX8/XWthkd8XS9a4mut34JU0E+Nn3OPt0/Iitprc168kb1sUWS2QCQUK/+IFVYQNDQwsDzFcPhtuFxwpJP737tKPgFNZ/PsXNyYlMPSY+xYAoevuz06cZilrSSjw23WN6SsIbhrfufFPBxw+BHpAzM8dLZc5Wo5yfq+gCDHLdBhhl28l7uWadhUqEtoaa/xBUFzDoeJrT8eR6SV8wbOujoQh+OUrAWZz6p0bsXdBIyuCCnwiK1eCPi0m5bWgeiR7KE2TMBUzRJdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnzKO7HzCp68c+m4GUw8mn/l6iR06y2WyHzqr+95nwA=;
 b=VQThFjuaczaJIUMOGpT0yhS5FdSBFIxrZrs3g2JZztlZcETqQ4cEXS4Lg+jdSvEKYa+uOQyScpHeif+0GOUkRdBMFllsz/hR236LH6QdYGzRLR+bisgyJS6C8Oe/9XVOYWEEX4qNT3lAtRKl+ooHsXwGZiowq/XPL/B97C5/0PI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 12:46:51 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 12:46:50 +0000
Message-ID: <a936c0e3-8f65-af51-b0c3-a907f414e0c7@amd.com>
Date:   Thu, 5 Jan 2023 18:16:32 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 07/11] sfc: implement filters for receiving
 traffic
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
 <20221207145428.31544-8-gautam.dawar@amd.com>
 <CACGkMEsgJCniBiggqX4V+quhBY-Dj1Jnr7H+YD4w6gESOX1SmQ@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEsgJCniBiggqX4V+quhBY-Dj1Jnr7H+YD4w6gESOX1SmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0055.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::10) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|BY5PR12MB4084:EE_
X-MS-Office365-Filtering-Correlation-Id: ffb2f67d-4465-49a7-59bb-08daef1ae9eb
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FC6LAYGVUJIZmw0/f7SYtTwn7I1U/qDAYeZd13n72osjhhktWCMIWwC+12iP/5u5PxR2uGqRyrboAK4OF8uJRxXYFYgNUu3ceB/FKoupSrOV4SQN3HNLxC2l+Ne6nWxgTuy1hcfwvOYBp4Vss0bJM05CoEuTuEoo2XBQTZa/TjDMcnSWiSWK5j0IH3anEESaVfLv0iLGB2L9GY1N7VbF1rr1+fxKL7Ag7fSdVZ14Pgu1CghHGokOvQjZw/vriWPz3X7vyXnNmC9a4tPXAbiy9VVI0Paovzbl+rE6audieuVVOx/1QIjmpvp1WRntM0DSGy7f5ZAlYSNGe3rfPqEF1bGOOoIx3GPf10kHdPlJnfxvezpgj5I4TDSEalu/1DPcwL7y3tQdAWE+yYAVBq7Amg99AIx+s23tjaUfiXScAsbG6oabh6h0KMoPTvwgG7BhRNyvykaFThrFhHCHTpcZWnlxVrhsLI3QOYNOWyYTww+DE7sxghIv5ruFze8omVfnnED4bG8I1u7JSZPh2r3Uy07YohvZ6qrDO8lHLoka8Nzbj+66XgBN7HSGWbAFxkRpyBdwZpPdSKYI4ARIXooZQLN49WVojLpkLJgFqffY/3Z5SwT6mstWLBdHxUqEK0Zsi93F6gdmfYV4clfaECKYS0Rd+6XQ4/3BgcQyT1zCkk+/bfBSfjBAsAvFvYCjzv61E6APJBXth6zHxmcB8NGvAVdP+TJ31jh4gVNUEE7wrr8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(451199015)(83380400001)(2616005)(6512007)(26005)(186003)(53546011)(6506007)(6666004)(36756003)(31696002)(38100700002)(41300700001)(4326008)(8676002)(7416002)(5660300002)(2906002)(30864003)(8936002)(31686004)(316002)(66556008)(478600001)(6486002)(110136005)(66946007)(54906003)(66476007)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckhyRkw0TXN5QnJsMmhqYkpmaXp1WkNuZk9acjVYMFlJdWkrNlo2SFZSc2hp?=
 =?utf-8?B?NEVTT3FyeXVZSHNDZityQ2tIY2Jra0JoUGhZSTZnSjFWM0pQaEk5NzdwRlB6?=
 =?utf-8?B?ZWdadG02QmJwTWkrWW9IUEVvM3ZkbTdwUlNoQmw5QTZqM3VhUndJZno4Z3N6?=
 =?utf-8?B?N3liMmZIQjRNcGZObkMxNGloZ0N0RWEyS200R1N4NFBDZGF6WjNzYk51b2lk?=
 =?utf-8?B?dVBwMGtCaC9sdWNrYlNoRkdIVnNMdDRyYjBZTnh0Tis0RnZDelovLzRXV0Fl?=
 =?utf-8?B?eFBObEhMUzN3OFJ3cStxcXJFQXZOU3pnYVd0bzIyb1VycXRPdThxQmpGdjBO?=
 =?utf-8?B?eGhqbHg1VjhaV21XeGtGazAwRjB5VlNNbm5hTkRPVjY2ZXBFUVpNMTFrSUtp?=
 =?utf-8?B?Z3RxbjJoTVRYQ2t0bFBQWFlTcmhaeU5vWkdHZXZETjdOeTRFY1hBdDE2M1po?=
 =?utf-8?B?aUo4bWtEZXhGZjRHN1d0N1VWY3IyRlNzWk9OYkVrOW1NcXlNWjkxLzNXdERR?=
 =?utf-8?B?eHVGcFNSZVpjQU5nNW8vYklUQURXWU1YQUg3WlRNU3lOd3dRRnpGMitmcTlJ?=
 =?utf-8?B?Uk12aXpuRWNKWE9COE9rMDFiby9SMlR0NklyU25tUXB6QWo1TGtsZnNxV3h1?=
 =?utf-8?B?c29NMmVzcnEvcE1KN3gyNzRwUnZVYy9tUHdGdU5ZdDVNNDVweVdta0k2U1Nu?=
 =?utf-8?B?anQ5Q21HeXVJU3lya0ZvYWxNWml3UWhjNFVTdjRQTms4dVlwc1pLRDEyeW45?=
 =?utf-8?B?MHdySlMzZGFQOGgvZ3JJcWs2c25WQjVqTFlnK2FLSTBPMlFSRUptemxiVmxF?=
 =?utf-8?B?V0ZxZ2p4M043OWN2Ly9mTW1xU2Y4R2JYSFFnR29EY3pCSklLa1MxUzBIU0Zu?=
 =?utf-8?B?ajRtYUdKMU5NZFBOS2NJNFFqN1RuOXZ3VThUNC96bXN3cDBjOUl4dWlmM2tL?=
 =?utf-8?B?Z1JPUGFSUnY4WkcwbTA0eE9JQjZYTlJCTDJqUmNFSDExWDZWRTFzUzU2MFFO?=
 =?utf-8?B?b01EYWxyekVsaDc4VjI0dnYxNDJpOGlqdUVVUEJjRGxGVTQrNHdFd29oaEpF?=
 =?utf-8?B?eURrYUM2bWVGdFp2T2FoUUhSRHZ6VEFYVjdJTjlGUmVhVHB6Y2w4eEROUlho?=
 =?utf-8?B?UnZpRjViZ25ZRHVNMWNVQ0lKRTluUkswNWQwZlNJelNCQitNc3A2OXBMSklM?=
 =?utf-8?B?RUFzVStkUXVPSmxUSFZZQjhHNjRORlAvcDBYWjErL1NYVVZqSTdhcG93ZSsz?=
 =?utf-8?B?T1UwdXU2MnlrTk5CM2JvMWpUUjcrcGF2eVlvNXU5S3RoYklkRGxOallqVE9K?=
 =?utf-8?B?MitLYXBaUTZTNGM1SlUzTFhwa0FlcTAxM05KWWk2ZVBWb2N2SUZyT2I3Q1Zu?=
 =?utf-8?B?ODR5b202emI3MlRMUUVFRDFjSENvQ1I5dlhDUzJreXZ3d3U4T205RkF3dGlE?=
 =?utf-8?B?ek81Sm5aNUd6UisyTFJRbTloalRlR3Nob1pzTkRMOUVINFRUWU5UR1hZRFFR?=
 =?utf-8?B?L2RzTDF3UnZ1eWpSRkJsWTNIRzJwM3Z6QUxXelBSNzl5Z2xJQ1hYbGEvM2wz?=
 =?utf-8?B?L3B6QUszZDZaVFRTQ0ErZk04eFFXU3gwVTV3S3NyMlh4WTNoR29aamlzSk5L?=
 =?utf-8?B?emcwQ2Y1TE5objR0ODFGVHphSjczb3hsSXl6aGNjZ0IxVTBTUGlVQ1BkREFD?=
 =?utf-8?B?ZnpER2ZQbjRlUUl6T21Hd3FsdXBzdStqaG1sOXVzUjRndXB1N2dudDNIZVBY?=
 =?utf-8?B?Ukc5T3QxTi9BOEE0RVpXVTNMZW15N0FZVE1haTUvbnZnQ1IrWklzbS9ub2ZC?=
 =?utf-8?B?K25RMkFwMDR2TW9sWWNVdTZCOEFOaUE5QjhwREtvcTVCb3lCL3NQajQ1dUcv?=
 =?utf-8?B?MUJ1WGZaaWZUSWNNeXN1UnZoeHduRTBuMjNlVlBsOC90bEs5TDRpYWhubkN4?=
 =?utf-8?B?TURkd2JNZ0Y5WmduOGV2TUsrL0xpa1lnT2ZEOXBaczdxQTRwRW5pK3pzckxC?=
 =?utf-8?B?SGxVdE5IbUlqSWFtNndBdkowSzBKZVViTkl0ZW02ZUx0dGl0dUlkajRNMGdD?=
 =?utf-8?B?TGtyVlVyYTg0YVpOWlFVbkR5M0RBdGJEQndyUS9XZGkzZTg2MkxQYStoRXpi?=
 =?utf-8?Q?6cQcqip0AO6SfUt4QnWgEwW9o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb2f67d-4465-49a7-59bb-08daef1ae9eb
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 12:46:50.0768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74dNIG3QdDA8B9vfPBxrw5pyxWGxBadjs3AMDv4D8Z6lAqz30a5mqc0z3WGQyjM9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/14/22 12:15, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> Implement unicast, broadcast and unknown multicast
>> filters for receiving different types of traffic.
> I suggest squashing this into the patch that implements set_config().

The patch that implements set_config() also implements device level vdpa 
config operations. I think that squashing the filtering support (this 
patch) in to that patch will make it unnecessary long and combine lot of 
unrelated functionality (except the call to configure filters in 
set_config operation).

>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     | 159 ++++++++++++++++++++++
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  35 +++++
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  27 +++-
>>   3 files changed, 220 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index 41eb7aef6798..04d64bfe3c93 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -17,12 +17,168 @@
>>   #include "mcdi_filters.h"
>>   #include "mcdi_functions.h"
>>   #include "ef100_netdev.h"
>> +#include "filter.h"
>> +#include "efx.h"
>>
>> +#define EFX_INVALID_FILTER_ID -1
>> +
>> +/* vDPA queues starts from 2nd VI or qid 1 */
>> +#define EF100_VDPA_BASE_RX_QID 1
>> +
>> +static const char * const filter_names[] = { "bcast", "ucast", "mcast" };
>>   static struct virtio_device_id ef100_vdpa_id_table[] = {
>>          { .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
>>          { 0 },
>>   };
>>
>> +static int ef100_vdpa_set_mac_filter(struct efx_nic *efx,
>> +                                    struct efx_filter_spec *spec,
>> +                                    u32 qid,
>> +                                    u8 *mac_addr)
>> +{
>> +       int rc;
>> +
>> +       efx_filter_init_rx(spec, EFX_FILTER_PRI_AUTO, 0, qid);
>> +
>> +       if (mac_addr) {
>> +               rc = efx_filter_set_eth_local(spec, EFX_FILTER_VID_UNSPEC,
>> +                                             mac_addr);
>> +               if (rc)
>> +                       pci_err(efx->pci_dev,
>> +                               "Filter set eth local failed, err: %d\n", rc);
>> +       } else {
>> +               efx_filter_set_mc_def(spec);
>> +       }
>> +
>> +       rc = efx_filter_insert_filter(efx, spec, true);
>> +       if (rc < 0)
>> +               pci_err(efx->pci_dev,
>> +                       "Filter insert failed, err: %d\n", rc);
>> +
>> +       return rc;
>> +}
>> +
>> +static int ef100_vdpa_delete_filter(struct ef100_vdpa_nic *vdpa_nic,
>> +                                   enum ef100_vdpa_mac_filter_type type)
>> +{
>> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
>> +       int rc;
>> +
>> +       if (vdpa_nic->filters[type].filter_id == EFX_INVALID_FILTER_ID)
>> +               return rc;
>> +
>> +       rc = efx_filter_remove_id_safe(vdpa_nic->efx,
>> +                                      EFX_FILTER_PRI_AUTO,
>> +                                      vdpa_nic->filters[type].filter_id);
>> +       if (rc) {
>> +               dev_err(&vdev->dev, "%s filter id: %d remove failed, err: %d\n",
>> +                       filter_names[type], vdpa_nic->filters[type].filter_id,
>> +                       rc);
>> +       } else {
>> +               vdpa_nic->filters[type].filter_id = EFX_INVALID_FILTER_ID;
>> +               vdpa_nic->filter_cnt--;
>> +       }
>> +       return rc;
>> +}
>> +
>> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>> +                         enum ef100_vdpa_mac_filter_type type)
>> +{
>> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
>> +       struct efx_nic *efx = vdpa_nic->efx;
>> +       /* Configure filter on base Rx queue only */
>> +       u32 qid = EF100_VDPA_BASE_RX_QID;
>> +       struct efx_filter_spec *spec;
>> +       u8 baddr[ETH_ALEN];
>> +       int rc;
>> +
>> +       /* remove existing filter */
>> +       rc = ef100_vdpa_delete_filter(vdpa_nic, type);
>> +       if (rc < 0) {
>> +               dev_err(&vdev->dev, "%s MAC filter deletion failed, err: %d",
>> +                       filter_names[type], rc);
>> +               return rc;
>> +       }
>> +
>> +       /* Configure MAC Filter */
>> +       spec = &vdpa_nic->filters[type].spec;
>> +       if (type == EF100_VDPA_BCAST_MAC_FILTER) {
>> +               eth_broadcast_addr(baddr);
>> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid, baddr);
>> +       } else if (type == EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
>> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid, NULL);
>> +       } else {
>> +               /* Ensure we have everything required to insert the filter */
>> +               if (!vdpa_nic->mac_configured ||
>> +                   !vdpa_nic->vring[0].vring_created ||
>> +                   !is_valid_ether_addr(vdpa_nic->mac_address))
>> +                       return -EINVAL;
>> +
>> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid,
>> +                                              vdpa_nic->mac_address);
>> +       }
>> +
>> +       if (rc >= 0) {
>> +               vdpa_nic->filters[type].filter_id = rc;
>> +               vdpa_nic->filter_cnt++;
> I'm not sure I get this, but the code seems doesn't allow the driver
> to set multiple uc filters, so I think filter_cnt should be always 3?
> If yes, I don't see how filter_cnt can help here.
The filter_cnt is supposed to maintain the total number of filters 
created on a vdpa device. For now, this count will always be 3 and may 
not be of much use but later it will include the count of multiple 
multicast and unicast filters.
>
>> +
>> +               return 0;
>> +       }
>> +
>> +       dev_err(&vdev->dev, "%s MAC filter insert failed, err: %d\n",
>> +               filter_names[type], rc);
>> +
>> +       if (type != EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
>> +               ef100_vdpa_filter_remove(vdpa_nic);
>> +               return rc;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       enum ef100_vdpa_mac_filter_type filter;
>> +       int err = 0;
>> +       int rc;
>> +
>> +       for (filter = EF100_VDPA_BCAST_MAC_FILTER;
>> +            filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
>> +               rc = ef100_vdpa_delete_filter(vdpa_nic, filter);
>> +               if (rc < 0)
>> +                       /* store status of last failed filter remove */
>> +                       err = rc;
>> +       }
>> +       return err;
>> +}
>> +
>> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
>> +       enum ef100_vdpa_mac_filter_type filter;
>> +       int rc;
>> +
>> +       /* remove existing filters, if any */
>> +       rc = ef100_vdpa_filter_remove(vdpa_nic);
>> +       if (rc < 0) {
>> +               dev_err(&vdev->dev,
>> +                       "MAC filter deletion failed, err: %d", rc);
>> +               goto fail;
>> +       }
>> +
>> +       for (filter = EF100_VDPA_BCAST_MAC_FILTER;
>> +            filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
>> +               if (filter == EF100_VDPA_UCAST_MAC_FILTER &&
>> +                   !vdpa_nic->mac_configured)
>> +                       continue;
>> +               rc = ef100_vdpa_add_filter(vdpa_nic, filter);
>> +               if (rc < 0)
>> +                       goto fail;
>> +       }
>> +fail:
>> +       return rc;
>> +}
>> +
>>   int ef100_vdpa_init(struct efx_probe_data *probe_data)
>>   {
>>          struct efx_nic *efx = &probe_data->efx;
>> @@ -168,6 +324,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>          ether_addr_copy(vdpa_nic->mac_address, mac);
>>          vdpa_nic->mac_configured = true;
>>
>> +       for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
>> +               vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
>> +
>>          for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++)
>>                  vdpa_nic->vring[i].irq = -EINVAL;
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index 3cc33daa0431..a33edd6dda12 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -72,6 +72,22 @@ enum ef100_vdpa_vq_type {
>>          EF100_VDPA_VQ_NTYPES
>>   };
>>
>> +/**
>> + * enum ef100_vdpa_mac_filter_type - vdpa filter types
>> + *
>> + * @EF100_VDPA_BCAST_MAC_FILTER: Broadcast MAC filter
>> + * @EF100_VDPA_UCAST_MAC_FILTER: Unicast MAC filter
>> + * @EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER: Unknown multicast MAC filter to allow
>> + *     IPv6 Neighbor Solicitation Message
>> + * @EF100_VDPA_MAC_FILTER_NTYPES: Number of vDPA filter types
>> + */
>> +enum ef100_vdpa_mac_filter_type {
>> +       EF100_VDPA_BCAST_MAC_FILTER,
>> +       EF100_VDPA_UCAST_MAC_FILTER,
>> +       EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER,
>> +       EF100_VDPA_MAC_FILTER_NTYPES,
>> +};
>> +
>>   /**
>>    * struct ef100_vdpa_vring_info - vDPA vring data structure
>>    *
>> @@ -109,6 +125,17 @@ struct ef100_vdpa_vring_info {
>>          struct vdpa_callback cb;
>>   };
>>
>> +/**
>> + * struct ef100_vdpa_filter - vDPA filter data structure
>> + *
>> + * @filter_id: filter id of this filter
>> + * @efx_filter_spec: hardware filter specs for this vdpa device
>> + */
>> +struct ef100_vdpa_filter {
>> +       s32 filter_id;
>> +       struct efx_filter_spec spec;
>> +};
>> +
>>   /**
>>    *  struct ef100_vdpa_nic - vDPA NIC data structure
>>    *
>> @@ -118,6 +145,7 @@ struct ef100_vdpa_vring_info {
>>    * @lock: Managing access to vdpa config operations
>>    * @pf_index: PF index of the vDPA VF
>>    * @vf_index: VF index of the vDPA VF
>> + * @filter_cnt: total number of filters created on this vdpa device
>>    * @status: device status as per VIRTIO spec
>>    * @features: negotiated feature bits
>>    * @max_queue_pairs: maximum number of queue pairs supported
>> @@ -125,6 +153,7 @@ struct ef100_vdpa_vring_info {
>>    * @vring: vring information of the vDPA device.
>>    * @mac_address: mac address of interface associated with this vdpa device
>>    * @mac_configured: true after MAC address is configured
>> + * @filters: details of all filters created on this vdpa device
>>    * @cfg_cb: callback for config change
>>    */
>>   struct ef100_vdpa_nic {
>> @@ -135,6 +164,7 @@ struct ef100_vdpa_nic {
>>          struct mutex lock;
>>          u32 pf_index;
>>          u32 vf_index;
>> +       u32 filter_cnt;
>>          u8 status;
>>          u64 features;
>>          u32 max_queue_pairs;
>> @@ -142,6 +172,7 @@ struct ef100_vdpa_nic {
>>          struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>          u8 *mac_address;
>>          bool mac_configured;
>> +       struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
>>          struct vdpa_callback cfg_cb;
>>   };
>>
>> @@ -149,6 +180,10 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>>   int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic);
>> +int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic);
>> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>> +                         enum ef100_vdpa_mac_filter_type type);
>>   int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
>>   void ef100_vdpa_irq_vectors_free(void *data);
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> index b7efd3e0c901..132ddb4a647b 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -135,6 +135,15 @@ static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>          if (vdpa_nic->vring[idx].vring_ctx)
>>                  delete_vring_ctx(vdpa_nic, idx);
>>
>> +       if (idx == 0 && vdpa_nic->filter_cnt != 0) {
>> +               rc = ef100_vdpa_filter_remove(vdpa_nic);
>> +               if (rc < 0) {
>> +                       dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                               "%s: vdpa remove filter failed, err:%d\n",
>> +                               __func__, rc);
>> +               }
>> +       }
>> +
>>          return rc;
>>   }
>>
>> @@ -193,8 +202,22 @@ static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>                  vdpa_nic->vring[idx].doorbell_offset_valid = true;
>>          }
>>
>> +       /* Configure filters on rxq 0 */
>> +       if (idx == 0) {
> This seems tricky, can we move this to set_status() when DRIVER_OK is set?
For a virtqueue to be created, qenable must be set to 1 and status 
should be set to DRIVER_OK. The current implementation ensures both 
conditions before creating the HW queue. This will handle the situation 
where DRIVER_OK is set by a bad guest virtio-net driver but queue has 
not been enabled.
>
> Thanks
>
>
>> +               rc = ef100_vdpa_filter_configure(vdpa_nic);
>> +               if (rc < 0) {
>> +                       dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                               "%s: vdpa configure filter failed, err:%d\n",
>> +                               __func__, rc);
>> +                       goto err_filter_configure;
>> +               }
>> +       }
>> +
>>          return 0;
>>
>> +err_filter_configure:
>> +       ef100_vdpa_filter_remove(vdpa_nic);
>> +       vdpa_nic->vring[idx].doorbell_offset_valid = false;
>>   err_get_doorbell_offset:
>>          efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
>>                                 &vring_dyn_cfg);
>> @@ -578,8 +601,10 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>>          }
>>
>>          memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
>> -       if (is_valid_ether_addr(vdpa_nic->mac_address))
>> +       if (is_valid_ether_addr(vdpa_nic->mac_address)) {
>>                  vdpa_nic->mac_configured = true;
>> +               ef100_vdpa_add_filter(vdpa_nic, EF100_VDPA_UCAST_MAC_FILTER);
>> +       }
>>   }
>>
>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>> --
>> 2.30.1
>>
