Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA44F46AD2C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353463AbhLFWyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:54:06 -0500
Received: from mail-eopbgr80130.outbound.protection.outlook.com ([40.107.8.130]:8513
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352960AbhLFWyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 17:54:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TescxQIrxQdeT5oCLJgROCyNb/RA57rbzhWJlQZfNhRj1wkQ46bvfHMcsdGc8VucCIZ7X8KjUK9NegqB+algZwqkuA11CQ5FRUqmIKbTAB/ky2si7xS6iRhwPmvhxNeJrRezcyUavRG5jT9FKCk892AU0YJ182GLgdpUitYAJum7pNMT1+tffPQZhYvKmJ8XsxRT76jtGCgS3u9tsjyfa36w1fVHqSOgEfPG9OTB0Ow3HAuE+KeZD44oTVszBEvEpkusfx4tF5VeHxYgf9/4OtM7erypuCZbvPKtXDa/WyBh+k941+lTuMAdOCBY7FI3EhKL9QkqL/6MG5IDG4JHug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WzFD7gwPXgB4REhH1orEKEAheTf01h8tnhwnDV7x/tA=;
 b=AdE3g9k3x4hRi0NT218O+Fjanggmx2Jub6QsDtPgZDIXxSfiNPedKLBO2UbRWMnJyy9NOtOEuWriz9tKX/KYP3x6gExgzlNWrxdPnCkii/gxy8W4pxO7VZXDaP9MhnkFC5WezwgsMLdonDZxkvEheQYlUSdPxNl4SlS3lTHUXSyBWzMRg4wzEDP+gzdh4XTgEafnEIEsnV0wuvhOmIYkjd1XPReuuXQo5BMoRSgyItL1Co61KWJ57rVQyt2r0ozsi7Y6BAIUXDW5d1IbPmBZEBlcW0oGZ87wPp9nkRjkTrWi0r99TpKJ+yO/dQQRE6eU40sKNUbvs5kcJo4b/bu+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WzFD7gwPXgB4REhH1orEKEAheTf01h8tnhwnDV7x/tA=;
 b=FOg10AgY93LQFmGBoukZyivtQzr29gAW5NNgC23KZ6RiAhmk+QmGS1hOryq3Yh1vhuh/c3cC09wYKXEYi1Myrk8iX5o1ReW4OIG40jwqEJAtRdaOZMTBa8MrS5HKQ6umA4D6m8OkuvYeemQaemVL2kv6IqqJRjTLiXFMkptealYkZcsBCHOiIS4Jhs5m0BnlhTmdQJDw3nVQaqNV5SHqbKkuHHPwTmHGI/tvJylenBX0Jt9+kCKeeY14Lq0VyHI0EFcoKS9Xqy6WeVigA74J7NdLEr9ENKIJZI8Xd8oCFJo5SjqM7V8Tz+TJGBkrPRRBntQNr3/fFg252P6NwcvuSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DB9PR06MB7610.eurprd06.prod.outlook.com (2603:10a6:10:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Mon, 6 Dec
 2021 22:50:33 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 22:50:33 +0000
Message-ID: <243d82b4-a0c8-6687-f746-399388344cb9@eho.link>
Date:   Mon, 6 Dec 2021 23:50:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 net 1/1] net: mvpp2: fix XDP rx queues registering
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Louis Amas <louis.amas@eho.link>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211206172220.602024-1-louis.amas@eho.link>
 <20211206125513.5e835155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cfd7a6c3-dee9-e0ba-e332-46dc656ba531@eho.link>
 <Ya6PYeb4+Je+wXfD@shell.armlinux.org.uk>
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
In-Reply-To: <Ya6PYeb4+Je+wXfD@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0131.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::23) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from [IPV6:2a01:cb1c:80ae:d100:3374:b07f:907b:f9fa] (2a01:cb1c:80ae:d100:3374:b07f:907b:f9fa) by MR2P264CA0131.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:30::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Mon, 6 Dec 2021 22:50:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00850af5-92aa-497b-d137-08d9b90acf9b
X-MS-TrafficTypeDiagnostic: DB9PR06MB7610:EE_
X-Microsoft-Antispam-PRVS: <DB9PR06MB76103FB29C2D5EEA4598BE95FA6D9@DB9PR06MB7610.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUN8dWHsxv7eIZuJKiS3+XEGWjRhZdcyyPTulGVdti3AYFnqB6HP26xBHmX2c5A5k9xzE3MBouPf2nIcF2F1T8OyNQr8DFpCyYFYAjBqr4vx3MpzrjKwtJEU92TfiuLkthf8Eo4+kMqhwefrWhu5USMD/Fddw71cYH9lLfCccCtAmUJMjyQObmeYhmsrncIr4mQCUH6/8YHgBW7uzcxBciBGATpG+xJr1wgIEex+tka0dkVs9vn/F5lVWTZxk7iL51s+UGYcYB1IFTMUIawOte+wEr+fYeEZWo956gXTHiiaMUoTV5b3ZW0nzdoI4heQ0PZbFqDSzwP3BAhrbTnr6YPxRdZjeqHU+L4y3Nh+NNxfI7eEZabZY2kP5qNxopo+haByScfQi42ZgIjopKRagl3jZvDARLKITFERShj1ag99lvWqxMyxrFZrI9TUBCdtqCmCA6u2Z6RaP6dBCuekntg5oVLlD07p6hIGtu8YQW+Gbnt9EvUz+IwshT0RF17r+lEHqb/ifviBbvGSbnAx8i+1lD1ONP6Nbd9D6NzDsUdb75tU6jH/R75vztiTfl5hnawT3lLMapf6wPcoKPdn2HJ1QtgjqlIIr8ih6Hfj3IjLZ7CJNE+KSEAFwiERfss5wSL6OE6c7mbJWaqX1ZBH02EvTvoiUbXNHOUW8n0emak/dRTsEdjhdCVo05Z8bAx1weoHgraGwshPqRWjQyIsHml3hAY06piDmVlqpRlEH2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(376002)(346002)(396003)(366004)(136003)(86362001)(31696002)(7416002)(508600001)(54906003)(66946007)(2906002)(316002)(6486002)(31686004)(4744005)(8676002)(8936002)(38100700002)(45080400002)(52116002)(2616005)(6916009)(5660300002)(186003)(4326008)(66556008)(66476007)(53546011)(36756003)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yjc2cFVQMzlpOVZ3YTRSOGFNMmxhZU9qbjNZTHgybXZRQTNMOW9DOEVYd2NP?=
 =?utf-8?B?cVdjVWJWRUwrdnR4Tkl5T0liQ1pwNXkzS1hMZnNPU2pFL3VFR0dWbEFja2U3?=
 =?utf-8?B?RUNVdUhNbXJQR1dScXpQYmd0OWlVV0t0dGdGcDkrZWdPVHI2aGZyY0YrZEtE?=
 =?utf-8?B?ZkxnNnplZGtWT1FmUVJUaHpRYmlHMkQ3cWpyTnhFVStxTXBmN2htbUtJRi81?=
 =?utf-8?B?RDVHUVFCYThpQlpmSk9vb2llQjVycW83bDdneHhNUE05UTNWQTJKMmpNbGs2?=
 =?utf-8?B?UUw0TGl5RXVrVnpWUnVuNHNpQmxydGUzNFhsRkRUeUVqcFI4RFpPclB2VEpr?=
 =?utf-8?B?U0d3K2JxMjRMU0hQRlJIZjRqTlFzcGtmSkdLRWd3NW80SXppM1ZoN3h0dk5m?=
 =?utf-8?B?bExBYkZldkVibklxU0JEWWg3cktqQVloOGlOV2M3c0VZdjZsOVpubmJpVHVB?=
 =?utf-8?B?dUM0UUVNZ1NKUTZ4ajNKS05LOHU0Q3JzaGQ0aHlUZFgveW9xT21UZkErTU56?=
 =?utf-8?B?WnFRemh0ME5DcTRsd29vT1lGQmRxLzlGSVRpWXdGRzhNai8rdWlVV2MvOFdF?=
 =?utf-8?B?aGQ4emJtZHBOemhBVWpRWUZoc3Z5THcrd3dmTFRFNzFBK0toY3Q3VjBzWjJQ?=
 =?utf-8?B?Sk1RSVlZWkkrY1pCNVFqMW9VTldXbVQyaXBxaGd5WmNLYk1OakxJNGh1aytM?=
 =?utf-8?B?cXZSM2xEZC9OQW5uaDhTb0NoRjNXdE9NQU5aVVN1RGtta2UwMENKZ3pVTW5s?=
 =?utf-8?B?RDExQ3NmdjhERGVLM1FvalNuWFQxQ2FTdVJjWFFsZ1hMSzFkMDVqb0dvVURq?=
 =?utf-8?B?ZDlLZVV5OE5HVEVZbnpnVTlDTkVreWd4WkFZV3UrK2t0dXVEbStyQklhc240?=
 =?utf-8?B?ekxKdktyMVNGQWEwcE91TE8rZHI5dGVKSWtVVTgvRjNuUHNodFJEL0RyRmth?=
 =?utf-8?B?MGtibzU1V3hPa0lST2kxOU0rNDZ6V1BhdERWZ3FlT1ZOZG5xTkhvQVlWT1Yv?=
 =?utf-8?B?OWxmaXlhSGJiSDVIK3dXTlVHQkt5b2dSRGtiR1Jzc3JmSE1vMkNNYUdXcFAz?=
 =?utf-8?B?cTZPblY3RlZlNXRxbUFXVXRKdGtGVmJoaEVXeEprMVRsKzMrMjc5Z2tYRGxi?=
 =?utf-8?B?ekNSUVEzNk1QV1dDL21rWFlqMXB3aDE0MTkxaEsrTTFINlVTTXpndFR6NCto?=
 =?utf-8?B?Ris1czdZVTJVQkZEWTFRWHdLZ21kQTJiRU5DeXNKYkh4aGVDdVBXL3Q5OG5u?=
 =?utf-8?B?a3QvU0NGNldtMXZzS3dUQkJDdXViV1BSN3U4NDBjbXJWaTMrdTlzNTFoTHpL?=
 =?utf-8?B?cnZRY296cWVFem9MSlk2bGI1NER2R3Q0amdYcGgwSytrVFFhbnQzLzZLRjdO?=
 =?utf-8?B?VXZxTmV6aFRJTWRKVVRGWEc2S1VNRVJuM2czUnNuenQwbXZaRGUxUkVnaCs4?=
 =?utf-8?B?MWp1Z21xdndDUXUzbE1uMGFIYms2TkV5YjA4Nm5mQ3RaOGNGaWo0THlnWUg1?=
 =?utf-8?B?bS9VNm5lOXNSQTNrZ0ZiVGhEamVwdVdwU0YwRk55MlhKUG1lNHhTVm1wSzhN?=
 =?utf-8?B?TnFZUnlPTlcyQXNpdG5CTjZ5RkYyY0s2enp5eTR2VnViQy9PN2Z6STd3U2M1?=
 =?utf-8?B?Q2RpdkZ1ekk0Tm40QnBOeERUZTdOWnFpT0lrSVpDR1NORjB1YWhUUjI1a2NI?=
 =?utf-8?B?dkhCTWtmR1dXRk12cEtXeUtGOWtqMDN6eDZjUkk5T1pVWWFDMWR0QjJ4TFhm?=
 =?utf-8?B?UEcyaWVXeGdrMDVGZ2hwM0NvbTdDOW4yL0NVNENmVzVUeUU4cW1WMVdtcVNX?=
 =?utf-8?B?VGp0SStPVUpQZkxWR2RjYld4aE8xbDg0VHpXdUN0aFpFdjBJakQ4akdrQk1o?=
 =?utf-8?B?YUtjQ0VzN2JCSUN3aGFHWllDR1IvelZmWHlkTjIyaFBXZ3lRUTl3Vm8rclMz?=
 =?utf-8?B?OW1zTGM2bUpTb0dDY2VRTW9mZGltUzJEWkFmSkpvMU1haGRyNi9ldUljZ096?=
 =?utf-8?B?RS90RVEzOTk0ZmNZbHdxc3NSVHRCVlF3L0hBek9KZVJmZmNUeG02RThDZE8w?=
 =?utf-8?B?U0xHek9aZG5TZnRFeFdORmRoWndiWXdYZXV4VHVHYWU3ZHpVZ3ZIMGlqN0lp?=
 =?utf-8?B?L0pKV0ZtQ2w3SWZ6ZEF2L3RBbEc3OGhQc3dOcXcxUkp6ckpLL2FRcDR4eEdB?=
 =?utf-8?B?UW5GM0VUWnowb1lHZldFeWhzVkJqcUZ6RTlVR3VYS1IzcmFRU3pERkdicWdM?=
 =?utf-8?B?K3RkaS94eTRlaGszNUpZZG0wdFU4dUNlRWVOTWlzMGFnRHBKRmljQUh0Rlha?=
 =?utf-8?B?NXpwNWFORncrWTRFMWpQeU42ZW1PVE5oWEJUaGJBMGpLRjlUcHNTaGxHQThM?=
 =?utf-8?Q?Mho5Txr2+EBKdDzQ=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 00850af5-92aa-497b-d137-08d9b90acf9b
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 22:50:33.5155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCtNpRnY6HFlorVbk/EeQ4qg6Z/BA5BEq6IavrnR1JIyJem4eF5lQ0axWzc5xJwt27h3FgpW+/hFF8J0DLHQn3Ud7GxYI6QJa+F0K4LjqvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB7610
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2021 23:32, Russell King (Oracle) wrote:
> 
> The reason it doesn't apply is because something is butchering the
> whitespace. Whatever it is, it thinks it knows better than you do,
> and is converting the tabs in the patch to a series of space
> characters. Your email also appears to be using quoted-printable
> encoding.
> 
> It looks like you're using git-send-email - and that should be fine.
> It also looks like you're sending through a MS Exchange server...
> My suspicion would be that the MS Exchange server is re-encoding
> to quoted-printable and is butchering the white space, but that's
> just a guess. I've no idea what you can do about that.

Oh. That. I would assume you're right, given that we use git-send-email. 
And that our mail provider is indeed an MS service (smtp.office365.com).

We'll try to figure a way to correctly send the mail tomorrow.

Sorry for the noise, and thanks to everybody for your continuous help.

Best regards,

-- Emmanuel Deloget

