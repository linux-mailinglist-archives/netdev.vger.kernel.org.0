Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE10F4AF296
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiBINXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiBINXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:23:36 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20102.outbound.protection.outlook.com [40.107.2.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51196C0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:23:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLadaSji9g9McJDsUKbmW5v9Ut8KNAYqjVEJenMZDghFQWC4UuRaqyxyvDBQADc0C14Bxz4NJtIOnLI/4HVWwW6vI2iUkbrnWYvdjMwGk3fEVZ+ztyKgST3BgjeFH4vbkf2BEN5utWhmw5AklCHmcomN0TeWZYvmZnNgV42vowkLEiZlMEdB4/VTdpSD5DUcIvQFWLlgp0TYKM37Enx2QTSr0mqdTtSVeFhcRzRdburX8j/y1A046GSPtkidkUzauEpNXLb6Y8SKiEh3kHbDwI1vb6RD8xxgzG/WmKE1/t8GtbKYaySIqfuzpCWXms7Me6SvLirLv0/rH7EzRCiSgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMFGd/ADxiB8+yiAF8Xi1YBDHcBXouGBCFMc4OoZV40=;
 b=k7Lbk64AzdLKYpwWBodU2/mTEQkT7ZafqYutnLgqdZYT1Mpfqap37X7c719DpLhTHwCLVUiV+JGxPDggjoeGW+sRl498c6fSbBHVwg6xECYVIEBQsOABegV/iLlE2wYYoXlRxUBEqRg0epQ1sFrGEstOWQhiwNy325cJRBjv6bv94HzjIOqt4EHwu3MxhLemQvi9mr5hj0iqbexHiFcm02m5+5Jb5T/B9Z4bM9R+86VFQFbB6ftme8ZS8w19xqYH/2Mvi+64ev8DxxAvI9xTQNj1kcKf11ctjOjkVVfIuayHVaI0rz8RNT4G9zxf0Vxcpzb62XHCd80O9SFG3DDHmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMFGd/ADxiB8+yiAF8Xi1YBDHcBXouGBCFMc4OoZV40=;
 b=WPxKFmHHM4SWANznOs/3nqgmDAd+Fx4Tfm41XIsiZaKp39G0ANCaGs7Nct2FjQNoEFACrrFPEDHcaC9sBE0GSqPLT5Cy7OwCrHDGRz+KgIUp9aDNfEaXOAiKydoAjH+jcxSqUoV+D7aJurAmJKFNLkPdnTUn9TfcmAG6YUYiTtMH87wfOa4yXy5ZSjXRFd+YH4Cb9IGPudzSZ9ES0ieiYdtZAf3/1RQFvnDjy0XWosB7poQfwi7xAzILvI8qX8w3EnXK7jaIuAJH+f0BWOVsqSd6M6g51axbrWvss4gJ4ZPs4lvPbYW6mDEKOjeBRC5qL88opniT8SgKbs/vd2MUBw==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by HE1PR0601MB2474.eurprd06.prod.outlook.com (2603:10a6:3:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 13:23:36 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 13:23:35 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [v5] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Topic: [v5] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Index: AQHYHZsKZlC/aBDBdUimD8mOlShuu6yLKB6AgAALu3A=
Date:   Wed, 9 Feb 2022 13:23:35 +0000
Message-ID: <AM0PR0602MB3666CDA52930B908ADD5D37DF72E9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220209095427.30568-1-holger.brunck@hitachienergy.com>
 <20220209133631.1954a69b@dellmb>
In-Reply-To: <20220209133631.1954a69b@dellmb>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c304359-f625-4be8-e8ad-08d9ebcf602e
x-ms-traffictypediagnostic: HE1PR0601MB2474:EE_
x-microsoft-antispam-prvs: <HE1PR0601MB24745528E336CF8FDF81C47DF72E9@HE1PR0601MB2474.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /9JZ+s5HnmDTCk5Vlt9ZrwaWYmgfJFqiK2tqpd9oJY7yQlBVWmEyT+pAr6BFvdNKc5UKta0JXGhZ+ykbdZlKrVgONUbCmY0Gh3Y9D1wKU7OhLjV7kWaCTtZIw36fiSRe2T+exqyIj6ADp7whYWZyC0XmGqn72Gx63VWAyys4nBqnDYAcSuYKRUCSK4xTLMYWAB6Zf0rZyOJ0J9AnAGjR7VwwT0arZAoOneYx0YzfTlJOVX2/2ahmTCPEp9R00ugqLc+1DBKvLr8Byah/9aoUp6/Xs2kJeqSAx9adm91U2+AxV6BqfDzKNXZI9cC3RvOYqLBRiWM/8GjtSCgFr1HQ2vLCI5z1dj5sa9Nq94EXjXtP6lhnqIVFNS0iL8D+RLHEsM0n9R2inU0HMbJrWqcUHFSZi1PLGBPBMHZjQs4Lt/PakisM3UmgZyljFXopMy0kod94vo/DcyYFSwyqJdBbAco5EHoc+DAtVWZtHWOK7Np0zgB5EEn+zbOgF9+kJkvYQc6j79IIBWjV3RVwxc06Adt7g7l+blUeeVPcoi3W6ouFhE9J28p+9T/cLXAUNUC1WuGbQi9dhzCarQgJqZsdMLrr/dyHPeTjBiG7p3lWTutwOibNCHzhXrQcZceuAxN/546GUR/OguOW0RqgSXoN7rM5N6bpyRmLcHlCBqd1cqtk9mhrqqMWu7A0Kkn0MjbPRIFmAaW5JFCdlAuJvbTsrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(6506007)(38070700005)(55016003)(33656002)(508600001)(9686003)(71200400001)(82960400001)(122000001)(7696005)(38100700002)(5660300002)(66946007)(8936002)(86362001)(54906003)(6916009)(66476007)(64756008)(316002)(44832011)(2906002)(8676002)(76116006)(4744005)(52536014)(4326008)(66446008)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EE5oaH5ClDtBPTP4UPHMh3oaEpDs7CYBCULcfHTRHyoaNpEHa0k+3clq2T?=
 =?iso-8859-1?Q?i4cdETHhKEfHbNTOXojQ6HgJ3aizYiel4ICc3G9iTsCgLTgzRBRLQy/+6N?=
 =?iso-8859-1?Q?5Nig7AnyL/zEfOQwF6ip543H2n1/kQPTCCeSx58QAOV0U7JigxEzMNbFqH?=
 =?iso-8859-1?Q?NfpK16EK+pEloBK0GY6fMOc6Czcm5YJiazbzelIxDKEEuLSC3IY0W1klQ8?=
 =?iso-8859-1?Q?Y4ka9SWfxlXNDehUdXew9CPyfFOWozaosHWNK3UU38j5zrBYhhf6QnsVyv?=
 =?iso-8859-1?Q?wclu6LrjwpA2Hpx1SHnjqlirvoJyRK8qHUXEGYajPBa/xHbcO4u/UW7EuC?=
 =?iso-8859-1?Q?xA7IkSNxQFKDdheqkOOvXgkW5/nIsRZZBCM5TO65aFEP3qEDw5Ks1PuGVm?=
 =?iso-8859-1?Q?GjFW87QuLLTuV8+waqKayqreF16NPfyPpTzKlqgBIobpkyaOyrdR59hfE4?=
 =?iso-8859-1?Q?FdBC15mlIr6xXNXk9ueWTMarC1YYnQOl15aC/UTR8HHvPK7mToRyo9alsh?=
 =?iso-8859-1?Q?fmvzFJ+OX9oIQVvQl3KqzQXnZweUY9opzQc6uuEjVdu0mgrIIhI+EmVqLj?=
 =?iso-8859-1?Q?hikb1SBZp6sf42yHgGGboErv5Bbg1EIuEGIGli4TfW9Om62qUOgAypfE2R?=
 =?iso-8859-1?Q?yjGkCIjpIX76/PD6CPjwQTU8hQImypN562EBrp67UHQjkhMF0Y0kIjfxGc?=
 =?iso-8859-1?Q?/sf8ObOFwn9ftFM+40C3xDQoOJvVoVcjXCV4756KAYjbgxRf57P8kkWF3b?=
 =?iso-8859-1?Q?HpqyYXFNg37eLfAihipQD3XEiV1RSZOKtRpcTcnNPKmYrpiGUiLVq+AMz9?=
 =?iso-8859-1?Q?xrA6Q+/tF1zz1ziaviGmbce9WKW3QIWxewLqBKmKW566M9k5nNcy9KTpNj?=
 =?iso-8859-1?Q?hWDGFvzporvcnu+A9UZC6yPKbWgzFco0LXnIyK7FeSCeXekTv9lbPKJBJh?=
 =?iso-8859-1?Q?DzKY9hA33C5cM9J252Rmc2n8tsITm7BtXWE+yoJ84dL/VhKVmawPa05Voz?=
 =?iso-8859-1?Q?/FuSjOaAUYG7cHSPjCu0F59uwXMC56rofDLLverkFhBCDsDVk9z3WbAznN?=
 =?iso-8859-1?Q?XhIyex6CLv33Q4W2QNAHNL/39A0nw7fmxbhNVJa9vZ6UG7tswWaQYuHk/1?=
 =?iso-8859-1?Q?xJPefstAQmz72WrBA1cMYR3TrFbagNk/ltcyU4d2b5DAnXkW5rUnZjrG/O?=
 =?iso-8859-1?Q?2gHcnYLloBBCWtBn60nq3x5UksozSPodUmFNMlzj4F8/VNymdXAU2dyPl9?=
 =?iso-8859-1?Q?DKMv72nrQN+pBveiPd3hlmuDtOExKdqusOuVOkUzjUWZiKVwDGMKVK79Cm?=
 =?iso-8859-1?Q?tqcVSQq6KJkNtmi6O7WWLjMFakwHAbA8g+Cdn/GWu50cL+h6WzEssKtZcy?=
 =?iso-8859-1?Q?XHv7kpBSC/hTIFKzSHI4Mz/vM1gwlKFIMIkqpf19V8hQqPAVoQ5Y8rhZNb?=
 =?iso-8859-1?Q?vPXQv9JufESzHU1p5md63Ht10nIvQsehEnxXNTMl/s2p5oBWRZrbltBm/F?=
 =?iso-8859-1?Q?tiDcB7I8LaANeXttJb10D9nDW8ZXQbblvctGNygKAaDrIj62nm81LWzbn2?=
 =?iso-8859-1?Q?0i8i09qFrObmMBbbptZa7knQ3hlPelyicFjhbO9DXbGfAXafl1Sq9sMdZz?=
 =?iso-8859-1?Q?dShkEez4PrL2NgKUKmdG46Ovlb2U/6jKEyyVKUK5GsuQYnybNVf88SM3WT?=
 =?iso-8859-1?Q?vyFfdtVAwTfxzK467mxD1FI+iTBaNWo5HuXk4cROLPERLUdJhr1nShROz6?=
 =?iso-8859-1?Q?cpRg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c304359-f625-4be8-e8ad-08d9ebcf602e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 13:23:35.3143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rDXO+sAyc+hGm8PH9o8Um63fknz8qly2KuPDn3n8iEZ53zfcKzd64gORuwVvO0gGU9t4WccMQ871agmWZNxKBEFoW5EjlCwDMbNIp0FGCRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0601MB2474
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -3178,6 +3181,25 @@ static int mv88e6xxx_setup_port(struct
> mv88e6xxx_chip *chip, int port)
> >                       return err;
> >       }
> >
> > +     if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
> > +             dp =3D dsa_to_port(ds, port);
> > +             if (dp)
> > +                     phy_handle =3D of_parse_phandle(dp->dn,
> > + "phy-handle", 0);
> > +
> > +             if (phy_handle && !of_property_read_u32(phy_handle,
> > +                                                     "tx-p2p-microvolt=
",
> > +                                                     &tx_amp)) {
> > +                     err =3D mv88e6352_serdes_set_tx_p2p_amplitude(chi=
p, port,
> > +
> > + tx_amp);
>=20
> You should use
>   err =3D chip->info->ops->serdes_set_tx_p2p_amplitude(...);
> instead of
>   err =3D mv88e6352_serdes_set_tx_p2p_amplitude(...);
> since you are adding this operation to the operations structure and since
> mv88e6xxx_setup_port() is a generic method.
>=20

ah sure that makes sense, so that others can add other implementations.
=20
> Sorry, I overlooked this in v4 :-(
>=20

no problem. I wait another day for other inputs and then send an update.

Best regards
Holger

