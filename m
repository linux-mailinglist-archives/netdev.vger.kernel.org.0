Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B096E1659
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjDMVM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDMVM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:12:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2B76EB2;
        Thu, 13 Apr 2023 14:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djCtVoZl51q+a811Jfsqujx5gXOvRbh88SmbQCRNJrsqaIernnFYaCKNnltF11lBqYic/5V+M96YFXZDwiuoWT9xtLMLffjpwDxE5fVKR9vLUfwvdxy/+kOV2O4TgKV2SY5KdKsVffIdgU3kRdmLub0oW45AsQgkubtDgl9TPvVolvVtNKmml6XCLjxlSst1hVBsLHgOdwnC0gjfMorf1h6O/SmQgAMNRduxyeHOvlxKVUGQvGCktr9lVU1AFBBV/EdLnWCOs1eLXtOk5sSD2k93bKEcDmHHvLEcuTBsPdnfECnDHwURdLwPYOXEgazPtlpLOlPMDmP8jyeuMFVgmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0kweVoK4Ysj+ETrcGaglQS6MUC0Ax1niCfQ7R7faWM=;
 b=FlRhoARHuvC5//pm4UG97l51kH9TAO4LD4ZCA7GVhTNWoxD8d+dCtRgnfh1FIoEN11UGgkGWl4ZZ3TsvpkWciZdxTkZimhNL9xpacZsGjjiJbYJkjQRiNlW2sdTR9e23q8Owxr9owPFP0cLOtjetyljExnpoj8lrsVyprWoGQCeTi33bUrajXo3sUtcttVRd2ApDz2EruMaWx4BY1IsQD+g/b5Pkw5Y2f4cp4uReGRL/9asgfB5kjDviyWmhHk/68pUoijtIrCiHqmRKTPmu845HKqwkf+YliKNF1CvOSgvILJNnQ3b5qOk8en80knP44jUcwMQLhJK1J2VuL4Q3kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0kweVoK4Ysj+ETrcGaglQS6MUC0Ax1niCfQ7R7faWM=;
 b=GG5gTP55y1KY591Yxpd9yJpIZXlH7SK8wi10dzzZaCFHM1NiBP9eEpdesKF01T9Lmoczy7O1fdTtQ09D8QOZpr3Co0R+q8q1zFDRpNJeHasqQRJsIdU+s9EndotG2Ke1gzwVRv/PE5ByQXxTIezGHpM6Vw+S0kUBTHYhJlYtxtJ3vyAq56X58bXpyHLOe9uHnNlp2mA22qWopAU5hAr6JeCeOQTp8ue2/DATSP2P7Fa26+5dmj5ln/VWKC80cs728ydBGRlETboftttLR45JPJqk3jnCWf9zyrmTy23IZ25B47ZdSQP5OEm6Xc2KgdyKOSu69U5S+Pt+RMXK9fHs7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 DM6PR12MB4284.namprd12.prod.outlook.com (2603:10b6:5:21a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Thu, 13 Apr 2023 21:12:52 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78%8]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 21:12:52 +0000
