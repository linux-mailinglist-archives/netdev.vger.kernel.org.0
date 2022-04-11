Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CD04FBEFC
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbiDKO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242314AbiDKO0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:26:16 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A576336E2B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyAta1P42YzJvaO39CTjuNJOcBHTngINTYRZ1UNMH2f3aoMNBCC7vV3+SwOqiqX7zANXqIoIYmhLHxX0R+SxR4zAHbHQVT05UmkX9mkSWZhcQQy0KTmRLk2UbJ18TzBtgHrKGOWi4Kq0Lt3/htKlfv16fyGRKdfvWqvlp5D34c+tdqB0gr7pgju9RLOFSJvYr8obtLqhw78XKUOkBHz8WSqNPcGxmq1tYKB18fEiY6H3XOpLcNZGbTjjd8k+v9NqLIYTy8F9t0r08fMIZEh8FQK71UCj/YfX4J5Umg3AV5TI0/dYZUG2F3wf1mBhIV7q9JLj1P/SbFrxs8F0DJ1obQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+SV7IHz0Kljc7cLgcWdr1BATg/U2MQd/2Ta3EbPWvE=;
 b=cxI+eI4N97YNR4/3HrlzM2TVjZ4xkvI3YKdPntfaQnpG++fdrOyw3I53k3ysr9iHwl7lMCzPU8zvjnMpg8JAoeS+aEXVRhVvg/zAiTC+LaW4GdtFsLHjQT5tt8yH0lfYGsbtw625mnBh+ogRvK8yS1ZGfA+Q3XFSs6K8mY4goLrCfneYicAgXBDWhyQCwUNQn/yTY5i2Iw1ECyAGl4NCyUWB8L/h23ZlfgSk4Sa6CtqOAHWVmcTwS/FNv6+7yvyMx97TmeuvmurhQFJATdf9uVN1AvMQjIPn7mISS1GKjXH4tO1/9PPm+1tnivcwLb4AnmXJIfVA21/c6bgtcc+eJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+SV7IHz0Kljc7cLgcWdr1BATg/U2MQd/2Ta3EbPWvE=;
 b=q4frz4Te5BuzT5ekUWgAschqVMRA8EwmVgUyhGdNgJ8I4Azc8xjaJMtgGHzkRamug3owHtQ78nZ10T7XX4frppKR3/gTpgiuazMbLZaUfm8lLuvAvzqD6FtkuWFry5xXG9rUQl/x0QMiCQNjTEPTmZviLMQpp/SEgQdLhumhruo8Wt9x5cfRG/0IXZc+mNvWX0+Rls/TYwDg4WBhBuS+Yp9AChGfOqfPgx6AyEL/XlK+8qodZRXY+OFeszyzBHEVbIISezm5Q443BE2fsViH4Ed4sUNDNZqgSOktWig/M6L8HDI7S9wjEsqbNp0e7rl+owkhBR9FOl1UCL6FvdgSCQ==
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by AM7PR10MB3975.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:137::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:23:59 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:23:59 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Schild, Henning" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>
Subject: RE: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Topic: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Index: AQHYTaW3YftshBPJT0uGZWTNekz6x6zqtRYAgAANgcA=
Date:   Mon, 11 Apr 2022 14:23:59 +0000
Message-ID: <VI1PR10MB2446B3B9EC2441B962691D67ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
 <20220411132938.c3iy45lchov7xcko@skbuf>
