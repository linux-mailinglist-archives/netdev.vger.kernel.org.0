Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1626F311C
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjEAMoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 08:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjEAMoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 08:44:08 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3E119BD;
        Mon,  1 May 2023 05:43:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtyprcsvBtEWHYENq8bh/kF+uHK8CCan/QgT9pK2yaTu41/mrDN+SijcBQ3y9Lwu3pEvtHKeDlC2JgPHo96I5Y3bsiyRBGAtOrW/T+yHhrzaeT87KhWpQu17oooHl8BYP5D8CoQBuIAkx5vejGdba0wyE9c7xYZKhsuhxCR9/YMyUFhDmX5aocsTsmsju5wcsjRLM5NFM4NNPcCQyt3d5+L9EcJafpWadexPGt2Rd6EFVldGeo6jYhwWYximG8MqsT9DM02SDFvRZzXcY9Qx4cH9EkAk91GjyBLUA5QRy5qObMusc/FfVVH6UpfFV5LatVv3lYjoQmF/eU+jHLGz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49enj4bGHVDbPILFVd4Kk2wFJyZsPnu/YCWf0MQVgnE=;
 b=gPWQ42Wv+dNAdT6IPOnYytL1jKNOTKP1NZU1O3y7Cw+e+c0XOgqclssGy3EI7YzXL/9uSbWxra5cDKyTtx9EdM6xlN77FGpWNA+5J4+YNSjaWi7BUgYgU2mT2zLr3ItlB8mvcpp1EC9T5sNQfWwXd8D5hauxKc1s4WCc7LkyT/S/PmvWDQDDmIjb1wBHgs/VdzqXqz+VxLHcdPZDchh1SH9ZFSr8rO0WFVNOFd5p7m7xS8o15bGFIwnk0Jbv4Y+92NBo6R+CrYIxs4djdBlcj1fPAMphBEJ5tZIeISGtbc5pb/jF7axoHOZOtKKsxwraLDzd9h6fHHD1hnBiQVcGNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49enj4bGHVDbPILFVd4Kk2wFJyZsPnu/YCWf0MQVgnE=;
 b=nTEPAXzMpcm8WXcCTRfdrl/408JMRJn7qmtVTqYybo9+KVRqxIwZBmA2qWO9VC6htBKl4U+u6y3X4bjBDmnTSGXiD1OKIsS8fOEXNS0VnW5qrq7jfqQSq3G0IZG+L97D3iBEDOYTgyQRycfZCRdI6D9F5Hob5+2+kkxlnyMs3EA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5001.namprd13.prod.outlook.com (2603:10b6:510:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 12:42:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 12:42:59 +0000
Date:   Mon, 1 May 2023 14:42:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Feng Liu <feliu@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net v1 1/2] virtio_net: Fix error unwinding of XDP
 initialization
