Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8915B90E1
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiINXME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiINXMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:12:03 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125F287094;
        Wed, 14 Sep 2022 16:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWqCEyqLN7EkgPJJ0Tfnq31qRzgTsJTYx/brCknHAwgtBOaOyoXh3tfSDx2mIygrAmyCDXeNXFoD0lbZrprw+5092qkqG8ttwlKJ7NKbz2Nnh00/cAyKlc7r9s4GpcDhuAN5Fq+ExSHM6hDz0R2mt4tIzwH3Mk4lrSmkplVUmk/4nVhYX06ZPnxJcLufm4TJAkt7T6tl6lTMFZvJdXA9lVoMBAx5hoksqCiXbJu3Wnq0M/+gRUZK4DpcUrvyS7gpnA9+yA6XDznZ3g5LWZy/4IjVOV9qY7cuaBB1Q6D/HjSo+KwfC0x66EeHvgIxsFO5Xxsrp7yr6J+2KXy3C6s+/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tO3QuR0zCgfem4zkPqgMzF0kR4gzkAsWM3Qb7/4mKUU=;
 b=ARCcb4imnyb0PT+y3ECfJp0unxNga7j3mA5Vmr4goSKTMpyJDpxWqZ5XTSowBRGVbt2WFZxVLB3FNUNemnwMTAudUs6B8FKVBhpY7aoXw94CreKoAeIPYXoFNJyEnHgduHn5RRmUGFap6wr/9mtn9Big5uWXQmACjF+eyZ96+WIl2jJOj71RP9UHRcNr/u+wYYoTYtJriBFQOF6ceBriFL8IiAJAXg3hzyA5rd2Y/uwZO+jYvVM8531lcF75rQgtxsRyc6566HdbDrUrUFZ7tXdfkpOZU291K0WWOpkuWnA0rZ4yPcF45YDPYs/8ZWm9bpY/UrzN9kqBvAGjjvlmBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tO3QuR0zCgfem4zkPqgMzF0kR4gzkAsWM3Qb7/4mKUU=;
 b=Nxxd8bRyGqBT723TbEgGZpe5gwUrupxNY8hgp6rbK5q7Z3FyNC2xIXINrqMotmZA4qq47wNFn4r/sln28wCn3i5rUu4gcZbO5AkmTqFwLSs8BUiCNzfBTiiETZdKN1/eHt0iJ/plz+AK3QokNfMmwSaNJnnnGMtGOu1be0xpWeU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6863.eurprd04.prod.outlook.com (2603:10a6:803:12f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 23:11:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 23:11:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Topic: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Index: AQHYyE9ZfT5bo6uCkEmd6s08JFlY763fi8UAgAACYgA=
Date:   Wed, 14 Sep 2022 23:11:59 +0000
Message-ID: <20220914231158.dwvcu4nvlfab7czh@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-5-vladimir.oltean@nxp.com> <87r10dh83l.fsf@intel.com>
In-Reply-To: <87r10dh83l.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|VI1PR04MB6863:EE_
x-ms-office365-filtering-correlation-id: 38b92187-6b16-47ff-9a30-08da96a6867b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PIVGRjnSX9qtYUKi3vTf2Dv0ri6Kys7uIrk8CdP9ns94wwj1dZb0oqhJX61DT1fuxp4V64WAfiXSepukKREpwOFGAN4egz+/nnQ96B6SlJClomoK3MB5wNv6D6R11Bw6JHZe/Bt+Mz61zafXyPOYuLFEE1dbirzW0dS8TfcUblDNj+igf0e2DDLtun6Qkd4F/eAj2n8M7OqQRZA9SNUZARsGRB/LkokhMk70vHc7pjoClMotivGglCd2ZnJ8R/AhouVyLZH6onnAggMhBd/kBZbdsd0sScC+dn06BSyHP4rBbC7BcMgeC8oxmo/7Qh7KGSom4N/pzJ2aYMw/ZpfPa8V0+D2G5b2I3RJP8W+aGonUp3ghScleyfb9KkDCSXT3CA+cbcdAUxT+eYE8Ivu0r3E4TAuA/HQNXyPb7MQI/AMLihDPZ1S2At+plka/EiOPmbkcpHg2TRrvR/sMpBIGuqaxsQ/gZUokstEWLv7/M4HGFK6g5B7BjY6uF76IILeMjQv2CoyAfgGrfFlvZySu/yux4QyoElCat2UkvNEzcoq4v3PfQbzu6kSw3MqPY6U6SCQYFMNEWhCf8HJ+eg+WjzDhva5JTJQQSbHmwqwFxJhFQTNeXPgdHtBXxJ/c4JCfN0wQqvqhToyK0UoWRUdCEyag32Yo399itkEDK6Q0BCZBFS3fUv93HKZ2YDd1tmCFsE0BcfCDn+g4YNHQp7iKFE7ELBUtoxZvMBvfghDkyaWVm9ADCzETS1QLcN9+reiE+EIedr719mUzDr5kqdd1KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199015)(4326008)(44832011)(26005)(2906002)(8936002)(316002)(41300700001)(76116006)(66946007)(478600001)(83380400001)(6506007)(66446008)(7416002)(66556008)(33716001)(8676002)(64756008)(1076003)(86362001)(6916009)(71200400001)(54906003)(9686003)(186003)(122000001)(6486002)(5660300002)(38100700002)(91956017)(6512007)(38070700005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eDoxTGx2CMJe8CpI8h0b+DkUThAzLK1N65+DvlznMHpMwU7L7WJil9lM0Bmq?=
 =?us-ascii?Q?xaoEPe4sQxtu2Z/LoY/EEhqqAJvu3BnTawNv6I8y3qITSI83dhe5NtQqLaC0?=
 =?us-ascii?Q?N91hMptzNumzZJP9ObawfuoLd98Tpb7nDDCCM7NURJ7uV1y9ibAouDtFJB2E?=
 =?us-ascii?Q?3TbFWyt5wmP4HnmvSUwEKBRWM+xphJVtIU4MUnoyC7q6vgHjEZoBiQoNVgVV?=
 =?us-ascii?Q?gKOU9QGYsg4fyjQLwjSn9n4Xuu/AtJIGPe+rbHGoZE+l92p4Z8DSVmugqBjF?=
 =?us-ascii?Q?jaLf56fjbqqA+plPUvpVqm338jzshBz0RnrM/KkDSfvQOR8HinwcAiXSC6QR?=
 =?us-ascii?Q?QawFzFYNgNrj5BWlOnKGv069oFlovyce+34VUK65cFBJQnzUqcvodHFwh4RJ?=
 =?us-ascii?Q?228mnVPuzpyyrAIUGzY8rXymNT18mPJ4ejr0MwflaL3TJXsPZm82uprJjqUY?=
 =?us-ascii?Q?GPv/O/yG9hVu5yaYTJf5Fkiyhp9tbStINDrzv9G8Fi+4GoFE9rwmBVSe1zLf?=
 =?us-ascii?Q?OsC5RjkmLR0qHyqh9wbB1KoQ0iVbZWqNmNXkLlfPMnIUxVs6FxiVdUBNHNxO?=
 =?us-ascii?Q?v5UQtgIEbJE4RWVHiBT7TgKMmFaWjT95dELTq+YRpOwOiuh08oHaEnTKvYVX?=
 =?us-ascii?Q?HfjSMG3BwjMrKuV22EM9Wg8Mo5JVrwegvncY/sKicPmPGWDq8ubOivNODSw/?=
 =?us-ascii?Q?cAkSKxvQxxB/zOKMuxB7goEOoKWsT2PANL0ccdhQhDGna5Zk8ZZFTNqzsLZl?=
 =?us-ascii?Q?ZGCEZvq+EncR2pftMSEpAGQlOQFQWKtvBdBPzkDaMX8XEIi+evIvkhO0hsR/?=
 =?us-ascii?Q?GIN5MiJLJ2Sf/Lk7TPeFn1mRRGHfqL41igCZx7kNQJcAaSpejp9U8AFgI0sE?=
 =?us-ascii?Q?MqnTrBVnTm+7Sk5IsZDbx7dCiDb0FgT+o+A6E1hZmMOHewdva9GpiLgN6rLG?=
 =?us-ascii?Q?J2fpjFGbbBnHs/MkViQlHg0uT1B3wUKKnprZDHifw7Wsggm2MMvgV9HVoFS1?=
 =?us-ascii?Q?AlMQC5Mje53IZKTk/wcZJhnWsyABNOpkzg+34sfFHQPNffOEcwQBejA3KM++?=
 =?us-ascii?Q?o1qJvvLYzZIAwOidIUi34wOAQ+irtKwTvkazgscobmYoLbduPrVdSLY4Rksj?=
 =?us-ascii?Q?Zceo/lZumC7kdKqvqWcMSHssKF7lp+7Ochp8kvPMxm9e8CKvrz1kkVbW9ri5?=
 =?us-ascii?Q?iy6zzoVV9ngE48mwgbRVB/GygUu+vneOR/GxjE9FRDASBK+ewfGFS8Rz5TgJ?=
 =?us-ascii?Q?GD1ue5DSJUAWmkP5rVDR1IG0CKavwB7yLMgxul1a4xWGBEoCF//sUDvZQZ94?=
 =?us-ascii?Q?P0khS5cOJ2zPGxrkLruq8QN/68fSmiuAUa3RJ/xqcZ+4ux9x31E0DlNKsrYU?=
 =?us-ascii?Q?kMSxEAqjKGFmHK4dbEeCeRRK8zcqxVHwHsHqHEZFa3aWTOIMuDg+PwSV4nf5?=
 =?us-ascii?Q?Kh4m1Cm+2gOrUHakzlIlC730k850qxl4QxTl4xQTB7pc7PHfZJh+jIr42dRY?=
 =?us-ascii?Q?tAAU0XFilTxEvhKJeRyEbwLFTJhRRFVKv27hPqyZ3InyPykfua2MMUG3VnbS?=
 =?us-ascii?Q?BgoyT9Z13H5RDqFQCw1VkOuNdyZhvVFVxAXVIsp70Gc3+e8mfcVCs5mMlaWS?=
 =?us-ascii?Q?BA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04E09ACFB48A1847A9820DD96B54C0A0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b92187-6b16-47ff-9a30-08da96a6867b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 23:11:59.1175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qYxAoXsWzBVicPwyPOIi9PgEmIOYQH8ELEEACdcS2WSPfJmYpmm+Yv19zSME1Y4T2xbSq2wSEbKGoG+UoC6+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 04:03:26PM -0700, Vinicius Costa Gomes wrote:
> Could you please add an example of the 'tc' command syntax you are
> thinking about?

I was working with this, as a matter of fact:

#!/bin/bash

h1=3Deno0
h2=3Deno2
swp1=3Dswp0
swp2=3Dswp4

ip link set $h2 address 00:01:02:03:04:05
ip link set $h1 up
ip link set $h2 up
tc qdisc del dev $swp1 root || :
ip link del br0 || :

ip link add br0 type bridge && ip link set br0 up
ip link set $swp1 master br0 && ip link set $swp1 up
ip link set $swp2 master br0 && ip link set $swp2 up
tc qdisc replace dev $swp1 root taprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 \
	sched-entry S 0x7f 990000 \
	sched-entry S 0x80  10000 \
	max-sdu 0 0 0 0 0 0 0 200 \
	flags 0x2

echo "Run:"
echo "isochron rcv --interface $h1 &"
echo "isochron send --interface $h2 --client 127.0.0.1 --cycle-time 0.001 -=
-frame-size 60 --omit-sync --num-frames 10 --priority 7 --vid 0"

I've also tested it in software mode, and at least on my system, a 10 us
interval is not really enough for the qdisc to make forward progress and
dequeue any packet. My application freezes until I destroy the qdisc and
re-create it using a larger interval for TC7. I'll debug that some more.
I was thinking, after the basic queueMaxSDU feature is merged, maybe
taprio could automatically further limit queueMaxSDU based on the
smallest intervals from the schedule. Something like a generalization of
vsc9959_tas_guard_bands_update(), basically.

> Another point to think about: does it make sense to allow 'only' the
> max-sdu to be changed, i.e. the user doesn't set an a schedule, nor a
> map, only the max-sdu information.

Maybe, I haven't tried. I think iproute2 doesn't currently support
skipping TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST.=
