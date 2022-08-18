Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3958359911E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 01:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346153AbiHRXUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 19:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346151AbiHRXUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 19:20:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215E02FA;
        Thu, 18 Aug 2022 16:20:47 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27INAG8m024262;
        Thu, 18 Aug 2022 23:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1Ywc5CP7SDwiMOkzJ+Sqrsgez4/sYYHE8MA0xPl2sg8=;
 b=3cUJVpLEaLETRXWGAVUHEwQCw5TjYrB401SDUZCLeTa84ifaCH6usOA6PARnf/b4bk+q
 G49a7Xmn6MEbvHo58IM0EiaOKuqPG+BJ8Hedncnz1WJ3J+2an0PXF3kVc9t8xGzrN/B3
 NO1EP/xT8kCaPauiL/cD7+TuXB/XjPqz/N/J5lQUej+S4xA2ClEnKEie0iHBmHLj4soQ
 wtAwaSAL4/9PHuLb8M6jOqjs4pA6cLHPOywlTe1CmnN+/hpTJCvbNIdnf7MpJK0P3SUc
 7Oh6D3nSjzxXX0yq0who4T0m4E50jtkcwXL/71gXOv7AuzpEDVPywHNq29xRWdPxzJ/K aA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j1xut00c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 23:20:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27IM06CT020799;
        Thu, 18 Aug 2022 23:20:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j0c499m9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 23:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyisOTTtPyEykXSYjDZXGi2QAFN4q7oWEcI1wLbqNUlJXYyOOPw8x6CsXmeFuYHsLvFhPodZFV+e2kNFyeaMdGJ2t+JJ24ptVBBwWqRRBXKFPRls4cCoewQAwPej8afgJ9vOnobJ0hns2LdvGdACZli7wd5qtlqHrmTrbh/+7r3dQaprvK/M86m8OliBgEm6oqn/+U3UZDWTw/LWKcDQexpDyeRWh8L3EQdFEjIr0AvzGoz2y+xa2NghjAwJ5eScP8GW01gOY5b5wAwwCmO+U/C2/31RVrte158R8cQFFx4S1Ym93RrurTP7Vt4rN5DSbtNTLVvAIzVgdllM9OChVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ywc5CP7SDwiMOkzJ+Sqrsgez4/sYYHE8MA0xPl2sg8=;
 b=dRrQOY8w3BAGnQl4TIzHJ7RVg7GSpbv7RlXA2UIH2tcVeg4BGvDTkg9lRAkKPqbZpH7zOprQvNngq3YS8CTScI/fOWG2/HihdWDX11P90cxWR/J7K7vAyP9XB/dp3TDfaEpfu1coF7S0L/F2IEmXSLBZw0M+UwVqwVdLXc7yOZtCOBK5F2+Pc7HnJEw/9g2Z+F6FQNLbskbLHsyDXOcrbqIm5pKrVZIlXKG8aUtPAFeBQsihnzy7p3EnempVJsjkN07cNh0LMbUARhzorVh/UvaffjZxoIWtGQ4j10Ag5SKf/GdLONFsBFpqLcSZpcQVe8d+cxsaToDZcQOXJ6ngPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ywc5CP7SDwiMOkzJ+Sqrsgez4/sYYHE8MA0xPl2sg8=;
 b=n9nbuQGBcHFgMjR4fAvttPprSv/FkGw8gMq8O5VVxql+NY5OVpHGjeeeVUAiG6ATJXajuN649VmhxpWKw12U5jyEg7oNk+N7swxk9KvUUndMHKpWRyjKqry46CKN83eBBgsInFrtHO1Ye0kq7ZOngHel9Mn3fOcU9USNuSvvM5o=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by CY4PR1001MB2183.namprd10.prod.outlook.com (2603:10b6:910:42::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 18 Aug
 2022 23:20:35 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 23:20:35 +0000
Message-ID: <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com>
Date:   Thu, 18 Aug 2022 16:20:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
 <20220817063450-mutt-send-email-mst@kernel.org>
 <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:806:24::9) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f02456a-82a3-4650-c9fa-08da817040f3
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2183:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xt7FGrNHC2nldznkiRRHm6lw0HpJCpa7v910VQwBhD7gJSD/gv2cvC/8hnCiLL6XZdsAAyDGwPVULpVc9OVARzluKUSYOfHH/uHZ3OCqxOPifHIR0tClRRseRqS/YX9HQp3udIY9p46c2xTfATI8vch7kFZZvfgFvMBGwLtcYtseTk/6uCDi56xj+B6kung74wmi/RO07DQ+97WhsCfJaGrq3vjLo3xhKySGs4au1LIUR0ZXyTCoxltP0xWTTioqd1s9Ztsisaw89JrQTU1cY1jFKuJFPUN+4L6RuHOTrYciVP9lXsfgyPwrYC2eGrNZoufIT9yACL8D0aOnGmU365JwwBCnp7JvLpCIk0R73z46Eye5qhB3/8/K4c2g9vgD0+0WhMjJytS41HnMg6xmIuFbaCBd1I356kcugFEE0mcI+SBp+zfXnEu/gzbmlzKd8cISVrS3QbVK3j+9DajYeglF5KvEsX88+T6hjSi1vHGwEFN9lgdXoTFPiug+MiUwhHTrXX1rsDtpFd2Wyxe00gd8hcnlFq6GRhov2IE2BLB5S4seZD32gauuWENO/AR0dWwQlniDJvuPc0NNu0TUDs6UEUbINReyjF6maEZwMknmGqD9nZj/xxLj5lv7pi4StDAhQR0GXYeMmXw994yid1z3JTdeI0nyY/15PNbivbucyxMErl4RvsH1hHVktvQJitssMNkXAOLjbbfc2spKWwnW2yM/Jtnd1vWKnDGSonVpmtusIeScr1DWhUR0M/Ol5QIlsSp5sQnvXS/OP/gGUd0Q4TYW5N5lVKnCOpw8Db8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(376002)(39860400002)(136003)(38100700002)(36756003)(110136005)(31686004)(316002)(26005)(6506007)(5660300002)(36916002)(8936002)(2906002)(83380400001)(8676002)(66946007)(66556008)(6666004)(66476007)(6512007)(41300700001)(4326008)(478600001)(2616005)(6486002)(186003)(53546011)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlNTSlhnbFBYVFpYNThRTXBKUUR2Y1FDYUVaMFpRWDhCZ2JzZmZaWDR0dElH?=
 =?utf-8?B?dGNieFdkK1YwbHAxSkNxVmJrNWJDTDVNOUVGSlVNZC9IVVJKams4S2dmYlk4?=
 =?utf-8?B?bkZncnd3S2tvam1pelBTcTZvcEdmbTNObWVzUWg4MG1MeTNLQkFpVTE5NkFZ?=
 =?utf-8?B?ZERlZ0hIQjB3bFRmaFZCY1pBVkFlanRlUE1nSWRpVXpkam0yZWxWaUw4V21n?=
 =?utf-8?B?KytMUml4Sm93YksvWVJBTVBRWjUxdU9jK25KNnIyWW1Xck10SVQvSk5OVXlP?=
 =?utf-8?B?cW90Zzd5bk9pei9wQUZNVVJabG5uWGlJV0Y3blFDSVF4SURCb0IxTWFMWmVj?=
 =?utf-8?B?U0ovYWEvOGNaMllWUS9SVHVMUjN1RWNoTGpsNzN6MUxNdERQQ1ljVFBEcmFa?=
 =?utf-8?B?TlRjWWI0Q1FadVF5c1BvcTgvK2s5WndkcG9uY0hjRkRhSDViajN6MzE3c245?=
 =?utf-8?B?NXl3ZVZkS2k2d2tHYjZ6MnhhRzJBR25xY2ZqcjkveCszQ0RWaGVLeE9aUkZ5?=
 =?utf-8?B?MFYrZ1E1bVBpOEViMWZZbFBUb1ZpN0xkd2ZLdUJIUmxsSXNXbTNtRzZYMGNq?=
 =?utf-8?B?UTFXbkwyMVZRRDd5N1p4UkkzSHI4WmordGdZWVBJNjVTREdGdzJTTmFoSFFD?=
 =?utf-8?B?U1htODVzdjJlcThxU25vVU5vOGMxQ090R2Y1R09LVHM4S2xqMGFoTXd6M1hu?=
 =?utf-8?B?YXpZWFJmK1VMQ2xHMGg5aHFvdDZoaEtrOUdjYzJnc3FUSGplcVFEQWNMWGZu?=
 =?utf-8?B?SlIwVXFUbmp3TTdndHpad0lBeWFIZXdQSGNQMUpPMER1czRuVmJsK3V0OTJk?=
 =?utf-8?B?L0VMS0tDcUlQSjRlMEpYbWJYa0pJZWxlZS9zTktXclE0SHV4UE5VSUR0Q0pq?=
 =?utf-8?B?dERvMG9LZVlyQm4ycG44Z0E2NDlmbEVyNjNBK1pUY0pCaGNaRlVIdjFoQVZU?=
 =?utf-8?B?aFlndVIzNTlZd3ZZQ01lblpkK0NLRWVCc3U1Z0ZSOTBWNUZBeUJURm9aNnJa?=
 =?utf-8?B?bUl3UEcwWXZpVUU4MVZJRG9id05NREUrV0hLOEs4OEtJL3cxTjVtdUxDUEFk?=
 =?utf-8?B?ZU1BMWFybGxkSkNlVkh6bGJ5TGxuNHdJSlhKWEJEWXYrV0NrZUZLNk1zWjhZ?=
 =?utf-8?B?MHp1NU9hZlRxZjgyMS80WkZlUlBNeGNLcWljL0VKbk9JNlVPa0NuVjdXMEF5?=
 =?utf-8?B?K3JoaWl4cG1KQmRNQm14NThpOUlNbVJGU0xxaXBPNCtxNTRUTERGNjVwcFZl?=
 =?utf-8?B?Y1dGaU1CNTd2U3FTcHpSSHR2S3JGR0U3WjFsSjNLWlR6L1U2Z3liOXpEa2p3?=
 =?utf-8?B?aFh4clJHVmRDaHBMaUYrTnJJQjZYSGRjQU9LL25YMmJzZVByTEo1YkFncEhC?=
 =?utf-8?B?ZDlPOVZ5T25kNmY1UlpKQjJNK25sUmlxL3c1OEFxNjgwV0hjb2RacjE4dXZN?=
 =?utf-8?B?OURpa2JYUjBIRDc5Y25XdHV3Q1ZaTnYwTHVML3l0bVdsb1JVbFVsRXpKZ0d6?=
 =?utf-8?B?QndZM0NjTlNteUJycmpJV1lnRXRpMmdNNWlIRFBLdXd5VWlMb2xmQ25RUkVh?=
 =?utf-8?B?OUpURUJFTlc2VVhmSmtJYm92TnBCV2xlU2FGbUViaytqOXVMR2hGNmx0UjFK?=
 =?utf-8?B?Rjl4TnV0YTR1VWNsaGs4aThwNERJb1EvSS9KRG80a2l0MTFGQlNBSHdxdEsv?=
 =?utf-8?B?L0RjUGJSRHBUTGZ4N2UyakNzTmV3SXpQZ2NLa29hMEhuT3JhSDBqa0hMRC9K?=
 =?utf-8?B?Y29aN01Nd2ZzTjY5V2FSOVB4NWtMWkI2Z3JiSVdzeFBnMDJ5cGxzT3JubGNh?=
 =?utf-8?B?UGZ5QzR5REkzMWRDL2ZhMzdFRStHR0tqRmY4VzhWYnYwYXh6K2FydUFrcEky?=
 =?utf-8?B?bXZ5eHlheHVISHhOWnRjSkY5UnNVckxaMVVZcCtLLzFGQ0drTWgwN0xlKzdZ?=
 =?utf-8?B?ZTFpTEkyTFUzNFRvd2l2V0UwamFaTUY1VEJaR2RKSU5LME5kdGZkSWJ2ZFUw?=
 =?utf-8?B?dTY5Nm9IOU5BMGtGMElOMllpckV6TFh3UkhGa2NCRXRBaGQrbURsb1duL0NH?=
 =?utf-8?B?SzF2NW1Mc1RJUXJJOENkMXQwclJPcUFMaG9UeDhLTlZOMDRsUmtHdnFhaTlV?=
 =?utf-8?Q?hwYv9PLqNxphlxYXHlshCf/Ns?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?M2h0ZzdFVGpTbkM2SDNpUklTSmNjU3lGbjB4b3M0SnI4eGFkRkZWYmRlNUw4?=
 =?utf-8?B?SFZkSkl0VlhQM3hXcW0xNnlyakJuUEM4RllJOXBnZW45YmNucS9DWjhoWHdB?=
 =?utf-8?B?YjBUMGs5THNGL0hHK0hZN3k3QTgvTGFwMytlMEorL0VBdzZpZVUzUldScHhs?=
 =?utf-8?B?Z1ZuVStsZkE3WXdqUEFGL0FQNkRxd2xZRkhGSjg2S1VBdUlxNnNKR1lpZFVx?=
 =?utf-8?B?NzNHTk9aRG94MnBBZ05VbHU4a1ByWFE5L1lvU0EyNWRmSTRjNEh2SFEyTjZu?=
 =?utf-8?B?dTVPc24wSkR4Z29JVnRpODBlTXJSY3NBTmRPWkxPVnZsb3VoV3JxdHl5aDR6?=
 =?utf-8?B?K3prRVAxU0w1R21mbEdISzl3SlJIc2I5R2lrNjE5TTVpQzliaTFxTnZvb3pK?=
 =?utf-8?B?OVhiQ04vemN0M3NFc0hjOEZ1aG0ydFpocVF5YUpPK3pQdmQxNkhYV1BPdHJn?=
 =?utf-8?B?Uk1RZk5yRlJCeUVVM2JGeUsrNUtrcS9kd0pnZDdrL1poTG1xZHZSeWhJNGpx?=
 =?utf-8?B?eVljbDVERHQzdTRPVTNQeUlhNEJ3VmVJb3ZGUjJnaEJacmlRZFFEYUwxcStX?=
 =?utf-8?B?SmhWaFRpSnFaNGp5dU0rd1dROWNIV1ZIbFNHU0dyRUtscUx5ZzZpTkNXUVFz?=
 =?utf-8?B?WENxc3gzL3QveldtdnN0dThoWUJwK1JVQ3Q3RlZ1MlZhMjVOUnhCQ256VGgx?=
 =?utf-8?B?SnZpUXBmM3JSeU5sRjBRY0p0Y1dnMGk2TDlTTzJFa1llQUFUNlg0KzhtbHln?=
 =?utf-8?B?UXQvSUhPM3c4SFFBR00xUE1ZSE5pbytPaVRVaTI5MkZLdDJpOVg3ZER3ZnRK?=
 =?utf-8?B?VjVka1lKdzVvL2FCQWJsWG44QTc4SkR2cmw5MEV5STdIVWxlaUI0S2Q0OS96?=
 =?utf-8?B?UzFrK1ZNTVBzSEpQT2VKampXQ3JBQ25nSE54aU1oNWkzc0dpUDRHZmwyTjk3?=
 =?utf-8?B?cUdYOUJTRDNqazZLZzNoYXJXK2ZSNW0wYXc2RXdMYTFsODdqWklBdi9vem5M?=
 =?utf-8?B?VlpuL2N5UWFYR3ROQmFncytqcngzNm1KaUdYR2FqRXF3WWVXUmJ6cGg1M1JE?=
 =?utf-8?B?RFE1SDVodU4wWmxLSmE5UGJqMW9jRHRCMDhwN3dJQWV6MUthOUk4VS9kNDJQ?=
 =?utf-8?B?SjVLOHVyb3NRcXZxZkNTbzlEUmk5NU1DN2ZLVlUvRGpxanliS1NuNTNJY0FO?=
 =?utf-8?B?UHZUclYwYzVPRk1ha2g0RGZqQUg4dzRzeE8wNDcrVjNyenVLdHgvUFNVa2pK?=
 =?utf-8?B?eHluYWpHNzluVzJsQVcrdmNQaWpIajk0RFpOd0F1eUpXWTVrYzhpaVFTbnJU?=
 =?utf-8?B?R2F0LzVqeWdCL1pjRHpIVnphWkJjaG1GQUN3emJCOWhiNmdTcWgvZnpqanBB?=
 =?utf-8?B?UVdLLzVnb3hHWjN0alZLdmQ5bzhsM21YRUIveFY3VWNjcFZsYm83Z29nak5p?=
 =?utf-8?B?dHBNOCtWaXZSNFg3dEpId0xJMmtES1lFd2R4RS9iZDlCTTNNNTdYeEFLNWtr?=
 =?utf-8?B?dFNKYlY1M1JMQmJtK0V0a3pGQXBWNHRVVmpPVlhiTm1TKzcydVhidmROMHRK?=
 =?utf-8?Q?MUHROg9/g1yr1WEgweGahp0RLTCZcLRZeXLukdyhZ5JR43?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f02456a-82a3-4650-c9fa-08da817040f3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 23:20:35.3947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1dEExckZk1IweTUlgQ4oV4ZV1fze2Qs69PAj3qH4CRZKaYjAN/x4P2AKqdAh9ZGnZt9DEJkr4v/2m+9jciEHzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_16,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180085
