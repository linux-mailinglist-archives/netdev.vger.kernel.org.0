Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABF46ADEDC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCGMhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCGMha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:37:30 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED5C457C2;
        Tue,  7 Mar 2023 04:37:28 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327BKmbA013844;
        Tue, 7 Mar 2023 12:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=5X/52BBVrEyXxemhknkupQfTaYRZbUr/+jHehWmIcdE=;
 b=O8ccTRuYhK9Q4mrMK0gpU5frEAfZnVykCql8aY2br9NKQN73HKErtsYmIeatEs2wo6AI
 FrfyIhii3HlmkoVAhxrxsbmVwM+lxZXG2uMhr9t/2kS28sjkJqkZAAqvilPhJ14H8jZi
 cfKesR9GP1A+FgrqXMXH/+oavwGxso6a9LDPBGJYTRq1fMXk1GRmOmeDIYwlNILLJO1a
 4hbBC6hCBFrzRWm0VotvDYAe1lK2BLy/9MfQoxdNKuadpjavc47QiFZArukkSg7KB1gg
 uK2qjkviR4iqIW/8lowcOMrZ86fWkMBk2h82dmQMI6QdkMISL3sFgyvLj0bfvRbPf/OG dA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3p3vyab2uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 12:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dv9S9k2cOp2JVDO7OMTDtEFEnqXaLfl0ctkkxH911/C0ZcUKuDlNmmond3N4FxysYU83EKfYx3fffWmQ5Qm8NLSYBAFLNZhE02OW7BitKLY/L0BJUw7XK71uMjnbakSu/vRX+qZol6KWvuZjVrlV1hxcH+bfiO0180o41/Oh59CN8xK966yK39dNxBWiHbinFwGw4ja0l3IYk5hKDtQnT/YSXdhxPYtvzO5zo9d8WY9Fo7XH9e57b8sJHYHwY5h+k0obY7cUPDG6pELzY3/qBrWmPToc+h0aoyOTESCnk1z7gWSZqrQVTA06g9J21irUWV0UQiLSZDyWR5JcMk1a3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5X/52BBVrEyXxemhknkupQfTaYRZbUr/+jHehWmIcdE=;
 b=Tzeuv/TjJ0EgzWCmlsu8kIQ9zN0Rl+JpoKQQiOwG0wyQptGmKpn2KGwWVcdBxXTE1gs+daG2Xvh+N+ZzhQ50U8AT77GYtPTeChSgV+MrqwTEUBN97J+gyFE8IC2CZ05HDtDlkia4nOliyJHCuoZ17TezTKUcXxkbbi4ZbdZZVx2XNuGpWkX6ZoMzig57bptQF8Cb8kWKVCgI2Vjj/dPGwEiWD1FhYXc6mAYAlk3gXoDFJJaziUacKvOwyaHJDK+t+7Bk6NdW4kpyruvRXDJParpbSgcr7U0e99gnYrCPe6ou7W6W5tEFkv+j2dB0nl9flk4NbiSpxaRznX68DfAudA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5192.namprd11.prod.outlook.com (2603:10b6:510:3b::9)
 by SA2PR11MB5210.namprd11.prod.outlook.com (2603:10b6:806:fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 12:11:53 +0000
Received: from PH0PR11MB5192.namprd11.prod.outlook.com
 ([fe80::aed:f30e:f18f:c74c]) by PH0PR11MB5192.namprd11.prod.outlook.com
 ([fe80::aed:f30e:f18f:c74c%8]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 12:11:52 +0000
From:   "Song, Xiongwei" <Xiongwei.Song@windriver.com>
To:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Response error to fragmented ICMP echo request
Thread-Topic: Response error to fragmented ICMP echo request
Thread-Index: AdlQ7X/oxr/JjbMvQfuLNLgfv6/HcA==
Date:   Tue, 7 Mar 2023 12:11:52 +0000
Message-ID: <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5192:EE_|SA2PR11MB5210:EE_
x-ms-office365-filtering-correlation-id: 2c216768-70a2-45ba-4da8-08db1f052312
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CegQt5YVphUQ+fdZLSlaHRHdzCivnuZIJ6ZNWdAGgmFb4o6/lG+oo5M1OEpkWGnvFZBcQDX+latW8voAAGMiFDiRC6cBCpLYLcMndFclKIMl3ZlBRoNPG5OqypSZtj44hi8xFrBIUhvc/uJ6H2Zxmxhu760sqbYPZ/pQgDUtPc3oe496qpjilZO+r3Q60BJdgmu+Zuv9vSvghNTXric/FIywzfgpMbhOIGOeUQmILBk4op4PYlBXsujFZi4QH9BDgxM7piVPj1A0bW4qkAlWAf5Ghy7XMECKH3PzLiN/eS3+9SjCFtnbiy2wsJbzZ91e6IGqrz5Wgvi8wFw9CWfWbeXhOLyqKX5he931Np9KMYnPrdXgZ43zgpbDtpqmBPNpFvVHK4fer8kbVsntFHEIOjBvMx1mCS/PMFjdjGvOp4bHO39vq+2azomnTPLKlakH/aMp+cDuottp/QECXx57HqHiotDxSDmtzTOMnuDPDiPfHt5lSXNRrdCuE6AQ6vuL7jCmzz01s87I+dwDfBy63LF/JLeW/7PQnEuRNSqBxVZINbqUvh7sb3D1QWmiq5UcQmd2ipc9D8RsK7BkTZzgAtls7yMzOfNZqFtMj9aDyDiXO51f1PavIuRTiNAqXytpyZUuqyu3ch8XFGsOMTTeXZYK/+rQGr+6/f4v4L3p6qn8xfvIDp8H3u3O3AVzMqJA8KtI2S6x+0P8/4mIq9oXOxHLArWEu9dx4hcdJhidiRw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5192.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39850400004)(346002)(376002)(396003)(451199018)(30864003)(38070700005)(7696005)(71200400001)(55016003)(110136005)(66574015)(41300700001)(86362001)(83380400001)(54906003)(4326008)(316002)(8676002)(33656002)(64756008)(76116006)(66946007)(478600001)(66556008)(66446008)(66476007)(8936002)(7416002)(5660300002)(52536014)(186003)(26005)(9686003)(122000001)(2906002)(38100700002)(6506007)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N7MNrFrXNaH5n1k2fFXOrT75lNlCpi3TEpPUnc6zcqSKx+Zzh4vqUZOVJz4E?=
 =?us-ascii?Q?BzBSWbtB/TNzGzBd7PjA2wEBZXj2DXGLl67WxzT4QTIyy31oR9DUKr7g7Qzc?=
 =?us-ascii?Q?c0Z6vNagPXiqeHOLS0QKHKWlfKrXXLzonOKb3uyTLec0UB0anFknEESwbWtV?=
 =?us-ascii?Q?AZ0GJ/7jN63QrYQ/TS+ZlAYFi6iKF1piTJfTS9Z6wYRYDWEmwOUhJ7s7O235?=
 =?us-ascii?Q?24nUDsArvRPruqUcfuo8AXyUaqxQ8xFPoc7j4VVqQkBc3/wBuOVENuP9BqWp?=
 =?us-ascii?Q?Cl8kSlKHrpQPeJGgO7ZN97tZQTF02wKuzgIfkX/YIsNzxfmrNSvjqh71+Ydj?=
 =?us-ascii?Q?i/et1dBP4i7uXLZtTZ/Ek4v/6FF6Xlo6eSXUcE1sWKqmYtt7aL7t3v0nqrhf?=
 =?us-ascii?Q?i5Ew0EcH5G0xSb5ybvsM2JicZJ1a3wozNwIgvuisUAeG1rfLl4VaelGl2CSP?=
 =?us-ascii?Q?IyOkFKe6UZjmsa0p5FtGroFfx//SCyN4GlF7Ut9mhrVJQ8Hdl439LPcYwAf+?=
 =?us-ascii?Q?kByihzEB94mhumqUZA7tvhao51qZkdznvDrA2w7yD8C/F9MhJrSdxEo0vZse?=
 =?us-ascii?Q?YkIre1ibQMHswNiBYoYXrhn7V9/2J1XnGBcRC+25YmR+XwEaYwpFQpo4HkFq?=
 =?us-ascii?Q?gzkBBSg2wy3/9Bmnmlc4KX0a2sbhUqcf6qSDKEPENfP66HQv/WusuvVR4WrP?=
 =?us-ascii?Q?b+9R1Rf1YCe4UdtTjcTkFD9nPNcyymthMq+g+3g2eywHBXpS6ovzdXPqjXXS?=
 =?us-ascii?Q?3H0Z/DUxrxOZIpm2Hk/Z0BfkbU+MZ7tqtCUfVhj3vAjj8/fdFQKxe5Diwzwj?=
 =?us-ascii?Q?ErLAjyYm13CgiZM0hBD0Q2kqUyNZjX911pRCPkm3++IYZaAvL+QVZCjDi0P+?=
 =?us-ascii?Q?zAGbrHPP1FBm1vEAkQ9EeGgTm4t/FFxlWyhOQNze6S3HcOPo+UyCCPetMvjO?=
 =?us-ascii?Q?c5p90F4+E6GTRVkFf7oJCyzIG2oM2JTOd9RU3Srta3sBThIljFixXb90oyTw?=
 =?us-ascii?Q?70nnx7uN2vBtiOOMGyiaFUAhUCw7c2kEXHajePImUBbDp0oxyYg8b1rqsrjb?=
 =?us-ascii?Q?0sbLuce1y+ddHFrdnOazZnzdMw+hfakDLPSF1Oj+X0HBXuTdwEGCOc5g+wAy?=
 =?us-ascii?Q?WQaPdyPQwO7UO1N+P6e4opPRYk9nGIS2NvnNZWtP2vQGJ0pog+1VS4Vlnxkc?=
 =?us-ascii?Q?Ab++vwuEbsOa5SgjZT3Kem9UvFe3m8pTqdVNuxopiTClMbrASs1YViY+ORx+?=
 =?us-ascii?Q?bgjM8ntsp+D+Bds7zuYGqV+KHcSk+PQjoNPwl05AY6YIt41phRLbiWD93t7e?=
 =?us-ascii?Q?PjOI20t4kyERIp85seHhGVdDWo/ftOZJuZ7C0kByoL3skYjkAe1qpPWi8nsH?=
 =?us-ascii?Q?SbwnzhCQ0eQur1Rqqdi0TpcwnGnwJ9zZv8g3y1sbs6TjOfJ5FwN7rtc+HIrQ?=
 =?us-ascii?Q?C838o5u2at+NCPMGjQsd8M9LELoVmMMqZYRuQftybJJTIhDxs88svg9wUO84?=
 =?us-ascii?Q?R+vcdRELQ7/4euSHgTrQCcOd13QSO1Qhi0fPEKcWfBT0RXHit6SlqKMKUeAN?=
 =?us-ascii?Q?vDKvNQcJCyoJkm4x4ikHVahBk1ENg82jtvjI3i1NSEh/Jt5tKtFVcGb4fWhe?=
 =?us-ascii?Q?Ag=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5192.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c216768-70a2-45ba-4da8-08db1f052312
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 12:11:52.6288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D9PMDjGfbLvFGXHxywKBmSdA4UnbJR2+yoabWM4J18yU00i2DCHHnIxR9kGIVOrXbbSNvFB+Z7GLX33wtpcpw/EqEPBBm0CjnJ/tZCvUWN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5210
X-Proofpoint-GUID: 1GWg_ZXpZ0XiiXowb6flsj7r_CIQNdJR
X-Proofpoint-ORIG-GUID: 1GWg_ZXpZ0XiiXowb6flsj7r_CIQNdJR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_06,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1011 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Experts,

We are using a NXP LS1028A board and facing an issue on icmp:

1. Scenario
Our test sends 2 fragments from VM to our board and expects echo reply but
with no response is present. send a fragment first, 2nd fragment is sent
with delay and test expects "ICMP ip reassembly time exceeded" but there
is also no response.

Detailed description of the testcase:

     * Action Send ICMP Echo request packet VM -> device. The packet contai=
ns: IP Source Address
     *               field set to address of VM, IP Destination Address fie=
ld set to address of the device
     *               Identification field set to 1, Fragmentation offset fi=
eld set to 0, MF flags
     *               set
     * Action Wait 100ms =20
    *
     * Action Send ICMP Echo request packet VM -> device. The packet contai=
ns: IP Source Address
     *               field set to address of VM, IP Destination Address fie=
ld set to address of the device
     *               Identification field set to 1, Fragmentation offset fi=
eld set to 1, MF flags
     *               cleared
     *
     * Result The ICMP echo response is received

2. We are using scapy to do test, the following is scapy packet configurati=
on

f1=3DEther(src=3D"26:84:d5:7f:7d:be", dst=3D"7C:72:6E:D4:44:C1")/Dot1Q(prio=
=3D0, vlan=3D984)/IP(src=3D"10.225.32.20", dst=3D"10.225.32.21")/'\x08\x00\=
xF7\xFF\x00\x00\x00\x00\x00'
f1.flags=3D'MF'
f1.frag=3D0
f1.id=3D1
f1.proto=3D'icmp'
// result of f1.show()
###[ Ethernet ]###=20
   dst       =3D 7C:72:6E:D4:44:C1
   src       =3D 26:84:d5:7f:7d:be
   type      =3D 0x8100
###[ 802.1Q ]###=20
      prio      =3D 0
      id        =3D 1
      vlan      =3D 984
      type      =3D 0x800
###[ IP ]###=20
         version   =3D 4
         ihl       =3D None
         tos       =3D 0x0
         len       =3D None
         id        =3D 1
         flags     =3D MF
         frag      =3D 0
         ttl       =3D 64
         proto     =3D icmp
         chksum    =3D None
         src       =3D 10.225.32.20
         dst       =3D 10.225.32.21
         \options   \
###[ Raw ]###=20
            load      =3D '\x08\x00\xf7\xff\x00\x00\x00\x00\x00'

=20
f2=3DEther(src=3D"26:84:d5:7f:7d:be", dst=3D"7C:72:6E:D4:44:C1")/Dot1Q(prio=
=3D0, vlan=3D984)/IP(src=3D"10.225.32.20", dst=3D"10.225.32.21")/'\x00\x00\=
x00\x00\x00\x00\x00\x00'
f2.frag=3D1
f2.id=3D1
f2.proto=3D'icmp'
// result of f2.show()
###[ Ethernet ]###=20
   dst       =3D 7C:72:6E:D4:44:C1
   src       =3D 26:84:d5:7f:7d:be
   type      =3D 0x8100
###[ 802.1Q ]###=20
      prio      =3D 0
      id        =3D 1
      vlan      =3D 984
      type      =3D 0x800
###[ IP ]###=20
         version   =3D 4
         ihl       =3D None
         tos       =3D 0x0
         len       =3D None
         id        =3D 1
         flags     =3D=20
         frag      =3D 1
         ttl       =3D 64
         proto     =3D icmp
         chksum    =3D None
         src       =3D 10.225.32.20
         dst       =3D 10.225.32.21
         \options   \
###[ Raw ]###=20
            load      =3D '\x00\x00\x00\x00\x00\x00\x00\x00'

3. Logs for this issue:

1). From ethtool
We use ethtool to check the hw status, found packet was dropped which point=
ed out
By drop_yellow_prio_0 field :

