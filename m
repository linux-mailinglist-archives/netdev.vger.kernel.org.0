Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF33D69D7A7
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjBUAqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBUAqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:46:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95741C7E9;
        Mon, 20 Feb 2023 16:45:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTBm5T7zsP5dx5gjnLujvJ6ECG16HfGhq3g9JFa77oMkzPAL30zgCJo5n9wgrlmI4gGPU94cHPjVOPnfOTlJfVxFoWpkASJbWAV75mUXmtRULp3bIZgjgJJzMObFF0FWBlMjCkTzrrG2RFYoID72HFzdwcXBr4owh+FzVVCSvn1n7Z2eve0zG4jdH+vtQcdyMOp9RoOdfVYlkULEQ8axG/FEZoY+zqnS/J3DDoLnL99xuHc1sCMUGFniPzE/dGNY7TpnX1kKpkNQurbwebMC04nKdc/LtwXIyR/HU5nk3z+v/I2mB55wJjhkIRRQBKqpoL2z8Lb+MZDnMKQyDI/b6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0r/5YXkHqs1FhACNJgDfyGSQIn2I0FK/7uuatQ45d0=;
 b=kyQJQbaMy14Ace65g2tW9UBUnM5UiCFcTwneRtuCZO6c5iUvqTVdRwRHRGXaFs4PDIYVb7EroV5i1x9CxyhY8WCN9nrbXrgusCUkUahZRXGHbMJPWcGA3wcLZCPWohd5tyt4o5ZioN+QtHFToWCNFeX2kyzC644iQMvSVapdMLQss97MvVL/qL9Arj0zCI3IubN5PV4AprjPP5ljEIXMPYtgZytLapKMc7sWT7YOen8pymMw7L2DH8osRsbTH3MtGAuwGB2VrV19vabqrQvOtMMOl5vKRVj14x7MZQxLeZFf9R0Dcb7Pv2LeQ5CeprgMZIX8IIMosQUSOpTdC5XyKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0r/5YXkHqs1FhACNJgDfyGSQIn2I0FK/7uuatQ45d0=;
 b=Og4DcqzilSqtn8vsIYz60OervvtDo7W8ZNxT6eyeDOnp7omjXz+WW3o2MWZ0GrKrhOrRF8TRGPXFGuU0ddB6LQb1SlDT2jh1trgSJEjthN2aVMZRNO0Bfol+1yPWySYLuzm21D546dKXsaMdazTAhB9pBhNhYFQYpvdoZk2OijQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13)
 by SN7PR12MB7933.namprd12.prod.outlook.com (2603:10b6:806:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 00:45:55 +0000
Received: from MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::8b33:613e:152c:2c0b]) by MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::8b33:613e:152c:2c0b%2]) with mapi id 15.20.6111.018; Tue, 21 Feb 2023
 00:45:55 +0000
