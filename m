Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E166EBF6D
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjDWM26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDWM24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:28:56 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2084.outbound.protection.outlook.com [40.107.105.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945FB10EA;
        Sun, 23 Apr 2023 05:28:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWMabei7k9G4pKhrd4xJEib0k0TRPP8HEbB2k3SnZ7TZp2Xw2+hzFCL0Nrs8S6PCxPOCaZM5m2wKa04uwb61i4PgdtLTKKDtBkO/pDxx0P1IMTG6ob7W+Sf88dDkgvs5Ij2k/ndYZOtiGxHOEBgGygTnIdO9lE9JKGCvtErptHlvNdS6w14Y23KNvOGSxCmOQrYSdgrIvTuW/cQEvhjxUIJ5K7UClo5Yin1ENu8uvY85eTwoZhQvXBmOFwPYPtO5AZZ4X9veyJPjLkogXxH+qtUkeAc3Ov06w0DgLymYoJbiaEd1QOw9RJNinD1L9VK+GGfVHF6cTiA4SiYiM/UBSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNmH4Atc66hkm3Wydi96sqAK5nGAzuRgT9yQHbKIvqA=;
 b=Xv0aV1sR0kZqWvRWBZUev/+zYNiie/HOEVmBRDn8YOQRVFd5u8uW2Wdpcp6hAXWqP/Ca49L81Utu8LnsoFLLB3mhXoSIjwcyWKs/U5zvN2HI7oZLLrhq75wfMV/UzWotPRvOsL7g0uA/3dLBH1HfwP5zfar4nHvgF1iG3hgt65xKvoG0SiGvY+pG8MczdrXuaR4/Afah1tiFu2qKD4vkJKW6jn6qPRve+yFb3F8peJRmfawHRj/ee8JCLdrm6psCwtWiKceaWqvbKRNEERNk/LnbCfeWpvf/LKEId6Ua+jI9BYmbrc4id6Xxe+DcnoVFKL4O7hHDyF1MsCT15AJXkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNmH4Atc66hkm3Wydi96sqAK5nGAzuRgT9yQHbKIvqA=;
 b=b8CzsvrEbV9ZRaN9BlbqkFzPuHwju1OiThcI4XU+2NBhgdzNzH8cZoTrlhOecw1toog9YdysH3MqSHIuSOFNRgltwVz0JVKDU0k8SkSk0seaYF96DNGcpIioxm0Vjvg4MBSoP6QPgo8r0goQVQPflcy/+/BZvMDJ8qdfaApnpoM=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by VE1PR04MB7390.eurprd04.prod.outlook.com (2603:10a6:800:1aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sun, 23 Apr
 2023 12:28:50 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a%5]) with mapi id 15.20.6319.032; Sun, 23 Apr 2023
 12:28:50 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Thread-Topic: [PATCH net] virtio-net: reject small vring sizes
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uIjT9gABGFgCAAG90AIAAMSwAgAABjzCAAARBAIAABATIgAAENICAAAM4M4AAIQOAgAALfyGAABuqgIAAAQKHgAADxACACRVQMYAACvaAgAAGduWAADkhgIAADWLz
Date:   Sun, 23 Apr 2023 12:28:49 +0000
Message-ID: <AM0PR04MB47237D46ADE7954289025B66D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423065132-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230423065132-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|VE1PR04MB7390:EE_
x-ms-office365-filtering-correlation-id: 9196a2b9-1dc6-464f-7594-08db43f64ace
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pmM/ImIqs/VjojXHzWfifHbXmBmzm3dtrVgCo1QuTVykA0XoWvoF9qq7YNSN95DKfnPz/XqJAaHCnqMp5a9jZCt37C3iqwVeBPuhcULmJJtRYoHB1XnYw8gSqvniFJQ1iEw+uXc8E90wq9kQSnQeEyL9T3bGU5n8FmOabWZQoCQhfUVkz235pnCNEICGck6b8p7jgQZN7pckdI+Owf0daybv6H0ircHYfzm+1D95M//QkdRPx6aCJymGw+8k7MjoKxw45PLNhLsCIGHDSuXaXjVsC4A0wa3AVU8NluMEN6lcnllECSDpaUZMWw3x0dXGNZ3lezPO5G72qjY9YQvvsAZofYmWksWQVzOZf4BqeOQcN7nAvguZeFrv0kmMerNJD79rzy4DKHmH3zsXDE1MUdyDRwvNou5+K7IJpl2irx/uLdxazjhdZSX78F0cCyq3e52lQzr8JC7BTSw66AtF+44rUujcjku6XdcLdNgB4Aoe9l/jqu7vMPYY7P/nBW0XGhSxVGG9eI6XYB1MRlLAhEy5s5Z1Av5d26DBoUwmSSIPHQSKi+nmL7otbEi0cq2vXi421AIIRfaini/HgR9ojjW1AlpHCYX/dLDi5CV9mdnGwuU6oqUb1/Q9u064kEn/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(376002)(39830400003)(136003)(451199021)(186003)(86362001)(9686003)(6506007)(26005)(5660300002)(38100700002)(52536014)(7696005)(33656002)(83380400001)(71200400001)(478600001)(54906003)(38070700005)(44832011)(41300700001)(2906002)(8936002)(8676002)(76116006)(64756008)(66446008)(66476007)(66556008)(55016003)(66946007)(122000001)(316002)(6916009)(91956017)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?mnLn2kcqbGiZksE1I+VPW7RTsziE51UWQqZlScN2dJCElfpf6trCGMqjD1?=
 =?iso-8859-1?Q?ahNuxR2EVtqyCZt6wni9qyvp46Ju5Z0Bv/X6amefzBAr64uhKGLMtuByXZ?=
 =?iso-8859-1?Q?WMTMUkcof2mMu/7PeaiMJ+GpJlITWAovgqALN+4/AK3rxno0REUx7MM0P6?=
 =?iso-8859-1?Q?tTAh9jMO6XgVz8T7CM6T0ivXolWmzA+UkzCFUXbo1hIR5BXwaKYcsWnyAH?=
 =?iso-8859-1?Q?rLSsWP5TNla1XIPCF4QzXvoyPGgPgGV6lsLAw2uOY2ASO8nIKgPrVo07GJ?=
 =?iso-8859-1?Q?PhoTsxKLDI9pGtu9SEHOvSS+dsABei5oPqGMjkBVXKa8LLKB/H2QPCNXIf?=
 =?iso-8859-1?Q?i9NGueZ+q5q7n++Hur/xUp52FkE2il2yLAFVwnOfBKa97EUQoeHgBjCMGi?=
 =?iso-8859-1?Q?PKV2GQUKXU++4aDp1jtN51L27+pSYNE+oPhhCaSd3hmCb/54BQhvSd0+qZ?=
 =?iso-8859-1?Q?TaFR7BW5G1ApNbO8hiZi/5ys0P5A6UiHl3biMIcrSQvEudnSsrtjCLL6zv?=
 =?iso-8859-1?Q?d1rPnX1pw8vaQZz/ccCV+mp8omNubzxWCjfHyggJQCaYdcv0GuZJpOrdWY?=
 =?iso-8859-1?Q?EsytSEGLVw9iKB6g62hVhC9UiNeK/N4/ckkr9gczyyTgxxqiXirVwiVuKX?=
 =?iso-8859-1?Q?ltbd9U6Km5oXDmu6lSRZVnlGJMQA7l3G65Czoc0QDFRBQv+dZt067sHcmI?=
 =?iso-8859-1?Q?ppTEOCGkQVqQtHdY+TAtaSgKDkdn+BnfCy7ne5Il6624e/KSUvcgSUAaHk?=
 =?iso-8859-1?Q?uAyGVUTTyEGrxvOBKBssJjS8IdCnAwVQDqHPlruBbbkNaO0+shsm7fhBRa?=
 =?iso-8859-1?Q?c4QQXPOscHNyskF7Pg3PN5Zkgxp5kOqEph77DeNIeUzeHSsHDRdzveXZXa?=
 =?iso-8859-1?Q?6feIypcHSJOCxgY3ug8SxoXepQjM6BPcQG/A9awZnX58tyDhbmMdLinXsU?=
 =?iso-8859-1?Q?f0UtF1JFFvUfK/GfrlKcrUyTLAgH/H0GyWiYmHWSl6dYyvX97rRMrD/eVj?=
 =?iso-8859-1?Q?5Gat2ZHzzlwwDIINjIulkHXm8qEJyrPeIlrmxqZx/KYdPsLVBLFVRBOHZW?=
 =?iso-8859-1?Q?gOv07suNcQrN6MsleL+gDa9NG5T8z//dM5JLsIQb4txidBuRToZj3UETsb?=
 =?iso-8859-1?Q?652yFSaYzkv7d3UYONv6AEjNDqtpKbCTcapWMG1DmT8jM9gSdS38l3pCDB?=
 =?iso-8859-1?Q?DGwRdiHSFMaAazbDr/RybHEycsq+OfHbE7jiEl9YC6kqtuD3jPkOlUq3jw?=
 =?iso-8859-1?Q?q+EcHABcyy9GJf0puanZIWCdxyt1Uau1TYWxlxzuZaanR3b1YzU0mcwRBA?=
 =?iso-8859-1?Q?+ikk6BnAM7uN+vPZO7P9pChGQB4x6UrMybj6mYbF1wCa5ZVnCe0qWEJ4Ya?=
 =?iso-8859-1?Q?ZPlqKp8AF57cIVkGPk1gqidRIElSZ+OBv90Om0Vx4RvRYSfzZJr3E0fVPR?=
 =?iso-8859-1?Q?pHA7sbb8s4l3KAfboieK9iFI/NfumkuIDEpplEhLwY4O29aZXdVpZ94HJB?=
 =?iso-8859-1?Q?YxZxs2v1QuZxQV2TDIVf6z4WW9P03aI6jztaUaMZwqnb+Ve/FkGd5yNAip?=
 =?iso-8859-1?Q?eueVjbMtDziPgpOaAb4GHF3Q++Pf9WBPWvoXdgnZ7hfguffghIzkRzCAbS?=
 =?iso-8859-1?Q?+x1BcDZ1PsXoLhYlMXT2Bg8quf9IqlGYeL?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9196a2b9-1dc6-464f-7594-08db43f64ace
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2023 12:28:49.8643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XZWp4Hgv9TDj22ymad6nAw5E28H4es9fmCM7QRRqzl7zfg6FxJbfCaLzFqn1fBys5Gd9iXOV/8Hy7fu8AopOE2PbV/YfVJWaxrYmpuJWbM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7390
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> > > The rest of stuff can probably just be moved to after find_vqs withou=
t=0A=
> > > much pain.=0A=
> > >=0A=
> > Actually, I think that with a little bit of pain :)=0A=
> > If we use small vrings and a GRO feature bit is set, Linux will need to=
 allocate 64KB of continuous memory for every receive descriptor..=0A=
> =0A=
> Oh right. Hmm. Well this is same as big packets though, isn't it?=0A=
> =0A=
=0A=
Well, when VIRTIO_NET_F_MRG_RXBUF is not negotiated and one of the GRO feat=
ures is, the receive buffers are page size buffers chained together to form=
 a 64K buffer.=0A=
In this case, do all the chained descriptors actually point to a single blo=
ck of continuous memory, or is it possible for the descriptors to point to =
pages spread all over?=0A=
=0A=
> =0A=
> > Instead of failing probe if GRO/CVQ are set, can we just reset the devi=
ce if we discover small vrings and start over?=0A=
> > Can we remember that this device uses small vrings, and then just avoid=
 negotiating the features that we cannot support?=0A=
> =0A=
> =0A=
> We technically can of course. I am just not sure supporting CVQ with just=
 1 s/g entry will=0A=
> ever be viable.=0A=
=0A=
Even if we won't support 1 s/g entry, do we want to fail probe in such case=
s?=0A=
We could just disable the CVQ feature (with reset, as suggested before).=0A=
I'm not saying that we should, just raising the option.=0A=
