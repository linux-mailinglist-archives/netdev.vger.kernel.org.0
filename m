Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17153171BB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhBJUxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:53:53 -0500
Received: from mail-vi1eur05on2126.outbound.protection.outlook.com ([40.107.21.126]:9696
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232204AbhBJUxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 15:53:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLn494ZN5uRFZ1GFyg81T6vnEuUwX6XHrEhlTR22oB//lshug5+HEzMXX8m+DSwjK+lDRU02O/zERwErC8Xax+Jnkw+4XJIeiBZt9kVKyGURCMRzQrKf7Qj5yL+OrlBrZADRqofxAoDqtl0zYzAkXuVCEI4Uoo4/IcDSDNaZmfOHLsxo6X/WU6ZiUpejXskNK6mGo7ZenUWmP3PtKGMtpwObXVxDBvW2Ch7qAk6GoEikV3gE6MgSr2QZTsV0YmBDwmAfb1YKnp6yGt6nYu8DJSMOdun5rT/ykFZa5DRl4u+DY9uubkXZ7Of0Ug30JEmpjA2J5aeBrnQaAaFMfUymLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zBSJnjBAgx79ocH1wk7uyE4jS8j+8u+tAFo0UwSXSc=;
 b=gxMLyn2araa3ud1zfaRcuwVuap+eYJKaFu/Va5p7UXVBnHVAeedNRmKMoGX3InTb/SFGBGF6h+uLQUbkqqj+tQIdYpOF5/eP1R8Q0maXFojBKzLiSSzdFCfz4wXUxHjjcNsiZB5JyDqQ41E6hdfRQb/DilpxR3MbnzT0lw7U3vt1DeqUQVxac9lKPhOUQVwpr7Ka4c8DDADC0Wcv/sVAbgVrIGtLgUQ5Mt17fig4+zH62s2Al1mGrj1PvltLp/CQe4rpMJ1N3IbgE2VR44AMKH/DCfb0AFJEwhgZshYZw78QYfLyvwaCnwvinMKLj0f9hxfp17sllbHqlJK7ZveAjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zBSJnjBAgx79ocH1wk7uyE4jS8j+8u+tAFo0UwSXSc=;
 b=lcNvCBrCk7p9HrgyJaxxdYfrl9n9miIcyvcwq85S3yEpNA36X6DWcT0lUha1YqEdgccdr8HzFJsmmjdg2xXnwxwrSIV7xZDl8qS20NMEMXhPuTM/i4JkW8JJfUDdvWdDxZBhLewiENqlDI1pAXPzx7h4/JnwwMsY4izW2m+RB7Q=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0491.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::30) by
 HE1P190MB0394.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.19; Wed, 10 Feb 2021 20:52:59 +0000
Received: from HE1P190MB0491.EURP190.PROD.OUTLOOK.COM
 ([fe80::cde0:1a8a:f3d0:accf]) by HE1P190MB0491.EURP190.PROD.OUTLOOK.COM
 ([fe80::cde0:1a8a:f3d0:accf%3]) with mapi id 15.20.3846.025; Wed, 10 Feb 2021
 20:52:59 +0000
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-6-vadym.kochan@plvision.eu>
 <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9b249oq.fsf@waldekranz.com>
 <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YCKVAtu2Y8DAInI+@lunn.ch>
 <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taras Chornyi <taras.chornyi@plvision.eu>
