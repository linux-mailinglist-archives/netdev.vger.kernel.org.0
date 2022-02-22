Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDAC4BF7FD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiBVMUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiBVMUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:20:42 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70114.outbound.protection.outlook.com [40.107.7.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B2C9BADC
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:20:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DA6p2Qg2ewZ43DJwHekAOJk7PVYKdTQNm1/fqcoy2KAwQWD0fYpVXvOHm7g0RYCtZw6PIGWtvyUv7UgILJw+hUz0kPsFXed92jrzz8UluE+5qsNXxRer3VQOBykHpbQg/+AUNZJRt53xVnDa0QTUqebsktLS/TxU4hm9hKvC7UlT2fBdknB0qeBOtOA4mY+cvXoIQQLWgh68JClRUcR6gudi58+UtzgS3LCefUqb1GgSpSpQRgYIBDl7IbF3RVtqjquN+N8oKX02hL+W4waa1vOsnPQYJ+7WVsixbKbAazTyg/ZHCEI1j+9VKfWGJgoPNgkAom//KkRHS+LnQ1heEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=foCRcVl4/QcLTNbdF3P+zMpV5ln3wulpwAlnzMUJTu4=;
 b=Mi8pV0Of8er72vO7eyP5tcC+7yG8VqZHGcyJ671Is1Nobv+kuzgr3vL1/7waFT2nqRkS8wfK5ArSvyK7rC0tWKCXQmlB+GyrTj4eGHfQ5XMXtocCqpKGie6xu5DlQC4RI0yTS5qyANXuqjghsePNesx1kINpGGe/7Z5u3uft4MWOMl7gWOyx/Su3pgr5sB29DHgH+97RCnTBW24PVxQQ+mquVBDKZC2g/N6SaQ0Lar5ELHACMcfMN+QisQd76yjBFJ4Wci5A6Qc7kK9rVR89bfITDHZWLuM+GBELuzPv/lGVmlOanyOHU6Ow9cEUQJdpPhz9Xonv+iuKOjlF+Ql+AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foCRcVl4/QcLTNbdF3P+zMpV5ln3wulpwAlnzMUJTu4=;
 b=EviUcIYlRHk/5JqrSCHfdiuUPXUM2x9S7mINCptyPXh+B5JpxNc3zmEXV7HcoZcLGfXQnJjVSbWMXD85YYUShYWRGfFM95dNea+Rzm8vuJH6UTI+n7IU+I1anj+WfiPFlkAW6g8LSAi811nJm9O4f6Q2kMGKKcJew4VIIEZE6fU=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB3624.eurprd03.prod.outlook.com (2603:10a6:209:34::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Tue, 22 Feb
 2022 12:20:13 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 12:20:13 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: realtek: rtl8365mb: add support
 for rtl8_4t
Thread-Topic: [PATCH net-next v2 2/2] net: dsa: realtek: rtl8365mb: add
 support for rtl8_4t
Thread-Index: AQHYJI5NALk0/+sSBUiUD2IeewCHOg==
Date:   Tue, 22 Feb 2022 12:20:13 +0000
Message-ID: <87pmnfgkjn.fsf@bang-olufsen.dk>
References: <20220218060959.6631-1-luizluca@gmail.com>
        <20220218060959.6631-3-luizluca@gmail.com>      <8735kgpdho.fsf@bang-olufsen.dk>
        <CAJq09z6v0KZU67-bD5bnFoRoWbd7a-Vc2VGotTC4N2Pk3WHHow@mail.gmail.com>
In-Reply-To: <CAJq09z6v0KZU67-bD5bnFoRoWbd7a-Vc2VGotTC4N2Pk3WHHow@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Mon, 21 Feb 2022 23:42:19   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e930dc1-02d1-4619-7122-08d9f5fdad6c
x-ms-traffictypediagnostic: AM6PR03MB3624:EE_
x-microsoft-antispam-prvs: <AM6PR03MB362450E5EE0CB185EA70C84B833B9@AM6PR03MB3624.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iaOnX+4kZQ++rUSWJ5q61i4KQ02FNdrwylYPo1XybrKj5yrpvVAIXL4bhX0IWa3gR6uoHJgY6ocMU/JrZLIeRpvswCargPspP5bgq/9KEkVuIBqgOf7LZF808xZ8uOT2BufD/pFPJiGUwkxqN/4mS/H3kdH7okM9ZHYjh1G6FFESQXSXMjMdWQxTrNJ+v9YMKMAksQA/m7DSt4Ssaj3BFks7Ewb/gjbvUq3Qb+tVcUAR10LVyRX9ro1BLnni2itbnBzDvzJMDqK9WQbzlTU47CWL44RF31El5ZFrnixIn+1Q9+qoWpwRoiJCjVb5dwEr0wmGzw+ofzMOJ4QX7SA29Bb4x04b1us3V57ti/yZNVvhJjbNpLBIHJFroo+M5+BLf6OiYdLQt9p5UuHd2zdxg9cZQ9joefxtw3nWZ15qa04JUlxDqG75k6LPnIAoNoXfsZSHpxVyU+gtyd5ENF08TZbzSVGoNJ3eAN0DaD02tXNpnLZK/NtYFDvW2Un0U/X34sLi0wFG7nELw2AdbOFSTo7LKlZgid4Is6/3x+pzER9AmIublsUUcx6JwueY72CYRf1qWcuE4UIB1EwDFMzEtQViTc8BZadEXi4iPLZA1y4rFOflyfZFM6j8aatf1ACQsYQM4i72WZk9u8uveWJvaFBcW/4ndUBBhrOU1sDRCP/JTuqr624mgCECR7ojtlZLoXPKlwMVWWD1NWhjs6edXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(316002)(54906003)(86362001)(91956017)(2906002)(122000001)(71200400001)(508600001)(38100700002)(38070700005)(6512007)(26005)(7416002)(6486002)(6506007)(66946007)(186003)(4326008)(2616005)(83380400001)(8676002)(5660300002)(66476007)(36756003)(64756008)(8976002)(76116006)(66556008)(30864003)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Zn9x6mqT94uDjsdq2hood/GIyJaBzWpMP9PETK5eEDHuodvwHrp5Qhzz?=
 =?Windows-1252?Q?G90TO2Rv7sZpzQ0mxlw8nLyO0rXxo6ufq6ynJvStXU7zdb7IT4K1Uarm?=
 =?Windows-1252?Q?of2XpiZ8Qp9U+M+CXAGeHy4QmqwPdFpZEDy1vokhjj3XeN3Vh+n8vADI?=
 =?Windows-1252?Q?RkO+B7L6gT/10AktpSwxvShij/2wPiJfdjWsCWZeGSgQsSNKHaaKf7oD?=
 =?Windows-1252?Q?GrRMMgrI3OQ5iCQ9uPhK94gYXsevwnAXWK8v7PknFymE3E9PAR8+1s58?=
 =?Windows-1252?Q?y1CeYzaemWTwotanqGEaQe3VpmAMdhghrE0zoCwleb0Y4UJdTHF6K0AU?=
 =?Windows-1252?Q?uqKKOuh3Vy3cKpu5biL1dyAG0TdLOKyvNUs3WcYJXvg5nnUmW5CfLM6c?=
 =?Windows-1252?Q?3p4l/477l/G1cDrG8q3dhWkruvW7y9QozBjrNTUXAlfe+6QIcvcl2mtr?=
 =?Windows-1252?Q?cqFHc08c6ECOAtGq7ahKCDzPDHykHgsHGMJrFmQEJUe352W+5PSE9be+?=
 =?Windows-1252?Q?z3p2N0MgPsrVP9IDkgZWDsfMUscxuui5antoGWHsR4A+w9QTOCBLD0Jd?=
 =?Windows-1252?Q?k+ptqi6XNPx+iiYYC0toupUAsQjQhXZJvvioBnBxqCgt7jIgLxx/ijI+?=
 =?Windows-1252?Q?ULkDE0IIaustcvhow1UaDpfPB4XbnYnKMagq83rnHW72PpdN/v+N7NnX?=
 =?Windows-1252?Q?rdyHOE2Mxbcxe5FRJmvZIusJbBm8hxEcKkzsez6zqgzO1Z1s8xO4wuqL?=
 =?Windows-1252?Q?zfBUoRFO4B5bBxTN83Y1RFB6vQahFf4MdAJ1818Y/vu/CAlK0//ygF4F?=
 =?Windows-1252?Q?zRu6NRVfUKucRI+tEIZu2YJmmoz4I9fg92oc7j+GsumXmE8Pqzvz6TgD?=
 =?Windows-1252?Q?hZ2plYIZ6PUjA3c4VYnZjNVmC86+XUTcXTupbrywlT7C9Ov7ayOV5zJY?=
 =?Windows-1252?Q?bvglEEWyBzZqAljEe10zufqskZHtmdBY2R7qpF3WQ7XpOWK4xnpqZpNg?=
 =?Windows-1252?Q?2hQldbt+0UYprBpDGi34Pshpg/t69Wn/77lXddBxR32X/J3Utj8h2CvC?=
 =?Windows-1252?Q?gYje8xGJ47QcpIOAZV2FeAQlFHh7R9UaMwtBy/saqoRkiicL9PqYYgMM?=
 =?Windows-1252?Q?Iph0SlzbWFXDH4n0b6PMdtkCekMItYWzTh5+JDgX/YdGZED40l0vf4zU?=
 =?Windows-1252?Q?siynPKLjcVRBWOQuqE6TilP5JPbPO2pNsf6KUfrPrYZPww9KvkdDGxQo?=
 =?Windows-1252?Q?1MAkZHZxrKTMh4T0rJ3HvYT3K4VroiwQNXBWg53BSC1VK8TTN+Dwl2e5?=
 =?Windows-1252?Q?yTYYSJuWmIppVDk6Usrlse/fRjPWQsGr0TQxyiFZimjw4NCJUmXmQiT2?=
 =?Windows-1252?Q?IrQ+1xsI8yQ0FPqr5ZWe89weaKPJyMc3xHVMrSnmT+h2o7akYkJFC7Q8?=
 =?Windows-1252?Q?0GCWQ86Naf+Sb/zHva+3epA276p+UZfFgEHKEnu5a7QWX+lC29u7GnzP?=
 =?Windows-1252?Q?04SxrBiuO17MDozB9/Ux/+ZVcdh8N1kzz22lJiysl9AU9uvjhn1DGTNT?=
 =?Windows-1252?Q?lppGsy0qZZYwoFuagPrO/Jpue8p1q81v6dVCvt/TW7BXyHJiLPfXb/Fr?=
 =?Windows-1252?Q?SYxzvZwOcG1h25YMCTTYF56KViml4MPhiz4dFv7M/AOT9msqKq3TFlVa?=
 =?Windows-1252?Q?XvsTdY3A8ISLdHeIlLqzsfDRqi344b/Yt4RxopIXbW311qto2hFlLywJ?=
 =?Windows-1252?Q?hrzERfDtL2Z6e3JlpNY=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e930dc1-02d1-4619-7122-08d9f5fdad6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 12:20:13.3794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o+4YEy1LsJqZElLXSEuYXOS3jRrf17kWPEd3MuYIFR5td+aA8MDvsrWlfWwG+Q4wiOMMWl5uwKIqoUmNtDQBIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3624
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

>> > The trailing tag is also supported by this family. The default is stil=
l
>> > rtl8_4 but now the switch supports changing the tag to rtl8_4t.
>> >
>> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>> > ---
>> >  drivers/net/dsa/realtek/rtl8365mb.c | 78 ++++++++++++++++++++++++----=
-
>> >  1 file changed, 66 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/rea=
ltek/rtl8365mb.c
>> > index 2ed592147c20..043cac34e906 100644
>> > --- a/drivers/net/dsa/realtek/rtl8365mb.c
>> > +++ b/drivers/net/dsa/realtek/rtl8365mb.c
>> > @@ -524,9 +524,7 @@ enum rtl8365mb_cpu_rxlen {
>> >   * @mask: port mask of ports that parse should parse CPU tags
>> >   * @trap_port: forward trapped frames to this port
>> >   * @insert: CPU tag insertion mode in switch->CPU frames
>> > - * @position: position of CPU tag in frame
>> >   * @rx_length: minimum CPU RX length
>> > - * @format: CPU tag format
>> >   *
>> >   * Represents the CPU tagging and CPU port configuration of the switc=
h. These
>> >   * settings are configurable at runtime.
>> > @@ -536,9 +534,7 @@ struct rtl8365mb_cpu {
>> >       u32 mask;
>> >       u32 trap_port;
>> >       enum rtl8365mb_cpu_insert insert;
>> > -     enum rtl8365mb_cpu_position position;
>> >       enum rtl8365mb_cpu_rxlen rx_length;
>> > -     enum rtl8365mb_cpu_format format;
>>
>> This struct is meant to represent the whole CPU config register. Rather
>> than pulling it out and adding tag_protocol to struct rtl8365mb, can you
>> instead do something like:
>>
>> - keep these members of _cpu
>> - put back the cpu member of struct rtl8365mb (I don't know why it was r=
emoved...)
>
> The cpu was dropped from the struct rtl8365mb because it had no use
> for it. It was only used outside setup to unreliably detect ext int
> ports. When I got no other use for it, I removed it (stingily saving
> some bytes).

This is not a good approach in general as evidenced by this
discussion.

>
>> - in get_tag_protocol: return mb->cpu.position =3D=3D AFTER_SA ? RTL8_4 =
: RTL8_4T;
>
> I was doing just that but I changed to an enum dsa_tag_protocol.
> mb->cpu.position works together with mb->cpu.format and if it is
> RTL8365MB_CPU_FORMAT_4BYTES, the code will have an undefined behavior
> (and get_tag_protocol() cannot return an error). My idea was to always
> do "DSA tag" to "Realtek registers" and never the opposite to avoid
> that situation. get_tag_protocol() is called even before the CPU port
> is configured. And although AFTER_SA and cpu format bits unset is the
> desired default value, I would like to make it safe by design, not
> coincidence.

Just check mb->cpu.format as well when adding support for 4-byte tags
then?

BTW, I don't suggest adding the 4-byte tag support unless there is a
very good reason. It contains much less information and will complicate
matters when we want to add e.g. TX forward offloading. That will not be
possible with the 4-byte format, and so we will have to put traps all
over the driver to ensure coherency. Ultimately it is better just not to
add support unless somebody has a hardware requirement which demands it.

>
>> - in change_tag_protocol: just update mb->cpu.position and call
>>   rtl8365mb_cpu_config again
>> - avoid the arcane call to rtl8365mb_change_tag_protocol in _setup
>> - avoid the need to do regmap_update_bits instead of a clean
>>   regmap_write in one place
>
> The rtl8365mb_cpu_config() was already a multi-register update, doing
> a regmap_update_bits(RTL8365MB_CPU_PORT_MASK_REG) and a
> regmap_write(RTL8365MB_CPU_CTRL_REG). I thought it would touch too
> much just to change a single bit. After the indirect reg access, I'm
> trying to touch exclusively what is strictly necessary.

Luiz, it is more important for the code to be coherent. Register writes
are very cheap here. Changing tag protocol is not something that happens
all the time. Same applies to dropping bytes due to stinginess - never
sacrifice the code for some purely theoretical performance optimization.

Also, don't worry about the indirect PHY register access affair. We
fixed it, right? Do not be afraid of the hardware, it is not that
scary. Be afraid of long review cycles because people don't like your
code ;-)

>
>> The reason I'm saying this is because, in the original version of the
>> driver, CPU configuration was in a single place. Now it is scattered. I
>> would kindly ask that you try to respect the existing design because I
>> can already see that things are starting to get a bit messy.
>
> My idea was to bring closer what was asked with what strictly needs to
> be done. We agree on having a single place where a setting is applied.
> We disagree on the granularity: I think it should be the smallest unit
> a caller might be interested to change (a bit in this case), and you
> that it should be the cpu-related registers. I don't know which one is
> the best option.

Have you looked at the implementation of regmap_update_bits? It actually
does two operations: a read and a write.

I fear we have a very divergent philosophy on this matter. By far and
away the most important thing is to keep the code clean and
consistent.

I already explained that these registers are non-volatile.

>
> I think it is easier to track changes when there is an individual
> function that touches it (like adding a printk), instead of
> conditionally printing that message from a shared function. Anyway, I
> might be exaggerating for this case.

This argument is not helpful at all.

>
>> If we subsequently want to configure other CPU parameters on the fly, it
>> will be as easy as updating the cpu struct and calling cpu_config
>> again. This register is also non-volatile so the state we keep will
>> always conform with the switch configuration.
>
> I'm averse to any copies of data when I could have them at a single
> place. Using the CPU struct, it is a two step job: 1) change the
> driver cpu struct, 2) apply. In a similar generic situation, I need to
> be cautious if someone could potentially change the struct between
> step 1) and 2), or even something else before step 1) could have it
> changed in memory (row hammer, for example). It might not apply to
> this driver but I always try to be skeptical "by design".