......snip......
failing SW:
rx_octets                       +64
rx_unicast                      +1
rx_frames_below_65_octets       +1
rx_yellow_prio_0                +1
*drop_yellow_prio_0              +1
......snip......


2). From netstat

The outputs of netstat for failing and working cases:
// failing logs

///before test
root@xxx:~# netstat -s
Ip:
    Forwarding: 1
    3 total packets received
    0 forwarded
    0 incoming packets discarded
    3 incoming packets delivered
    3 requests sent out
Icmp:
    3 ICMP messages received
    0 input ICMP message failed
    ICMP input histogram:
        echo requests: 3
    3 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        echo replies: 3
IcmpMsg:
        InType8: 3
        OutType0: 3
Tcp:
    0 active connection openings
    0 passive connection openings
    0 failed connection attempts
    0 connection resets received
    0 connections established
    0 segments received
    0 segments sent out
    0 segments retransmitted
    0 bad segments received
    0 resets sent
Udp:
    0 packets received
    0 packets to unknown port received
    0 packet receive errors
    0 packets sent
    0 receive buffer errors
    0 send buffer errors
UdpLite:
TcpExt:
    0 packet headers predicted
IpExt:
    InOctets: 252
    OutOctets: 252
    InNoECTPkts: 3

///after test
root@xxx:~# netstat -s
Ip:
    Forwarding: 1
    3 total packets received
    0 forwarded
    0 incoming packets discarded
    3 incoming packets delivered
    3 requests sent out
