Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AED1BD80A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD2JSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:18:07 -0400
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:62944
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgD2JSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 05:18:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KayasChXqlWGh1e0iiA+mLN9XzWAev2EbA10e60ljTrsJBO8X8rGS6lR/xiK8VGG13h02EYXegATsDgobToiGQmojUBqSAGdQyRdMShDjZe6YKLe3SHqA+20TWAAsHDQ8zeERjTmu/OCsUiCAPe5nMjjxc2Ev8GUNGaog5c3MSI6WipuWUJxFB+Sh/oGLSu/39RnPQKk3jTjtmzYkqTVX4yMthHLBo/zBnHk1+BFPu5r8xB1M8Xrcug1QnhiSxgK06b/KjmBs0eTCiJHjTXsnb+PJpXNfdYuwU/RPM0Y/dgvVqT17L717lzBjhM7wiFBkGNNsVwQW4P1npUmK7Ba8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItPTSB+hajx1cJjDprfUXT+YcpwWeD4djFuOZV5b1ms=;
 b=MQ0QJiPlrJLs/Kfu7cx16SG6u0Zg+G1uUZ3R8JJLLV5V9ML/sLuE1PAzh29f+muRccEC2oSPPvNPK0hBH4oTUsT3ZwwxvNmxaIlJqIJF4x2xlnJkQ4Vgx+CSzbk74iQokvZMShe4fGT5/OlZ+Be0lZafZ/8Hj48sxq5eYycL3mmmIa8ZgkCWc84j3ngkXXJESmOyKtUlKgVbRmCDLLHoJkcEZPkZ8qitayXon7iCWHZccu8/ENn//uw+MdlWHcIIX6tLWPIopxPgOpJ9+qe13Vp2FknMN8LURZI+OeB5ALhA1VgWiHQXpSPjK9EuV16xPLhSb2HNsHt8Bp3y2lAY/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItPTSB+hajx1cJjDprfUXT+YcpwWeD4djFuOZV5b1ms=;
 b=RDu/SAoWYH/En7a0RopcEGvk7JJYzwU8cKPdpgWXzaN9P1wwh/QZR2bw9NIpldi9agFbXcZ5Cd7kssJSiddtBii+dwe6+A1HQcEUIDqgtdRjFGeDMDhb58tdJCEdevxE0PGlKPgxpURCcGwEToL+rfKx91huqVRvcXJL4sA6GE4=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB7132.eurprd04.prod.outlook.com (2603:10a6:10:12e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 09:18:05 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%10]) with mapi id 15.20.2937.023; Wed, 29 Apr
 2020 09:18:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] dpaa2-eth: debugfs: use div64_u64 for division