This argument is also pie-in-the-sky.

>
>> Sorry if you find the feedback too opinionated - I don't mean anything
>> personally. But the original design was not by accident, so I would
>> appreciate if we can keep it that way unless there is a good reason to
>> change it.
>
> Thanks, Alvin. No need to feel sorry. The worst you can do is to
> offend my code, my ideas, not me. ;-) It's always good to hear from
> you and other devs. I always learn something.
>
>>
>> >  };
>> >
>> >  /**
>> > @@ -566,6 +562,7 @@ struct rtl8365mb_port {
>> >   * @chip_ver: chip silicon revision
>> >   * @port_mask: mask of all ports
>> >   * @learn_limit_max: maximum number of L2 addresses the chip can lear=
n
>> > + * @tag_protocol: current switch CPU tag protocol
>> >   * @mib_lock: prevent concurrent reads of MIB counters
>> >   * @ports: per-port data
>> >   * @jam_table: chip-specific initialization jam table
>> > @@ -580,6 +577,7 @@ struct rtl8365mb {
>> >       u32 chip_ver;
>> >       u32 port_mask;
>> >       u32 learn_limit_max;
>> > +     enum dsa_tag_protocol tag_protocol;
>> >       struct mutex mib_lock;
>> >       struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
>> >       const struct rtl8365mb_jam_tbl_entry *jam_table;
>> > @@ -770,7 +768,54 @@ static enum dsa_tag_protocol
>> >  rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
>> >                          enum dsa_tag_protocol mp)
>> >  {
>> > -     return DSA_TAG_PROTO_RTL8_4;
>> > +     struct realtek_priv *priv =3D ds->priv;
>> > +     struct rtl8365mb *chip_data;
>>
>> Please stick to the convention and call this struct rtl8365mb pointer mb=
.
>
> That's a great opportunity to ask. I always wondered what mb really
> means. I was already asked in an old thread but nobody answered it.
> The only "mb" I found is the driver suffix (rtl8365'mb') but it would
> not make sense.

Yeah it was just the suffix. You can think of it as the nickname of the
chip in the driver. Many other drivers do this too. Sorry that it
doesn't make sense.

>
>>
>> > +
>> > +     chip_data =3D priv->chip_data;
>> > +
>> > +     return chip_data->tag_protocol;
>> > +}
>> > +
>> > +static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int c=
pu,
>> > +                                      enum dsa_tag_protocol proto)
>> > +{
>> > +     struct realtek_priv *priv =3D ds->priv;
>> > +     struct rtl8365mb *chip_data;
>>
>> s/chip_data/mb/ per convention
>>
>> > +     int tag_position;
>> > +     int tag_format;
>> > +     int ret;
>> > +
>> > +     switch (proto) {
>> > +     case DSA_TAG_PROTO_RTL8_4:
>> > +             tag_format =3D RTL8365MB_CPU_FORMAT_8BYTES;
>> > +             tag_position =3D RTL8365MB_CPU_POS_AFTER_SA;
>> > +             break;
>> > +     case DSA_TAG_PROTO_RTL8_4T:
>> > +             tag_format =3D RTL8365MB_CPU_FORMAT_8BYTES;
>> > +             tag_position =3D RTL8365MB_CPU_POS_BEFORE_CRC;
>> > +             break;
>> > +     /* The switch also supports a 4-byte format, similar to rtl4a bu=
t with
>> > +      * the same 0x04 8-bit version and probably 8-bit port source/de=
st.
>> > +      * There is no public doc about it. Not supported yet.
>> > +      */
>> > +     default:
>> > +             return -EPROTONOSUPPORT;
>> > +     }
>> > +
>> > +     ret =3D regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
>> > +                              RTL8365MB_CPU_CTRL_TAG_POSITION_MASK |
>> > +                              RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
>> > +                              FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSIT=
ION_MASK,
>> > +                                         tag_position) |
>> > +                              FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMA=
T_MASK,
>> > +                                         tag_format));
>> > +     if (ret)
>> > +             return ret;
>> > +
>> > +     chip_data =3D priv->chip_data;
>>
>> nit: I would put this assignment up top like in the rest of the driver,
>> respecting reverse-christmass-tree order. It's nice to stick to the
>> existing style.
>
> ok
>
>>
>> > +     chip_data->tag_protocol =3D proto;
>> > +
>> > +     return 0;
>> >  }
>> >
>> >  static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int =
port,
>> > @@ -1739,13 +1784,18 @@ static int rtl8365mb_cpu_config(struct realtek=
_priv *priv, const struct rtl8365m
>> >
>> >       val =3D FIELD_PREP(RTL8365MB_CPU_CTRL_EN_MASK, cpu->enable ? 1 :=
 0) |
>> >             FIELD_PREP(RTL8365MB_CPU_CTRL_INSERTMODE_MASK, cpu->insert=
) |
>> > -           FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, cpu->posi=
tion) |
>> >             FIELD_PREP(RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK, cpu->rx_le=
ngth) |
>> > -           FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, cpu->format=
) |
>> >             FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_MASK, cpu->trap_po=
rt & 0x7) |
>> >             FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
>> >                        cpu->trap_port >> 3 & 0x1);
>> > -     ret =3D regmap_write(priv->map, RTL8365MB_CPU_CTRL_REG, val);
>> > +
>> > +     ret =3D regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
>> > +                              RTL8365MB_CPU_CTRL_EN_MASK |
>> > +                              RTL8365MB_CPU_CTRL_INSERTMODE_MASK |
>> > +                              RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK |
>> > +                              RTL8365MB_CPU_CTRL_TRAP_PORT_MASK |
>> > +                              RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
>> > +                              val);
>> >       if (ret)
>> >               return ret;
>> >
>> > @@ -1827,6 +1877,11 @@ static int rtl8365mb_setup(struct dsa_switch *d=
s)
>> >               dev_info(priv->dev, "no interrupt support\n");
>> >
>> >       /* Configure CPU tagging */
>> > +     ret =3D rtl8365mb_change_tag_protocol(priv->ds, -1, DSA_TAG_PROT=
O_RTL8_4);
>> > +     if (ret) {
>> > +             dev_err(priv->dev, "failed to set default tag protocol: =
%d\n", ret);
>> > +             return ret;
>> > +     }
>> >       cpu.trap_port =3D RTL8365MB_MAX_NUM_PORTS;
>> >       dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
>> >               cpu.mask |=3D BIT(cpu_dp->index);
>> > @@ -1834,13 +1889,9 @@ static int rtl8365mb_setup(struct dsa_switch *d=
s)
>> >               if (cpu.trap_port =3D=3D RTL8365MB_MAX_NUM_PORTS)
>> >                       cpu.trap_port =3D cpu_dp->index;
>> >       }
>> > -
>> >       cpu.enable =3D cpu.mask > 0;
>> >       cpu.insert =3D RTL8365MB_CPU_INSERT_TO_ALL;
>> > -     cpu.position =3D RTL8365MB_CPU_POS_AFTER_SA;
>> >       cpu.rx_length =3D RTL8365MB_CPU_RXLEN_64BYTES;
>> > -     cpu.format =3D RTL8365MB_CPU_FORMAT_8BYTES;
>>
>> Like I said above, I think it would be nice to put this cpu struct back
>> in the rtl8365mb private data.
>
> It would require to split CPU initialization between pre dsa register
> (where format must be defined) and dsa_setup (where cpu port is read
> from dsa ports and settings applied to the switch). get_tag_protocol()
> is called between these two to get the default tag protocol. DSA calls
> change_tag_protocol afterwards if the defined tag protocol in the
> devicetree does not match.