Icmp:
    3 ICMP messages received
    0 input ICMP message failed
    ICMP input histogram:
        echo requests: 3
    3 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        echo replies: 3
IcmpMsg:
        InType8: 3
        OutType0: 3
Tcp:
    0 active connection openings
    0 passive connection openings
    0 failed connection attempts
    0 connection resets received
    0 connections established
    0 segments received
    0 segments sent out
    0 segments retransmitted
    0 bad segments received
    0 resets sent
Udp:
    0 packets received
    0 packets to unknown port received
    0 packet receive errors
    0 packets sent
    0 receive buffer errors
    0 send buffer errors
UdpLite:
TcpExt:
    0 packet headers predicted
IpExt:
    InOctets: 252
    OutOctets: 252
    InNoECTPkts: 3


// working case

///before test

root@xxx:~#netstat -s
Ip:
    Forwarding: 1
    3 total packets received
    0 forwarded
    0 incoming packets discarded
    3 incoming packets delivered
    3 requests sent out
Icmp:
    3 ICMP messages received
    0 input ICMP message failed
    ICMP input histogram:
        echo requests: 3
    3 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        echo replies: 3
IcmpMsg:
        InType8: 3
        OutType0: 3
Tcp:
    0 active connection openings
    0 passive connection openings
    0 failed connection attempts
    0 connection resets received
    0 connections established
    0 segments received
    0 segments sent out
    0 segments retransmitted
    0 bad segments received
    0 resets sent
