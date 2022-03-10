Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200F44D51B5
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbiCJTPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiCJTPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:15:43 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A066156948;
        Thu, 10 Mar 2022 11:14:42 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22ABjTnh031996;
        Thu, 10 Mar 2022 11:14:17 -0800
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3eqgr4t2t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 11:14:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gh9fmD0l7arD+T9N30n3r9QaKkiowEUH7AALOnsbaglm47yGUS3B7m2aT6CHh+MU3WcGug5PuGKX4RJeNqmFmvc4xQs1dXHr/DgxnZT8Fq1TBxNDaYOqf7zj1CLGY+P4PRYsuJBGwxSnnGY/HpD/2G2VGOa4A2C/MPCZzJkpMCqtoZwXc27B89E5VKuOf06P2CzTshbE2tcF/jkU2ptDq7TftyBWb8e5X9jD5a0PDHkqHh8Q1ZzQhsoKWGLKPoujUDWjFfW6BX/4NeGzjBCc17MsiKEocyNjDGvm9fjDJM/ou28D8vphjdPZC2HbLMy61ubawAtNhjRHO+v/MiTr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g02qr/YN58qXwtL1qhgZyzJxMoMgTzWBjyIkp3ySvNM=;
 b=JpXo30K15yYRUP4QRRsbsY0+b7z13wTpToL+ha63VtOaJAxsAONN+tJpiYqQ+TzUUUHDCfQl/dqviuao63QtdqLdgVMwJo3gAcduajWpOKJS0fy6zxHp+d088zStF68DXdcsMMJ2uJkk+akQaTpgV3Fsxo5laI4BtIL1FBUfzwJGGeCUjlv6V1D+tUre4unsI8Tnybq04nE0/e1USyr7uihOteVF77CqzkW+FYT5WTN73nya6nt16NjVTu7ONBexIoHrj0Rl+Vr+MHCsgnRDIEp/wA5cZHjZciZBv3K0o/1mLoMwOhSKMPqmzF0u7im8sntzxCeew5Fq8Eqa9F6S2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g02qr/YN58qXwtL1qhgZyzJxMoMgTzWBjyIkp3ySvNM=;
 b=HNKE6kSVzgk+jLUdGKF82Zm2QlXhj5UPO+AaADXIpEKfQ/Su+UDQ8joJ2hJkH3yTSEKDwvM+8y99rOYaRhAUSJYIQydH5ViMFP1x5HzJBdBA7VCYd1bKJZbTrFfHlPCXPXnr4i4iYWZrVohik3vKkLRYGj1dWLYv/I5Gbzo60QA=
Received: from PH0PR18MB4655.namprd18.prod.outlook.com (2603:10b6:510:c6::17)
 by BYAPR18MB2598.namprd18.prod.outlook.com (2603:10b6:a03:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Thu, 10 Mar
 2022 19:14:14 +0000
Received: from PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::e883:e9b:d83e:1cda]) by PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::e883:e9b:d83e:1cda%7]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 19:14:14 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Manish Chopra <manishc@marvell.com>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Thread-Topic: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Thread-Index: AQHX82cEVwPwSW+vmUa7c6IBcwRrGKy3uviAgAAIkoCAABTSAIAAFsmAgAAAxwCAAAX9AIAAKnaAgAFY0gCAAARUUA==
Date:   Thu, 10 Mar 2022 19:14:14 +0000
Message-ID: <PH0PR18MB465582071EDA502A96E57096C40B9@PH0PR18MB4655.namprd18.prod.outlook.com>
References: <20211217165552.746-1-manishc@marvell.com>
        <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
        <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
        <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
        <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
 <20220310105232.66f0a429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310105232.66f0a429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d77a4a0e-85ce-4d7c-7f41-08da02ca2a40
