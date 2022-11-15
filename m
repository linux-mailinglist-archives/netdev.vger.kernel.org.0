Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86C762943E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiKOJYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbiKOJYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:24:05 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E245DEA0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:24:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APeR/pBpZRBGaT1max74rpqbiS18FCQoaOGOcLyNzvi0MQFNCMMi4zDOx1TWmaQWPjH6UTUDgKMabo5gjrj81KuHhDu31tT7tKBzG/ST8eUIsr74KLpI9lcYhxONUyR3mO54XYmVJ6McI9fn7q815r/Fpl9WbywRQ1BAADiSqWK3iBcMcP6T26YWc8bOp9rHCVf97O1gT2Bi1gyCxMfBNg7v6Gq/PpOKIXfWlYzwlUygpox9260xBLhq0pcchmMkhtFVSjPU8Isvvd7FAj3Il8/Y3gKPk8JMR1P5Kj+xZ0h+QcSfFKKi4wmeO+d7Z2PhPOHRQve8Z3u4dyKb5XEwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZatoyyx1rB1KL30X5xZ7XKww59G+1QrQGiLUNf9ZMA=;
 b=Y7nTQl/yU9Rw2cCHW+mbdr2F3Ro7cV3n3er/XDr5QaKqMCkoiSEoxUU85TRA36a1eD1NeMCLqquLcIYaWlCjM4bQXlWY19xTQGXuF5U7rvhuFkZzBsn3VmoSJKZXUFhozjxmiOD4fyTPDGg01BA0oHvKwEKqqKFC03ZIn0NK1npGCANdsZ/Nlf9w77i7hPCv15E6uOSgYkOy7IDXp3pfpkbAlQRvrwwNhhAPqEoMwk8OQ1GL8r1pdDlLOxkrNDOqD5VwsdUUoh4sctrtxQ241rpzea/78rXS5O1Qqpg+PTdOfS3hIrtth3v7WBg5guSazdzxapTrxakUdby3Rx+SIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZatoyyx1rB1KL30X5xZ7XKww59G+1QrQGiLUNf9ZMA=;
 b=dZkZqhl0GYlFu33IW4MsUglIqpaBhNtkjLQIT9tAfhczoomOJO4/3wGKVRGrkTidOawvqtxgqf8dkZ6h/sxOfFapcClP2Ao8g+1zWLhN21KiCzfFm/Dknwa08OedaYZ3higzLh0VB3b+nIYO6phvISG/+WG0AhCvdDqKYqD1Zy+XDeXdfYxVMkrbdRJQ48eNFrHLggNmmU75Wht0Kcg7gJQ1mgUzkYMQVE5sRMYEaP42/i0jYKayoZOgLSW86tBep8QatHGWFZK+5GUeg1VexTnV2VSB16Aa8CCMoyGXsz7q743f6WtZ29coSdtcPAIOYwp+ANPgtnqJhEDVpWlXTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6166.namprd12.prod.outlook.com (2603:10b6:8:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 09:24:01 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6%3]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 09:24:00 +0000
Date:   Tue, 15 Nov 2022 11:23:53 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>, petrm@nvidia.com
Cc:     netdev@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net-next] mlxsw: update adjfine to use
 adjust_by_scaled_ppm
