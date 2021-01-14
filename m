Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C83E2F6D7A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbhANVr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:47:59 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727196AbhANVr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:47:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10ELTihl002122;
        Thu, 14 Jan 2021 13:47:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=qo1S7pD+MGbpB4hcFE+VNh9Ylq0zHf0BI5DWz4EMVdc=;
 b=eV0rLYJoM0w3AuuwmeZO3VpRUuPtWAt0bxcESerse4vpW8h6JrRt3u9bCsG2EJrScHEM
 0LjZndi+Peao/9JBTguEyL3ZPLS6atiwKTWXMBj8VGtc05HUtWGUpEiAYqbUySP0Vwy9
 nXJDu51zVEuj2EYlrcfvSu3P+s+KOds8Pyjt+oADMhQayb/aEce2RvVnwgq3HHuuk3RS
 6uaFLvH79cx/wyMm5Woin4aaFc9gsLkuhKZgNpKos6/1deauz0waPD10SM320M1kR3Ke
 CsvDkfARSLHyvcTR4n4KrSZmL0dptkFfkGKjT/+Xzvz0JB4YgzhOl9mJZvU4KQ2tCBkt cQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqt0vs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 13:47:00 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jan
 2021 13:46:58 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jan
 2021 13:46:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 14 Jan 2021 13:46:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUJN/ExS0L2zMr4mvdw1Ftq1QxUKvHuTXs+UXStU3dFCOG46YLtgldeX55qlNaX5b5Z6tAX9reqEDSRMvM9BB0mauRluVZje5bUeM8Ft6jf8H4pplKFk+pOuEHo+i5Pq0i4d3OP+C4n7pt7bYML/NJCNiyEXfaxPcLM59k62doN/z+1XXGSCWK9zMDgECZdohQ461kSVDvfuKmi5PTZnPMqA9MT2g1J04ooB9kohK7vPVTEUDn6aE2It93WBOtZMqzW6H61B6gVnGd3gwV+GxrsMv/CgYW/ULHevmO7T46u060R7+7+JMcMNjd/N2nj4Dm0HK0kWOWQXOoAoyFQqXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qo1S7pD+MGbpB4hcFE+VNh9Ylq0zHf0BI5DWz4EMVdc=;
 b=PugWgIu+tKshMDWtrfHOBTL11oIa5lsCmUk+U2XONp2OR+/vDyQLZU5uKh8t5tThi+LuhAp44bqLAl/VnimLlSBFU+5n0JjA2hOgwbnLRvOVDa2qngjBUUPoiPO6ktVAbNsy9r2eJT+Y9fJ95qPfGOogbxv8RBNwMbqbZ2eqXPFgVhpj06fQpvTqE/8LzUlSwEma1NQN5K7gG1yPieHcKWiAZtQ7feY3D+M3oOKtIqpoAELFaK5SxWjSEtERbBkV+pXDkkffmQDfx5DfQVvDPTD+ahronlRLo2zLPF/3CFiIte5n0felS9CjLZjF4kITgS04suiCZEMp9ekBmjRKpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qo1S7pD+MGbpB4hcFE+VNh9Ylq0zHf0BI5DWz4EMVdc=;
 b=cbMx06Wuve1GoHYvm5JrXDbWeKV6u6KpPQhCexO6rF5fhmTySD/hRSGR7JvWzhU8dqNJsGB/AAz5TR6XejJTS7k/f64l9k1tboL9EZhxDMpjg89WLa4CRLij2MoEiY9LDNUfWtDKBd8eR1AqpeO2RYVeAggMjy5aIiX0M29e87M=
Received: from CO6PR18MB4083.namprd18.prod.outlook.com (2603:10b6:5:348::9) by
 MW2PR18MB2185.namprd18.prod.outlook.com (2603:10b6:907:5::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.11; Thu, 14 Jan 2021 21:46:55 +0000
Received: from CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::e911:9f46:795f:a420]) by CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::e911:9f46:795f:a420%4]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 21:46:55 +0000
From:   "Taras Chornyi [C]" <tchornyi@marvell.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
Subject: Re: [PATCH net-next] net: marvell: prestera: fix uninitialized vid in
 prestera_port_vlans_add
