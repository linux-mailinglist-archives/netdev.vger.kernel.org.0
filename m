Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634444FA6EF
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiDILG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiDILGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:06:55 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50042.outbound.protection.outlook.com [40.107.5.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF2723D5AB
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTQEMYhsh7ks6kbTUQfjR2EVSFhGwDmZMqmGaHaxdl7MkjSTT0siqUpbFEnwtR87GYMPEyS5GH1+nW9x/zHozNW6VhxtsRPNH8BsKialf4EjvpNGdkvFraE7YKo2aXbOcSEbe9z7I9OazwGrWS2wGitI7u5R6P6H6zzTWXi7qLGeWGQHJ15g6pg5HQtc3MiHkv6H2IGsD6s13SoQMyn/tx186IU0VDKiNr5dn0VRFwAl3YpZHtBTH53r6YoMtq5B3qpgCTmgoGhrz+hG1vYyk/ybllqCsD7R5u7xt8QKZ1jP5+fcZFNPpyACQCQz8Zy34HKk8Qpgo+D9CYqjZCagog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUaLA0XQcCEu/0ycvrypc9IuGZsWgWdQy1np3iO8WB4=;
 b=dL71XgP76j/mXSsLr/jk4YIVH62iFM7I5v37iXiOuT8lLaYdgMu+A6/5cSlKxN8vPG1wfaTPvlbgRf/1eFIsCqTIZaQid/anzcq5FBX4Fk7YARiLvpFAqMCgqs8TvGml14k5Xs8gGVPFkYdlv4VVQqyCe7HnQL/vh15aBOkGr9dynegCSagO3nr1n07DVTZAiPR4okPTzAPKMF1RsfXFWOBxXMxKUT09JCAJa7UvPfC2ikQlxIOen0HTZrVAJaXBguSruXPR7qpxTcvO96mXAVjsZSxO9DoKpFDhL4AYpbnupW/r7mv6cgsHZ5WxQ1ckW8j7zZt+YAm3cQylue9VCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUaLA0XQcCEu/0ycvrypc9IuGZsWgWdQy1np3iO8WB4=;
 b=IbwBsrdcM0olgbFiEo1AR37rCHOHmA+MkJ9I0VcjjXNogeIOybtXn4OqHI4TUlD9kzsxcSHQrtwYJSFmYVLBfyY0A6qnH1S4BHhdMxv85/8E+8/Qxy1AcCoV92vf7DMhhbhs9+GhWt+1xHo9OAicXxZe5YJMIhgrxKx0BgHXd9k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7160.eurprd04.prod.outlook.com (2603:10a6:20b:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sat, 9 Apr
 2022 11:04:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Sat, 9 Apr 2022
 11:04:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     kernel test robot <lkp@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH net-next 6/6] net: bridge: avoid uselessly making
 offloaded ports promiscuous
Thread-Topic: [PATCH net-next 6/6] net: bridge: avoid uselessly making
 offloaded ports promiscuous
Thread-Index: AQHYS4PvZMgIStRZRk2NwcP1mpJ7TaznXvCAgAANRAA=
Date:   Sat, 9 Apr 2022 11:04:45 +0000
Message-ID: <20220409110444.5uf62kg5xjuvwysk@skbuf>
References: <20220408200337.718067-7-vladimir.oltean@nxp.com>
 <202204091856.0PBgeBSa-lkp@intel.com>
In-Reply-To: <202204091856.0PBgeBSa-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dea278b3-b8e2-45c0-76d8-08da1a18c175
x-ms-traffictypediagnostic: AM7PR04MB7160:EE_
x-microsoft-antispam-prvs: <AM7PR04MB7160E6E2C1A527648C957D00E0E89@AM7PR04MB7160.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hpxto1NeTS5th+GrNbOnbOyewTqJIjNOZPfdOZVkmXt/vmER7yb+INaHv0qJ6HwHD5q8kepBehIAnhf4pz+gxFr8vgeUT1vK3DIoGkdXDQXgSvIGdmL1Q9SnyQwalM+0PbO5qqHvjt3ZeArn6V/KhjuI1E19ZE2Mzllkh7JJdRn2Xj3K/Fdl2j1XPHC47O7rU8Vem1wBJnNE+ExwQV4ZwYhEXHMhZeZliY/mdU093OhaYnqkuoKoPLFO/R5IZrPnJn677Xx5K6X4us9SyuW4IeXuXmaE9SQ7rGTWdDpSTqAs137XJkdAVkCO5M+KzS7H62tPoTIe+SwGTHXOxssnrabw79oi0eeQf3gByh5yi/KjZkdHJXjcoMZds1eGUqMk4dIpy0/X4nfizbqNUcobiNGlNPVM20TDHEVLbP6Wi+ndhP0mVRqkCRSMGDGT3X5q9rx/A8UE8/aVf6f0001IvQ7t0mL3fy3N6EN4CvJEze7JrrOhUaABDc3lPQK5wa94qbhrTQsRuoO/uhIv0fh44jCabFVqpmewpTLZ0gASSSdrSgJeRAUBAzc63fd1QHnix7VjY/PnaiAYTk3b1JsOdPj910/p1WQIkxbvI2AG8is1JAzBq7p+325tbT7O6cc7R+cDBIWSZoXQdwK01nB8kU5lEQe7qiMmgZQcXKqfFIY9QzUBgkhGs7Aj/pfwMreB9DOi/ZuItqcnzEsI6P2MvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(44832011)(64756008)(2906002)(7416002)(76116006)(5660300002)(8676002)(4326008)(86362001)(66946007)(66556008)(66446008)(6486002)(66476007)(38070700005)(508600001)(83380400001)(6506007)(9686003)(6512007)(1076003)(186003)(122000001)(26005)(38100700002)(33716001)(54906003)(6916009)(316002)(71200400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uO2FHsOQPzz0ay9YY2m8c8Tf2MtbJbG7K+b7495w5UBmFCmxQjQtF55fDRIp?=
 =?us-ascii?Q?o7i6MnZALjWfEC0iPlSeSlwkZcqIbGCv89nVG5BEPN+qbsFHq7isldLBgvgR?=
 =?us-ascii?Q?ozoaO7WR6mh9LCKdn7Gso7GJwq9evf92/XYtZmJxwENbDu9ap7qnGK55aXSl?=
 =?us-ascii?Q?VhiI3Jj6f7a5XHnt9JRUNDiUULjcHGdmZRMkuHSIyB3bA+oAvZbnS4CYknqo?=
 =?us-ascii?Q?XXcUnF8Ewe7lABYTKG1irzvyItEQWesXwyk7G7kXspOe/ak+18kbEUAHFygl?=
 =?us-ascii?Q?q4b4rrrBfJtf6WdKAxtcONZM8SDunzqo5wgnN4BbsnYMcLWp+k1hfK4We8xp?=
 =?us-ascii?Q?tboHmX4xlEzp9NXG2EVQ9dGvdmj5xIq1MQk3n0gHmwpjIJKFcI/a6XHpiQCs?=
 =?us-ascii?Q?tyYJn5B560qnb1nE2xwKag4ERc6H9F7RSLAetJSVWLTh/Prc19XjzeszavJx?=
 =?us-ascii?Q?xFTtgb4S6oQNw9+NOI+prsg74JJHrSxjf3gia2RKTeW+zu7qjBDlqWp/qMwc?=
 =?us-ascii?Q?Qajum8CmZGrrluCya+4CdYkexE+K2JTbaMNyq7uFxBv5VQMgmeU8vQDJPMgb?=
 =?us-ascii?Q?VWxRGPcxj3oapgh3rAveZgjsLUlUNXyAPwEeGiUrHmfWvmaAgXmXiUs6gh2f?=
 =?us-ascii?Q?Ww++L0opAJlV3H7izuiHGdHaBpc4746ssCs9R9PbY5rCWGpANjrJRLW2ZK/h?=
 =?us-ascii?Q?VYhZTBRtVUchhbRny0jS1Jx9Ri+OIPdcceiixUK2dYE2hvKjqvtD6sgOkdhM?=
 =?us-ascii?Q?e3iJSV9KJsoau1GSRUbSQBxJTsKHHcCDL2EKOTVLD8ugEn8+L4iTQ6KSFT3o?=
 =?us-ascii?Q?981/UEfvXNCmaTuIsLQTH8hpddrkAis0hpXvlf5fpwnUFUoczCQWZpoNAIE3?=
 =?us-ascii?Q?B2XGHTMuU1oWFkRnKm/R1O3dOXkEFoS7HnblGpzywxeuioeOH4Hcza3Pivbj?=
 =?us-ascii?Q?wJ3QGDe2gGnHymQTexVMVc2KrxKOsBCF69UNhfKbnoc+C5cYRvsr8P+0FDMe?=
 =?us-ascii?Q?F412fBlka/WbgALEMDwizonL6Aoxu1Zeaj5ZTLG8yGPGuAUTJNkjQim5tQ/V?=
 =?us-ascii?Q?HNsJDU0zSLStHaKGdhAQun7P+gOhfliBdCnU9O06ERdB0BYNeI0CsTLFa44u?=
 =?us-ascii?Q?MyMbG7Cuo/ezDCAM3t8q036EvNYI9ukgJFNsgH+XaNn+UUFJz8qY35cvFI3h?=
 =?us-ascii?Q?lmIy8al80AeZKAgu8+za0qH6Pfs7mmn7y70eJOfz6O2KvXJ5EvcD3ifZS7ew?=
 =?us-ascii?Q?JWb3eS237ezDeF3gwN87KEwcwYpXf70Og+l2h074Mbg+KyKZeqhBs76U6wMq?=
 =?us-ascii?Q?3RNVg3RYaSbbtc3+b0YknDvQUzny6xL4i357XTF+wih+wFTWt4fwDvrfKxnV?=
 =?us-ascii?Q?OEcz2uQRzsYVx5UwfL1LAiHxTM8ZCJpv/LgJuvPe8m0QH/eJkilSzQE+pVCO?=
 =?us-ascii?Q?FPzOpDgzjkoC3/JndmgfF2dtRJCaJyMV4qtcQ4g2rmH+b34twiy1N13bvGiA?=
 =?us-ascii?Q?I9zbCjfI2ezwEahrDBFihbg7FAViU0Hzvvtj9yFUBaOyK2yXLFT9WNtT7bD5?=
 =?us-ascii?Q?wCx54B0+2LAbHHQ3VT0SxuzFbbkmqR+K3PdUQ1xi30hbwafoWhfGKhVoxBnZ?=
 =?us-ascii?Q?Q3eXmMzJe3mEVOs+xsWfuH1T3R85+mkTwXnD5NJrrri0l95mB4GQatanzCBO?=
 =?us-ascii?Q?84PYK5aQT8G0/0pwxNIuUOJK5MjXefJTskuznHtySwAcQ1Ie9z24WwsDWNSd?=
 =?us-ascii?Q?5/t0K7je3rsR0wF26loZIfhVNugVVS4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F6E2AC479288946991E3B419EFC0410@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea278b3-b8e2-45c0-76d8-08da1a18c175
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2022 11:04:45.2959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FPW979wdEtV/+emd3B4yc90GLkftDSOUVZs1CKomBj6W0AJLib2xwtjb7bgsBDC9umS+NaX4AJRbOZRD5ugZzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7160
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 06:17:15PM +0800, kernel test robot wrote:
> >> net/bridge/br_if.c:145:10: error: no member named 'offload_count' in '=
struct net_bridge_port'
>                    if (p->offload_count) {
>                        ~  ^
>    130	/* When a port is added or removed or when certain port flags
>    131	 * change, this function is called to automatically manage
>    132	 * promiscuity setting of all the bridge ports.  We are always cal=
led
>    133	 * under RTNL so can skip using rcu primitives.
>    134	 */
>    135	void br_manage_promisc(struct net_bridge *br)
>    136	{
>    137		struct net_bridge_port *p;
>    138=09
>    139		list_for_each_entry(p, &br->port_list, list) {
>    140			/* Offloaded ports have a separate address database for
>    141			 * forwarding, which is managed through switchdev and not
>    142			 * through dev_uc_add(), so the promiscuous concept makes no
>    143			 * sense for them. Avoid updating promiscuity in that case.
>    144			 */
>  > 145			if (p->offload_count) {

Good point. Please imagine there's a static inline nbp_get_offload_count()
that returns 0 when CONFIG_NET_SWITCHDEV=3Dn. I'll address this for v2.

>    146				br_port_clear_promisc(p);
>    147				continue;
>    148			}
>    149=09
>    150			/* If bridge is promiscuous, unconditionally place all ports
>    151			 * in promiscuous mode too. This allows the bridge device to
>    152			 * locally receive all unknown traffic.
>    153			 */
>    154			if (br->dev->flags & IFF_PROMISC) {
>    155				br_port_set_promisc(p);
>    156				continue;
>    157			}
>    158=09
>    159			/* If vlan filtering is disabled, place all ports in
>    160			 * promiscuous mode.
>    161			 */
>    162			if (!br_vlan_enabled(br->dev)) {
>    163				br_port_set_promisc(p);
>    164				continue;
>    165			}
>    166=09
>    167			/* If the number of auto-ports is <=3D 1, then all other ports
>    168			 * will have their output configuration statically specified
>    169			 * through fdbs. Since ingress on the auto-port becomes
>    170			 * forwarding/egress to other ports and egress configuration is
>    171			 * statically known, we can say that ingress configuration of
>    172			 * the auto-port is also statically known.
>    173			 * This lets us disable promiscuous mode and write this config
>    174			 * to hw.
>    175			 */
>    176			if (br->auto_cnt =3D=3D 0 ||
>    177			    (br->auto_cnt =3D=3D 1 && br_auto_port(p)))
>    178				br_port_clear_promisc(p);
>    179			else
>    180				br_port_set_promisc(p);
>    181		}
>    182	}
>    183	=
