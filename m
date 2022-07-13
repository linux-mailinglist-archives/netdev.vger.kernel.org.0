Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69751573D5E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 21:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbiGMTw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 15:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiGMTw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 15:52:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF45226567;
        Wed, 13 Jul 2022 12:52:56 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DICfXf024936;
        Wed, 13 Jul 2022 12:52:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8xwlN/aid2gPLz4D8UaeMK1Hv5lGVF1q6RJoDh+qJH8=;
 b=Q5D/qH9/VPaPWPx7yUO82F5r6IuvHwx7cZEzMcaY9Gw5U2vJDo9jd9N76h86bVXqv9tf
 hitXcc846EXFl6+Cmt59hGiVEfIQL0h+Xw4dLJyRXUO/0CS5zny+R1QcbclDngMWlhls
 +YBRH852IfpJu1TKKNeg1sEmgtxCx5JmsIE= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5feeeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 12:52:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iw4lGXEO0y/a7aq1yO6tJfKbjCHz5E4jNddS5KtUuP7lEMGenayZrWoFZVYEZk1sOznE6iXcNChm3PynzUIGOrxJrB4wLVJD7YzqB7kqTUBqRWzK8Aj8VUjom+87JpoebJYBe0AOVsB4pAmXZtE7AiYAwzZPAZNn659LOvPqFX9aLn5lBsgohNbji49GwX9CZVfnyiCfR6tgzvNEHv86rv+fKcv1uB8wyfO0kbrUHoamyJOMEO1gq5Mdx3mYTQ+ZNG6FHXHxaTBQSuBBhSMy4d68/loEtKyTIXu/i2T1+61WVzCdASjvS10UQqTvO5yNMHylQqBBF1oqkxflfopaWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xwlN/aid2gPLz4D8UaeMK1Hv5lGVF1q6RJoDh+qJH8=;
 b=ks/w0o4DKqUxVaukyRIs9rz7crVUKb/fRgDWGn3COciLPhXRKzzxLkLyhf69RBzrm7bL96D1en2aDb5qe7S7OfiIo3gtTnAeOIwqvXJ67jOc4Ms7VzeFt3zGrTNSWlNrOnTvVxrymxxfW/U/DB6v6HPJHM1BKJPDQC+OZXZKdZLk0TE2fOPCEc8giCRpnGri7zGtJoXvqNrqEbna6tt03VdpdtwTmhWhlWRoNnaKixONey3DNi1vv6wcwZ8Ea5DTLo24oJGkYsj8FGuNQyAwpLUMknYwRz9FAp80rEcJL5J0xweLFLsCBS+c6CLRtvA/OUIdv1NF0f6XMllkqTBaHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1742.namprd15.prod.outlook.com (2603:10b6:301:59::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Wed, 13 Jul
 2022 19:52:39 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 19:52:38 +0000
Message-ID: <f935d733-9bca-f396-301a-cd3a38fae7e7@fb.com>
Date:   Wed, 13 Jul 2022 12:52:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v4] bpf: Warn on non-preallocated case for
 BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE
