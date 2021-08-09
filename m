Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB613E4964
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 18:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhHIQFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 12:05:47 -0400
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:34145
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229456AbhHIQFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 12:05:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOoRSWFlX12+xvEjUEOnin6k62golGNggu9Mj5WRvcKexJNClQO7j08Gkr82GtMqlCxv3KH+ybDcN7YgYw3bJV6+PZC7u1BXOm1TKTvSyQrCWHEKQLl6zAE+9Dw6LTCpRJyxwhqcQIikiNAZMNSQ8fuZ6mUVAMAl9+B3/X72wUPTUPXK3hu2aDTr2scVMLNLPPctyNHoUhhRi6mhtnNPKwj+pyUcSdhSvldmDeeSXVr+OZ7mDXdeJiOCKloRex284Zp+LLiBQ270m96d1Apc27N7KztPXQ7vbiqnaLYmwOa0LTWE9BhcNNAZDzx0HI02zwXChv7F1VM8+rx71p3WUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zGxz6hlDKFKLDM0lkTsn4+5vr2DoX6Vg4i1fG9WQHI=;
 b=CrIAzX/uJZOWsDAOjRNLXuSRNIfTX/ePC7oB1M0y0qQvn3YVkf6vZUH88hsmlgwYydAxbE2+oCQIdhMvS3YvKXM9zDvui9aIh88Y03RObK8aCtmcj3GqgRpYOjWrq+S8aFZoguNzRi49jOaauYm2EgtbPocXy0/41+vUYpg6pvJMFgi9bdsZsq0/SO+RCJLyJdG8je32wBuKtu24c5c3IsDk9X/+aWq69Gk7k7W9QklwVookXRfKJX/CDFp1w2cJz22GUCce+fMroyEdUZ+c16h/EyWOqzg2N9m+0IQ4e3RgpWNk+AC3PwvKDCFMiNtcPiscBGpfgSnjQd0TIwFVHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zGxz6hlDKFKLDM0lkTsn4+5vr2DoX6Vg4i1fG9WQHI=;
 b=GGjcID9zyVdnsQVzk/dx/ir/d8IQ2NWOxbuD7sBTvs/Eus4DGIwi8NDX+oBHW+mV0uwkfnddBKWb20AOvFyHI+SbsBSHxBoM8ZZQ120mIdP/WfVk2C+RPHCtmFQo5ogLv1jh0kTGmFmFG2KuGNnSmXj4ejyrzsW3QUTfBBgPoKQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 16:05:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 16:05:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Topic: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Index: AQHXhyttiQTxBmfp1EqsG/8ivlTylqtrInkAgAA/5YA=
