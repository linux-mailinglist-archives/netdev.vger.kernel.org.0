Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9C5F0CAF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 15:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiI3Np6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 09:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiI3Np4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 09:45:56 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2123.outbound.protection.outlook.com [40.107.114.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EFD5D0EA;
        Fri, 30 Sep 2022 06:45:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eaw0dY4Jrj021Pe2Vx7Ou9X7kU+gzsF8leLrmthCIyZ+qCAWcU1F2VIXP/uh1UrPyW8iqToT7EeybGouZoUETy0hIX9Y4+dx5kiOVmguj6gHm3zCJL11n79XS9zyLAkdGF1ocigu046me6PsU31EPlK4F0/8Icef4Dob6Ncas/KD0iNrURoSboQ1izNtnI78rPJpFzMOB0qyQR8zUJMoau/gd4sOWxOSGMsHzi+VUdQK/hXyL/Di3OsFCniM8CLyY6pxsF+3CWLVFUAra5mSKxx3fMxQFY/l1PNwMQUITSL0TQdcFpwJQ7CA1xOZcXgP7Gy1F9IlFX0TayBvLURFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLeJrb9p5g87gnUO3Yu1euFvtK9fGhNQZWG6DQj3YJc=;
 b=bjYsTVsI4KJlX7R1uAJ0fYDWgW350nMRew2rST1RenrpLyWPU8d9p2+v9FaMzaFBjfdwXQ7lRU8JArHDaau+dwl4VGgrgzPhlJ2lpoSqcfyFPNneeKxt4jdU63x2Q6jwyMAn9TIHsg+WgaKx2iNB4EMlEB00Z4Cuxv3FQs6UeJe91R7Z3yabO5c5BXyOI9k/4n2ekeXAchkQfZIyrei4jIRF5EDFygYYvido54d5tzSrC1ftGWhI7yD/E4NC02vccePlF9xe9KsXGr4dnyqkB5gQIIYJhjE9axvjnf7nJGYUK/OuOuDZcOBbeR9CSYLtbQcmEb6X+cXFom1KKTsitg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLeJrb9p5g87gnUO3Yu1euFvtK9fGhNQZWG6DQj3YJc=;
 b=Tt3829W6HIDL2aW85otn25BSHMHmBlL3KeF+KcS+q3kNRP2FhQof3+kru3oIkvin6VG2pdnOA/q2fdoqZOp1g9QaeFn6L0h+5GJHDopE/ScvsCf7lh52zYEuqm+E2Q9Z7eqcMdq89SJ8D0GcUxUpLQS+Qh8fjhrF2SZutiJ2+sk=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS0PR01MB5858.jpnprd01.prod.outlook.com
 (2603:1096:604:bd::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 13:45:52 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 13:45:52 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHYzkQbCGZNTw1MNUuaNx/SR8stKK3s/34AgARIsfCAANSngIAAruVQgAB4MACAAQobwIAAeWqAgAGUAQCAADBzAIABfLfw
Date:   Fri, 30 Sep 2022 13:45:52 +0000
Message-ID: <TYBPR01MB5341F83687A3D3C9E0DA5437D8569@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzH65W3r1IV+rHFW@lunn.ch>
 <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzLybsJBIHtbQOwE@lunn.ch>
 <TYBPR01MB53419D2076953EB3480BC301D8549@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzQ3gdO/a+jygIDa@lunn.ch>
 <TYBPR01MB53415F3D11FEBFFC8BF09FE0D8579@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzWzDEqCFYqqJcr0@lunn.ch>
In-Reply-To: <YzWzDEqCFYqqJcr0@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS0PR01MB5858:EE_
x-ms-office365-filtering-correlation-id: 54266490-f5f3-462f-2990-08daa2ea179a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lvzy62eSqsmPP+qEkp+Qoh6D32afVTWE53LiKs5V1H7PRajMRzj28AUCjSk3Rewzo7pNMoP/U9hKX6CyPSHrQ6TuxMd1VdZPK+oiYdGducFABZoXQnR3STittdUXbzNpeFcG6/yGch8ZRwtGLEnifSboeZrwtsqbirAY09WyDUcZAcnV0NcF/HI4PwzrETGVs0RFXEzYG6btVefVaAHfWbohfLARozS+cwCQYbWRsNjWidc4Npg2Fb6DhqBeBt96FftwkHta8YocBzc8G7QB8+n22ZTfJjzrJOCiq57pNnqD4KMizPXJHvtVyTuQ18bqG0TYk1GKFq/fAcu6rhKboW2gNS9JJ8WFcZf9Yq7XOy01jnxkGDQfrexjYHa0aImaYupXdBBk6KEaWj3Zd98B01h4lmyVO0nj+MPpIg6CJc4md5DbEXSZ2mS31E3c6J3F7Ekb3OVuA7bC1eNiAD4lESoSrms2dJ6UCk8Bs+pgMEp27WkRIx9FbOkEWgOHmDMX64AFrOOG7lRf96UWwrtxr+rcb4hLuQKYOsJr4TzvXVH8JSWE2UJ54F9Pj/8oXVbu3R9nsvko1XrYdBY11SCAdcEjKbnSD4eYKD6BnKKm9YuBqe6c719g3WjUnzI/NYzfOh7WpDjMZO9s5fuHMRBTE8oTRskpca2kAdVCEWzbPvfkMoTiPnZJOwjc7k3GJi9Rtdcaz06gHaKKsENcNbRtJ8l2s2vm4G/8dowhMa2QrP0Va8Ss0lIaO0RE6kOLbpFx6SujXW5FlW5yPenjxwUdYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199015)(316002)(71200400001)(54906003)(66946007)(64756008)(66446008)(66476007)(66556008)(76116006)(8676002)(5660300002)(7416002)(52536014)(8936002)(478600001)(4326008)(7696005)(6506007)(6916009)(9686003)(41300700001)(26005)(38070700005)(83380400001)(2906002)(186003)(38100700002)(55016003)(86362001)(33656002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wr7wCnXyNb83RrvEGgGlCj0GNcgfoXioapT0sOLmds99E3+DegAwpbamAljT?=
 =?us-ascii?Q?8ydjSImcR5L6LtCuda4JeohRKRVIZC6bmFzk2xto4LaVirXQZnx1OR/pLk3v?=
 =?us-ascii?Q?vuAjQJ7TcHTCs1QPQpXUVmlo0oIl3T0kY1ExjfD3uXveux8+8ioP8/r8aXt6?=
 =?us-ascii?Q?8xqREJA7DJoxgS8ZBspbhabZUhvKEniu6J+HY+x+Q1hew45901SRo9oZ3uzC?=
 =?us-ascii?Q?67snh1KZo2f7G7ww73dnMtm/19pEPUz73a+wFYLahDcV+38Fuxnzsrkwy/cU?=
 =?us-ascii?Q?1rnHQ2caIxVTdjLvqy9a309EXA3JOqdJPdK+ZJu7fZU6/Qgpu9qB/cIdcOxR?=
 =?us-ascii?Q?HMbXHA9GTT0PmTe2VY2k4lmI36Dzj7wl5UZwJq4UpXNev4ZiVG/cJnwZNLMs?=
 =?us-ascii?Q?Z1iTD/JZwS0NqIHwj+bFRw3uI5+v1DvAlobtmtoE92aGUcCv5aONrSWY7uxY?=
 =?us-ascii?Q?i4r5YkRInU9bA1TUeAaWSDQa5+8yARoJZdBFb9kFHH/iyXVt16bzR9LgxuiD?=
 =?us-ascii?Q?UzQdPOVF54BWS32kVlu0fgz5UuM+uoOxsmdWKqJNuqdAfJgIWYDq3vxzw/dJ?=
 =?us-ascii?Q?OOiEk1tc4I8nxBdJFEofHbuUvExa7EL3u6FAzZXqWLSQozu+nb5qKhA+ACux?=
 =?us-ascii?Q?Q85plgrWblXNIf9kbmmjbZfHTibiP+7cMcvUO1vhnV/VAbE4KyhXVybPt/9+?=
 =?us-ascii?Q?WNpmrgU6QMLrFoS0RFUqFUhDbg1x2SKdepXwziGs+sND9r6oYnoz/JYPqVbc?=
 =?us-ascii?Q?HM08GnGrkBWN/yKooihgRkyOqbBPkyUEjqDz74XguiXTvEWKAtg26vRS04MN?=
 =?us-ascii?Q?aIZj0p8rKd0kLD/LuUfJJzNFveZsk2wo6TbVI+WQWZSdSyTA5uaM92NvaAQB?=
 =?us-ascii?Q?St51cigeB2IXI0QPT1f8yFNrDcRp1KRQkDJfiWs5IPThOOSeqLtna/2m4p01?=
 =?us-ascii?Q?jkdYJK/s2k4nprvxzSHn/9bk4fBJA6pJNLvWBuGLhg0QRJjS/iwc+Q0ll4xI?=
 =?us-ascii?Q?5w4Le3NQ8wEaPPlqKbW7UggVFg6AuGlyfK7sNn9IiqM9N92mQdVeCCQWebKc?=
 =?us-ascii?Q?UyJs30MK9U2VP30Jr3qaaujBeoscO+AAWAEyMHTpqu5S3M7kMTFTAKILXwSB?=
 =?us-ascii?Q?sXAW2l2AkAfrzJcRM9Z0xtB+X/NN7d3ojMMfeFuwoe5g+FtPTRO19ChKPCLS?=
 =?us-ascii?Q?E04n/C2rKtytXSY/lAR4l45OEhZ59QbQ3rGAM/HGb/i9QPYpdXWNI3cMSenJ?=
 =?us-ascii?Q?a4GciKTX6NK/MxXwgCmaQ0zRnIP6ITNL+d4ZNzMWY1GD10ZoLDAzm/wF+IKV?=
 =?us-ascii?Q?zR1A7RWksU7mo8kDFQKwLNKWQaxOMmxUxvLMCeMSijZejHlP4GvbzIpHFuZM?=
 =?us-ascii?Q?WaTjgLC4hfRloY+yST8HrhMPNJt69xqkX/TPEctqjKgooVahdgwmnf6+fZF4?=
 =?us-ascii?Q?TQjxpMIXBSW/zUvAnz5GxRSKVwW4Vlr4xqVDpfjLpDpVCJyEJlDR40JK4ofk?=
 =?us-ascii?Q?+er/JBrPe0j6wFlc73d1WRxFiLFBP3LXuBo4mdsjvRKykt+t9+btJ0BHeuJB?=
 =?us-ascii?Q?2uudNGCRuumVzhq0tmBYHS+i1SXfg9NegvHCGL+D1phua9glkzpngWRkFrDi?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54266490-f5f3-462f-2990-08daa2ea179a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 13:45:52.8060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ba3c1JqtkneZinW685crhMrSENN5IJNWYgEmy5BneLtwVAMc5BjaYhAGpUKeRMyOvafdrc7U2k5nH5eRrR60ijmf3dSBRS4M8bufXOpgshAsww6jOXX2PUBkzAHqMFHP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5858
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Friday, September 30, 2022 12:00 AM
>=20
> On Thu, Sep 29, 2022 at 12:22:15PM +0000, Yoshihiro Shimoda wrote:
> > Hi Andrew,
> >
> > > From: Andrew Lunn, Sent: Wednesday, September 28, 2022 9:01 PM
> > >
> > > > > How do you direct a frame from the
> > > > > CPU out a specific user port? Via the DMA ring you place it into,=
 or
> > > > > do you need a tag on the frame to indicate its egress port?
> > > >
> > > > Via the DMA ring.
> > >
> > > Are there bits in the ring descriptor which indicate the user port?
> > > Can you set these bits to some other value which causes the switch to
> > > use its MAC table to determine the egress interface?
> >
> > I'm sorry, I misunderstood the hardware behaviors.
> >
> > 1) From CPU to user port: CPU sends a frame to all user ports.
> > 2) From user port to CPU: each user port sends a frame to each DMA ring=
.
> >
> > About the 1) above, the switch can have MAC tables and sends a frame to
> > a specific user port. However, the driver doesn't support it.
>=20
> In order to make STP and PTP work, you need to be able to send a frame
> out a specific port. With STP, that port can also be blocked,
> i.e. normal frames are not allowed to be transmitted/received, but
> these STP frames are allowed. You also need to know what port an STP
> frame was received on.

I understood it.

> So the switch probably has a mechanism to send a frame from the CPU
> out one specific port. And frames received from a user port and passed
> to the CPU should also be identifiable. There are different ways of
> doing this. DSA typically has an extra header on the frame, indicating
> where it is from/to. Some switches have extra bits in the DMA buffer
> descriptor indicating the port.

I'll looking for such a feature in the switch.

> > However, if I dropped specific registers setting, it doesn't work corre=
ctly.
> > I'll investigate why removing speeds of PHY didn't work.
>=20
> It could be the PHY is using SGMII, but your MAC needs 1000BaseX?

Both the PHY and MAC is using SGMII. For now, I didn't find why.
So, I'll continue to investigate this issue too.

Best regards,
Yoshihiro Shimoda

>    Andrew