Thread-Topic: [PATCH net-next] net: marvell: prestera: fix uninitialized vid
 in prestera_port_vlans_add
Thread-Index: AQHW6r7GluD9pVsAXEiI80TTQU7EpQ==
Date:   Thu, 14 Jan 2021 21:46:55 +0000
Message-ID: <CO6PR18MB40835482AA82B3A34FCAA165C4A81@CO6PR18MB4083.namprd18.prod.outlook.com>
References: <20210114083556.2274440-1-olteanv@gmail.com>
In-Reply-To: <20210114083556.2274440-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [193.93.219.25]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4349d0c0-9388-4157-52fc-08d8b8d5e920
x-ms-traffictypediagnostic: MW2PR18MB2185:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB21856AD8467433C5A8F6ADB4C4A81@MW2PR18MB2185.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YqzJ1Fwr3HK238w0rXsYoNsUWfhOG4rzBOf1/0FPqS7Da8im8VY89sxx09ORE7V2N78XsaDUQBXTTFZ/VpFVzfn7AarjkemBAu+/5sRlvuUu4jRlOfYZt7oSC8gtxoBIpmFHAVIvNLaGYBLLsMtj7W/YohAlp5cyliVe427ChpPZOJ+AJYuOhFrzykzwzHGrgTnhB1GvsVlBS3CdNIC/OydesKIfSEHN5UsUbbPAvDpjwjgE3pb2y+XZchHm7MhGLOJG2RIafI0uRdD1l2KhGOOT1J5IPfVG36HvaeJY6CVokV/Rdegllv3T5bnUFCrC2YnSDi1sXQTnoiScbz76zH7OqrRNv7sW6eAv4eLmGI2Fu5qMliteP5Ee1ydLaQQ5mzH75uAd+nkCPRgPACxCKZdcewk6UdgAQRAWC2Vo7AgXW868sGgf+MrRew8xEsiM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4083.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(186003)(33656002)(4326008)(83380400001)(66476007)(7416002)(26005)(478600001)(110136005)(66556008)(91956017)(76116006)(66946007)(6506007)(2906002)(55016002)(52536014)(8676002)(5660300002)(86362001)(8936002)(71200400001)(7696005)(316002)(53546011)(54906003)(66446008)(64756008)(9686003)(586874002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?UO4MKNwf7gXcM8A7oxaf95wmniomXAf0MjJabLCOQ423kEY7aloq+W9d7S?=
 =?iso-8859-1?Q?9qcpO1do9fA4XR4d+sbOwQqYAaT2ppy7GPZ50Yi7r0EbiLO4HxNUBtxl9c?=
 =?iso-8859-1?Q?bWZXzHbJg6kAoNTJqFmkYFYzU6T81m/Zal2baC9JD5NKUDYfzy+FLV+LSu?=
 =?iso-8859-1?Q?7muy8zNHMGkNfIYbry3KMnY0/CHNBJGXFk/Kk46r2ZRbNnwSIXicr8IUso?=
 =?iso-8859-1?Q?VuMcLCSB3VPM2POhaGNCR/XU6Q2+54hqLF/RShoQzUcQHq97QejQLWaREC?=
 =?iso-8859-1?Q?2Cz4PqZg00vgh8wiIFRkaCQ3kGydlj8F52mPbv089nrvw4ZunaEvbCtu/v?=
 =?iso-8859-1?Q?xdPNmS8P54IhA25MYXZBjzhxjefpI7AWhiqGXNrOw1kaQAfMU8mVSciuid?=
 =?iso-8859-1?Q?kZaVFiNZMKZ44ZXRELj9cb85J3K/9VwD4s7VPW635M8hlxmT3Qa8jXwV6a?=
 =?iso-8859-1?Q?4/8ru7bZugxucchJ5tmA6oWAbB28eAWa+7dR2LwstY6mFJDEZhKk+l3Xgm?=
 =?iso-8859-1?Q?3VFKFzcxK52Ncxv8gMej61ZLqRlrvHDfWHzqaQYqQsAf9l7VzoRwJXV3fa?=
 =?iso-8859-1?Q?3PJUCN+V0UwRRPZGyiJCmyPFB7r4UkNF9sTJjL71H3Ud5nCXycEcDFlOTF?=
 =?iso-8859-1?Q?g08y3LPLP5riJbCi68hslqoNc4tssQSBTrNsqAdfqoUYEzcxJ4fEruioYn?=
 =?iso-8859-1?Q?jCEiy/e668pFB1zxhtIsWLlPrzm9sTqfVSfb5qYHEcUBhYs8KzTtAwXpU+?=
 =?iso-8859-1?Q?sOlkSnrKMjhkwoF+W+uXuMlE9C3dcWbDEbnwbRMNAT2MDANFimBb/LH4/3?=
 =?iso-8859-1?Q?TuVo+DosAqi+9KtWw7sSINXIOeQTd7QyN//Iy8Mo8aTspx/g/zXoxJwaJK?=
 =?iso-8859-1?Q?OXkNBCy+7FLyPAncfz2obFX284HIRdXjEE9HN3BydHJmeojv1nMieHflh+?=
 =?iso-8859-1?Q?RBGSDQ6ySu9kmHqSUMGI1qbUhC/+bNSvMNInt5LuYMp1pV6+ekz9r6m6Bk?=
 =?iso-8859-1?Q?h6HKe+UPZz7yZtC8Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4083.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4349d0c0-9388-4157-52fc-08d8b8d5e920
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 21:46:55.0853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VMnM9fqjFm72ifIPzW6z171dNRDoEVjaSl0OgIjw3aWbNepd8YjEA/D+frmRKRc7DueG8xa1cpk36gVQqRqP1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2185
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_08:2021-01-14,2021-01-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
________________________________________=0A=
From: Vladimir Oltean <olteanv@gmail.com>=0A=
Sent: Thursday, January 14, 2021 10:35 AM=0A=
To: David S. Miller; Jakub Kicinski; netdev@vger.kernel.org=0A=
Cc: Florian Fainelli; Kurt Kanzenbach; Vadym Kochan [C]; Taras Chornyi [C];=
 Ido Schimmel; clang-built-linux@googlegroups.com; linux-mm@kvack.org; kbui=
ld-all@lists.01.org=0A=
Subject:  [PATCH net-next] net: marvell: prestera: fix uninitialized vid in=
 prestera_port_vlans_add=0A=
----------------------------------------------------------------------=0A=
From: Vladimir Oltean <vladimir.oltean@nxp.com>=0A=
=0A=
prestera_bridge_port_vlan_add should have been called with vlan->vid,=0A=
however this was masked by the presence of the local vid variable and I=0A=
did not notice the build warning.=0A=
=0A=
Reported-by: kernel test robot <lkp@intel.com>=0A=
Fixes: b7a9e0da2d1c ("net: switchdev: remove vid_begin -> vid_end range fro=
m VLAN objects")=0A=
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>=0A=
---=0A=
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 3 +--=0A=
 1 file changed, 1 insertion(+), 2 deletions(-)=0A=
=0A=
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/d=
rivers/net/ethernet/marvell/prestera/prestera_switchdev.c=0A=
index beb6447fbe40..8c2b03151736 100644=0A=
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c=0A=
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c=0A=
@@ -1007,7 +1007,6 @@ static int prestera_port_vlans_add(struct prestera_po=
rt *port,=0A=
        struct prestera_bridge_port *br_port;=0A=
        struct prestera_switch *sw =3D port->sw;=0A=
        struct prestera_bridge *bridge;=0A=
-       u16 vid;=0A=
=0A=
        if (netif_is_bridge_master(dev))=0A=
                return 0;=0A=
@@ -1021,7 +1020,7 @@ static int prestera_port_vlans_add(struct prestera_po=
rt *port,=0A=
                return 0;=0A=
=0A=
        return prestera_bridge_port_vlan_add(port, br_port,=0A=
-                                            vid, flag_untagged,=0A=
+                                            vlan->vid, flag_untagged,=0A=
                                             flag_pvid, extack);=0A=
 }=0A=
=0A=
--=0A=
2.25.1=0A=
=0A=
Reviewed-by: Taras Chornyi <tchornyi@marvell.com>=
