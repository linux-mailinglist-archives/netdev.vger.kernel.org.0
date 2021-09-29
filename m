Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5CC41BF30
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbhI2GhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 02:37:00 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:41806 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244177AbhI2Gg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:36:59 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T5vW9Z010449;
        Wed, 29 Sep 2021 06:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=YfVbQUmiC/MvOnaUX6SzFJRiUDcK//GSKnh2UNCOT00=;
 b=cAdQiaRgYMHs9brXTj+57xxzDzxIVHrGv9wso2JZt19BTCfUYKmvcE0DF+vozvx5fiY4
 BlFYx5QLPgXsTSjL07ndwXgTEg2zK4BPw1SvTkwpAc5j6C2ly7e+LAjp9QB+BmTnCHWw
 oxJ6v+VZhQnoCBgUwD8ZA3FxODzGkZcvWunYMp5RzSUGTsUOP1v4j7sblIwbnsFpZxam
 DTKC2FBFxet3vZ9AfHyxl5qxZj6JDixfrP8PTtyaC7YsFnhzXiHWdlMbmIMp6CoWvYaY
 lb1NOABU2c+rBZwVIIVXy9GwRy91TomAI4FpiZVSkGVX8OPEUzL6a9aC/yDZwX3jVQZJ Bw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc6rc0m3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 06:33:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUZBfhuCU8k0k8LjvzhD8ub9EUtBFC9905d+uLApUAxX6s4hamvP32q5GHES2R1guVVYxC4dFvYRZ9aEHeQy6fKGXt7MntkFKOQGicW7TPNgueGjPhR18C1XUctMVb9Y02BiJpYitinC/ZmCcWen983t8u2cSk6fkdwsxJL5S1Ws73X4Bm5h+ziseu/P90z2if3bJO9eXnJtAuALX6u80EdqmfF/ctOCWuRcFTmy70MtQ81ahzwyUTXmKKiEppVW33oQit8KxEY39wF4VCK27ypz5Ws1F3CAkJNgU8tEpXrYS+og+vL+mjEsY2gaj3NFY0FqxZbEGqSvlmiv3cW9MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YfVbQUmiC/MvOnaUX6SzFJRiUDcK//GSKnh2UNCOT00=;
 b=jELOrRnitt2AFUkMEk72JaKAMwW3NNSSJVnbDHb804NDs6ABhGgsa9sHsPopyQMB9vaUOr5WqcOTdp/+p2F9v29yis6wyt0AmetfESNtH2ICWtSuRvpRDw454e+aPmnVC4AC6pZXYul+5YeuFWPlgmD14dVv1/VuWhGKb+FS7AMKnhmnyeXoMhYJ6HNpCqMKgygKVMTE3ykfelIAwVCyVG93Ydb9w3NjbAvqnxih6wBYlgt0ISXUF1UUPUVWaz51rODRNYymbYFw1klHchabDhfEkS/Bxlx9gC/Wh2frIbAZQv2r56/YgyZRboUCPw7bPWvsDPV2b/UJhXTRoX0CkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM8PR11MB5734.namprd11.prod.outlook.com (2603:10b6:8:31::22) by
 DM6PR11MB4692.namprd11.prod.outlook.com (2603:10b6:5:2aa::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14; Wed, 29 Sep 2021 06:32:59 +0000
Received: from DM8PR11MB5734.namprd11.prod.outlook.com
 ([fe80::51b7:91e3:7c34:57a5]) by DM8PR11MB5734.namprd11.prod.outlook.com
 ([fe80::51b7:91e3:7c34:57a5%3]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 06:32:59 +0000
Subject: Re: [PATCH v2 1/2] Revert "net: mdiobus: Fix memory leak in
 __mdiobus_register"
To:     Pavel Skripkin <paskripkin@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, buytenh@marvell.com, afleming@freescale.com,
        dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210927112017.19108-1-paskripkin@gmail.com>
 <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <cf252f69-bc42-3d4d-3967-3f58f8607e93@windriver.com>
Date:   Wed, 29 Sep 2021 14:32:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::21) To DM8PR11MB5734.namprd11.prod.outlook.com
 (2603:10b6:8:31::22)
MIME-Version: 1.0
Received: from [128.224.162.160] (60.247.85.82) by YT1PR01CA0052.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 06:32:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18afbf62-4a0d-4510-f57c-08d98312fab8
X-MS-TrafficTypeDiagnostic: DM6PR11MB4692:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4692A10768DD6A5B72B42AF3E4A99@DM6PR11MB4692.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pwa4nf6FrO6srxxRk0U9zmfFdY6gOQgcEOTupW7gu19syLdjzIMcwLSsl4OOsK1JczDiWu5+vRCRvECDzEtCuyI/7u2XYAoXlSkpQyobsaGXBwAdXYccfSC1mE7A3QHJlk4UbvdtJjzkxeeWbO2w+g3kySjpmHJxSAx2hKyJTQXG39SdnPO0LmGwcRJQpz0mGPZu2wlWMoO+tiVoeTiCWP9cseadKPzgmJWSO12gEO3MJWKMLh3+BLZ53owL+3gG1gFDOMBZPrwasyOzi57Yr/HO6mhrcgaQ079AvjhTyTbX2yUqVxqRlTteyGuWIqjWF744VT3PRGVY/icv8a388D7zbnieXkHhEhNKuulKVhcOlEIGWLS6vR58cD5vyfGxCfG2WvReawO0Xl+aAW4C+iEOZFygsmGTnlTiqA7YVEkylvNSOi9MbVpQziQkg4wXgikHdVHslZox75yh5sTw7XJwWQQ4yWC18XezhkLx/d0o83bgf4qENDDPBguEWdVcefBk6mzfn4wKFe2sXc92qwMloCnmB0K9fCc6qhXdkCRSITj0JYpxsORQX6xWwfGt9vUqXUE0oLXl1VQDxWs32FN44zDfFG5vR6pPDNHE/nXLKmCscYV/UjfLhlETNOtUug5s/9w2zBGrUxrnVKNIU17MkPDy+8nkEUsdiKSM+0mKZ1yUW1ilRKgeP4LAnlbCWpYilbA6umAJjASNyqsisaaYVyrRzqHrAP2y/68fxq1Pe0L3eXkZXJF1sPMRfNZOwEh5Kx1LOoSEdL+rUiKHRGOfCdEOk1Cu2w5b7A5E6TFf5q/AyZQPt7GtA1/+onNRs23EPzCWeN2Pa2TD8RrQjGVTFvk0fTOg3Klu7P8yB1Apdmz2YcNuGgvn2TsUz24z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6486002)(2616005)(956004)(8676002)(31686004)(4326008)(186003)(53546011)(2906002)(31696002)(26005)(86362001)(8936002)(508600001)(4744005)(7416002)(16576012)(316002)(6706004)(83380400001)(36756003)(6666004)(66556008)(66946007)(66476007)(38350700002)(38100700002)(5660300002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXFta1Y1NG50VzN6WjRCVVJJcUt6TVhUaTh3UzROVm1kYnh0elc3RjRsOEhk?=
 =?utf-8?B?cUdqRmxIVXFKbGFDalV4QnpLTFNEVGpVNmlLWDBxOEx1UUZ1aDFxb3JyRGNH?=
 =?utf-8?B?TW1pbWJvcWpBdDRGeDRYV2VuR24wUU91MFRZUFFuY3Flc0kvSFIzR3JXdmRm?=
 =?utf-8?B?WUkwWC9pbXIzcE9pdlh4NFdFMWpIdFhwZlJCVUNHdWhDY2VzNVM2QWxCWWVM?=
 =?utf-8?B?Q0lFL0FGeGltYXNjK1I2dE5UQmRrRk5OSGFSQVdRdmZzRHZVb1VtcVc1THU4?=
 =?utf-8?B?MkxNQnFJcVdnYXZVVUlUTERuWm5VbGNSYVhERVNzMlowN0M4YStDSmFWQ2pN?=
 =?utf-8?B?MHdnTkRxeloycmlTbVdkdkZiYmVBLy9FMGwySmd5VFpiaGFFWjRmck9HS3NR?=
 =?utf-8?B?UTB0SHpXSTVOVE1sNitnTWNmcTROTithYjNVNkYvN0hrb3AxamlYSGVTSGYr?=
 =?utf-8?B?TVNrUHBLQVp2TDNqaHhRVG43eitaR1Y3bnNjZW1JcElDNWNmYXNkdEZsc0ZO?=
 =?utf-8?B?bVFFQ3dMN3E5cDB0V1VXV3NVdWxLdkhlVDRyU0pJQTZOd0hybGpHWnNXTTRK?=
 =?utf-8?B?Y2pmV0pXT1BQV2VqY2RCL3pXY1YxbU5Gd3JXTzlXZXVXSzRub2Fza0Y5SEFx?=
 =?utf-8?B?MlJ4YVhFc25lMzl3Z2VndkVQYndYU2xTU05Yd2dUWWlLamVYU0pGK3lOTU04?=
 =?utf-8?B?U2VPNGYvOTIyN3NZSGQ3ckloTGRZNkRhdmNxdVlKbTFoRXZrcFNkZDIwWCtR?=
 =?utf-8?B?OFVONU95czMzenNlSndqa3Q4eUpuNEg0M0lRN3k3a0VwZThPVWFPU2N3dXQw?=
 =?utf-8?B?RUwwRVVzWEVJL0Zmb1RxN3ZGSlEyaWthcEwvc0FJaHBPU3lrei9Ka0srbmVG?=
 =?utf-8?B?YTZZaG5iTFRYSVBVVUhFOU5GL1J2VXAvK0xxSERmMERQUTJtMVl0VG1WMC9v?=
 =?utf-8?B?UGV4SFFqQ0crY1NHdE1zNjlmd01YYXJWZzRGZklJNUJ1bzl1TEhiSHQrQ3I2?=
 =?utf-8?B?OG01aXZ5blJFZFl4Nml5emlEVTd5ZFVacXg1eEt5LzE5ZFVjQ2MzME9Vd2Jl?=
 =?utf-8?B?RHhFbVgyemhMNkt0U0RveFRRekFhZ05yeklZRXNYQ2MrYWRRWnRESU5TWkNm?=
 =?utf-8?B?SmRTN1Z5cy9jOTBWajJaanhwdFoxRTc4d3NPcWdOM3NIdFkzWXl3dU4zcDlw?=
 =?utf-8?B?YXRKOVJsMVNjVDBib3RvUnNsV3hST0RaeFNrS3Jydno1NGdkLzk4VHh6STM5?=
 =?utf-8?B?VW11S25vdklPdEdxVU56K1hvWW9uSlFKL0VuR2VCZEdhMThkOUQ3OHFDbUlw?=
 =?utf-8?B?WXo5SGtVWWxlc0JmV01Jb05GSktsUk1ibjhIV0x0NUtaSlF4YWxaRmtCOTdN?=
 =?utf-8?B?c24ra08zK0ZJWkRiNFp4bmRJZ1h3YmlZUTM4K2szckg2TGdNQWlKSzVaWSsx?=
 =?utf-8?B?MFoxa3prU3hnSUFwMW5MNWJZelZ2ZzNxaFBZQW1HRElwL25Sa3NyOFYrbWNB?=
 =?utf-8?B?VVV2Q2hMWElhVUsrdFRXV0hVb09ucjY5c29keWRPZTY0bFZYQ0JSOXVodUhm?=
 =?utf-8?B?RDdEWkZDT1c3QXdIQXNON3AvTkFvdmVhVk8xSTdsaWpBdXNSMlpyZUlCdlFR?=
 =?utf-8?B?V0N6R0ZNYWU0Vmw0SXFjTDROTjhpb001blM0emJwYmNQUjh1UW5vVkhKaHk0?=
 =?utf-8?B?bHdFaWhCb1hyNHNBY1NienF4V29UbXNyNW1tcHc3eGszUHo3WXdUNEtISUtH?=
 =?utf-8?Q?CIdnidWdirllvZe0k3KUkJs6jrHNXaJpvLQ3gdv?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18afbf62-4a0d-4510-f57c-08d98312fab8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 06:32:58.9726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dlhFwF2JqKWg3iCqV6xdlXyo0G8tZnV7lVdMFzYSPBirSsVO8dqYnVlMA0+xlgEEFzCmv6/H930cWMAMulNCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4692
X-Proofpoint-GUID: yS-XlynpM6IEKPMH-9BmUhD2mNck-qd6
X-Proofpoint-ORIG-GUID: yS-XlynpM6IEKPMH-9BmUhD2mNck-qd6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_02,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxlogscore=911 adultscore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290038
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/21 4:39 AM, Pavel Skripkin wrote:
> This reverts commit ab609f25d19858513919369ff3d9a63c02cd9e2e.
> 
> This patch is correct in the sense that we_should_  call device_put() in
> case of device_register() failure, but the problem in this code is more
> vast.
> 
> We need to set bus->state to UNMDIOBUS_REGISTERED before calling
> device_register() to correctly release the device in mdiobus_free().
> This patch prevents us from doing it, since in case of device_register()
> failure put_device() will be called 2 times and it will cause UAF or
> something else.
> 
> Also, Reported-by: tag in revered commit was wrong, since syzbot
> reported different leak in same function.
> 
> Link:https://lore.kernel.org/netdev/20210928092657.GI2048@kadam/
> Cc: Yanfei Xu<yanfei.xu@windriver.com>
> Signed-off-by: Pavel Skripkin<paskripkin@gmail.com>
> ---
> 
> Changes in v2:
>          Added this revert


Acked-by: Yanfei Xu<yanfei.xu@windriver.com>

Thanks,
Yanfei
