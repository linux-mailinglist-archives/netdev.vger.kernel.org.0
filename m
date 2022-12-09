Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DC36488FC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLITcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLITcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:32:53 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E078D2018D;
        Fri,  9 Dec 2022 11:32:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNa5Ot0xGOgUgEaLocofpTV1KFnrlssUpxeklRoqbqvauLRlFIOigAvbSkoRLQyxWLZZVPnnHErm5czb/VtdfRdrHidMtT+CJVUdOkD5eZlwU+w6gRYqZHsXrr0C+s+45WNjqvH5snN1P6AuLRjAa5MiRTAsEtdXvQXiLdr34rZYr7FlL8pSfv9E35aGrfujEjd+WIA3fodvAxx7DmHhBmUluBJTTsRJ/Keqd9uT6F/ccJ8PQTkfh88+AwkfYTQH1YLuEYChiky1rk29Oa33avgLbHdEQKAfbdAvFGAT2iZX+ZtBBnJR+uOW4leFGluC5KlDSL3qVCdcNt4lVg9RMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2ZSOIt8MuYv+kiQ3iOjxUqINIliNSfx3GzoDWM+HCQ=;
 b=jEHSs4g2VMm+pitjIpabJSVF9YgRgA/n6fzEnTDswgLJjzZgyQT1mJHAl6k8yytTLQUs3Q0/8ukQ+105sXi1o07wOZSJquLUSg2R2VV7Bc2Bv3xZ6bNMP6RsFv3KmDL8zP3arlDscHb2Q05WzSo6Xccu3FQTsLhOlbWH+4bAR69X3ykZ6IdK6ReR9afuBgoiHXW2vd0u87TCugjyY8kA6FQlV8Ror+jf2GfJz2ROfZnzgV7eGBvO/h3VGDC2qZn1ObY79Q5qCkWQSs3/0yT0eVCeHlkTkvSES23QuPxstBSLWEUdFgypGyEorxrRCx6+PWk5WsZVS5TGkqr6nxi+Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2ZSOIt8MuYv+kiQ3iOjxUqINIliNSfx3GzoDWM+HCQ=;
 b=H1dHz6DVDLWCY1GyCTWkdMUi4s26w2PAO0+Rm60mrCBwsnjYhCmnT99SXASFY9I3Bgr8l6zvnv1gVbajT046Hlwe8BbGRoOjSrts60SIr0PPxUnn+b2Kd/u1/qmjNv9gsfs5kL0ojUrfzTISImOxt3LI57zLtQHuVDxGnwJMR1MjZneXb9MHOkt1jor/rt/TjYid/uHPMTW0PDE7AU9BPoaOd1idmyJk5dCqnSLCICloVRjH7FW2MrZ9a/ZpU0UAln0QG8jLZpfrmuDuGp0Y0cTrspY71AcQmKif8uuc4xgEx5F/2e/VyRZ129iwk3BQSFsnviqnNlADUqqeP/ZYhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4374.namprd12.prod.outlook.com (2603:10b6:208:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 19:32:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 19:32:49 +0000
Date:   Fri, 9 Dec 2022 15:32:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Message-ID: <Y5ONXuY+TlvOx1aV@nvidia.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-3-anthony.l.nguyen@intel.com>
 <Y5ES3kmYSINlAQhz@x130>
 <MW5PR11MB5811E652D63BC5CC934F256DDD1C9@MW5PR11MB5811.namprd11.prod.outlook.com>
 <Y5OMXATsatvNGGS/@x130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5OMXATsatvNGGS/@x130>
X-ClientProxiedBy: MN2PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:208:23d::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4374:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ac40031-f452-4212-34ec-08dada1c26ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iagGOmxvRtaJNvdXkL8omjVTTGnj7PZ28w/WmWDkpLejhk7qLrrsZv1pdl3xjDLkVhpqFTCZrXxcc2vZ+hyYpDgu4qnvSnCz70EV1vn8kXTqYQECVKgQ0t/YmQue9s2XY0xkCTSkSzDU8Ks3wMytEHff+IA09l3sJepUj7v6TP1nA7IqqWo+/hMOb99qp6x5PGr/OcA0rIU6mKIejbG3A9DqI66p5/fsc6iBLxddYfhy/yYk1svHmjwzaHL9RofoYHDYj7DLYtF+QIMLFSnf5sh3slMaRT83Lp18MUzNqmrXwhxYN5Cp/IkCPEcssXM56uqlGLM0i9/7i6DrcK6H1h3zRu2MUxLrr2Gn8aRNEoEVeQIMhvNMpwDbsD/75JuTr4mjC9TqRRgN4064WYiKQjVJRFfQNal6XkTrEoLz5Cag6WWrBrAf9+0+z/Ooju/Vthn1Lk+MJKz24tLVR7dWh/CcfvAvgSUujaSNDwVgu7ljTj8r/YTlXcKuzKtCh98vCdVE1UyBIM/1/zBNyWcthlPSGXW5tk3ZUTX9b/g6/YRinv2UlZA+U/3BROWjv8KqdUyByN8wL7QHk8OCXSkn/Iu5xSeQHXUgFbiCfz0TUGlO0Y58sU6HhvXEyCqRJNkHthD9NFyano7KAtfNmDJI5cUxBf/ey4Kju/tlCmuJd8QhF54Rb10uKBsDJqVbbtX1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199015)(4744005)(26005)(6512007)(8936002)(6506007)(83380400001)(7416002)(5660300002)(6486002)(2906002)(186003)(38100700002)(316002)(54906003)(6916009)(66946007)(66556008)(66476007)(2616005)(41300700001)(36756003)(86362001)(8676002)(4326008)(6666004)(478600001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iVjJjWuWcTjxUyK20MeBDq86uzlNdSW1IX+jRXuckouVFyFM3bM95Sz0gZM+?=
 =?us-ascii?Q?ZGT3Ak/V8OoVTQ2gIcFDyn/8Uh85IL34XTXZhBfrcYmqmfG+ZgnZ8k5qFNL4?=
 =?us-ascii?Q?CR+f9SEmbnfHIj1yP7xB3Zeq3JxXLi+Q7C8JOpeQtzzIa+XyFJ6LeDAxPBTJ?=
 =?us-ascii?Q?4fnsNhn0zmd2AVU5V9mp1ZCkA9NhGwEuarDs0uvXrC1QGEilzw8mWuA3U/CJ?=
 =?us-ascii?Q?KptSSW6NOlNqiwG2ks3t3aPb/ZY11l7em0DK2WCB/w7w3N0uXOiltPWtVGZZ?=
 =?us-ascii?Q?qqPaZZOTPxEjcU/TDaWSX6UeJGQJpYIp0MDz0xSBBbWHH5urwPi7cBUXVycA?=
 =?us-ascii?Q?dIWOBtXB8CSHG4mqIY3ku+NH2tE+aG2VMmSrPWPCmTA8JrcRpUMF61Kvk8Kr?=
 =?us-ascii?Q?gSTtradFJhyzgvcCxBx04Tl91pzJJRT672hWigSMtcdl6KXLmyniCePXmeJX?=
 =?us-ascii?Q?gbwSEkJ4avyu1dtCrR4ljY8oF9Co4eUNYkXEsdwn7dgH7WMuAeomq65hfcof?=
 =?us-ascii?Q?aafJxnQqg+Iwtm9S6dTecOQSikTP0W1qVrP4CNUJy1XYmfXDaioMsRolzEUt?=
 =?us-ascii?Q?jY8PXGl8p6XpuOnR8TgrUkmPRKdLltYHoINCEyZO78m8RdTUrmgojW0Ief5g?=
 =?us-ascii?Q?/p5yWXsjT86kOjbHi4EJuhuLy4lC2LZtNKfAiGqoskKC5dAV3a6PVdi3HLgh?=
 =?us-ascii?Q?7y7n7bmkD2J3gm5fIRyXRzr4MKa/IlOUhk/kr0F4onJ0wjYu/CJLkQC63Qv5?=
 =?us-ascii?Q?w+WGOYM5iJejfWubSGbWTj1Wg7hxfOlcshiwR6VVv0n9lzveixMUUYPAUHiD?=
 =?us-ascii?Q?7LGL52McqwIg9FIPHYgTk9L4vZjqlhNszfqeCCBLpWz/PgGcZ4LPfSJBdLn9?=
 =?us-ascii?Q?Im9LFaEBoeQ3bgtikUgqZpXIUGAJw1V+J4Fug+XnjB6WgBUaeEoq+LJ88zBJ?=
 =?us-ascii?Q?QESpSccM2pcMepcq8q3JAetlGY8xxDaTbRXT9x00PGrPWiIyGgVMUg1TOjgM?=
 =?us-ascii?Q?bzW3FM/dpem+D6KtV2V9sF8uRxdGe0l6b6P6kbAvk4c7+nFVddu4twzK7fVW?=
 =?us-ascii?Q?DpxrVGWfe1AQusB9kr7hwXqs/Cs2Kfxu3oAhD/oBG82AHIOvQdpc6+uk8EsA?=
 =?us-ascii?Q?tAvSoMRbcyE+Xew/LhoAYja8II9tIAd2F4qrcaKcPtlOUEUwuolWI1j4DYIE?=
 =?us-ascii?Q?6ylUZaH8/RuD0KbRw7imUxhQKNKsoJka2gQF2x4DmyGxGqq1q7+S0eYp53+N?=
 =?us-ascii?Q?yIyJ1oTdgbmidRFNiwEcYORANDL2R68rivBn6I0luebIs9pVWaXZKjYzSzAm?=
 =?us-ascii?Q?NHpRzstr0pH3b8PvoVu4djpXZVCOUpkLcbztdmscqc3TIvC1mnmDzgyYNnEu?=
 =?us-ascii?Q?wPmsSSx5qMWV8aXTPnLbs3HVlLZXn/rYxGpjNyW0gn09bXFlGtgmXF1kZwPE?=
 =?us-ascii?Q?ZZwtNHYoigNDY7ePnf6r2wZxJG7dMXFlL6/BbDHCUzR05qHYEUuE+cb+cUc9?=
 =?us-ascii?Q?opGmYaSnjUuZ4sb2Gda5EPfyiryAMkzE0GcJksPNdn2mVAGlJ+f1gPdtZsAt?=
 =?us-ascii?Q?ne7+28b4e62WIR1OmPY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac40031-f452-4212-34ec-08dada1c26ff
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 19:32:49.1878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXBC7CanvD/FHQDi2Kl5FTm6yoRtOe03NeHRgd1JwdfLNIWhkkdMa2tPFrHtQdtk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4374
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 11:28:28AM -0800, Saeed Mahameed wrote:

> IMO it's wrong to re-initialize a parallel subsystems due to an ethtool,
> ethtool is meant to control the netdev interface, not rdma.

We've gotten into locking trouble doing stuff like this before.

If you are holding any locks do not try to unplug/plug an aux device.

Jason
