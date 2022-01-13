Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E090448D408
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiAMI4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:17 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:10080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231817AbiAMI4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXoY4oDr7RP640puvBT5CoETMgpZ86rnUnGGe99sX8OnJ5nzOypSFADRgAWs+NrmkhbKDb416WHbF6QwMtF+Aw7u3DlkTO/Hql0TFJSBiqMOmKSetqdSVxbCauXxWvLJvXHEIPBUkmqDEjGjWb01IfrgsWb7hsmZ9U4tIcSAOQqbftakmmeVd3VviKkdKzCLuoNcXNfuhjBALQ89WtxMC4989I4AXPDtYzQYRaTUNhy0RjxjkivsmxGov4E7Zh0xLCpCDI5UQPcXQ0wtzyyE8gTqbFL94HnYAL/xlzvUTXa/EftHAd93IFvNYotwz7kulatreH3js4ooF9JqvE0sHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/IqAtaKLS85I0Ect0B8jkTWemnsBq29LWk67+TZC58=;
 b=ca53F8klNyTOHgmDeu4soeV4nFI9uBn7JpzwY5gGH/8tDBcnPdlFP47GCi8yYhRrvODXWUvG5+mBg5oT4bUYJ+n8CBdGeZVvbAcRwsKi2SWGVChk/OUGZBZ8uIIa1DoABetBsZPqFEtgTanD31zpP/nxn7kHobS+2qdRtNk28iJy4awdwDgTaW8i6A/VlkyzgG5Km32/sbc/LzkHQX+M9okc0WR9EJ2ogkbQe9YBLFR2G4Qb/Zka1bgB25sMRDHYY1SgP1vUDZRxNcUXmo8ivVzNxjBAlZZBcLlJkfWAzu9BKmu8U9LmUaqhVOHllGI1WB5SNF0K6T+NLdyZda6l5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/IqAtaKLS85I0Ect0B8jkTWemnsBq29LWk67+TZC58=;
 b=ag+0+EKVM91Nzg8GaRTavfLJwbeCfJfxz2C9okFe3Gd+bfURUVmkkgc8Kv9d/DaQb+P8otqLdi4aDtbOHTJePdf9Y8M/y+P1RpYSzphxBrMa4ItoESnM81nUi/mArbW10pNAHcS/xT5WCEVdL8ucPuoWDGUPVIwWXFxZ/JU0tfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:03 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/31] staging: wfx: fix ambiguous function name
