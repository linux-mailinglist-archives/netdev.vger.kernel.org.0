Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3845A52CD6B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiESHnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiESHns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:43:48 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2063.outbound.protection.outlook.com [40.107.22.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680C0AE25E;
        Thu, 19 May 2022 00:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jn45kQ3BgEkjbduwifkUSP5fASPYgOQfxH+iUNXCcHVKwd2ujEe31WKFfJvUqF9IOJZmQG6LPgzD2UTVwOcH06OFMOozT6D8URMVzVh5xwpzGWEac+e8LwgzqjAbjS+C9Ub4Zldu3hOPxtSxwPI+qnSc24TrAi7uGRZ9oZY6zoPKroLhJfjrfucBjxVukGZkbm4JHfQnFU1rsHXjcw4KE3kuh4a0hlvZecmC0A49+PS2PFvT7bjeXP8y+PKd5xnXEYmFpm4gsPKKY+zzKByYGYw1+bVgQW0uJB1XfVMnKKtEL+u5+JPfCiD1YcqDlcAXQHT8UFWlXoBV63oYhtP31g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAN/QwIu/+zv3S/UVGqFCm/DhA1Sjq+3MNcXuUgTsuE=;
 b=YYrYcBj1YYjBYIxQ/6G3iJGEXc5s2h/SOPLM4rkVY3VDA27kk5dVnL+dNFXctYFISR+RkBL1B/S/h5bAxdvqQZxAdOP+/Qgc1fwgGUtk/9KYm8S6RyVmlXXRQ1uU9ifTw6GN0YJow8MqASCMylt05K+0ySnGq310tB4AnlqfuaPF0xlhwQoZWnxc+HMMdPdwLGGIRyanyE+2t9EfvCmVQRK6NAADgHLbvSvqDUItv40NLvjjPACejjrkLb0cZ5rJh+ShXi9TsEOOoxyShw77ISQnOybSARBrUnl2YJsx0VywcJm7FjUOlp/8MaPmYjEsCXePz7CUsTKnen3yx2s9qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAN/QwIu/+zv3S/UVGqFCm/DhA1Sjq+3MNcXuUgTsuE=;
 b=lRvsdNe1TOGa7Ks36mXQE6zDRKdMPhGN4pCZkri7jp0dEmu1rZtxLMACz9wvmt06NMwiQBMtIvBIJM8oAwKoUnRaRlYO8njgv9kCEXORmpyh9vEnTE715YJXf01khICkz5eN2KE5m+1zMlpy7pZ+HEs0ZXzW0efx2he5ZPvX9as=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by DB6PR0801MB1717.eurprd08.prod.outlook.com (2603:10a6:4:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 07:43:44 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::6496:573a:4140:b034]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::6496:573a:4140:b034%6]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 07:43:44 +0000
From:   Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     Jakub Kicinski <kuba@kernel.org>,
        Carlos Fernandez <carlos.escuin@gmail.com>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] Retrieve MACSec-XPN attributes before offloading
Thread-Topic: [PATCH net v2] Retrieve MACSec-XPN attributes before offloading
Thread-Index: AQHYapVaG9fIw78CF0erEwGJ0dAwg60kVqiAgAB7YQCAAQD90A==
Date:   Thu, 19 May 2022 07:43:43 +0000
Message-ID: <AM9PR08MB678803198E0EA09F9AD1AA7DDBD09@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <20220518085745.7022-1-carlos.fernandez@technica-engineering.de>
        <20220518090151.7601-1-carlos.fernandez@technica-engineering.de>
 <20220518092326.52183e77@kernel.org>