I don't see the problem, sorry. I am basically suggesting to go back to
the way it was done before. You can always change the tag protocol as
you can the rest of the CPU configuration. I even put a comment at the
top of struct rtl8365mb_cpu to this effect:

/**
 * ...
 * Represents the CPU tagging and CPU port configuration of the switch. The=
se
 * settings are configurable at runtime.
 */
struct rtl8365mb_cpu {

>
>> > -
>> >       ret =3D rtl8365mb_cpu_config(priv, &cpu);
>> >       if (ret)
>> >               goto out_teardown_irq;
>> > @@ -1982,6 +2033,7 @@ static int rtl8365mb_detect(struct realtek_priv =
*priv)
>> >               mb->learn_limit_max =3D RTL8365MB_LEARN_LIMIT_MAX;
>> >               mb->jam_table =3D rtl8365mb_init_jam_8365mb_vc;
>> >               mb->jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc=
);
>> > +             mb->tag_protocol =3D DSA_TAG_PROTO_RTL8_4;
>> >
>> >               break;
>> >       default:
>> > @@ -1996,6 +2048,7 @@ static int rtl8365mb_detect(struct realtek_priv =
*priv)
>> >
>> >  static const struct dsa_switch_ops rtl8365mb_switch_ops_smi =3D {
>> >       .get_tag_protocol =3D rtl8365mb_get_tag_protocol,
>> > +     .change_tag_protocol =3D rtl8365mb_change_tag_protocol,
>> >       .setup =3D rtl8365mb_setup,
>> >       .teardown =3D rtl8365mb_teardown,
>> >       .phylink_get_caps =3D rtl8365mb_phylink_get_caps,
>> > @@ -2014,6 +2067,7 @@ static const struct dsa_switch_ops rtl8365mb_swi=
tch_ops_smi =3D {
>> >
>> >  static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio =3D {
>> >       .get_tag_protocol =3D rtl8365mb_get_tag_protocol,
>> > +     .change_tag_protocol =3D rtl8365mb_change_tag_protocol,
>> >       .setup =3D rtl8365mb_setup,
>> >       .teardown =3D rtl8365mb_teardown,
>> >       .phylink_get_caps =3D rtl8365mb_phylink_get_caps,=
