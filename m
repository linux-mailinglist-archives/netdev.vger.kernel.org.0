Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7F56C818
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 10:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiGIIew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 04:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGIIeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 04:34:50 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05olkn2072.outbound.protection.outlook.com [40.92.90.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E3566BAB
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 01:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4thaVhvsdZmp9lupgPyXGk3xBqXvI+ZMs7WipK/IzjXQdPhWhkakpUvIxITJTvU/3vKOjZPsRKY/8jipj4w+78fEWq9YOCpl49KkDJVU4gnIMU6QSrhepLgwEkbrAi8rxvSn2qX4sX9+iQxao4+vk+AiTpsQ7jejKQUA/2fIiSnFwS6OumD/V96lJ2FUz0nToMjov0PQTop/HH3OrXlcRUbR7Y3rjoQ02QXEwH5x/XIFJROZYob4RdF2wWir6c9Rc8LQyFfmr4tVzd53rxjiFiQjRpLTFUKH6QDtFNAObewlwlCbRM+b5PHugulPOOVTJEfE/SfpUClh8WxJE2/Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdQ7CeNkHN7f2ofgQHU3q4GQiMrA+jJutjH+IdyjNuo=;
 b=M4kSzJeDn6TGhyHDN9hM24MYo7oyoVG44ThVyLPCFuLUvTsCC9M+kqmG2wzG1Mi66ru1uZ+w+pCQxlbItMKcURnPQ/K0f70UBBgBnbFrsf6mkRjbdUXCyoMFXNY0M2tRds5F0BhU7lXqPDLRGndyFdnO4rKPq6QHnVmQMrLZzm7qFr7qRj/PZ5PC42F6CGhhY2WLkedagv1XgvQetsJWoJ7PB3SicRIJseFmEK+hM+Z3vygm7Z0I2mGGeOIALvYAM11uLHo1KhiOUnOyVc6X8DV/2lIGt84dZeMhNNZ+M9A8DhfEllohOsa0FxF0Kfn+jqTMyxi7JlY/Bzsm8IEAPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdQ7CeNkHN7f2ofgQHU3q4GQiMrA+jJutjH+IdyjNuo=;
 b=fXVMjaeLMeNgxZb9AreePtgHuQSOhcXPgVG9RGr0vEXtObHEL7jQE1Zswn2Ot3B4nAiA3G8FQZ4Lcc9lggKwHP7+8NnU2bSEF4W81qAgDsIh0p04GCX2bH1B4cPLUt+wvYlYkLjfejYBSwxQHhxqxF7ZtvN+S5DPIgaWuRAVZG1unCgzp1xRhm8DyfojQRT7hUh+Vi8gNrbN5rcz8YIl0ZlKLrOesLPnD4g04zdpmg2pDMJ6AOX1DtHwv9u8mIJ26qV7WlwAwJp826+7kVeJ54g8FZv3JLsNhifqWlmshRauP26Om8icp/DijLE85LFrfksiaIunuqHP/j0W1VB3BQ==
Received: from HE1P193MB0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:3:101::11) by
 AM9P193MB0840.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:1f4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.21; Sat, 9 Jul 2022 08:34:47 +0000
Received: from HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
 ([fe80::566:bfa:a746:b3c2]) by HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
 ([fe80::566:bfa:a746:b3c2%8]) with mapi id 15.20.5417.023; Sat, 9 Jul 2022
 08:34:47 +0000
From:   Michelle Bies <mimbies@outlook.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>
Subject: Re: TPROXY + Attempt to release TCP socket in state 1
Thread-Topic: TPROXY + Attempt to release TCP socket in state 1
Thread-Index: AQHYkErevbS8bXbfdEm0spXJu4GhIq11kwpRgAAKJACAABtRFQ==
Date:   Sat, 9 Jul 2022 08:34:47 +0000
Message-ID: <HE1P193MB012310556C7CDB8E2B1FD759A8859@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
References: <HE1P193MB01236F580D05214179C7AAC0A8819@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
 <HE1P193MB01233D583E9A7B1418A77713A8859@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
 <20220709064114.GA4860@1wt.eu>
