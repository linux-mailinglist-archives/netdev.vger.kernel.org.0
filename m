Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1CF67AACA
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbjAYHV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbjAYHV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:21:56 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144D13E09E;
        Tue, 24 Jan 2023 23:21:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZ3LCBQzgT2bVCsRYzSmoIlqywx06EkfnurLgSkVUbtVtp9Nj84w0JLPufKrOulYwlMuXWjFfzGqRYyxn/GVbGkFiWrip7Yptv5ncPKQu9T+Rzcxe+qkfhftJ7ooxdhi4lvqJssJ0wQQ0IcE5X2tbXMnWpDY4vAdf3a9Wo/FBbSqIi/o236n4nf7CuJ2qlObvPXw7uNU0TpNP0Xt+L4W0O4E596ag2XAXnI8iEBicXFKOfUsA/iK1yDqHiiHdHBea59Ya4qKaCOQqPyAciZS8GikfMaYD6SPZ5jI9Ur1lNY50to3clXlKKvMdmVBYvIaHbn0iE0xF38hCGWhadJyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEMPJ7O/U5FLaq5tlZbC9xPHbphUbcH9PBP0vpSgYg0=;
 b=dqbIzYROWGuVJjvsgW3LiPAWEvGVRzUkoxGHpbzlno1vZsn5KN58snoIIBOtTZn7fR5a8+ecMuYvfrrq6WPOgSJ0oIWJCygxWzRXb1vFvubKNeyHBWBNyKkBmSJW4yFV/IjdjpegMCPH93umcAvvDphrUcaOcXqnHsg3lLuBnXKUDyx0jr6FIdFLOC6dabm0R6eWjFLXgua2Jpmwr76QEFe6wMpbcqfWXtoKsfsMpR37hNjOv+f7Do68wBfHSMAzktlUc0jRQhZwcodlLqtESgkhgMVSzxJiWyyph3WkBh+N84cfyLt8WQ8xebi1zsFqJ947qzRZVNqzi4aDqMRNjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEMPJ7O/U5FLaq5tlZbC9xPHbphUbcH9PBP0vpSgYg0=;
 b=nmxF+lQvN0CiPPesRYngmSdiNjzFosbfXWMlP0/TSZ5AQYGq5JecpshrkfKberdS6n1hUSF/Jztpl5ZYlJZ8FQNXwt6Uni69ZrjvgJeE8IZglwFSkKVU8k8m2MtihRNEmnKJllNgxsrMLM224avfmVYn5sjxIYBHfQZ/72lBaDyrdHXthWOYPSxtVVHZ+1bAF2NfpaYTDXRIlib6EKXl5yhbui6+oFK5kCt8EdMBEoRYs6F7vejNDenPZlDwvnXVs9iWjeNi/OqG3PsbF1GnsBllbtGe1A6ZFVlwCGcgMv3b2r7le6mxij6PXRcj+ZX/A4iR60Ktik7HGmjrYNeu8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5401.namprd12.prod.outlook.com (2603:10b6:510:d4::13)
 by PH0PR12MB7932.namprd12.prod.outlook.com (2603:10b6:510:280::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 07:21:52 +0000
Received: from PH0PR12MB5401.namprd12.prod.outlook.com
 ([fe80::87e4:2a28:53f6:1b89]) by PH0PR12MB5401.namprd12.prod.outlook.com
 ([fe80::87e4:2a28:53f6:1b89%9]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 07:21:52 +0000
Message-ID: <eac88aac-1a96-c8e9-0bec-cbff3480aad7@nvidia.com>
Date:   Wed, 25 Jan 2023 09:13:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/1] virtio_net: notify MAC address change on device
 initialization
To:     Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Cindy Lu <lulu@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>
References: <20230123120022.2364889-1-lvivier@redhat.com>
 <20230123120022.2364889-2-lvivier@redhat.com>
 <20230124024711-mutt-send-email-mst@kernel.org>
 <971beeaf-5e68-eb4a-1ceb-63a5ffa74aff@redhat.com>
Content-Language: en-US
From:   Eli Cohen <elic@nvidia.com>
In-Reply-To: <971beeaf-5e68-eb4a-1ceb-63a5ffa74aff@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MR1P264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::9) To PH0PR12MB5401.namprd12.prod.outlook.com
 (2603:10b6:510:d4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5401:EE_|PH0PR12MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: dabc71bd-b25d-41ed-50b3-08dafea4d26a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iN7Q7e77JbaHbiRIyoa2WZ4d1xX+VpeRqMRUMHCc6bWm3awrfKQwATSzchqxqKytsFeETGDfVCNIOTqZsVLq+J2F5baI9XQD6B4jyoIa5W3qUXj0unlY85uu0xxrkG5hcBA1z/UQO/Uf8AOtYucZMnUVFoyBpW6eCKgztgYMh4CnCX07tSsOoH7o5UhBmWjAKalJhhc4S6J61eNXiAOO5LS6V2shf1mICkuQt+/jaY7U1KlnHHEAUYik1AlWBpw0T4U1XKtHUTm113OxObuaS/3nvSwDwkeIgJyTkrQObkvr7xG1Fxjtt6XHN7iH7lAbQ41A8YrYxVGYzjVNdwhbcEr/2OAJTMncCCUfLyf2btt4mRHPRxCjTPl/Aq27ib5y5rLAuDJk4QuHC5QAzeqpDIqCaJO6ADrEa3izyaHAwXaR6hABCci4DlEjDaCWYpIRyp6ucZSHbiRFvol33sTXG9hYPpcCzf2JgiVaEs3FtduO6PRd9exCNWg0Nfnhb+WLxnTU/Ee7WvWc2LvQa2wgSoYfKyhGo0EiTAMe/PiPfa0txgNg24E2l/ehwf8fE5KpkqeapcS2KNJjSwKECcKA2OutVlSvoYUElqzmMOqH+llN6jEaNZaYK6EJhmKoMAbdbMGXemdIvpTzT6sGdq/IkY99hWdltYOCUyaZ4h7Yxqzo1U2bzmnohKL7Tb+mQ268tyoJmt9eOC86VTHG5cLaanJiv9+PEFcmmHv2mtKRXyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5401.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199018)(6486002)(5660300002)(7416002)(6666004)(6512007)(26005)(2906002)(36756003)(478600001)(316002)(66556008)(66476007)(31686004)(8676002)(6506007)(53546011)(4326008)(66946007)(38100700002)(83380400001)(86362001)(31696002)(107886003)(41300700001)(2616005)(186003)(54906003)(110136005)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWRUQ3Q5eVA4eUZ4aURBcFdkbXAvaTFVTy9RakJIOUZTclB3WlpSR1MzcVl0?=
 =?utf-8?B?K3M0MmRnYzFIbU93Y1hKb0FtYmExMHFGV2VBMVdUVmVmN2xnalVrazlORlZS?=
 =?utf-8?B?R3FONURQTjFISlBTZ2xUWGJBeDJuYW9wSHJIVTczeTRreVQwa3RSYzVleDdT?=
 =?utf-8?B?MVp1RXQ2TFBmcDFjOGtHK1BqUkxZZHRaZXlPODRrRktPRytXNkZHcmI2OEt3?=
 =?utf-8?B?aTBFdmRPM04vTjk2VWhxNE00dFFxT1R2VzFkazlLNmlGa2tmZGhGcGl5bDF2?=
 =?utf-8?B?aXIvekxjNU1nMDFtS1JQVm9keDhVUkNHcW1IN3V6Vm5qc2xPa1Fmd3JzNjZl?=
 =?utf-8?B?MFpiTURnMStpQjcrSUhZWnpxK25Lc2xwV2FEOWZIZ2tjZVpmUVBVcnYwc25D?=
 =?utf-8?B?dENZendnYys4ZlRIQTF3aExJekJCMDVyU21VWUtZSzVqUnY0UG80b3lVL1Za?=
 =?utf-8?B?WXcwZEFMZC81a2QrMXBaTERqZGxBSk9TRXA3T3JOVXVVUjhjNFVhcU9Mb3Jl?=
 =?utf-8?B?LzZBYjIrd3gveFNHZ29FVUhFSDNYd1pMNmFXeWM3TUlHa25TNDdJdU9udFFX?=
 =?utf-8?B?UjdBaTZvT3kvTUJxTDFaTU1PMGNuTk9hTlhUNVErR1dWTkpMeklmbEFjZVlH?=
 =?utf-8?B?SkxLQ1BjUmR3MzdyaE9xUytEK2wvSnlZVmhRbEZzTTZhTStxUEI0Qi84TFBs?=
 =?utf-8?B?S3psV1FCTHBxS2lMWURzWFN4LzFJcUJyU3hUVnhLcnhJVkFaZzBjUVFVSHRF?=
 =?utf-8?B?NkdDN25XUnk5WUl1ZE8vMzJ5MXEzN05GeW55UUoxVWFTQitMaVdIYit0Nzl0?=
 =?utf-8?B?TDZoTEphWENVN3NOTnd4OU9INFYyRXRQOFJNYU1QUDlGOWpHNER3Ynk0NDJQ?=
 =?utf-8?B?Z3BVbFNvSVRUejZiRkhybmRNOGFZY09TS0RZSUtWbUE5cEQ4U1d0WnNpc05m?=
 =?utf-8?B?bkt4Vms4YXo4ZjBqbDhRZmF2UVh2enlHb05lMXdidVA3RmdnVkpHQVRteUhj?=
 =?utf-8?B?dXdyOVNRekE1YlFCK1BFOGJ4bmFRN3JQcmpvNzBMQ2pWVU5GalJCWnlQQlkv?=
 =?utf-8?B?enh4VGFIWVFJSzgxaXFQaVdOU2lvSC9UTFR6Z2hMbXIvMzF2NnNQOHkrdDE2?=
 =?utf-8?B?eUdydnRrUjdXL3V5Sm1UckI0N3RLWU12bVMzY3dibWFZQm01T05Ca3NOeHVF?=
 =?utf-8?B?WG5saDY5VTNQY1hNSkMvcE90OHdqWFpsY2FVVHFIYld3TE1jdHdyMk9mYkJk?=
 =?utf-8?B?dUNMb3BDMmRWNXNqMmFUM3Ava29ad1hXOTVWZTlPeGczZno2WGZzeHpuTXZT?=
 =?utf-8?B?ZnkvVk5UZGJ0Z0tCa1JGRHBvbTkwVVFCQlhYTUlEdWxtM2JLejVVT0F2YnI3?=
 =?utf-8?B?Qjk3NGVIazM4eVpaRDRqOC9ibkxnbEpESFRySU5GS3RZUURiWFZkR2N3UHhm?=
 =?utf-8?B?VWNkbEFWNURIUlNkQzFpK1FvaVhSQXFwNE9uVFI4T2ZNbVFQMHVIZGdrS1RJ?=
 =?utf-8?B?TTBtendVdWtnMWxiZFIxUXZMSEFXM2YyQkROZTN5dnZ4OUdsLy80RDBnUGVK?=
 =?utf-8?B?UUYzbkRmUlJrQ2x3NVYrdmFhayt5SXY0VnlmZENUakRVcjVIVWw0YlFkSUlU?=
 =?utf-8?B?MjVNck5tek82ckVlWHZYQWNLSDhZNUYyMWcvMXRQa2tPeVFDMnFONE5rTWNI?=
 =?utf-8?B?eEJvdmt0blVvUXF4eGhHZGJoZ3YySWdqdEY1ZnJZbVI4VmUyRG9HOEFSS0hE?=
 =?utf-8?B?MDk4RHRscDJIQzJzeWtrMXpVWVhjbUR1RlVBd0pzVld3Ym9KT21EL1hWc1pW?=
 =?utf-8?B?TGp6YlgrZnZiTnZuTzMxbFJaOUxMakd3T1lGUCt5dW5yZ3MxbHZFZmxZQ0xL?=
 =?utf-8?B?UnptTEw1Qmd5RXBvblg2SzdzZVFvamJhbGZpdnhkRUw0T2p3bUphZEJENGl2?=
 =?utf-8?B?SE1GeG9IKzR3aEZQN2dDNzkxaG11KzdrYVVhSEU3emsxeFVjd0hoN3E4V1Vw?=
 =?utf-8?B?Y28wUkRpaWRnU1lmVTdWVmFQVzhmR3F4ODRRTHJIdWRudnpqYXZmejFFTXZQ?=
 =?utf-8?B?ajZvaGVCcjFON1gvbi9CYmtHWDNSUlIyUDFsZ3BoMmRPeDBJYXkrZ3lZOHUw?=
 =?utf-8?Q?6E2JtvrJ0nw3TwyB65SAzFH3x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabc71bd-b25d-41ed-50b3-08dafea4d26a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5401.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 07:21:52.0242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GFrl/DXjWWtDdvCQaTany3GefDcVMVAtx+exJ9YPoWWxYzIKd/TEaY2ZkKvXsS9n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7932
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/01/2023 13:04, Laurent Vivier wrote:
> On 1/24/23 11:15, Michael S. Tsirkin wrote:
>> On Mon, Jan 23, 2023 at 01:00:22PM +0100, Laurent Vivier wrote:
>>> In virtnet_probe(), if the device doesn't provide a MAC address the
>>> driver assigns a random one.
>>> As we modify the MAC address we need to notify the device to allow it
>>> to update all the related information.
>>>
>>> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
>>> assign a MAC address by default. The virtio_net device uses a random
>>> MAC address (we can see it with "ip link"), but we can't ping a net
>>> namespace from another one using the virtio-vdpa device because the
>>> new MAC address has not been provided to the hardware.
>>
>> And then what exactly happens? Does hardware drop the outgoing
>> or the incoming packets? Pls include in the commit log.
>
> I don't know. There is nothing in the kernel logs.
>
> The ping error is: "Destination Host Unreachable"
>
> I found the problem with the mlx5 driver as in "it doesn't work when 
> MAC address is not set"...
>
> Perhaps Eli can explain what happens when the MAC address is not set?