Date:   Mon, 9 Aug 2021 16:05:22 +0000
Message-ID: <20210809160521.audhnv7o2tugwtmp@skbuf>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder>
In-Reply-To: <YREcqAdU+6IpT0+w@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8226424-e0f3-47a8-1456-08d95b4f7e4f
x-ms-traffictypediagnostic: VI1PR04MB7104:
x-microsoft-antispam-prvs: <VI1PR04MB710473A90894F41AFA990719E0F69@VI1PR04MB7104.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QpC4HnKuLlJWSoRs8DhqkDljfKqbrRulI4ifSo/Qz3i1EcmsBw01uBXW359jB5fGe0vrPG3OO/fsOF8XzJMDsgWUF2oyLN61j52n0MsWvAKWUlr1FEHWiTaX2/6bfOm68QucBxdY4A2hIJ4Uav5LeEQjCh6/viQ8niKVjzKhLLEooZj7CGcmcsq9Zxz42x3KfUqOgHl3LYjbCfW7UllRlSBLlePRqCv93Kq2BLCPXSy7hUFnreE+lMtXJJBFUvEOUW4lHfwwW53hoVOtpVFvHzCeIZx592oqUvsP1zpgOMQmbWnOvuFVX8Ba0dvUjSbrmjcalRfaKOcLsRkH+Iy05AidsRm7Bm8Hme71P8x/kZgTZThvfFvWCBE+WM1+dQbtsaWJVdN36Axy6IsaCZqKmiPon5Jbxj6kxNuRLhet4nR+xKOYhLxxcg1GF7p9v1vnxbN4rxoGa8njTRbMqJaO/u3LJIKZ9oSIG9JYoYHysNFMr5Rdj8D9FwiajpF+FuBcra5tF3yo3TjdXCwgRhgFuqSjre9DwK/3oczh0v8EOSDdmkghItFDFlPgRyHqDaWlbusP992waexfTVPmdQH+hFGTbiykjOR1wOwCGs3P5k6dOtfMl51FeHpm3ziL7jAS7NDBmfVtGtdux7Do9wb1u/sF5vLTj03RWotLNGGxYbclCQokpv6x8VEsWlQRhl5cDfHv1nH1/+Ek/AEunpRA1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(7416002)(86362001)(71200400001)(8936002)(4326008)(6506007)(122000001)(38100700002)(6486002)(54906003)(1076003)(5660300002)(4744005)(66946007)(6916009)(38070700005)(2906002)(26005)(33716001)(8676002)(76116006)(44832011)(186003)(316002)(6512007)(9686003)(66556008)(66446008)(91956017)(64756008)(66476007)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j9/EV26O+uxGAnLd36bZPTilQWKMQidmqT1B/A6cnOva/YXvT4uRI2nUGxkk?=
 =?us-ascii?Q?0AXPu7VON6CujwPYCNxKp0fDbBwVnbsQriWUWovor4SmtFHGU6no9e3XlhIq?=
 =?us-ascii?Q?O6LV0sb9egEdsn/bT/BLFb6TackozOwKWx+3jeCSnyyPrzSX9hZ6/bcybi6w?=
 =?us-ascii?Q?sbD0Gz4NAdGn19+P6rKFUguu97jTvWKj9nFHb6tIF4BXS87XWb1H9nN1azF8?=
 =?us-ascii?Q?1vTAIlBXxgNHpiJ/UdY9TM0//sWkUyj6Z7mPZWyWlJBCGCmRX939lny9Ga+g?=
 =?us-ascii?Q?ksCTLa5EqeR3SgakMNWkb2lw0PiNQTp8avufuKVzBdCpDSCyyppUzBWRkZ45?=
 =?us-ascii?Q?nGwJTuiK/SgvZsjG2G2IgvT37BoQ5eXqXGsK6ePvNQG2tFIYBBV/qHrXxQ5D?=
 =?us-ascii?Q?/en+Y0LR6S0vFLdVi0tMtpaXMFC/8ZF8VqFwkkFfA93nY7NdSDBoi1w+SezB?=
 =?us-ascii?Q?Ev5er5Iy9H5GiWoyHC/bSiZrepLJrUZHU79zybAUeW4gJrNbfZMRkQkjsaRx?=
 =?us-ascii?Q?qOJS1DiUXoQ9fa+lxOCofdWJRtlSecCRG4GcfcBBQR6H7G43GjztdnPce+Yb?=
 =?us-ascii?Q?RUHvmvB8z1SSIwxCpK12xBNxdgoWW7eE19ivz2B9XmADW/1vNtWgpNzz0bOI?=
 =?us-ascii?Q?L2dxUqXH0TTnjO3AHGXUEJJIk+d0vstTKL3rUKxtEDURQs4bdhyy+8tK3hPN?=
 =?us-ascii?Q?r8AKwOBbPGIPhZ4DEOg6VDl8Lz6P+SAYB2mMCrEI3qbon4TZA3jPpUUijmF8?=
 =?us-ascii?Q?i5ajrVhKIJczl89cenyw+UXEgHBGVVwRwcOhtQ6as/zir5TVcnjNBwYykrVl?=
 =?us-ascii?Q?sRJtpqiP2I7T8FDwXlfsAckLmZhWNnqD7AwP15CHGQbyKkYKbIsXp5bIojWK?=
 =?us-ascii?Q?1bAvXRqmrPIcrcJpOBRcXy6oOL34rZyy428rsd8Nx9lCAJsWZ6+BdOevXXvG?=
 =?us-ascii?Q?41b/xl+pX8J/2A+izMx1cs76LxfwI434iDGpYlbCJE8EmT0zdPgfbEc25K5p?=
 =?us-ascii?Q?dCQ7EEaUhYA9BXnOOlgqEXUYxxVWR9PsLpUByCkoGOiZJb4wOYwyGLrpmxRf?=
 =?us-ascii?Q?Qav8vuwxTqX8e4/YgkISBb1I9iL8QAT2RF86HvNq2neCEkhPH4MdZ9ctxe6t?=
 =?us-ascii?Q?Q+mj+/BCN/sX/u+FSXp4WxC6WYwkaV19ey+LJiJ5mh45EVsz3Fq3wYatqVwU?=
 =?us-ascii?Q?ekjrTbOlxu6eJ6DrUaz3MdGedE3jTTDgrw1hvCd79pUnRw/E+yqPO+XE+MKS?=
 =?us-ascii?Q?OORwDPi01bzEcIQK9GttaRcuhBpxfJHNICZLTkuSLjmHlI8CwspjvqpMcTsy?=
 =?us-ascii?Q?QBWeeX9p/hg1p8McwTGvAre0?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <538578EEE12AF14992003D542A780495@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8226424-e0f3-47a8-1456-08d95b4f7e4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 16:05:22.8572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E2dDk6K2hfbuW6tdoKrL3P8dz1YuSkocS8ryXKGY9BiuKCQ8Fh6oYjb5FDT2hIiSJu1A9M9C5HzyDe0GoklBLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 03:16:40PM +0300, Ido Schimmel wrote:
> I have at least once selftest where I forgot the 'static' keyword:
>
> bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn vlan 1
>
> This patch breaks the test when run against both the kernel and hardware
> data paths. I don't mind patching these tests, but we might get more
> reports in the future.

Is it the 'static' keyword that you forgot, or 'dynamic'? The
tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh selftest
looks to me like it's testing the behavior of an FDB entry which should
roam, and which without the extern_learn flag would be ageable.=
