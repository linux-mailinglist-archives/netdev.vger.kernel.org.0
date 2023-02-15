Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921AF69803A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBOQMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBOQMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:12:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78043B0C6
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:12:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B28XRjEl0FR6dilIkuoTHrG2lfr9p07k/TwYtZ16MjE71+XyEVOYJzQ6esaInF2jdFGiy3H1RWaux6Zv/ZdcJ68By/Ky9nyi5zBvm5QvrRggppkOotQv7zrb7H8uiQ38yppOlEr6Obf1Zca/NZULf402QsARBn9Mh/3/UzQab+tLCm3JqcOjnRTEScNGpfQNXcbg5Z57mObIYnT34CvH7ms2qQngeSRzHKTbrrEXlviOkAJTbzC5jbW/CTyJlg7R/dmfo8MlUwCcadvIWvBMqt56BzdAMQ095uvmc6Wm1TLD059pDyubtB9HruqCXo3uVJakKFOcN1WiilVoiH8iOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSEFqPfWR+WVoFIX8VGBVZt7cigu8sA8f3xyeF+q1Lw=;
 b=H1669Uqt0GejCc05SLh5e2rw/8rce2oM6WLE3tlCYdasRIB3yd6jMdBpON+6MQBFV780MTOY4hdxd6J5pYH79nbJOQpUXWaP9XniWWIby3gdU503n7db/r7mSIQdLuzFUYTt2oWAqGqJxSXo6YF16e3cPfxgZm87BwIJRJ8YWKN2KRQwG/NMuCp61osO0g0S75HHx8Mw3g0lYHFk5aTnd7QK8sU/Q2Uo/Pbb4MSMBMexISlYdLtJEYzL+u2L8ChmYVchXyCf/XINbXb+bALnKvhFGe4+IF9oh+cJdT1dtev67wg1l0+LJpzrjmSCMRv9mEyIRGeeNxxlK2yaYFPrIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSEFqPfWR+WVoFIX8VGBVZt7cigu8sA8f3xyeF+q1Lw=;
 b=Iw+aiB1uh74RqfKXPpb1tbiRwqH2cwxyFsVcMotFfEU8A3MlDGMlgqSnqkWiX4pqOt4slOzbNf6vdZKlYiaWHmx1kWsD4nIvn6laBojWdpjcJFYYHGd2iVShBKK8GkggSqQmKGe55wtzHy8bqdiO+MCOdvhnc0UNqn+fe+iDk3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SN7PR12MB7909.namprd12.prod.outlook.com (2603:10b6:806:340::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 16:12:15 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%6]) with mapi id 15.20.6086.022; Wed, 15 Feb 2023
 16:12:15 +0000
Message-ID: <d0bf1145-7cc8-ae37-1609-3f0a89b93723@amd.com>
Date:   Wed, 15 Feb 2023 08:12:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH ethtool-next 1/2] ethtool: uapi update for RX_PUSH
 ringparam attribute
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
References: <20230213203008.2321-1-shannon.nelson@amd.com>
 <20230213203008.2321-2-shannon.nelson@amd.com>
 <20230215104804.a76pukyorknilfw3@lion.mk-sys.cz>
