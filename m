Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9447C606714
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiJTRd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJTRdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:33:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DED31DB261
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 10:33:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz4mcxf8fDoRDdssRXsYd3U7JUswcbG/t2htXfyoqQrEuMFiHZXHszZ+72RWE/J5/J94XvSSk0HsXWjbGUewVH5YRz0PBnCESjKEfmeNQQtYAXnX6nTbhZbxQlVKKIuanF3pabEYVtxQxiK4xfuZtsUIkZPTyvlJ6gkH6u/yKcwhnU+tzUyo7+T4OuP9rG57Zh+C87QEeg3NsOb6bvAojC1FKfbZc4cpmJLONNcnUlOg71Cx1xfzV/j5ktZKRU2a77a03F2dA7k594uyiV7HpDvVqqElASDq1je+PMAR9zLyKsna43IaWXdE3D43ElVKc731Tv3LXJPCNtL0hYCQuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OnALdmc1hK4AB7XLHM7WCkBoS6X3y1oP5w+y0HQpgY=;
 b=Mnc0m4AjKvyxxjQeC4lFXlSfwOuPctdkD69fFFOSQEYbFsI6vkd6jZvVV3Iq7llrVUCje1SlIGzd8QWxKkmOmhjnOhY3IRky+nEdPWwbLXcUBg0M6hN4yeraUIRrG9mp3cZ1A9gaV+T0hLPwrqhUJgTKOy/K0EqBF1gZ8gpRZ40LM+EuSyDFC/9ef+U8Vxpmd+TLUQYwWHQTGf21BJRp5IZBwDFscA15Io7UQSrDPI/s55dX5xM8tjhkvH20shsNGRkOMNNZkzT6FjBo6BWFnH6UaIM9lIksLJpmKDS8+PYtF4r6RpuAJga9PwjjgRyOLmbPN160rX3d6hK3ib7YIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OnALdmc1hK4AB7XLHM7WCkBoS6X3y1oP5w+y0HQpgY=;
 b=ziNwt1F6wnONqbbrOQEDhPsXlgAJJ/1MfkTWZdj45FIWGyZCwL33zW5qP2VyueusXWlaCq3SPPkm1m0PEvQKUro0RJlNQhZnRDpnagkACwMJAOJLZMk3Cfm1ofQORkTXKuivFSM+1O+VC0NURrMa6WUr66T3v6FV44/cwhvD8mU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB4059.namprd12.prod.outlook.com (2603:10b6:5:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 17:33:51 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 17:33:51 +0000
Message-ID: <71059a78-44df-4f92-c6ee-23ac19450f7f@amd.com>
Date:   Thu, 20 Oct 2022 12:33:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 net 0/5] amd-xgbe: Miscellaneous fixes
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Rajesh1.Kumar@amd.com
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR1501CA0023.namprd15.prod.outlook.com
 (2603:10b6:207:17::36) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM6PR12MB4059:EE_
