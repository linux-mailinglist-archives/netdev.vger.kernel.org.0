Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E3608B87
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 12:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiJVKXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 06:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJVKXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 06:23:25 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on0704.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::704])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC767558D2;
        Sat, 22 Oct 2022 02:39:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmh3hdopKzOri7aOa6/CqvWLZPqH3RQeOkRTCfSKrcuw+B6IqaaPQvz18z4b0ebPDDG5bpq9NFnOzZ5u7D5pS4zgQEWCBrnEFIXM/uQu7yenJP2YSqFojmGIsPIMTX+5zq5IdCp8IpBfA6Sf4ydjwezGKazUb6ogusdzfmbFnZlaORSV6UGagyeYotjrmhG1DXIb5MPH4p2vhg219F5vireCDF7qs7X1JHo3MsCBavNCmr9t6lsBp6xSGhE0j2st7hFG/J5ghgzkozcLxLiyrZJZ1u/dE19MI4kMQC6ZicfrQ5FJN8RVL/kSYuisTDi0NjtuKkVgb3F4tuyl7JvT+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giJfGDLtqc2o+ahaFbLTwbplaYbC2dMlAFVID8Z/3bM=;
 b=YFZArvM86zSEhlj2egn2uaUC4nrOOwI+YPUf35JHTQ1PkAJuGdty30yWD33lwXTBqDRcEhuIFkf7WBQwCRbAaAT15/AC6eaXg8/buE/xhCLNGX3tPAxC/uE3Ua4Cnto2wRytHc9zpIgyXWaAonDPXAyqjRls9Apm3KVRIL7j5nNOAoTXetT3D0wtGPZ4J5StEgKLgPZsFri22+WM9MevOHXf01MOkgdTR10woEs085sCYg9L8CLdkM6S0oaUgwKr3DZPGb4OtNM7D2wfBDrT5EwCJX1Kv3XjPOhJpxAgI1dgB7PBRzz5AzAcQuXGyJGujqzdkjZhEl+eU2rb013k1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giJfGDLtqc2o+ahaFbLTwbplaYbC2dMlAFVID8Z/3bM=;
 b=MOfwVinifEVmZswwTgK3Pa7RpL0XlfvYBZmiFoAZ1hEfQOFZgIQxUYrLob1/iBo4oyMqtd9ZrJETPynOszbhXRKf1zT+793p2UwiYkIdgREzA81B5gZM/6aJA00Fwdr0RsJWl7a+M4A3WuB9TQcmo3gmcK/TIWgMVTL3KeQvzF8=
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1863.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:520::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Sat, 22 Oct
 2022 08:50:21 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::ad3f:a290:9b:a47f]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::ad3f:a290:9b:a47f%9]) with mapi id 15.20.5723.032; Sat, 22 Oct 2022
 08:50:20 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Thread-Topic: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Thread-Index: AQHY5Xjxdu313+3SqEWfDCgfC808Q64aFd2I
Date:   Sat, 22 Oct 2022 08:50:20 +0000
Message-ID: <GV1P190MB2019CFA0EB9B5E717F39B621E42C9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
 <20221021181411.sv52q4yxr5r7urab@skbuf>
