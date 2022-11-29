Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A2E63CBA6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 00:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiK2XQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 18:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbiK2XQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 18:16:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2052.outbound.protection.outlook.com [40.107.100.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAA91A21A
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 15:16:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnxPZmwOFRIf8NYFPtObi6YQS86vy0OF9xm6zxnGZ1Ndg5q7uMeFvYDsTOPGaFeunRl8jaZrgYm3jMoHsQoTUamFlp6Cp+Ti8JqdlhxS+/7dbjY90E4sJIQ9xu8rwxdGLLINR/1YEeeTCEV3RehIVHb/yJStxPAspkt/jk3hoFU8xilien54ATcQVHbxVxNEltqNRxeiFZdlxhk0Cs7UIjevxiTvvDFWj+SuMb2MKNlKOeJbc2y4euDrItx3u/DAz8wYRVMUnjOdyGH6/NsXbx0p4IQLx6+hCqOEHJ2aJbgKVayEXeBNuQw9rF3+JWCPEwMu6k2qFhf3mkpfrbMxFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvfdVwViirQTareP5+Z64RSOjKISGhFk/2nCCyQE+tI=;
 b=Mc44Hz/KOpRT2aYkJl0DqOEALPfZPuauOEIrM2Wcc71gUEJ52HL8UxgA9L4pwkem0sa5FwwjBCMZNWJANHqpGK1+8YWA+YIw8+r77nSBcFByB5/Sy9xVan9v/T2TWKKk/MkJ56Nwz9gIiC4uxTy33WqWbgQsQ88qfNaJxNze4OlQ8pZVNxMBVoewp6F5b3NTeqQMHiHytp3gN8o2/OjPLcfBdlfR5OTMRWqPPZIL7lyr/tdpXUT2vx8ckVFFxoRs/zWkcKN7FCY/C66MTWt7Ou8Fti/NyvVrSuTuvDgnPYyTuREjUqXy4ampYIiB//G5XbFkv034BoJgsNgSdvApxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvfdVwViirQTareP5+Z64RSOjKISGhFk/2nCCyQE+tI=;
 b=FXUA+SqAXOjBf2AO+ZaLgwhfklzTuEsWiBj+Zin5LrxrnRRFO3G8hXzq2ELOtDk0kYVTkUJb4ARh5OP5bqweBAevCX1myAbwlwsa8WnTm/J6y9EJT6nhTFF2qwJk6k8xvge9ChKOoTL5w+h19N9aXOJwCW6lICLHpjlTBmObmTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 23:16:21 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 23:16:21 +0000
Message-ID: <b88f866a-0595-eda4-7418-1b3173af79e5@amd.com>
Date:   Tue, 29 Nov 2022 15:16:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 17/19] pds_vdpa: add vdpa config client
 commands
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-18-snelson@pensando.io>
 <CACGkMEuVYUFJzdKDRGo2B3BNtaPaWduHr+jLNAfwCOzpr-5fcg@mail.gmail.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <CACGkMEuVYUFJzdKDRGo2B3BNtaPaWduHr+jLNAfwCOzpr-5fcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::16) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: d79cf7fb-d48c-43ba-5d09-08dad25fba0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZNYN5Z9ZJrKbWzfDvZPEGSABENnzeAHYSIBl7ouDYDGJra4onsvOAibMmZ7zaXblypBveTTDmmoHZmCtBRqKXsFGove4igv0e/4U45QNPuM5/HGMT2paTMsGzSXoewkB3JqtH68kvlGK0ko8I5XzXv++CjaAKRoS/rnbJIuEr1uWxK/luQRWUiPjhkWlqIoOKazgU51fEKMxFy57da1QFOMis7bUDwoF3JrFo+k/H3GfC+gQn+V8io0LIFPVtu70idCcEChuJ46ZsGN1am+0XBQ5Gmh4JpmFkWE+VJa7lvr+Yzhcj1FA1r7NtJqSw+BIBEwJrHipkIcymk1AMYiNmFe5/vJeD8L7YvjybusllCeIZxSTsil4kkjISA3abCR6ZLFm9LHFOOrJptTBtbR1ixV6UyLiGYxrA80xa2CiXfifUixy1LOAectIZALBFJTv9QB7VYOdbYkrM6U0O6Q2LaDGeseN3dTl291ZMQO+r1A7qBH/tpF0ZsHkI3MgzsGLC+4dziUeitS406hBmLRexvJsLxsc9Ly/YchfeRTjUFs5ywuNIE2g6ggo6IKerSJCKO3Jgj9A8ZladwzsfrMzCy1iBu+svNdERy4PUq/CB6c2JSFd51ND55SPprtzoIEuGTkS5LR7Et/Nd8G218/nwCJPiTzofdRvw0jzUqZnZG8EifDj+SGVBs7JVrEqd0bhyq0+iOduZPDEUBZc26Z+qP4so2CJ0R/qzxJs3IWVms=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199015)(53546011)(26005)(2616005)(6512007)(186003)(110136005)(6506007)(6486002)(6666004)(478600001)(38100700002)(31696002)(83380400001)(36756003)(31686004)(2906002)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(8936002)(5660300002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWhKOVFPU1c4STRnZml6eTFONnV0UFYvSkdqbXE0TDNGQktlTGw0U1VQWVE4?=
 =?utf-8?B?K2NTMGJSY1cwSm5YQ1BkaUZjVFNnWHpsNW16QTUwcGltaUtGZHk1VHRzem9T?=
 =?utf-8?B?MlpPVVdnWUoyd2JNR1FMUW5DWElZZnUvNkNiQXc4RHBSaWo4bXBTdW14LzNM?=
 =?utf-8?B?RXZNakU3bFZ3Q05saFllM3BCQWIyMU5rSWd4MG4rdndLNm9Ia29KTVFhRlNz?=
 =?utf-8?B?SFVONDVhV0FVTWN5Vis5WmVPV0ZncWIyUnBwR1AxYTlpTUI2d25ZRE9LUU5U?=
 =?utf-8?B?ays4NDk2d1RIblVwang4UUpKR3lLbmE1UkJCelpxa3ZnTS9xN1diREplMWRo?=
 =?utf-8?B?djBPbXkwT3VrWi9FREJmd0ZaM2ppYy9zL05oQlEzaFAxd1ZvZWhaYi90dzNF?=
 =?utf-8?B?RzEvL0wzemJJVEZvY3RVUHliVFd1K0RQQ3JXNWwxU2JhZG82T3hxNmk1WDlF?=
 =?utf-8?B?dUhXQmtJaEh6YVBIb0M2TEg4bTJRMUEyUkFNYUNBTG56Nm9keDBlU1kveENI?=
 =?utf-8?B?Uk56Vmw2RnoyT0I3YUZBZll4dG1vQWNYZVdIRUZLbVJoMmFobnhnUUlkZ1dB?=
 =?utf-8?B?WWNkcTZYWGVOR05iY3F4TUtiUkNCdlRGSG1ITnZVVFJDR2lJL1JyRzlQNHZz?=
 =?utf-8?B?Z0VzZDZKSGlLaE1jeVlXQk15WDIvblprcWdWRVNpNkUwV2wzSFEvWWlyUVpi?=
 =?utf-8?B?WVM4anFENXZOOE9mdkFtWjZ2OGMwYm1UZDhodlo5Wi9PU29MK0Y5SGJpbjFO?=
 =?utf-8?B?akVDaHUrLzVaeEtHbEIzRnB5MFN6RTBhRWMrQnRoVlNreDhFOFRDRDZIWlNl?=
 =?utf-8?B?Smc5T1JPMUI5ejBLblFLUTJmL2RRZExpT2JrMndTSG9UV1QzUlZGbzhUTEdS?=
 =?utf-8?B?OFplV2N4WUxBa3VsTkpMTzdXa1F6eVp3d2c3Szk2S0E4aUJNcWZCb2xGYVJE?=
 =?utf-8?B?eWxzZUlDWDJheGxjeEJkODh4V0pUOFl4b0FCTHNhMUdET1A4WFZjMzZ1TXRH?=
 =?utf-8?B?d2Q0ZTNnOHdyNU1ua0RhOXZFZXFCZHlnb2tOeWFoRUFuVThaU2h0bFBaQUQy?=
 =?utf-8?B?TDkydG8xNEdFdHMrNC9ySnJZRG4vOUZKbXdERUtHQnpnT3F0aFA5VS8wQWo5?=
 =?utf-8?B?RmZxZUJqNzdsbkR6cVZ4cDRqK1U4cmZWUGM5RmlsMEVjcTRuODVGZ2RNczVS?=
 =?utf-8?B?bXdrbjRIamdpZ0hCQ3VEYlN5NmVDRXp4TXhuNFVhdmxUKzR1UVgxNElpWWR4?=
 =?utf-8?B?cHAxRWpPb21OVWQ0aVVRbkNHT0lXd3Y3YXVkWEducktsNWpHM0RENnNCRHQw?=
 =?utf-8?B?ZjFuWHRvTGxQVGd3YlJUTmg2dWM2MnpqOEJSUEltSE5jU21qTGJuU3R6by8y?=
 =?utf-8?B?RDNnc21uMkRoSXZLWFlkUzJOR0dKanJQNjlwNnVaaHlIeWdrR0c2TmJ2bk5U?=
 =?utf-8?B?T01lSkpBK3p0M0dWREhOZDB3MTFLM1gxVUtYSFVZaGZCZk0xTGRSZEcvMXNr?=
 =?utf-8?B?SC9VRzhUdUNLazcySmdjd2pmbUZ1MVhwcG0xQVc1NElyc05HbjEyV2F5OVdI?=
 =?utf-8?B?cjFkOFhqb00yTEdEaWsvRnhMMG9UTGxMVktMem9XbVM3VTFtWkV5cGc5SGho?=
 =?utf-8?B?MndXL2tUZHZTYjdObHRUSVJSck5wbnlCU2lDWEtOclIrTjYxWmFSbUFPUGhF?=
 =?utf-8?B?d2tSd3FuN1M1UWRzbUNzaVJzdU15L0EvVkVhdHlDaVZ4TzNSams4MFJqN1F2?=
 =?utf-8?B?OHgvSVJ3UFhPbmlPOTFnQU12eldPRTY3dTAxNnpjWXM4TDZidzJvK1pKcGlx?=
 =?utf-8?B?QnlHYUgwcVRObk1ITnpkZ21mNzMxZFhGY3hSdFRtVVhHOXRzb2xDbzMxTkhD?=
 =?utf-8?B?YmE5QmM4MktwMUJnT3o3QjJaMWJrNHV6dGE5R1k5aTFraUtKc24zenRiRmVM?=
 =?utf-8?B?Qmw1cWlDUWVyUDVRWHk4RXJic1pNRTNvbmFSN3FrM2IyeUR5M3BKdnVyQ0Ro?=
 =?utf-8?B?QVJONjdxRzdSZHQzU0NUL3Rwb3p1UWNQY1VpR0gvdjFwcUx0b3pHUkRIaG14?=
 =?utf-8?B?KzBCTGRzUzVDUUZQUnFQR3huaGxkTFdsOVNSUksxNmljNmlHTzcvbVFBZUxZ?=
 =?utf-8?Q?dPJ5tJ01nRBYlOk0D6Rr5uNwT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79cf7fb-d48c-43ba-5d09-08dad25fba0b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:16:21.2931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BX/ww7jA7LdSuHKnF9v+y7vkR0I5g80ZjT/li/hAWEvNWcOPx9J0mpjnJIcQyEKP5D262cnZH3peyqnBMLASrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 10:32 PM, Jason Wang wrote:
> On Sat, Nov 19, 2022 at 6:57 AM Shannon Nelson <snelson@pensando.io> wrote:
>>
>> These are the adminq commands that will be needed for
>> setting up and using the vDPA device.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/vdpa/pds/Makefile   |   1 +
>>   drivers/vdpa/pds/cmds.c     | 266 ++++++++++++++++++++++++++++++++++++
>>   drivers/vdpa/pds/cmds.h     |  17 +++
>>   drivers/vdpa/pds/vdpa_dev.h |  60 ++++++++
>>   4 files changed, 344 insertions(+)
>>   create mode 100644 drivers/vdpa/pds/cmds.c
>>   create mode 100644 drivers/vdpa/pds/cmds.h
>>   create mode 100644 drivers/vdpa/pds/vdpa_dev.h
>>
> 
> [...]
> 
>> +struct pds_vdpa_device {
>> +       struct vdpa_device vdpa_dev;
>> +       struct pds_vdpa_aux *vdpa_aux;
>> +       struct pds_vdpa_hw hw;
>> +
>> +       struct virtio_net_config vn_config;
>> +       dma_addr_t vn_config_pa;
> 
> So this is the dma address not necessarily pa, we'd better drop the "pa" suffix.

Yeah, strictly speaking I suppose it isn't necessarily pa, but _pa is 
the moniker we've used throughout our drivers for this kind of thing - 
maybe not perfect, but this is where we are for now.

sln