Message-ID: <ZE+zzGF3r2Zo7coK@corigine.com>
References: <20230428223712.67499-1-feliu@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428223712.67499-1-feliu@nvidia.com>
X-ClientProxiedBy: AM0PR04CA0119.eurprd04.prod.outlook.com
 (2603:10a6:208:55::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5001:EE_
X-MS-Office365-Filtering-Correlation-Id: e71a4701-77be-4747-1771-08db4a419867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZnUmqdtydCMzYLSfeIj16l+RGgJt34X0yjakPpxNzkwzjCwy/EJVmQOEfW+g7LVwr41VtwwO6NfYs5N1QxOWboBlfEjndjzVA6RuIBGNU45Pv2eLFSM4OGX/rXmXEudr2PYwblfdmQwkFYKHAZitM5lsfcv6cE6ZRnkIokBj8kHxDL9m00iqaC43YUgNWwFjKCaHrxhlJmv17hav5W09HGiP88fVhCCtvl+Fvl7xSzXUIGfIxZXf36ol3Clh/CEp4BWD028b27kP57jYw/GCpKAoft0xiJ7m4G1mPQM4QGm8I1M/u54uvc1QbrqiyEMjgZGjc2C7G29oNcpPbpqGVPw1lS6iSQ7P4PIIgRjil6g2OOdXKQsFtlMRoP8PJOOxN1DhnM3QOqLw24BCJcLrGYYtP1guBoCrniqxtNHl4BxaX5arIgdaGSFSAoTaWV+9wmJUAa4WoNuvL19Va3H8+rzxFcHGp1wqH8ON7a8uMi8iGw9zDssgDkA/2AbbH8gRvCoo03gr8BKRd70SI8L3SaFDpEZ1WoLNBRzOZoDHNDJhNCddn20t6pItT2YRPZNNMjw+8DezZopOv1pOIrs09CC8HzBaKW0Ho1zoN0LDH4OzryUil5q8LY+zQb9FtMQeRUwv8wBwRJ/ttpXPflcNHc8QWaT04nLFrSYyTCRZPU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39830400003)(366004)(451199021)(186003)(6512007)(6506007)(7416002)(44832011)(8936002)(8676002)(5660300002)(2616005)(36756003)(54906003)(478600001)(316002)(6916009)(4326008)(66476007)(66946007)(66556008)(86362001)(41300700001)(6666004)(6486002)(38100700002)(2906002)(4744005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HjMSVVX1F5Ayht8PxeAzj6jp9RVZvsINiCxEgQkRkHMmCJmpfdlIAQBJtkNu?=
 =?us-ascii?Q?cu/wihz4OkfttVcNbwW1bIBTLYJqj3e6Oao3I2uQyIUdY6S0fQEgUna/iot3?=
 =?us-ascii?Q?wRgRLivHlxDnSpdeCDH+Xgl8JZOIUheVk4tfmvlcqoU4ajSo+x5WjrGj1JFJ?=
 =?us-ascii?Q?tTvPgos8HX8bf/3uPYOc9QTP0gTbcznh6722RwLp084UpwOP7ZgIG3gvQ/qI?=
 =?us-ascii?Q?zDth/eDhxdtWawHKsoEXcM8aRM2kaFKCP1NoxpGateFjOEytvLeLNab2hMTb?=
 =?us-ascii?Q?EOXygiLND9IBP5ZbW47EvS3nenN/0it/DTyAYbx2Oa5bf92MkL9kXliT9S5y?=
 =?us-ascii?Q?q4aeATBuSte8H7CVxtV4J1ZzVTPCKzaQIX2MKmcS02fNQxPbwp/xnT1lUu3Z?=
 =?us-ascii?Q?GvJJRGg0XXRBTaUIKdcWfwbpS/RnQJxdtAWDxmTkVbN053R1CuibgwuL80Ii?=
 =?us-ascii?Q?6PWW2MtD+B9dzdhbPfu2g0iiCkk7Yl6lHIjtIz2J2Tkzh4gxlTACtVKIqSMk?=
 =?us-ascii?Q?qNtZkyqUpflxgDTh2VsXn7qJc9sai6Osrqg4EWOBerlhb4416C9HohKgDsBd?=
 =?us-ascii?Q?Eq8HVxkPFqpGtsIa6nlmQqtFy7dK5iaygph0PEk4BipmEbiYIu4ZTlC7/nPI?=
 =?us-ascii?Q?K9Ws1LZbd4x12O24+ZAMcSX+VhCs+lWhedMv+ioDP6XqQnO/5AGdWVbHocuV?=
 =?us-ascii?Q?dsmyAoDY7qPwMJoBxXblKeA0KCugdA0GzjOvw6t4xEQb0sl1rPY1/DUOymxP?=
 =?us-ascii?Q?ibNgbSIltjjunRKn8ySFf0B7ybkZblSkIlsY4b24V7C2HvDD8X39TZU/WJl3?=
 =?us-ascii?Q?T2Cf33JL0yE6PMSJ7+E+jO06a8PZgLvYwt3zrjSBbDuYY9OHa582NEhMh1Lr?=
 =?us-ascii?Q?znGOySxNuyd0nOS1iIEu09iphSy7g3AF1gvTyQprkeCmrwcCFP9+CKaWtcCG?=
 =?us-ascii?Q?FCbqmSKK28Dt1uLVy8me7NVbokYfGe96q3vtZOC7tU/Nbz9tiGgX9F7FcOvw?=
 =?us-ascii?Q?epBCnZyfPqAJ5WB40XsCOesZX+4E9ohKYgEaPSfaFRmq2xFaF2VxL2MBlSP2?=
 =?us-ascii?Q?qfMWspSdkSLFJSA0FQvsSVKjRLyJWHiifEiXJCHkWXwu7o8YzAZUvwLoTmFP?=
 =?us-ascii?Q?M/X/cWXcePomWH/rmADJ4ZCto/nSBwBXKePPP+lTM3xttG95x0c3/V8/B3YG?=
 =?us-ascii?Q?1oTLBG0vIyf+g9mIXEmY1cimQZmCNROeL4J67L85txfY8zjTu6qtsHAuwan5?=
 =?us-ascii?Q?ApwVVThhD0aSvn45srnR5I9R7vwOfFeH1z8RK7c355d6hkNKYSZBo7kyFGPF?=
 =?us-ascii?Q?lrxamO19D+K8RjQ+hawRLuRYxKNht3+NS6w0Lrq4pg8QVfVDDkZZ/+LWC2he?=
 =?us-ascii?Q?7H/7jOTSkVK7KjTXYwJxMff86kC583JFMwG8XzKVKMxnmYncyNDzqjYBveY3?=
 =?us-ascii?Q?2QNNTVSMSietKLD0apuAHkqUWFM7FCJmxxfAXGiIIn84ki9UR5+THMV4CSMO?=
 =?us-ascii?Q?DkVwcdbvIYCoQ23HQtKvT2ldX6TrSFOPTMkHTM3uk+vtlX2mViqKjNMl9+X9?=
 =?us-ascii?Q?meW1xNoy+lNYjSh2l31pr8Sicr5CJ/jA3VBPT869NteBTG+oDjW1H8bpnUCV?=
 =?us-ascii?Q?kxDY8aBXjj3c8t9yLJELqg9dZrLwzNeby4RvoVT1zfGuFMNbaLF9VnhECnoS?=
 =?us-ascii?Q?JyGeCg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71a4701-77be-4747-1771-08db4a419867
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 12:42:59.4543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcwBiDgr6jKDPnBcPQRTQMr7B4Xa/i25MfhWiGaVygEizmdMyQezWaO7NZlNyEdHD8l5GrPnOCEh3HqCUhRaPMdDSZQ39jzapS6MiOHqubk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5001
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 06:37:12PM -0400, Feng Liu wrote:
> When initializing XDP in virtnet_open(), some rq xdp initialization
> may hit an error causing net device open failed. However, previous
> rqs have already initialized XDP and enabled NAPI, which is not the
> expected behavior. Need to roll back the previous rq initialization
> to avoid leaks in error unwinding of init code.
> 
> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: William Tu <witu@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
