Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756652EEA76
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbhAHAf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:35:29 -0500
Received: from mail-dm6nam11on2128.outbound.protection.outlook.com ([40.107.223.128]:18689
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727858AbhAHAf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:35:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XekjpTUPZj7rJ6L44zGqYcXddhWj5Rzh0r6UwWCE3vVAP9qUUCKulxVN486n4EwBokh3xy63omZMjQiOUS5ePvE6mXvZFWp6+5Ej3hwkekZA8RGQpuitwMGn87YS/D/14UfEKeeGf7utP6GIfjKIDQOnFMz/HHvTntCvoFEYDTLs8x+zKdd4Qr6czq/WhcBUoIfmrcrFLLNt84vPfY87pIaI4I9dEb3lMk/tYq7l4N183734oNvB2RP0LC12J4EYH1LUrdbuDXenQxbyO/MgseOukZ1bA+7TPn3/5m3htKK19HasjVj88zayERW1Ct0sFKxbTmv2IoS6oc2ukf9S/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqkJ/th9Pd4gfGNtcUkRAn/vdwxGAaShUmCWDGd8yio=;
 b=nADzwpbAvpuRGc7SFfsWgscJlkjyZbm6A7YWDic2eOuh5t0vDqw300ys5QsFyxn7bxy8ZlXeC3PgPMyktDzHNSZogN4YzcRbzkp68JiGfMqZofNOoxvWHns6bm6A2v0dtTQ8O/bSKtudpbf1Oud0mT0o+PbaoPCFAvlZaqiUDhiYHLCULTm3NG6nypCnUUAZL974DbUIzW/9QUfLHvKn50epv4sHSZjG9P2Prinh6RhNwrNQI+ydQqd/NguZmd/DGf2ZjIH3gHmGpzfPItCCSQsQFjFwIiASHNtZhEiuj5u4X1BCcI9EawC7MaI6rY6CxB0FHI10nLW/sQFWURAWYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=morsecom.com; dmarc=pass action=none header.from=morsecom.com;
 dkim=pass header.d=morsecom.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MorseCommunicationsInc.onmicrosoft.com;
 s=selector2-MorseCommunicationsInc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqkJ/th9Pd4gfGNtcUkRAn/vdwxGAaShUmCWDGd8yio=;
 b=Tm+kcJNinAd+KtoEt4GVJiXHTXSBw5aqOBcUn+WqKMus70hJWex5hWGhQycY9o1d+Zj4SX6x09B1HBfBeHV8eqtYQGR4RJGuX99pak6eQnqMXkKa1iKLv5PbaE5xQazRjYFxJtYFBHRpfXuaMgp7KHDyh26Hj0cahQ1eRCW7AAs=
Received: from BN6PR05MB2962.namprd05.prod.outlook.com (2603:10b6:404:28::15)
 by BN3PR05MB2676.namprd05.prod.outlook.com (2a01:111:e400:7bb8::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2; Fri, 8 Jan
 2021 00:34:30 +0000
Received: from BN6PR05MB2962.namprd05.prod.outlook.com
 ([fe80::81f8:5744:c4a3:abdd]) by BN6PR05MB2962.namprd05.prod.outlook.com
 ([fe80::81f8:5744:c4a3:abdd%12]) with mapi id 15.20.3763.004; Fri, 8 Jan 2021
 00:34:30 +0000
From:   Corey Costello <ccostello@morsecom.com>
To:     "noloader@gmail.com" <noloader@gmail.com>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
Thread-Topic: UBSAN: object-size-mismatch in wg_xmit
Thread-Index: AQHW1xTBoapJy1K2eUK0f/WmpHtAF6oBRT0AgAAj5QCAGsg6gIAAbyYAgAABzACAAFuVgA==
Date:   Fri, 8 Jan 2021 00:34:30 +0000
Message-ID: <CA5B0431-801C-4F2E-85F5-E329F02D364A@morsecom.com>
References: <000000000000e13e2905b6e830bb@google.com>
 <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
 <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
 <CAH8yC8na1pNcGPBrfuBwyNbfC4JjOOo_xHODAkbjs1j-1h0+2A@mail.gmail.com>
In-Reply-To: <CAH8yC8na1pNcGPBrfuBwyNbfC4JjOOo_xHODAkbjs1j-1h0+2A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.20.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=morsecom.com;
x-originating-ip: [2603:9001:420c:3ba1:b546:d664:6398:63f2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ef24ac2-1e70-4082-194c-08d8b36d2992
x-ms-traffictypediagnostic: BN3PR05MB2676:
x-microsoft-antispam-prvs: <BN3PR05MB2676E165B6AE4345DCC8ED43D0AE0@BN3PR05MB2676.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:15;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8P5V12V2711/KXL6BqU5Rnu+V/bI6Hid6t/xx5b1gvNYlJWXrnpVwcIATf20u9KqNr30OQrF7d+rsUUyHBVP9DqzkQHIo8OjPF+rJu5dxHc4ZvGh/AotZLdt0136y2ocNorX1nnQwAKFvdv85Jt2QHQauJtSZ0CzbnKxf2vj1w8tOSuTMlOvRwTNYhDuZTKZdbpCdrbiHA1cHYZn/dYuCWw66uLr4FyTqCLSf4RMNggFxry5lCIsxmZqN9pspAqC5QMhbsGFzj8WKo7qU/azV5v4OOhazxP5/NJVQYfoZiIY/hbM0GjcdmiMA3Itg2I2uy2jg2sL+BddrtxUy5pRZOZwrd/duQfnw23tMSB9m4L2pEnaBs/PW4D+HUgDXtYAje0Kwva7qoKY92cUsik2XD84z9bOJtGuv1UrAJygEOMevQ7tipQ0hj5wR3Eosp6TloWfe2M2JNwE0WII4rMWmcmrqnM68R+57ABRQFvpFOjKMqpXmKUtXnfH4T2lKBCHrwr1E4mAfHQe4VQD3B3/3qwoLI6BHGu4lQwn1OY9i7ARp60VZBhvST/thfQ74DYMBPHslgqtfIemAJgo09ZmD4kvsa6vEa1El0kMwzajhm0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR05MB2962.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(376002)(136003)(396003)(346002)(83380400001)(6512007)(4326008)(186003)(8676002)(316002)(2906002)(16799955002)(54906003)(8936002)(5660300002)(53546011)(86362001)(33656002)(2616005)(66556008)(478600001)(64756008)(66446008)(36756003)(76116006)(71200400001)(6916009)(966005)(6486002)(66476007)(6506007)(66946007)(31884003)(99710200001)(45980500001)(358055004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?c20Zwc4Wn9xQkr4XxS62q2CXQSWAMsgNTgUjSlBLVhF6yJMmlJOVoF4uuYpB?=
 =?us-ascii?Q?JbenxCUfTUOqbhUE3RnLL1/xZ4g1LmtV1vBAiRCIr+CtqRz7DVEL2J8+GJte?=
 =?us-ascii?Q?EtvELE7DA/uA3hEeg7huzOJ7Qg4pI3f1Yn/GcHE1bt29bGfYjwUSMi6ANEMm?=
 =?us-ascii?Q?RYtViRlDKNAYM3cfTVSJEGR2oCZBxZHmWEyk749wb4nZU0SXd9NmRcIEF73x?=
 =?us-ascii?Q?pvo/PdSfCU3K7Zg2+M+QmMcya59Zz8P38jvQXzcrVvtfLN4KjKG7LyqlRSvR?=
 =?us-ascii?Q?4HIYzrl5d9I62EY85zLTCP48TWqERyZi6O1AxyheeiGI0TMpZsqkzPp74o5Z?=
 =?us-ascii?Q?k2Z9hsi9AEW0qE8MYGyAtx+y/0JdU7GQQ05ahLfDKO7oaKP5MPJs29Fd62zX?=
 =?us-ascii?Q?1CJWujsHBiFZdERH0I3Q//xMMcUD54aFidZqynLJ7CZKzfrhiWMsA7RTfI/6?=
 =?us-ascii?Q?c33buPn/9HE7EVD5BEXolXODSJCPCLMVVNj51ZQ1wyNQ8oUf7SYsF/4N4EeL?=
 =?us-ascii?Q?/RMti8wQoD/i0DJUXwgbJ8OMLRJJnGffpwpCJDJAaGR4R0mkm744xNQBYnWA?=
 =?us-ascii?Q?k5KoeMzIM+UzaOmvrKcZgJ6uZStmpZlmn/zwxK11+XyOkagjAqLLbAf75SEA?=
 =?us-ascii?Q?KeDk07h4SgcgV68YpSsp9TDunFBtixJ7PrY9nrM7/QLVlKBLC8l6kSKR69sK?=
 =?us-ascii?Q?ZLZIuBbH0N4dFOuFVVj48rar2tD83detZ2duu+XWOLtsxxhM/st00ekLFbTi?=
 =?us-ascii?Q?tooCgP+EglBeaSOZ4jq8nLUAoXdXvE2aXhD8s0Vjsxp6vPKegLAZX6/GekDp?=
 =?us-ascii?Q?90dJmsCT+a1NGJ3d19R1LhmK9I8zpejIrme+UycS/9XYQ4G9XArtJ1JeGboy?=
 =?us-ascii?Q?NtO6slEqMgIi/prLX6I7qrSj5FpWdp53rUmKUr3/vvPGLOldVgYEJd1ldq6I?=
 =?us-ascii?Q?MWrmgUXZak0G28P/jjOU5i0FXbmahMaERguAp+i2bL/vVy8D+IyRRUIvJOjB?=
 =?us-ascii?Q?OJH1TF84/H0lTp2qOJg8P3JySwasQSaqptStILYalxGl+vShGx/Ih/Z81F9H?=
 =?us-ascii?Q?jIZCYy5c?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BEABC203CDEBDB43950D56703E811F1F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: morsecom.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR05MB2962.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef24ac2-1e70-4082-194c-08d8b36d2992
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 00:34:30.2093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dd11875b-80bd-4856-b2d1-d8b42fe95638
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wy7V4jKymT7wokW5ew706WRlRk4CS9O8PsDXjeeRrcAqPDrj0QTmYvONQgzrL+BETmJ8gTTv5elyB3XWT2ae1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR05MB2676
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get me off this fucking list ffs.



> On Jan 7, 2021, at 2:06 PM, Jeffrey Walton <noloader@gmail.com> wrote:
>=20
> On Thu, Jan 7, 2021 at 2:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote=
:
>>=20
>> On Thu, Jan 7, 2021 at 1:22 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>>>=20
>>> On Mon, Dec 21, 2020 at 12:23 PM Jason A. Donenfeld <Jason@zx2c4.com> w=
rote:
>>>>=20
>>>> ...
>>>=20
>>> These UBSAN checks were just enabled recently.
>>> It's indeed super easy to trigger: 133083 VMs were crashed on this alre=
ady:
>>> https://linkprotect.cudasvc.com/url?a=3Dhttps%3a%2f%2fsyzkaller.appspot=
.com%2fbug%3fextid%3d8f90d005ab2d22342b6d&c=3DE,1,RVpgZsRUCGs2jKlumiMAMnpeO=
F4QdiW5h8GDIsBJPz-orFNwvwCXnceC9n5Bhr1h-G2EsU0tlC7N4QUpHuF6tIMI7tTnBoRjAo5t=
T-Bk9-Fhe8CppuOL4mqdkA,,&typo=3D1
>>> So it's one of the top crashers by now.
>>=20
>> Ahh, makes sense. So it is easily reproducible after all.
>>=20
>> You're still of the opinion that it's a false positive, right? I
>> shouldn't spend more cycles on this?
>=20
> You might consider making a test build with -fno-lto in case LTO is
> mucking things up.
>=20
> Google Posts Patches So The Linux Kernel Can Be LTO-Optimized By
> Clang, https://linkprotect.cudasvc.com/url?a=3Dhttps%3a%2f%2fwww.phoronix=
.com%2fscan.php%3fpage%3dnews_item%26px%3dLinux-Kernel-Clang-LTO-Patches&c=
=3DE,1,7u3-jWadklYo8ai_XrPNvjnu46LLAyg0hqsGIaMPaoQ5UxtcNM84jrHUgSg4VciXKk9X=
VpwgyBwD85LbbW5_j195jSH6RrAej45I1kr_XfQ,&typo=3D1
>=20
> Jeff

