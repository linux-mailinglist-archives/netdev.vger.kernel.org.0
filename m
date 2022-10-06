Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0688B5F63C0
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJFJit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 05:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiJFJif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 05:38:35 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E589A9DD
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 02:38:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHAdM8n/PO+1cWNMLeWK/VmLoGmpjZS65irJ0YL+EAFdBi879wPkjwodB1wrmp6ZKHw6KCYTNHJDDCjJHNqZae0h5UEbnra6dt4WfNopps+a1UR+0UFptkEkFBz2Z646k5I8KBQvnBrrvYu9AsQghELoEEapxnRypMc45OlzZAsMx/oRmm/KzFUg8/9K7l7JAPWrxSyldTvOxcAcak/2DxgZeFv8NdT/nO3weXgMQSvxRBJKVOl5O2NW7mssgl540VDGRWLyxa6X8r7H9NHjGXaomg+UupVcaFBwRaQX7U++mak/H8l0ol/Cg+JA7cxlHvDT76ldUJCe0uDICqx3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdDwvh2uMQnqOe9JTjbxmDNExq2sxZezjnh/PGdHJig=;
 b=ACpbC5kX/KXaDTV9azN61UFAVw8nRDL/hP9IBFMgY+W2nU1rCNS7yRL8Q1HE7mjtv9l6jbdizEu6DJlS6j+3A0E0YuUNXjRDVuhsuYiG2wBfHG+AhzSTUOSG4qTYyTjuDNYVX2WuUV7i3RxR2Q/y6VJmJMdBhdGOWXKBXN4+4PoU71b/at+p/odUTYCuTyIyf4FkMT+SASU3WMEuAtYqnPyuhgZTZF6mb98pz3OS6ZkosKucoSx21SLZ+EuvjUjTjgayxmNDbeBVrqyqdsdDNawYqqcpvFc9lVsQBHJcXbDDZbM5fd+/w6ROwIMCSfmW157ds3gwY1JdkQUCQxT2gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdDwvh2uMQnqOe9JTjbxmDNExq2sxZezjnh/PGdHJig=;
 b=ZKQOa9LYlu0GyBTNJwGEpmuLhqRm5eN5FoG2o5tect4X+aNO3cyXpTvhOVGv9uZIlEOa0pZCAdsOTvGn2oRFOyZCxIJGgtlS7yz941R+EI4jUq46PbTyQnBH/4/6ritdpK3IHkbgBWY9NfUBHDa+X/WcR5xpfEV/AjdzGJzrv1o=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7033.eurprd04.prod.outlook.com (2603:10a6:10:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Thu, 6 Oct
 2022 09:38:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 09:38:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yannick.vignon@nxp.com" <yannick.vignon@nxp.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net v1] net/sched: taprio: Fix crash when adding child
 qdisc
Thread-Topic: [PATCH net v1] net/sched: taprio: Fix crash when adding child
 qdisc
Thread-Index: AQHY1RxOd1dFmi5dEk+opmYKbXniaq34lZOAgARaWYCAAdiGgIAAEjkAgAJJ5oA=
Date:   Thu, 6 Oct 2022 09:38:32 +0000
Message-ID: <20221006093831.5sngbg5cq3r6lxar@skbuf>
References: <20220930223042.351022-1-vinicius.gomes@intel.com>
 <20220930225639.q4hr4vcqhy7zyomk@skbuf> <87v8p04y6o.fsf@intel.com>
 <20221004213617.7qodtbsr37wkyavj@skbuf> <87pmf7p5yd.fsf@intel.com>
In-Reply-To: <87pmf7p5yd.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB8PR04MB7033:EE_
x-ms-office365-filtering-correlation-id: 1e9b5b15-2390-42df-955a-08daa77e8869
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WFCdK61apgRjsLZMKsuqTX8c5WtTi7COHNWEw8ALXygQGnjNKkH+/M7zLr4jlghd+mHUyhE0pq0OsSzeon6r0cyiLOa04oKtynP/vDw852fLAG3KU0dQ3CqdUn5mda9i7UNbBdEe5KXRcsS/NS8i3YtU9TY7188O25i5BaCaMPMVkE5E52vhVbkpJaxoi4Ci+dH37039H0XFQgROgyuYxoAIE2/44b8qS3+EK7I8Wsye9rROtchcgYXD+p7xcDj17IoVA+NgEWaB7oI+GdCg7gPjQIqqHaUHGknQiBoh2ztAALOVNZaG6wMGMA9VKBBiMD1rHaaVFy7xGya1aGhjn5FULUQtP7HRc3nqaA69wk1z3XYjddynqqj0VU7p4aAFjEvlVdsRajoZQSiW0y2FwywaVK/C5mH7wsOn257vF4y0itfvEZkxjdsLOa3nEfg+e7Mh0EFGe+XbblNFqmODCMkQ8/gg+NDrcuAkqpWO5ZT/D//+HP2KvTO6ecIDmWNF02J0aMq4svwGicdLUzw9HsLIlX8l1XwXmiwf0XXr49Hcac1Zv+pWIZajlGDDdFxX29D7o56cDZS0lo8haItNf7FTazCCIvKmOuj2I0IK+2fzo/SXvSo62Fj3jAsx+QJRFiV06NrY99tXYz13hpqRaeVqz7Hu7/sby3odnLxrTp9bPtpGzFpl7T1GEbt4lg9KaHPGgdvD10wott0NakvXtEJkN5b7a9SlS5sNsUSVZ1oNJLLGYvFGpyndwr0XKIn/rLhtksQBaYsGiHCXTvkOJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199015)(6916009)(86362001)(38070700005)(44832011)(4744005)(122000001)(38100700002)(33716001)(1076003)(186003)(6512007)(26005)(6506007)(71200400001)(9686003)(6486002)(478600001)(316002)(66946007)(54906003)(76116006)(66476007)(66446008)(64756008)(8676002)(4326008)(66556008)(8936002)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ev8N2zFkwYlggu82wNKmPVbhBtSxVfCuhnYoVL1Le1RSfQUFxYtiavlMY5eI?=
 =?us-ascii?Q?IElJtKJiwD8cjope4FTnU9nKl90PWSQZTG87TXL3CfkL8DDx2H8KHtq4jRjC?=
 =?us-ascii?Q?jmMrtFRMnCKCQUdZQaK3D9yXU1qQrNgrpcGc+ABCO3PsDc+XIkiHELU2W4kB?=
 =?us-ascii?Q?sOrokOejgUUws/xyTXOEh+/b1zZOZsraeZp1bhYsoG5rsnZJQaFxQPbib0vO?=
 =?us-ascii?Q?eYXn490rk4PpxyidLTzGa+CYjvslKQzZp7ZOXVWd0vOf3lNNEeLvPZ/+7NG2?=
 =?us-ascii?Q?pwqdN9fCVTO/obWqRGrFpE+P4K7e+GLHVQj2Ah41TEirAyIhGOQg4XehuQZ3?=
 =?us-ascii?Q?PRf1eceDWUTPHY9yiSrsqMcvsfN+ALTlbztFP3dcaDuL/GmE1hKbmnDkkfjf?=
 =?us-ascii?Q?WNczz6TX73oTy+iQCOhoHZZ+17Z4BEkZCTnLDm5yad6up+VG4VFew5YpyjGA?=
 =?us-ascii?Q?o+LgbI7Ymzu/ojUihCbpsWJXuO4FOpD3ImARD4B9s0NKSe9+eDMJ+vcLkncI?=
 =?us-ascii?Q?BuGPOeSE2rPXhCPPYQf7odTyJ/LkuN6prrM6683/2nRI1/e/xQqW9PIIbqTU?=
 =?us-ascii?Q?eGatZL0eox2WEcA109RbeAnF5uCua42Vx5jGh+L/j9zqPiQVoMsSVnLzC4nF?=
 =?us-ascii?Q?jVYIXuIo/1u4VywK5EtRyGZk0bj2uFTxkoFR1RLM4kpmNDMuutnydDcWhUwC?=
 =?us-ascii?Q?VuwDFmlr9j3RoI1TwiiNVVdAtud0lUZxK8qJiZ7QNKsU7kiRfdawGcy/MgD3?=
 =?us-ascii?Q?RdIsHoNDdHTczsag1EWXM7eghB+BvcIfCQrd48Bz/lo/NhhU4RKBqto5CTUD?=
 =?us-ascii?Q?P7P//s6Yh3QidM0QZNgMbJLv45lQK1IMHF0xx3An67mcUHTI3qliVOhdXqaw?=
 =?us-ascii?Q?hYT4DRxjidf1giq9wLLYIuvTlz5lONClOrTrCAtOn0WwBbDRj13bTAXIsett?=
 =?us-ascii?Q?nTf46jI8JrdT0dujgJghRzfi9R5rZB/1vMc9JCnZ17EOz74pQGBSsAsmHPGd?=
 =?us-ascii?Q?DLomhOFNMGyagEuBgXGzIBpw1sND0yfn5bQVMeXe3EPPI7n9PiE/YjWcxfCE?=
 =?us-ascii?Q?GHerb91H5T6lV0CDKsW6xO81azXm7CEV+oWCKuiu35AaUhTnpZJdieWChcqg?=
 =?us-ascii?Q?sqOSCHpEGxhFUrWbP46OHMBOft4ZqAAKJJY/QvxTlZCRunq1ISWSDq2nb+u4?=
 =?us-ascii?Q?zTrtuadUz6TKOR6r0qWuk0zi33g0ebG14Gl4eO91ToG5h9K9pnzE7er2LELX?=
 =?us-ascii?Q?i7ZN75YDVsa6chpd/H8Rx94dDikDJ7qXpHArxGuaNFllypFM0uDrgLgFEDsW?=
 =?us-ascii?Q?FuhfhrVu9kOWEpcX31eezbYEIf+rtdKoDjaZb1+jPKW6vjJ8CXjOvxJ2C8vw?=
 =?us-ascii?Q?4y8mEehC6BTEx95VIAUxZFP1pdFZqCVs+xJj9nlFrJZ5pZpzWVoZNxcp2Du1?=
 =?us-ascii?Q?CujgyRJ5OLWX+DbbdSfxbg3FUHqNM9ffTqRIqHVVwg8PncLVkiVsT29J/wgm?=
 =?us-ascii?Q?dsucMzBZ9q57g9k50uMFmS+Bx2e4PkMOJgzMR81+KxfHn72tOd6A4WphwJT3?=
 =?us-ascii?Q?gVVXDWsKr3DdIUSXsYUrKFlXNhe0eztyoTGo4eeNvSfrk2H/QdZpRtuRFnmC?=
 =?us-ascii?Q?3w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D001C6ED5998504EA2276ECA4845BD1E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9b5b15-2390-42df-955a-08daa77e8869
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 09:38:32.2060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zo9t4VDkNZAizEcKs5+a4sdbHcDObPFAnjmRXTbZ9RGd2rTpV0Bo/O6bRPsfbzJnF3qGMnJNbj9Lbgv1aWl+Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7033
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 03:41:30PM -0700, Vinicius Costa Gomes wrote:
> I was afraid that this this would happen. I need to stop, grab some tea
> and think very carefully how to simplify the lifetime handling of the
> children qdiscs. It has become complicated now that the
> offloaded/not-offloaded modes are very different internally.

Truth be told, it's not like the problem Yannick described in commit
13511704f8d7 ("net: taprio offload: enforce qdisc to netdev queue
mapping") is unique only to the offloaded taprio, but I just don't know
enough about qdiscs to see a different design than what is currently
implemented.=
