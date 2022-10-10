Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C747F5F9E2B
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiJJL6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiJJL6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:58:10 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138D55F7CD;
        Mon, 10 Oct 2022 04:58:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkpH+IwLPx8p9NdEbY+/q8htvYBAz+wKCuOlxKg5mgSPyU1Gz+yKiCNYQxEPatZoTW84hiT2Nj26svRuwSkrRYhFvgmXf2cP7MotZiKUE9j9beOG7Qa8aU2rat8wfj9wvaoYKBh3az+Kl+NXrnMbrKoEIB9NLxINBigtvafBGns3kTyjuDe8FZ1xj5ZTd8z81R+NKrUj+Uk9lHiVx6AhPgffqbFUsNqpQiSZ0kP9wAgJzREuCeyZH/Ptf9ck/jn6YHtDN3B+AlHiBgHFqQybUY3SD5LKauf/KpsVbwWXuJiwy+kK72lKEKUFgW0EFnOhplUfWn5x7Scpla1Y0z2f8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjdRo5rsfakvj2SLeyGCvlD4DB/RCxKWiWXeKMNGrhA=;
 b=T+d/tjxn38yBJoy0Xgt1LgER3FDMcgrh76Y0N6wRuj91tGV6LyIHi9G/idI8Rig4puPJHIjUUr9IDq0Ul7ykCrOtM/ZegiO1tLqPTANSYtK+0AYylnoL5mKBx0J2fP1EhUpQZcTx46PjSfqtMpnKfUhihAcbNMpnnib+31QS4O0aWNco+3NZ3Of2SEx5gGL8IPQyLM3o1j2ruPWve6gsxgAjVWR2+SdI/TNMzR9/hL72WPRWG+VZAFm1j0ed9MSzt0uLfcJSZyVxtifBXKtxcOftmrRoUwkfSCyZmdYjq3qF23/TyiUkvMSDb90GrgoEGVO3uL7NRccAeyuEib60Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjdRo5rsfakvj2SLeyGCvlD4DB/RCxKWiWXeKMNGrhA=;
 b=pKKrdnY9pCieqVKVZCHWDsN4gj+UJUMDTKe3ZskRMY6/l6RSPIFFB0cPVdidrTOdNx2dElOc3F+7McsWImMd+dhntaPavGC9+hVZJNNKgYldvyR8rQEIrpveUXvFIVIW9FI77A0uyJxLU5Be3YnWMnSOpWhjbh7cceDNDxxA3j4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8282.eurprd04.prod.outlook.com (2603:10a6:10:24a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 11:58:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 11:58:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.19 52/73] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Topic: [PATCH AUTOSEL 5.19 52/73] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Index: AQHY3C0C0Zj1oU6egUiNjTSjwH9hka4HhrwA
Date:   Mon, 10 Oct 2022 11:58:00 +0000
Message-ID: <20221010115800.tjpcmsq22eivpz2q@skbuf>
References: <20221009221453.1216158-1-sashal@kernel.org>
 <20221009221453.1216158-52-sashal@kernel.org>
