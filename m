Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECA61EC984
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgFCG3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:29:48 -0400
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:7170
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgFCG3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 02:29:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYSanO650l+HlZ5w1tt6NmAmzs99Wqdya6/mBgctTH7yKCleC5yoUvIN9pL0gdLahp8PB5LtCII+MPGLn/UX9Q5KXGwXvezafAJd0zWwHFRsuWMfaitmtv8YF9SlZur36Tu12pPsYM6qHkor3VeOTheApK0bayUvubOA02ZPFeMCjJeC+wwTHXIeR7I7ZIR70z42ha7p0HnOfjO08HTJsZ3CKSLyH9qA/oCSmlrwS7qIOok/u5zert0ZuuS993dkd3hyJaYxtMej6MmWQf3FCE9DD2D7NEOz9eZ9uEmGcaoK86yYFqzyh95hqLCcQRCeda6p063+wVUYiANdA+z2KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4m11y0sPT/n30llmbvZJSAqhHJLfVQI14kMf4RbB9Y=;
 b=hkyUrd7hO3uXJXAo9BnBl6TV47AzqZdNgLDzll5d+OtF/PGgQ2QA7LFFc0gLPS7iXpGSAUyKoRQyjwo7oeP1ap4jnqHGmU63TvAwYlYYitEBzgkZufAMYp4CxZ56qvH+pU4ohwLTza7zmhdD18mJBPwr5YjWaF1uwDaZOUUxCgrmHus1fELOxv1SWVS9GPincEhix60UgN/kNPuoI2TD664rM3250DigKLcSftH/u2hTWN1UrVbxk/0/sQmzcvQGkEi/Pzxc2e/lnDg+dG7sgGH+ERT31FapcmhBEWyVii9+kP90gPsCFZFDgwD3jwxaEmL8raREaQZsggsxX+FcpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4m11y0sPT/n30llmbvZJSAqhHJLfVQI14kMf4RbB9Y=;
 b=K8xwNwjh81luLvq5fQbE0F8+D37OrJ0fhoIDKy1R5gHMP2K/ZmGdiOpB+0ShMK0hAGOcraafVWlDnf4YoRhtoSPnvOHrFKKf3SCRuRA8RPiJbnGcFwo5Gg7V2PKT2qF2qBrqdGwkDCutgEOYo2raUVWj3Ia7A6ERIgtpeGLwGbE=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2768.eurprd05.prod.outlook.com
 (2603:10a6:800:a6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 3 Jun
 2020 06:29:42 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 06:29:42 +0000
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
 <20200529194641.243989-11-saeedm@mellanox.com>
 <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
 <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
 <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c58e2276-81a1-5d4a-b6e1-b89fe076e8ba@mellanox.com>
 <20200602112703.13166ffa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <105f697b-7af3-6eb8-1474-eb47e78d0103@mellanox.com>
Date:   Wed, 3 Jun 2020 09:29:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200602112703.13166ffa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR07CA0028.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::41) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.6.235) by AM0PR07CA0028.eurprd07.prod.outlook.com (2603:10a6:208:ac::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Wed, 3 Jun 2020 06:29:41 +0000
X-Originating-IP: [77.125.6.235]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 869c02e1-2d4b-4faf-5900-08d807877fdc
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2768568623BF761636CE15A6AE880@VI1PR0501MB2768.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzxlNqhrzIo7z/TpMVrL3HKz2rtfJR+mO4zjTqBG0SITQvkybCv1efigusvbQQ0IWEPD1WUgKOeBsSmhcn9UUOQnXyaTjQMJITNXQ+QmxmqWoP1L2iX8kYEd3BpfYjZgj6lky20+w6tk6yl5AFIibBAmSOFgTdRIu6FCaHr+df6SqiPeJz/HLe7zn0TiWmI8cy8KKfrYnmY9glZlkHD4SEfXqGxJecAp4doIVba5SWfetjpWl2NtFJM2ziIIjFAhlPrJQQnAmpCInrxRrne6MhJlk14Ls7YuYHh3dsvUr+/Hy4JEFTs/7Gj1vyN3U0Er2NhzmcEx2ryvx7s9UQzzl0tH7MN265HcF0XFLe/5kL80vxh4VCMoECQIf9prsoRS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(2616005)(8936002)(5660300002)(6666004)(86362001)(956004)(31696002)(83380400001)(8676002)(110136005)(16576012)(316002)(54906003)(4326008)(53546011)(107886003)(31686004)(36756003)(52116002)(478600001)(6486002)(66946007)(6636002)(2906002)(186003)(26005)(16526019)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +hhgvqRFr8BM23LPnks+cSaHxMsfo5AV2Wo6us/rldyhLRBs9vCDdWth6SsUyCqUke9MAoK7Rx5wbrNACis1ZoX+u9UlCirzr8WcDpQU8gZP7WesyLFMNoCMhWzrc6IBOEj5xDvSVGjlsI+jEfWk3g4gWRo1GpVB8e50GD767fxPXDQjs2qcXoc2VxHMQWzlEDzjh13NtPgq08egnRTvQbrSC/W35fFnVKyNxXGXPRzYZCSumTOcnMtE/HfcJEXouY/v4B2lIsIUfCZLLHb1VA/KeD2ekhtLXbTRt8xD1TCwUgDlc6ijJT6eOf9NnC6Q2Hx7HXAfoPoP0PeNKu/EzwEBpzQUce9wG09uYPQbplAFF/pfm8hWDAPKB9hyaBYdoCxN82UXccDp/V16pBR/xrBUfZ39JZwr6eQOOaWEfOTjoVDEYFSsUC3FaQQcWkOAm2YROwJqLGma5KZK8/HOn4cQfUyv1wRdicwNnm/rcjM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869c02e1-2d4b-4faf-5900-08d807877fdc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 06:29:42.1960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDZtBTDgLYCRljGiQInZH9C12LMKfJstAxwTQbLXN48xXbi+kcTKE+7Ij1Do2mTpESxa+ElAXenx3e7xgCXN7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2020 9:27 PM, Jakub Kicinski wrote:
> On Tue, 2 Jun 2020 07:23:53 +0300 Boris Pismenny wrote:
>> On 02/06/2020 1:12, Jakub Kicinski wrote:
>>> On Sun, 31 May 2020 15:06:28 +0300 Boris Pismenny wrote:
>>>> On 30/05/2020 0:50, Jakub Kicinski wrote:
>>>>   
>>>>> IIUC every ooo packet causes a resync request in your
>>>>> implementation - is that true?
>>>>>      
>>>> No, only header loss. We never required a resync per OOO packet. I'm
>>>> not sure why would you think that.
>>> I mean until device is back in sync every frame kicks off
>>> resync_update_sn() and tries to queue the work, right?
>>>   
>> Nope, only the first frame triggers resync_update_sn, so as to keep
>> the process efficient and avoid spamming the system with resync
>> requests. Per-flow, the device will try again to trigger
>> resync_update_sn only if it gets out of sync due to out-of-sequence
>> record headers.
> 
> It'd be good to clarify what the ooo counter counts in the
> documentation, it sounds like it counts first TLS header HW found
> after seq discontinuity is detected?
> 

Sure NP, I will add it.
It counts the number of times the device marked the tls resync bit in a 
packet's completion, this happens when hw is tracking (but not 
offloading) and found a tls magic.

> In fact calling this a ooo counter may be slightly misleading, I like
> the nfp counters much more: tx_tls_resync_req_ok and
> tx_tls_resync_req_ign.
> 

I can rename. NP.