Message-ID: <401543c2-63c5-a45b-94f6-28da54aa43d5@plvision.eu>
Date:   Wed, 10 Feb 2021 22:52:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [193.93.219.25]
X-ClientProxiedBy: AM6P194CA0020.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::33) To HE1P190MB0491.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:5b::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.122] (193.93.219.25) by AM6P194CA0020.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 20:52:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0acdf83d-6671-4b27-9bfa-08d8ce05d939
X-MS-TrafficTypeDiagnostic: HE1P190MB0394:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB039404E2EFF26FDDF3D7831CEF8D9@HE1P190MB0394.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XBd6QLAtRc+zD+Ihl1NvstK6DPFrHhoF0Kbe+k8jySZ4hFnpsjPUi8AommEv2kZxd4oz3ML7VMVaZZayWc6JwTH8nWk7luK4FNg6Bj5WqNPdQhq53jEnmn6JdzPfRtEtEw/qPAtSbt1Ori86rv0sG+7+z1kcJgpkr45Hhx2BTrTnn1nc77+vFy6C6s3Gz17RFyBA110ZlDUnS6uW0JU3ln4ztFK70YgD9wD1IANkx6zPTnAkhFPyWGAM2X2DpAEvncAdK4SSN1uiYVKazf9uO66fMv15+fPcka5zSjQuGFYbT3q1hx837162wEXoYCmnUh9pNBHpAqRFnbxvYUxc/jlmGmgA628uW7ze2ug8OzP/LtMifmHB64CcnOd0Nrn4gdgfiwtStl0bwv7bmZamUvlcgwNURO0s+41dWj0knCD/wbXyKb8QZ1IC7zU0IWJF6qXOx+SOlklqqQkbRxngGnar6e3hJ3zR8FCP8zS4SxEizljUlQG31D+1m1XNqeXeEwwEao6IlCZduJLtdkG14vSyrvwsYumq7OFfrloZpGhL1B6qkbsp5XBILdvyNNl+rS5+1Mj/lymtKWg27kf0OAqp3vwcM9PmiBHqgEgKRho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0491.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(4326008)(5660300002)(4744005)(2616005)(316002)(16526019)(53546011)(44832011)(66476007)(956004)(26005)(66946007)(8676002)(54906003)(2906002)(6486002)(36756003)(6666004)(31686004)(66556008)(16576012)(110136005)(86362001)(478600001)(186003)(31696002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TGF1NjdSanlzT0R1QWhTUUY0Z2VIQUJVakxHSG9rSHlhTGpGMXBwdTF2Sm9u?=
 =?utf-8?B?MG1pU01zSHlPNTZ3N1EwblBOTTZ5Y0srQ2pOSVp1V3pUQ2hvL3Z0NndwWXds?=
 =?utf-8?B?aERuR0VyNVJMcUtaUFZQWEg5dk5TMktpUWIzT0FqMkd4ZnJ1VWVuTjZPVkxZ?=
 =?utf-8?B?VC9lVStuMzNDUHRQeHZoR1lMSktJcmMwWWp2ZUZESTFudStlUlNSNDJTUzAy?=
 =?utf-8?B?R0p6bVJld2krWE1QK0h1SGg0dWROMUE3TFFhaUdXbkZDL1BNZ2xDbmNtN1pQ?=
 =?utf-8?B?ZXVRUmp3Q2FCRGwzbjhMeGtVdUxOWis5ZGlXeElTTU5iQ3Yvak93Yk12ZFIx?=
 =?utf-8?B?bWF1M2E2UXJwZ0JWVjJJYXVrK2p1Uldueko5WjNqNU5Mc0s1dVliL01FcU1p?=
 =?utf-8?B?R3Q3Z1piT2FaajRSUDQ3akc1eUI2TG44Qko0L1pUNHNuNzRPb0ZqNEh3T0to?=
 =?utf-8?B?U3lNYTNHMzUrQU5FT2Z2ejFnSlErb0VLb2NyZHBVWXhWNlVscG10a2FFTWsr?=
 =?utf-8?B?aWV3ZzgyRVUzcFJqeTBMNTU3SFJWbTVJRG1XbmF5Q0czdndrcmhma0FSQlhP?=
 =?utf-8?B?UHRTUG5mcGlTZzBLUVhOdnU1QzN2MFFjRkFaQnU1OGMrbU55SEdvQkZMOW1p?=
 =?utf-8?B?OU9EcTRkWWxaVU9lems0Ri9sR00wWUhBWGdybzdQVHJpdXlraGRSL1BBTUN1?=
 =?utf-8?B?ZVM1UWxUT2MvVFpuYjVBeFN0OXBab1FVUlBsbERWZEc3UkwycjFmK2J4ejlU?=
 =?utf-8?B?NGZvbU4yeVVFbWluZWdhL05oSmF1R2NDdk1xUUQyWVMvYzU4Rm9HdHJQcUg5?=
 =?utf-8?B?ZFRLcjNGRjhYR25XT0MrYzNlaElrQUY5aGtHTGpxSHpPUkVCeDM5YnVlTEtB?=
 =?utf-8?B?Qkl0bERRNFNCdmNsU0JpSHVLUFZuYU9kV2JFNGhwM2YyTUZzV1ZkMk5BdzhI?=
 =?utf-8?B?eGRHS2sra09TeEo2R1p1aGV4UnVoTERMbmZBZjF0WGsrckM0c2FSZ0s1TWZh?=
 =?utf-8?B?Z3lXZHVOUDlhYmFWS3BXNjBlaGxIRTVGN1h5anVZSWxBK2dwTUMrUjRlL0xx?=
 =?utf-8?B?eExBbmtheFIxZ1hCbDA2SmtOMk1mcTl1UmlxL3gvdkY4QWNEVFRwVVBsS3c3?=
 =?utf-8?B?d2hVYVVIOTBsY05pTjZDMzhtNjRpU0orUFM3SFdyNWpNZnAxVHlWWHFMRWFT?=
 =?utf-8?B?WWx1L0kwNzB6ei92eUxKb0FoYjN0QXF4UjhjYzQ4S2ozaTdDeW5mNFFQVlJF?=
 =?utf-8?B?R0JFazhpVE9DT2duUStveFVMd29HWTNRZU9iaTFmcFdsZ0lLTHhiMHNpaUZo?=
 =?utf-8?B?OHEvRzExOStkMDQ0Z0MvNjFHY3Q1Y2R6Zy9YR1ZmT3I1TGZkVU5XalVjZEtr?=
 =?utf-8?B?dVp3cTcyMGhva2MwWGk5cmpHT0c3WHBvSGdqLzlpZTExekFJdGQwT2NzWU5T?=
 =?utf-8?B?T3BhdHhSSmpsajV1YmswaGhYMTdua3hyZlZKRnU0TXhZOExtYnE5YlBUcDJK?=
 =?utf-8?B?Z2oyMW5LemRjbGlYZFh0VWN5QSs1Y01OeGhQTmtLR0UzUTAxWGcxTDYzdCt6?=
 =?utf-8?B?cGpJWEF1eXFsTGNBYmRZb0I3NEU2K2JPeGF4b2U3bmI3a0hMQWlldCs0NUxr?=
 =?utf-8?B?SEpvUEpYZGdLY2pXSVJrU2xtVzZxK212ZHI1RUZndkxKNWd0Yy9qSlhCQ1RZ?=
 =?utf-8?B?ZGt1OFgwV0VzY2g0aTdPdGZlYjY5cXVDdkVRUGo1VlJHWTNjNldNZ1BMdTVj?=
 =?utf-8?Q?1dNu33I5qvGmITYLdRXLtArISHVgdVIORuFlNNb?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acdf83d-6671-4b27-9bfa-08d8ce05d939
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0491.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 20:52:58.9403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yj9kPhnDi6ba9IU5SW0jGmux/reBTs2xIEUsGqcapSQkM8JXZsv1dKe6wupowpKEZmSqneCh6qmBA2k0N+Dm/uFymyKkwN+9Acb4L1wT3NU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.02.2021 19:35, Jakub Kicinski wrote:

> 
> Sounds like we have 3 people who don't like FW-heavy designs dominating
> the kernel - this conversation can only go one way. 
> 
> Marvell, Plvision anything to share? AFAIU the values of Linux kernel
> are open source, healthy community, empowering users. With the SDK on
> the embedded CPU your driver does not seem to tick any of these boxes.
> 

I agree that FW-less solution has many advantages that enable the community
to engage in its development actively. We have continuance discussions with
Marvell and as Mickey stated, more PP modules will be managed from in-kernel 
code and not from FW allowing kernel developers to extend/improve it.
