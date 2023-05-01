Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CB56F3277
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjEAPHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjEAPHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:07:24 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2103.outbound.protection.outlook.com [40.107.243.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E548E185
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQZCj4Nkz2kUy7Oz4qJDMcrFZOn6XB5HYKV4wlu1/mQwBCgxhf8634iu6grTMV5odSOeq+5YVU53hXOqAcBb8EsffWgZ3GsQw7SfmipV+dt69L0uAJfz1RnFaVrTPYr8RKah0pNdVEEG5bWPJuBp5U5Xn0nhmbDT1TMF22o6oecMeQKFIRW95GmNzuS5Vz02s2XSksUENjbHCw6PH4bTC8eZ5zfqVJI2vROIu3VJJ6/Qyg4rVdCpfoKm0/wS9N8KqsFH7eCoX4RK6ZJdliuMOmlJTs9DmAjaeu+ExBhLvskY+EvCBUFCqqYwhe5PiNGWrnrY3ro5W8wvbQIQuUnyEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLAzUK534NpWc2g+BM5FnwmNvAdXqKyAuq7ExQ/pHF8=;
 b=ZGSBP0enrW8vGmUKR/t8X0XR3vat249f78Rd289wZWfFdj/0ylCImte1dL+sidMSXBpjrBSnGOqemBgkeXfFUWLC6w1sBbfK8w699Nyf5pPWAd1+CD6/13tWr+cqXAdaRkijfDrYbS4WEmu78VcnHV355bDyMCLevGneY17R6XOSjap2W3kkoBexWiUsh9kR+ddAyI65Ujpw8XNTHxZIYq/Tu1XmVkRuMPYoks6VGyMOx1WPWevb2ztFr/C8OxD8QuXnTVLpUo1+XcRS0xL95F1DvnhPMBy83GKsWGVDUcTsZPVgMyyG4r2/QjdzHdMvp/jDoBtYaM+u82BYCteA2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLAzUK534NpWc2g+BM5FnwmNvAdXqKyAuq7ExQ/pHF8=;
 b=C8toRpqCvP213g9nlu9sINfwR5yk5fqOhr/qz3XQzDiV7MvcZg8Ev5yAV3RFQWyArtZvtGgPXHz4onrD6WqlFoOKfJ2xe+1B0Y3VzM3CABrL16rdykla8wCxH13xxZLvUXF6sCJ6vah4qEEaeRwlvT9NQX3kpC4vn/2q5obi9fo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3907.namprd13.prod.outlook.com (2603:10b6:5:2a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:07:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:07:18 +0000
Date:   Mon, 1 May 2023 17:07:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 05/10] pds_vdpa: get vdpa management info
Message-ID: <ZE/VnyiC/Hw5BAYg@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-6-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-6-shannon.nelson@amd.com>
X-ClientProxiedBy: AM3PR07CA0146.eurprd07.prod.outlook.com
 (2603:10a6:207:8::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3907:EE_
X-MS-Office365-Filtering-Correlation-Id: a1174e35-ff78-423a-8247-08db4a55c157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDcZhr6KhvQu0LTPFUpM5hbM6KotQFmrHDoBI6SvVuPSYKAnbWuNnnnBf6MOYmUb7FrcmU5kQzDgBNCIT4vUuKdSF5vpcYsw9ezXkc7lJp2mdBbncJdigBr0E3uukYjsbDMXS7lA6QXnvQbW7v6OnNZUK2oKb+XRgsAtZ34A+vz+DBXiPHwDJvdEh0rfntTVc6iwRpsBHwwEcvsI/yJcnn+uSc6BKa2ujNrEvpZmfCDL9KX020cXnFoQfJfaQNwxqEwZXocdFshTrmzMHAxUsiFymOeZ8326dGWOBdKsarMX5s474Je3NAP+FEpAFK+0d85HOgd4EJIbJfc83kIP/zUrtflgdyXn0vWVHndYvwicmocaH+KsRIZqG/Edvjj2WyjuZfxOdzHCmX0WPAaEHH/0/3J9xA1t1Jxd2qWpwq76OWOXh9tgTNOxTHkZ2hxBtUrI/4S/Vwh+X+s9M8fMp6iOhmT24HOSeVyzHRB+aJYOqgYPir8hs24CMK5UCWzEBKFh/2+a2RjlxjHihRk3wXZJNANHbkwtLSXbYX1+Bp5C0jW4NJvx8lONmmUI/AQXGQDgN0nyz3ftx4rXKQsvSLEqalSajmtD1VTlQM4BmkE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(376002)(396003)(136003)(346002)(451199021)(86362001)(36756003)(478600001)(6486002)(41300700001)(6666004)(8936002)(8676002)(38100700002)(4326008)(6916009)(66556008)(316002)(66946007)(66476007)(2616005)(83380400001)(6506007)(186003)(6512007)(4744005)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L4TODwVpZPp/y5qy1gUoZz0ZSSaxlNyYMc1MXS0RzV1mWFIWCosdwsqcpZPa?=
 =?us-ascii?Q?jEmmQNFzrOwAvgNHRTXk5980lRjUQCrH5PWQ3W0gCJ2WC6M2sjZ/5/vz8Ev+?=
 =?us-ascii?Q?SdDEhNKHmf27aSnQCyEsyVAogkmWVvTkjXcD/eCCVb/7YHtEIVdhbR5vbxCN?=
 =?us-ascii?Q?vSNQDjFlvdjghQjZx37dIHianBazTGpdduNR+T53/RV2qRuAFWseHo4ymM0c?=
 =?us-ascii?Q?G7qGHX9yWOz+mMY1rFOy+9mFwzJBzm6SAMH3hX1I9q2XxGsiwdexC/pHR67H?=
 =?us-ascii?Q?GX+wVk4N4ROSuw1OLmM6PRERD8jyGVelSMiC4RJ2LMmm9zWSHoi7WVr5xYeF?=
 =?us-ascii?Q?YSVF6evf/PZc164SoaccI10OXyc9JKimIwCf5g+b+MkLHPMbkySCAwmK9IKY?=
 =?us-ascii?Q?Lyx3D9AYIQXsdKrGg9RQzaqWNZyqdfeh84pcEUsuTXlgy2xaLfGnh0t0J11K?=
 =?us-ascii?Q?n64vTrAn4+c7HzLcUMVnKf/wpiq8iDat4qVLl4P0SElmL5cCponLw9DJGdQw?=
 =?us-ascii?Q?oxBLZFpKH4ZJN057Y9McL8xBZgMJICicpiM/LsX12rpot8rLuJffm5tqcrgm?=
 =?us-ascii?Q?3Zfx1YqntQEGYacewLAP29n1gTZjKRpyn8W1OEh92CPyJdAw4j+ou1BRhcXq?=
 =?us-ascii?Q?q6w8LKdd1rgCkJozMzVs+PzEpRpX5mOEOx0wnvw4i3oMUiYo1pcL6aQQE9wb?=
 =?us-ascii?Q?S1qmHZGLkSHD7HJXrVrOSE3Xf6RmnEjRMlbucHp1TSx5VmbTF1WAEthkopmV?=
 =?us-ascii?Q?y/000a8iUYDhrFoLbjlHYvGqxdpoi2RQJ7W6MZYnHHepH0AJHvK99vwwiDvK?=
 =?us-ascii?Q?HECKO8KfFJyzGkE4z48rXKMg5ALMtblj+Fq4aZxMjR2ru7U3veJbDnQk32ar?=
 =?us-ascii?Q?uuUQ8VYsmtXqy2uvFPZvTLRRFqLvMuWRuOwF+52oQEaOXee0iPAmM4qiN8xS?=
 =?us-ascii?Q?oWl6DVGDAHv7W+up9GtpfDg9Z/A30wdFhmbo+WHEyt/lcJDWA73TXLUyZaoP?=
 =?us-ascii?Q?3MXZih/EudI0DxfICj+pEHEoQ9Xmq5VBFUTtZZZZUuxIM+NUDzhr7ZZMNOR9?=
 =?us-ascii?Q?KZe0M0Z0RQNxmMffJV9fs45SNk0Qed/Ym7o2mNKLA9qkrmrdGxeA5BmxLUvN?=
 =?us-ascii?Q?yUEO1q6WCjEweY3qyj8fAZLpANPiQqQulTe/75X37dnRYKJCBDBDG2aJxbCJ?=
 =?us-ascii?Q?iUeH/sEwZoJquq5BzAnU8EIvmTf14237ZiPasgAtulpjgWr3dsOt+EpgK0bq?=
 =?us-ascii?Q?Iy0RgvlKIAZ4DX6PxSulkY/D/iFZc+1ty3NwpCuy3VwrAmLe+jQkI2m7m/GN?=
 =?us-ascii?Q?3ubHXrxCD0nJJEdpIgradKboexQmz+cPHFvDkLcDbYvelq7AG8oy2mRBiwjh?=
 =?us-ascii?Q?HRrD2DhQj+AbDB8gGiCOecTCDUPGDHb6UrXHtwPqbb43i29Sxi7UxuZ99/lV?=
 =?us-ascii?Q?XDRZGnSux89ZEamtgzRphHA9GfN3X2hWTpqD/aNhiDmV4YwBXcA757eJ7tnL?=
 =?us-ascii?Q?Q2+FNaZxPNOMQAEPOsCpWM+flwDOlgdkXlJoXwb6xl1v5zRWY1ebg68T5Qq9?=
 =?us-ascii?Q?YQ5/f9YvrWKpJMY+rmA7hwEHH8dWlZn09Nhwnn0h2Aj0YSpZquF4NZhCSzDA?=
 =?us-ascii?Q?Mvw14noGlZtqTqntChTvJ5Ipeb4eMhAUEv51kp+cZLc7Ki1fltNEwYEzaY2A?=
 =?us-ascii?Q?sLsxcQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1174e35-ff78-423a-8247-08db4a55c157
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:07:18.1970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VuUiPJSES5qZTWANgpQrSX8AHeGr77pBapPNv8T3y0Ul7OKMd73/U2Qpe1vpos45Oh3alxCENiBDogLH7eGz0WOMdYSTswlaYzY6zB4xp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3907
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:57PM -0700, Shannon Nelson wrote:
> Find the vDPA management information from the DSC in order to
> advertise it to the vdpa subsystem.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

