Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6957F4C907F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbiCAQhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiCAQhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:37:17 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130051.outbound.protection.outlook.com [40.107.13.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7D135DED
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:36:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1LHjaGK+AqVWB/hB+JPlwLrH9e2lpbnTNaKyzCECBeNiKOU+VxNPLxVxtnH8aUyMeKFObaKxVCkH4qky4mIMDtnbQQeHQGi6xYzXBP4zkJxrInsO9RsBrLXRAo0ylTJdNNlF7kFl6+fSWkZ1kTdUzYHevcHWbq9V3OAvggMzfbM0Smza6SLjk53kt94prFSCI+UlAGsif+OilSqaDf3FY8uF6a9k5RydtNaopKrMLS6w1pC53DP/3CLg23RbOujiU5scczDytVCij7guBnin+K/iLKg4hJW8rCIEHyOv9NsdRoWt9dKM/x1ueNLObH+T3i3rq+N9AE4KhJyA4dUPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVRdAepwFuONBQXL+QxQjxkTlOefb8/Ha7c3WzlvClI=;
 b=QtCYGIcLTVuucLybQnf+YJ84UQaj2nPUWpHr4F8f7JzOlJ0IrM/RgJ8O3+tj5NUBjJH573uCU944JDAnmQbm6NmxTjJgOOVOV4bgZA+ONuPmV+ANw+J6dAP1Ma9kSs5qduAK7MmtH1f8Q0rOHQCswVc01S8jYbjOaxdUZPmYLC+21U4z+MFUapoAsrP2s2rVRIFqdQkyIBXhYUs/YeJb86kjQmkn0LXHp1s5z3vVlg5ezIbKd3I5cY67YYuSVNDduzraoGrPRHPTIJReHty9y+HnGzQP7jnYOSfSgYdFrLa/zmVn8DEVpA+0TFbYjy67+fsQ+yyNadQ6yBfAGTOaZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVRdAepwFuONBQXL+QxQjxkTlOefb8/Ha7c3WzlvClI=;
 b=N6dAakCvwmJ0ZKlWC22GUJi8D4elXzApc19lgCpgsNFNCTaE0whklPFVNwQc4EJrcHX5nDInSjfF9J1jSBvbmEOc9OpCjDyDay8xYnLhJM7sP/7ybmj+QHCgwoexNiXAmmBLhv2OXBFZ1B7/7EfiXjWy14xOq7zL7mPnibYkdvY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0401MB2545.eurprd04.prod.outlook.com (2603:10a6:203:2e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 16:36:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 16:36:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net] net: dcb: flush lingering app table entries for
 unregistered devices
Thread-Topic: [PATCH net] net: dcb: flush lingering app table entries for
 unregistered devices
Thread-Index: AQHYKZfghaCn9gSIwkaajp+2UkkGvayqvh8AgAADtQA=
Date:   Tue, 1 Mar 2022 16:36:32 +0000
Message-ID: <20220301163632.pcag3zgluewlwnh3@skbuf>
References: <20220224160154.160783-1-vladimir.oltean@nxp.com>
 <Yh5IdEGC9ggxQ/oy@shredder>
In-Reply-To: <Yh5IdEGC9ggxQ/oy@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 811ff16f-ce55-46eb-0b19-08d9fba1a53c
x-ms-traffictypediagnostic: AM5PR0401MB2545:EE_
x-microsoft-antispam-prvs: <AM5PR0401MB25455919A6297F4332851B8BE0029@AM5PR0401MB2545.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p4OkkmiSRyNqLQWahqzTx45tKDFvxKaEUDNAI9uIgw3JvnELWBQp/dACJyp7je1fV2LgIvXA6HMTfwUIHEY3UXkSA3uN2B7Uflw7SjWBHA9jBE877vrezVZ/LT50mGMfGR4sllzjpBlMu2BOeM9AlmncC2B/RnOtvH9boNZGdhCz1ttFVxuVu5sMs8iFmmSIEf+8vROXN1z9ikbtgkBfVvHQKaUPgOt0Mkh6QmjZawhAEtN+eYPMTR4UMw/XsDK7M5XGNud09k9LG7lkslaqyYPdNchsJmP3UVB/xcM5C00gnEjNBmbR5OLmxFbjGr4Jy17Iccj9LE/+NBEMiCloAY6YG0UMxHxVcMZnykqc5efM5fR4AcwsS98Iey/m6ihJGCOQSE8/gkGIjrbcLh4gTebC8rCnB+As40BbEXYPHnKLrq3GHFamuaMXUkNeWCeRhPahSxmaPvP5QX6wFjBuojTUb3MEekkp/DENc/4sJ4WwbOBY2CWu/LE/YAkX7sYSZ9GO+AZg+1AkKDkoqTJ+STUtUAYBg5SeUBos8zYYrlk+YQCXQIFmsn+9MFLVtlogIn1ElrI43MNFXv3Km+Rad6qxJ5Abuzd+pVrAhebHVdh25gNX4flNa6DFrGDl/5aIaBrDv+49HrEzcT02Vs17YeUnSh0oVJ8iZiIC14C8vWF5nPeih5JnyoJ0iKI5875M2F7Cr6oc36xS9HzxC7fSxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(4744005)(44832011)(83380400001)(6506007)(26005)(9686003)(6512007)(76116006)(186003)(86362001)(8936002)(5660300002)(66446008)(8676002)(4326008)(64756008)(66476007)(66946007)(66556008)(6486002)(508600001)(2906002)(1076003)(71200400001)(38070700005)(38100700002)(122000001)(316002)(33716001)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O9/gYfddYdoMCLbTYINRgusVFDLhuvX/vtT355v6IFU/tvLtwdeGsL06BlTw?=
 =?us-ascii?Q?MgZG3uQHWmDQi4Ts0O8uJcxsAUrox2uBVf+Avwz3331iEBz151oAv4bWCuzO?=
 =?us-ascii?Q?ndrRpSDsobTQCEDllJDxidTLg6G3yPbhqRmgxipz/LAlCA0xa87nnRmeAVDr?=
 =?us-ascii?Q?EkSofYlL/Gvor3dQOTNY0c7N1OHE7WfGaxsMLpd1yVTLh9p/r9FFWOqNZoE9?=
 =?us-ascii?Q?XwHZnPi1wFtStHwn25wKe/dNY2Bo4CQKa5MfzVJ4lix6Le3RO9Jvw1HLthCR?=
 =?us-ascii?Q?TOsF/xxNem8S6nsxfcnNdu1nnnZrsgb3D63xuAtZZTEeaeFnlrvwXmump0d2?=
 =?us-ascii?Q?9/Nm5J1/2d9KwWA0CDVdFgK9A4Lao6mJy8dPraRptlE3iJ5sq+tehnplOvyJ?=
 =?us-ascii?Q?+HhK/G7VYW0sGcNiZOoUL3PfJfMTY2g8tI4RAfbgA9SuwzIWnAW+OC9EopNP?=
 =?us-ascii?Q?XWYyrClTu1cpl5KVMScgocPFGd506a9jF1ftIYrvsOG07NnHbdy56ORZhpow?=
 =?us-ascii?Q?2BrObs0r/uIC5VvQhu5SZa9U3maJqz5CTu7EeLFxWubkKo+hzuiCmdkUptE9?=
 =?us-ascii?Q?sn9zxImr5ypBm72RHWOqV5+nGxOX+oSY0+XEcIvfjjpuIR25Wj3moEyzBH/X?=
 =?us-ascii?Q?Asfhg+gxLJ3D0MTzu6NqNZbEEsKkAZneyolZ5Sg8r5lqNLM+E39XYahDe/wU?=
 =?us-ascii?Q?NmH78hdLORhsb8kAWmQfjVKSNxVAn3wFu3xeqUGFBxJP92ABQZYWmBmQy8cn?=
 =?us-ascii?Q?GLmeN9u3isYL5YfdnDk+FcAT5P76rhxbRETItzSCXD6XVp/472BwkczXoRAM?=
 =?us-ascii?Q?jfoI21Fe4BFOjd01DNsm8X03MzuVIuUn1vrAottxDYJZS0lBzuvMx2k+ukAX?=
 =?us-ascii?Q?1uWDbMymUbdUqFn54B1xBh3RmggbfVR4Ej+D51aSWYrHLxXO4/Q9BvtfVmsK?=
 =?us-ascii?Q?/J6UYR+XfixyF6NkReJxWFBdMVei1Om6uOYO8J8hIhH8Taivau5rXXudCKyx?=
 =?us-ascii?Q?XqEh+ocuPxiCo96weaesW41nRKZVqboIhc1oYN8kZzGI4s7/NSsb+6Xq2uyz?=
 =?us-ascii?Q?1qr2lJOgpCFGRYzG+xrdGbvk/LejTrHS3BrkZPeb8fJjS62IViwzZi1IJ85T?=
 =?us-ascii?Q?RAW/d8TCHjmIDadXLuQxZ3LP3kniI4kg46cTQLIH+tswuvyrdjKQDcwXuI9L?=
 =?us-ascii?Q?pp5IsdTvMOf4lKOCp5dOiHeWg1jPKwUqJLjge9o0fLG3/lQHl4iE8Cmkg03j?=
 =?us-ascii?Q?HO1/I/vp9qKgoc9Zrn4+u5Bja74LdN64UYGHZOCRNAL2YeTtY8WvZ22+FGr3?=
 =?us-ascii?Q?oCDlapI0ejYQLhcIVvsEO+1x4iPX4LLkbYu2LXIOU4NQusBOLXIcgC2RG92E?=
 =?us-ascii?Q?JEWnzJg3uxasgiYVZC2PwurP0i9t5GQCn6bxiHRI2CJyzaKyMHvoWp5cEsGX?=
 =?us-ascii?Q?yMw1nKNe913N3hz0zviOZi/+/AQj/vd1ir8bwUad23brUR8ISHbB+yY+D8zk?=
 =?us-ascii?Q?1R4sQulgjdlvMGErnpl5DHzSEWzO26IbVyzVpde3Tdof1FV9ripjMWlQkOAx?=
 =?us-ascii?Q?0vpngfhrwSPKjP3t3edNseb6joIa/h0gSPJv0JVlNcRN3tvuTOFc5My3u0P/?=
 =?us-ascii?Q?Dp+avYMmpCs0HBLu7eMovwU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A59703297B8369468D0D795CFB320273@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811ff16f-ce55-46eb-0b19-08d9fba1a53c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 16:36:32.9024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7fZ2rPTHSj9OquL7DRnlN2XGyyugYtSvIRT/nxTYrDXQgeD+7lHxglPYdTwlJpco76JtEkZ6cyQzhieSE428Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2545
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 06:23:16PM +0200, Ido Schimmel wrote:
> On Thu, Feb 24, 2022 at 06:01:54PM +0200, Vladimir Oltean wrote:
> > +static void dcbnl_flush_dev(struct net_device *dev)
> > +{
> > +	struct dcb_app_type *itr, *tmp;
> > +
> > +	spin_lock(&dcb_lock);
>=20
> Should this be spin_lock_bh()? According to commit 52cff74eef5d ("dcbnl
> : Disable software interrupts before taking dcb_lock") this lock can be
> acquired from softIRQ.

Could be. I didn't notice the explanation and I was even wondering in
which circumstance would it be needed to disable softirqs...
Now that I see the explanation I think the dcb_rpl -> cxgb4_dcb_handle_fw_u=
pdate
-> dcb_ieee_setapp call path is problematic, when a different
DCB-enabled interface unregisters concurrently with a firmware event.=