X-MS-Office365-Filtering-Correlation-Id: 7457ce26-e4c4-4e8f-3497-08dab2c140f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7mbJJysKq3dDC19P7t2EoqCe0fXe+9/Sy2obyOkU9cEt3C7hG9K+77VRU4HT82Gd3GUsXlI+ZWJ40JI2lW9opVqLqCZkJYtep1bOIlVAmNz9IqICFU4QtP9+dnEG35JOGZ2Jps800YfM4nXYGIjBe0vzd8QN3ka42fMT8PC2poJT1mo7/Go01b2sWp8jsVdk5iX5URh67P0xM0rYZXStCIDipDuuvBkqu8LGpL2omX39bZO5qRbiVRDLct2qJGL4crck4nqM1FrqUNkI+2PYfp4KEH55lyil/2iXj+DM2BMLFqCFo8wz6FjW6uC9dQbq02QQf459seT6xFPqqkkicmg1KrB/QKE81qmPnotdDHwftyjZKbjU11F9WL7e0AZY6R3SioZMJK3sq9L0JIaxmKcwkL2titPK+mH+y3eSpctOF8PtyfBcxWAOGbgln9ojL7+L6sUIESLeW7vFAUaDptYlMUPJ7GqLs9Q02o5DE2GCygYM42LMVdpL/WJVLGD+TBUxJ9/tsQ/kiT2QvbYjv94DGPAh/fCIJo27TlirzMMlfz1F/jByYY4vIsIiL5iF62Q1LQMJI79icBoY1T0MpDKHQau5e9WS6t74DfYZ7uzotOy6aPqCxsQcfsy9txX+GvXUA3/HI0dMEzXg1q+2RDj880a9GcMYj7QqLI8qmLfWMFqZLMVUs6Ge866UVBbj46ryy+JtJjkOYzWlbvuXLD9MKspu8QYaJ7NaKeqBamxpvYrpbcHVTsDZOdPkODqbefTbDEDSkcwqlM8VPIWJdRAFKApnfEEMD21d222us+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199015)(41300700001)(2616005)(186003)(8936002)(38100700002)(316002)(5660300002)(83380400001)(36756003)(31696002)(26005)(86362001)(6512007)(2906002)(478600001)(31686004)(53546011)(6506007)(6486002)(8676002)(66556008)(66476007)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVpicVhuQ1NiT2tUTytrbUxTM3Jock1tQlloOTd3NEdVaEY3MG9kc1Y2Tlkv?=
 =?utf-8?B?VUo0SG1PK3Q1UDEzczFaM1JNbUhuclppRmVCdTMxOG1aV0FwUzRCUHUyKzdl?=
 =?utf-8?B?SnVlL1U5N1RjWExrSG8yeEs0Z1FZWHJRdjk3SUtTSGoxNXFGSzA4ajBVUUxl?=
 =?utf-8?B?Mis1ZVlxd0R3T0Z6NkpiV0k3WGJUMzNaT3dWWGM4RGJhNFBwWUFVTGtPUVE3?=
 =?utf-8?B?OU4xN0haRzB4QUdCRFcyZGdWSVZTbjN3ZVAxWkNsSlBPUFNnREEzazQ5MEVy?=
 =?utf-8?B?bDRvdDVTV04wV3pLTENEbHlGRy9leTQ2ZUQ2Z0FxTnA4WXBIR2dSRlhrTFJN?=
 =?utf-8?B?ODFNdjhYcHNqRHRZbm1LcVlzdC9naHo4YjNpKzcwbFc1YmM3WG43MlBYOWFh?=
 =?utf-8?B?OEJoTjJidVRJR05UcEFDUzQvZFNXbDBIa3Q0TlFmSU9iMm9HQSs4aVdaT3U2?=
 =?utf-8?B?dlVUVS8rejJSUWUvQzZidE1XOUFDbUZmOTQzenNiQUZPWFFKY1h6WGlKUHgz?=
 =?utf-8?B?Y2UyT1ZwUnZtb1ZhSks1blJGQnRtL3NRb0tpamdxUUFXSlcxNFFCYXluZWZJ?=
 =?utf-8?B?VUFvTXAvZ3BOaktjTWw0RHVtUkwyVi9DMkFWWnYzUjdEZjd5S3BzWFcyZFFw?=
 =?utf-8?B?eW1NUmNFcjhLcnlOblJDeU9XUXlwSXdZTjBzN0JJdWxvdmJaL0srN2dPRXNh?=
 =?utf-8?B?ZTZFWmVGS3N2L3U1cmo4c3lWN2dBeUhGMVU3ODJPcFpTTGRIclF0amV6UWRR?=
 =?utf-8?B?azV1WU9FQUp2eHlUbVFIWEdTOE02bFFWSlBaUVYxTTg0b2JRQ0tRd1JtNTFn?=
 =?utf-8?B?V01UeVBidldYWVZxVVBBbS8rODk5NWxVNmF3Z3lXenl3aVJsRkkxc2l0bmhv?=
 =?utf-8?B?RW5VcU5aaVpsSjZ3TE5UQ1VOSGV3RmJSRG9uTDl0OUtCc3BSNkVpTDREZVUz?=
 =?utf-8?B?ZU5uT2Q5V2ZNQWRBK01xYjg1eDdnMU1BSFN3ajZrdmhNUEJkc0MvT1djNkdD?=
 =?utf-8?B?MWtyR0xxNEdaT25penM4MkVJU2RGZy9SVTA1anM0OFF6SW5PcjdVTWhRSGVn?=
 =?utf-8?B?RmFiVW1CSy9mOWd4OC9lc004SUE0Z280QkdDbEYyYVZXK0hHTXFYY2o2d1F5?=
 =?utf-8?B?R01DUFlsSHIwRVZwcERHdElSaVE1MXA1eU5FL0Z4Y2VaU0QxUU5kazJPZFdp?=
 =?utf-8?B?Vys3QThRb1pPbm5xVFZoNnRlNm5Ia1cyRHZpcEdRM29UZks5bXFMd29iZ1BG?=
 =?utf-8?B?YlM2QWRrcmUxUGlwZldxaE11MTcwdEhPWXNtb1MySVRvaFNwZkkxUXdQZ2Zm?=
 =?utf-8?B?R2FvK093dFRYZE5rVGdqbnVMRng4bjZiaTV3MFhxeDlpSFV3WU5Cbjg2VC9l?=
 =?utf-8?B?blRRMDhxSDhMNTZLeUJ3SGZWNGViK2taekxoeDhsWHh5WDdsZEdIWC9oLzBW?=
 =?utf-8?B?aG95dDBJNUNGTTBrT1dVSVVmQXRuUktOWlFhK3hoSzl1Nm9HMkoxQjc0aUdq?=
 =?utf-8?B?dW1MMjlpL0NyaUtIVDBkQzFQclJ2NGtnNUJ5d2hRNWl3UWVsbk5MVmJkcVZM?=
 =?utf-8?B?akU0RkJuNzBrMm4vQ1RHMU55a2g5QjJmVWwvcjJBazd4SW13MUhHQkJwYTFU?=
 =?utf-8?B?YWdSYTVGL0dJMUdMZzYvN1dFU0xFVjRiQ3VxbmxvQ0wvS0lWcGduaG0xbDBv?=
 =?utf-8?B?LzFkODc3Ti9jTmsvbElTOUcrQm9aSG5ibU1lYVVUY3Y3ckl5cDdNT3NFVTZp?=
 =?utf-8?B?aU8xUU1BaHVjbk93SEl0UmZFTFRKVisvSEF0N0g5S3VoMVF5NzJkdldjSzNC?=
 =?utf-8?B?U0liRktmSVhZMTRpK1psV1hzRC9OQkpyRHVHb05qekt6N3ZFaDZuRElGdlhV?=
 =?utf-8?B?RkxMdnNhT2JqMjVWOEx0eHdXSHkxLzhhR3duaTQ5Rlp2S2pVZmtYRmV6UGNB?=
 =?utf-8?B?R0xtSzFoWUlTWUpkSlY1RGdYZUVxVlFSUkFzTUFkU0Z4SkYydHlsK2NjUkVX?=
 =?utf-8?B?R202QUl0YmlFL1o1TkdDbVQxT3NTakozME9rYWpJTUR6UVN3MXdKanROdUUw?=
 =?utf-8?B?WG5PWWNMTnowcU1JdXRJNi8wck93WnpkYXYxWU1WWGR6aFoxb1pMUTJuWWpv?=
 =?utf-8?Q?cXe19lk2ZD1mFZKN0w7gzXQdi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7457ce26-e4c4-4e8f-3497-08dab2c140f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:33:51.5956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kXelV+mVe5Wcuzac2jtNlxk8rVNLhCwdpJqjdC72RdYwBERyFX0bXOYFvZ209zmRPxFC17PApv9994o+3Z4cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4059
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 01:42, Raju Rangoju wrote:
> (1) Fix the rrc for Yellow carp devices. CDR workaround path
>      is disabled for YC devices, receiver reset cycle is not
>      needed in such cases.
> 
> (2) Add enumerations for mailbox command and sub-commands.
>      Instead of using hard-coded values, use enums.
> 
> (3) Enable PLL_CTL for fixed PHY modes only. Driver does not
>      implement SW RRCM for Autoneg Off configuration, hence PLL
>      is needed for fixed PHY modes only.
> 
> (4) Fix the SFP compliance codes check for DAC cables. Some of
>      the passive cables have non-zero data at offset 6 in
>      SFP EEPROM data. So, fix the sfp compliance codes check.
> 
> (5) Add a quirk for Molex passive cables to extend the rate
>      ceiling to 0x78.
> 
> Raju Rangoju (5):
>    amd-xgbe: Yellow carp devices do not need rrc
>    amd-xgbe: use enums for mailbox cmd and sub_cmds
>    amd-xgbe: enable PLL_CTL for fixed PHY modes only
>    amd-xgbe: fix the SFP compliance codes check for DAC cables
>    amd-xgbe: add the bit rate quirk for Molex cables

For the series,

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c    |  5 ++
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 58 +++++++++++++--------
>   drivers/net/ethernet/amd/xgbe/xgbe.h        | 26 +++++++++
>   3 files changed, 68 insertions(+), 21 deletions(-)
> 
