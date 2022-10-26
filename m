Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2660E2CD
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiJZOAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbiJZOAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:00:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C469A63F0C;
        Wed, 26 Oct 2022 07:00:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXWxoXVdpreUUOTxLEIUHd5oiTR08idZe1SwH0XkVh6EsczUdYBuoSscwBttfYPM0qPdYGQE+oJog0C4LEAwpMqgN12sEMzRqkrhhKx+ixYu85KFp7yqL6PlkUBUQmzxaV7dfjkIxO8MRqvRN6KD/qC+Gx+ptzT5PXSUf3Rwqn76Kzr83S/iblzNInQ/X7XGK9FAJ22KJKEwAl34jtPUj7uqO9qTjkBgxtcEPrgPLIfVdRKfx3jToM/VdTBIbyirKBnx2wIEMx9Zvc6dzjV80bIBUnj8lMtk1606JXJw7q+6wmIOwg261+TIXcc8tp5dc89EgANPqnq+w1Mit4qRkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omXoRbyMTWwc8f4pBneEbvbU81JhVEobJo8kb0hFe/Y=;
 b=gG+ggnk1Um2siqK/HFdiLiqv6wTZ1AX0WoAlXNQbQxHHmscUSceMDOHihmT8Em2aUle4KmZo5nAnZbdg0B1oVrVq0+rlZPN+nUHkihmKYqY4xyMbRIMWuYbZ5pqCeE7RiDXLsgRuWA9unRh2c+yZ4r81xOQrrAQmfRlA6w6MrNhTOAL1/Qbi5LbNKdyuCcSkWjZcOWzS/0mxUmr0cS7w5AMTwvsYgkF0+yZ6+cudIgTgLdctAqELcni1BZmUIbBfAs2kk7LImotZq2WIX6ryP7Xl00FHkdi0D595Si77cU1IezqA7fegmce+TXpZDy6HKRjS03lBon/OrnXdAO43Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omXoRbyMTWwc8f4pBneEbvbU81JhVEobJo8kb0hFe/Y=;
 b=EcDFBjX0VLGvSBlolJxsugNRqkW00FBn+KaxrwAXhP5RCVI2u8mPk3XaHinfTe+8eBsESnK3zEyxOLH9Lo8FaRkt4+TQI46D8SJEAyHUKo51fdvcM0O7q0UyMep6dxhhFrFLpdUDxE6IpTmLjAZ4L9lJSAgzuJhMT+KTmd1KwuzrfrcXgJpjmw5+FTinPTkI+KwKEeSqwXmzYogVU8rSzowjXQ01G/j1fCf4OkJDc09TW67mrSmixWljjvcb6gYzoYFMQDgk2EhgKIiWoOi2AmV0yYTXuERaTNCqfbgRmni0pbsmtdWx0imd7shK+QjUb8LzEHCLpwKNG/GKc4KJJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SA1PR12MB6725.namprd12.prod.outlook.com (2603:10b6:806:254::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 14:00:17 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6%3]) with mapi id 15.20.5723.032; Wed, 26 Oct 2022
 14:00:17 +0000
