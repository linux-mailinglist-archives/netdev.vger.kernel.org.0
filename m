Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E2953E650
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiFFKZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 06:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiFFKZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 06:25:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A63B29CA2
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 03:25:15 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2569ncvo018371;
        Mon, 6 Jun 2022 03:25:03 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq50cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 03:25:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOcQUxFMH6gX3C7B1FQwWUQ0GRn02w/8yfLF1dpjz87EAk5Z6hVfWA9/BbjGgI3axV6sEqktXrrQkINBKO92b2Sp/dAOYAcbdafbh6pyYERFM+vTAHNB1X3F2eJxKq62tkJaaicZGa1JMvpI39R+gnEA8VBAgbsgqDJnQPFXz487sEIA0mBBTeDEFlJnusoTO1g9NNOSDwlxA9jhqb5wE9diGRtJ2QNZ/0Yvlom9DoyF0jLnDhsWbbUpYcFhCdihxtUebXo67tCsHRrKMwt9ckF+8MZXCE44+3oLoArgOT1YTsFMaVXAgPbQUCf96XHzA9tUiMUMdS7UvyAdDeIi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrZhbde8z5Jt1Jx3sJXdcin+1hb83QKm2Jd/3C//Esc=;
 b=dbQQOoNf9fcTG5Umxf9Cz71xGTinAPdvZbVELDe/yLAqscO2NvfdOflAmZEVHgVP8Ukx/r3BucsOnOJLrNujT0mCe2d9ZSDGlHFtLtj0UdoPNQJHJRjod1fIPewF5jluQf76e/XMIX4aC/nYbs86Zp7lPT3mx+27Wc2eHnZb4af5abkLqTQGqb/sBslHTGBWEKC4vWX2F6X4Bn/ETWVuud86ntOJZi3zazrVpSXWC3dRgo5oFyAj9Qe/gayLOnZW20X/dySluKaT14/t8ztEJTy2duPp5LrJG7pcW6ZWjySZKr9dZpBF6tJoZPfbtmbHQAAJbQyJqjoWMWMqVWzMTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrZhbde8z5Jt1Jx3sJXdcin+1hb83QKm2Jd/3C//Esc=;
 b=IcVncVeiaJxLnVEU/hedYQnExXG2Hk4/aOR6J0R7BdC0C+R9yRpZFmn7V7a+2JpEhGmxvMRD0AqyiouOPg6TAmbOqIY+I0+h5KNGGE6wRkFiUm/79C4d7oLykn/F9Q7HGpvwNEbruuhL4/QpIgiJK1538CA7LRi8WqSE+dFv7NA=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by BN9PR18MB4235.namprd18.prod.outlook.com (2603:10b6:408:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 10:24:59 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::e540:d6ee:94ca:3844]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::e540:d6ee:94ca:3844%7]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 10:24:58 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>