Udp:
    0 packets received
    0 packets to unknown port received
    0 packet receive errors
    0 packets sent
    0 receive buffer errors
    0 send buffer errors
UdpLite:
TcpExt:
    0 packet headers predicted
IpExt:
    InOctets: 252
    OutOctets: 252
    InNoECTPkts: 3

///after test

root@xxx:~#netstat -s
Ip:
    Forwarding: 1
    4 total packets received
    0 forwarded
    0 incoming packets discarded
    3 incoming packets delivered
    4 requests sent out
******difference******
    1 fragments dropped after timeout
    1 reassemblies required
    1 packet reassemblies failed
Icmp:
    3 ICMP messages received
    0 input ICMP message failed
    ICMP input histogram:
        echo requests: 3
    4 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        time exceeded: 1
        echo replies: 3
IcmpMsg:
        InType8: 3
        OutType0: 3
        OutType11: 1
******difference******
Tcp:
    0 active connection openings
    0 passive connection openings
    0 failed connection attempts
    0 connection resets received
    0 connections established
    0 segments received
    0 segments sent out
    0 segments retransmitted
    0 bad segments received
    0 resets sent
Udp:
    0 packets received
    0 packets to unknown port received
    0 packet receive errors
    0 packets sent
    0 receive buffer errors
    0 send buffer errors