Date:   Thu, 13 Jan 2022 09:55:06 +0100
Message-Id: <20220113085524.1110708-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e4f187e-fd33-4307-aa39-08d9d6728723
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB207158E38891576F894A071193539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RwwdJbHfJESLVTges5WJkm8QaeXslStrmcLYlfOZQOX7XHZJ6nCf86ksnpP1pgMgRSiLzfMJLNE/t3D0fubrV2MmZccRG1BE+g1NgVEJN2ScQyDZHisRRx2xfynqlFhNR77ZwhRXMMPQTUmbXza8Xezc+GhoxSADpB4DLIJOgNUJW0dLwEcD8QlaMrpcJw5zFY2XwDx3r6AB4kpxk36Ff5l69G3DCGr5n+wZdjNLzhdEm4/lytKv368fH5y1bgVqOyi9JESFZ/qyrBzs8nbOoPQzlP55DxlJLX845qtBTWCW2HybkWB65dQlZIdB1fbLHIHc43q2P/wM9Sup4z6sq5paVHuaCQ3Bz5NhZ8syULWjBxljaBDpMEgyb0v/dI+/YvRj79+3CgxqvKGzXEeb78/z2U0nFPYOwdtUqx4Fwl/Gs6sNz2XtR7ZE8noNZ8m0Zh/Lr8xh6XMfuoOGuUbH+9ZslkobOOnOFewi9DO7/PfHr0oYt6ybUqIV9k59M4qOQZF9ANpHO2AiLPdvjIi4g9lj3eu23rvhzgfRUeFoo6PiFGmYCL2JdG9/fy9q8eeUnYrgDx9zq9vNenGwC0BPi9oZqW2iYeIR+IFASiPpmkEdBNXIBK/J4Wp8E2w1o4SEXYKQNTlR4kPoY0jeiD6Vzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0NkNGUwWVhPdEUwRU8wZDB1cFpnYzRUc0hLS0Nsa3BsNmhFL2t1Zy94aHJI?=
 =?utf-8?B?R0RydHdGcy9iNDRLYURvV0RNMDQza1lidEZvRVFscFZoYUd3em42c3FsbzZJ?=
 =?utf-8?B?RVcvbmcwSTJXM3hPNlpqbzVRdzBjYjZ0UlZjNGtXbHE2VmdSL0NaK1RoVVg2?=
 =?utf-8?B?RCtsaS9yWDZwandXQ1cwU1lTS1pEUGx0SkFTQVkwMHB3WVQwZlUxVW5pTFNU?=
 =?utf-8?B?VDlTOFlRZ3dqaDBjUW9oTFdKWGJWSWNSYWlueE8xZVl1T0dDSzExbVBmcFVk?=
 =?utf-8?B?NUVDYTF4YzNCdFVrYjlaVm1STS9LQ28vSjlhYVVXN1NKb1l1RjJCS1RPRkhw?=
 =?utf-8?B?U3FJSnFVeElLZkVGdFhOb1p4QkVnWGRJaDRPOWcybC9EU0twWTQ4OU9CUTRT?=
 =?utf-8?B?ZjFuM29NZHIxY0FkNTBCNzFRc1ZzY1NqZXlhb21sbDdoM0pNdlNGdXN4cjBD?=
 =?utf-8?B?VWhhaGIvclZvY2Z6R0RtUE9NSFlOMVFGRFVZVXBDMkQwRnBlR2dyaW5OTTJn?=
 =?utf-8?B?dXhVVW5zS04wYmZFK01IcG4ycU5ocHNreTJaQzByRUNCZDdza2N0VytGcUNl?=
 =?utf-8?B?dGpaYk10b1dhVlc1RkFHa1pWM1VNMmlXRk42UjQ0UVBZb29qaUo3c052Z09Z?=
 =?utf-8?B?RWpVMVZ0bVJuNWYxbnp2Q1h2SWJuSDVrL3RXWUQwZlFlSWU2WFZrVW9ObHdN?=
 =?utf-8?B?SlRZQUUvQjQyd3lmUjV5emtpSU9Oa0RCbHdmMzhoUk1rMUEyZVdQWlQ0MFgw?=
 =?utf-8?B?YzB5UmxPMlRRMFFxVmVIU2xoeXhzQjM1M1dRbkNHZ0xSempURUFEdmJwZUdB?=
 =?utf-8?B?TGtRdW9KbzFMNVJGNU5qbXcvYldxRGQ2dEdBUUZPb256TDhkTi96RVZwSEFo?=
 =?utf-8?B?TkdFcFJsbjdSbHFRTGJoZnhraEVXVHlmWnRxVnZDUHBjaHVXVW0reitsWWl3?=
 =?utf-8?B?Y053YWZFQWhKZnZQYVQ0N3l1b0xrS0djN3p1SXhhM3ZFVHZodVllUXpIMXIz?=
 =?utf-8?B?TkVobDRZQjNseUxYNnZXTVl5L1YwZmtJMTI1TnZWbkdxOEdLaWcvYWhuRTVo?=
 =?utf-8?B?NU54cWFURlV1ejJzUnJlV2U0R3FKYjdaVGo2ZlpDejZ6TTVvKzRjMy9jQjhQ?=
 =?utf-8?B?Mkt4dFYzcWdjVDF6UEhLSUVmTDZ0MVNnRFJHWFN5UEphQkErTTRTZUYzcHhy?=
 =?utf-8?B?THRjQm05VTg4bUtFZmlKeE92aU9GeVkzT0YwbmZjVHNkYUlicWhhb0doY3NK?=
 =?utf-8?B?TlV6SzR0ckFPV3FzN0ljQk1IcDRsVjl1dk9hZEk5bVUrcTNtbk55NlpRQXp5?=
 =?utf-8?B?T0R3SzlFUVB4Z0VGdm5aa0dWWDVSalplS0RlUWQ0QStxSy9PMnprdWkxZWsv?=
 =?utf-8?B?TkZpb0F2ek0ydWdSYzhRL3lQS2xTZ0F1NkZ3SkVSWmNQQndDNHMzSDk5VW5V?=
 =?utf-8?B?aG84YTF0aXNGWUtNUFdRNmhObVpkZXR0cjhoTElhZVhKWllnVUxuUG81cGhy?=
 =?utf-8?B?MWRLNUxOeEYzekgyZjh1Q1llNkFHRkRUN0QrMHVobysyNUt0T1lmNGpPanJx?=
 =?utf-8?B?VkJMOFhPZWJSUk8yS1UvYVpxMkNjZ084Ry9nOGV2a0ZwZGVZS3BmU0JOUUg0?=
 =?utf-8?B?ZGVzbFlobXhwZEkwcGRiaVM3aWg3QktnaDJMR3Vjdk9sSGRTRTBDczIxbDdi?=
 =?utf-8?B?NTFtd3dZeTREcFFSYVM5RkNBMkQvWWpvbU1ERHpWWUJXeHZxaWpYUldBd0ZJ?=
 =?utf-8?B?ZHFQV0Fld0o1MGl5aUdvRGJFRXIzdjlLRTZCcFgwRGx3TXpucG9xemNqbzNO?=
 =?utf-8?B?SUdnZW9EdFhNSzJpMEdNMjFWT3l1cisrUmNaZE9YRldlSitlc0xpOFhaRnEy?=
 =?utf-8?B?bFNuTEc2cGRmVWw4MTdPT0FJa0VUaDBOVHZlY0NDb1RRMnVmTkhIR3dULzJU?=
 =?utf-8?B?OHVubUlVTjFFc3ViNWZGbFcyaFVnL0ZKS1N5VkNpNE1rY2RxSDFmc1RXWklp?=
 =?utf-8?B?RjE3cTIycFo4THNadkh3bTNOWWJNWmMzKy91emJ6UnIxOHpMYkZycXBZV3NR?=
 =?utf-8?B?dnU5Nnk0ZDZCNEJOZmdTdW1YeUFTNjlJK0lSZkV2enpYQ3RPcjlMSXp1clBD?=
 =?utf-8?B?UmFGbk0rbk4weEFlakM5WXZiL2NvN2svZEREZWF3Njk1V0pnRmtySWN4UVV5?=
 =?utf-8?B?R0pMa0xJdUV5M2pUZC9NZUU2K3F5cHBQQm4yY2lOTHV4b3JRaVdqU1pxRGd0?=
 =?utf-8?Q?MDm7tGKW4cFE09dxZuZK6JhyzLC9Xb15RK5EDPwyPQ=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4f187e-fd33-4307-aa39-08d9d6728723
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:03.3856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdQNe+0htqatolmwGS77BWQNn1x6S3aJS2nUHx6kZ21UFMpvfhFOEhciJ4hcqwaNSPhT76TxGN/KeIg4JS2mkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHByZWZpeCAnaWVlZTgwMjExJyBpcyByZXNlcnZlZCBmb3IgbWFjODAyMTEuIEl0IHNob3VsZCBu
b3QgYmVlbgp1c2VkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwg
NCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggNTQ5MjM3NWZlODBhLi45ZmY5Y2NhNWViNjYgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jCkBAIC0yMDcsNyArMjA3LDcgQEAgdm9pZCB3ZnhfdHhfcG9saWN5X2lu
aXQoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAKIC8qIFR4IGltcGxlbWVudGF0aW9uICovCiAKLXN0
YXRpYyBib29sIGllZWU4MDIxMV9pc19hY3Rpb25fYmFjayhzdHJ1Y3QgaWVlZTgwMjExX2hkciAq
aGRyKQorc3RhdGljIGJvb2wgd2Z4X2lzX2FjdGlvbl9iYWNrKHN0cnVjdCBpZWVlODAyMTFfaGRy
ICpoZHIpCiB7CiAJc3RydWN0IGllZWU4MDIxMV9tZ210ICptZ210ID0gKHN0cnVjdCBpZWVlODAy
MTFfbWdtdCAqKWhkcjsKIApAQCAtNDIwLDcgKzQyMCw3IEBAIHZvaWQgd2Z4X3R4KHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3R4X2NvbnRyb2wgKmNvbnRyb2wsCiAJ
LyogQmVjYXVzZSBvZiBUWF9BTVBEVV9TRVRVUF9JTl9IVywgbWFjODAyMTEgZG9lcyBub3QgdHJ5
IHRvIHNlbmQgYW55CiAJICogQmxvY2tBY2sgc2Vzc2lvbiBtYW5hZ2VtZW50IGZyYW1lLiBUaGUg
Y2hlY2sgYmVsb3cgZXhpc3QganVzdCBpbiBjYXNlLgogCSAqLwotCWlmIChpZWVlODAyMTFfaXNf
YWN0aW9uX2JhY2soaGRyKSkgeworCWlmICh3ZnhfaXNfYWN0aW9uX2JhY2soaGRyKSkgewogCQlk
ZXZfaW5mbyh3ZGV2LT5kZXYsICJkcm9wIEJBIGFjdGlvblxuIik7CiAJCWdvdG8gZHJvcDsKIAl9
Ci0tIAoyLjM0LjEKCg==