Message-ID: <40d6352e-8c6b-404f-8b6a-df1816239ab0@nvidia.com>
Date:   Wed, 26 Oct 2022 17:00:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH V7 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
Content-Language: en-US
To:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
References: <20211118121245.49842-1-huangguangbin2@huawei.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20211118121245.49842-1-huangguangbin2@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0606.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::14) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|SA1PR12MB6725:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7edfa4-1c17-4428-edc3-08dab75a6947
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZnMheW2GAKqocT7gLn29iVfjjeO+EVmEJRYA1dOXdub4TEzYaawnI87LGHsgIq02klG8HYprdMXt7VNIYiYlw5pj/NfupV8uWXVnbV04gLspbxkjYQNyAKsx+AEbbCzDkuzNwOhmvjgQ/QtzYZUkZb5jhpXF6gSIKwcnTXgb6lwArIS9tnI7Ylb1i3NdU9uJGqXp98uzVfjVGi1iy6P6Wpw/cX/S6P6bFFKQQAcyiFmi7Ten+gf6A68VEOBDbqpdHWrmDmMTlKYn0+tm9iBi1IUTkl9qz4hyHAQbU0RXNJyk+P9e2waD4JPZys5+LhOEW2Oxf1Qo+ItRqmDHo4T+uig5smTu39lYCmdCw8HZ/cmTcHI9mkDef3dkTp4nUGu/OEOCWPZvizKEKWSnJx4lfryTliDFlNL1YvjId1lzaHeOjPZ5YfXNCY1cnlfIHlQtMWbgJQHo9gBYspmI6czR9eZR/vGyplVuu1avjgrr8zfWxVEb9qS1XlGsCdIC8SV6faZRU6rd4I4nKB9Sjutxnv/+jokzXnVdpwd4Tv78vpgEIEevFTYwJI6YvpMC/ghbHVTNvNg8AcZ01b/UP2cT6bgME9ec9XyUpgzACpqLQJducrVwUOt4w//Md1AgOnO/8oz8/dmtXgAJ7NrknCjzPonmQODtg+RBjfcJxQiOeYOdBrBUnDDiHZ2jmk17ARQ58j1g0g8CufVYRVviFa0qhqy9xEl+pHbjkT1N5pzM9qAchF0EuA+grED/KU7Xwko3+f1YwNGhxqZiPbfokruf+1iCvv9/RVrp7jWofVJZwrcwWURV6UFa2Z3NccPISAzh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199015)(86362001)(26005)(8936002)(36756003)(6486002)(6512007)(478600001)(31696002)(921005)(66556008)(66946007)(4326008)(8676002)(66476007)(316002)(6666004)(6506007)(41300700001)(53546011)(38100700002)(7406005)(5660300002)(2616005)(31686004)(7416002)(4744005)(2906002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1Avb1dZMTZXQ2NlWGN5cSswc2tYVjNtNzQ3M3U5dm5DUThodE1ST3JXS2g0?=
 =?utf-8?B?L1VxS2RFaG5ROXFXVmY4ZE4xSUhxMDNZdGlhZis4amg4Rm1kZ0szbXczQXpy?=
 =?utf-8?B?RU9uSkVjS0NTbmhtQzA1UGt0aFhKV1Z2bzBYZ1FBOUpiaFBQeDZzMzBlRGVo?=
 =?utf-8?B?REpydnpCWXBwVFJEUTF0MXZUMjhPa0JjZzJqMXZrcEhuUE11YTR6NzVhU05I?=
 =?utf-8?B?VGRhWFhWOXZ5eTRTVVRwdElXcjczYUFVQWs0VFNSd2c2N2lGWjVrQnVNZmxy?=
 =?utf-8?B?RnMzcnU4bVlYYVJxM2FQcUcwcW9XYkMzYi9kVkJVdDJBSW0rQVhpSHA0MmVr?=
 =?utf-8?B?TGo2aFlyWHVHanR2MFdiNHFQM2tMNlVDc08wMzJnL3dtYm9TYWFoNitCUnZn?=
 =?utf-8?B?L0l5YS9iS3NnOVBra2gzRmN4UDhKVHRjcjVhclFxVm85R3htKzZFTkNLeUlK?=
 =?utf-8?B?QmszKzl3Sk5ldUs3TC9OeVd2SnhOcitCeDlITVhBODcrOUQyeDdyQ0RZRU5u?=
 =?utf-8?B?N1NaYklLSXBLd3M3Kzh3dGVGRE1SZWZSK0RlaHJFUGsrUG5VdGdEOVNwSWdv?=
 =?utf-8?B?S2ZQdkhJZkNFb3h0YVZlZW5sbzdaTzRDQ29DdkdFdjR4bnYxU0ZTVzIwVGMv?=
 =?utf-8?B?OFhZQ3BlQXZ1Tm0yWnhYV25jYm40bFVlb3ZMVy90QzFjM1FnZm1OeXhybmNQ?=
 =?utf-8?B?TjkyL3c0ZlQyWjU4NUh2ZCtVMis2Y1FTaG1ZWG14dXBBZ2s5d1JhaFpYYTlx?=
 =?utf-8?B?cGxRZWRNOVQxdHRGM1dmdHJKTDh4dkVPV1gwenpxalZwam1naGNPQWc1YlVk?=
 =?utf-8?B?UTlFcXVXRDJUbzdKcmNUWXhXaDVqM1dSbmF6T1dXbXVjRittTGdzdE9jdzE5?=
 =?utf-8?B?cFhzcC9VdkUrUytRL1QrYTgyUStaKzBhaDBzbDJuNHZiZkt6OFNBSDRPdjJl?=
 =?utf-8?B?RzkxVVE2U0MxY1l1WFV2Yy9TL0JmeVE2QmRZUCt1THdYelN0emoxWk5CZUln?=
 =?utf-8?B?SUhyaFFYdENhSXVydHNqQURtUWpFN3VkZkdpa0svK3hqQ3pYRzlDSnJSUVQv?=
 =?utf-8?B?Rlp0NmJ3TEtsRFNvYWo0eXpXOEZKYVd3bGpGWGtXZ05Va2s3VXZHL1pzTUlh?=
 =?utf-8?B?Z0V4akRYZFhwOXJ1U3YrZ2p2amhyeWo2b0FybmtKQXdkRW9QVDV6YmN2TTY4?=
 =?utf-8?B?VVhsTjlDMnZzMVJCeE9WbGRvUEdrUHJNQWgzWDlSdzhpRXp5b1hKeUtuUDdV?=
 =?utf-8?B?cW9WTjZ3RmhBRTVJbytjZVdYbkxkbktJQ2toenJlNVB5b3gvWGFTSWprekc4?=
 =?utf-8?B?YTk3STVhZ2dua2cyaUdRY3JleWwxc2Y3VlpsRW1UQ0NSY012cDg2cW9Wd1Fh?=
 =?utf-8?B?cTNDNkRjNjhGZ1JEWU9Vek4zSmQzQ2lZd211cVlpaEY1MlJKUHBZeGUwRkJX?=
 =?utf-8?B?YlBtMFp1Ui9BbTFVakdFZnRIcjJhZ3VPYU1zV2huUG5HWXdCL041UWR4NGFD?=
 =?utf-8?B?bkRNQXQ1VDlBeEpGZllqSm9QRkF0Z2NXWHVIUm15QzJCRzY1MnlZZG52UHgz?=
 =?utf-8?B?Mm9FK3JLc2VvY2d1b3pzMUxmQnE5WWFuMUxsMjdIb3l3UlRnK0pGbzFKTzFw?=
 =?utf-8?B?NEJSUGJ4U2xxd2s1ck9OS21qeThjcDd6MEY2QUdVU04vYkdJTlAvOHdmcFpt?=
 =?utf-8?B?ZWpCczJZeE13bWx4bW1TckoyaUhqenZleGxkRDY1VVRxdjlHT2NueXl4QVUr?=
 =?utf-8?B?NjhPbWM3V2phczBBUkQyNDBxNFMwc1VNd24yQW8rVmVWWGFuUXZpelpTMUcz?=
 =?utf-8?B?ODdSUTFqWHRTaGNGSHpQNllyWHRxSWFNZmJZRXNpejJSTVE0ME5FMXppbEJ3?=
 =?utf-8?B?RllNVENPcVF2RW84YkNJK25LT1FyTlVEOUd2WFZEZzFoZlRrSFJOVjlCcURG?=
 =?utf-8?B?aXB2WjhRa3FrNjcvN0pFeWEveWpHVGdkVkc1UUMyZTNkK3Azc2ZvSXNsOFl2?=
 =?utf-8?B?b0VOcmN2eHA2RHluaEhkcmNETjhCV2hUTGlBd2VlRHNnc3NIRjlyaURsUEEx?=
 =?utf-8?B?RlRqRFg5dVF4Zmk2Yy9sNy9EbzVTTXVON0c1K2U3WFc0MEUwUnZaZFhWMFZ6?=
 =?utf-8?Q?uu22u+HoMqnsAgTwCPJqdYexN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7edfa4-1c17-4428-edc3-08dab75a6947
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 14:00:17.0575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bNAx4x3IrllkednPXa0fpkploUHd/kWdQt54RMIY8s/7tT8pJ+4jGKtLsSlUPD5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6725
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2021 14:12, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
>
> This series add support to set/get tx copybreak buf size and rx buf len via
> ethtool and hns3 driver implements them.
>
> Tx copybreak buf size is used for tx copybreak feature which for small size
> packet or frag. Use ethtool --get-tunable command to get it, and ethtool
> --set-tunable command to set it, examples are as follow:
>
> 1. set tx spare buf size to 102400:
> $ ethtool --set-tunable eth1 tx-buf-size 102400
>
> 2. get tx spare buf size:
> $ ethtool --get-tunable eth1 tx-buf-size
> tx-buf-size: 102400

Hi Guangbin,
Can you please clarify the difference between TX copybreak and TX
copybreak buf size?
