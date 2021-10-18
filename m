Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E63432448
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhJRQ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:56:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7052 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231898AbhJRQ4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:56:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICWLEI009528;
        Mon, 18 Oct 2021 09:54:04 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 3brt1s3njy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 09:54:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hotvaFShXI9p5I9smTCWk2950tbsigK3gNGK6PF0anLys0P+ClJtfghKV7nwYFEZ67Holwv5J9q6OwyfCtkFXS2BjNCsXrUETOOdNt479cWqnZ1/KVlw9pzkWnzNo06fjC0aWwCj3uich0nwT9DtIiF3gaQT9bnkRbvClfGmcF2ll2bgZA+x7gh0ldpgCX+GUAGjG6gkO+YzCh3/sQkwQSzU7bPBciq6GEkagAAadu7o7cLKijj1KbAzRM4XQi7prwUUTfxpsndD8IV1PlFNvRCU4aAFqXkECnj/lLvL17MEMbRd6DkE2EIDxe2y9BDvjHnjqQKKr7lzjgFHmf+c2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJc3mNH+Mu3D8h0QctOuTMxYFOXT7vcI04IyxQTFMi0=;
 b=F3Cv6qQ/mSzw+lwBANC+xvItd7T49by+qb5sMLTuk8muN016PcDB9GKAQpx3cNttsgUUeqgaGn6hRPORhqjyDM2008MQ1fFoORcCMQ/IfpT9B5dAIEV2Cxr8hdQaCPK7K9qCg6aSRAXuSiuTTv3quO1zLcvbuz6qCDUBoiErsem4GrKHUOO2czfz+Vf2l9txkdJsk8WJGH8AUZvevLbSrzIslYKPpjVqTTZ18grCnPMa9hlwG+qsRSbDGOqabTs1AD41qMWfotESRS928TCRF3/jWG+IMKDnhlh0ZuBCPZyBAzEGZXnsNUIaJ4FE3bkhPuC9ZJxltqsoot57zBGZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJc3mNH+Mu3D8h0QctOuTMxYFOXT7vcI04IyxQTFMi0=;
 b=CUn4ZXGgrLL0cO5LHoAxPyloiAGM7MPj3OEgUNL0pA+2NzGFA4YUlLBHxF+9byVuzkHoKYHuVfL3uZjzwLXG2uyn5Nqy9bp+iM3MY2L3U//NCrUrUcyLEFkI6rUSjaY/sWLNUTqYZp9WH7I7qZIHXai6XKPhU6biFpo9B/C1ZCE=
