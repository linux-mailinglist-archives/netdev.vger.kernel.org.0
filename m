Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01A3644E93
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 23:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLFWjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 17:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLFWjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 17:39:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED86E48427
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 14:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670366342; x=1701902342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VBjbeC9zHYnY+EC2KTxO5CLX1tIhZQvADqp2xBSeR6Q=;
  b=2GWCa8CHsyY9whmvRXxNioKOFeBvcSkq+UfW/Ov96MxgPKElQiGi5gVq
   GxPaTK/noVWHv5FysoF1v2obrFU+NzDVOZy5OxD+kme0/FBJcFW1B3c9M
   NrBie/ZOmv+DGBBm0xq66f+9wIJsj88USnVRSbIzOT0+mGMu7WyE1dJvV
   rLGqDkjx7sVKgeEXB+z7Pg0SsPvw3iK8ny5QOKIc3wSjXf9uabvWM7HyG
   6vailULPnv0V0QQURDvMYQygaO1odBLHwNcKKJSBWXfOFANZtQ53U2cll
   ItALX7ixYPpwcquo4MDlSf0XjPzbsz0OjD+CfL4eSKus3Qb8wlzH39si4
   w==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="126824884"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 15:39:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 15:39:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 6 Dec 2022 15:39:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARrZ+tAxBFOfKNSz+OiGCu/Jq7Boh67VuZUF2kFbEEshccst81wwVET4XuxAK1zKzCjTIZVGvdTz/4Av7vRW7BBaYzVA/cYNW8ODkKx2vN5fLY4F2XXUdVLhDbqfXVkGFWAdwNuSTz07mqZWvnauW5d4lFUd4zHZy0ETc6ziNyNLRXmNyMNYGGVt6iZuTvriI6arS9CPDQXu8qz6rnn48oBjGIQLZZzoxDMwUJy/ULlXLAnahGOOEd7by3tn/a2YbuBuTmcZ9HBjbW/VGSQK9zXVtr9AvNtdZY3yojussoO59FM3iiDxVnucmMfuebJyVlHtYl/Y5BnS1j2LTUQPCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIoCiCU6R5C8q6XNRC04A9Ca54pMAKrw2UObZ2kHDh0=;
 b=O5vqL+MlBYBFXSg5SbtNK6XRrhCxLno5mlbUKNL13hHYsf3CAVcsKUCO3Zd4hLD4aVhwYU9QAOVxD+l/uzSPduzI+Y6z5Wa5CA32LjSUk2xgFT6HyxN4bF6jkYM+ttkq1SUTtW4EqvyC1ch3gYHD2Lz0tw43cx9UhFQgb+JI+d/DKz9C92Eh+C7UjtajIjlVNXpFlZZUKHeF/G5bw35bnEs59+UfRojf1xtEE4q+Y/T+hqwO3Da5muiLrg5YpQ29nHtCQ4zwe8uCNTtLrmnHs5D93k/kSrKoUXaaO268teWMDsYy9MkJK9gHh3YAdP0eGnN6uiEZmlPv29EH5F3H9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIoCiCU6R5C8q6XNRC04A9Ca54pMAKrw2UObZ2kHDh0=;
 b=CG3DpqeY3XzjK8qeK8FoiN41ivyFFS52uTfvxCWxKqbmfWhvzaPmvfwQUz1HvzVRwxJJ0s1j2eCehxan6a8YVDLUSoy4z90eLNHgMQ5c9+lQrQIuHHuMapgYJbmjFderpMK3TUyWbBLO+CbH2WjBq5XXlu5SBb1H06nz6hy2R24=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by DS7PR11MB7690.namprd11.prod.outlook.com (2603:10b6:8:e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 22:38:59 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 22:38:58 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Thread-Topic: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Thread-Index: AQHZBPd7JcFTQQToA0qvxVT5rs7YJ65X8puAgAFEzcCAAAdwgIABes2wgABHIwCABk6bAIAALUMQ
Date:   Tue, 6 Dec 2022 22:38:58 +0000
Message-ID: <MWHPR11MB1693C9E7D1B2AB14B5256F19EF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221130200804.21778-1-jerry.ray@microchip.com>
 <20221130205651.4kgh7dpqp72ywbuq@skbuf>
 <MWHPR11MB1693DA619CAC5AA135B47424EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221201084559.5ac2f1e6@kernel.org>
 <MWHPR11MB169342D6B1CC71B8805A741AEF179@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221202113622.21289116@kernel.org> <20221206195516.vv57lab7p4iifar5@skbuf>
In-Reply-To: <20221206195516.vv57lab7p4iifar5@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|DS7PR11MB7690:EE_
x-ms-office365-filtering-correlation-id: 4d10b73c-1086-45e8-c34b-08dad7daaa71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LlzipYXKf+2u9DitExxpZ4NLsv+mUkhIu3T0ix69pYxy4qXYbC45Pe1ej/YYatLdNY73QXgSzlUiUcmPI03DJOAB/svPliyPIOVwvOKmNLrCtI5TNUOWLfLcEbl8AsiFvRBG4YglQW+ncdhgZOYykTX7XPditwNplI7kx/EsXdiF+CuHFIMktiSurcGKFDFlTCBW4z3+g5cm1WcQnpb95B60hgI+R3HuwsswshLJMp0YitRxA64Ej8M3auKlsYrL1LyZgC/qnKM6o6ckBLoeb9pN4EzpfwdYWuT3NSq3DIJS8KKmPXY+6G+T9RkVSVo46uyjzNVwL8gxQc3wmq9wgkd30N9ja0xtPM5zHjFFB+apPCT37rhkRwntDYSuT+13LnOShGLNEv59NGGx5NO9pLAmOI5HrvbYIOpZWVGJv1xTVCmdrl2Ubd47wKG9vsxGFtafAlgQq2TcmOPhCUUIFOevB3L2A4W3LVRUQtENsUtrQv9LkxFelf4mILiUk5I9RkAhjQ0ldpDF//+k18S2rowGMCPJwnJHAjFs9Z8F3rUg0hONKTRKBxx5WruE0BgU1Hutx8tG/N5iubx+SBw+jtqk8S66mYu3CnFDWjlJ4hpXT34thuUGN2lchUsGZkrMKeHpPYZ9j07iksRLOsSaw9sXG+wh7NROPMC7oTXImBCyp4H5kWJ1p8Nob+ai7nH5qXIrZUTiEtgBmHyYX0KJrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199015)(64756008)(76116006)(186003)(66446008)(66946007)(4326008)(66556008)(8676002)(33656002)(66476007)(9686003)(6506007)(110136005)(7696005)(83380400001)(478600001)(86362001)(54906003)(316002)(26005)(71200400001)(2906002)(38070700005)(52536014)(41300700001)(55016003)(8936002)(38100700002)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?atOQiYnbUfI6M9lsKh6YPN/4rVmaua57aAnyoOTWrxSVspsiKkgKxTzZI8OD?=
 =?us-ascii?Q?zJJ6om4KNDr6HpKukcKNYBPJYZU68dilTqFZoHs/GAtZUe0Ecd54E7+6d6qQ?=
 =?us-ascii?Q?T/ugU2DMGKQGEizFDzrVBtpn7GmiG2V12tWgyZlxnz0NVqVXPXuw7H5E25/U?=
 =?us-ascii?Q?0+Ag4p46fO78VKkEsHPO+ThwfRP5ugGTU0w1GXM2KlF8pbUar4C9/3KSut0O?=
 =?us-ascii?Q?mil7ROT6UcoWS3rSOQqgkGzzEUgV1C1XyzwzMxpvqZsSepbRxMmnrdyNpOsS?=
 =?us-ascii?Q?dtyWcJoU2b/CCD38xIwtxv3mA9aefkSAGsgQywjISslOPOPCVSCI4MNs83dJ?=
 =?us-ascii?Q?sXWmN87EypsWyw+P6Bvl4koLQJBtERoqvD/sJw6ckopyMvW5ct16Wh+GvLNw?=
 =?us-ascii?Q?GajJx350vufeXTW7EohA/tWX0OSCw9n9jpdrMHXvQDvJF9NHpDZlg7Hx6zzx?=
 =?us-ascii?Q?hG9jSS3CAESCbSaInrjoi8lpPUfM4XDBk7bW/sO7kl5KSXlgrI7Wd7tMT4v4?=
 =?us-ascii?Q?/A87E0IAqLjWKTIjaz5/lJz0u6W7eObt9ZonvrKZXIkTgADRpDAu1XNRaXH+?=
 =?us-ascii?Q?MU/RxCMI7wD5ah6M042EJ+bMnkqORrT+4oojTTogKLu5+lPbu6F9GVecrt4z?=
 =?us-ascii?Q?JmXTNYpJrZ3goKalZ7kMRdA0DMij/4mfmppqzr69sEVtwFzCep9XSeD+FWEZ?=
 =?us-ascii?Q?RMBD0nFZoMqUou2iUyghaSXN1W/ti41kEl/i5iJh/JtVIbH3VSZFyJssbYWq?=
 =?us-ascii?Q?3URT+IxU4UJTJgl3NfpRTIdZXTtKLsAoZnIfNl2/rJeBg3XZCMEF42AXirLt?=
 =?us-ascii?Q?gnHprm/6lSfED3dkUubM61hqGrVeiStF6Xz/D0XjKSTmNwGrD3VEjJQPDpXO?=
 =?us-ascii?Q?8M32FWbYwus5/gDUUTEy/zTD1BzeT/d+XYV5kAegrfrVue56e8af8vmOt1Hx?=
 =?us-ascii?Q?MbRQ5PdEL1pkfYAVddGXRggXnWjL3qixFAgN8awn5qvKeuEg3tZCK10V/vDt?=
 =?us-ascii?Q?rRU8+6lyxhEk44fzVNV95fadLZ+aarGIv77idlPjFay8iEpHN/W7moqP2gkp?=
 =?us-ascii?Q?tjaDdbYcroRtzsP9ZyiJcvNGBJwr1PWRqjG6T6vehmved5bRzpOT0h1Y6vP6?=
 =?us-ascii?Q?f3a4RhsBclOcQb8RoiLwf9EQ1oRnlpr7M5GPKJkfamrofHNsq2yej65M/Mt6?=
 =?us-ascii?Q?gODU5/33t/HZ3ga8XCgkNO/ARjbmN92Z6k5L7W8t88sXbNIGppB+XEguLQVA?=
 =?us-ascii?Q?yU8YwZx1SBWq+Qn63y15OTBpZ1oAE/KxubVt4rnxXaFMGNdzqKWEphQt9f9+?=
 =?us-ascii?Q?iazp3nhOurr4WDcTMtDBZrGMRpRIb90boZgmsdNKl+wYrZDhcUrQiaMvulkJ?=
 =?us-ascii?Q?ZwmGMLOwtdSgWYEhftezXH6Bfmkhwzvp21pQQ6zYOlE9qrEoh6By6KZymWLe?=
 =?us-ascii?Q?k0zd/6NwPLEroxAvI+tNKYZ7KBAEy5moVCBgFufbkdjQTJkwmyL8GyFZal2n?=
 =?us-ascii?Q?sB26bAeiCp/CYA2ey2l+3/kMDoShU5JcAygIWKEerAan7F0Wm2LsOsZAEP1y?=
 =?us-ascii?Q?NhCU/+HTwmbXFF84wiL0ZJV9zrZeN96cG7tNz/Bf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d10b73c-1086-45e8-c34b-08dad7daaa71
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 22:38:58.8614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uLN2iYsIBPTxqULdpiZHGPzAWoUBcn+8zwj6t5T0g7sw2n8EHmAhdZBXEMFHQtqfyKGSpAuTHLp7aiS6lPgLCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7690
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > >Huh? I'm guessing you're referring to some patches you have queued
> > > >already and don't want to rebase across? Or some project planning?
> > > >Otherwise I don't see a connection :S
> > >
> > > In looking around at other implementations, I see where the link_up
> > > and link_down are used to start or clean up the periodic workqueue
> > > used to retrieve and accumulate the mib stats into the driver.  Can't=
 tell
> > > if that's a requirement or only needed when the device interface is
> > > considered too slow.  The device interface is not atomic.
> >
> > Atomic as in it reads over a bus which requires sleeping?
> > Yes, the stats ndo can't sleep because of the old procfs interface
> > which ifconfig uses and which is invoked under the RCU lock.
>=20
> Jerry, did you respond to this (what do you mean by "device interface is
> not atomic")?
>=20
> Still not clear why transitioning to phylink is a requirement for
> standardized statistics. You get your link up/link down events with
> adjust_link too (phydev->link).
>=20
> Some other drivers only perform periodic stats readout for ports that
> are up, because those are the only ports where the stats can ever
> change. That's about all that there is to know. There's no requirement
> one way or another, it's an optimization.
>=20

Yes, Jakub's understanding is correct.  The device is accessed over the
mdio bus and as such, will sleep on hardware accesses.  This means that the
get_stats64 will need to respond with the mib info cached by the driver rat=
her
than reading directly from the device.  This adds to the driver.

The phylink up/down DSA hooks will be used in controlling the workqueue
threads that periodically read and cache the stats info.

You are correct - It's not a hard requirement to first migrate to PHYLINK.
It's more of a logical progression of bringing the driver up-to-date. Havin=
g
adjust_link API still defined, you get the=20
  "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!"
message on board power-up.
