Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776A24FFFD8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237254AbiDMURr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiDMURq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:17:46 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130047.outbound.protection.outlook.com [40.107.13.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE1C7DE10;
        Wed, 13 Apr 2022 13:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nD8oiGkR2rUdEWs8kktus5UkVxhmrMjXirqI3QCF4ySEiXwS3qbzHD9bDaJ4i4s0gzcFr9KpNeeeqcYudzGfeZa2jitUuVj6Tj7bL+tsDGX2eRG2priheSdQ780kdmOX0mODCyMtIZyOYo844hskXNy6AREo1Q0I3QPy45dyc2yGKmSFW43/BCSc6Ofzy6Zts9t9zuSwd3YrKuOpa1uOdCstIjXEBVlQgUlK1+8RIVIpx4Yo1XPeillrkyWI/eWDgmE1FuqJ9NObY9ZJPgjXKF2Q9MYD+Kg6IguKLGmkDvWsl3lnnJPjH0stAGPYFz9kMoBHkT9ucZbVYZvy3TrAcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NTC3H21EFtPy/5KRI/SiA0iQWujtG9LY9PtYQOEOJw=;
 b=TVTS5Xr9CK2Ne/yqOcv7e8Fxy7WmplPFJWL1ej6rmpdci4QxG62rACTioqMuvU7H7PRZF2RgPUx8isyMn0DTVAeB2CQRmJbVEGeqZhGHmPaKHIwo+ScL4naZ9fy9i7g8czBBWAUfe2pJ1WrYV7SWJ8A3kKUT7qNPmedkAlact1tznyg/ibvC5n8QIqvK2eFSpHg05SNnLZLXu3GEILR/AiNQQOSdx4ZMMB/BPpsDp+mXQ3aJ77tRKsSg80LGsXhHLmXDMtcU2wU9Wm/fzT3iWfnMJADedrDPQ0gsarR1TbUGyJqhvg5sfqJ5edVvUGVUQYVEg5fu/HfLPiNGABnDAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NTC3H21EFtPy/5KRI/SiA0iQWujtG9LY9PtYQOEOJw=;
 b=JAM+GhtzIR6HCs0HWLgTzjmtfZkk3puJ1tnuzRIINhAmu5Yurshol+OS1pEGGmpf+16BaSHYslXPDlGkySNU5Ofd3z6n20ZYzrf/6WzrF23WdFltmvniPcyx4YM5ZNz51dxEKFqmgOpOx7UT5sHqZdBY8qej5ScOCtW+CuFYJqI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7756.eurprd04.prod.outlook.com (2603:10a6:10:1e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 20:15:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 20:15:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?iso-8859-3?Q?Ar=B9n=E7_=DCNAL?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next] docs: net: dsa: describe issues with checksum
 offload
Thread-Index: AQHYM9/NC+3mEspv+kGYTn+QoTcLVqy3uLEAgDarZQCAABqQAA==
Date:   Wed, 13 Apr 2022 20:15:21 +0000
Message-ID: <20220413201520.wpdeso2zfmwjhhqk@skbuf>
References: <20220309180148.13286-1-luizluca@gmail.com>
 <20220309234848.2lthubjtqjx4yn6v@skbuf>
 <CAJq09z7AT0eZR6hf4H2wHsSbXm5O6m4XTV0xM9r_4xgCOu=rtw@mail.gmail.com>
In-Reply-To: <CAJq09z7AT0eZR6hf4H2wHsSbXm5O6m4XTV0xM9r_4xgCOu=rtw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04326d03-933d-4c72-caf2-08da1d8a5617
x-ms-traffictypediagnostic: DBBPR04MB7756:EE_
x-microsoft-antispam-prvs: <DBBPR04MB775684BA46C5AF3268976253E0EC9@DBBPR04MB7756.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wOwk5F+4B+rjLQqZPnGUWp9hRfSG1LvurP6E72OQITn8iv+mXeSbs3oN115xCOJUJJqFGsu0vei+uJ7I3UN+KIK42x9hQcZn/aMPGUdP6Texbco0rqsPSabNtbgSUHbWTdyyaN0gAvXiWK2ngWdOoYjEK9+7eVI1j3ySRSl/0+wynxmPkW1tvR6b90CocYWgD0nRe1w9noERNtiC3cz+3e0KxUyNMJ66nTQHSNVOnSDF3INpPMzPS2anT8OsbTNUYZLCN5enQFH0Lbj0B3cMMZSRlzfNhf5olQNsP9Q4JZZw17Amj8ybNuEfGWsUwkS08xWG3GVaOWxyMHC09nGQTLEAAlYfrQleEK7jQPHksg2h/l/Jb4AOFY8IQQHsBzu5IkpBzKeaQ6whlgnpEUVucuJqEHga+1R7xNre6n4hVCUxfg0tFf0pLh42AIdG9UoZPbaMObPdg6hmnsQtshppTrWK75lCP8LZbOij/MwIPPEnx+ZNISNBbKcfjddWGOKtElvw8CoBgy3UO0khX0GZIYY4pwvx4+E0dn7sqy9Tp55ThRnohNRPJa+T0UXHTIVZ8jZ/31r/YvSS6F42EOeTpG4xIRE+D46KIkvy4NGON0J9jQJdcIUafdB4S2PnDrtYHm+XslPoILZXwl9AjlBTCtq+gekqqry3f9EreOaVur3r6isVajzpU3LfrbCBojOiIIWjlEZWGgOw5fQYTpm/2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(7416002)(5660300002)(2906002)(44832011)(6512007)(9686003)(6486002)(71200400001)(8936002)(1076003)(54906003)(6916009)(76116006)(186003)(4326008)(64756008)(66946007)(66556008)(66446008)(66476007)(8676002)(6506007)(508600001)(558084003)(122000001)(38100700002)(316002)(26005)(33716001)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-3?Q?qJQBUbyhNnfAcIqKvq+BJVJFBP6N7y3FL8yYYJ7FwZy+pYcabbVgpvxXIv?=
 =?iso-8859-3?Q?xQCBpax3xo57CHdgCAaNfAyAQHTscEWR82ms7a3+1xC9P5dXPX4mgnPtf4?=
 =?iso-8859-3?Q?ViNFz2nrAiqnVuEn+e2z9PGHLdwxsIzqs0L5oa2ngMOjdIE4kEZ5h2ZwEK?=
 =?iso-8859-3?Q?SS6OPHupqcLGvgMY9CwVUGSrBsCRiUObdUdCXg+cmAYfL4EHQuWXfJAqod?=
 =?iso-8859-3?Q?ml5zr94ob4zpKSKJTbvX/fzC6Xpi0cPiedd6k2XoY2r6BpE3cr74Q0R+nr?=
 =?iso-8859-3?Q?Pu2mvZo87PBQlMkh7ZR2IrtiqwDQHKlvdhd1G1jMNr8uhL2fkwrtFnbxON?=
 =?iso-8859-3?Q?dHi6mHCvj5ESova8PcUEyWem7RdOW3cy+VxyS3RMUcsIOQCkwzT8d0zt+m?=
 =?iso-8859-3?Q?xYRuflNu0xbS1pKjCOvfj3pnauaxoH47n5GeTO41mCb7kbhC4V8/wR1Ond?=
 =?iso-8859-3?Q?dTC4izBPMRut8N8vSLRaMbhHr8xVWWCgjw6rlv2yk2QqpGuLwfQwV5cGeo?=
 =?iso-8859-3?Q?08yOH7eXte+ZPpQgtkJQ6Qx0A1qYgsiW5Vi5Y1Ivd2nrjuW83QFHhEpztL?=
 =?iso-8859-3?Q?5QIdZ6mTWHKrLgwkij2SOHqEKcRhZdLhLjLTn6rPQc4gIIpMl30TUZuMXj?=
 =?iso-8859-3?Q?S3VK4NM/DnIk7iYlq3cXvkrndZRH4CXQTjeSz+JIixJYniJ7IsZsJm1y7W?=
 =?iso-8859-3?Q?xBiy94yOmfhJymFlvTIJAcyf2gFbWUFQKK/p6+DtZbWe/AmLdt7ad9ZJdb?=
 =?iso-8859-3?Q?gQSgwCaWf6FrSQ9wJKsMRP3Aiya4Qj2JXRy0BPVD9B+LwryK+AsVKDbC1p?=
 =?iso-8859-3?Q?lCXu9dj61cBRADuWlcp8bP6b9fX2Ze1pWCbY6ex5wc9oxEHAphTVlD3MOl?=
 =?iso-8859-3?Q?Ck41lAw9nnVzppRQTwl85+oRlPKmRm1d0qSlSCS81md/Jz5Oe2MsJo3coX?=
 =?iso-8859-3?Q?9g2tR1tRwuIMYOD6ck7fXNMpe2Uz22X+v57/lK5ZDMrrPpgujIiaoq2hCU?=
 =?iso-8859-3?Q?Jhl6d/dq/rASW216cYnllYUczeknVyoYDZz6QtqGbrn/iOh4z1Z3pFkpBH?=
 =?iso-8859-3?Q?etnh0V/1OeqkjnawdpOwUk9mhUGbcxP9dn8INPCRwXgoHtxqmxKy5CCuFz?=
 =?iso-8859-3?Q?IT+aV2MdJwr0glH1CAaYhR6H1mCurrulNP6DohcCtaJ2EkXxVn6LuyTHaN?=
 =?iso-8859-3?Q?Slj2NE+xRE3AQKJoF3kA81tupqL+Nc0ErtxidWQXPVFpEs84FwBQRzlcTu?=
 =?iso-8859-3?Q?QMjPF1s1kDB2hyMUOMlJJ2MaZyfK0RfqRqJFFuOLIsm6J1J4yJ5zp+W80Q?=
 =?iso-8859-3?Q?VWhzYdT3xU45X8u8GSVWPDxzTb7giJZ2jqLr35motJRZflbzKJYswpDySA?=
 =?iso-8859-3?Q?ZR0xy5gwdFIsPY/vwZbK4RQUmAz391uBmh9X31Ye0DQzFD/xNAL8DtQnb8?=
 =?iso-8859-3?Q?MjGVTgJhmcKIdbmWQm6ANVhpNUtZUaNc2FYfZSOfY5uWV4k3I+J6np5DxC?=
 =?iso-8859-3?Q?wWhHjb7bqk13GWU6gamBYMBn5vHn4zNL6N8VOoYESW1MXN7y+EOIeygDAL?=
 =?iso-8859-3?Q?ObzNEvDOltImE1Jce9fBqFUHnagfJr6CYq4+9ckyhZhpGw+HrDE92U8Dok?=
 =?iso-8859-3?Q?7n5W4IrfOSYX3LfoANlk+yexKZeGAbSnW/6cj+qJTset762fLalzNcz1dt?=
 =?iso-8859-3?Q?qAd6XNNbmaSRligRHHG58J1kFA9Flp7z1hvk1t/sghosfRousObCzNK9o1?=
 =?iso-8859-3?Q?njgFsb0LG1KlkkcsAPA7eukcr5YKKHVRT8WhJio+GNYbG4MbcEZO6vXT/j?=
 =?iso-8859-3?Q?ngJNEcOMe7GqjXIlPL+AC7epjIHeqYg=3D?=
Content-Type: text/plain; charset="iso-8859-3"
Content-ID: <90FDA0D7F1937C4BAFE169D1F76A5B82@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04326d03-933d-4c72-caf2-08da1d8a5617
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 20:15:21.2032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qba/QuuI1MGNbaavXfXD4wI14jOA+DOj25KgPXyRN5zcw2ZUd3rg86qV9Rd8Rw4ztFNq46vkivnEFSZ8F3wQEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7756
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 03:40:16PM -0300, Luiz Angelo Daros de Luca wrote:
> Vladimir,
>=20
> I sent a v2 with your suggestions.
>=20
> Regards,
>=20
> Luiz

Sorry, I had put it in the folder with read emails but didn't actually
respond to it.=
