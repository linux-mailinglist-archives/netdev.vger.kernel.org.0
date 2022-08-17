Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273D1596DCE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbiHQLuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiHQLuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:50:13 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC62176463
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 04:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wx1CO9u/sSPeoSC/4SrFfb8WfELIhk+s1LeSauYLWktvvSPl2AilSQluZj2xVDCBQqGMtIcPwFp4kz3Dga7UJah2lviY+W4UwAKct78DIoLDPZp25glIfkFU28H63posclf1hTMePNwaPrXSh60vxL/8l1NF7Rr7tPH2V5dDPUofNY0cJgt4XantM6w9qr6AB1Yd+7sw1byEuu86iWnGixcb/RnZMI6VLtj471WkLBeWUkXXTYVkHzZObjLJUdsDXLXEW8GSaq4w1L0TGjASV9cXUbc8pULMqX8Uxvn8nS2deRj8n0kCBIXvhEvNBdqG1FpHv28mSnNnfQHF4KjSgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P87svMHIW4ohV/aM3PfCRlSV/PRk/WLXOREjT0tCBEQ=;
 b=IN6Cbe75XKm1xO/XkVQ4HBz2s4qtNEk8RGRQ8EmXXarrH1gSAKYZiaF5HxfxVt5ECIAIa2S9A6r/oitmwL+Owj1LZC0ZBVwT2moqjZilTStpVJinx3mzVBQm2W9aYBbiioP5S3ILJBen5oTpnp63AEtYQRtX2jgLGsao0O5NrTm5DYYF5n9yydquK76zypQ/h2D7be9YGmYtMc110lF1o2lyu5ljb8UURGog83OgNpmbfjJAuKEKUJJ1jHE3HwQIPx9a+k/GqcJ0VJU51RCGjcDs+DWkCZ89DKv+KABY6PrSkwNXNgtYQ5Q++YwJhRY2Do75Pn8P3vHzlq3HIzLA/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P87svMHIW4ohV/aM3PfCRlSV/PRk/WLXOREjT0tCBEQ=;
 b=NiQKj6ARbfNX7qbfzOJcNSAo3I1GzRjOhbTdJR/tvLVm57mIfTWmGksFA03op58O/UCZK0RuKdXxJqB7GXnuBPWswwY0bKLM1IzR7tVq6wQ5dXTnSHlu5GnZltJSQ1txd+nIb3DGR6QMkMKTSSI7vbZdZxYGhsEXP781PA+brX8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7800.eurprd04.prod.outlook.com (2603:10a6:20b:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 11:50:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 11:50:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Topic: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Index: AQHYsb+mq+RKMZoa5EST9UiAwGJ6ra2ycPWAgACKigA=
Date:   Wed, 17 Aug 2022 11:50:09 +0000
Message-ID: <20220817115008.t56j2vkd6ludcuu6@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816203417.45f95215@kernel.org>
In-Reply-To: <20220816203417.45f95215@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be100a3c-e82b-42c2-d00e-08da8046a2c0
x-ms-traffictypediagnostic: AS8PR04MB7800:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KowI0JBi7GjuPefKvDo94yaMR0QnrOUIVnlVZ80WttWoIHyAHOMgOHe0iYLczdfn8HtDY0qsc9m5zc0Kcu1BxETEZy7hVdEGoRo6K/YSsMcwQLhXXTwtzlVgI/Rg2XBN6sUBTqx6AfHE4BrOkAaKX3C/HW9manQVWCmqPLqiFJ1eEFz2W1qi9ZKnTxwSoNjPmSHcUsSLuS0SGvIBBAZnaQA3gpid7UQeXHhKW0JKH/gQfifDxsQXbYfkadUEN9R4ytzBc5ScLj28xJh+W/5Q76jVEeLceTgMhWdGTRi547raJHqfuiJB06wzuEUiiLtKbEtBuFFRIc31rox1lQwFf8boCFMij4mvGBUs7rOSwtPW2hHToOCHksHMi9GjfCqUnxW2eNPKHHUSzv8Rv6tjnMeOun9j5dukEliWEhudUAg85mlcHLqavEE+NmKzCGpSMHxoyMI7PcjHm2Jk05b7s1SnS3dxkQzi6k7Ga9Nzs821FeWXYQq3aAirPAvtBQJlvtvEhkPO5CdQyaeT4Z0ZyHXUECnPnnStWPBN4L5Y05/dQWpYNqHXg+RJ3m4L6d/X1zLyjJRN4GSXEzG6E0LOW+F/wUM/c986ZdiYCJp1GM+qnw45+4uRa5az2lOIqpjFuBHaCwaMm4rYfyfbbeVCc3dXFmU7wKTpRnF82ZsqoXKXsarIWhZzAt0Oq4MGXbRq7S+8dir45hMNzIipeX+kX827j09nqvx9WsSbiDAX9bn97zMcMrdEJm1sYULaEl/i8T6Y/XTrJaAFd5A8JjMeda9dHutTgo0dcIf3oKFC0g0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(396003)(39860400002)(376002)(346002)(136003)(38100700002)(316002)(44832011)(66556008)(86362001)(8676002)(66446008)(64756008)(4326008)(66946007)(66476007)(122000001)(38070700005)(6506007)(6486002)(478600001)(76116006)(5660300002)(83380400001)(8936002)(6512007)(26005)(1076003)(71200400001)(41300700001)(186003)(54906003)(6916009)(9686003)(2906002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ep4E6pfxPbrXYO1+ueFp+RRazFgjAFpe9CpZSiBBsw9/axyefuQD7dDRzLzY?=
 =?us-ascii?Q?1F8IjwhE9ybtUN/xbefNs/2mLSGw0dOfY/zEu6nc3i/vnWsgsia5k9Q/f0XR?=
 =?us-ascii?Q?zD2o1eAv1NGNUGEuim3jKOBRgqkmvabUZK/eo9rGuwsxgVBuS3qaoXES9w6V?=
 =?us-ascii?Q?bepC1smstrYJYjGwV5PzBWJdCzTVuGWdyyzfaf7ZzALWfPL0YlhmP9ElX0ge?=
 =?us-ascii?Q?1rR+VD9CZdRJxwy1vi3q5nA6/ADRGekx33Pxx1idH/N9H9CyQ+DjaPE9ujKp?=
 =?us-ascii?Q?4CCVsxbWfrVUB31Xfe8PMMY97qb8EvZtg9TyINIWiXQbMq6Bc0IMBhHiYKGc?=
 =?us-ascii?Q?RNjimeuhOgvEShCqI1Kv5+LUIdBtdp+n2LCSnoJJdf+7ClKahN6s32gGzoCu?=
 =?us-ascii?Q?1M5OdgCPERX0kLhR6AmGsT3qY3BzFlw+MMLVHKsgXH3SzezrqQea0UjI4nfm?=
 =?us-ascii?Q?vjxJMBp5B/Tlyv7qGiQwKnSljL/m4JlmygY8f+EgbaeFlLqkDVNyVzEvCGvs?=
 =?us-ascii?Q?pbgzboxaogrzAx+cBVsCbTE+1ZLqdxCM7K/kVAyhupiH/2Vj/OTQWmOAGS5K?=
 =?us-ascii?Q?RLMujpwP9eSjdehrILMeNVop65FaIXYzOHcKS7iKQVjyVwb5cc6OLWtlseUA?=
 =?us-ascii?Q?pSlhY6i50/Ilh0D505VQ7Ey5Q4KNlgFIVVLrJWucqFyULs01PqR8N/NeyFMz?=
 =?us-ascii?Q?VFLfryQ8FMTOLEJztxyjtKtp0V5CV3/ztzQvn6ZrmWwCgTvf5PwFPSgv/GAS?=
 =?us-ascii?Q?N1lKYncKmcVpl7KKp97ViH3PI/SNKqKBlznLE9SQvyaHFI0YVFGjiZ3hol35?=
 =?us-ascii?Q?lIQhTQTydC/xAjb3xTGVYTMimUPCDHUtxpzVV3Vf+wTFk9qiiqy8WlggLrz0?=
 =?us-ascii?Q?Hm+GLHjpEiSYtqZc5h2bPiwVmIdCfy9N2CrYrU58k1NWh5lA0lgX9ou9KIYH?=
 =?us-ascii?Q?BawZDi6IJ3M1xKJGrpzrDy/sWmX+zba4h9luS8h2ZyJ2+lQhLfyN3p57zmm/?=
 =?us-ascii?Q?0GsNWYzfpo7urkT5vQ6DUTA916QXwgSvcVbMHNJs12+ewH1qIExG4q6pcBvG?=
 =?us-ascii?Q?tT5BAGbFFQ/x59WbAUHL133ADtHnqStXsjXvIM8KM+FWglq6A195DPjBRzud?=
 =?us-ascii?Q?I4r7l5k4/s78oL3P7+bviUeDyTqcHUzapKUJg3Wjde3Iwa0s7p1LPG8slaqk?=
 =?us-ascii?Q?iY5PS2F7CVcYM84ktJLPmmDukG+7yfG3j0OIO8kvFbxfQnB1/WM7qhkpdBPt?=
 =?us-ascii?Q?rl9lQycoFiFAet6RXaXmjX0f+BLxAFWHQSWINm3QyOqXjQUfkE/VXBaKqKVm?=
 =?us-ascii?Q?6j6Uyo9+hUuim+kyZ2koV03PECBki7R9lDQ0p4+sQNBbpdbJsgK9ZuV3ikTC?=
 =?us-ascii?Q?YePU2bYEilmGfi0VcG9Pdw2iUydyTbIXsGLkmg5/BsD1AiwWgxCyPPZhJHbx?=
 =?us-ascii?Q?YfN46+DhPDNVhxSjmfjujV+glOfRxzH8dpOBfmWIVC5uO572Pg0M6C7XSvxm?=
 =?us-ascii?Q?JoQWve667gXZL7lo5Z8e1ygHlekM0s33AO1VvPSrBU0+MX68t9Kdrgp+sML5?=
 =?us-ascii?Q?wvYwsOsBO5tNMTFndqIWrFER+zYFUMn73PUYMgiINQ+49nLyGru4/5hmFcR7?=
 =?us-ascii?Q?ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <628FF3DCF23211449DED95A67E939A02@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be100a3c-e82b-42c2-d00e-08da8046a2c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 11:50:09.2801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yu0aw0AbEZudEhV/FE2SrGh8/FYLnWoip9SLfWYBPTpAwKxHITT2ydgHdcyAw8p9hyOk197bYeavQ0A9oC5z7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7800
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 08:34:17PM -0700, Jakub Kicinski wrote:
> On Wed, 17 Aug 2022 01:29:13 +0300 Vladimir Oltean wrote:
> >   What also exists but is not exported here are PAUSE stats for the
> >   pMAC. Since those are also protocol-specific stats, I'm not sure how
> >   to mix the 2 (MAC Merge layer + PAUSE). Maybe just extend
> >   ETHTOOL_A_PAUSE_STAT_TX_FRAMES and ETHTOOL_A_PAUSE_STAT_RX_FRAMES wit=
h
> >   the pMAC variants?
>=20
> I have a couple of general questions. The mm and fp are related but fp
> can be implemented without mm or they must always come together? (I'd
> still split patch 2 for ease of review, tho.)

FP cannot be implemented without MM and MM makes limited (but some)
sense without FP. Since FP just decides which packets you TX via the
pMAC and which via the eMAC, you can configure just the MM layer such
that you interoperate with a FP-capable switch, but you don't actually
generate any preemptable traffic yourself.

In fact, the reasons why I decided to split these are:
- because they are part of different specs, which call for different
  managed objects
- because in an SoC where IPs are mixed and matched from different
  vendors, it makes perfect sense to me that the FP portion (more
  related to the queue/classification system) is provided by one vendor,
  and the MM portion is provided by another. In the future, we may find
  enough commonalities to justify introducing the concept of a dedicated
  MAC driver, independent/reusable between Ethernet controller ("net_device=
")
  drivers. We have this today already with the PCS layer in phylink.
  So if there is a physical split between the layers, I think keeping a
  split in terms of callbacks makes some sense too.

> When we have separate set of stats for pMAC the normal stats are sum of
> all traffic, right? So normal - pMAC =3D=3D eMAC, everything that's not
> preemptible is express?

Actually not quite, or at least not for the LS1028A ENETC and Felix switch.
The normal counters report just what the eMAC sees, and the pMAC counters
just what the pMAC sees. After all, only the eMAC was enabled up until now.
Nobody does the addition currently.

> Did you consider adding an attribute for switching between MAC and pMAC
> for stats rather than duplicating things?

No. Could you expand on that idea a little? Add a netlink attribute
where, and this helps reduce duplication where, and how?=
