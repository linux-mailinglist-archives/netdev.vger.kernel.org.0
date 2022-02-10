Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E2B4B07E2
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiBJINt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:13:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiBJINr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:13:47 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2131.outbound.protection.outlook.com [40.107.21.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557ED1097
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:13:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVxMkdEbTry1pl7r8++xsOZpeVAT07aQ8I080MKEE+nAQV/o1WqBDExsJnDWhxQhp6aO2Ud9vYs4pu+0zZjXWQ5SYa/JA4vIu5ZA/gMU0d5kTyanvpKYTojn+SvYxVfQLfX0dMF5rg3RZUxjQqEzXUVoMI4qvN9myFeeJAAC3z1gbCDDXiWj9p40lIcD2rKSIHo3iJSBWwZbYsjGD6yKUYkyJDlk08JhyXs+btB8V+rauLM/CeQyyo4OTBgGhzytCEiDySmqTF7/LRbBBjuOsloUMp1mHJriRqTjFWfOyJr/Q/2P4QoGdynnrUhUtFyaY8YicMuOSkUyOndu+Jpk1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvsjF1bTVm42MOpxbTKz2JuiqBAelKMTaAugwTznN14=;
 b=fahbLtQy1AtnXyqEG2HzjSshEf+YVVkEn/nrjOefyOBtsliz5m0NJKkTFOATrMeqqalHif6b3z8VJYi7Rau0Ck2nNrxhhZK1lnl0qk3BixZnSEFwMHL+20JT6zuf4HvPgKf6hiNJiZj5gE0xyTp+/JQow4gNAyoJeAAPtBqbveCfm/EGJPaoePBb2P7qcfs/mtQfjudrQWZv/cSzDOtL6rj+gJbH9y4FrBGvnCV0paTA4VFpkxqclWipWlP5h7rfeAMqaupn7XEvNhu8LrrUVysAJ+CSpjjvs2mwu7uvxbVZbLa+Ev8burXXDWSqisKNA/G+C8zHZCOgQDW+QQmETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvsjF1bTVm42MOpxbTKz2JuiqBAelKMTaAugwTznN14=;
 b=MDfvl8SwVSHhJBDOsNKvYo97uvO1nNFBZrQjfRiQW14oGWyEDTZy/nu6vZYAB2SKnG3vXU2Kdoi7mhWCBDG1QdNYe15LnLyFNNFiiqLwz/YiDJoemafxMUlRzMgfN2C15BIUp/em2pQ+rrp/IApFGFMmInVXl1Ju99gtHLPy/Ao=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM9PR03MB7089.eurprd03.prod.outlook.com (2603:10a6:20b:2d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Thu, 10 Feb
 2022 08:13:46 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 08:13:46 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>
Subject: Re: net: dsa: realtek: silent indirect reg read failures on SMP
Thread-Topic: net: dsa: realtek: silent indirect reg read failures on SMP
Thread-Index: AQHYG5fs5yDF6pxxpUySzHA96Kq4cw==
Date:   Thu, 10 Feb 2022 08:13:46 +0000
Message-ID: <87h797gmv9.fsf@bang-olufsen.dk>
References: <CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com>
        <878rukib4f.fsf@bang-olufsen.dk>
        <CAJq09z71Fi8rLkQUPR=Ov6e_99jDujjKBfvBSZW0M+gTWK-ToA@mail.gmail.com>
        <CAJq09z6W+yYAaDcNC1BQEYKdQUuHvp4=vmhyW0hqbbQUzo516w@mail.gmail.com>
In-Reply-To: <CAJq09z6W+yYAaDcNC1BQEYKdQUuHvp4=vmhyW0hqbbQUzo516w@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Thu, 10 Feb 2022 00:10:23   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: beb14a62-7078-4233-36eb-08d9ec6d42e2
x-ms-traffictypediagnostic: AM9PR03MB7089:EE_
x-microsoft-antispam-prvs: <AM9PR03MB7089B54B505F2F84501E8721832F9@AM9PR03MB7089.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mgZJqqigRSMaesHRZM+SoEo/MJ4zIrUr6/98kVY4EmFZCGjjg+/wZE+QBWy4BZWXdp+HPfjXP7A8cUvEjBC26YqOw66engy5xqoPS6JuN15C9vrovrD9tVrMYKhdwth3aQ3v9s77eUQlSARHoy2tkt2kPBwDnvwI95ie6JvTiUEfsmcR6w6n4JTBVMemroDKaIzFPgufKtEWdqaW+E1WRdNBKuHLasugdM/3sarvgO0HWuZzyT3sNsMi9qfI3I8pUe6yspiSCohrKtKz0r8+/QS1kbQm31iMFQrHTwv8zFZOVeeZk1VqBREMvv+za62Dg37RXPkI7nse4rfYR3gQ9kecPOlpB59dje6yen0uJIfEWjua12gMPo6PGE5TKBduQsSrP4GJYwvVALOkTHgqNA6vH9aJBDYjIuM4WNKFP7mIR1n8xydB9aAWGavgXVUb7mmzVXrQHAj+w+3ZaIcv9Op7LGfYpqrnBpUxaaX7PxyzUlqiJzrFier+1mkmo28YhbGHiHsD9WcaHaNuQrXzK+x9XUgb9jIG9L5evaJfBa2/HmjvU596zOEdFGG3g+TlMUz9uaeqYxlL+byK0ztF/S4ZCpNnGUNssygMfg1wVpaS4kokYfAQFbS7HMmRQRK/PGG83exJi9nyVewhlRpvG0ga6EXAmkIh5QvpM9X7JZdhSpXv6M1CVPVjdXgnMCm5NnxOiUIA2DqDXqkA5jpd6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(6512007)(508600001)(6916009)(54906003)(2906002)(122000001)(316002)(38100700002)(6486002)(8976002)(6506007)(8676002)(66946007)(91956017)(76116006)(38070700005)(2616005)(71200400001)(64756008)(66446008)(4744005)(66556008)(4326008)(66476007)(8936002)(86362001)(26005)(186003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?TIhL43eFv58K6CivaRWtPAeGEgzMnr+s+YMX1wiZPQHorVgaBLhAnbuf?=
 =?windows-1254?Q?PbSEFHoeivyQDf/9SQeM/wnRFLhDoeku/r+3wwy1h4a8mNdJw/z+Jdb8?=
 =?windows-1254?Q?b8UAAIMiC9HK4IvDINgciZadTvcO0ss5xvTGM44Z6eGjOOyKLrQQ3dQd?=
 =?windows-1254?Q?U5uxVuMOt9HXkWHapj42vY834g+LEwlg9KURRU7VV7BZHqizqOya7AvL?=
 =?windows-1254?Q?DErpnGoJDvuUhD/dcOePY5WjGStVRFAFPITps0zvUL3XCD1ILyKnyuUD?=
 =?windows-1254?Q?NQECCZ30Xyxpy5v+KNJrHUR72yuGaQBYMRu68snz6T0pNQJfQnaBCrPd?=
 =?windows-1254?Q?8/LB7N9/UbvHzsFBqMXEUmaBSFjdpfpvb2OuTevBSF8Qgq4Uf5NYfYny?=
 =?windows-1254?Q?h2QJ+KE16n+opZs2vkV5851eage6iRYxLoPsE3+CftWoO09rDPVNN56r?=
 =?windows-1254?Q?+aCSEh30udn2ePGQS+2cmkFffu7ZXurpYYYLOruAScLXl/z+hZ6iApfb?=
 =?windows-1254?Q?/rmP3qQNwzGg9GXr4HDNeJzdkyuXf2N8RDn33SZeAWJpB4s/mtdQg2H3?=
 =?windows-1254?Q?DCEcyBywnQb3mynPJJi44fZ5uNEoy8zil8F3t/lBtGcI5I4UjKteKytc?=
 =?windows-1254?Q?Sh68b4Y7mmuKny7Kt/Brp2c68ggXUYdowyng1phWxRfzoU+rc/ORUf42?=
 =?windows-1254?Q?uI6SB0Q1xJ+VRw439Fmkg9pBm/2lsdD96P6ytZCXvmnAlTj2uWxcZKlJ?=
 =?windows-1254?Q?RqGiv/IuStd0qX+lPY3lmhX4M68l4OcfPZLft6aCNCDHy7D2CISEal7+?=
 =?windows-1254?Q?8FAV3o0HNZkxXIurHJnwQ1nNWi9AUaxFHs2xqwFKuq0XkGpylMUwssYh?=
 =?windows-1254?Q?16TT1rR6W8xu4A9D17xSijmZcm+4mi3J7xI2wp8re2xCqNtEiZb2Gskg?=
 =?windows-1254?Q?MZBFxmSSnQMusWBtJA1sV1zeeq5QJVk1sXY/08zWWqswXKH/AosDPIw7?=
 =?windows-1254?Q?EPc0dyHtG0QJCwloXTGkdUKP81FlJ9AxFkB1ZwOteBpSFavpIKjhVODu?=
 =?windows-1254?Q?M6dWCOTdALMdjom1Sw/Z7y7P9Cw/1EQz5K2hPipwurx++40oCP7p5urV?=
 =?windows-1254?Q?WIP9bno3NuRsnAeYp5VoNkgGqVN6fPf6HRwVxsPR8RwsG3JAw0YTL9lc?=
 =?windows-1254?Q?OFMj86wb0eE0G3EGN9J5tP7bZtP2/jrGECE2PNZP0Ggkv2c3xlfIMqZ3?=
 =?windows-1254?Q?4e4TDjbObPnk8svTfGeU8xPvk7pw2wmphysgMzkarNwfVukwstbbFhpz?=
 =?windows-1254?Q?QXWvxhdiGB5oRDxSUiuplhQnC9Vt73+tw84gHFwBXi/IJv8XuzTVNDU8?=
 =?windows-1254?Q?VpROSdJ8HAqSxsCxEuwN7kKVAEA5SGe6yE2Rsk4Sr2M3iqvOmVhpOw/+?=
 =?windows-1254?Q?+q+x9FyfXcPyXKyExfvqKEjil00te4OjctoxT/WBrd2aiUmNbCjwDrQ9?=
 =?windows-1254?Q?6vnorj7QzZIsMqSgYB/Nq7HSke73Uy7Za3TRW7F7a5vzMivdA4oRIqHF?=
 =?windows-1254?Q?jcxIgCsANGxqBWMZda0sOHyWSvfHdxU+/ag04z13lMUJx9U9O62JHixE?=
 =?windows-1254?Q?rzWoDwSpYW/EJBJJ3b9yjSzS4LzXQvvbAmljVwNLb2G1+gj0mL2JJgUy?=
 =?windows-1254?Q?QVz2ssnfm7DorIDlAQv6/kvTa5lT9nxX6Gp5stKm1V8jvbpc6TsYk6We?=
 =?windows-1254?Q?NjtsaL59WxH7u0tmkEQ=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beb14a62-7078-4233-36eb-08d9ec6d42e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 08:13:46.7035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BmU5YouNDzM0ydZkZ1XXWJi71TiFtxVmTu9q60+6t+oLreiI1UTNd5Gh/Empxj1klzZjrxFxWKEjaROLY0f7Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7089
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

Thanks for the info.

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

>> > So I used this command:
>> >
>> >     while true; do phytool read swp2/2/0x01; sleep 0.1; done
>>
>> I'll test it and report.
>
> In my single processor device, I got stable readings:
>
> root@OpenWrt:/# while true; do phytool read lan1/2/0x01; done | time awk =
'!a[$1]
> ++'
> 0x79c9
> ^CCommand terminated by signal 2
> real    4m 56.44s
> user    0m 1.61s
> sys     0m 0.72s
>
> And most of the time I was executing three copies of that loop in paralle=
l.
> I tried with and without my patches. All of them resulted in the same beh=
avior.
>
> Sorry but I believe my non-SMP device is not "affected enough" to help
> debug this issue. Is your device SMP?

Yes, it's SMP and also with PREEMPT_RT ;-)

But no problem, I will look into this and get back to you in this thread
if I need any more feedback. Thanks for your help.

Kind regards,
Alvin

>
> ---
> Luiz=