In-Reply-To: <20221021181411.sv52q4yxr5r7urab@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1P190MB2019:EE_|AS8P190MB1863:EE_
x-ms-office365-filtering-correlation-id: 221281fd-32ff-4998-e23e-08dab40a73a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZlwDh+osN5y/q692TYuHDrsZ9OP58upTcs4gfqaAeeREexoFAAlknbFgYPjz64n+cKQjVDPQjrwUYUE3ffeYMWf3U/Xxbvukn6lc+gjVib+1vMdh6jbJLePawL8gQ2eZtd0o3T9ZcUtvs21BzUmS98KY9q+8iuGxEJ2F5AQ6zmChlPt356ElyBNe4gPDonC9Q0eLzqLb+0FJBq9UeMT6qNGtW4Id5sAsxKNXBzUQF4QPsT0SihRb1VFZ9OKakvv8u5L/y5kTSToFkaAB9dvJg5nei170L/GjXveLn+bFmow+a9mX2jJTvxl6oZxQrB2L3dv/dnoUVYvR2ASAhYy0aKvhVtZXKYiqn9pceMwk8M5IQLmFW0Ll6Ni25SWcF3dAkliOJy10SSwtknht+B4MRVGoFfgZm/ZUcJqUNgjwzE5XVTR/jUpYOxADSSatWc+BbuxZKFK082z2P4vyGO75Jc8T9xBsAnoeTodS+T1IIa/JOdHMChnA7Qu66Buu2Jnu9B9FvazQ/9Ucc2lHLgxIT0/Qte+3eKSpEoZF/gSu80Ll8G/h0HrXdEYiR4/synApG8Y2DjO+kcmFcKqTaT6m+6IGa1FE1VYpIDrojeMD4EEXmdph6FATaBAfsi1rb9qFYWNdrISyyUSJTO2YLK4rLK6EvGFuuuStEzoenufWTi9//VuNr8reH8QvVboO/W/fWENKIi4UnxVM3UTFNfYJ8y5NLAch3Gfv1BCzdGksJKYi9ljAMD9TTYnaOCxWFEvHzb/zJbRv2k2UxLTe8M6yvtrxTknKzJWKu9SsbquZZ30=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(366004)(34036004)(376002)(39830400003)(451199015)(186003)(66899015)(33656002)(2906002)(71200400001)(38100700002)(122000001)(508600001)(38070700005)(8676002)(76116006)(54906003)(41320700001)(4326008)(66476007)(66556008)(64756008)(66446008)(44832011)(110136005)(41300700001)(66946007)(26005)(7416002)(86362001)(7696005)(83380400001)(9686003)(6506007)(7406005)(316002)(91956017)(55016003)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?q+BGQJrduyl2tWwTHG46FB/xkY+qkFhhHN40Fc+6iXiguUaCbU8AVjkABh?=
 =?iso-8859-1?Q?d8sOq9b4iX0nMa7F87dwfclpxYOjUAapOGy+EBybVrJvAjXa7XxtefVPIj?=
 =?iso-8859-1?Q?h2qPU8kALfWbRUVpWHV62orbaa1Zd9LjB2uTIUl8uk4xOIgn1J0lu/NeC/?=
 =?iso-8859-1?Q?JotLXm7QRbs0rQ5o04Eb9ZVHL2pl9gqaUxsGNtoHAbfzp90tLBc5pMwUAJ?=
 =?iso-8859-1?Q?Xh16Ih0CQopHdAQrqnB4EH0cgqIm3cMANAGzH3Na+CZ6I1tpb07Pl7lpZU?=
 =?iso-8859-1?Q?ROztCYFgQyxaxXU3FwsFg+sP2PXYmcx4FTP91yFFivb8XQ0iftTYC7HN+H?=
 =?iso-8859-1?Q?BTTaIbVYbEeFuq+p4r1ULddMvhKcNRFdlMF4rwgovb+HKa2L6St7Tcm8lu?=
 =?iso-8859-1?Q?lqJx1eYqwfDC7hj/vBEyNlOkoR0jP9t443p6dR7k8ZOgO6qANUS5XynpBa?=
 =?iso-8859-1?Q?LsPp6GiNpF15M4I6mVRLQmqGJ4lv15AjfIdW4vrGbOEsc69ykii7TAcRfy?=
 =?iso-8859-1?Q?FthbKgAvPlGGaDAT9+K35Z2f0kpu3BF7ZHyMqZiHBqxzkuaQCJpBa/C1uS?=
 =?iso-8859-1?Q?2lwj8H/ZkqcDZLdBUKGcdYampVXj0lmY8gv52V6ZSQ2dfrvCua5VG/e9Wk?=
 =?iso-8859-1?Q?MlcQ4HzAYIisSDO08sFPr8/W7T/70v8NwCESU2JXI4ZbPwXkQ7jOMvIMdt?=
 =?iso-8859-1?Q?+UbJTwCsmZrvJBFHJdbBuJN1dqzYrfnoWtRZ2kaVXmPfj3XENnsl3j4DZa?=
 =?iso-8859-1?Q?LaVcjKd6u1fgsjPRYfNDMmIcvLRqFUxY7r7Rn4CAsYeXyGhtH5/dVgdmIP?=
 =?iso-8859-1?Q?AU2XhMBcIyUgnL/yDFqJ1jJW0m/bg4pWAe3Gxowsa34cM5oowL8P2kxR4t?=
 =?iso-8859-1?Q?dcmfo7vv4zOKTE/y+ihAVWO+9+vdfDM/DI8tUA3yMZk1J62qnV6uqeaXDN?=
 =?iso-8859-1?Q?HNRA0VmVM2wHu8k+pq/kfBqW/43Zzn3tRba6JcCC5wE7UP+P4y68GRZ6FB?=
 =?iso-8859-1?Q?efB58/KTc44whDHUsS+nKTmIuZA2cCVUSoE44p6PoZNIaMI9Dem3OInZsC?=
 =?iso-8859-1?Q?ZHQ9QXa9mQIB/mApPsFsleVxsq2o+iTiZCQkVPvHyYXIA0Anei4rRqdIbK?=
 =?iso-8859-1?Q?NpgEROVUYfWu4f1AfelikaZyCECh7O4WepJ4xZ/GVXRMaT2r174DU7kBRs?=
 =?iso-8859-1?Q?Cj5eqMhcCUXDKWwBwj3UQs4+fTxcj37oY5DaBkU3Lk+B1rACSiZT+bTxRJ?=
 =?iso-8859-1?Q?5fbb4sjmfpPxLytqxWzX8Ncpt0SNoVyF07ccjLHR0AOJQIRqU8ga+q0L4c?=
 =?iso-8859-1?Q?fjzpRZgjWr3pBXRR2D/ZsbvhMEKTopANMkzH03j/58v1s/iJnAa5tv0U2z?=
 =?iso-8859-1?Q?14KzGQNl8oqzzmPS1Hz2hMovWnUjSyKrqmuPCX50O2btHWuSRkpESw5mTg?=
 =?iso-8859-1?Q?MXKBoJ/g56Rau9BDcQHdrKOK+h5JHiC7F9+wrWQVotSJqi/DOs846EId4j?=
 =?iso-8859-1?Q?M6ojZhl0SiCxtTMduBgILSZ2zYwnieICuFKczXVSjYY1NRBYk458QMYT58?=
 =?iso-8859-1?Q?Q/ZFOWirXOg+7kW547qwP0kdNjNghpTP/QNwYBX7RguMWGKbhwnS3YfDor?=
 =?iso-8859-1?Q?6jSKQl2VvilCrTsib8ABTuM8cp8Z11F/J4?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 221281fd-32ff-4998-e23e-08dab40a73a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2022 08:50:20.8383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D51UvtVc5giU+mobzRZKLWqZvBmP/zhvUT/6v6Zg1tPudDReuY+8snQjH+5lMRTFU6MRYKe6UVVOO7Y3aDGV3XRCG6/tKSUqTgTIImdGrgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
