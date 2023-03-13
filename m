Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E006B6F82
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjCMGhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCMGhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:37:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AE13864E;
        Sun, 12 Mar 2023 23:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loo++zQQ2pvgnYcHQ0si31WwDawqSr82Ukz3dcCVTqIWDxnZHrCr84il2PV6zcAMq9QErrxAPIeVJB8c8+J9X2s2p4MTkV0Hs2dxWPtriQu3YdbOvQ3CjSbLdIqDmd+oZlcLHJmbgfnsEyfiyoJiY9+ERw1o4TGfsJDbwJoa2nL6roUUwwauFC55Aqg6UMxZGajVYHT2rD21GgfIATYjlrVvOfaO5jHwLm1rTjxdaTu3UhZFSQSjoGKKI4KGk4cu3UqPHMY6aLqrhczgTW3Ug/W/3mLddeARD/Gowq4wYFnMYcubheVl4TqGl6aHg1EFdJuwujLh5ENINqFTw76Xvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIjiUBQ7edBQ/gKeINgZzS8TnKtUXrrLrwRywyAQpSk=;
 b=hPcpMprjO8dVScqYF1HkWMfI+eCc0dBsIlIHUahA4lia9qXKXqF0R6yERBs4GMilGdtS8wskTwmc4o81bd8UV/l7UT9+TB8gBQ4oiP5C7QYDRvPLpdqvB3gc7IXIyad6WvESw34z55fQOI0HbTG8iMyrMbvr1FKiwFCbVzO1RKmPfQuDMc7w65TnTsjgIwoKY37ATfxBXVm/IMQ9pxSEN8F4YrIZQ+92xkA9y0lC7+PNDSJFXEDk2qdTNdoG/Vba7wNmPwLqPvLNxyrFoBPJ1m0gZflDF3CjlvzErVemfuefdBlhRCzX7wy4z92VnrNCyQ2LTztP/vCfozyePvISJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIjiUBQ7edBQ/gKeINgZzS8TnKtUXrrLrwRywyAQpSk=;
 b=Xw6SWr2i24NpMgN6nDMcie3cHs+OXZF36VbKDj6b8rL07Upys/p+fxtGO8fkalG3/oBcU7tYx5UPT8qyO7I2Queh7FMdVRjMLa2yKZsueSd6eIKm+prW9PU8u2XlKIsjrZDdmFTsxJFemSSOl8Y2B/zmNSAX3EucGpwY2rKSzik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by PH7PR12MB6668.namprd12.prod.outlook.com (2603:10b6:510:1aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 06:37:29 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 06:37:29 +0000
Message-ID: <e563f5a5-2d1a-fbc9-be2d-986b050c6548@amd.com>
Date:   Mon, 13 Mar 2023 12:07:16 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 13/14] sfc: update vdpa device MAC address
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-14-gautam.dawar@amd.com>
 <CACGkMEuY4KoiZKswjMDNfoeUTqUagXye-_qe-iP2JJq0schObQ@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEuY4KoiZKswjMDNfoeUTqUagXye-_qe-iP2JJq0schObQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0008.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::20) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|PH7PR12MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: c5efed3a-db24-4db9-4495-08db238d6a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A01gx42QElx3ZBbvx7gSxE08PX54PDORKV9RlaJYiXufIJiM9QTTJbZBYOU1d574yA4mPS3VU50u4RQ2wCcNQOB5/XfQ5qR3SIVWeB5SVAxgJUBvmt/lzc4RxUppRquWIUzePUWSd0+R8C++FsC+SG9sh0z6aZeM6wfeN/zkbSXiFl+RMOhcZlLJLzsmFmU8mDieWEG9ee9VgkVklj2/wnfVkzYyV1ltvcWgpPRS2RCSkTcekIqCoPc3NByy9Cz7+ajlxzpeJ2vtdcMBiA4d7NQkfs6ncwLr5COCAUVqe2oCfnvT2b6QbKcJ6yFSBCCzkRr5roOsc/NgYZAKdDWIO+aPNzDVSf+59lwgO6Bg5a/RR66vkIK8Qzjb1SzjWHDM3f+FmrMaA+6t8qtuidI/sIdiTwQgb9wLdpblpqXbOgaj5p5YbM3nL1eZ6VebX7l4VdrYsqciA32MPyxHe8+fQhM7qBxh2mXnfgKL0i8p7pRmqdak+sY2fMo9Z5qXvg/nqjfmqEbjBlo7cC445DnCwcqGjuiOEqaCik4Sp+GBNHHu+ol6OFT9v4Z62eNFeIfdbWtUoskmfR58LZg1nrRxNgtSu08+NyB934/6lwgxieltttFxkYkO7YB9yQXWMAPb/vLZ129LsgH/nsOpeaDijDt59Ftv7BMdi+npZHTo20Fx4gTcDVd2zfhO7WjxPAdnZKzhtkmP4hSFnWcdzaQlKNfnL3+1cF/o41/wsu7wS70=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199018)(15650500001)(8936002)(2906002)(41300700001)(31686004)(66556008)(66946007)(5660300002)(66476007)(8676002)(4326008)(7416002)(478600001)(83380400001)(110136005)(54906003)(6636002)(316002)(6486002)(36756003)(6506007)(6512007)(26005)(53546011)(6666004)(186003)(2616005)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTBEYjdTM2x4MUJWcWRuT3M5UU1RbkxKM3paUFlnV1pTTVBUMU9zTjROajh5?=
 =?utf-8?B?OGZxTHdHUDExMzBoRHVIQ0E0R29yQmtLbTBZODN1amR1b1ZxQUNWTUU1QWNW?=
 =?utf-8?B?aml2TG9Ick5Qd0g5SG4yTUNxbm5OcythdUxpeFliaHIwZEt5azdUdlF1Ukk5?=
 =?utf-8?B?SUp6L3dITE40ZHJHdHZyaFAwZDZ0VjFSQ05UTVhaTUY4VjcxTTVmeEp5dFNt?=
 =?utf-8?B?Q1NQNTZ2Uzk0NVBwRnhPQmg4Zjdma3ZmMTJIbHM2UTVSVnhiRXQyTUN0OWZq?=
 =?utf-8?B?c0llT0pETlNwaENXbXRhZmRCU2VRbFlBYzJhMkVKSEhOcGs5TDFiWG9qZGEw?=
 =?utf-8?B?R3FKZ1AxaHRFKzdWL0ZoNWpTWElBd2FsVjJCUG5MWFpOL3d1YW5JVEY2OS9U?=
 =?utf-8?B?SktralcxbWI4ekV0ZW1MTTM5WDV6aUUydVR1ZUxRVlBGRTJhdFZnR3Uzdlpz?=
 =?utf-8?B?STIxQ043eDNndmdseWVSOGlwVGxaTFo3TXdxS25XUjF2TXU2aVdFV24vTHNO?=
 =?utf-8?B?NzQzTlpITGtTYmd1cUozYzBhNlpTVURUT29MenNtZzV1TVYvMWd4RDZvODEy?=
 =?utf-8?B?ZWpLaXIxNWhMemZxSWJ2aTkveFdLRVhlZHVFckxmVFNBdlM5RS8vYmVucGg2?=
 =?utf-8?B?NGFwR3NSRFV4WmtadWY5UUVzcUdWNFd6c0xyaDhVKzRlL2lEdzVDRjF3WlFr?=
 =?utf-8?B?Q2xabW4vM0JocWtJN2xSSjU4WEthaFhXbSswem5SL3cwajZXRkFzZ3RjUDlv?=
 =?utf-8?B?VEdpamx4bG95Q1Nmb0YxeGl5UUVQazZydktOc1NES1BEVzM1VlVyVDBCOG1M?=
 =?utf-8?B?bWdQTjBSSVNmV2hEazV6QVhnNUtvU2orWGc2T2s0eEVIRkZlallKdmFrT1Qw?=
 =?utf-8?B?NWVsdXdTNXhTU3FmL3RJeWZMSzZOQjFGY1hEWjNkdjF5MzFZbEpqdFgwekkz?=
 =?utf-8?B?RnVNZFYwc1Q0OTVmaFdaMEtaOUR1KzF5dnFqYlF2LzVPK0xsaVdwMW10U1V4?=
 =?utf-8?B?TjhNL3BqYXZpOHFRdTNCSDFkNW53WWFBMlByUy9jaGdsNHhiL2hreGY4NnNM?=
 =?utf-8?B?WEFTUmx2dElCNmswcWJpODYyb3VVRDRSUE9YWnNqak9DbW5EQVRvMFNUOHRJ?=
 =?utf-8?B?NTE0K1pOajdZeXRoUHJ5VkxIYnZYaHhuOGJFWWR2UE9FVVllUWFyRTZRL28w?=
 =?utf-8?B?L0VJeXNJTkMzUUhlTDRoNGYvVDRxbDZLL2hXS0Q2dVJ0YWV1aDY3YnNSeWcy?=
 =?utf-8?B?MHYrUy9kWFFpTEZJOXRjZ241SS9kMG5nVTV2ZEhIWndvMUU5ajFMRUVsM2VJ?=
 =?utf-8?B?Ym9nb0l5OVJQd2dHS2xTUk9zMlJYTnBQODB1MU9ubDU2MXNyV2d0djQ4WHJ5?=
 =?utf-8?B?SVN3cnNRTUJJYlUzMS9NZkJ0YTZqUFhNWVlTdUVzeGlTd1hjbXZnTGpMOW9r?=
 =?utf-8?B?Nnc4TVBZbG9xVUl4K2JLMjRRY2hpUmg4WUVYaFV4dzArT3F0OS8wZHFObmlq?=
 =?utf-8?B?YXdObnI4TUxhS2R3NmVlR1NpYVJMZzMxdmJxcENCYmJwWTZPUnAzbGVtcVMr?=
 =?utf-8?B?aHRIcmRTdjdJcFNkR0xRNjlySVc0VGF0Q3h0TDc5bHlpZW9ITFZaS1o5TWxO?=
 =?utf-8?B?bHh6YW5RcktnaHpFblJobTJkNTgzVHdXcUYrUWxjeUNDcEs5SUZCSkFzRExl?=
 =?utf-8?B?ZlRDZWQ0KzErdFpiWDk4MWtZbGZQZ0gvOC9BR2s5R1VCTDNFczJiWGJwR3g0?=
 =?utf-8?B?bGwybk1leFFCcm5FYnNjOWNGaVhXMXFvOFppNFNmalpWaWY0Q0Z6S1A4dkRC?=
 =?utf-8?B?S0hjejZiVWZ1TjRmdlFnUGNqbHhQeUlRMWU3M1Ywa0pTa0VCWnNxNVd1QU9F?=
 =?utf-8?B?MzhZWHdTU3NDMWZVYUlnankyVWV1dENWQWszMTBIc1VGNko0UngyNlZ1T2s0?=
 =?utf-8?B?NUhwNzdaTU8vV0ZkWm9rMys0Z0tpNW9acElKZmV2SHlheVArUFg5RURtWm5Y?=
 =?utf-8?B?ZE1UN0R1cUZKUitWcVM5d3hFNlB4WXYzdnZmZUNtdXBGRWdiL3cya1VNc21O?=
 =?utf-8?B?TXFweUtrcGFSbnF6SHZIZGkwTENpbkswVERLZzZEVXpnelNTUm1KSGZYTHBB?=
 =?utf-8?Q?wJqbnG4ssECMsPNsQgHm4N/eU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5efed3a-db24-4db9-4495-08db238d6a72
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 06:37:28.9897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89Jh9h8DtXomV4u6k36INbVEx0RNJBEdBOp8xsoLISGZZAnVSPYLciQVLS4qyE9G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6668
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/23 10:35, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Tue, Mar 7, 2023 at 7:38 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> As the VF MAC address can now be updated using `devlink port function set`
> What happens if we run this while the vpda is being used by a VM?
IIUC, updating the MAC address using devlink interface requires 
unbinding the device from driver and hence updating the MAC while vdpa 
device is in-use won't be possible. It can only be done via control vq 
VIRTIO_NET_CTRL_MAC_ADDR_SET command, when available.
>
>> interface, fetch the vdpa device MAC address from the underlying VF during
>> vdpa device creation.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_vdpa.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index 30ca4ab00175..32182a01f6a5 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -272,6 +272,18 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
>>          vdpa_nic->net_config.max_virtqueue_pairs =
>>                  cpu_to_efx_vdpa16(vdpa_nic, vdpa_nic->max_queue_pairs);
>>
>> +       rc = ef100_get_mac_address(efx, vdpa_nic->mac_address,
>> +                                  efx->client_id, true);
>> +       if (rc) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: Get MAC for vf:%u failed:%d\n", __func__,
>> +                       vdpa_nic->vf_index, rc);
>> +               return rc;
>> +       }
> Can this override what is provisioned by the userspace?

No, this was carefully avoided by overwriting the userspace provisioned 
MAC in ef100_vdpa_create():

         rc = get_net_config(vdpa_nic);
         if (rc)
                 goto err_put_device;

         if (mac) {
                 ether_addr_copy(vdpa_nic->mac_address, mac);
                 vdpa_nic->mac_configured = true;
         }

>
> Thanks
>
>
>> +
>> +       if (is_valid_ether_addr(vdpa_nic->mac_address))
>> +               vdpa_nic->mac_configured = true;
>> +
>>          rc = efx_vdpa_get_mtu(efx, &mtu);
>>          if (rc) {
>>                  dev_err(&vdpa_nic->vdpa_dev.dev,
>> --
>> 2.30.1
>>