In-Reply-To: <20220518092326.52183e77@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 7b100ac5-e0cd-13fb-78fc-b06a1f109d52
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95359b5f-8ee8-459b-7450-08da396b4cdd
x-ms-traffictypediagnostic: DB6PR0801MB1717:EE_
x-microsoft-antispam-prvs: <DB6PR0801MB1717990FA4A5BF68DBFAB7E4DBD09@DB6PR0801MB1717.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yILjKAMNX/p8GYoyLA93MGisrILU4vz5ErU3zYZQLnrZ6CTBB7mZMjE2omi/0WgNKzWJbP1QmBTXgMre0LWDDFxuiXQjkQFJLN9PeQHTFSqn0WZVQdSG2hGyG4EBt48IlW9X4zs4bCC6Gv3xBo4Ajf2X1GvMWizwhbAnCgH5u3CljZFZYYH+jtRRmHIQzrSq10/Ho8GBDzJm3ig24DXAu/ZJHj2AKzQfmSN/omN1EDbNuo7PuZqCG7lGHUvOn8YdlggXk0prmXV5UBYBQFgVDz63WuZS0AHl/gcpbulc3G5GGnbPQGOyhGi9u9FqNX+G+Dpted/leW6lqFnLt8MRdS40na8/9/qG671rIF5UZ8qHUo9WqFo+fXcYAIF11mBh6Rgi6RmDuDuhTyfAnOb3UjGEHrWPaWG9z8S4D4SYeNZtuXj3a1JQ8lBOmRqAQyU5nXcQfBjrRZfkk8Dym9dD4VTmJEHAcGYrZZDtHoXkx3hUXeNOHf2IqcHRuI0sfpcyDMzMY8L7B3YSbbw72qTZOK2Ut7IefcNo8khKsabDOIjPV6y5gSB0o7RMho6/Q+PIa3vbXL2GLeadYQCilTRTgTMpfaMkvoDm9X0CCqQA9m+7d+v/c8OaoMxnjul27unhqvpqCrt68YmpY2N7Mlx5xwLzGUruJrF51jipwqg3LijW/TmHciU4bT4g/FIN07RBlZ9aWR1R2D6cfgr/xzspsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(91956017)(316002)(122000001)(66946007)(76116006)(64756008)(186003)(4326008)(110136005)(38070700005)(38100700002)(55016003)(2906002)(66556008)(86362001)(508600001)(52536014)(5660300002)(53546011)(9686003)(44832011)(54906003)(6506007)(7696005)(33656002)(26005)(66446008)(66476007)(8936002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nUFMIkE+gt2YLW8M5C958gD2N40ffcyJiMDIP2UCu4QTX4tpsIHJqvPK24lu?=
 =?us-ascii?Q?CbwGM5N3yAuXSypx9qZxpm8ek80YzBu7ZKjASIQFwtTpGs/qDlj0e9J+0yHr?=
 =?us-ascii?Q?Bj6VMK79JQxaa7bb/kijYyUlZ8ZoVfKC/vF/xcXmmF+x7cFwoxXCws1VEyOR?=
 =?us-ascii?Q?MDM0GZjLuiq0CN1IJTLJMt9jYl51+wkRs3zccjyM/KqS+TSfXjrFnPJGzV0i?=
 =?us-ascii?Q?5pmrwzdY45tXmCHxKWtOzXAXFyP2RK8jrw2XC6km1Gt9jQ+mOytRh9fWmasV?=
 =?us-ascii?Q?okTCwDzbYLXay21c9kIweTa77OwXTPw7YPPzyMARm19qZfiIOvQka77AKOMr?=
 =?us-ascii?Q?qbm83tAy8VwUQEMStDmJJ3dYoTZG7XvZPRjkfqiOE+1jvOwYhQUndyLxdoQJ?=
 =?us-ascii?Q?sAa+mWfWKuSX0ussEpMuISK/BtKcvsKLvLSqtxVHH+EqHgNE7/7Ulm7lvDzE?=
 =?us-ascii?Q?KZPCDdmk+AkAnPrniKS9Q7W6bZSxxQe+vksIBCC96yos9eijvjWt/SBorPre?=
 =?us-ascii?Q?auVvZJhuH0+NXLPCyQcqQFOdb2asuji4FgpFVGjOo9bRbWirI84YgiHWVbUY?=
 =?us-ascii?Q?kPywJ/wOMzANp6mUseQGZwY1ETosquTf24JE+wRmXyg2X/JwjRzce0iHXHwK?=
 =?us-ascii?Q?R5lGFEidodZPdX7bXVRgiLVJeukcdFGHoy52D6e9NN1S/H+RNsWXRdYFUu8E?=
 =?us-ascii?Q?nuTDAKZOKOLMs+EoSiueiw5wKnAJW9aforwY1kaRZOuomUgcSnbyugZCtD0/?=
 =?us-ascii?Q?mTaXQlA4ucKPQcYl16h7ZHfEXISB+ZcsGG6aP+Awqh/IrQJGct1JiwkxEPxR?=
 =?us-ascii?Q?UQzxzXEZ/voPGtcD7hwKUeqnEQxaXjDBNoEVb9Z3W5CfdWd5/SsfmvGM0qbL?=
 =?us-ascii?Q?O3Xbd+w0VHBgCizmAllo8Vqt0v3V1oVQlxOwwT38N1RQWPl7wi3oDHqtJ0WZ?=
 =?us-ascii?Q?WzP92nIR6qbgrqHvkhjKJTCzCBWeGd1J81gae7jXM6Bpo4kIU1cYuM/7xFV0?=
 =?us-ascii?Q?yUNC6mUVXbGMoFvWMr9eYLZMSAiNBo+MrREfrcAQFKhSsnqMVdoV+yw1eACJ?=
 =?us-ascii?Q?q0R+e/QlVMgqxqY2PUtauvp9a35VegIRPFXpD4BUPbr9bNhlzH/Nyqa1dGfH?=
 =?us-ascii?Q?J0pHUTSbJBOy7XnTqj0oD/aTz2OxSVdgiqAFaN3NgrvfYp6ASEPh6XiTsxXm?=
 =?us-ascii?Q?pfkg243HoheK8fs1xOqKIuzS/PSlVJ6lXcwnO+bAZZEhrnw7G0aPbz+/OuXX?=
 =?us-ascii?Q?+Q8gz6UJD1jON1sfbzAbyvsAxIkIO5QT1woJ/QuZOrlpOl8g83A4uY8CEbVJ?=
 =?us-ascii?Q?PUF2uEGxlEtFLnnO4kuM1Gn+R8PrtEcLerkYkrXuygOVVx6MmKY9zq1PYibK?=
 =?us-ascii?Q?EtvKH9VN42wjdgsi/dsF1QGIoTNC3UzdN7Jm/XjzXjpxeNr02J3lpT57yB6u?=
 =?us-ascii?Q?LjZm1Ke+UA0e9mhVMJEvcFRnDMaW6F3Ih6g3M0ZoOVK08rHatf3uNTVhutxg?=
 =?us-ascii?Q?88EIsI+OQxir3txEzXj5Nq/uVbGoF9umRlzL49ybfv68tg0m+fikTB7OatSc?=
 =?us-ascii?Q?/yR7xc6vMvBCRzBejJ1wGo4T4lP2JX7djgXieAFqS0SAdEohTRTdtPPHeHTG?=
 =?us-ascii?Q?3cLIGk5EKyDrE4vwOIPcVKJoSWltGMpeaoYCsJo38oHN17B9sZIdrjCN4pDa?=
 =?us-ascii?Q?j35RKO06ygKSAyTRNxXVe4ZfUhBI2zBoftamvJ7F84rDDYObdqTG7UUUGW2m?=
 =?us-ascii?Q?gbkXBjJnz+4Vnn6QFGsQmghj/yMJr8ENU49H99uyxRZXeTujbgsv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6788.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95359b5f-8ee8-459b-7450-08da396b4cdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 07:43:43.9587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h0yBJaL9kangPtnCvTOfE3D/F0cQWVqK6vx0ABoQsBcBf8EBUqIiTNS68z8Bojf1Kaa+BHjkU/B3uTrl+R6FHtIZxbMV3a9ArTSIxFmCth5qXAa/jhAmS8RwC8ck94xexaoeLJ9cjXAKl97oz1wg6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1717
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Where should I rebase it? Thanks.

________________________________________
From: Jakub Kicinski <kuba@kernel.org>
Sent: Wednesday, May 18, 2022 6:23 PM
To: Carlos Fernandez
Cc: pabeni@redhat.com; Carlos Fernandez; davem@davemloft.net; edumazet@goog=
le.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] Retrieve MACSec-XPN attributes before offloadin=
g

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.

On Wed, 18 May 2022 11:01:51 +0200 Carlos Fernandez wrote:
> When MACsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct. Offloaded phys will need
> this data when performing offloading.
>
> Fix by copying salt and id to context struct before calling the
> offloading functions.
>
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de=
>

Does not apply to net, please rebase.