Content-Language: en-US
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220713160936.57488-1-laoar.shao@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220713160936.57488-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:a03:331::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69fe0685-8fa3-464f-b88f-08da65093d6e
X-MS-TrafficTypeDiagnostic: MWHPR15MB1742:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48nJrS4f3WmD8pH1nsDm/EzWdN8bAYENobqLpvN02QbTnxWCCaqSPGpH6jIwI/AVj1KI4xOgBLCztXqEEDlAqrUWX6MRLCTpZIKS894Z1E7geU+q3GWh8NQ9qGgYCY9lvqeDBs4HYyB0NJxQ1upTA2rJ1iopGrC4fYa7P84UayxyvKZ2K0djdMntytUIMUtoa/qvu9vVE1VIN70MKLiER5CJxrLwaDO4P7jePpw2Z5jB1fV7ZPSAKTeAInYxBua+b06dbnUcLOM/D98WyM1GNPobIZOXQGyn+7sAE16pLXRURc3fZuzzmzlVGNQtaYzwk+UglOiat0XpQQlHSaj3el+bysqWM/ranj2Gp9qMxnvgNUT9+2K8DTqXLqPs4RDa0jAu/E1eMFWB7ljG24WnbPAm/Qm0w16DuhJFTSr+DWv5wnTbL5026XzAfbkBFEIm8B4MpxQ86m0bxkwBQ2NkLm5DOV/rd5grz6FGtvRWrGuLPHxIGfqSwJMCPhWmL7OcaH+1GtYxnKXU0yt0WfJYHztkNpZFHfml8OckCz9OHOJ41blfnIfn0qrobj0V+cSDnihmOifqc5ylrSiJw7afI6pxZmE9BlsGz8nIPY1Rysx0wYGxL65812L9UlGgxB4T58zzpBKUfL+EqlvO1puo/Mms5Kp9G4RmiIN/HK/WM8AeAo2DTE8W07OV+NcdbsNQq4GkdmA5CMxVmYUZP1YD3/sRy6yeNaO2EswEHylzx2rr8V3FUR1aB2S4Pl22RzfaK5sYR1rvYsgU27UPuUPuRm7zrWux45X3gPnnnJE2onWb4hvROQF363g0ljT1Pb2ZMFBrmA2urXbSsWLw3Jqpuq2vIfbj/cGVXiQN0xwPj/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(8936002)(5660300002)(86362001)(31696002)(2906002)(36756003)(558084003)(38100700002)(6486002)(478600001)(66476007)(66946007)(66556008)(316002)(2616005)(186003)(8676002)(4326008)(6506007)(6666004)(41300700001)(53546011)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N25RdkdtcFphdk9pdzVJQ01yMjJoQTdLVDFQZXJpbWwxUUhHb3d5TS8xemFI?=
 =?utf-8?B?S1dXR0hJTG5kVnMwMHFtRDhpTTVsWmJ3WEhJUTJiSTB5SU1VTWpzYy9lRERw?=
 =?utf-8?B?UENWRHoreU82TWhLQ2ZyK2Jnb0FpUG1ZWkJEME1MTG5QVnNreUU1b2IwNksz?=
 =?utf-8?B?YlA4TXEyZUNvRXpvSzErT0ozVUVHWHBYOHZhOHFTWHBlRmVjNWZHT3dnMWRl?=
 =?utf-8?B?TTI1Y0RtZWpGTlh4QTRYM2EzTS9WSWFKNzlQa0U4aGV2SmROblBhWGZtMXZs?=
 =?utf-8?B?SlkxNGhmWkhFZ1RORXZsdjhCS0Y2YmNVZWRtc0ZXL0psUml3R3RoK0szQ25P?=
 =?utf-8?B?Ykp4cEFyRndDQjBYYlliU2hrckNUTkxqSm82elNxelFkVmJ1SVNXUTlDZ0Vq?=
 =?utf-8?B?VU00Zk9hNFE0ZWFsMVV0R3dsamU4TFFSeDVFZytDOGJzcGZETnd6U2pQVElM?=
 =?utf-8?B?OEYyZ0lFQlN5dlg4cXFxQWxsSHUrTEhKeDdzNURnZGFVTm5RS0xvcnl0alJw?=
 =?utf-8?B?Z29MM3V5bktnNjNKL2l3ZW1EUFdiQjErWk5rdWZoT1dmNE9wZU5aSWJ4dnB3?=
 =?utf-8?B?M2hKdXcxeSt0aGdPR1BjL2N2cHBYdWhydzZrL2VDL3Nla0ovNW42RXYzcFNJ?=
 =?utf-8?B?WmxEaDBJSDl0NG0xSzBrWVVjM3puN3VIUnQ1ZzJHWEhGVUF2K1JwZnBRNE42?=
 =?utf-8?B?bmdzZ2tnTXBCaytLY0JtU3RrOFlnK3B1QzRuOWt5UE9TUU45Z2tvcDY3UzN4?=
 =?utf-8?B?dXQ5cUp3T1ArQXlOek5VSTc3ZGk3YnFYTGRRM0tOL2J1dHhPM1FURlpSajA3?=
 =?utf-8?B?TnhuMHpnN2lHOGJ6a3Q0SVVDYmR1Sm0weXVmeWFRTS9HWGRrMDBXR2pnSFZJ?=
 =?utf-8?B?VGpNcDhXR1NHWisvcmJhYTkvZHgvdkdGWHQzTGp1SnhhbUpPdlRkVlRLYWZB?=
 =?utf-8?B?RjZoYk5IaWE0QVJjWWdyNjd0dko3WkQvelhMeVQ1S2sySjI3ZjcyaU94Rmcr?=
 =?utf-8?B?UndsNkRoTVBCQ0hOdnZOVVk3NEVUSEhLYTFBVFQ0UUhhSU55aG1DMXRYNUlp?=
 =?utf-8?B?T1BKQ0p0R2phSGw1WUxzbTQrVlYrd1A4WEdWV3RiNldSNjgwY3JpZU5MbDNv?=
 =?utf-8?B?alkxbFI4eXNQRndWekpwZFAvUkhPOHh3RTV2bS9KN3NXYUFnUHBSWEpNSS9l?=
 =?utf-8?B?RU9NdHF4SGV6bnVPbHZNRVVlVjYyUUEzRzl2TVJnUG1oaGRCY0NlY0RMdWpK?=
 =?utf-8?B?cXhpV1lBcnJYd0RRMmZJNWpwZytZK1hXWUhicHBsMHFXSWZueXFHVDY2aWtQ?=
 =?utf-8?B?SzE2UGMvbGlXdzhsQ3FyeHRpNGVzK2ZlN3BJYURicUJOekdIU3hIaTFUV3VD?=
 =?utf-8?B?M21ZM0VmR2RTNStMS3UxU3dXOFFLd1RWN29nZlR0bFB6RDNUemk5YksvMit4?=
 =?utf-8?B?VE5MVWRmTE9vNWRxNVJCOFJWaytsRGJOaXBGNit0Z0dPMXJyczM3OGZLbmgy?=
 =?utf-8?B?SWRzcWpZR1g3dlJvM2RQQlh0b2YrWXgwRnh2TktxTU5ETXQ1K1lHUTBLVWZ2?=
 =?utf-8?B?cjhlNEJwM3FzdzhtYzVxZENIVEUvOGhKNzdSNGgxb2NwdmF0UERhRDBKL3BU?=
 =?utf-8?B?VlVDY2RGQWo2dVBFSy9hekxUdlJRNHdtdHN4ZTlveDZoeGV1bWkwMEFSR3Zh?=
 =?utf-8?B?UjBvQkp4aHRtU3RiUEoyZEdlcW0xWGZ4Z1hrdnhZVE5EZkxRa3NSbDdkV3Q3?=
 =?utf-8?B?b1QydktxVmFIVHdYZWhTWDFKV0EvTGcyOTFaRmozNjI3bXZ3TVpNTzVsdFl1?=
 =?utf-8?B?STd4Qk5RWElwWC9seTlyeDBINlJSMWJRenpLWTczcWczc3hrSW1ESHF5S2NP?=
 =?utf-8?B?ZXRoeHVFS1lHZEdNOGkwc3BzakErVnJFVkF3dHp3bVhBdEt0alpGMVJ1bDAw?=
 =?utf-8?B?ZTVzTHhROEVxT1k2TldLeTBoRXJxVVdRT0NPR3U2WWdRaDIxcVVFYklKd09u?=
 =?utf-8?B?VGpibmUrdTI3Q3RZWkVDM1B3bzNrMmNHQWhBVzY0OVJNNWZIQkNVL1B4R3B2?=
 =?utf-8?B?ZmJnNTFOR1hrV2NXSWtLQVFtRDZ1dFF4YzlwcjN0ODlrL2RKMzZpN3ZYUCto?=
 =?utf-8?Q?HjILDHdReQ9sdyTcC38D8y8UQ?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69fe0685-8fa3-464f-b88f-08da65093d6e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 19:52:38.8155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yx9wtehZNYMBRWE5waVQo6YoCvHqGUtAbFKOwRtlwExZ/DXlX10359civ02I0z2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1742
X-Proofpoint-GUID: BUsIxTVigP2RgydHGGt0xkbJQRmDZuxI
X-Proofpoint-ORIG-GUID: BUsIxTVigP2RgydHGGt0xkbJQRmDZuxI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_09,2022-07-13_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/22 9:09 AM, Yafang Shao wrote:
> BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE is also tracing type, which may
> cause unexpected memory allocation if we set BPF_F_NO_PREALLOC.
> Let's also warn on it.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