In-Reply-To: <20220411132938.c3iy45lchov7xcko@skbuf>
Accept-Language: de-DE, en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2022-04-11T14:23:58Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=c387523b-c02b-4482-8e05-e52af27e4646;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7faf8fcd-a60d-4ec6-8056-08da1bc6eb79
x-ms-traffictypediagnostic: AM7PR10MB3975:EE_
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-microsoft-antispam-prvs: <AM7PR10MB39756C762261F7CB3E2348DAABEA9@AM7PR10MB3975.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Tg8MBAWMGeAcJxnovCS8eUSVbuJDz778ZC8ao38RuBw1dH76097+2spDM5pY05PyXwsUq5rEKZvPfP+N2C5hst98fNJDP/bp/PUC7hP7M9yPmfl38pi3KBnAY/zVxhAuqwV7ybMY/pmE7urP+mPskSCqwAY5niRAtD0E6XcMp8wibi5ACUa+jxm5M+DXj50iozUjXsVGUdWe7W0DCRoUZU5d9QTIgIZQybOyIbZ4ILnTg/KRJG6jTDgaGiWEyBPsE5N35YB7Hrxj2ehTDYTY/0MAolqh1IORDrk6zBZKwchieKwR5lEaVvb1JeCAO0vAB702e8ehqPA74VSmEo3F3hMGmXBQT2C3HyiINg66huM68+1Nbsw7BDcctgy0n1gWvZmwQBq432bRNtS9KHhdhMMXqFDeuWGfAzD/etkIOUuDJRNlHrqDKUZZxJt0HAYAEgaEIifF4IFGqwaY75aGqZMWes46gV7HdPM5KPrjGJP47K3FErE314dH3gnL5wchdmfWK8C2mcEYEAkeGYVL8Gvo8CmYhd/+trZAnsThvV2hRikD+WftPbQrvq5c9kgmL0gBfNtQ0HeqQjKCk4ptP7oFaF25PT4EMCJ/8YVIVeq4yywwkkFbVXIrA7Vz/i0Q9JrCzEKMyJIivut2f0NR1khpnwpzdAThNCzAPJPiNZYSrejwctalpcUOUImDZp3DhE6dHEyrvAkaj00o/ap1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(53546011)(26005)(33656002)(508600001)(55016003)(6916009)(54906003)(71200400001)(107886003)(66446008)(86362001)(186003)(38100700002)(64756008)(66556008)(8936002)(8676002)(66946007)(66476007)(83380400001)(7696005)(6506007)(9686003)(38070700005)(2906002)(52536014)(5660300002)(122000001)(82960400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fIGpT8vMhx+1eHZ8l0orRgJhiy+rqGUrr4aKfsELCbuLPY7QaQD6uixR6XlW?=
 =?us-ascii?Q?44cBCT6Abmz0SeWyNQY1eM+/XXBZ3zjl1ptv84a36o7Q+aGFzEwwOijojReF?=
 =?us-ascii?Q?cnZb4vRCPUerXm8J9iltwRTYwaQs4lbsW4Wnq1RnwkuDbQsgRCmvXZV7u+fK?=
 =?us-ascii?Q?BDwRlKSDaWTxwTIQm5fj969mNnJQIAmAwFD6sRjMLAyl3o/vzWPKEEDyUTTs?=
 =?us-ascii?Q?qQoDP+346foWyOYBH7TdrJkwnzHrGqBtpShvE2hyVSxL+GNip7q8NqA+cBbH?=
 =?us-ascii?Q?tWR9lPJ+chMryHQcPX8evUI+k+4yS816r+kIxWHC84PSVEiOK7B3xzSrONEX?=
 =?us-ascii?Q?lb7InNiVyI0llRsv9KSSgZJ4sXdHDPxiL5Os3nzwp9exB7wQzSJ06Fs1qgsP?=
 =?us-ascii?Q?RKi5cZUH6jYiHcCK5Ho9QIFU0UaKIIbIzEDd1ZPG2VSld0hhXnU0kwDcQIbv?=
 =?us-ascii?Q?OPE3bRlLsHsohIIbhbrwPj0CLqrSKtPaEm7zGqQEWnM0ZsV65TzrWUbjMPOE?=
 =?us-ascii?Q?qiDGkL9S8bAIc4b+jlWSpOjo5RxBchOAAnFDW4Uw/vcFwXVMI/ljI9ISYBmW?=
 =?us-ascii?Q?J9g2IcxG0Z1Dv0ZaS0rk6BE2zflwzpFJ7fycYAqyeIA4AxaU3tbvAmmD2yGU?=
 =?us-ascii?Q?2I4rA/jUdYAHqrp56zl17unae/sfUwGuvqr0Ai88QDphWUC1glE2IIc/S32r?=
 =?us-ascii?Q?20M80qLyuYtugx+AisUTu6n+2bi04ako7KGQbc5AVYg4hDHniWgOcFuuRWzq?=
 =?us-ascii?Q?0Av7V5sKkADam/ymi3klO5BclXDDl3peoHNJ5ueAjbZRdTXl24RdpvjdXNJa?=
 =?us-ascii?Q?hCiu2nYC17jhAxuA08D1FQCwNIIpecQYNu2cOsxQgDw3f5I1Qnmhp50/Ixr+?=
 =?us-ascii?Q?R3iRDUAXmcaY8Px1prMe3KhOmQs3m8l+sQ8Ua1WVWQncSTPwN6vn7XIfXAdV?=
 =?us-ascii?Q?7adlM0XUGvIkX+t6TZOEyNHx74BIuJ9WX6HDZvvig+ACckWHLrGC0zCu8V5Y?=
 =?us-ascii?Q?2+5wN+zEzkNPPyhoVcpw9yF+q6EO5jt2zBV/3NSY+aFLGyd+4JY4FyLNWOY8?=
 =?us-ascii?Q?f9/ANTDkDG0XRHC80pfOM+RzAkj12DY5qpApQa7aR24iUmdczH/iuc2LypRM?=
 =?us-ascii?Q?CKT3bnRdUoarkEM3tggiQEddaprKj1seknCmUvpZQ+OJmW4CfMg7o7Aw9rx4?=
 =?us-ascii?Q?vgmz7e7pjLc9kDrI48DNiHAhHZ0lt4pDs8pjH9QUYQ3DqDcWPDMdj3xxFBeM?=
 =?us-ascii?Q?4vpDnWirk9xD5jC4xp4Vun+5FiQ5UDPfCrb7n/MhVWSoCcFbSGcbroanLvaR?=
 =?us-ascii?Q?FCBDc5GVpNRAMpb5VRLUAWYaqwPBjIr4+k47+k5In2YJ6el9yhFiZEVDbJ09?=
 =?us-ascii?Q?2BYOUuFvI/1qdeR+NRJx6b9oDss5aXvBX0FWHVKz0c3Vxo+MQW/zrfLJEQZK?=
 =?us-ascii?Q?UxPuInXa9ZcRQXEOzVoO7uHLe2jubj/VyUDl4Y603wipUuiwKbueVeMpSZmc?=
 =?us-ascii?Q?ZY3vlgIChzrlNy+2UVEl/Wz2P7JomngHxqNkoO6v71gIWpmvppF3ymPO/hl9?=
 =?us-ascii?Q?sEKr7iOWauMGDjMzT/mqeaK0XkUO+OXQkzvmCTMIecdYOT+nB4bAC6lmLFxX?=
 =?us-ascii?Q?fZhphHgwA9IhEK9M7Ioi4aWY5knVXJ0ISrPhGOwyUXweXPvGtKgq0bRiM1Xr?=
 =?us-ascii?Q?s/fbJRs6of5gifNcNNAKKjVX90IXDN/H65W7reEvhthld2WNlSIH3RnzgY5K?=
 =?us-ascii?Q?gTAQKy0ada3uUypE2yUCRuIUEKyLC1M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7faf8fcd-a60d-4ec6-8056-08da1bc6eb79
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 14:23:59.3804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TWI771zkQ2lkjehBrWE6jR3es3VzubPauN/Lv+iAAbRv/brkPn4zzt4FVWBf1h5kVURVDo6Xg+lzUN36R0dJ2VFmIMpMZAEDbecuNkPaKtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR10MB3975
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As I mention, I do not own the tag driver code.

But for example for ETF, is like:

... tag_xmit(struct sk_buff *skb, struct net_device *dev)
+       struct tc_etf_qopt_offload etf;
...
+       etf.queue =3D skb_get_queue_mapping(skb);
+       if (dsa_slave_fetch_tc(dev, TC_SETUP_QDISC_ETF, &etf) =3D=3D 0 && e=
tf.enable) {
...

The port_fetch_tc callback is similar to port_setup_tc, only it reads the c=
onfiguration instead of setting it.

I think it is easier to add a generic call back, so we do not need to add a=
 new callback each time we support a new TC.

Erez



-----Original Message-----
From: Vladimir Oltean <olteanv@gmail.com>=20
Sent: Monday, 11 April 2022 15:30
To: Geva, Erez (ext) (DI PA DCP R&D 3) <erez.geva.ext@siemens.com>
Cc: netdev@vger.kernel.org; Andrew Lunn <andrew@lunn.ch>; Vivien Didelot <v=
ivien.didelot@gmail.com>; Florian Fainelli <f.fainelli@gmail.com>; Sudler, =
Simon (DI PA DCP TI) <simon.sudler@siemens.com>; Meisinger, Andreas (DI PA =
DCP TI) <andreas.meisinger@siemens.com>; Schild, Henning (T CED SES-DE) <he=
nning.schild@siemens.com>; Kiszka, Jan (T CED) <jan.kiszka@siemens.com>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information

On Mon, Apr 11, 2022 at 03:11:48PM +0200, Erez Geva wrote:
> Provide a callback for the DSA tag driver  to fetch information=20
> regarding a traffic control.
>=20
> Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
> ---

This is all? Can you show us some users?
