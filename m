Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DCB60C68E
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiJYIfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiJYIfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:35:19 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AD324F11
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 01:35:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kk//h+ZMBt1wPS+kQn5rfM0olKkm4Vi+0LHEjGPdXqNoqb1qUA/rpxMq95diXLKiQng4F/ezinojLJAfbrsJRdmhoCoEUctWig0HammtembGupdy+JeKIWvJWhdL2k8WrQi/fcaOW86q3Tpe8JXzII/4K95Ys3OXOp/EQjjQM5lKF8NdSBSj7g/7dsGP9yyxHHzwXRSDJ4yqjAhyh5VSL58J9ZXRkCYbIVrzIKVw7onQxvqNXk1CVjKqCyt+st2nD8WsM86tMcdWH4VDJixGXMoapSk69TJ596lh69HUmu3B1TBSdGN2PXYC79n4dPZf8w3b07xR4aci/ku/+NSplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNHfFOHIoe/5pTSAm4wASFiuGv0XLDASTkAjRKLd1So=;
 b=F+j7/8tMb4n5PYpED4G2yV8tbh0BS/Hl6NUilBXddM9JyizdQ8aV9Yr1YmFP6wrA+JfxDfaGdgxGdV8gye3SpvqukfyhZOtpZbWlLMRxYk7itfzNePu9DfVjNkVF6gBRMPFG40MRonQheg+FDbqUgZerbGDYyVev2UtWANgLqdJbuVrjQOCKkTFsGp+fwseuli5z/jLDhmZ/xF9UlkO0yal0gVlfSvTgGf/VQZMBEWExtmrJhOxygPUg6LOAmWMj/4FxdLicMxKZhDcNQZ/xaew82xMI5juMhTo2If0W4lQp/H4FDQNV79j6/Fby8/KN00RI/29EtHXBln/+k6dhww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNHfFOHIoe/5pTSAm4wASFiuGv0XLDASTkAjRKLd1So=;
 b=Ls96/meeNlB2MgPwGjKw5GKTnQncCcNBrLe9Ue0W/aXFIupere+qZ8Gap+ezar0PnSMsrYjVuuBuyc+JhIttEiufj+YM9VXcchF6DYjwx+1xrEqWYB45vAbpWNq9Kw1st95O+lyREMEtF6WJgCNdrzoEP+0Mj6at4lzR779QCK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 08:35:11 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7%7]) with mapi id 15.20.5746.026; Tue, 25 Oct 2022
 08:35:11 +0000