UdpLite:
TcpExt:
    0 packet headers predicted
IpExt:
    InOctets: 294
    OutOctets: 308
    InNoECTPkts: 4

3). From pcap file(the pcap was collected on the senderside (VM))

Frame 1: 64 bytes on wire (512 bits), 64 bytes captured (512 bits)
    Encapsulation type: Ethernet (1)
    Arrival Time: Dec 16, 2022 16:36:42.803640000 CST
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1671179802.803640000 seconds
    [Time delta from previous captured frame: 0.000000000 seconds]
    [Time delta from previous displayed frame: 0.000000000 seconds]
    [Time since reference or first frame: 0.000000000 seconds]
    Frame Number: 1
    Frame Length: 64 bytes (512 bits)
    Capture Length: 64 bytes (512 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: eth:ethertype:vlan:ethertype:arp]
Ethernet II, Src: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f), Dst: aa:3a:b3:e7:6=
7:5c (aa:3a:b3:e7:67:5c)
    Destination: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        Address: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        .... ..1. .... .... .... .... =3D LG bit: Locally administered addr=
ess (this is NOT the factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Source: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        Address: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        .... ..0. .... .... .... .... =3D LG bit: Globally unique address (=
factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Type: 802.1Q Virtual LAN (0x8100)
802.1Q Virtual LAN, PRI: 6, DEI: 0, ID: 981
    110. .... .... .... =3D Priority: Internetwork Control (6)
    ...0 .... .... .... =3D DEI: Ineligible
    .... 0011 1101 0101 =3D ID: 981
    Type: ARP (0x0806)
    Padding: 0000000000000000000000000000
    Trailer: 00000000
Address Resolution Protocol (request)
    Hardware type: Ethernet (1)
    Protocol type: IPv4 (0x0800)
    Hardware size: 6
    Protocol size: 4
    Opcode: request (1)
    Sender MAC address: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
    Sender IP address: 10.225.32.5
    Target MAC address: 00:00:00_00:00:00 (00:00:00:00:00:00)
    Target IP address: 10.225.32.4

Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
    Encapsulation type: Ethernet (1)
    Arrival Time: Dec 16, 2022 16:36:42.803664000 CST
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1671179802.803664000 seconds
    [Time delta from previous captured frame: 0.000024000 seconds]
    [Time delta from previous displayed frame: 0.000024000 seconds]
    [Time since reference or first frame: 0.000024000 seconds]
    Frame Number: 2
    Frame Length: 46 bytes (368 bits)
    Capture Length: 46 bytes (368 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: eth:ethertype:vlan:ethertype:arp]
Ethernet II, Src: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c), Dst: 7c:72:6e:d4:4=
4:5f (7c:72:6e:d4:44:5f)
    Destination: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        Address: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        .... ..0. .... .... .... .... =3D LG bit: Globally unique address (=
factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Source: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        Address: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        .... ..1. .... .... .... .... =3D LG bit: Locally administered addr=
ess (this is NOT the factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Type: 802.1Q Virtual LAN (0x8100)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 981
    000. .... .... .... =3D Priority: Best Effort (default) (0)
    ...0 .... .... .... =3D DEI: Ineligible
    .... 0011 1101 0101 =3D ID: 981
    Type: ARP (0x0806)
Address Resolution Protocol (reply)
    Hardware type: Ethernet (1)
    Protocol type: IPv4 (0x0800)
    Hardware size: 6
    Protocol size: 4
    Opcode: reply (2)
    Sender MAC address: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
    Sender IP address: 10.225.32.4
    Target MAC address: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
    Target IP address: 10.225.32.5

Frame 3: 47 bytes on wire (376 bits), 47 bytes captured (376 bits)
    Encapsulation type: Ethernet (1)
    Arrival Time: Dec 16, 2022 16:36:49.915062000 CST
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1671179809.915062000 seconds
    [Time delta from previous captured frame: 7.111398000 seconds]
    [Time delta from previous displayed frame: 7.111398000 seconds]
    [Time since reference or first frame: 7.111422000 seconds]
    Frame Number: 3
    Frame Length: 47 bytes (376 bits)
    Capture Length: 47 bytes (376 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: eth:ethertype:vlan:ethertype:ip:data]
Ethernet II, Src: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c), Dst: 7c:72:6e:d4:4=
4:5f (7c:72:6e:d4:44:5f)
    Destination: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        Address: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        .... ..0. .... .... .... .... =3D LG bit: Globally unique address (=
factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Source: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        Address: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        .... ..1. .... .... .... .... =3D LG bit: Locally administered addr=
ess (this is NOT the factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Type: 802.1Q Virtual LAN (0x8100)
802.1Q Virtual LAN, PRI: 0, DEI: 1, ID: 981
    000. .... .... .... =3D Priority: Best Effort (default) (0)
    ...1 .... .... .... =3D DEI: Eligible
    .... 0011 1101 0101 =3D ID: 981
    Type: IPv4 (0x0800)
Internet Protocol Version 4, Src: 10.225.32.4, Dst: 10.225.32.5
    0100 .... =3D Version: 4
    .... 0101 =3D Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
        0000 00.. =3D Differentiated Services Codepoint: Default (0)
        .... ..00 =3D Explicit Congestion Notification: Not ECN-Capable Tra=
nsport (0)
    Total Length: 29
    Identification: 0x0001 (1)
    Flags: 0x2000, More fragments
        0... .... .... .... =3D Reserved bit: Not set
        .0.. .... .... .... =3D Don't fragment: Not set
        ..1. .... .... .... =3D More fragments: Set
    Fragment offset: 0
    Time to live: 64
    Protocol: ICMP (1)
    Header checksum: 0x0515 [validation disabled]
    [Header checksum status: Unverified]
    Source: 10.225.32.4
    Destination: 10.225.32.5
Data (9 bytes)

0000  08 00 f7 ff 00 00 00 00 00                        .........
    Data: 0800f7ff0000000000
    [Length: 9]

Frame 4: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
    Encapsulation type: Ethernet (1)
    Arrival Time: Dec 16, 2022 16:36:50.063589000 CST
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1671179810.063589000 seconds
    [Time delta from previous captured frame: 0.148527000 seconds]
    [Time delta from previous displayed frame: 0.148527000 seconds]
    [Time since reference or first frame: 7.259949000 seconds]
    Frame Number: 4
    Frame Length: 46 bytes (368 bits)
    Capture Length: 46 bytes (368 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: eth:ethertype:vlan:ethertype:ip:icmp:data]
Ethernet II, Src: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c), Dst: 7c:72:6e:d4:4=
4:5f (7c:72:6e:d4:44:5f)
    Destination: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        Address: 7c:72:6e:d4:44:5f (7c:72:6e:d4:44:5f)
        .... ..0. .... .... .... .... =3D LG bit: Globally unique address (=
factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Source: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        Address: aa:3a:b3:e7:67:5c (aa:3a:b3:e7:67:5c)
        .... ..1. .... .... .... .... =3D LG bit: Locally administered addr=
ess (this is NOT the factory default)
        .... ...0 .... .... .... .... =3D IG bit: Individual address (unica=
st)
    Type: 802.1Q Virtual LAN (0x8100)
802.1Q Virtual LAN, PRI: 0, DEI: 1, ID: 981
    000. .... .... .... =3D Priority: Best Effort (default) (0)
    ...1 .... .... .... =3D DEI: Eligible
    .... 0011 1101 0101 =3D ID: 981
    Type: IPv4 (0x0800)
Internet Protocol Version 4, Src: 10.225.32.4, Dst: 10.225.32.5
    0100 .... =3D Version: 4
    .... 0101 =3D Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
        0000 00.. =3D Differentiated Services Codepoint: Default (0)
        .... ..00 =3D Explicit Congestion Notification: Not ECN-Capable Tra=
nsport (0)
    Total Length: 28
    Identification: 0x0001 (1)
    Flags: 0x0001
        0... .... .... .... =3D Reserved bit: Not set
        .0.. .... .... .... =3D Don't fragment: Not set
        ..0. .... .... .... =3D More fragments: Not set
    Fragment offset: 8
    Time to live: 64
    Protocol: ICMP (1)
    Header checksum: 0x2515 [validation disabled]
    [Header checksum status: Unverified]
    Source: 10.225.32.4
    Destination: 10.225.32.5
    [2 IPv4 Fragments (16 bytes): #3(9), #4(8)]
        [Frame: 3, payload: 0-8 (9 bytes)]
        [Frame: 4, payload: 8-15 (8 bytes)]
            [Fragment overlap: True]
        [Fragment count: 2]
        [Reassembled IPv4 length: 16]
        [Reassembled IPv4 data: 0800f7ff000000000000000000000000]
Internet Control Message Protocol
    Type: 8 (Echo (ping) request)
    Code: 0
    Checksum: 0xf7ff [correct]
    [Checksum Status: Good]
    Identifier (BE): 0 (0x0000)
    Identifier (LE): 0 (0x0000)
    Sequence number (BE): 0 (0x0000)
    Sequence number (LE): 0 (0x0000)
    Data (8 bytes)

0000  00 00 00 00 00 00 00 00                           ........
        Data: 0000000000000000
        [Length: 8]

4). What we've found so far

According binary search, we found out the following commit causes this issu=
e:
a4ae997adcbd("net: mscc: ocelot: initialize watermarks to sane defaults").
Without this commit the test case was passed.

Could you please take a look? Please let me know if you need more debug inf=
o.

Regards,
Xiongwei