Date:   Thu, 13 Apr 2023 14:12:49 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <ZDhwUYpMFvCRf1EC@x130>
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
 <ZCS5oxM/m9LuidL/@x130>
 <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
 <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
 <20230410054605.GL182481@unreal>
 <20230413075421.044d7046@kernel.org>
 <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::32) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|DM6PR12MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 29703983-7c83-4398-8e04-08db3c63d766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8h+wb1Kbw3oT1fZZ4S92n7gIJpA7Mn6TpbLg9YZgZWrqdrdftQRcgMo3G+W/OEGb7g56I/cs3uOqO5mDjAFdXcs3ETcI7vewKpMbPQbGV+zkiVbc01ZLGmnOu56IjKAuXoO/Jgl/ZTJRf0XkluQw7jVQT2RDM8LALtsYOIMw5+Xkr1eSVKlNvVn3teppIyeLSZY0dHEWUY25wAjLmCBEdMnt5rq6uHnDr/DrgZnwR6i6r8DGPvY3zbE0okVFZWHVhkdp7imR7KSAwgHgdxZUZjydPe5NtmOZxMVGwqlePLOlQ9z4BGMdzlgZQ5AJquf9FnQS+gxsnBNhjpkRa/Ig1DwC5vYnog2FpOxNTdvTPJxdTSav4N6qUspwwx2Uy63OHAMEF0AN7Q9uhfKE70d/9oyJQNiwMV4lNbZ5x1Tbx/2ph3nwN5pGMeTbBXKo/rJ7qI8iPpd4jObKe1Od1rziw05VIe4RUxfEqUqsVs/6f+k+BEophEcw/Z2yieK+oTC3KyyDAFzykPviq/mFpSjBildhIp7tfByGxZ8sVd3VCmud2BrCZONbqtaep8dv+UL1wEtYzrZQHD9KHVGgyLnDxyphwJs8Grqq3LFYzSgA1ik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(33716001)(66899021)(83380400001)(26005)(107886003)(186003)(38100700002)(6666004)(66556008)(6916009)(316002)(966005)(66476007)(6486002)(4326008)(54906003)(86362001)(478600001)(66946007)(41300700001)(6512007)(9686003)(6506007)(8936002)(8676002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW1NU2hZVktXeittampuenNQMDRnNVV2bVp3cVlkaEd3U3RsbHIxR2dveXBD?=
 =?utf-8?B?dGJQQnFmRTRzV2dkbTNJMU1McDg4NXUwMnRnQms0US9VRDcxZ2xkMkxwUVh2?=
 =?utf-8?B?SE1WRmwva3lJRTltVVRRMmZEU1JzM1Z1RmYrUkNoM3hGM080MTlPMVFzUXdG?=
 =?utf-8?B?ODZydzhhWmtENVpCN3I0ZXFRaVorVFZRN05oZU1hWkZ1Nkxma2ZmSGFtUlpD?=
 =?utf-8?B?UGE0UTQ2VUZHTk5VMGFtSWp5WlY2WmMvRCt5K0gyZFFmS2daVzNVRTM2Q29h?=
 =?utf-8?B?RlZ1Z3JaODVUSjQ5ZFpLbGw4SVNpL2FNUkhKcytjMi9qMUluSkV3ZHM5VGpl?=
 =?utf-8?B?b3BZb3M2VUg2TmU1c0M3d085RHFrMGIvSmMza1VRQWgzdkhhMEhKVDVYSUNG?=
 =?utf-8?B?aWhOY0ZzcU5ERHcwZkdGMFRZdkVRSU1tYWMycnpRM3h0QzFBSjkvUnk4YlFt?=
 =?utf-8?B?ZzJ5Q2pPZ2pIblhyektES3BNb2Jkd2laUEllbERFSmY1V2YxUG0xcytOVkk5?=
 =?utf-8?B?K3hlMzJ2RVRXYm9Uc1lubEFnOVMrelN2MVQ3bUlPNVFCTXZoNzdpQk50dmox?=
 =?utf-8?B?UFdqS25lSEtIRTFNWEd4d1VJdDNWYnorbFFtS29abElCZkcyYkRzYy96TU9C?=
 =?utf-8?B?RVJKYnROdjRscU1oZXdkMm9jN1I3OUFFL2syckZhRGVybGdhY09lOXFhdWJS?=
 =?utf-8?B?OUh0M1d6cHFTQmk5NWtaakpNRTJ3dXhSVEFxNjM5RGo4bDNVNmxHUEZLS3kv?=
 =?utf-8?B?MW0zOVZzY3NTUHRFOGxtdXlzbzdSanBJdlZsTndHSTNZUDd1Vk43cHFtR1dv?=
 =?utf-8?B?WUFXMlNlV0c2RkQzY2ExU1NqTkRPNHBMVWZMeDlSSitYZ0ZQL0laY25IUXJm?=
 =?utf-8?B?T1hIYldTU2M0d3lRS0RzS0xaNzFlWE14T3YybURjY1BFcjV2Zno0eVZnaVFy?=
 =?utf-8?B?Y0Y0Ynhaa0NoaDRJTXdzdVI2RjcvRzNhc1BmajFLa2lFamFQM3cvZXU3SG1B?=
 =?utf-8?B?TDVqdkp3WkpnVG9LUlZBeEdGeFlDTkVPa1VSc2xZOUk3UlIzdDFlaHVhRUVy?=
 =?utf-8?B?SEJqeU1tdUZmSFA4aDBISzMzTk9IUzZ2R29Vek1uVEpKOWdVcDhaK2FyMnNy?=
 =?utf-8?B?SllaVnNjbDVRYUpHTzdJUGU1cnpuKzQvRWtqdEdOL1dxVXJRTEc5ZTNBSm5E?=
 =?utf-8?B?UTVna3BjQ3VNVWpjS25UZ1J6bXI1R3d2UWpNUmN5M3FDNFBzUElTVWNROWpC?=
 =?utf-8?B?S2JBaXA3VGJzaUJ4Y1FBTG1GcStLOG9hUk5SdHF5NmFBbCt3N1JHRDhuSEpZ?=
 =?utf-8?B?N0t2L0Z1TG0vVlY1VlZRN1hYbTcvQW5KR2krWU4xYjZ3aHZUbWt6RzNmdkZi?=
 =?utf-8?B?OUdLRzdJdGp1UWJVczhXa1gydDhnWkZnOWNoUXpnSDMweEtQRjdjVGdvRy9G?=
 =?utf-8?B?RGVGemV1bWlVL2IzcW1Gak9WbkJVbzNBaExnL1VvcUxZOFlqdDY3Q2pNSHp5?=
 =?utf-8?B?c3ZTSEEvdDRTRmRGUkkyMTBzRW83aVFCN3A1RjVSNWNabHZ5VFJWZXhLdEw2?=
 =?utf-8?B?M0JxL2MxVUQ2RE5uNVRZdmZ4amt0a2xsdm1JRGQySHoycjRscTJJUS96UG9L?=
 =?utf-8?B?UHZzMklPN1dxVHhKM2ZXM1BMNW9HbXUzTTBVWldvdVdYeGZZbFEyb3FDV2ZV?=
 =?utf-8?B?UFRwS2RiUEh6OHNKTXVsUm9iT0dIS3NEQ2h6UUd5TGVhZVpXMUpTcDRPOGNk?=
 =?utf-8?B?V2F6TjBnenN6Q1BGRmR3c3JSVWVmSFNob1VLQ3FYUCtaSWprRGRmRU5OVWJW?=
 =?utf-8?B?cVkvRGwrZ2JHS0pRVGFLbnlJbzViQnd3b3ZRQnFYSmJqZ2dWZHJPa2tTdGJi?=
 =?utf-8?B?OVdJcDF6V0t5VXExN2t1RzFWRU94VGwzVDVmdzg0OGVtcmo5N2FtQVcvUldY?=
 =?utf-8?B?TWpjdG5ZSFZrWWNDdlhJNWlEaXU5V1BiTlpHNHBoRDdrVVRlQmw2UnJ3dlZN?=
 =?utf-8?B?YzJBaGs0L1VyTWIyUWV1d2R2MitCaGIzNCtoTWQ1L1RGTUFNanVkS1A3aUVu?=
 =?utf-8?B?cENIdGdGTS8xTDZpclUyQ3NEeTdHTmUxWnlWY0RwZDRhcWtzL0VwMm5zUzk5?=
 =?utf-8?Q?hiDZl0Ijt6t5fKei4YJkG8f4/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29703983-7c83-4398-8e04-08db3c63d766
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 21:12:51.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFCAmV4gIkFwgewOgi+oIOY0MbmhnpyeuNdf/OEoQI0R7FJdvk+bbvTS6C7odXCzvXdaWB9VLwLvky6Uwu/m0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4284
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Apr 11:19, Paul Moore wrote:
>On Thu, Apr 13, 2023 at 10:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
>> On Mon, 10 Apr 2023 08:46:05 +0300 Leon Romanovsky wrote:
>> > > I haven't seen any updates from the mlx5 driver folks, although I may
>> > > not have been CC'd?
>> >
>> > We are extremely slow these days due to combination of holidays
>> > (Easter, Passover, Ramadan, spring break e.t.c).
>>
>> Let's get this fixed ASAP, please. I understand that there are
>> holidays, but it's been over 2 weeks, and addressing regressions
>> should be highest priority for any maintainer! :(
>>
>> From what I gather all we need here is to throw in an extra condition
>> for "FW is hella old" into mlx5_core_is_management_pf(), no?
>

Hi, Jakub and Paul
This is a high priority and we are working on this, unfortunately for mlx5
we don't check FW versions since we support more than 6 different devices
already, with different FW production lines. 

So we believe that this bug is very hard to solve without breaking backward
compatibility with the currently supported working FWs, the issue exists only
on very old firmwares and we will recommend a firmware upgrade to resolve this
issue.

>That's my gut feeling too, at least for a quick solution.  I'd offer
>to cobble together a fix, but my kernel expertise ends well before I
>get to the mlx5 driver :)
>
>I have been running for a while now with that small patch reverted on
>my test machines (so I can keep my tests running) and everything seems
>to be okay, but there may be other issues caused by the revert that
>I'm not seeing.
>

Paul is it possible to upgrade your device's FW ? your current FW is 6 years
old and we officially don't support FWs this old.

here's a link to start your upgrade.
https://network.nvidia.com/support/firmware/connectx4ib/

Let me know if you need any further assistance.

>-- 
>paul-moore.com
