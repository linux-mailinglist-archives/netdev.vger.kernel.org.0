Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D83F2A2E68
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgKBPfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:35:54 -0500
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:62691
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbgKBPfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 10:35:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLbpjuPbuiRvTG1RaOz3+ptroh1n7r9D79R3/WZuA1BqqHgMYyZ1npx3dRCKRRioyzBvVpYEdAwNW8KwYx8lvdIpTV1hel0QdLh6uYSA3RuXFdEMyKc5pwpvZh1WqYGeBk3bhuNggbRR4qSK+CK4Dz4lIg2kQc0Wn0KTis3XOkY1SVQGaYEQe3RLNk8wqBUCMYb6fpe/EqsvBRRu8YMYk/7WmLB3s/GhqFyksHu/zJ3Qa2V/K3vSlEjzFEw60OAmKm57QEbj1CwysegKbHr52F/PYjnqgh4QbOvoqiukDi6IyuoyEnXkMCMlYPs95BoJ4SDaOhRRGUwn2ZNFzwaCcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UL6fIUHgm5reg+U87yV1K5BWkuHpOez0kTs2QNZMtuw=;
 b=fCxX3OgBp5NBghgd/I0f5H9pcC5AU+XVfI2rvG13PlY1+zGqSu6YXmLJz/LGTSjiUtqi+k42k61NF7xZ7+VEu2ROQHbVuf6yK12NAbZb5WUeqxA+YDe9+P7TaRC1U7gchS0mOleWlvo+lSEb+5BoIOHQBApRCCRbOe0iHODSIWVGznh+aGqGQ0t2aD4rqccNUO7kGDKlfAx06LQq/zLEMzXY8m8y05WROsT2iZQuXwk08hqBmH8mBv3+JB/iudFNptCWfXOifYfeuHLiHaBrrN3X4MlozLt7GTtZqPLWYF9SAALFD81arrew9PWICuFYRVPqzoJOJUe9g0+p4z0Zxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UL6fIUHgm5reg+U87yV1K5BWkuHpOez0kTs2QNZMtuw=;
 b=llb1Ousiup+OexW/yL/6jS4rdjNdYJDZnYgv2hA1wRl5tke6/2HzeMPs0HXJxbaBU9CezJSenbgzfYETOd3Jp/SIA13zpGTIjfkqqqWSmYMAAHTfNT8AIOji8No47xsJ+T9ndFlHclJsmpmi5SW0ahMFD8bH4Zp2TsBYfnAriLI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3965.eurprd04.prod.outlook.com (2603:10a6:803:3e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 15:35:49 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 15:35:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/7] net: mscc: ocelot: use the pvid of zero when
 bridged with vlan_filtering=0
Thread-Topic: [PATCH net-next 1/7] net: mscc: ocelot: use the pvid of zero
 when bridged with vlan_filtering=0
Thread-Index: AQHWr3C1eyZYc+uP1E2/DC1hu+Q/h6m0iqsAgAByIAA=
Date:   Mon, 2 Nov 2020 15:35:49 +0000
Message-ID: <20201102153548.njizmvohmum6rxdj@skbuf>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
 <20201031102916.667619-2-vladimir.oltean@nxp.com>
 <20201102084720.GA7761@piout.net>
