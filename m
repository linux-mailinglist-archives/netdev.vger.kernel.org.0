Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3205262D5AE
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbiKQI7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbiKQI6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:58:55 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2114.outbound.protection.outlook.com [40.107.114.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D5951C30;
        Thu, 17 Nov 2022 00:58:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqcA0tWQ3NYyE2h0JYQ06yDzc5slRMwO7vkCwTWP5F4pdIbf4NMewfjmTPZAQ5gHylwBNTskqS002DP5VHHYCTM5WKVhIihTauTQSB3T1gwz9LhNvnD5cnYcUK28A7ISPFNIDoP44oTDmV0ZMEk5zwW9pO4fo1T4dwiXQDKdhu2byCBLGa2wjJLLj2AutmMAAuCVXun409cEOrdmnDTzHlwz446ovQq871p+dnvKG81c8P13gNhHWzqWI0FtkyRWS3Nh3XAxhFt85pUeU+UYmBnw4zx78LGje00ogJ2UZjDWb28UOR9vAo3IAsu5r66rwwh2RqawORG6hDknkfyb+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVBunp5TCGeP7CY7M7JcTvd53+2bEJrogVo+hzViM/Y=;
 b=NKXYicNSyGSNcZ43oafG2IUxaIc1HA5AsQ5EpmcQFgccEVVDxxFHNCHgoYJqCqNVuDVGmhRcLvHqLRCwxKzeIp2lLAC4WG+v8klURCDrSOO0wqbMD6TbMHN8T324nceCbuHbS+5I49oE+ub1TN8twMxEmOBw3T9crutpLCRU9luz/ttbrtrmgmkv3XoB1CFBpgCmyliMkpU6Eo9crFfTQp7FNt4bnVeGbA+6266LL0mrRT0Yw9bcJ1WFniw/rATpAcHEOsRC+5qoURiw0smCuvRdUgZj2/oXsFKwtP8uwKVdzrAsYnkxzMg5RjY8GrIc8VLy2/sJ3nGwuHWGtZecwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVBunp5TCGeP7CY7M7JcTvd53+2bEJrogVo+hzViM/Y=;
 b=AJ7kc6lfCH0lXbrpIbyJXjc0ixEe0Xi+SyN9uFv7ZciWNgpQuoXSWRWY1AFrFWhLoI5Rxkc5V7tux7T5EzsAmkVoSdn7Ew9OP2kVp2hTo3x2cQraUn/F/2Rp+Q4FmBqS3Res8HcRv+i3I0Oal3ld3qZ3H2vcKJejx6OUOgVMOsU=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OSZPR01MB9363.jpnprd01.prod.outlook.com
 (2603:1096:604:1d4::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 08:58:52 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d%8]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 08:58:52 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: RE: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Thread-Topic: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Thread-Index: AQHY+U28RnERYwPjUEeRyuo9iuoUG65Co5qAgAAvGaA=
Date:   Thu, 17 Nov 2022 08:58:52 +0000
Message-ID: <TYBPR01MB5341160928F54EF8A4814240D8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3XQBYdEG5EQFgQ+@unreal>
In-Reply-To: <Y3XQBYdEG5EQFgQ+@unreal>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OSZPR01MB9363:EE_
x-ms-office365-filtering-correlation-id: 1518d37b-bfd5-4896-746d-08dac879f322
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sktrfGEzn2MXjYWjaUL5eYbaIA7c7dPRk7r2Wt1lwVJ7ldFTdbFQUBY40f8pO7e/ing1g2gjlpBDknLaf3wf59bu8CCaIAYYF+037u5kNkJ1zvsZroBM8x8CzU62kDBH3GhBISCusdm5Rm9XR5MZqCNXcrEJAyM8IU7UFC8gD9hYUmKrMy0IM8o1PqunCfk5b8CTdSx8icFYl+SVBGmJVko4+sWd73XCRrKxVFD5OrGF9ME/ZbGjiyx22GEEPBH3nYYcRhRWEF9KaS8DWBUlxWuxmM4fG2kNvpg1rigV1cOI4R+mv74LUDM0O37kjfYoOEwB8qBag9+DujsZIUObC/WjJ0dNwqCyO/H3E7Ry2s4SyYFIK/3lxwrJtu/pJwsuBg4mOffLgsYTrcf+ObG3S4wJxv+6y3qv4zNg3715iimYW0JnLCpH131XvHBm//mGUC2bfIQclBTrNtQrrvbZCgdps1XjdqZxmWGQDklow7UYbsPGzaHfDmgdO5D/MBfcGWcGbmnYw0VTQFAw83UCbWXcmUg9l1GISjalvNcQq4LJtUYsbmrEoxJ3RyThkRdDzycVTZR2FQjpray3GuxaeRxNoiwqXZwzpZ8PS6u1T+H2GKj8wBj56PW+EniEEmygDPUUOKi/brwM51bWdOeXQnQVAgZhT1HZwXWM74W2t9/RKFBllXAdZ+PcFfMn+Utj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(2906002)(33656002)(66946007)(52536014)(66556008)(76116006)(66476007)(41300700001)(66446008)(8936002)(55016003)(86362001)(64756008)(122000001)(83380400001)(54906003)(6916009)(7696005)(38100700002)(6506007)(38070700005)(4326008)(186003)(8676002)(71200400001)(5660300002)(316002)(9686003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zMgkrnbe7O5AnczKcEXpZY84JOYdbuhTa/V3k/2fnaA/Km2NofV3+Ongf4N4?=
 =?us-ascii?Q?MROhVluXyAHc79YYZd59VUSrGIRnecldfJtCiHJ9wkTgRj17O6QgLLdy2f2S?=
 =?us-ascii?Q?F0T4FFtlSD8KraweJNLf3TQ6QOHqnPLc7k0JX9O4i2TaMbPFFZkvh6RfkyM4?=
 =?us-ascii?Q?xF30idIIJXF+fwjvxZs50bW0GEorLE0Iij9ySpw5/aIA97/H1FPhVUJQ/69W?=
 =?us-ascii?Q?dXejAx5b3Tv0D8uX8dP2hTfyr5u8eVF4Iosn705LvlZEVX9O2J79H6/Kf1kA?=
 =?us-ascii?Q?OxBJYZ0EI7h+fKQu2e1u70+3GPGmsiq6TVQXOOCKRp4QGJbKowMPvFO9ZghY?=
 =?us-ascii?Q?y2xurSa+KRApH0lPymaGln9cBGPYQ/r34CnRlhQtb1GdY4FpfDzfRgEBq+Tu?=
 =?us-ascii?Q?6Voun6amr9OKhc3NEaOADMy7iDT/gSD1NWgUSzg/kb27w6KDvDy/KnO1xPaT?=
 =?us-ascii?Q?fmpHJwI/4DTxkN7ipQkFZvXWZHhViSjMrUSlsIGm99AGocdbCkqy0o6GECtd?=
 =?us-ascii?Q?K6gugAxHocZCJ9rYmM1HkQzwNIht+1F+uV/LpkAGVx7y/TbHg2NCS4ae9qOF?=
 =?us-ascii?Q?et3VWs8nEbMJzFgu0Zmp/4y1xo0lDcwj9IMPFV7gQEVSkYk1ExKwZpfa4dWM?=
 =?us-ascii?Q?e4aAjGUYhcBcq47nLC+qqEy3HboECmzjflI2IIFh8q95/Djf4VdeyEEuk+JI?=
 =?us-ascii?Q?Ew4iy2mua2P4cMGddnAYe1g2VLQcK4BNLtJXMEtULVE+VyJJneharka0hLQS?=
 =?us-ascii?Q?lr/L/DnlINzjRrzcxStZlAKi3XlHFcT1GB/6oxpEkeH4WFd1FSs+XLBiIvEJ?=
 =?us-ascii?Q?S2NlfTlxd9YkxH8ypnTfaHufGHZm6HMSOEkPZN1ElXhBNOMiebcy6q+dB+i/?=
 =?us-ascii?Q?0rYA9dzVlPfPygWu4AjsWmkmyZqZ9t5WqNUVFRQd0hIryrAXa3nG54LnMusP?=
 =?us-ascii?Q?cZpQ4KMsPbPM1iKTNdAaqC0SxErSuFb9bTfkT6dmtqrEaj5s80dRhXCDuKNw?=
 =?us-ascii?Q?v1Cra9CJj/ZzI9ir1Tfp79Rz305tp0UFIVmM2Qbsx+NPEAxBrD2xFogs1NCT?=
 =?us-ascii?Q?BNMkUQQaudlIB7X0X2veqEkeqXBEUHgJkc5ARFp5cG3PmbftgWbkLeuowfs6?=
 =?us-ascii?Q?qGmyxTkv/w+c93lEstqt4k86UtkHPsMMBdYomUnD98ayjnGNF4GfGwbFGuCr?=
 =?us-ascii?Q?etjsaHkLtxQCHeuJEpoOmx0uNgW1g1zuiUz30E0FKSQ7ssPpm00+LYrmSs8Y?=
 =?us-ascii?Q?VXBq2BJj4cw0dYKfbtV+3FYcPjoZbZmHT0K/zB9AWasVzCN8QW+UyKrbNP3i?=
 =?us-ascii?Q?hEb0nz/frxJafjmX95WO1H+uvqI3ZxoWoWMPcejXQ1w0TieC9YkNkVrqnLpY?=
 =?us-ascii?Q?tBEBnTonmXuWFQ+VWTPaD1hrrHewxVPV67ykyd+lX6+YInjcL91hlzKoHez2?=
 =?us-ascii?Q?U1RyadXUDBSKcp63RbG/SD3MO0Id5R1HlZZa8polxfOv1CdugmT4onNWdKC5?=
 =?us-ascii?Q?k3VpalUmEbqbHK1CVmQhy3EkTybJUsg2FA4wJddVjQncrUaOMZrdTHXchGft?=
 =?us-ascii?Q?AXPrs32wa4Z6+Ct/gyuOtLjMfj8SeHcQGsbpJRaAiUJGuwab5ZTf6WxWtPPS?=
 =?us-ascii?Q?9aH0f8615UgyDXL2lzx2P3lT7COnYZnE6/av52SL6Nx06ZCZqCUp5NAkqOsW?=
 =?us-ascii?Q?r7gdHw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1518d37b-bfd5-4896-746d-08dac879f322
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 08:58:52.1910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wDFBp711whS7euaVmLJWxl8X/hPObQur7P6MIptt1bLLQOpD/IijCFjcH2LUdBl8KeI0wqEBwZVy99SVByB48gpztz/xuHJLvghvGOhTG/NGthA3jFN0pHrVezi+q/5I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9363
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

> From: Leon Romanovsky, Sent: Thursday, November 17, 2022 3:09 PM
>=20
> On Wed, Nov 16, 2022 at 08:55:19AM +0900, Yoshihiro Shimoda wrote:
> > Smatch detected the following warning.
> >
> >     drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
> >     '%pM' cannot be followed by 'n'
> >
> > The 'n' should be '\n'.
> >
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet=
 Switch"")
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/ethernet/renesas/rswitch.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ether=
net/renesas/rswitch.c
> > index f3d27aef1286..51ce5c26631b 100644
> > --- a/drivers/net/ethernet/renesas/rswitch.c
> > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > @@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *p=
riv)
> >  	}
> >
> >  	for (i =3D 0; i < RSWITCH_NUM_PORTS; i++)
> > -		netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
> > +		netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
>=20
> You can safely drop '\n' from here. It is not needed while printing one
> line.

Oh, I didn't know that. I'll remove '\n' from here on v2 patch.

Best regards,
Yoshihiro Shimoda

> Thanks
>=20
> >  			    priv->rdev[i]->ndev->dev_addr);
> >
> >  	return 0;
> > --
> > 2.25.1
> >