If the MAC address is changed without letting mlx5_vdpa know, RX packets 
will be dropped since they won't go through the receive filters.

TX packets will go through unaffected.

>
>>
>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>> ---
>>>   drivers/net/virtio_net.c | 14 ++++++++++++++
>>>   1 file changed, 14 insertions(+)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 7723b2a49d8e..4bdc8286678b 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device 
>>> *vdev)
>>>           eth_hw_addr_set(dev, addr);
>>>       } else {
>>>           eth_hw_addr_random(dev);
>>> +        dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
>>> +             dev->dev_addr);
>>>       }
>>>         /* Set up our device-specific information */
>>> @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device 
>>> *vdev)
>>>       pr_debug("virtnet: registered device %s with %d RX and TX 
>>> vq's\n",
>>>            dev->name, max_queue_pairs);
>>>   +    /* a random MAC address has been assigned, notify the device */
>>> +    if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
>>> +        virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
>>
>> Maybe add a comment explaining that we don't fail probe if
>> VIRTIO_NET_F_CTRL_MAC_ADDR is not there because
>> many devices work fine without getting MAC explicitly.
>
> OK
>
>>
>>> +        struct scatterlist sg;
>>> +
>>> +        sg_init_one(&sg, dev->dev_addr, dev->addr_len);
>>> +        if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
>>> +                      VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
>>> +            dev_warn(&vdev->dev, "Failed to update MAC address.\n");
>>
>> Here, I'm not sure we want to proceed. Is it useful sometimes?
>
> I think reporting an error is always useful, but I can remove that if 
> you prefer.
>
>> I note that we deny with virtnet_set_mac_address.
>>
>>> +        }
>>> +    }
>>> +
>>>       return 0;
>>
>>
>>
>> Also, some code duplication with virtnet_set_mac_address here.
>>
>> Also:
>>     When using the legacy interface, \field{mac} is driver-writable
>>     which provided a way for drivers to update the MAC without
>>     negotiating VIRTIO_NET_F_CTRL_MAC_ADDR.
>>
>> How about factoring out code in virtnet_set_mac_address
>> and reusing that?
>>
>
> In fact, we can write in the field only if we have VIRTIO_NET_F_MAC 
> (according to virtnet_set_mac_address(), and this code is executed 
> only if we do not have VIRTIO_NET_F_MAC. So I think it's better not 
> factoring the code as we have only the control queue case to manage.
>
>> This will also handle corner cases such as VIRTIO_NET_F_STANDBY
>> which are not currently addressed.
>
> F_STANDBY is only enabled when virtio-net device MAC address is equal 
> to the VFIO device MAC address, I don't think it can be enabled when 
> the MAC address is randomly assigned (in this case it has already 
> failed in net_failover_create(), as it has been called using the 
> random mac address), it's why I didn't check for it.
>
>>
>>
>>>   free_unregister_netdev:
>>> -- 
>>> 2.39.0
>>
>
> Thanks,
> Laurent
>