On Fri, Oct 21, 2022 at 07:39:34PM +0200, netdev@kapio-technology.com wrote=
:=0A=
>> Well, with this change, to have MAB working, the bridge would need learn=
ing on=0A=
>> of course, but how things work with the bridge according to the flags, t=
hey=0A=
>> should also work in the offloaded case if you ask me. There should be no=
=0A=
>> difference between the two, thus MAB in drivers would have to be with=0A=
>> learning on.=0A=
=0A=
>Am I proposing for things to work differently in the offload and=0A=
>software case, and not realizing it? :-/=0A=
=0A=
>The essence of my proposal was to send a bug fix now which denies=0A=
>BR_LEARNING to be set together with BR_PORT_LOCKED. The fact that=0A=
>link-local traffic is learned by the software bridge is something=0A=
>unintended as far as I understand.=0A=
=0A=
>You tried to fix it here, and as far as I could search in my inbox, that=
=0A=
>didn't go anywhere:=0A=
>https://lore.kernel.org/netdev/47d8d747-54ef-df52-3b9c-acb9a77fa14a@blackw=
all.org/T/#u=0A=
=0A=
>I thought only mv88e6xxx offloads BR_PORT_LOCKED, but now, after=0A=
>searching, I also see prestera has support for it, so let me add=0A=
>Oleksandr Mazur to the discussion as well. I wonder how they deal with=0A=
>this? Has somebody come to rely on learning being enabled on a locked=0A=
>port?=0A=
=0A=
Hello,=0A=
=0A=
>The fact that=0A=
>link-local traffic is learned by the software bridge is something=0A=
>unintended as far as I understand.=0A=
=0A=
In prestera driver, if port is in blocked state only the PAE frames can be =
trapped, so i'm not sure where other traffic might come from that you are t=
alking. Or maybe i didn't get the issue here right, sorry?=0A=
=0A=
Also, basically, prestera driver does not rely on the learning flag if the =
port's flag BR_PORT_LOCKED is set. What this means, is that we discard any =
learning changes on the port if LOCKED is still set (done inside firmware, =
if i recall correctly). E.g. learning is always off, if port is in BR_PORT_=
LOCKED state, or in a block state but also has a static fdb entry (aka mac-=
auth entry).=0A=
=0A=
The concept we follow is basically:=0A=
  - some userspace daemon blocks the port;=0A=
  - speaks with the <auth-center> (PAE traffic);=0A=
  - the daemon itself populates the FDB with authenticated MACs (adding sta=
tic FDB MACs);=0A=
  - forces learning flag disable, disables the PORT_LOCKED flag. At this po=
int switch can basically receive only the traffic from authorized addresses=
 (fdb still has static entries; learning disabled).=0A=
=0A=
Hope that helps.=0A=
Cheers.=