x-ms-traffictypediagnostic: BYAPR18MB2598:EE_
x-microsoft-antispam-prvs: <BYAPR18MB2598A6B30218D71F8AE8EC35C40B9@BYAPR18MB2598.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBz6pVQqNwF5TOtjlvw0rRQkqew37Qyv1XHO5kcyUbTJyGQmj/SZxQRKpx2n8Anhuc9Vf0+e/1CauZ7AXi7j8reAwo28137ChZbFFQsV5flMOMJBbh0a4b0/cHBLTr9yPZfXfbUW1IQYe+2zLctXVy0cnqk7GFVL3OZI1HRaFNMDw4e8K+8i6fNk0N/BOotJ9K6HaiKLH/FXgyTjRrB/v37qPhX2iGXnWA4WLDoW4+fDXvjYylQ5ekmvbaNaLEGNkqlGy6bYWYWa0fvM7siLTlqD1PmL2EVmIszy2N13+Z1mOSvyugKV3MEg0Z3o082gHkI6+cQfHYDC9uG8Ynvl7SOFZ1VwciWMJCU6nzR20gnfDxQtTLASnK+EXadzQiloD5EqjA7+OFghrbrCBdQ7h4qauEIhnDxz7HSDO95vt9CPrkc2B/yWHRIKcMm+eCDGRMeQuWQPv7VegAzTk2OQIdTFbHtWRb6RG3rDRT/0sRK1XLzm8AtuqtgQNYviMKGz7hFpwO1cCqC9lhmt147oUmgbJF4Tbye7ECyAYuFnIqEtiGropMYxD156S4h0tQfHFZN9PhnD87b41fqDkVkbehG0sSVd21zS5Bj6SFVVf5du+2+a2ybC8LKguzEMAJQFeiiFBaTSQgVmOok/QZnpj2BbBOJ7VRYg/U0iy43tNDNjinQQ21JfSpNKyZL9OvlmNKTZV25x3j15eHFQg+czgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4655.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(508600001)(2906002)(66946007)(86362001)(64756008)(54906003)(8676002)(4326008)(6636002)(316002)(55016003)(66556008)(66476007)(122000001)(66446008)(76116006)(5660300002)(38100700002)(8936002)(52536014)(110136005)(38070700005)(83380400001)(186003)(6506007)(7696005)(9686003)(33656002)(53546011)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qghc7aXWgNioF70l+Ol+HlVDyvmOAEUOqXDOSwLjalpN8Hl/Ni/N+BUy/rNC?=
 =?us-ascii?Q?UPymEZJ89VNnR7t3mpHyo2dqi00ilDpO26P7hhJInM0O+mt0S1Yz6fqH2nTT?=
 =?us-ascii?Q?XJvMW510N0astBOGJviqOXseSCXkyVukdR4AKI9jSpEsOgXfR03Tjj3dYoAd?=
 =?us-ascii?Q?o9PsbV4ofQbt95ZFFe/SNwX0WC9gTpsiYgBrVLRAJ7DOEaKOiSSKDNVRwt8G?=
 =?us-ascii?Q?Q/lSkU+P6IkdTJv9U0fUMSrKbg5KY7baTQ6z6o/pdFOTkIEUWX5PLfYE1FhN?=
 =?us-ascii?Q?cCo6/ibuS1T7cXxcfPeTwkXojQtNaJaMN7xE20bUyYjZP3abmU8xBaWjHBE5?=
 =?us-ascii?Q?NRdGBmuwO6/3Ato9TiAjTbvO90bySVwKQyv2aaZOmC9MogTOCJB/bxGuJOsL?=
 =?us-ascii?Q?ZuAQ+pb85yVa4vIJSJuUtqw7mQ20WRaLGwnomg9WKpZQtCQb+hYPs3oJje1i?=
 =?us-ascii?Q?3YdTGaj7cxJ/lN90ZQ5v5xqKnZX3Xm6B7+vFMZguNJVPWrUPq30dnI7bl/3G?=
 =?us-ascii?Q?sZ/x3EBNl6ZuspXBrOisZq6wTiZU6NvleMntgyWCwkEtQulDR90+m6uCijPE?=
 =?us-ascii?Q?ifY6IvFPSjDMcFZDP+tjqPOugxPWbjYRDQgKNgHeX0iHMbQV8YuYp4qnYaIK?=
 =?us-ascii?Q?gjED/Kp9F2g9dKTe11WJr4adrVL7fu4r3t1F0NO97Jv+NSpi11TYEi5W2XE/?=
 =?us-ascii?Q?F0+UMAP08smvn954XgECq9Wfl24HC2tdaE9BRtCtlhL3GEnMMdsDPRR98uIw?=
 =?us-ascii?Q?5mm7jRT5/3tOmhModumIpGxVhq83SV0WpIqqaUKANzIvAgTVFFILYdDvwamz?=
 =?us-ascii?Q?WBKV6aC6fVwwqRVVf9t648L01xsSg6l1kdGLFG0IH1LTkVlhEXbL1LzfcqGA?=
 =?us-ascii?Q?SSRYbK7gw0Q3BsXUiFobTmrc6XUM8hFSvnoydQoE7041MjpEyV3OhkkJeiR7?=
 =?us-ascii?Q?UFklognS4YA+FYBlUi42MhhrK7lXU49weWhI5LAjrLXVSO2Fl4JCa1Evb6Vp?=
 =?us-ascii?Q?yYGGGGxUhTkuNJI/rLYN8P8Bqb+leorHwb6Q1rKj6qqtZDEoa06rJxPL+kY4?=
 =?us-ascii?Q?1+sVtrVs+zcQhMUpjwL/k4LcJvpfCVJTU7BslcMxG+SGIPxhg4Pa9kO6KV1a?=
 =?us-ascii?Q?JUaAusP5WhK9hXGodBtAxknH2p9yxDrKnltsuce0xMtKgT1rq1wUJJlkfQPO?=
 =?us-ascii?Q?j+FrkP7PwnH57J/pmRuwKvZ4zP9DwmtJ2VCmQiXweoFFGZbEEzpmvseQZFoO?=
 =?us-ascii?Q?n4Jt6IafADv24bZ1hmHm4EXS1mlKtCSqbxPzncKDAdixQLJmBc2vCGmf9UM+?=
 =?us-ascii?Q?t3VDIqVKqDtOwGRIlYS/Dvk9SExnnLaJQcKeqe4n2yHArmkzq1AicTUQmdz8?=
 =?us-ascii?Q?aiHT1VDfhOv5uVaLAQwE7JMpbsKg5l1dpBWVfhlPQ3eygOwK/5HOSyoJH7f3?=
 =?us-ascii?Q?KcHyYwwMtstNjv+jdLUtjECx/NF01P4C4X21QBa6Hl4gnkpUkRVxKzjih7Ue?=
 =?us-ascii?Q?DbEy/jM7U/rOhzEHq2ymk2EsqnVT5cUWthwA3wWbRUOB7Av1jxFY7SOsVlzO?=
 =?us-ascii?Q?MzSXFI81+hX5btBKLV7cdYpuDc06RPd403RsfHAtiZ2tJzsbbkBXd3s269kw?=
 =?us-ascii?Q?OaILoKDsO2jLuYMI0EIcgO8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4655.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d77a4a0e-85ce-4d7c-7f41-08da02ca2a40
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 19:14:14.1241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fm+jTN6MdDr40bfd2vGdp8NJI9Nlkm1Dmp+/3rQTrWglc8U7pmN7VXyM7yHbDsVCc+tqEwH4oiDeVGhI6A24LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2598
X-Proofpoint-ORIG-GUID: JfvATiTnl5u7IgrZBvT9FZzJXDd7qo-z
X-Proofpoint-GUID: JfvATiTnl5u7IgrZBvT9FZzJXDd7qo-z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_08,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 9 Mar 2022 14:18:23 -0800 Linus Torvalds wrote:
> > On Wed, Mar 9, 2022 at 11:46 AM Manish Chopra <manishc@marvell.com>
> wrote:
> > >
> > > This has not changed anything functionally from driver/device
> perspective, FW is still being loaded only when device is opened.
> > > bnx2x_init_firmware() [I guess, perhaps the name is misleading] just
> request_firmware() to prepare the metadata to be used when device will be
> opened.
> >
> > So how do you explain the report by Paul Menzel that things used to
> > work and no longer work now?
> >
> > You can't do request_firmware() early. When you actually then push the
> > firmware to the device is immaterial - but request_firmware() has to
> > be done after the system is up and running.
>=20
> Alright, I don't see a revert in my inbox, so let me double check.
>=20
> Linus, is my understanding correct that our PR today should revert
> the patches in question [1]? Or just drop them from stable for now,
> and give Manish and team a week or two to figure out a fix?
>=20
> Manish, assuming it's the former - would you be able to provide
> a revert within a couple of hours (and I mean  "couple" in the
> British sense of roughly two)?
>=20
> [1] patches in question:
>  e13ad1443684 ("bnx2x: fix driver load from initrd")
>  802d4d207e75 ("bnx2x: Invalidate fastpath HSI version for VFs")
>  b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")

Jackub, assuming former, we won't be able to provide anything in a couple o=
f hours
(already past midnight in Manish's part of the world).

Linus, does "you can't request FW before system is up and running" translat=
e to
"don't request FW at probe" or "don't request FW in initrd?"
Or perhaps something else?

Thanks,
Ariel