In-Reply-To: <20220709064114.GA4860@1wt.eu>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 0c0860a9-b3ff-28ad-2c63-6bcdf90410ab
x-tmn:  [tGVLGISzCFAkDANYYUtANoR5/s5rHfIqMfMUPBDPfn4=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60292e26-c7ff-46d9-b227-08da6185e1d4
x-ms-traffictypediagnostic: AM9P193MB0840:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q038V+Zi+RpjKJQkALxUBItpdfmI1xac57/vFWbeEpfoeU5+JkpuqBxvrSvSFlCyI/P99Dwo6a6Z+rA3H0cMVHOJjzCWgXnPyYRBTTzIH4L7w/TnFCE35sDqYp2PcIltYUPZN9tr7fqnuN9Y2vOPAgcqM4oEV94rWQZqNAQwpw6M1QHrPeF5o1/qtxIp94yfg/JLQVGXPARdAE+m9hSTqPUQRpuY9bldYZ2tifXNnKLTsOkZJ4oQs/jhxfZe2WPzGB3sgbqbfZ/H4fvQF3fClLaYCoWujfkzqGRDMX/hbgtAMXBgksLMAJiZIWlWqYK/fN+KDNbqD+KbeVSF9A7f+s90xPFAvr1WCBQwnECX2lfwJO7VRGaMlsH0bx9FOwOcZQ0n9FtJhPxV+4Z3p3ReG4yYAFi8oSGTEnLPc9GzffbvxQh6Y1/7nJLE9krko10bGqW2s+xDphIhYV9x9vbcvTZ1DB2LcJ3Fwv8ztwrln/eU9uXkHQEUJLEBVHx3oG1/SNQZpsIwwJ31SJzbhdKoo2mMd94MaNiH92Yz9dcVuiZ/g6JUchtDKjeuITxwORRKouchzfzW7Pofz8vRva6Wg7/2E0W19qDQ33IJXhvQ5umeGzVTTlTSrTqHrdH9aBJ0ZGcZszIlHxg4MbwP6aU/qmzEpqVpZFmQaNyFaObUFb5M8CU0ok2Cim/5BpXfUa5TwgICGRnS5i9g3DF5JtoDpegLGuKX8HDLkopmqGRzqMs=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?lcYBpWaUcDNRUh0YKGh86xN8OiBwrVER5Fsh2QAulOogn+Fl2Q7mNZUjxx?=
 =?iso-8859-1?Q?uZ+1F4IROpffBdnuPvEgsj2SsLYOwbSje6gekKvlO44ATaxjoArS0xPgk+?=
 =?iso-8859-1?Q?xtfpBesJYEnmI5Wnz6nPxefnxMyT8gaVp5llXn4MlSJfoRXYbKuXVhoRz/?=
 =?iso-8859-1?Q?5rL8rpddYSENyiFhjEbqtsdfnX8oRcmOGGuIKxz75YfVBDenPJksbgMRzH?=
 =?iso-8859-1?Q?IW6drglqU1UkFKZJom66wzHUrR2Y1st9+VTxIOa/ApddNBKlR6PY3rEdMk?=
 =?iso-8859-1?Q?bpbTp6x3Lvo2hxbHfHkXWFC5vC2gaiw7saw+nBSuEsrPb8+w4IKTe9VvFm?=
 =?iso-8859-1?Q?BaG1Ks2Ich6qF315L+XedHIzGOvw6/zBrVP0JAxXHwFHpXCWumQc/v9te2?=
 =?iso-8859-1?Q?UZ/BwQ6xwwEkXlGuDr09loO6/JNkFU/qePtDnpLcRcu37YJL/POi85MoOr?=
 =?iso-8859-1?Q?UYcGi3uvfYBXAbVwgS2tVQV4f45Xtv1hKv1whvTpV3f3L1RzeUGmdQUXks?=
 =?iso-8859-1?Q?RZNIG0KdweRpqD7+Z5lYpJ6EvwAfWjlKgr292E/EMx8F8jlEw/T95QC321?=
 =?iso-8859-1?Q?CQ1du53rWmqEun+EY+H5iQwKEhV2ZOL7R673U83neK95+xs1afXy8Y9HDT?=
 =?iso-8859-1?Q?m2tZq8bqMXAgrpaugAwxQXWuiDzz7J6lPIaUhaTydH2w5KEcnxsAoLSU/z?=
 =?iso-8859-1?Q?oY2Q5lU0NLkJCFEPKnfY2MrcQglyc7boAN9xt7KqE6aBkNu+Qjeok1sFbo?=
 =?iso-8859-1?Q?qBtO0QhldTCa3KKOD/tpPBPdveOx07Na0rlYg88obIYjkwxs6P54JVg0e3?=
 =?iso-8859-1?Q?0YERTuIrwUSwrTkJ6yG9h8EUDY30Dss1UkDHW0vTsn4QyfCjSXIMD1dPNs?=
 =?iso-8859-1?Q?7NXG4jVXnhX0hirv5WWKuDAV9BcNWF3ShhTxrolLb7OIEH01kB7QP2JdRr?=
 =?iso-8859-1?Q?A5d8XbstTW9FIF1h9CWKAHU3B2/07TRwP1w7gr42PLLpSO8EZ+Si06X9O/?=
 =?iso-8859-1?Q?1tEzSO/zPFb0NGXpk4Pp1y6Xft15ljB5OaiZwCEtC1IzBkqrNOc3Kxa7ym?=
 =?iso-8859-1?Q?o4T7IX3T8eiEl982VvXqOccaKdWfeuHeeLsLpcYyoBusdzKjN7UAtDRd0V?=
 =?iso-8859-1?Q?mdnW+GMJ1ZG/y77aioMKtDmyg2Eke+rG7pruQpiE6slVdfS2Ug3755k/wk?=
 =?iso-8859-1?Q?41rP/0RbyriOsVGjHAGIKo8IHf9fJCOSOMNqOQswwL+TS1SNfKcpeHeEyF?=
 =?iso-8859-1?Q?Iq5QfcDD5+F3f941e9ZZ8mBkaffGTSvjDbpH1A8GuZS6TVQmXrwlhRqb0k?=
 =?iso-8859-1?Q?cdGr?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 60292e26-c7ff-46d9-b227-08da6185e1d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 08:34:47.3079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P193MB0840
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi =0A=
=0A=
On Sat, Jul 9, 2022 at 8:41 AM Willy Tarreau <w@1wt.eu> wrote:=0A=
> =0A=
> You sent it only 4 days ago! As you might have noticed you're not the=0A=
> only one to request help, code reviews or anything that requires time=0A=
=0A=
You are completely right. Thank you for your attention and I am sorry for t=
he rush (I am a newbie in the kernel scope).=0A=
=0A=
> ... . What progress have you made on your side on=0A=
> the analysis of this problem in during this time, that you could share=0A=
> to save precious time to those who are going to help you, and to make=0A=
> your issue more interesting to analyse than other ones ?=0A=
=0A=
The problem occurs in a production environment in random periods, sometimes=
 after some hours and sometimes after some days.=0A=
I couldn't reproduce it in my test environment, I even tried to simulate th=
e problem under huge load in my development environment but still no crash =
occurred.=0A=
I also tried to attach a serial console but nothing special happens when sy=
stem reboots.=0A=
=0A=
> Also, I'm seeing that your kernel is tainted by an out-of-tree module:=0A=
> =0A=
> > >   CPU: 5 PID: 0 Comm: swapper/5 Tainted: GO 5.4.181+ #9=0A=
>                                              ^^=0A=
> =0A=
> Most likely it's this "xt_geoip" module but it may also be anything=0A=
> else I have not spotted in your dump. Have you rechecked without it ?=0A=
> While unlikely to be related, any out-of-tree code must be handled=0A=
> with extreme care, as their impact on the rest of the kernel remains=0A=
> mostly unknown, so they're the first ones to disable during=0A=
> troubleshooting.=0A=
=0A=
I applied IMQ patch so I have a xt_IMQ module.=0A=
Could this be root of the problem?=0A=
=0A=
> Please always mention the exact version in reports. I've seen "5.4.181+"=
=0A=
> in your dump, which means 5.4.181 plus extra patches. Have you tried=0A=
> again without them ?=0A=
You're correct. My kernel is 5.4.181+. I got the tip and I will check all m=
y changes, although I think they are irrelevant.=0A=
=0A=
Thank you again for your time.=0A=
