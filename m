Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C282661509D
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 18:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiKAR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 13:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiKAR1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 13:27:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAC91B1DF;
        Tue,  1 Nov 2022 10:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ch4gi+50eSlKvBj50NjZSC7vwBtbSFYDdt+imPUxl7jtbep7QnwpoZVfMQta5vQTMe5QK22zOB/Cfhrn4NoyVwQLPHUzjpJDB607JuGc6bD05n04QMKBLXgjoAtgIEYx0wbINnGAHQ8alRGnZdjaxs/gg/fzpXLHy44AoEy4Orh1Odb2lovGNEZ2/igawT/MCD4E5ADgfWezE7ZFxAWyXpGyvp2oKc8mveG7mlmFvfGf204iUfi/swAHlDO8DVkRffiBYBI37ggsRKMqYd5r2BlKWknXwKkYqgQaCydBgR7U0HMPc+FS+pPVM/90sY7PdPuXZir1RRN7TBK01pwkFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbXPYJosroMIyQxsRQXXByTZ3xAFZgELMwepwhDFZWo=;
 b=OfY/S2/q0qn9OISQercj09yMvsRwrXLyLPGse8H/LNRxVJPqSujYr3aWswwiNXKuHrgOTBgjt4NT3FsqZrk6EGFJZu1VTmGkUV4kj36xvmanbdA8F9YWkY3wNslYDQE7wInoZ/qae0hLMWf+tIk5EWS6lgBrH3dFUOXbw5FU91bUS0fmRI5jTqemxvNGvTfXTwElXoD/2Ww3UWDtHScYqVzZI6MKaycEQeLd5N8DnCMrYXeTXGAImZfe9DSDFHfdjSTtAizHXCzCM38ylQuMpdO3Qd0ySh9Mb+b2tw9Au1rGYcSUUpqrN1q2RHriNlTliO76J/01kfCuVuVVvnbz2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbXPYJosroMIyQxsRQXXByTZ3xAFZgELMwepwhDFZWo=;
 b=iXmsdEPTlpL/yC2TFWPUAy84biPqOlNHQssMRv1YI5l645PoiH5Xns47VOWINOMF692VFK8OL8nlbs0Otqe3dV+4BTolzFGgYK0wWHyTbP8wEqyh5lYO4jiwimvkjLGUxn5KIrjNq6FYQnYAROohGJRxZDj48ph4l2bWsYdNUigtMmP1fPvPm5LWV/OVm+5tz2NAP+iyJdMvwq94VAMq5bYFx813gZj0urjVu8pmuJT49a/nfO3K74xlXmrgF+HmXg4fEnnMf6fkJRqNftYcEk1BdoVP82Ipk1jGJCx/boBljTAYLFofv7FvV0fJCuwUHLyswctc2EgpgEPbn1JsuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5809.namprd12.prod.outlook.com (2603:10b6:208:375::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 17:27:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5769.015; Tue, 1 Nov 2022
 17:27:09 +0000
Date:   Tue, 1 Nov 2022 14:27:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Long Li <longli@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v9 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <Y2FW7Ba/krWc4nwP@nvidia.com>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-13-git-send-email-longli@linuxonhyperv.com>
 <Y1wO27F3OVqre/iM@nvidia.com>
 <PH7PR21MB3263C4980C0A8AF204B68F1FCE379@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3263C4980C0A8AF204B68F1FCE379@PH7PR21MB3263.namprd21.prod.outlook.com>
X-ClientProxiedBy: MN2PR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:208:239::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: 306fad81-116d-4fca-c4c6-08dabc2e4e44
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PAUR8KeIZh+TBGtvVUUWoKau5tGPQbAPqbDYt1cL2c7G4MGPEWSKskQpqhAn/kacFKUVM5fnXwAWoRx2m7nG9XJ7XZbrZdt0FGLyBXK9/6MpDAZe/oRiydrLSsc54j7KgrUzIiFq5axajub4RMgFjsK6ZlsJWNZg/diUJYY0o+FvV0qpjFHBAFY/DEeQMoSUJ8s91KrOrEDA/i3n1nk/oZXK+Do5pwDmAJfZg82wdYac8W9+Uxace6R1/fk+amHZO8BOCl8QI3t+EFXA0cSygcKlpYlvLG/U8QHZDIqm+1OcwRHa7hxa53+Q5irX/Uuqrd3f6itfDxeStPfUiuUk897ujQ4Fx1M1HWIwCVrmRAH/X3L+AGJm2P8jally8ktEHMLfNCGyp6K7DAVLMB3RXK50M5a/UNGD3hbmk7oqhj4OQxT+1XL6btUTFj9/xGU2KQHmWhEKbGnZa2geOCQRSjgejv7MEHIfsLfTSwXVsSmc7ULM+ufhVYgAEbhLJKiWfO1igfaWxg/aY1tMMpZjSkAbvLuAiVokbO/de3NMOWfemGkm2OSNlVkk1wJnvOsczVkVD4fnw6Q+wVEWQ3UE1z/qNYlCrYGK8mv6aqAj8XRD9p2kPDXu6gvNn+nSx8xzs+Q4AU2NOQr2n3razMRGvTOfpBQDhY6EqN8SPMh5lSAcIvj5E7+CKS87XeyZQse99vabVB8Y5OAwCtD1s2UxJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(47530400004)(451199015)(54906003)(6916009)(316002)(38100700002)(36756003)(45080400002)(6512007)(8936002)(41300700001)(26005)(2616005)(5660300002)(7416002)(186003)(52230400001)(86362001)(2906002)(83380400001)(4326008)(66946007)(66476007)(66556008)(6506007)(8676002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SFb5Ba8lXwHICKGOlt+0xIk5oUDbW9ese3CBqVLaXmoUec+FzQIykFjbzzik?=
 =?us-ascii?Q?BIDFHDnqKXwFcwUsat60+F1+6Q974Z0qNm4OgTZnUrA3OE6rvUGMDUGXKpWn?=
 =?us-ascii?Q?gAyP5rFtkxWecuRQ9G57rooQe2+CPCr8Yqn9x7z56VAU6E4BQpVN1uYsoA5a?=
 =?us-ascii?Q?srCGwTL/670+EllGNV5iKhjAnxuKsKvegqTWnz1qxySGufqlubG7HT+IEVup?=
 =?us-ascii?Q?GnB5IlFM72UwMqVpKGDxReWwHJoMe3OVoO8aHd+qqLT39zHx4ZwiESFxcWub?=
 =?us-ascii?Q?9MkmTG8WUQR4pZy6v6rMlAQ6fxnbQk5JfjzMxFusTH+27cBJqBSXrbV1i73g?=
 =?us-ascii?Q?mzNHSe3w4kCVRXsLQULD7oqzTyHn9VmyWSCV4y7TAxQkldyKwX2eFZJXGast?=
 =?us-ascii?Q?CX1SMTIIOgjKeBbqA7GeA6O7K+AqjJOI7dDS2ifwtKtqdSyM7W1C3wjFEGZR?=
 =?us-ascii?Q?2FyfK8gMvgcM0E0NdLGDw4/vlHEYnI2rx16YA5O8i4jkS1gW6yhdfhYzY047?=
 =?us-ascii?Q?jJacIB6j9ngbQV9aACXBnputAggEqkESC+bJ0PgXA5qbLuAz9tTCgvP31pyx?=
 =?us-ascii?Q?4Ps1N5ifMPS93Z95/RHd/DuRzFg/BbNTRH2AlXLkU7uVK2VoMepwQK7ZcLX4?=
 =?us-ascii?Q?mfDXINqYFemFKmBgxyNE03EqO1ZV+fJ8/EiICiMuO6B53mcbTL++y/w88m0i?=
 =?us-ascii?Q?pMOSqTq9U0g3sT7uolO33n2IUeJmZ36bibgLHMYCNDbN5uBdWU+IuVYmBvfJ?=
 =?us-ascii?Q?JM5TKypQTfgG67uAbH7hUBwfDnP+6hjiiaqSxCKiYOKiZeI5DCIEN7wzL4TU?=
 =?us-ascii?Q?0KSWavxHgw3WBLqOYtTysOsSgOrFe/XUNsxjjfvR30gJUPBLV3/D2zf6MFaX?=
 =?us-ascii?Q?pR9jxPYZVLYhdBRdetH+NKp2c8c8VwF73FYuXNHe932pjgsbyxE+nUyPE2MH?=
 =?us-ascii?Q?WV3cn1+890P9tM4p8VH7HkX8c9vo1XFIDdue7qz9ezEpMMQAzabqgCl6S+BL?=
 =?us-ascii?Q?iXn5mFP31QQcL5iOylgtZH6L3EFNZ9PKPCLgbrFlu2LbvJyyhE494uUFQkxk?=
 =?us-ascii?Q?TKx73Td8ffMzaH1/pwHycMt1DWQJKsKeGJdaF937M/JyCdudhVZMPLvaJbOx?=
 =?us-ascii?Q?cbssbUNdkUo7dypW/nq+YhvJdIrzDkpXi/ec5xEMSUlEt4Uc7nLbrkzAQPRH?=
 =?us-ascii?Q?8F7nCX4ebQuYuxaVz2yr64MLIOowzu5PASkDwAOgFYqW3FIGmr0vGHwmOlKd?=
 =?us-ascii?Q?/ZRBUYNlqJmlayAP6uKi8OyVJALPyij7LDNTf5O6/PARA4Vy4Giph1KxtBid?=
 =?us-ascii?Q?iMdp+HxB+AjYKMsJtaT20ixwiYFEgGzVoRg9ex07pIu0fG3GTpQexIFTXVQR?=
 =?us-ascii?Q?z+Gn6Afn2unew8jONpzTQtNut9bHvQTDcLE9gKlB+LsBfFtwtl5TEU8SttGi?=
 =?us-ascii?Q?FW+HAggVio0nS387FRPgq/qqwXUgbXgeuFEwm2c4VW78t8UP2hTREimfbmHe?=
 =?us-ascii?Q?6EYMmhAGcR53NJH6p4nun7g8MOEeuuYeFaSL7cQKfbVMJmOu+NuYU7gy4eoQ?=
 =?us-ascii?Q?dwFi3M/igxUQFxCKBU8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306fad81-116d-4fca-c4c6-08dabc2e4e44
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 17:27:09.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z29LbiD+8Bxkav0PCxWVI7Y/W7DNZKWi0OM/Q9q3w5zJxCpSlF59vEc3cuidRrdc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5809
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 07:32:24PM +0000, Long Li wrote:
> 
>         page_addr_list = create_req->page_addr_list;
>         rdma_umem_for_each_dma_block(umem, &biter, page_sz) {
>                 page_addr_list[tail++] = rdma_block_iter_dma_address(&biter);
>                 if (tail >= num_pages_to_handle) {

if (tail <= num_pages_to_handle)
   continue


And remove a level of indentation

>                         u32 expected_s = 0;
> 
>                         if (num_pages_processed &&
>                             num_pages_processed + num_pages_to_handle <
>                                 num_pages_total) {
>                                 /* Status indicating more pages are needed */
>                                 expected_s = GDMA_STATUS_MORE_ENTRIES;
>                         }
> 
>                         if (!num_pages_processed) {
>                                 /* First message */
>                                 err = mana_ib_gd_first_dma_region(dev, gc,
>                                                                   create_req,
>                                                                   tail,
>                                                                   gdma_region);
>                                 if (err)
>                                         goto out;
> 
>                                 page_addr_list = add_req->page_addr_list;
>                         } else {
>                                 err = mana_ib_gd_add_dma_region(dev, gc,
>                                                                 add_req, tail,
>                                                                 expected_s);
>                                 if (err) {
>                                         tail = 0;
>                                         break;
>                                 }
>                         }
> 
>                         num_pages_processed += tail;
> 
>                         /* Prepare to send ADD_PAGE requests */
>                         num_pages_to_handle =
>                                 min_t(size_t,
>                                       num_pages_total - num_pages_processed,
>                                       max_pgs_add_cmd);
> 
>                         tail = 0;
>                 }
>         }
> 
>         if (tail) {
>                 if (!num_pages_processed) {
>                         err = mana_ib_gd_first_dma_region(dev, gc, create_req,
>                                                           tail, gdma_region);
>                         if (err)
>                                 goto out;
>                 } else {
>                         err = mana_ib_gd_add_dma_region(dev, gc, add_req,
>                                                         tail, 0);
>                 }
>         }

Usually this can be folded above by having the first if not continue
if the end of the list is reached.

Anyhow, this is much better

Thanks,
Jason
