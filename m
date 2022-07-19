Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C283057A822
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbiGSUSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiGSUSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:18:08 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AD345982;
        Tue, 19 Jul 2022 13:18:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTHGGieGqtzDxOG9kn3N1g5tMOON94XzCutAsa3QDuhX/EjP2/lKu3/+1nhrn4TSg1ax2qcJ4FnlOcd+YPcHNys5xFzcvYusOkRVmylVsBcm3c2225NeT62SjleIThm4Bfj3rnjgsd2Vr91upTunSl6M3p6j+kTn8T49xwd/xfqiM8caUSV6fD8wYj1CtbxacjNr9SamAZKbaq2zN3WJZ+yYymOME+Na0ZMDDVHjH92kGbXpfJ/gl6+FqiSu+WDSqpnTo1i5VUHCMjS0d8zRoCZCblNhlKqDQIEqZjdiddoqlfNjryYusUATx8Xr0HQdhQAjU26BUkjasD26n+LS8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyQLoEAtfa/8TXNRRjLPMbO1VToOuh0H5A8z/uziawg=;
 b=OLDcx9KzZROROlGJ8r4VySrR0upAC0imzX86IPdp0QiM7vCeh0d7OHM4aCD9ZsppkwtCr5PjZ6/yqdCz5m97n0kp1L38IunYjtp4CcGoFHYBdxA+7V5pMVHZvkNPbodgLZvPQL4bK2cM8i/bQEPhD4ck5phIMzt/Vj+0QXJ0tHsm2rqNyqZ/OQGQ+rKMosObh2LQD6BXSuE8CfcYgSeXgZh89GaR0Cl5GtGgvwM5+RxwljdxFFrXsYTJXr6WgfCPxyhIjgRyRT7QLEwD9vk30vg5KTag7Rc7ug9gm8e/siJ1UO+fCT1wU+YoLlphjrKHFvOnuPiJrxJrqzlpu33/DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyQLoEAtfa/8TXNRRjLPMbO1VToOuh0H5A8z/uziawg=;
 b=HE+LH52Ukn005uGXXJvU63LVmeDzhXBjx4IiKsnQXmL21qlZ5sflVRhYlrzJNUtjyLDCvz0TxcX+zlVuv0YygYOlZGLQn2AArjlSpj37aqeKvvoH1wXszFs1tBMzf2K4nW+JtKu4c+JSFF3U5dLJmf3c/sUm3MwS3n0XHFLAjSuUlmnqMIGYeVpvOCZdSQbsZff9C6JOgp1XqZs/tT5BXhfm2kFEBTuGSLSV0No+b5fYX51iXqLBNJErA3rWY7u8/uA4EiJEDyXIYzpw/okYfr/Ta5b5Sk4bhhbtO8EWWP/9dncqCRXYOtR6Q77x9nuB/q6giBVBAymcbe23P8/8lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1145.namprd12.prod.outlook.com (2603:10b6:3:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Tue, 19 Jul
 2022 20:18:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 20:18:05 +0000
Date:   Tue, 19 Jul 2022 17:18:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220719201803.GL4609@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <20220718162957.45ac2a0b.alex.williamson@redhat.com>
 <49bb237a-5d95-f9fc-6d0b-8bcf082034c1@nvidia.com>
 <20220719135714.330297ed.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719135714.330297ed.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0293.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52bc68c5-666b-463e-afab-08da69c3c9ef
X-MS-TrafficTypeDiagnostic: DM5PR12MB1145:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWqONoD8Yl1eBa3ukcPW0A41CBNMom3CicySFYo5YVMpHkEt6D11JTOixmwqiJgIijXwRQYT2UstHQu1udHF7Nhrmb5uabf6guM4z1reMGNxxE7Um26WbtC7MmYQjkEbe9z53S9FebMwACCwxOt5m7rAd/hLfh0pY03YIthYNMA98POHVL++btxsGyHuuwiuRLbrRS8ajvnZkIomBE8NcXvZ0C0pp8+fIVU3Vq6drNbS5tMhkLPPeWKgakZb09Q9LwYY40N2hQ+VHK4DGLUrewYt1b0yJaezwzTkIKnFDD9WUthTR4piNmlFkL9ERUpYTcjLRm9SoYmdzPtNn0TYNj+N8Pw0dvd1q2eTZQrFeMgjoqNU5PCkgT1q7HdcYIzuPUSBWISu4se0W/55onGply9PAYm6/Tk7xXFGlnymZ2DHT1tzuGxU5rGw/xNYtFNRKbI2vtjb0SgPytU2qKJ1vSGirqBL/+hzcaXEeBpyEJr4O1iTiTLEJsB1IHi51HbyfFBgJXcp6p8BVTpAKpR/OwWIgYlrzujvDDOrZIBn7KAcih/jlh0B3NV3f9U0YcNXMXpd4UH0gNj9tzdvhPJ1snT3HAEUazU7IPafq745NQzgDsDWF/ZolJ7a8OdwuUqovY/xP+2NIxvAMHBjg6Ai1Dhh2Ku437JAdj2a71YscNGKeJRPCjRnGJ4xAZ5npmSnGNC7YGpJZM5TMCvQBs2d54g8QxDhHnxZK0KD5pxcM2Pj8koHUFcwi17c/R9H7AlR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(4326008)(33656002)(36756003)(8676002)(66556008)(5660300002)(107886003)(66946007)(66476007)(6916009)(54906003)(2616005)(8936002)(6486002)(316002)(2906002)(38100700002)(86362001)(6506007)(26005)(6512007)(41300700001)(83380400001)(186003)(1076003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Md/Gq26Nm5e1BSAMlK2BMwQtZo7l5q2M+QOK5ZFOCA8sG2BDy+yJb3V7GuJn?=
 =?us-ascii?Q?gi3JGL9L+6jd7r1eYViSTB8gAWzxltMNra4eKpoxgkLACo8nBoBccmF3gXq9?=
 =?us-ascii?Q?+CmtDvaZsiNucRbpybe7hBUPy3TQjuonP8XQsysPloOP052BtqaqNiOodiNZ?=
 =?us-ascii?Q?Sa6uKf1yzyvgvdZLojrfH+UbXURtAqke6uVnMLymdHhJg09g7P6nVKHEihw7?=
 =?us-ascii?Q?4bYkNNNZN/d0FGir+OTFhNw/3S/2pxo+IqBaTtm3AjJU6OdZjsVIQJJkzVfX?=
 =?us-ascii?Q?llg9/CNg4WBKH6qjlTDPQbutWQGJHXGmS04kizfnpD2mwq8wSSUQCd0p3Umr?=
 =?us-ascii?Q?nXu2pX3szi7ZffB3khiPFaO03ZqE0E0h7kdy6NA73cs+LhAl7ErRXlOOkEpH?=
 =?us-ascii?Q?E8AGsdLFrTF0ftku7Oy2XvhCjoC/iJ5rMmQPbasQEYqBLGSDCpppPEUwAf3M?=
 =?us-ascii?Q?HB/7DcM664547syOCXJabaG9Z51hLi7V+C6Jbz/oLHhlt4WM+iLN9QBu7QD/?=
 =?us-ascii?Q?Fo2EuNEpYRlss+WMFXPnh3lp5VTUzPOQryaFgXeqQjv+dfhA/gA0WzZ9bjzb?=
 =?us-ascii?Q?c09JcalYrexG5UUVhh398GqEulTlkv938SElqPBGHeurA/11tavRloUGW/fO?=
 =?us-ascii?Q?0/nQq6ZZ35PPSvtHMX0BrTj+SjIuPfOhH2WHncqwjx2qQ2+W5DdolfIMCZDJ?=
 =?us-ascii?Q?Kr1dy+TYkxAgqfVhbfx4A0F9XwZNkYc8USXFZd+if9K4nGp4VhLD2ONLRgk8?=
 =?us-ascii?Q?xgSWRIa4Kf591ELBUJjIUXEeT5sQuGtVFxe+gfQBMn5ULOlRrVbnQFrH5StU?=
 =?us-ascii?Q?ekN4Y0XlIT03s+XzRLztMzuDSo8VVbVnCoTywwwQ7gLL7QunbKBvVTMIMstG?=
 =?us-ascii?Q?5Qyn8yhNRCXFO6siXsGgubXVFf4tlv49E3lPj2JP1YYJke2n7gqJ0SqxnoKa?=
 =?us-ascii?Q?S5p3K+3IVZh7Ylf1JK1kj61D9xVF61FQcu3wqkItQrJUKe+g+Ui/hte1a7T8?=
 =?us-ascii?Q?KVLlJLuwBaNIIZk7KYniAue1bowLFI2VV02tNGRDN6iMEBiPRRonLKBYBCbN?=
 =?us-ascii?Q?xeQAVV1zjv3nsbblawK4m7eELLy5u+tKno6x1sgQiSBNzlN5EkroDjKNMQjl?=
 =?us-ascii?Q?wC/+PWfMrTpFa3YbJujiUUncxmgnsTNRhJd2CojFB1nWEV7q5NyosZUDcNz2?=
 =?us-ascii?Q?+SBV4SUgOJTqErzudaSiqdly986y8SG2HOkvlxdqLxc3ENreWzct5/Jrtue4?=
 =?us-ascii?Q?f2/JiOnz4qkryrWfPXtSTzcFzIkfnznaO8OoLLYwgi5SRUBa00bTYDOMOmjI?=
 =?us-ascii?Q?Ixmof9eXyCDbBMDuTEmd5xGBMvxSAp/wBheYpx+Jem0jgbEdYantJzARy8O+?=
 =?us-ascii?Q?EpHRGjOmHxGqN9fVUbaDqSKb5DznuT8fCp7BX5mXkDhWmBycWh6tusyb5Kwx?=
 =?us-ascii?Q?Mr6L9NXQQANnQE8UO3ytFinfni9T+wNb3mc6nVzAPBH2lzp4dG70CXEsX3Mq?=
 =?us-ascii?Q?R8gLeZm50EnCTaH/1CzDKX4PX57msCOyLafoeW77QaI0nuNRkkmEirJL0TZJ?=
 =?us-ascii?Q?T+jrAwHXfCVGb9fdZktdkogS2DsoFwKwEPY6xV6t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bc68c5-666b-463e-afab-08da69c3c9ef
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 20:18:05.5845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFqRTCj5rMXH2+9qHxrR8wezX/9NjQwL2c91arpbwjK4cU2tRYLnDnkpC1WwBufN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1145
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 01:57:14PM -0600, Alex Williamson wrote:

> If userspace needs to consider the bitmap undefined for any errno,
> that's a pretty serious usage restriction that may negate the
> practical utility of atomically OR'ing in dirty bits.  

If any report fails it means qemu has lost the ability to dirty track,
so it doesn't really matter if one chunk has gotten lost - we can't
move forward with incomplete dirty data.

Error recovery is to consider all memory dirty and try to restart the
dirty tracking, or to abort/restart the whole migration.

Worrying about the integrity of a single bitmap chunk doesn't seem
worthwhile given that outcome.

Yes, there are cases where things are more deterministic, but it is
not useful information that userspace can do anything with. It can't
just call report again and expect it will work the 2nd time, for
instance.

We do not expect failures here, lets not overdesign things.

> reserve -EIO for such a case.  The driver itself can also gratuitously
> mark ranges dirty itself if it loses sync with the device, and can
> probably do so at a much more accurate granularity than userspace.

A driver that implements such a handling shouldn't return an error
code in the first place.

Jason
