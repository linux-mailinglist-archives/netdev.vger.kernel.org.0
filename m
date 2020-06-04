Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5D01EE2E7
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 13:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgFDLEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 07:04:52 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:27526
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726426AbgFDLEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 07:04:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9kIx3YqFcG424K9SjJ8DVpuggEqVPUiazSS/IHVPJXeZkb5HAySj6YdGUnNUUGTpISvmZaHVf4Sse1fiQimF6fSXR+DNvI5d/tJL+rkC7Fn4bTUsC07HdGTLCxvvPbk9CitlajMj6YAdoxlFXF8HrX91wso/nZ++nREHG/jnJfckvuT5MC39XfqWDzKZII6v4Y0SzjZxRSPOCLeSUol2rPndrLXGFzK9dsOIAW/zackw2AWxXJ5sSoZzvtDjbBygZ98xomiGGKvtMDU9MI7FCdU+iqcbTd7shOMd4+X+2aq2daAUKtzbDSrluC1v7vx/yq5w8OLFHmt9cTrrURdVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6D+G9q5/R98qBfFmGi87f1/1gMtQfrtc7N+DBYaAfk=;
 b=hNlv/iJ50mMeNJHnpn7vxXC+ImFK4RAQPwqmU0dxct8FynlmZClnni0MQ23w9Khu+7EYbIlhGblQNpTFA9PDNm/LZpVyexj1Nksc9Z40rIwWckYk3Lo6b2A1uiIdt4XWRFG1dDVLwyWTL5VuAoM4a9FSt/xQQywGSkgNcAIk0RKlsSR7sBFhHxaYFqeOEZ9k7KNA8tZ210ICgVHWJFKo5j39aN1+zGXEEYcYc93IksKtvSugzhE9Y99YZlWffU1su6HbMhFD+rM+1UAC/AXnAs9rWu4/2BvNoBXENvhtMg5zl8bCkqwY860yIRWj+8U3oDFhOGoyyQ1WIPQvrhFxYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6D+G9q5/R98qBfFmGi87f1/1gMtQfrtc7N+DBYaAfk=;
 b=KEHub/s0HCXc6uD5yOWUf2v5r7LC0rJkSLICYp2FfT2hprvBdDw7s/HHhqIwZ4PYoEYYCalbj2yfkqDD5HK9xlgGO6QgrGOYggTXBDZ0SCoqNPCg/65NcNaGKjZjN48JY1QrJiBe2ZwnN2UsaxxZIUQwUMMVHuBUa+9HKMHYUx8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM7PR05MB7121.eurprd05.prod.outlook.com (2603:10a6:20b:1a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 11:04:49 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f%9]) with mapi id 15.20.3066.018; Thu, 4 Jun 2020
 11:04:49 +0000
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
To:     Jakub Kicinski <kuba@kernel.org>
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
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <2293c868-30d3-7c06-0f4a-4e06e5c51f68@mellanox.com>
Date:   Thu, 4 Jun 2020 14:04:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200602112703.13166ffa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0082.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::23) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM0PR06CA0082.eurprd06.prod.outlook.com (2603:10a6:208:fa::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Thu, 4 Jun 2020 11:04:48 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e292db57-ba65-462b-e432-08d808771956
X-MS-TrafficTypeDiagnostic: AM7PR05MB7121:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB7121371CFCB2FB6AC7B26616B0890@AM7PR05MB7121.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04244E0DC5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nWV9Q1UTK8gtieDabQVSTTTv17ZVTsJqXF+Vz2ERENvpqLwREP3vN8hJhFHeSlHtpnHNHm8WoVaq5G8hUBhlIM5f4Dclh+SNIIV09mQstjgC7OLZUWOb4+uIY34WvZZqqNbgW5wbZbqnmPnQkMZIsze9N5BWi2zt4jqxIyXSEtZ3NpNLL2AnlTAWI86LLrFEZMSMUlnVKopjQVU0gv6fe/Luo4Az6NB16NiakVp6iTjLP96qmCHUQ45rSYqAMSKb/IsViyZ/WveZfAXTf+JZMWE0G4O/twodqY/TFGoCDz7/lvktO6QwGJOz3XvIF0qUt0su1z13EEyXF9WVgwk2wPISeNdEBvcAUYj8gCUjqTXc5INWcJrbdBT7KrC32OQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(107886003)(16526019)(4326008)(8936002)(66476007)(83380400001)(31686004)(478600001)(66556008)(26005)(316002)(16576012)(8676002)(36756003)(2906002)(31696002)(54906003)(52116002)(6666004)(6916009)(186003)(66946007)(5660300002)(6486002)(53546011)(86362001)(956004)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yMu9ERCe45EAKTJZrfQWztA726+oe8S7JHvYhdyfNgq5Ud8VdZp7OnVPGQYNLJFUuRgFxIibsAWUSFWHuGzfJUjNVJfAb1oPM7SjAiYNkjHwp2vF3nNFpqD2SfnIFwdMMO8PX3cNaSNWUHAsLi0R/5rGKxKyZF87SeRap/fvpfrC7QJhde7vgVD8PVjfzdeTwOvnVTHt9VNwi3D7RuGAwVz2AQ/4YvBf2j6kEv+fMgU/M/g9eXyqs0FaRhGsmGVbxp+5tQDhmDNx9Fe0QXznSPhP6wrBIx9k+dpH6SePwNDRkBMavmusQbgJXQjrloIbKLLyFbuPQd3o4+jYhCabdEsZesuOjSoKjcf/waXxti6L3Va7O0yiS+rTaOyDh5un3mdr/gm4Zysy8Xr/zo8CpBF51uClfm++KTKXWE8UDgG1WTzARq9gHxP3yEYqEK4g3JarxlkZI9TrnJ2ynmAWWr7vM8Lh8unVeQFYJe8rB+/4yMR081GA36xAgjEqUqhn
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e292db57-ba65-462b-e432-08d808771956
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2020 11:04:49.3733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v4Jjhy9OdH9m5RA5jZmT6KZ7DoJ2fl6NtqEx2UtBZsCaKcCWLTJR7rWlEJFz5p5smOARPuhRkLLH5tQNaVM4ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/06/2020 21:27, Jakub Kicinski wrote:
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
> It'd be good to clarify what the ooo counter counts in the
> documentation, it sounds like it counts first TLS header HW found 
> after seq discontinuity is detected?
>
> In fact calling this a ooo counter may be slightly misleading, I like
> the nfp counters much more: tx_tls_resync_req_ok and
> tx_tls_resync_req_ign.

I agree. We will add it to mlx5 and document.Thanks!
