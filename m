Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0460F323
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 11:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbiJ0JDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 05:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJ0JDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 05:03:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E088EE17;
        Thu, 27 Oct 2022 02:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXbJ1PbrG5lEmAcir9MDpG164K5QbGru++0py6hK4wvXrcXVot8j24mbBaFZ8OjkfoQS7YWt3CwEsOOVdZHbm3nYHzaPablTW1DVxDEmnN1b26ilzX1X4fir0BkFdesAqtUr9/eItG/LV/9ZNQbuEmwT4+kJVxpiu5qhUIFkdwYIXCcy9yELue1M9/DU9w0TF2ulXdQ6gd3KEPH+aqGko/yWD2+G1l2xMu3iEDq6WG+s/ZXbTmqkp4ewb1ETsztM9LPADe13e5/0Tus9uqg29HEElx9WQZ/BPlRRheDevBwhWGAsPu6oVrX8fkqMQ7LhYw5J71cSlLh75TsgMqar6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9QdJhug8wHDdihD9fHPZ3tX7DYdnRm4IgRu+ZIBYY4=;
 b=QF89BJvuh/cuQwgOl6xXKb2ZzjS0xKYtfnWSWk9W3LFXVWUBQ27JvacTQkWI1un17WtVgTBGiZ4ad85hs61hZoDc2CYMDeMCuLa7oGu9qxp2Uf8pAVsB6ROQ+hObnV2rgh/aHA2Vc8E0JnkgU92Wasntrej3jT8Sn+L/cv+gzvkgjUyacRlxTj1wbtzixerNgbAYfjMN9ozG4CMdrRb0lFKVuT3bwdafeany4KdRrpQUf+lmzsi38oR/UNOiSES/TfUegZ9x8j4QEyKeLys6WPkVl8qXN4erWgpZzb4lFZLZoTFIDLSgaYc4pEFCHiQLOWNGIS1b3HWbvOgVZnzsrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9QdJhug8wHDdihD9fHPZ3tX7DYdnRm4IgRu+ZIBYY4=;
 b=Crr0LUL6rChNKdAM/YnLLdXh6UOvkuDAckK5rhSa2IYx1rWt/rlEn+9oyBxOKl8Nt7+rwoQHHc5m7X/l4e7Au+Icz4NDbDnwO++Mxt+Vc22IzdMV8naqShg0hAHvXuL4dK22pM2nEk5uG1sy0bgvtGl+pL42BYyC5zRl5FM90wqNCigs/ozscACf6qYNPsXE72rVLVmJonp24TZ5ap3iwLW9Pf+MBa5ywBHZQZDxhyQZrs4KX6j7VGOacL8jIbfnH/G63rsm9PRICxyPDn2OxkLG5DNhXwVEpee4xqSMKM+C3ox48lc3dZKHyN8YTHf5ndpi/aEhJ/+ivJ4bnSLgTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CY5PR12MB6623.namprd12.prod.outlook.com (2603:10b6:930:41::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 09:03:23 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 09:03:23 +0000
Message-ID: <e56e1c33-3909-50ec-f116-80b6335e3ddf@nvidia.com>
Date:   Thu, 27 Oct 2022 12:03:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH V7 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, amitc@mellanox.com, idosch@idosch.org,
        danieller@nvidia.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
References: <20211118121245.49842-1-huangguangbin2@huawei.com>
 <40d6352e-8c6b-404f-8b6a-df1816239ab0@nvidia.com>
 <4466b159-7476-f833-ec22-ee234b70110b@huawei.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <4466b159-7476-f833-ec22-ee234b70110b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0065.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::29) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|CY5PR12MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: 08aa1b9f-b114-4bc4-4898-08dab7fa19b0
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pd+B6Itl4E6T3jbdS7PV/Zjy8ZFGunP3qFirGZ0Hk9esYpO82gxvnQnM0EVQzoI0FpihFfI1iAyDEZ4RzZT3lvtEkUhyBRnrROACPUOpesi5X+HMVvTGC0jjNaY4SPgajbqpuvqGcKUa7EwYtmN7uh/JLv8ZgViVgrdG0OD8ri8NaGV9QAiiRXYEYLF1nl7vk6Lo6LguBXPE/dmaY5xTZ8DGr7QOU28Sc+oQZ+8lg0Kif2RQZF70t9FEjw6LW3uNc1tD1KvQpHg3HSn1PQnSG9NDHxWLNAsnefBt+qHbW2tPyNu4iExheeSrnz4t4LIYOfvZLl/qwPX/HBHSbLy1OzWKd0tzFvwIni4fZd/8eSYdn+7Pn6l6zW+ZTNJH1UyWX/CPUqk1zGdS6IJLhlPNRg/lVm9qAj8bPWVE/SBtbYNZ4mNuBtyOAOo5hxOcA85+jqJ08LFoQir/FfDEuEOclGtPIIrk0GDwh5LNfqdHPZ70p3GfLxvIJRfRQ1nFrsTeurIq+3PpRQn5Swpp2QmYzHPmi6Lc9ZAwJj8VICGxmbdkn9+dYWaAE+sXdNqWaHNpyRvwgM7AQ/0IYZhIsEePt2Y42P//hIVEKaEIEqYQiIb8rLapLw9cmF3f6b9Zt1W2hwAe5mxaszWQ6nZmCsuIHSqEA4XNgP0+J1n6rP4QsUdV1uZeFTyUjIx8CxZ5nUupvm8qg8lck9DXVqidRZ1stEUB2ffMOdgTKFOmDvVi5oPjU+ML/l7eUyqxwY/NLaCCU09b52pIYxxFBviqLSPxW5Z4tMARAQU3RyiU3O/Ml6XXlsvXcu1su0pCdk4z1x8y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199015)(41300700001)(316002)(86362001)(31696002)(83380400001)(38100700002)(921005)(6486002)(5660300002)(66476007)(7406005)(110136005)(66556008)(6506007)(26005)(6512007)(478600001)(8676002)(4326008)(7416002)(66946007)(53546011)(2906002)(31686004)(186003)(2616005)(6666004)(8936002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGI0VWlBaHpUMkVXOVpyVGEyRkhRVWFKbHBwWGQwTi9jbDFaMnIwcUlZWGZE?=
 =?utf-8?B?WGMxb05YVTh2TUs4L1FFTUJ4R004djlMU1o2dXRhdlp4VkZKZ2JrQzlKb05M?=
 =?utf-8?B?Wm4zVFFMaE1xUDZpRWpBSUNtUzZBcHJjeVJFVGtBWDdUazhWSmdodEpLa3dv?=
 =?utf-8?B?R1U0YXVhMTNlRGdGYVl4Um5SVTdGTHRKV29Sb1ZHNjV6VWRSZmMzdGRPelUw?=
 =?utf-8?B?WUJZY243MzNOaGpIQWw4aHoxQ3dYVGZKcFg5NTNLS2NGbTdFbStNUFVDamJW?=
 =?utf-8?B?LzF1U2N5Mkd3Tmt3d2dpWXNkcTNYcElNVUJKM2JYL013MFM2U2RLTnJXS1BL?=
 =?utf-8?B?aTFCRjZFd29RTndqMmZ5MU9SSDF5OTRYYis5TVd4VU8vUHp0bWRabnhUM3U5?=
 =?utf-8?B?RlpMZG1jeFByRVZOeXhPZlZEQk14eFVmREd3ZFJTQXdNd2k4OUV3a3NHSGhJ?=
 =?utf-8?B?WVlkRVNQSjJ2bWx2NmRFc1JLKzRvWHZEYktNcnUvdUViTFdHUkdRRkUzUndZ?=
 =?utf-8?B?UnRCc3lFTlBaaXdxZ3NkRTd4QlhoNHhyWVFyMWtFWXNWYzNvOGlHSld5M3pl?=
 =?utf-8?B?OHZoRVA5RUxRbldXa2RlQUZzQ2o4a2VHTHBCbHlnVDBwZUlYTldXV1IxUGdt?=
 =?utf-8?B?QXhZUHBwSHZxVzV2RStySHZqN3A2WEFINHFxaGg4OURpeHgvbVVqZUFJZlZ5?=
 =?utf-8?B?SEhWd0VPNzRjdHIwVS8xNUk2VWJiWW9JS25FcENxUHlCRHBiUWZkcnBSWGFx?=
 =?utf-8?B?Q3MzUklyV0xkd1AzSTNFeTVXN3ZFVEkvMnd3OWQ1VWFBTG9EU3BVVHU3SFcr?=
 =?utf-8?B?T285bmxQbGV2aXBKbHlDUHNaTURDbGg1TWkwWVA1VHovL2JKUzRqRGZobS82?=
 =?utf-8?B?akxOZkhpMU5jajd4aTR6enZHZ3ZZUW05a1QvN2w4OHE3amVsRnRhTWMzTHA2?=
 =?utf-8?B?VUxlbmZOWFdpU2xob0FjQVhDc2JNODVldWpmRTZYYi9mazlWTStZTExXOHFL?=
 =?utf-8?B?RTlWczNEdWdkN0ZGOGlvZnR0NE4rVG5IWlEzK2plMThxc3lPd0c4ZVJnTmFh?=
 =?utf-8?B?ZkVLZU1POFJ5eWdaTTN2WmhoRjRuRFRJYnhmODYyU0tDR2NSekNsQzZNQndR?=
 =?utf-8?B?VWZWSzFkOWRxa1lOamZ6Qm9UM3RzakwvMFgycUxtNGEzSXZrNkc2cFNxTGk3?=
 =?utf-8?B?RzNraGtmSlRwS3Iycy9leHdNZHJ1dlh5TEJaSGNnclhpSDQ0akxHTHdZWGdj?=
 =?utf-8?B?VHJSbTdMcll1dUVEY2FuTEM3RWtUelpRSmRvZ2lwSSswZnEyTVNQdDNxdmFL?=
 =?utf-8?B?T2c0LzY4VnBLeXZBd3JKbDNjdktnQW5qM0tlR2dxbEtxZnJiTForcjdEZ0RL?=
 =?utf-8?B?MzBqNTFzVUhTc3IzQ0N5U2tTYkpFaUhmZ293b2JBb1FJU3Bvb2pKZUtVbVdi?=
 =?utf-8?B?T2Y4TnUyNENyOTNyWmN0TFJVajBTL3FLaHJEbzUrS0Y2RkFzM1NtWnZMUXdo?=
 =?utf-8?B?czFpYTlWM1k3ZjNBSmhRbGovd1lVMFl2Z1c2U0NlUFJYMHNPTndrYkYzMXls?=
 =?utf-8?B?b0JNNk9WMWFwck9EbnZtSHNSd0tlL29TNHBkMlEvUHMrL3MzRmJlRS96UWNr?=
 =?utf-8?B?ZE9hMXdXa2g2alg3c3lZRmtFUVJva2UrSTRJNUIzdjE0WjQrY3Q0cUNtZ0Vr?=
 =?utf-8?B?K3hUdi84bzZjYzQ3WVBiL1k3dVZpaDJNREhjbk9pTlFDd2dJR01saStUWnht?=
 =?utf-8?B?L2NlVUQ3VGpCb0d3Qm42TFlDMUN6ZFNrVUJCODJDdmMybGFzNWdDamtmWG53?=
 =?utf-8?B?aXRodGxOYnJncElpTFdsQlFpcHBGUFl3M1pSSjZQOFhOMzE4WWpYN1hENm5x?=
 =?utf-8?B?ZGZmOSt3bUpURi9uVjdyK3l2eWF6NTRNY3ZZdUtldmIvME9OQ0hQNGdUM0ND?=
 =?utf-8?B?cjJsUTlDdW0yc00xaVNqc2tNRkZWc0Ria3dWUGxtU2NtY3lZeENMSHZTdVdX?=
 =?utf-8?B?YWc2VkF2c1JwazVkRFdTWmd5czBKQjZzMmpYS3lIb2N1VDJVRG5hdmttNVBT?=
 =?utf-8?B?b0lSQjM0dmUxc1lwdU1PWXNaMThGeHVmdW5DSTdnMHRPMVczcWhNNFVoa1R1?=
 =?utf-8?Q?Lv1vYHlhc11NIBrg/KfqsBb7T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aa1b9f-b114-4bc4-4898-08dab7fa19b0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 09:03:23.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrfauCfOWs1Vq5b827k9myEovzNffz84AJOf1quOQGG9NfZnRWDgFQaCRu44Olqi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6623
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2022 03:49, Yunsheng Lin wrote:
> On 2022/10/26 22:00, Gal Pressman wrote:
>> On 18/11/2021 14:12, Guangbin Huang wrote:
>>> From: Hao Chen <chenhao288@hisilicon.com>
>>>
>>> This series add support to set/get tx copybreak buf size and rx buf len via
>>> ethtool and hns3 driver implements them.
>>>
>>> Tx copybreak buf size is used for tx copybreak feature which for small size
>>> packet or frag. Use ethtool --get-tunable command to get it, and ethtool
>>> --set-tunable command to set it, examples are as follow:
>>>
>>> 1. set tx spare buf size to 102400:
>>> $ ethtool --set-tunable eth1 tx-buf-size 102400
>>>
>>> 2. get tx spare buf size:
>>> $ ethtool --get-tunable eth1 tx-buf-size
>>> tx-buf-size: 102400
>> Hi Guangbin,
>> Can you please clarify the difference between TX copybreak and TX
>> copybreak buf size?
> Hi Gal,
> 'TX copybreak buf size' is the size of buffer allocated to a queue
> in order to support copybreak handling when skb->len <= 'TX copybreak',
>
> see hns3_can_use_tx_bounce() for 'TX copybreak' and
> hns3_init_tx_spare_buffer() for 'TX copybreak buf size'.

Thanks Yunsheng!
IIUC, there's a single buffer per TX queue, not per TX packet, correct?

One way to implement TX copybreak is using an inline WQE, where the WQE
itself serves as the bounce buffer, sounds like 'TX copybreak buf size'
cannot be used in such case?