Content-Language: en-US
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230215104804.a76pukyorknilfw3@lion.mk-sys.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::28) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SN7PR12MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: cd0e323a-515d-46be-5de5-08db0f6f6702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LbZQckPoHxrPBai0NkHIO2MMgR+zOjvdoXBh/xBOsuzX7uIhOvjOGQtqs7HpNV0sGkUgBI3lfDee5NKfm7f6g8xcdefaC77gbbLltq1yxW8n4O+pconNKExdtvp+/ORnVs/ZyzDH0PCFnDCXJG3iJVo76AveqepPHDIfqdg0vPzkao5PeTPwWZj1AF8YT69XrqTUuv6Gjm748uGJ/b0YQAkXzSQ8ptSy1ihUfdK3rth3Q7/PTLmnqH9J5DDnIn6tAESCTlcDaKWNqfAu6UMxhMb+oXTapB3gdHYcC4O3z+EvG1nEW9H+hMV+uaMpLMaVmymCI3fik6/UpLBqLmHrgNDX4lBxcL94oN8gjOSVn3PhDzhCVcRm+3BcwOlbp0jIgVY5VGo5MdkHA/BUhnFBklJYxYGmOrXhcLbnwKm3OG/7EUlyK+UxWoCDmTpbNDVWumi4LJqYQC+a7C+fYluTQk09eRG4uX3vP9mpLU8ow9l38HeEWFjSDIFE0jg3POBafn6CMP+zZCzBe+Cmum+Qk1o/I44Sh0OW3p5PQxRtOWM+BksNxn2K/MXNpB6o5lrQXzd/g3f4HuyMmLG0a/8ZDvjhn9h4r6WmBwfC7fbziu2qjWTrbSScC3Z5UadBgso1go4vQnbu+mOZnDUHKk831ARE8gjqxm8lHC2bIUUwC+diYNIbYjMH51VeVsKZf1B/tYPa9OZ2RG1GjKpV9T7ZcwI9KGPVpq0/qEq5s4qhJ3g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199018)(83380400001)(2906002)(15650500001)(8936002)(41300700001)(5660300002)(36756003)(44832011)(8676002)(66946007)(6916009)(4326008)(66556008)(66476007)(316002)(478600001)(6486002)(966005)(6506007)(53546011)(2616005)(31696002)(186003)(6512007)(6666004)(26005)(86362001)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVpWNE1udUdacENNdjZVRFZNQnBwYTd6NTVuVzBqZ2oxMXVvU3poRUNnTS9N?=
 =?utf-8?B?STFCdHJVajVTR083UTFsS2FZczNxQ3dOL2ZnUFJKRURxbzA3N0hMaVBnKzQx?=
 =?utf-8?B?VGdNR1AvYzJIZ1U1bVVFQWZGUm5JTDJBRXJZaW11VW1hemkvcVBLZjhZaUNq?=
 =?utf-8?B?MVR2QXllZmRNbnhtTXhOOGNjeGdUMXZZTkV2cXFOQzYrcjVVaFJFYWlqdEZt?=
 =?utf-8?B?eGNOdmNGV2szb2ZuVUdFeTVPbmF6aFpGY3Z0U3ljSXhVN3R4NDJsL08xTThy?=
 =?utf-8?B?YmNFL29wSENOSWREZkhlN0hhNXUwZE5xbTZ6MWloK0NFU3F6VTF2TGwvNldT?=
 =?utf-8?B?Y3VpVDM5QUNHakc5T3grTlc4VGdZbjBmZENrQk4ySGwzVk82UjJKeEY4VjRk?=
 =?utf-8?B?UlRGcTd0elBJcExaRzZMZzQrOVRzTWpvNHpZbDNYekFESVFScG1pVXV3V3U4?=
 =?utf-8?B?bGlTeUxNbUxsdllPSms4OW9icDFWQ0ROUFQvR2R6N0EyNHVNbTAza3NmMjMz?=
 =?utf-8?B?azd6dDN4K1ROamFXS2RpVkZWRkRIR2FnWGttQ0FQS1hCNzZMYnFhamRUSGho?=
 =?utf-8?B?ZXFpUmdrSGJ1aXBjdHI0QWd2OHNOa3ZFZTF1ZU55Y2oyK2NtR2MyT1ZjS3Vs?=
 =?utf-8?B?K3owVUlZRDlJbFNOcnBrdVovczJqLzY3R3hSTUFzYzJXbCtuZ2pGWFEwblNX?=
 =?utf-8?B?T2ZyWW9BMW9JRFJmbklUdjd1RXFESVQ5cGpMZ01OZ3FhWmgrWDhnRkhMVy9N?=
 =?utf-8?B?QjgzVTJobnQ0NG5PU2FpRHh6R21KQUY2N3hrZzRBUjNEc0FEbzBITUlFVlV4?=
 =?utf-8?B?bHdFeXVxTWJPczdoM0UzRGFqYWhIN29mN1c1dGJpZll3YjRKeWh3a1p6aCsv?=
 =?utf-8?B?cVBFSnR3NlVyMlZPa1dLVjZ3MDRncHkyWUFtNnQ1dm5RMnlRZ0R3SzNzOXdU?=
 =?utf-8?B?U2N2a2xEN0I4dHl1ZWdUM0k0dFZJK0x1SGwya2RuUzNTKzFKRHpGbU1rdmlm?=
 =?utf-8?B?WDJXR1R4WWF0ZUtUaWIvellDVUlaMFdaNDRncHY2TkZKaGdiS1huR3M4UmNq?=
 =?utf-8?B?S01xdHVDTU41OHZ0V1p3YkJ6MEhqKzBvcE44a3dkQWhmL0tSM3JYVnNrNm1O?=
 =?utf-8?B?ZVUzNnY2ZjBkMVpMZGdscmJRcDdEMFoyNnNwdWd0MFIwN1FqSzJ6dUp4ZDVX?=
 =?utf-8?B?Z3hQeDMyR1h6STMxUlZSSVlxN3MzejB1UGtYVXV6SDNkam1HdEhsSm9COTh2?=
 =?utf-8?B?aHYwdzM4ZWVNbkxvcFRZYUNJd0g0cWNYdzkzQTNqdkxNQk1nTE5HNVp4UTdv?=
 =?utf-8?B?V2EwZVlRRWU3MkxvbVl2cDgyU2Vnc0xUd2p3akdHQmwvSlFmMEdwUGpYaHFy?=
 =?utf-8?B?SE96ZExGUUcvWjRsSC9CQjRWTzNFR3EvUWI5dVpXMS9Takx4Szh3UU0rVFdT?=
 =?utf-8?B?T0xiejUwNlhFd3VnNVhveGVJMjFZd3U5WDEyQ0FBNEhyeHp6TlEwTXRudG1R?=
 =?utf-8?B?YjdGS1RMeVRXVHVwQ1dOV0xzVXhhRElwcnQya1plMUdkYTRidWx0ZStWTUpn?=
 =?utf-8?B?aW5QOXpxNFpkYm8xOTJQdlZzMzFIeVJhamJQUXdPNXdNOVFOODhJZ2dRbFAv?=
 =?utf-8?B?aVRGTGdlSmFsU1FqVkNkcWNxcXZPaXYrYW8xNkR5S0ppajE3MTM1Zmh4Ly9k?=
 =?utf-8?B?dFRpbmYrTCtUdklDZGQwNGxWWWFtZkZ1TmlST3VBcnowdklpd2JnTk8wZmdr?=
 =?utf-8?B?R0FZazcxS2VoM2V3V0hUejVaVXEvVXpqeGdTTUlKbWJuSmR1bTA0U0x0bGhJ?=
 =?utf-8?B?dEdOd3RINzBHdE9rU1dBczRUMEoyMjRrQU9pTUJhcGlPT2l4Vy9jTFZ1WFdr?=
 =?utf-8?B?MDVBOWlhTG9WMFlqWThPcThEbHNzUUVtTnJuY3FyYUo3SlJHcEcrY1BkUWpP?=
 =?utf-8?B?SFZuMEEzZ2VPZkQ3VzU0WUpHa25UU3ZzYUVxSndMR1Vta1VlcjhHTGU0a0Np?=
 =?utf-8?B?cWFBN2ZGSUZackI2a3lLMmxKVHRVTU42dTMwaFRlUC9vc3R3UzVjbUd6L1VZ?=
 =?utf-8?B?djR3YXJsTWVEQ3VqemJOSUFkSURwbEtEem8vQ1Nqa2pBVHoxcXZjYkZhd2FM?=
 =?utf-8?Q?4K6DgbIQoVeOPhWZXFwwQSZ+t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0e323a-515d-46be-5de5-08db0f6f6702
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:12:14.9082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iukWrky5FBgXiFDQaa+EPR8xp72BU1Sp4QiV043ey3F7V354ZJXbKk4E/B3iATds1fLmtfqn47JD7plGWmOrGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7909
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 2:48 AM, Michal Kubecek wrote:
 >On Mon, Feb 13, 2023 at 12:30:07PM -0800, Shannon Nelson wrote:
 >> Adds the new uapi ETHTOOL_A_RINGS_RX_PUSH attribute as found in the
 >> next-next commit
 >> 5b4e9a7a71ab ("net: ethtool: extend ringparam set/get APIs for rx_push")
 >>
 >> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
 >> ---
 >>  uapi/linux/ethtool_netlink.h | 1 +
 >>  1 file changed, 1 insertion(+)
 >>
 >> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
 >> index 4cf91e5..13493c9 100644
 >> --- a/uapi/linux/ethtool_netlink.h
 >> +++ b/uapi/linux/ethtool_netlink.h
 >> @@ -356,6 +356,7 @@ enum {
 >>  	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
 >>  	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
 >>  	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
 >> +	ETHTOOL_A_RINGS_RX_PUSH,			/* u8 */
 >>
 >>  	/* add new constants above here */
 >>  	__ETHTOOL_A_RINGS_CNT,
 >
 >I replaced this patch with a full update from current net-next head
 >(kernel commit 1ed32ad4a3cb), next time please follow the guidelines at
 >
 >  https://mirrors.edge.kernel.org/pub/software/network/ethtool/devel.html
 >
 >(third paragraph in section "Submitting patches").
 >
 >Michal

Thanks - somehow I didn't stumble across that page so wasn't sure of the 
process.  I'll check it next time.

Cheers,
sln