In-Reply-To: <20201102084720.GA7761@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f737fb17-31bf-458b-c370-08d87f44f9bc
x-ms-traffictypediagnostic: VI1PR04MB3965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3965077A5CDEA5F60D270557E0100@VI1PR04MB3965.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MuMDr7nlQxdRHpy6nS5g18MLkgz2vyYjM/Pxq7/mraLHyWHoYhGG9udAmM/gICcwYDNToqvJ+Pwv+1nTtqv6EhYuhF2hVktY0bch3tXXW9XPx8Dj1fuFXCMvmlJy/KVU1an8V8DZkBC24dc3epltCVZiUu7+rOlRfwbfasyKJ+cOkzbAz4xikkSzLxprJ7bl9xlDh8p4oKip30Y51vcSu700RQXX7j4uuW57Rln5Ni/a64rW0A7YM98nGtSjzuCblBvHmbUITj4WjWmGtb06Lcy/jOKVrrZn+sszD7IpnxTMcT7UfVwszHtPUMouyfUcoOdX5eW45E47mQ1wDph6Aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(136003)(366004)(346002)(5660300002)(478600001)(66476007)(9686003)(83380400001)(44832011)(64756008)(66446008)(6486002)(2906002)(8676002)(186003)(26005)(66946007)(66556008)(76116006)(86362001)(91956017)(6916009)(4326008)(8936002)(6506007)(54906003)(33716001)(6512007)(71200400001)(1076003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: uh3jq2a61QAOXbmrGhVNK2OSCTfYsWoqGRe+ULV5ruj3ECSAk4MD6k/MG5j1AdmjfYbmxKHrAOy7+aKEY1bAep3kKXMjrTcnYqMuQtBSfNoKNPSXw7Yf86XxyQA8VJcZvJC9jQW17fQi1bvfu6XT6TPPtPWSBgvWa2NVE8TgjS4iGbc0S2bpedZfjo8yOy8gVXM0pkh62NUcBgo/osJNNai7xEqGdvyUqt2fzPZ6py8S9FDVlRhDeSKDrogi+mBBm/iNqmfjygncHxJeYN+eGitvu8z1cOq3b1Y91ZHm1PbYIvv6soNEIR8pSOYauFHE+fFMy0jt4siAJekQ1b9p8uTSog59Hd9sM35HxWfIkCUXk1XD7NYECvwz6D+tM3YZFDPPIG84P0mSLrWzimRlv460lO9Z2PghGUIidOEL4a97MfwATz387DgCzieHDdTTDPZ13Hh49c5mjlyOvn9vAVoQY2TJVYs7Ua7ZeI71amgl4FF6cSnAVgtwE3kH/W4K/N1eTDh/WXOv1CPNNakQiaiXUEsrXx2kl+YBN3uhqm5oiEUMnB6CJ0g/d56HQgN0olOTVJIUgJZliPb3Sno6oH8RJCS0GKPqbzt3Y86PArO+DEalb8smZmXilcaH/L9OA6alRvSDF22GdouLP/iwhQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D609BECEE87184AB68E4734120A2FE5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f737fb17-31bf-458b-c370-08d87f44f9bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 15:35:49.6646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2DlvpCxZP96ZwRAetyFqPVH5HaC/X7at7XP0htNk1l6yVhvonZKFlBdSJwdf28m/Fh2Djzt7DdxYHoYNXXxkAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 09:47:20AM +0100, Alexandre Belloni wrote:
> IIRC, we are using pvid 1 because else bridging breaks when
> CONFIG_VLAN_8021Q is not enabled. Did you test that configuration?

Pertinent question.
I hadn't tested that, but I did now.

[root@LS1028ARDB ~] # zcat /proc/config.gz | grep 8021Q
# CONFIG_VLAN_8021Q is not set
[root@LS1028ARDB ~] # ip addr flush swp0
[root@LS1028ARDB ~] # ip addr add 192.168.1.2/24 dev swp0
[root@LS1028ARDB ~] # ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1): 56 data bytes
64 bytes from 192.168.1.1: seq=3D0 ttl=3D64 time=3D0.717 ms
64 bytes from 192.168.1.1: seq=3D1 ttl=3D64 time=3D0.442 ms
^C
--- 192.168.1.1 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max =3D 0.442/0.579/0.717 ms
[root@LS1028ARDB ~] # ip addr flush swp0
[root@LS1028ARDB ~] # ip link add br0 type bridge
[root@LS1028ARDB ~] # ip link set swp0 master br0
[  409.576303] br0: port 1(swp0) entered blocking state
[  409.581380] br0: port 1(swp0) entered disabled state
[  409.586738] device swp0 entered promiscuous mode
[  409.591866] br0: port 1(swp0) entered blocking state
[  409.596852] br0: port 1(swp0) entered forwarding state
[root@LS1028ARDB ~] # ip addr add 192.168.1.2/24 dev br0
[root@LS1028ARDB ~] # ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1): 56 data bytes
64 bytes from 192.168.1.1: seq=3D0 ttl=3D64 time=3D0.768 ms
64 bytes from 192.168.1.1: seq=3D1 ttl=3D64 time=3D0.657 ms
64 bytes from 192.168.1.1: seq=3D2 ttl=3D64 time=3D0.509 ms
64 bytes from 192.168.1.1: seq=3D3 ttl=3D64 time=3D0.513 ms
64 bytes from 192.168.1.1: seq=3D4 ttl=3D64 time=3D0.496 ms
^C
--- 192.168.1.1 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max =3D 0.496/0.588/0.768 ms
[root@LS1028ARDB ~] # ip link del br0
[  135.526825] device swp0 left promiscuous mode
[  135.531729] br0: port 1(swp0) entered disabled state
[root@LS1028ARDB ~] # ip addr add 192.168.1.2/24 dev swp0
[root@LS1028ARDB ~] # ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1): 56 data bytes
64 bytes from 192.168.1.1: seq=3D0 ttl=3D64 time=3D0.783 ms
64 bytes from 192.168.1.1: seq=3D1 ttl=3D64 time=3D0.289 ms
64 bytes from 192.168.1.1: seq=3D2 ttl=3D64 time=3D0.412 ms
64 bytes from 192.168.1.1: seq=3D3 ttl=3D64 time=3D0.399 ms
64 bytes from 192.168.1.1: seq=3D4 ttl=3D64 time=3D0.396 ms
64 bytes from 192.168.1.1: seq=3D5 ttl=3D64 time=3D0.390 ms
^C
--- 192.168.1.1 ping statistics ---
6 packets transmitted, 6 packets received, 0% packet loss
round-trip min/avg/max =3D 0.289/0.444/0.783 ms

There's no logical reason why it wouldn't work. Thanks to your code
which ensures VLAN 0 is in the VLAN table. Nobody is removing VLAN 0
right now.

	/* Because VLAN filtering is enabled, we need VID 0 to get untagged
	 * traffic.  It is added automatically if 8021q module is loaded, but
	 * we can't rely on it since module may be not loaded.
	 */
	ocelot->vlan_mask[0] =3D GENMASK(ocelot->num_phys_ports - 1, 0);
	ocelot_vlant_set_mask(ocelot, 0, ocelot->vlan_mask[0]);

I cannot test the mscc_ocelot driver, I am only testing felix DSA, and
for that reason I can't even go very far down the history. Remember that
when CONFIG_VLAN_8021Q is disabled, CONFIG_BRIDGE_VLAN_FILTERING also
needs to be disabled. So logically speaking, nobody calls any VLAN
function when CONFIG_VLAN_8021Q is disabled. The standalone
configuration should work in this mode too, shouldn't it? I am not sure
if there's any relevant difference for mscc_ocelot.=
