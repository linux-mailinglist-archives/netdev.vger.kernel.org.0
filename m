Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0B46F0ED9
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 01:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344286AbjD0XYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 19:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjD0XYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 19:24:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D1F2728
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 16:24:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQ+C9i1hYoBflmv4doqvmB/8PmVIT3eXfWdImnw5CLEfEsJc9oDTZtJKNUTtFbhHmfxbfsOkTTtNeQy+h+dyBRHdkud6MGgD6Ou5jg/9EjywF2KcM/Ct0gKgNj5ODpnQo0pJRMJ8MXmOBC+XC1mvPY3fXyn0tZdOFxqR9IGgmNZRPgag30KNJCgdEjNLRKKvVJwrCmDd+woDgBQSxrZ/bYoVByeJqhl/SZzMlUYfl8PwYNHtSYH69hUT491UypoXQ/s6ZqcvnONzrJqTqW2o6CtvW6vjBCFXj7sLxzhjs7P486877bTCvidjMiRX3eBYj2s36aaQClkoR0LX0Hy0nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mS0ezV0bZOfrfDXA5WAi3c8d7DybD2QYyw114h9RKjs=;
 b=ezieQC6RKkUODieAJX2rLM3Tct5FGQ+C5smYINSRpf4A/AbryDPnQiy3nSCvR+/BDmfJN7qvqYTvlLFXiDeJOrf//BexieghhchBE2K4rRZ7Kn0XiOHF9vB2OjJThwEqBtLO20NEoIOZoddA/X6Ip1XNOgf/06NckvXPC/qzwe2J2voQcnqLxztDfhtIZoRaRt+YoIEJb1YY8ONBGy1Hl89mdgaFyq2XLCisNNiTdvvU2JhAO47FRMh8kZYGuzAY51i3qi6lJgIBzOlLJ4nqYKT2t6JkWac0ErElBQlyHWuVdJNIgfstkek+pw6OEK65ogV+EroxBTs20wkiLDHDfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS0ezV0bZOfrfDXA5WAi3c8d7DybD2QYyw114h9RKjs=;
 b=du+0/6jvZbsIJAu0EKsyds9sPlal/hVwHSWcW4o9b4gV2QP39YVWjDUWDdkU87SoEMgj+6LmZ/rRzrXIkx1NRaVIJujX5BQ3DbeVMjg9v0jOHN8eWMl3qldfwWszg0JhTlLOtNZNJHAC7q4+i1fgdPztwW1PRw6k5vXPM+dduew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH8PR12MB7232.namprd12.prod.outlook.com (2603:10b6:510:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 23:24:29 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 23:24:28 +0000
Message-ID: <616c557a-16d3-7be3-b0c8-5fa07cbf293e@amd.com>
Date:   Thu, 27 Apr 2023 16:24:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [net-next v3 02/15] idpf: add module register and probe
 functionality
Content-Language: en-US
To:     Emil Tantilov <emil.s.tantilov@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, willemb@google.com, decot@google.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, alan.brady@intel.com, madhu.chittim@intel.com,
        phani.r.burra@intel.com, shailendra.bhatnagar@intel.com,
        pavan.kumar.linga@intel.com, simon.horman@corigine.com,
        leon@kernel.org
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
 <20230427020917.12029-3-emil.s.tantilov@intel.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230427020917.12029-3-emil.s.tantilov@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::11) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH8PR12MB7232:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a553df-c44d-4157-1bc1-08db47768c20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eTd/JHh1DrHbWj0dUitPbeNwLP/pa3B7V0SsLWgVW/9tupPpYKNEv7clXMenzFX9b5b7spgswCq0YuPJ1UKxXQry02Vn1dScLrd7bD1haX8epGzm/y0ELXjfghxCzpA8McsVZIayuqXWA0pRIZLHRoyH7TuWFqtTOWwMjgcx6psb/b9wEbkMN69y6bROsJEOdMl1MEdbAfOwogriwI8ttroi2n/Cs2yDa2pNKa8+k8nrJ6uVY2VqoR5J59ATC5nkkvnJxGrnCE60Xydu/neDx7jP2XH3sbnjEHxVjT8OKBXxR474nD1U8GfOuicVFWhpWfGQG00Qtr8XiID8dE/rNKt/w61wY+Txc039nHAqCdWw0GbfHCFFpj4auOFdZ4NxmOk91y6/W1GKqJUAOuxggvKCQNKWOcKKtzHIJoDiM+82WTN/2GrMvA1Zh0WxssmNhnJkd4qJ5LPKHXdou4kQqFnfARwJRXiXxQKCFT6k0fjbBT+A+0u152w4lpFMFS09MWLO0Xn92uikwM2SuF3lMr8gOOIOhFmfb96a+USdf0IpQU4IHTHntC2AYkfe8YriTNfou1LjwdrB5R0v8+bmhZfUzJxlkBdxGWWL0RbjM9AUC3DabhCM2craeOC4otpG2GYsL31cORaDS2NlQTWzUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(31686004)(2616005)(186003)(26005)(6506007)(53546011)(6512007)(86362001)(66946007)(4326008)(41300700001)(38100700002)(4744005)(66476007)(316002)(31696002)(44832011)(2906002)(66556008)(478600001)(6666004)(6486002)(7416002)(8936002)(36756003)(5660300002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHg1cWlRTFpmZnprU0RVejFsM2w5ci9ST2JmR0VuUm9EUkgzVVg2L1cxZW5C?=
 =?utf-8?B?Um9vVm9VMDVxYnc5ajdWRDRBZzdaVDh1QllCdml0THMzTWFuclpidU1TcmVE?=
 =?utf-8?B?RC9CMkw2amZiNSs2aTRmOEg1ZHBCR0hXd0RnZVpnZk8vNUswb3BhaGZ1cENW?=
 =?utf-8?B?THNHMEQwVVM4RHlUWWdxU2dZRC9lY09zeEU1cnZ3OW1QaVZldVF3SXRqTjlZ?=
 =?utf-8?B?YjhkeWVDUHlFdUNHSWFiTFdjMmpFRTFLQTl5aU9oN3VnREdodVZ3aHZhMS93?=
 =?utf-8?B?TDZpa0p0WUpHcHIvR0ZFRkFQcEMxRWpVZnQ3TGUvQ2RCMFpwdDc1UlJZU1Qw?=
 =?utf-8?B?eXJWakRKV3Z4S3FUV280UnZEK2lwWlRzYmxmU1pxSE9LVVlxaE5KR2dMYi9v?=
 =?utf-8?B?OVVZQkhRNU9VU1FMRjJBTkt0VkxFWVpKZWdVcXhweHFBdTdpUGh1NHh6T1B0?=
 =?utf-8?B?QWEzVFN2VEt5OXhvU014c2pPR0dsdnpONENxSGYxcTB5UzRqeWMveDFEam5i?=
 =?utf-8?B?REtnZFpiRVBLMFdQVDE2VG9tL1oxVUJzL0w0REluZDg5SEdTYkY1Ry9YcjR0?=
 =?utf-8?B?UmIyODFRM3dHMU9wTzE3RW5md3hhRWxTVkZoRjRXb2ZXbTkxbkFscDMwbTJE?=
 =?utf-8?B?UkRKNVIzU0tPc1c1andLSFEyYVFHdHU1YkZDSjQ0aFF6Nko3dUZtMThMN0xO?=
 =?utf-8?B?UWMvSXhJNCtXY09XcXZ1Q2dXbm10RHQyZ3RMUFA0Q0dIYmhhenBPRXRBNUd4?=
 =?utf-8?B?WUtsUXJmaFhpTWZHOXZ0MjM0VmJ0WHo3SHlzNmhIbWFudzJMWUJJdzljd1hi?=
 =?utf-8?B?a1JaZyt4MWlaODR0eHRJTEVUL3RBSHArbW8zWjMzMk5FajMwdENGVTBGL2Vz?=
 =?utf-8?B?UmFlSklPcGRpM3JsMWdOekg3UWJYcDQvdGlIT2xuSU9YcTdjMHFSMzJ6Zis2?=
 =?utf-8?B?eHlCRHF5eXFRL1NiY1NrRFI2MElObk01UmdidGtiRDhBajNVL2N4RmRGVWpH?=
 =?utf-8?B?Y1ZxaUJrUnEzL2U1TldxMVJwM1Z0UDl1NkdaNmtkd21tUTJmYmpYQytmOERO?=
 =?utf-8?B?TU5NZTdDb2NwRElCM3daZElsQmp2eW00VDNNU3BCU2UxRHFPM1hVWXFqUWpD?=
 =?utf-8?B?OGZWSDJSNjRKRkloenhsZ05XblFOUFA3WXVEWHlKZG9vU3p0emRZS2dENzV5?=
 =?utf-8?B?WGRveW9sSG0veHdLTHlLalNwbHhYbnlJSFVOWm1HNHU1SWR4eXMzSHZsT20v?=
 =?utf-8?B?ZnpnM0EyMTBHT3p1VCs5ZVFpZGdVYkVlbVNHMFY1UXQxdSsxLzAzOHpsSGs5?=
 =?utf-8?B?ajEyZFNxOXorUmkrMmJzQy9FTGFrWWthQ0pyN2JPVG0zQnZJbnc0NTlhdmIv?=
 =?utf-8?B?cWp6OGcwVEdkQnJ0dTRlVlBzWjRjQi9weE9NRi9ubUNOSFE0d2gzbEZ6bmFp?=
 =?utf-8?B?b1FxSmVhN3J2NFNhWm42T3I1R1hnWFk3ZTh1eGV2UXFHVXBJaENxZkl0alph?=
 =?utf-8?B?eFRsWmF6TnovYms3UHJLR05SM0ZQV3JHdk4yKzN4bWh3aDY3TkVlYXQxSXZO?=
 =?utf-8?B?UCswR09oQnd4REdjVmVWcStzcTRXY1VDbG1ycENiMktEWEErL1ZDRGpyeUp0?=
 =?utf-8?B?TlNvOE5wU05qTC9HTGFlenNBaTNUelptZEcwYTkrTzl4SGc4cUpFZnY0Q2tY?=
 =?utf-8?B?YkJSNWNMWHhvdFRNMFBQY2VjMVVhWG9ldkliL1o5MEVJRjI1RCs5NWthUE5E?=
 =?utf-8?B?VEo2MU1aNTFLby90S244ZXNEWWdyZkJseFRQWkthdGR1YUROa1h5ekxuTlI2?=
 =?utf-8?B?VlRHdGx6bmg3KzR0RDJNYTRrYm05TUx5ZkowOUhjRy9tZW9sb3ZBOXhEWGZP?=
 =?utf-8?B?eEc1MGc0RVVIVzJXcVhHU3h5WVZlS1pKRlkxM1R0MzVLb2E1RnJNTTNaelFX?=
 =?utf-8?B?RVBUV2VVN0g1U1BKV2lsRTNGZG5CT2ZFNHAxU2xkbnltMDJyZmxEMERHYmlr?=
 =?utf-8?B?ZEsveWFtbDNDYzBwZjY4dm1nR2NMNENKVkd5TEhEY1k5VnNSbnNJOGR3M0h0?=
 =?utf-8?B?M0xzMmtPS2VZNndKdkVLT2g5M0ZUeHZoczdWRlNGL0FqV2lzS2VzbWFrSnFW?=
 =?utf-8?Q?msbn/ZExVV5E3VJ55ewCWh3Nh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a553df-c44d-4157-1bc1-08db47768c20
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 23:24:28.8033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQSl5AgT3y9/nZtLVzAPwoTLwiknO/Z1LFh0Uh/BBG9oFdc0IFwIl3uojCiLDA1KcBoiigkBqpqv2xXNI71jfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7232
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/23 7:09 PM, Emil Tantilov wrote:
> 
> From: Phani Burra <phani.r.burra@intel.com>
> 

[...]

> +static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct idpf_adapter *adapter;
> +       int err;
> +
> +       adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
> +       if (!adapter)
> +               return -ENOMEM;
> +       adapter->pdev = pdev;

The custom more recently has been to allocate the devlink struct early 
on and build the device struct from that allocation.  You likely will 
want to follow along and play in the devlink world.

sln