Message-ID: <Y3NaqWlpp15fYJfb@shredder>
References: <20221114213701.815132-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114213701.815132-1-jacob.e.keller@intel.com>
X-ClientProxiedBy: VI1PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:800:60::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6166:EE_
X-MS-Office365-Filtering-Correlation-Id: bf62c47c-91e1-45c9-10a4-08dac6eb20be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pur/HzaGBhB2fjiaYMA61HMxDC3GC9LwtyDKqtLbJQn1iFJgH9KZCUP9YRbFzmL0Ps+xsLPqMTyqQgdNvxAEFAZAWMrPg2Umn8lEVEg5eNCNVEoMsCDTNfauQ4ljpIp+F9qyBBD0F5IYRx1W8qxjtMhjhJmsn5g8CjJROda3GKTQ5zN887eSQrw35+rx6+wsm3z8nF86xArZWnyBuatXqOhV4SdtQt/p2R2q4kkpf4/GPrYcz6uHUM1CwXkF++EgQ4CDx6lZ45/Wq/Wpy0weHVSJT1M/UYh5BLJHM3b3w/Uu+XO43RZI4Zy/O4wPNBu3tGaXirNZtqLsw/0uYAWmvBSm/qKgrK46inskFPCnTZoBYOcNpg2hIdCFGP3mR7YVF8+w9Yc/JJ+p8mCRGuYUgetve8vsD8B3RGadn7O0Q7NxJ3BFtfKv2mJeH+UiaQvNANsL0D5M2NwTmWDlO+sr+INULj66MLuu+KPE+EuXTorsC2jh0jcfuDDZRQ+LvaQQgglE8DF2qzc+Io4Xl55hQDo+ZjU5tb67dXwSb/gK3uHh1zgiKOXkLXWGTN8T3clSGYqjN0cTp1881eHkLJEV74vo5KQgxFc81+0InvpqX7XFBW/eG6xYQn+MsTPV8OequNQZHmQKEuNRCqUs4teeLeZ8RyjxJe5RgFtXLhClTaYr+xivvMbdb25KeftsdP533W+9WgxAb/WBvKnuxsEcHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(86362001)(186003)(38100700002)(33716001)(2906002)(4744005)(66476007)(66946007)(41300700001)(6506007)(8676002)(6636002)(316002)(4326008)(66556008)(54906003)(8936002)(6486002)(6512007)(6666004)(5660300002)(107886003)(9686003)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lThZZVXK06ifx1OqcufwRISjgpB67p/CqiFi4a0z4xEcEHXSFx3BPHFm6YTJ?=
 =?us-ascii?Q?08kzEzNh9WcjFkt8xFpY0mBE1bkkkMMhhqzl6+promvoqk7tilLs7WUYe44S?=
 =?us-ascii?Q?YVFGfU0jUwX5iDx7e4GSqH4w5/OUUZTHm5wShxpwWu1a/7UPXVnjoILy3H/d?=
 =?us-ascii?Q?Rx7RdZzsavJnaSKDkC+r4Nm3jIDCBcdT9xYyAxE6orfVzWVOfeBHnc3zBNyK?=
 =?us-ascii?Q?nEanLJHpCke5JR2odhVIJjci2RNaE4cUvI4xgKfPH/TpsDkUymh/kL+OjU9L?=
 =?us-ascii?Q?4iPoINMT9T8PSD8PK9bDPsJtJQ8F/oMq5AwXjaC/QVZC7x2UMpB6GVmHJ389?=
 =?us-ascii?Q?oySlP3c1WKm2JGhc0ykEwt56rPrzTahSiwkT/0aRnt6Q4tpVNQFjBO1rfRvp?=
 =?us-ascii?Q?U+prfF622Bck6+hqB1VLRciEyb109SGbkDyZRNxcA+XVDIRdmIilMaOsA2w8?=
 =?us-ascii?Q?yMQu8zE5YCYRxLc4GFLDNdR/CY7flOmmr3drNEZ0wvZXjL67RqrqaO1YmLgv?=
 =?us-ascii?Q?BTfDJIvE/w/81X7ofUkWGPiYiX2nw2Ttbls8RaK/OgsM0M5tToN1bX0cSyb1?=
 =?us-ascii?Q?4SKRblVTT8qqtADZEEC1q1KIo8veT8arUxNmHgvyNZM2bxZKJByHxASR0sgY?=
 =?us-ascii?Q?LAS9iGtBFOKZ7HEt3A51vI5mpB/dcQM0veqq+nlt3DyJy8RhV+3XVMddeFVo?=
 =?us-ascii?Q?qS50Avn54Za+uikfeSx9P88604hb/y8+h2OH+3N3EQyQAneSq4hZcaNxQ3A1?=
 =?us-ascii?Q?XyFhDOumfWmTvF2tNK7bnBmc/spQvpbPSmO/Vj0A84S2bNO+IZFC1xUD83Ob?=
 =?us-ascii?Q?FTiqxeb3j4bxSoKTAWtvnx0IY8of+o5RkQpuRkwMZduBnWX+1eqaKGfphAox?=
 =?us-ascii?Q?ZA75JIAhR1VN9tkMcnXZrM4cVFK8u+m02eQrSws6aWMHAPX83LXcdFI07Wk7?=
 =?us-ascii?Q?OC9FfmgfivLDtiND+7L0f0lHVRNLXdlSd0PQLdVGK3RAuhjYFFI3Q4oI/0ng?=
 =?us-ascii?Q?Tw9QbTJfVISb192Rn3wChL+ovJajjW8GLp0hI9cuXS+GytUsW7JSi7W8Fnms?=
 =?us-ascii?Q?u65T0cGgfuqveONp14FPfbmTgLFjZW8a9g4wYR1cyFQno215nUYpNPfWGhZT?=
 =?us-ascii?Q?K9RhuKvD6F8m7yeOsw7iSpjS6sJzE7PXjlPfnv3qzwR9hIaiZIBE1kGadEK0?=
 =?us-ascii?Q?AwyLEH3lIWyy+A64v/wnT7WWe+GPe9gq+IOBZZke0neIQQlO/6J/vEnQVfhZ?=
 =?us-ascii?Q?9f+YkQ4UrLGjfLB59gpcWlmBLWuiu8VJLI2lV0a15oKn6nKwZRziSBB/rynW?=
 =?us-ascii?Q?ytX7anTGDXqqoADqiEGfkF2BXjFlb0k0vwf081DvVnGibZlxR8/cuOyy0fIE?=
 =?us-ascii?Q?tpaeuGIGmP/jou8rMCv6xgZl9Va7iBDI7Jks8kABhcEruE+eHLH90AbSy3QN?=
 =?us-ascii?Q?5qP77s4tGmSl+jw3n4Ij4kzwSkOYVd7cbe8Uk+J1WbAhZyb5aGkQZkfxXkGv?=
 =?us-ascii?Q?7DEJtC3ODQbHbsQh+C6OBlnUlgOtQ7uedjHy34yyagmKd+MY1yx4o7TlxjMG?=
 =?us-ascii?Q?IJ1jN+WzlLNl12jgaOceWpVFJ2a50fCCrVnSItRT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf62c47c-91e1-45c9-10a4-08dac6eb20be
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 09:24:00.9191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uukU0Q7Aexyg+LQZgflK/MHdobMELP9vlQFE0x6s5/mezUHOhvKtBApWTRQgpTzu2LfCQBpKgqD/jLvj2HZZPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6166
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 01:37:01PM -0800, Jacob Keller wrote:
> The mlxsw adjfine implementation in the spectrum_ptp.c file converts
> scaled_ppm into ppb before updating a cyclecounter multiplier using the
> standard "base * ppb / 1billion" calculation.
> 
> This can be re-written to use adjust_by_scaled_ppm, directly using the
> scaled parts per million and reducing the amount of code required to
> express this calculation.
> 
> We still calculate the parts per billion for passing into
> mlxsw_sp_ptp_phc_adjfreq because this function requires the input to be in
> parts per billion.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Amit Cohen <amcohen@nvidia.com>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Petr Machata <petrm@nvidia.com>

Thanks for the patch, code looks good to me.

Petr, please apply this patch to our tree for testing.