Received: from CO6PR18MB4083.namprd18.prod.outlook.com (2603:10b6:5:348::9) by
 MWHPR18MB0958.namprd18.prod.outlook.com (2603:10b6:300:9d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Mon, 18 Oct 2021 16:54:00 +0000
Received: from CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::85b0:35ef:704b:3a19]) by CO6PR18MB4083.namprd18.prod.outlook.com
 ([fe80::85b0:35ef:704b:3a19%9]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 16:54:00 +0000
From:   "Taras Chornyi [C]" <tchornyi@marvell.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Vadym Kochan [C]" <vkochan@marvell.com>
Subject: Re: Re: [RFC net-next 3/6] ethernet: prestera: use
 eth_hw_addr_set_port()
Thread-Topic: Re: [RFC net-next 3/6] ethernet: prestera: use
 eth_hw_addr_set_port()
Thread-Index: AQHXxEC/RyNcl8BdZk6AglnPwdAujg==
Date:   Mon, 18 Oct 2021 16:54:00 +0000
Message-ID: <CO6PR18MB4083DDE34183B96B4D882D60C4BC9@CO6PR18MB4083.namprd18.prod.outlook.com>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
 <20211015235130.6sulfh2ouqt3dgfh@skbuf>
In-Reply-To: <20211015235130.6sulfh2ouqt3dgfh@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 8b6723c4-d19d-9f06-996b-2fff29fadc04
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ce5140a-9889-46e0-150c-08d99257e25e
x-ms-traffictypediagnostic: MWHPR18MB0958:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB0958DDCD0BD146CD39F247A8C4BC9@MWHPR18MB0958.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RquSfgB5syMNL7Tdqt4uEytQldxkW2QBB/Y8lbSCtHtsNc8TYPzFZ9iUJIM7w4XG7bNcG3P/zaGZ6OQKLIx8H4wRqtuoq6cLuKHr286CFvjOCLKP6cbkjB555iBB8czC43g6J1ZUjA0xWOltSKxS1fxY4zPVVopSarqcbfpPINaiEOo62b18CVNYwFUhbAHyn/mHcIBdqzsubdVm14Y6XjvZODw/Z65tSne6V2fM8iAkhsoJs8/moEbF7unUMRZtENK9DYgby2duIHh+bYSyGbgfkxyX1D4OgrSOhcPQT/zu6xB6HXEjKjhW58Te7SW16JjdVkG2/94e8y74TJAK6/wP05GC/8Qcgw2LwfCezkihDCYQ+rnhx7kh4LEavBgQ/whxoa+rgDNCh7OZugtAAiTpehZdviRoKdOt1agKisA8XUQjnGxiJHBxJ67WK6NxYtLVHPoAkm84+By7OaXIV3FjCWFqMxRcEMbc5PyyqQs2A4Z+cMczQ52d2dv2Kyih6R4Laxe+RYGcM9hEkL6xS8/82pPhmeu0AS6DHVf6Zg5JSZTTqX1tAD+Sa+Bka3/ah7AZ0fnM82sJGA6GPWdo8EoZdNHhYF38uwvvbjCZQ+opFx0mMuyyl/3zAsKZE/S6xzcKqiz8uZVn66nB81kVBULIKIezWpT0AW+m8ivAnuPUtl0v23oOcYjt7V2QiZ8+W1OH4LiLmrGuU/1JAyTzqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4083.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(54906003)(110136005)(4326008)(38070700005)(26005)(6506007)(66556008)(33656002)(107886003)(122000001)(9686003)(55016002)(86362001)(2906002)(508600001)(38100700002)(8676002)(8936002)(186003)(71200400001)(52536014)(316002)(76116006)(5660300002)(66476007)(64756008)(91956017)(7696005)(66946007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NQfkIj9OybPMf1a5l96Mjx/4iSYpRmtedHN1lxZGIxmDUGqG18Dm4dkZA8?=
 =?iso-8859-1?Q?cZCxdahpAqXA/3EKtaT3AmBl7KCK6bsLRSwv+yTPbxgZWeJRSNRtMNBEsY?=
 =?iso-8859-1?Q?8CFeUKjFqj0Rhw9cd40OWEibrqrXVgRoSKGoW1cWi3d2O9Mq4QyJETJmv9?=
 =?iso-8859-1?Q?M7vsvN05gN67dIhAXvmbKM9EKSYVozHgPau5F7v2Vz+aWFLLfCLHvteCEY?=
 =?iso-8859-1?Q?UQbo/ySfyj/mlFeF7ew2h8DN4gT94QKKpwEYP8GtfpQ4EjpcDqAnomadoX?=
 =?iso-8859-1?Q?2xup7sA9e/37LvK7fSLcq7mb3oZkCWFkzu9UGfiXWcpx/70v9hbITk74uD?=
 =?iso-8859-1?Q?WscZbdqB5dMHk+foweW0wg+czWIPyKmBYyd8cV58gTIDQXffZLqzfCHnXR?=
 =?iso-8859-1?Q?KHHjdl4TDl0Iq33tPJqrPn23zLNNOArHxTC8ERR84SnCtE7kkmd/SU3c1e?=
 =?iso-8859-1?Q?PzGc5jOxRzcG0ePTgRO2dkFGQVgB1h/LsvMX6fxP1kQVYxZWiyBjs33pMX?=
 =?iso-8859-1?Q?EGHMS6gTz5mzZqxoA9AP+jQ7VU6Fn6cYuvYzvDbi3FGGLbvkRZpcNUNj6e?=
 =?iso-8859-1?Q?viO+X7ChBx7Uds/O3pQg+v8F8rS8gTg5CT6PPd6dNv51HVL4iBADXBzBxc?=
 =?iso-8859-1?Q?5g9CyvDybL+N57N3nA5KyIbik8x0DkDJnqsxKslfiOG2x7MJCoGImQKsLB?=
 =?iso-8859-1?Q?PYOEWiY4mbjSY0/iqQzmR2HP7cfTqa7pmNXzSp1W7T2K/82/UKvjiu9rEc?=
 =?iso-8859-1?Q?JrWzhW/rsWWH68pctIf0cQKWFZNG8FhAnuX4PkezRUl9TgSnsL6Q+ShNx4?=
 =?iso-8859-1?Q?SnYZ4H0/5cSvBuNGNrpUjvJcj2VTozsG/NSO2qdZ7T3/PFT3fjT+tbqdx7?=
 =?iso-8859-1?Q?TxgMIKUR8cCNn5uJVx9BLmW+fIXFl806hr1Q6ntnUx22DiHJO/M8czFVMP?=
 =?iso-8859-1?Q?7V0XHEpMU5dFneYPYvURNr0j82vDR2oMGX92rqiQXe7rquH1VsgJcZNIjE?=
 =?iso-8859-1?Q?a2Am200HGWCNy+raeiWqRTfF08fpb0tebZ65o1a3N8Vf9sbYMmsA9MnPD/?=
 =?iso-8859-1?Q?fS3pY9BU1Kvrrp0BPDk2JK6spJmVz7w6ltnu7S9djnU45RaqszM6XwW+cP?=
 =?iso-8859-1?Q?0Hgz+5Ohx5s0wP4c/xFlvLiHN+0IoZuaH/YIU8y+MTlWrGmGZnCJO7ZG/8?=
 =?iso-8859-1?Q?6bYV5IiGTE4u80BeYXkQ3bOF4e/Kb/m7X77w79kwPLlH9JlRe4striowmU?=
 =?iso-8859-1?Q?eOjlbWX1llT+VAugcUU3yvM4R5tx4Nk+Ky0qPpVn7tWvmHr1V65bJwyEx7?=
 =?iso-8859-1?Q?duXmLmsnC1GKep8KZirE6HQADWSMOL5LyU7ZiX8C9VQ5X6I=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4083.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce5140a-9889-46e0-150c-08d99257e25e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 16:54:00.5360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CxH/uE1hzLiv44p5W7gYzzarAZ0U2AUcDths3emVEyhIddsgI/kcFGt+TQdUkC3UwQJgge1XGNh8IwuotiJkIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB0958
X-Proofpoint-ORIG-GUID: I2EoLLcLrWcM-Tpax4gwpEx7aZqLeyKB
X-Proofpoint-GUID: I2EoLLcLrWcM-Tpax4gwpEx7aZqLeyKB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
----------------------------------------------------------------------=0A=
On Fri, Oct 15, 2021 at 12:38:45PM -0700, Jakub Kicinski wrote:=0A=
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount=0A=
> of VLANs...") introduced a rbtree for faster Ethernet address look=0A=
> up. To maintain netdev->dev_addr in this tree we need to make all=0A=
> the writes to it got through appropriate helpers.=0A=
>=0A=
> We need to make sure the last byte is zeroed.=0A=
>=0A=
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>=0A=
> ---=0A=
> CC: vkochan@marvell.com=0A=
> CC: tchornyi@marvell.com=0A=
> ---=0A=
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 5 +++--=0A=
>  1 file changed, 3 insertions(+), 2 deletions(-)=0A=
>=0A=
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/driv=
ers/net/ethernet/marvell/prestera/prestera_main.c=0A=
> index b667f560b931..7d179927dabe 100644=0A=
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c=0A=
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c=0A=
> @@ -290,6 +290,7 @@ static int prestera_port_create(struct prestera_switc=
h *sw, u32 id)=0A=
>  {=0A=
>       struct prestera_port *port;=0A=
>       struct net_device *dev;=0A=
> +     u8 addr[ETH_ALEN] =3D {};=0A=
>       int err;=0A=
>=0A=
>       dev =3D alloc_etherdev(sizeof(*port));=0A=
> @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switc=
h *sw, u32 id)=0A=
>       /* firmware requires that port's MAC address consist of the first=
=0A=
>        * 5 bytes of the base MAC address=0A=
>        */=0A=
> -     memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);=0A=
> -     dev->dev_addr[dev->addr_len - 1] =3D port->fp_id;=0A=
> +     memcpy(addr, sw->base_mac, dev->addr_len - 1);=0A=
=0A=
This code is a bit buggy.  We do care about the last byte of the base mac a=
ddress.=0A=
For example if base mac is xx:xx:xx:xx:xx:10 first port mac should be  xx:x=
x:xx:xx:xx:11=0A=
=0A=
> +     eth_hw_addr_set_port(dev, addr, port->fp_id);=0A=
=0A=
Instead of having yet another temporary copy, can't we zero out=0A=
sw->base_mac[ETH_ALEN - 1] in prestera_switch_set_base_mac_addr()?=0A=
=0A=
>=0A=
>       err =3D prestera_hw_port_mac_set(port, dev->dev_addr);=0A=
>       if (err) {=0A=
> --=0A=
> 2.31.1=0A=
>=0A=