Message-ID: <4220d8d7-1140-9570-3d6c-ba70c4048d98@amd.com>
Date:   Mon, 20 Feb 2023 16:45:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 vfio 0/7] pds vfio driver
To:     Christoph Hellwig <hch@infradead.org>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20230219083908.40013-1-brett.creeley@amd.com>
 <Y/MTQZ53nVYMw9jI@infradead.org>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <Y/MTQZ53nVYMw9jI@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:a03:255::10) To MWHPR12MB1390.namprd12.prod.outlook.com
 (2603:10b6:300:12::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR12MB1390:EE_|SN7PR12MB7933:EE_
X-MS-Office365-Filtering-Correlation-Id: 40dd221a-1b5d-4e17-4971-08db13a4fd3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGLaI141RUz1ACV/mITmL1fEfdyCTcCRveli6tzLGKJAdkqv0QjBYEEO0c8knqBPrCGZ4wfy1dNHK9/whuJNxlcaJEc+d8xZfHyTXs4xbCtQhgmFh/fYhkKx/ILzbar2lTMBNipYYIPB1MjAc0eedU370Kin0KoA3k7bLKDBlvsg8xI+b6/Q+3nVqlpQz5+CswxaK2bkdi2asgCLigVnniwqVjjet6e2erYiwvyjY21pc97WnwZW9t4cPLTF9oQRVI2FQr+DbVi6TctmHTvUMF5/tjcMOo5Ndk1mMIOSSVdzbOjjr5i5UM5Sr6QrcmsSGTy5QfxWozpcC5JFjEkC/+mve4f6lckw5My7e5sFCPchCzIB1mpDVPVyys9NVr9st5BQeU/31Uu8ebs8NIu8rw240QRF8mHK/lwaXTPevDKt9quoAaMS5fdYPj9ywm8UNB5Ae6SSN3jlKPSD0j1XKnJ2vsJ9+e+0wXdiiiPRnwGugvDtWBuQa88hf/4St0HHY/Bl8svsKVkQE8/AK95aUptcPAk4fBFlHHOGjKxOlUcIn8g4KzD2nkUPO4/iodBpEYGEB/4C2UdhTvhHVft+jj+Ue4Rbi5+FZbSvL93yg8KRFtDTPO4Xex3/jvVjBC5ZSzNnAKEoLsIyWRFFJRgi/UiBEPpwEBwTUDnAovKW4qUZenMP/4y8+3g0aGDjx62lU9sq3sdsYUIaAdPR6UO/MKPnfOwdAhH2/8fEqULG9VQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(31686004)(2906002)(7416002)(8936002)(5660300002)(83380400001)(36756003)(6666004)(53546011)(6512007)(6506007)(2616005)(26005)(186003)(6486002)(38100700002)(66946007)(4326008)(41300700001)(8676002)(31696002)(66556008)(66476007)(6636002)(478600001)(110136005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjZnRE1yQUwyWjIvcjIzZzJiTUEwNkRKWVdReExUTDI3YVZOVFEvMGJPNVli?=
 =?utf-8?B?N2l4VHBROWZsT3lsNmVOMXJDRmthT3BRNkpxa1krMEZrWi93YXlDYTNERUpE?=
 =?utf-8?B?aGVvOGxxSEUzbithdHh1Y25wY3kvTXFLcm5FZldta3pIZFdQcEZYRWswaGZu?=
 =?utf-8?B?RFVON0JGVCtRVndIUnZuekViQWRzU21aaThtcVA5MDJET3NuUUFqVWppUFUx?=
 =?utf-8?B?bXFGcTJYNFp0cXV1b3FKMCtTWDRyL0t6VmczS1Rsd1RUSHcrU29XQ3dJZVpD?=
 =?utf-8?B?NjFwS2djcHBHZVV2cWtrTGQ1N2tzcXQ1TFROeklESzhJZVVUVUx2R0RuM1Vt?=
 =?utf-8?B?NWdjK2V2d0hPeE5DUnRiOXV3UWliOUE5Z1UxaXBWV3U2azFyd2kwSEtBNnVH?=
 =?utf-8?B?WmViUnZ1WGJCYW52dnRpNDNGamY1YW1sSzcvb0NTc1hhd0pGMFZabG4xUWFi?=
 =?utf-8?B?ajEwaXd4WEtDY2pzUXN0aldab3hUeTFhMlczdTVVTWowZUZXQVdMSS84RnBh?=
 =?utf-8?B?NUdLSEZLNGRPUUVmYmhMeFBBQXc2a2hEaGZyYW1CL0o1aFZtWmdUZXhZdEtQ?=
 =?utf-8?B?SzF2SGJYRVVTUnVMRjJENmRqTStLZVVDam0zU1lkSFBIZTJXVHdTQUNFWm9Y?=
 =?utf-8?B?NjFJZk43by9lQitXZnZzRWhDRW5TTFdHc2JyZDkwd29DYytRU2hYZ1ZuT1BS?=
 =?utf-8?B?NVJCR2l1VWhsR0RRaC9qN281ajNhaWxuVkRTS2RzTFlQNmlRYU13Y2MvK2ZI?=
 =?utf-8?B?eXk3Y2hpY2x5TTVnQkdkYkJLaEs0eU5OUHRZd00vTnN0aXp2cTlWYUI1aWdH?=
 =?utf-8?B?UFBvTm95SmlxMGt6TExZdXgrZTk4QnQrdW1qcFRKR0k1RTJyck1iQ3c3WWEw?=
 =?utf-8?B?OVZodjd5SzM3SWI0QjhOenVKSFFzUjA0QXlwbkg5V1pmSnJHbzFYaVBHTFpG?=
 =?utf-8?B?amdlakQ2TDAvRS9GNWpjQ09lamNMMkpiamdPODRVYTVMd2IyZ3ZBd1lkNjl3?=
 =?utf-8?B?WE5CRzFGcktoWDQ1d0FzMlRDaU50QlNtWVR2dm9FZWNBOWNWZmpnSFJKVXFq?=
 =?utf-8?B?RlZDK1k0VXk1akUrRFJBSlhobWg0L2hyMDJyMnJKNW5aV2FKc0xRSFlqTVNU?=
 =?utf-8?B?N1MvbldqWXpRVStvTThTL055SUQ4MldHdkxGbzErSGw1VjRJS1RaM0d5UzFs?=
 =?utf-8?B?dm1JN3Y0ZEZzR3A5a2hqbUE3eFVhNHlVeGszSGNoWnp6REwvb2ZqeFRxN2kw?=
 =?utf-8?B?Mm15WUlzK3JSS09oNmNSOVJRbDYzSE1QaXlPcVVGV3NRT0ZaeTNyczUwdlps?=
 =?utf-8?B?akNuSGRxdW44V3g3MTNINkdUWWEyaFBmYjczeEJZQ0cyQjdkMmp3ZThsbjNm?=
 =?utf-8?B?WDVGTWhiSUxPaVczZnJIOVVjV3NBcFVkelhlaWhKbng1UGxVQjlrMUdjRzJp?=
 =?utf-8?B?dUN5OVVScDhTaENYNXNMMmtDM05jMW8vTFhHZ21PYTNsQ2pwRGhIQXNFYmI3?=
 =?utf-8?B?QWpSU0hTZkpCRzVkS2FlRjRrMTFPWWNrSVFFRys3MjNybzI3NDBxc3FCUFZa?=
 =?utf-8?B?TjNNRE9vUzR0RTVlWGFSTGN3UmxEeUpNVmJmRnpWSHlDaUphNm1BcHhRQUN3?=
 =?utf-8?B?cTVzRHJ5eHovQWhpMVo5cXFUOCt4eHlBVmRJYzJ1elovT1lFdWRVaEllcU9F?=
 =?utf-8?B?ZVlqaGNaY2lLYU92MTdBU1dUeVFSdVRDeUR6eHdoWXF4Qi95Um5rcWFmN3d2?=
 =?utf-8?B?QXNuZTh1YkhvUjFFRDFILzNTWmdjZUFIQlJKQXpnVXNic3RsNVIzVkY2dXp2?=
 =?utf-8?B?NDYrZlpjbVF0Y1d2bHJsblJuVnR4VWI3ZkMyeWp6c0FYMndEVzZxNnN0Nis1?=
 =?utf-8?B?b1JRZ3ovQnU3elAyTTVBSm0rbTB0bWJ0VWlKSGk5OTVENjN2K1RjWUFoaGFR?=
 =?utf-8?B?QytZTkdXaUlRblB6MjZnZWJ2OER4V21iSzNvdERDUUszT0dSR3ZoOVEra1dQ?=
 =?utf-8?B?eUxCYU5YYWJZdVhyZnRnWUdYSWtpa29iekRFVFdHUFBaNjhsWmNnOEdrVDlE?=
 =?utf-8?B?akNET1lpWVFOQ051MFFrN2tuSXB0RjNWcWU3S29VdnlPKy9zaHVWdFdwQ3Zh?=
 =?utf-8?Q?jT8tUcfrCOiJIm6Tro3ZB8sEw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40dd221a-1b5d-4e17-4971-08db13a4fd3d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 00:45:54.9773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffuqpurrkGyZCO791qIozYyN8IuNSrXEtkVUzwqUc5XqwIcv3NVYeKPpKPCo80HJIaLFwsWbOfp/ccM2wcMNHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7933
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/2023 10:29 PM, Christoph Hellwig wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Sun, Feb 19, 2023 at 12:39:01AM -0800, Brett Creeley wrote:
>> This is a draft patchset for a new vendor specific VFIO driver
>> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
>> (DSC). This driver is device type agnostic and live migration is
>> supported as long as the underlying SR-IOV VF supports live migration
>> on the DSC. This driver is a client of the newly introduced pds_core
>> driver, which the latest version can be referenced at:
> 
> Just as a broken clock:  non-standard nvme live migration is not
> acceptable.  Please work with the NVMe technical workning group to
> get this feature standardized.  Note that despite various interested
> parties on linux lists I've seen exactly zero activity from the
> (not so) smart nic vendors active there.


You're right, we intend to work with the respective groups, and we 
removed any mention of NVMe from the series. However, this solution 
applies to our other PCI devices.