X-Proofpoint-ORIG-GUID: bC9786wraePRAQ6JbIVuoa_lV9r7arYn
X-Proofpoint-GUID: bC9786wraePRAQ6JbIVuoa_lV9r7arYn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/2022 9:15 PM, Jason Wang wrote:
>
> 在 2022/8/17 18:37, Michael S. Tsirkin 写道:
>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
>>>
>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1 
>>>>>>> because of
>>>>>>> transitional devices, so maybe this is the best we can do for now
>>>>>> I think vhost generally needs an API to declare config space 
>>>>>> endian-ness
>>>>>> to kernel. vdpa can reuse that too then.
>>>>> Yes, I remember you have mentioned some IOCTL to set the endian-ness,
>>>>> for vDPA, I think only the vendor driver knows the endian,
>>>>> so we may need a new function vdpa_ops->get_endian().
>>>>> In the last thread, we say maybe it's better to add a comment for 
>>>>> now.
>>>>> But if you think we should add a vdpa_ops->get_endian(), I can work
>>>>> on it for sure!
>>>>>
>>>>> Thanks
>>>>> Zhu Lingshan
>>>> I think QEMU has to set endian-ness. No one else knows.
>>> Yes, for SW based vhost it is true. But for HW vDPA, only
>>> the device & driver knows the endian, I think we can not
>>> "set" a hardware's endian.
>> QEMU knows the guest endian-ness and it knows that
>> device is accessed through the legacy interface.
>> It can accordingly send endian-ness to the kernel and
>> kernel can propagate it to the driver.
>
>
> I wonder if we can simply force LE and then Qemu can do the endian 
> conversion?
convert from LE for config space fields only, or QEMU has to forcefully 
mediate and covert endianness for all device memory access including 
even the datapath (fields in descriptor and avail/used rings)? I hope 
it's not the latter, otherwise it loses the point to use vDPA for 
datapath acceleration.

Even if its the former, it's a little weird for vendor device to 
implement a LE config space with BE ring layout, although still possible...

-Siwei
>
> Thanks
>
>
>>
>>> So if you think we should add a vdpa_ops->get_endian(),
>>> I will drop these comments in the next version of
>>> series, and work on a new patch for get_endian().
>>>
>>> Thanks,
>>> Zhu Lingshan
>> Guests don't get endian-ness from devices so this seems pointless.
>>
>