In-Reply-To: <20221009221453.1216158-52-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8282:EE_
x-ms-office365-filtering-correlation-id: 6641a70b-9750-4523-a0e1-08daaab6ae16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XCtmuPka7nZtD6dZ9G38OE7md14Ui3y+4jAqMRSXHr5WXZH93/9XK7slaz4wggGjnAQbFdAQbiLh0PPkQewM9NFhiQSbOxqx2IvpXSFCa8gMuNnANLPOVziI0RUd43e1BvvDZI3+EQS3pS7uvpc9hf9Wg8kxqPReRQHvivuUmEjzRXffEh8I1YfRRoIuX6euv+bWAeHesCYM3Q1gnwVbgx8lSvhPmhvENdftmnMCfrWCLlR1BtEGh1lBkzggF9gF9K6GxsCQC7PXqdSJSVXf1OlfTZ7f7U0guzd72VVm0E2UBDqOcuuWEpbRRMoNgkJuWWpDcGlsn414CcEmxb+0DHALNOzQFciydoHCF3nguLv/xc0CaQArf9nsiUNq2leG4kR9i41FmbRyuPwnpJZUtM6iPAktSH7NyHYpZh2zFiEjEeqTrgVe6F1NBWr4jnvLoDdnSpKq67fQiWifH4yTNGahK9KT3eOulKmge4fcuifEWXlsxYsbrXIdYZS06JJ4rE2S+MR+ynnhPixqitTju4syNNxOEvBDTe9J8jNePtCNzcLjVMFBJ/PiyX08eKUubdYBkzH51sXyJwEdQ6PnitQq5flKPm+tfeAb736BrXNm21f2Gtj7aVSyFcqZUGu1FWX/e/Thwj+a0RrJVkxiZ1TCLFsrNvUfbEj5GtdlL7cTa5bwdl9Q8dAOW90V9XxyLASrkIwNNW0YsbplJnRiVpRoZGNO6UPiMe/NAaKzIKt4+M/24RP6dNEs8g6g9p/KN66hf5JSnizY2eOOFM7IiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(4744005)(76116006)(66476007)(316002)(66946007)(64756008)(86362001)(66556008)(66446008)(44832011)(33716001)(6916009)(54906003)(7416002)(2906002)(8936002)(4326008)(5660300002)(41300700001)(1076003)(186003)(38100700002)(6506007)(83380400001)(478600001)(122000001)(6512007)(71200400001)(8676002)(6486002)(9686003)(38070700005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fflc08iVhy4wiixnUcA+QZP68mZekBilZxBYxHGUmqPZNSvqWq8V4H1pTyRi?=
 =?us-ascii?Q?QpYsZm0p9JTLifTCJtOzBWjS5lxKyUMxtCmM7IRWhCRGbphmkR4Jm5N1Oet+?=
 =?us-ascii?Q?R7OGUQTvpyoJ5dAUtI4Aa/VOi54Vu8XMs9k1NiXO3R3vDpyxVjAohNrPv8Ow?=
 =?us-ascii?Q?/Tpf1YFaSzAsyMnscedE3VsjqTPwXep3967PfDCvquXLJQq+feHmuhT+CTpq?=
 =?us-ascii?Q?eZ8VM5Z9az07vKFIIrdkuRLF588lboYhLsAXQGXn39GVsTGIbGvkaAbva1vR?=
 =?us-ascii?Q?x9zeqWsDXdxs1kgCgaFG8FHtONfPbc5m4bhrretjfPDbjf+I5HLepZeQ2yxh?=
 =?us-ascii?Q?A/Z2ygUE3xct5QIIF92DvcWM1cVKQgpi6dtvNOyg82RYPI/MTxmthF6NBx2B?=
 =?us-ascii?Q?ojvC+qNFdBn0tXVy63kNs/1ewaJSWiG8UpXJpnqAODIhVGSc7gtRZAbCgAib?=
 =?us-ascii?Q?JVzEY95QXw2uErdQQ+quSHWEFyuHQx/K2UDk7Yehi1zfMs8jdaMkp9aOV7mk?=
 =?us-ascii?Q?Zx/Ffb9r6/iE/Wg6xWkuOMBIR1LScFlDP1MaAqPtactSZBIqr75MQc/KgncT?=
 =?us-ascii?Q?PUyvWOmNqWw5VT6vbl/aB2tbKVV+KpqdjZHIaGxOZx0FWUReB9+LSOC4fBw3?=
 =?us-ascii?Q?zW5c44+HyvFhWjHMxlV02sLXHPxzX1gNKJXCtAEijBqNVJuJ0UpM/Av+CxZ9?=
 =?us-ascii?Q?A9SDjBSImqRvmQc0S7d05QYt3YarVX8luev2NMvG+prdO/LfCNWH/zudmPnc?=
 =?us-ascii?Q?K8VUkgyq34/NGaXd+0Zb/whwB7G1r1fEtBFvcGX5f6sqdmApxHdIhTeBfP2g?=
 =?us-ascii?Q?hCiOl3NRTgsHd6HE9HZVqHXbut/hkx9x+EwvpuonxrqZ2B+EWwtaOQ5Ngdis?=
 =?us-ascii?Q?QSYIzGtoikADIgzpte5KN7bboQoxSlmG5CMimaTDtep7M8QV2E/1OfnQgtzp?=
 =?us-ascii?Q?8f75dpdJWhJWXJPsGcj6vW4cMnHjC+g/hhq201XKm/PIUXlCxnqHl/baJb+l?=
 =?us-ascii?Q?fR4A3PYOqIXsraPWn+gjzku5G5ChkWniaadmVINsAUvpl872axzHJ948zTic?=
 =?us-ascii?Q?+vA5EZHkZWM5XOYW+hCT0SRsjftWwS/17R/A/CpOnO0KOC5B6Mi2GSsxO203?=
 =?us-ascii?Q?fKHATrldaQobaUXZ+s0702zvlHhRZRHxkikZpTqDTVL/LrG65wkUjRoldKAZ?=
 =?us-ascii?Q?va4/u79gnbXYnjalTXTScD1neTUzHFVv3tnB095xMs90Gu267t7aRnG4expO?=
 =?us-ascii?Q?oNCDeG77BAaEKi/mJKJrJLLqgerBHNFpqREm9JZCh+2DTcRjiVO5/i4L6n23?=
 =?us-ascii?Q?u+WjVTr1qL9UB98nJuMlWilg2Z5ZWkf/zSwsn/GeXMluxcmPSn6XeJxzOZR+?=
 =?us-ascii?Q?nToPLkLKFFkRFxEmgO51FLi0dECTFKOj2hE9/VoIgu/tEXKVWI0PjuHxanBg?=
 =?us-ascii?Q?VucAiwHHFl9omZiQnhBwVomOE2E+p7lAwrDuxYkY3B3dI8jpx2FyadU6+Inh?=
 =?us-ascii?Q?5JtXsAys37vEIVFgXe41rl5hjuXA38XS6r6tLK6k473MbKdk05pRSaXYNHQd?=
 =?us-ascii?Q?eGT5gHyPJ6P4uuvzfOOVzIYmb/oeAAC80xLGDAjJ2Vyl2r5536piu+8fUEaE?=
 =?us-ascii?Q?tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0FBDE2C943570546AF72EEACD514B1C6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6641a70b-9750-4523-a0e1-08daaab6ae16
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 11:58:00.7209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ifTyF/AxqVa2LhT1I2NSJp4df3FU5Jhk8s3vQYDCT+C+NjxSL3e9GeFLW1K5R2FJtspmc18oK39syhDcJkvO5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:14:30PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
>=20
> Since the writer-side lock is taken here, we do not need to open an RCU
> read-side critical section, instead we can use rtnl_dereference() to
> tell lockdep we are serialized with concurrent writes.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