Subject: Re: [ethtool-next PATCH] rings: add support to set/get cqe size
Thread-Topic: [ethtool-next PATCH] rings: add support to set/get cqe size
Thread-Index: AQHYcPJy2CaL0+s7+kyHcBZDpjslTq1CPSkA
Date:   Mon, 6 Jun 2022 10:24:58 +0000
Message-ID: <CO1PR18MB4666A3447DA4C32A429D1C02A1A29@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <1653563925-21327-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1653563925-21327-1-git-send-email-sbhatta@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc2bb485-6e89-46d4-38f2-08da47a6cedc
x-ms-traffictypediagnostic: BN9PR18MB4235:EE_
x-microsoft-antispam-prvs: <BN9PR18MB4235B154FF77C9D840713905A1A29@BN9PR18MB4235.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wkXN3Hx1mGNe9I8rkMcSVcn7m6D8eeEnHCDw4D3bTQc3SeEMm8WmVOBywHrGDHPsk+7Oy0fM/h9trXOPEmAj7xtwkWKUCheZVlJ3JNSRQE4yZjzSRRgkGFlU2Mrmb0sIq11ZBVuOgUTGMY5IytM6WkPhvZqPmMylWtHGg00I80548Sbzkz2BlvgRhoa8HFAkb54oxCTd491GOZidoxMop+/shF94dr+6x2LGrfJhDdbTb1OjXuboHD4wpmONYalln0iU8+Xm67ygapX4DKFlH8fE1PFzyk5lpwdK4X1UIkEVkEZfde1qhjoxKu6fBsH9JqleF/wbCLylwYSIpc6S0AmUAyI7pAtpG3+G1w9t9Rrs5I2q3Ure74+05DkV/MV+5TVTtso8YCa3CbMQZyTy9NUFKGrysYB+DPh4OyVrEc+VEKOdE7Soo39AhlDnA3c8HZTvd4JO4iL0khT0FIpB+DgOV8NVo/YCh7nSPkWak3Lr9xWOG9jzCVYTFmZFGS9/NhlTpAbgglAv0QMj/AeydWKQ/b/dmDpXvMBwQzsopESLoRq4BfDi5u84mAKnq9Vvh5u7zd4EZBD3MtQVIiUPfBh2iCg+2MlroUsraRL2TZSJ/JoJ0IEj+OuWtRlZ5FG3KYWvalp4LtgsICQlBwLlqOJkpp0bJa1yeZk8a6YA0v0x10aCygf3UAz2s0gTLdcs4ETp3Hu3UgLG7uz+gg8GwMy/etFumIQHHGPn4UhC01E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38100700002)(8676002)(76116006)(4326008)(5660300002)(91956017)(8936002)(66556008)(64756008)(66946007)(66476007)(66446008)(107886003)(7696005)(122000001)(6506007)(54906003)(9686003)(110136005)(33656002)(38070700005)(26005)(53546011)(186003)(316002)(2906002)(52536014)(508600001)(55016003)(71200400001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?2lozw4yRT5FZ+KXbO+sEabBvsK92mj+1kWlYnwUf20Nohn3Xf9IRTZ7Wcd?=
 =?iso-8859-1?Q?U0vtzbi3qMymB3syMKLPeaUDFa1+8bJSdfX34egNwvlVwUt1WoCXqTAolf?=
 =?iso-8859-1?Q?qnnBzUeuMMG9U6bDjFODC1MTsb0tcWfup4JruCB++MEetXHpEy58Sysoxw?=
 =?iso-8859-1?Q?vHfZiwmvb8IMiVSsCkITLoZ3ZHJwnJTFUcvPEVlQUAog9ndorlfZZ0rvZw?=
 =?iso-8859-1?Q?JHYMBKAtBXdXeBanJnJVhHLFKYTGs8y5k2teAc+NpZ1fOY5S1QuB9eU+QT?=
 =?iso-8859-1?Q?F1fWFizKp4gz7g+h4WHgpMbYrLuV8SMgyp0N2QirAplzdqCLTta/Hsbcb/?=
 =?iso-8859-1?Q?733RxsdkGWLICcvTVT6y+NrAhwR0xrI7yQOxpcDPd0bMcF97IibMB8nMze?=
 =?iso-8859-1?Q?tEPO/S4NR5iyG9GG58leFhPXj3h74bsQ8dtPlwUOOIAL7L4r75WiLZbL6A?=
 =?iso-8859-1?Q?DZ6mfJ6Java7lgzfzWHwQTEdTptcOaaHoWPTE/xv+7IwYDR+hVSctwxAp2?=
 =?iso-8859-1?Q?CPoNdw+x2hm+fMPR8Xvxjw4KtGBGCc3jV8XPa/NSLASlvn/t5mWO0UmYjZ?=
 =?iso-8859-1?Q?Sf52p2TmUKO4hCZWTzc+2l4yK/2aBqV/Y2wIRlKbyA8RcDTTVr6dGBf/2n?=
 =?iso-8859-1?Q?cfH8k0kG+jESzT59fHptXtVQTxluD03w137Z/Q1kKb/sL79mQJOLXScxno?=
 =?iso-8859-1?Q?WrAoCkBw1/xZbHZX9dfq96n2psrn1aK84uqgfI/OHQjjtGZTWg0UsQpi3q?=
 =?iso-8859-1?Q?F0c3CaxlqwCEKL0Y+LaX78+c6SiC50tt8nhX9jTHaIWTm5+YVvWITBPa7U?=
 =?iso-8859-1?Q?75uo5PVGGtya+jhFi8E6QTZAeBu4BXLBPDLyr34dCM3DEp8klW57MK7eGs?=
 =?iso-8859-1?Q?fs64aJKpDSKzObZpLJTPIuFS3w4g38LXKPh7s53qdNJ1jchgQOteVU0065?=
 =?iso-8859-1?Q?sxJj1uDwqQ758BumhI5onVm1hyztx2SNZwreM/Geg7VNJNYGOC9g3hbWyl?=
 =?iso-8859-1?Q?NXeGlAbnd/ytoCk49+WvAb/z3C8HNCPqw3J7+r4Gvix9UKYJV0E9IkLkCj?=
 =?iso-8859-1?Q?5y/qzlz1Y8Nhb5Xaq1ShwYJuSekp5IGyXL1jNnmD3DABUdnuOYgrkMgbN8?=
 =?iso-8859-1?Q?wDy/uHXT8zIqY11NXyPivErO0n6EPiLjghYGy3G571iOnF3ZdE9VmfoFx+?=
 =?iso-8859-1?Q?p5jYFO/JBpSCw2pEJQPHnlNWFwhcWaEI6mCS14Z//LAbVX7EneDD1dhavx?=
 =?iso-8859-1?Q?sq/H+YRDsf7ZHxij2hV8J9zAV+VZ99YaHGxqmJYHbdTprlrEc901N8RrZn?=
 =?iso-8859-1?Q?yjNQtUw44RTVZA637Bu4COIk9/ijZHGWqIB46R/Zd//z7JwqYmqjTDNlt+?=
 =?iso-8859-1?Q?7C7saEubs4tSjOUAixTEanD1R1fB+CTqeGXE0mKtKIoA+jmIoCEsAKiS5B?=
 =?iso-8859-1?Q?NNpvbxUbxDpUXnspvS2fciIDy0tzkVPsGvyBxbddM7D1q5xD8s4xf8apNW?=
 =?iso-8859-1?Q?/e3GpNgkXU6LewULa/Q8lzEWwBvUhrqBurfhvM0Sa+nTEubJGzeQFUzXoV?=
 =?iso-8859-1?Q?w4p6cBsNj0TCYRCVOgeN+3KTJRXOrb67Bh5trXYIqq61Fi/z96MwyYYz/g?=
 =?iso-8859-1?Q?fQgDPuY7MTkaH+iywAXy79TWJefyLleFvunrvEQ/XUeCnXo1pyBWqol2F8?=
 =?iso-8859-1?Q?/HZ1yPUQUFimHUGjLxf2ji9BcS9JAJdcYNthdzXJQRh4+N7qCyXyMAq6d7?=
 =?iso-8859-1?Q?4eCTiqSoQZNk0VKxRQd8+f0QPvAvZphQbGDJFyQ8/OFKaP?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc2bb485-6e89-46d4-38f2-08da47a6cedc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 10:24:58.6404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yOODwOZDxyPLNcwHcLsAUpB52ujBiZc9lqpL8+RTLIpHC66r9mEWO9WQ99pauAI49iRbWQY0BvvTaDtwFunkNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4235
X-Proofpoint-ORIG-GUID: nLHttqeZdmlSGco-YQqPJxjsWD9Clfl0
X-Proofpoint-GUID: nLHttqeZdmlSGco-YQqPJxjsWD9Clfl0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_03,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal Kubecek,=0A=
=0A=
Any comments?=0A=
=0A=
Thanks,=0A=
Sundeep=0A=
=0A=
________________________________________=0A=
From: Subbaraya Sundeep <sbhatta@marvell.com>=0A=
Sent: Thursday, May 26, 2022 4:48 PM=0A=
To: mkubecek@suse.cz; davem@davemloft.net; kuba@kernel.org=0A=
Cc: netdev@vger.kernel.org; Sunil Kovvuri Goutham; Hariprasad Kelam; Geetha=
sowjanya Akula; Subbaraya Sundeep Bhatta=0A=
Subject: [ethtool-next PATCH] rings: add support to set/get cqe size=0A=
=0A=
After a packet is sent or received by NIC then NIC posts=0A=
a completion queue event which consists of transmission status=0A=
(like send success or error) and received status(like=0A=
pointers to packet fragments). These completion events may=0A=
also use a ring similar to rx and tx rings. This patch=0A=
introduces cqe-size ethtool parameter to modify the size=0A=
of the completion queue event if NIC hardware has that capability.=0A=
With this patch in place, cqe size can be set via=0A=
"ethtool -G <dev> cqe-size xxx" and get via "ethtool -g <dev>".=0A=
=0A=
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>=0A=
---=0A=
 ethtool.8.in    | 4 ++++=0A=
 ethtool.c       | 1 +=0A=
 netlink/rings.c | 7 +++++++=0A=
 3 files changed, 12 insertions(+)=0A=
=0A=
diff --git a/ethtool.8.in b/ethtool.8.in=0A=
index cbfe9cf..92ba229 100644=0A=
--- a/ethtool.8.in=0A=
+++ b/ethtool.8.in=0A=
@@ -200,6 +200,7 @@ ethtool \- query or control network driver and hardware=
 settings=0A=
 .BN tx=0A=
 .BN rx\-buf\-len=0A=
 .BN tx\-push=0A=
+.BN cqe\-size=0A=
 .HP=0A=
 .B ethtool \-i|\-\-driver=0A=
 .I devname=0A=
@@ -577,6 +578,9 @@ Changes the size of a buffer in the Rx ring.=0A=
 .TP=0A=
 .BI tx\-push \ on|off=0A=
 Specifies whether TX push should be enabled.=0A=
+.TP=0A=
+.BI cqe\-size \ N=0A=
+Changes the size of completion queue event.=0A=
 .RE=0A=
 .TP=0A=
 .B \-i \-\-driver=0A=
diff --git a/ethtool.c b/ethtool.c=0A=
index c58c73b..ef4e4c6 100644=0A=
--- a/ethtool.c=0A=
+++ b/ethtool.c=0A=
@@ -5734,6 +5734,7 @@ static const struct option args[] =3D {=0A=
                          "             [ tx N ]\n"=0A=
                          "             [ rx-buf-len N]\n"=0A=
                          "             [ tx-push on|off]\n"=0A=
+                         "             [ cqe-size N]\n"=0A=
        },=0A=
        {=0A=
                .opts   =3D "-k|--show-features|--show-offload",=0A=
diff --git a/netlink/rings.c b/netlink/rings.c=0A=
index 3718c10..5999247 100644=0A=
--- a/netlink/rings.c=0A=
+++ b/netlink/rings.c=0A=
@@ -48,6 +48,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *da=
ta)=0A=
        show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");=0A=
        show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");=0A=
        show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH])=
;=0A=
+       show_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE], "CQE Size:\t\t");=0A=
=0A=
        return MNL_CB_OK;=0A=
 }=0A=
@@ -112,6 +113,12 @@ static const struct param_parser sring_params[] =3D {=
=0A=
                .handler        =3D nl_parse_u8bool,=0A=
                .min_argc       =3D 1,=0A=
        },=0A=
+       {=0A=
+               .arg            =3D "cqe-size",=0A=
+               .type           =3D ETHTOOL_A_RINGS_CQE_SIZE,=0A=
+               .handler        =3D nl_parse_direct_u32,=0A=
+               .min_argc       =3D 1,=0A=
+       },=0A=
        {}=0A=
 };=0A=
=0A=
--=0A=
2.7.4=0A=
=0A=
