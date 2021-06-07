Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648B239E44B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhFGQrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:47:08 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:34858 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230291AbhFGQrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 12:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623084314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zyBokqJk6WaR+kQSjjUJxrd++NIcmMXlvo2EuVABQTM=;
        b=ObiRViiaPvmY0b56NL3f+n/eg11KVFsyEoVxx6yiNyiR372lbZ74kVG4JIpUco0svWnKeu
        us28NGOJAmgjLp811iOPGVH4YWY/toPcB7lLSxAm8ZhHcKPsdQI28zwm8npzGqv5L6TUbn
        C5NvikinFHPXgQ1VzyPZW5L5uA3LIDQ=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2051.outbound.protection.outlook.com [104.47.2.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-1-Qi6S_JH6OWepdADCSuN3zg-1;
 Mon, 07 Jun 2021 18:45:13 +0200
X-MC-Unique: Qi6S_JH6OWepdADCSuN3zg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjPc93t2cma8PK0mBiNJ9dCOAYuRB2/RCkpHKbFhMIv2MxIcT0ynYwNXt5d6cAn9V7ChQYKC/y2PcM4K6k1mXmSXJq0Q0fjmQmGvayxBVM2BjVLYzBVOjBu2kodfI82qC6QBgJOgVwJYcW0yG6ssLAmtYnFBixchJpar7A3zsnCANO9v8wW94FbiOrQ1X1Get0u5PoZeo9DgB66+Mg4aXHopGZS7ala5yBr9c3EKwyd/Xt+KKgCYS1dc7RnoGs33NlIdlgfU9XFrr29Bk467WAnrbJoG/X20/zT8pS4yLXNGZuDvxzivgRmgnHMyUdCBzbDAgEvI1bsZnqjWfALBaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyBokqJk6WaR+kQSjjUJxrd++NIcmMXlvo2EuVABQTM=;
 b=NeWVtB0FfHUB33IhjiEpx2rO2gKU9ew6ldjqFWDlydmWz5CwDYiCnZ9Kh4GJYDyy5zD/mVTlcTRkn/68g43qutj4Ez1s1n4A03rH8ohOtzLKm5ot8sEixHK4RXsiuNOCWqUhtfntGPzuXP6Y8LoNLDCF9Ph7C+BWwpYgvk96P1dFwE8NyGMLuRORl3FKDs3fEDSUWAl+NpK8P4YAjL84dNvwcY9+AztJoBYJSmY3dK2Rcl99z+2G3eX5BUhud2AvCToR2t0cvuxoVA13j5BRkEff7OIJgn1G/55gfMXuHPFoaHh1wyfggmx1PZo8m6NDUc+wZqBhXrioUpRkfd3AGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7453.eurprd04.prod.outlook.com (2603:10a6:800:1b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 16:45:10 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4173.037; Mon, 7 Jun 2021
 16:45:10 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Alexander Ahring Oder Aring <aahringo@redhat.com>,
        netdev@vger.kernel.org
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: quic in-kernel implementation?
In-Reply-To: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
Date:   Mon, 07 Jun 2021 18:45:09 +0200
Message-ID: <87pmwxsjxm.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:714:9957:af14:fb36:6198:c925]
X-ClientProxiedBy: ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::6) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:714:9957:af14:fb36:6198:c925) by ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 16:45:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55755e4a-adc8-46e4-9c74-08d929d39d56
X-MS-TrafficTypeDiagnostic: VE1PR04MB7453:
X-Microsoft-Antispam-PRVS: <VE1PR04MB74536604575AC3FD2116D69AA8389@VE1PR04MB7453.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //1iXChSXTt0//OYks8rUdEGlcRoq951c2KGSjRbTLA3M6vHMBc3BX4KFafRoqHIAlCOjkPuZsGeoqheR01joOBCqkm2jZEwrdHqDWGApmf4/P+lij0Fo7tWthACAclMDiRZPYg/U5SMIf1IcCGUIb0jyq7qtAhDghQC0jmaOvXiHTF7266DQOz8yEPY5VMNxV/oxaaWtjDtxwoKZBQ5gOQtvi9LKS+7XB8vlpYKLC/Nk2M5NrohN8TaN3wpOJQyek2RXmLFX7W2zdZUxlHKlnkL2bWsa9D5RVw9csaLzpiDcoQA2YzOuXoq6E4NBsULmrGDkXVQFQs5h4xe2tmyenokb4M0gmWRQU0ozav9hr4+RE3FmI8mtu7Ugpkl5aoZMcXrC5r/Ztlv93t/w0gEhd4y2uz4piXRtnmzBy+QaAGWxzTTtp6P8aM/C74PnFrSQ81rZyytRYUzduPRz3lQD1pkWk2vLTHozdD6FCs6TDVcdc92990RtjXGwFAjHBgGSLIZ5fuO4gJ33PScmRN8HzIrGnfxaxgOB4yrPyuFMsohmdhP1hSmZJuyUDKve8wplHpSbF7X/AK155zottlVEXItCl7bMQoK+uE4X0yBe7uaxnftzxBQ65tCBjzukfgmKEffBprEJVX+Z2DtUNkm05KNQ1JvtOqrxBJ4CwjLY7VBO0KEQclrAIUIXPm741g3OqK4k4xBAY88NI1k+5qY5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(396003)(366004)(346002)(8676002)(8936002)(3480700007)(4326008)(966005)(66946007)(54906003)(6486002)(316002)(2906002)(2616005)(86362001)(16526019)(186003)(6496006)(83380400001)(66574015)(5660300002)(38100700002)(36756003)(45080400002)(66476007)(66556008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Vm8rNjJacnhXUHhFenE0ZHNhNDZydWVSMVhDNkpCRkpGR0pMUnB6SVhud3hO?=
 =?utf-8?B?NlZFVVEvc1dKUC9MSktOSWZaNTFadFlTRTRDcDNRcyswNnF2Um9uNVpYZ0Zr?=
 =?utf-8?B?aXJvMXVJa240eG9ocUtVZ0FrVGRLM1FlWGhXVkFkaVhzYmxzQnRpVStRRGVo?=
 =?utf-8?B?Z2pmV256VFo1czFKeGwvWjJaVFJQZGkyemg4eFZvV1NPMk1yZW8yMm1pTFNI?=
 =?utf-8?B?ckZhak9VVDJrMFpYQ1JRc3RpdUlMNC9Ybkhpamp1YkZPQzAxdnQxMXVqNkk1?=
 =?utf-8?B?MDE1TXN5MEVNOUZNVWN4T2tBNG5ucWo3MzN2M253aVl5UmxsZDJuNFFwSm1a?=
 =?utf-8?B?bkRUQi9vNTZCR1pNTFg2UDU4UlAzaTNRKzFOYXdIVnIrUisrSGVDZEVxSFdK?=
 =?utf-8?B?WlN6cWtKS0JGSXowODdCRDd2TWVTQndIUkNTa3Z1Y3hVT05rQ0hET3kzT1d3?=
 =?utf-8?B?S0tUTDloWmV2cWRYNnp0K1lETHdJeDNVQjU3L0hzYlkzZDgzNWRuN0FLdVBp?=
 =?utf-8?B?Q1M3eCt5NjFyaE9GK2RkR1dodWN3cEFxWEl6OGw3emZJbHo3OG5HbnhVWGtV?=
 =?utf-8?B?U01PY2puUi9LdFB5V0Jjc1k2aTQvSFR6bmdtSVlvRVAxZDNKV3FNYVhjeTJk?=
 =?utf-8?B?OG9HUEI0NjV5UUxsb3RXOVhuNVV6dDlXbnU1YyswNUtuc1hseU56aWlMam5B?=
 =?utf-8?B?OUpsUytoYWMvUDQxVGt6RVpBSGdVRytPdTV6OXFUS2d2SExYRkVsdzBCdnBT?=
 =?utf-8?B?aHBDeGZTb096bU16WXlRMis5dCtRWDkwSEFtV2NKS1FGalY4TFZxYkQ1U3Rj?=
 =?utf-8?B?TllZNStQamJMeGoweDFmdjcxVEU1aDZ3T1krVUpnR2JUZ2xlcElvMzMyNktl?=
 =?utf-8?B?NmFYU29xSVhsRFBFc210Skd5cE9EaFhMR2xVeS9VVURtSWJFV3IvblRPSFZL?=
 =?utf-8?B?TXRaNlhwcC8vMHQybmZlcE4yOFZVZmhlVnYvU2dXMHA4MXVkOHBudWt6Mk82?=
 =?utf-8?B?RnYvSnp0NnE0QlZDakZLWHRDKzhXWkw1cTVyMzZtMjJGZGhiOXpLVjFCbTlC?=
 =?utf-8?B?TFVoZlBEZXNkN2pOR2pWcnpWOWozNkMrZGt6SW1uMmJDQXNPaGtZS01QRWlp?=
 =?utf-8?B?clRTNituRnpKNXlVbjZYOFFac0N0SzRQMHFVMU5vRnVsSmo3M3pNUlJwbzc3?=
 =?utf-8?B?ZGF6ZDY3R3Rsb0ZqZjR5d3lUdVJZUnJmVlEzZ1lVM2NVZm5RMFhvQzdhM210?=
 =?utf-8?B?OXpuMWpFUzAvVm56Q1doUDI2d0FUcURUTDhxYndSOWpzY0I5VWVDc0YvNlZx?=
 =?utf-8?B?R2ZMT3laZTNqZWpZSjVLN3NvYllQeUtSQ01FODRaR2JqQVA2YThPcXhFQ0hu?=
 =?utf-8?B?bndRbVdYc1dEL0FXdGtCRzhjSHh2TWZGRGNzTU44dVZHSUxqOHBMa1l3dStu?=
 =?utf-8?B?cWVMZ3F3S2xNK2pyMXVYYXU2VkhYYnROcjJsOSs0K1BVZjNPLy9ZL1Y2ei91?=
 =?utf-8?B?Y3pnd0dpa0o4OCticEIwS29iMmFpNkZiazZJWWtKaHJEK0lSdEMvdm1wa2pM?=
 =?utf-8?B?eDBGOU1oaXgwbUo0SXRBeWFGZzFDTHBsOUhhZEkwdFVEQVh4MU50TktabDYy?=
 =?utf-8?B?bFRlSGE2NUNpamJQenhkaTBpZitaTWdXQktKdEtYTlZnbEFXdG1Mc2FKRlJB?=
 =?utf-8?B?aldnMURKK3ZYYnJYcVJyaE1ZdjdxYnRTZEFyK2Y1WGc5S2xzZnkwd2pCUVJY?=
 =?utf-8?B?OEhhRzlvMmRSZm5aK0l4Q3d6aXNXTjZWTmNqd09nSGdubDR5enpPR1hxejI5?=
 =?utf-8?B?dVAxTkRtSWg1a1ZCVkN3dHN6dzF1VHB1SlJJNWc0d1luOFFCNWxpSjNKRGVt?=
 =?utf-8?Q?ebYr8MfEMXd1c?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55755e4a-adc8-46e4-9c74-08d929d39d56
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 16:45:10.5382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rDBP/AU8EnXtIPzHbrTtHLPwz0m8da1WkZ6MKJuWmfFfVvpPBgEV4RoGM5979I2V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7453
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Ahring Oder Aring <aahringo@redhat.com> writes:
> as I notice there exists several quic user space implementations, is
> there any interest or process of doing an in-kernel implementation? I
> am asking because I would like to try out quic with an in-kernel
> application protocol like DLM. Besides DLM I've heard that the SMB
> community is also interested into such implementation.

Yes SMB can work over QUIC. It would be nice if there was an in-kernel
implementation that cifs.ko could use. Many firewall block port 445
(SMB) despite the newer version of the protocol now having encryption,
signing, etc. Using QUIC (UDP port 443) would allow for more reliable
connectivity to cloud storage like azure.

There are already multiple well-tested C QUIC implementation out there
(Microsoft one for example, has a lot of extra code annotation to allow
for deep static analysis) but I'm not sure how we would go about porting
it to linux.

https://github.com/microsoft/msquic

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