Thread-Topic: [PATCH] dpaa2-eth: debugfs: use div64_u64 for division
Thread-Index: AQHWHgLkhkz7UvZ/1kmdjpFTNc1tHqiP0RVg
Date:   Wed, 29 Apr 2020 09:18:04 +0000
Message-ID: <DB8PR04MB6828071573BDB80739446C38E0AD0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200429084740.2665893-1-arnd@arndb.de>
In-Reply-To: <20200429084740.2665893-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8594c73c-3379-4f82-1586-08d7ec1e395d
x-ms-traffictypediagnostic: DB8PR04MB7132:|DB8PR04MB7132:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB7132A070EEEC9DDFB85899A6E0AD0@DB8PR04MB7132.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(9686003)(33656002)(26005)(55016002)(86362001)(44832011)(4326008)(7696005)(6506007)(478600001)(71200400001)(186003)(5660300002)(54906003)(8676002)(110136005)(2906002)(8936002)(316002)(66556008)(76116006)(66476007)(66946007)(64756008)(52536014)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /fFa1/JT+PyXKrC5L2X83XMHXLIvcCsubtKYBeNGJGugcp+uTSARzPrLzfsMJm0Q89sIRqTDTPQAqAX/BwD3IZU21vz8xpgO+Et0o6Hap2qwcES3BNkHuz+YnqOD93q93/h8XFyofMPENXRF/5eAz6n61sLtZBa5Dw80fSNdAQFhoSPq0NXr67chncGGousx7cLODUgHWFF5s+mrSvwLtMif4uA1ML31Vlr1jLr8AtGlI/9kGNgV7cx09PLilDND6cp0Eu/AwqYV93otzvl06og6q4Hy7/tDSzty9AcfEMdSRVjXCQKqT9Jju9Lnf04I0R9C1pECFYo/le0cyohpQWwMgfoSwOB2edMr7LUSRD90w4LJYxvCWQqC2doa0n3BT9+llLaphtbGT0JFT0oIC0kry0QV5rIHHnJOF3P6U2ysknU52Sy0VQx+C45T/sDc
x-ms-exchange-antispam-messagedata: cJvcaNNaq0OrWCJaXMZHPSUqNx4NqPf1WeMZOMeQH1Hr/5TLKQ/+p+1HbasRsOIaf0MOLdZ6yGHfz353r4lND2cTm70FQ72pu06Xkb9Lebsgh8+Kf8PeVDugkQQYo/yMx13pJp7OroJzCz8Gd2oiw5RlSsvUf8rQQOlSZSIUS6FRqV+/fSnwh1HwLotN9SX3vdOLcPCmF7bOH4WLMnJO287cW+c1gZZsUIkJDGwXIFoKfeHeTCpfpHLkdQN2hdVUJdEiirmZdb56NBJoirXq0OAxv44wW12hFuMRCj/ygAWU3lKdtlnnJv9yaHCdPoWwZq4dYQ7s7/0zLXSoDidXhPaFvi/JEMbayHnM13yxJM+qDYAF5YbekisajfrVqDDuyI0L6Ja0jb4MvKfSyF8/k5ObcJMmCxIAxLOaQU+kN54DsvZ1/25MUetp0cLzpp8Cn5uGCwhkuVVekQoXEPwVQ3sLNDautnGblTyEYzpd10tKMhTVy0R13PHasF8ePefr69l/3uHHqO4ASZseDH6TR+VW653M3/+H3RTBzl4B4mFctN+JdyjGHZyYzKVQsIF/mi0PSXwlDD1RPJXj0OZu+dNIb9V8fisl/mxKwr7H5jjtnuNn9tZ+O7+7hG5A/0mSoQ+IynbWdZoYdNxR2X1rI7yt6UJTpejlhLgOt9cP1Zt+3xp0wjWE5v7bQ/YCW5hZDL1GY6cGorbqvXaE2ubWZJ+uvZ5jKmmlBbYVUuHHtjecKTHf0/CZuymIsf4T8kzy5Mtdr/8LjNfEvazbGG94fk2Gv8N6JjuDZ5vPeVVaCQE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8594c73c-3379-4f82-1586-08d7ec1e395d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 09:18:05.1232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1LnhRNm0AKCIMk9gbLCFXN7l/ZUQVKSEI+q0Bt4InhfeEXfmcGVQ0drccU6KjZuzsxpZdQz0XD/O9fcJ0tMCXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] dpaa2-eth: debugfs: use div64_u64 for division
>=20
> A plain 64-bit division breaks building on 32-bit architectures:
>=20
> ERROR: modpost: "__aeabi_uldivmod"
> [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!
>=20
> As this function is not performance critical, just use the external helpe=
r instead.
>=20
> Fixes: 460fd830dd9d ("dpaa2-eth: add channel stat to debugfs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the patch.
A fix for this was applied some hours ago on the net-next branch.

--
Ioana

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> index 80291afff3ea..0a31e4268dfb 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> @@ -139,7 +139,7 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, v=
oid
> *offset)
>  			   ch->stats.dequeue_portal_busy,
>  			   ch->stats.frames,
>  			   ch->stats.cdan,
> -			   ch->stats.frames / ch->stats.cdan,
> +			   div64_u64(ch->stats.frames, ch->stats.cdan),
>  			   ch->buf_count);
>  	}
>=20
> --
> 2.26.0