Message-ID: <e9bf1b39-a2fa-2c85-8874-e3676e4dd7dd@amd.com>
Date:   Tue, 25 Oct 2022 01:35:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 3/5] ionic: new ionic device identity level and
 VF start control
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
References: <20221024101717.458-1-snelson@pensando.io>
 <20221024101717.458-4-snelson@pensando.io> <Y1aCGgypfvK/+iwn@unreal>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <Y1aCGgypfvK/+iwn@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c2401f-65cf-4a3b-97b0-08dab663d470
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ROs/+tbkmO3vgKtGjmBX1f7tiiRvwB3gE98jPRtiZDG4x225BicXK6OS69iYup55Rx0qj4JX5KrhsWYTERaicVk1eep6hEZktcw/I/3V4H/HyGJKxIUZLA2yncsrQcHwe+pWfuNBpDCZ8cU6u3gjhPRFnS5MvCMCGhCQRiWoC7j42kTz5yVaVS5fM6aOmvipRIS74AUpMeFHO2Z88SvDFwuDairpW7IzeHwZ6gnqrrJ+vM9jc1AuVXpa/gX9Q0WTmGZ/UXn+XaEVyYMOeF0DHfyuGy5UVgIkKJhprtveCUryuoSFj6Wtj8xFf6+BoIaXPzZX5FTryvOaQVKA8Oazng+zRsKiuCX4Qw5xxPsb7taTW4Zhbye3+4lrwrOlZP1HxhasEkFQlEyEgfiOBX+BpxryI6IOGVj4GrTxvhcIJmM98QUMac/FpY1TeJ/AtmWnrJNZ/NFopXm+RVa1tLJC7MRiT6BR96cYjBKVb7UwqepzZ3qMfgOx0537Ka6aWja2WYskbzRN6/1tx6KJH7OQxvNJCisT9PwpQiBtondDpdCHQ9UF+uXqm2MDGNCvEIPCdxOBsKh/BfyWb6nEwhZLz4l/M5urTNCxwLvuUr2zY0dYcF3IpPtjotUxhuPGDRHFKO0i3wxRnMvZtES1yiPcQDY3YredrDS/xIk5ZrbzAkOeU7mTv6a66EkQfsbrBxaiQToDTx781M4zFnu2D1Pf1d0SFCU43QaoL7jOwrwxlrfRIvJVU7KpfR3fJkGK8eTqwNyg6e3lS5CE+uuPX2TUnP3CugTPlnV83Pw2xDpaUoM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(31686004)(36756003)(31696002)(4326008)(6486002)(8676002)(41300700001)(83380400001)(2616005)(186003)(53546011)(478600001)(38100700002)(2906002)(8936002)(6666004)(316002)(5660300002)(66946007)(6512007)(26005)(6506007)(110136005)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2V2RXFuclVGeEJ4NU4vNjhkc3VBS21JRXpkVkVlZDFDK01BYnVjQnZxRnh2?=
 =?utf-8?B?ZXlXVGZGQnY1TUN4Sll3TDZVc1dRUldZczAwK3dpUUpHck1QZGlia1lIUUZM?=
 =?utf-8?B?OUFmNGJSNHhJNWR0Y3FGY0tyakNNYkV5N0RUL0dXdzBLT0RYdVJGKzhBUlNj?=
 =?utf-8?B?c043TmZYbUpzbW11NFlSRElyTTFtZTdRU011Mytwa1V2WnlFNGhRdEFPRHdB?=
 =?utf-8?B?RG1WU01BSnMrcVFkbXI0SlFQbEZoWnpFU0VrNm5jZjhsVjB5OUl2S0RyeWhs?=
 =?utf-8?B?emZ2ZHB3cTlPK1ovckpad0lDdDVNaEw5RGdJOW1zaUc2d1dsdVd5ekowbXBR?=
 =?utf-8?B?NGhudnRDOFVIV0VLZTBqUTlzT2FYTS9QektSdkVORU56V3pVYTArUnRsN2tp?=
 =?utf-8?B?UmNDR2RQN1pSemV3b25mWHBkSXg2d09tNkgyV0hoandVcE5NK0ZnZG11c2VS?=
 =?utf-8?B?N0E4ZXhjeFdkakNqeW16MWZKZGpaZkVIdTBqL2NsV25uRDFFdnJJdTF6RG5v?=
 =?utf-8?B?Z3pRb1hMeW1vNUhTazNWL3EyOEtwVnhtZ0RzQ2ozOVlaTUdsTzNnTjlwdTJw?=
 =?utf-8?B?eXBTYkRPZytzd0lQZ1Z2bjhYL1ROcXNTWGw4Z3FPU1VmaHJscDJLRW1uWUhq?=
 =?utf-8?B?TWVMRzUySFlXM3UrNmJyLytNWWtXZ0FsUlRJN0k2bDJ0OGNEQWJBZU93VWZ0?=
 =?utf-8?B?NHpuaDJqOEhyb2doRmMvZzZYdzIwejh6dG8zam9Kcm9WSllINXZXQTEwbXRT?=
 =?utf-8?B?QzlJR3FEVDlGeE9nRlA5WGxkWWVlRzFRTlM4dWZYL21ZMVkzYWN3RXFBeXQy?=
 =?utf-8?B?L3ZwUm15cENkaGJFbnUzVmI0ajhjZjBnMDdtenNKeFdYVjM1Sng1Q2JiVWZu?=
 =?utf-8?B?RldMYXVvSzhjZzNWZHhyRlJYNjFKbVpCK1NTTWJMRmRFbThFbWtaSmE3R1J1?=
 =?utf-8?B?cjZETUt0bnhrMW0xTGhwcFh3NVlsd1l6L2tuR0ljT1U3SEZEYXhhRXA0ZFoz?=
 =?utf-8?B?WVo4ekF3RDNWeUYxSEVtUHptOGlvbERIeDd3bjhOVW1KeUQrRTFmVU40K1hu?=
 =?utf-8?B?R0VrSVhOd2owdm5Qc2x4Y2gwV0wrT2gvVTBwa0NZUVJJeUVKS09BZHAvbmE0?=
 =?utf-8?B?dURKckVreGMrUnNxYUcwdGVVa2RvUkpUZjVLaHNKcDJkR3lIU2JKTnJzS25v?=
 =?utf-8?B?MGJENWQxYWFJNnErM3hWRDkrM0dWOTh4V0RVbFZRMEU4b2taODZxbXB6RnIz?=
 =?utf-8?B?bTFrd25jUFJrU2d4Tk5ROEduTHlnSllpOGoxZWlZZzBIcHM1OEcweXZDOENl?=
 =?utf-8?B?OVk3VWVwR3RTUlV0VnNFUm1LN09uRnZEOUwyaTIzT2I5c3g3SFhVbEpTTGRK?=
 =?utf-8?B?dXhNOGtSbUVNVEtpVUZoZDNZUjc3NTEzOGN5OCtTUjVHdXp1UldrMW1CM1hS?=
 =?utf-8?B?QnZwMDBxMUQ1cDg0MTJ3bUZabnZvZnRyZHdkSFhTLzFjVlViRE12aHNQNy9n?=
 =?utf-8?B?enpGVXhuTmYrZmFNQmUwbGYxQXpKRVBDSUcvTWJELzBSSTBjK1Zvb1M3NWc2?=
 =?utf-8?B?UkJGajBDWUZmditSMk9hb00waTN1UXJYcXZjaktsZnlGZHR0Ti9lYk94YTJq?=
 =?utf-8?B?QzNPRytNOWc5bXI1VUhueDNkY0NyYTVldkI0QnA0Vlc1WkpGL2dJb1Zralpn?=
 =?utf-8?B?UUtVbXpBL3gwRERhbERIRUpURTlWSEtiTHovZHAveVh2b1grZ0lVOURhTWxO?=
 =?utf-8?B?WGxmWVc0R0dyaExQV2lOaHFCM1ExYVZqRVV0Rmp5aFgrcWY1SzZ0QnRqcGM2?=
 =?utf-8?B?QnJpb1psRS9ZRncxNUdNa0NDQllyVEJPeEw2UWRPZzM2eDE1RnBROCszMWFh?=
 =?utf-8?B?NmJ1MHFSdWxPTGlMM1o5ZnZuNkNGWWZSZVRab2diZU9CR1prdGtjc0lWa2RR?=
 =?utf-8?B?dUNHLzZCTGtKY3B4bWo1ZktYdFd3MEN0bWM2TWtkdHp0OStTb28ycUdrVk10?=
 =?utf-8?B?OUxBditycXV0REM0TCtXRGplSGMwd3VMaHR5dlV2Z214TEJWVEdSYVduenRm?=
 =?utf-8?B?WmhsRFVWcVpQQm1lcFBRa0dsckI1QUJEaWZRQm9LS2pZVnZzN0ROZUlTUXhU?=
 =?utf-8?Q?qD+m4BibSEehimApt6TgtvFjH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c2401f-65cf-4a3b-97b0-08dab663d470
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 08:35:10.9762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnvlQBkuxea6gF1HBX5zC0aIyU7wZD6BnvYMmOe1fInGD2GJNGGMJC2Czo8z2i8m0oeS2mKikPt89i5GFSwfHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/24/22 5:16 AM, Leon Romanovsky wrote:
> 
> On Mon, Oct 24, 2022 at 03:17:15AM -0700, Shannon Nelson wrote:
>> A new ionic dev_cmd is added to the interface in ionic_if.h,
>> with a new capabilities field in the ionic device identity to
>> signal its availability in the FW.  The identity level code is
>> incremented to '2' to show support for this new capabilities
>> bitfield.
>>
>> If the driver has indicated with the new identity level that
>> it has the VF_CTRL command, newer FW will wait for the start
>> command before starting the VFs after a FW update or crash
>> recovery.
>>
>> This patch updates the driver to make use of the new VF start
>> control in fw_up path to be sure that the PF has set the user
>> attributes on the VF before the FW allows the VFs to restart.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_dev.c   | 20 +++++++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   |  3 ++
>>   .../net/ethernet/pensando/ionic/ionic_if.h    | 41 +++++++++++++++++++
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +
>>   .../net/ethernet/pensando/ionic/ionic_main.c  |  2 +-
>>   5 files changed, 67 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> index 9d0514cfeb5c..20a0d87c9fce 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>> @@ -481,6 +481,26 @@ int ionic_dev_cmd_vf_getattr(struct ionic *ionic, int vf, u8 attr,
>>        return err;
>>   }
>>
>> +void ionic_vf_start(struct ionic *ionic, int vf)
>> +{
>> +     union ionic_dev_cmd cmd = {
>> +             .vf_ctrl.opcode = IONIC_CMD_VF_CTRL,
>> +     };
>> +
>> +     if (!(ionic->ident.dev.capabilities & cpu_to_le64(IONIC_DEV_CAP_VF_CTRL)))
>> +             return;
>> +
>> +     if (vf == -1) {
>> +             cmd.vf_ctrl.ctrl_opcode = IONIC_VF_CTRL_START_ALL;
>> +     } else {
>> +             cmd.vf_ctrl.ctrl_opcode = IONIC_VF_CTRL_START;
>> +             cmd.vf_ctrl.vf_index = cpu_to_le16(vf);
>> +     }
> 
> <...>
> 
>> +     ionic_vf_start(ionic, -1)
> 
> I see only call with "-1" in this series. It is better to add code when
> it is actually used.
> 
> Thanks

I'll clean that up - thanks.
sln

