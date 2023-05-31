Return-Path: <netdev+bounces-6877-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EBD77188AE
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B773C1C20F01
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F12182D9;
	Wed, 31 May 2023 17:43:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFF4171C4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 17:43:20 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9B9128
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:43:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbeYESgfbfC7+vpaPpjdZLefkKazkugobnl80l4hax7DzOLFv5vh+UDCijQ+W7oD3oEgmX072A39ZzC2tn2WiC44dIxbZyMmJYBt8DeZLblmxzZmbJBDTJBp68jama7cNBnQA6ibsa30/pWd/gmO/SioboRlKNveL+ulN28fafR06ahd9vs5PPpyG9vN/zvPkdZai9qmZa8IRIwcpFlyotd6PGIhjVoQCTegwihY8DNFRoYfc7uJsLgNSMOKr0rxQsLsXowgnMfFnrh9uVEp4p7eRH/W5XznU82vPV5kCRNSFP9IMXq9T/C0CIYYSyLTh6+WtsasjVV29XBxOj4Zkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1NGxqB6DceYy4yw+SnTdzs7yDlW6PumwP91veSfyTE=;
 b=UTGlJ41zSPNbOGJJ+N4Qr5VmI3zGUSQLzPTkycz4qtQ7G8J1rWS0OhWv9mwZjDSIk+cKUGuKuahdf0Zl2wpYMr4RPfn9Sd+gsLOcraSNz+Ns3uVaGiHmzi+qNdkG7T+/mP/rq3LoP0y+UmGB+YTp9dSXyQuFUTMhYJVoxei7VzJsNtzZ3tUm2G0AzVHyyAvWIfenHQfUCeSwp7a73lH22/6zD1l3tTWVgrC/c55A2ejZV/Jn9axTNFBn1BB8hSVURTMFESGWos47S4bHmMO/4rDsYZRADqBPWgYUzVLNA0i8D3AAaB0HjQZyb+OKetgELs9hSc+jbxWj/GLIl8dLwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1NGxqB6DceYy4yw+SnTdzs7yDlW6PumwP91veSfyTE=;
 b=hlDy1/mtxiFQGvZuqzJKb6cueHUHlbM+nPBUmT5d3gecss3LnDFXyHNM8hVKI5vs2n6IQyK8d+qT0fC4LQLkJlahU46PC9A7Z0WONXo7QsXOrqavr+Nf7kvwUJE37BQA8ow/xmY+Llwa0UqoRN6q/nxv8ChWZ3Y/aShgZUCqG2Q=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by PH7PR14MB6455.namprd14.prod.outlook.com (2603:10b6:510:278::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 17:43:15 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa%4]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 17:43:14 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v3] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Topic: [PATCH net-next v3] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Index: AQHZk4PK5yRseal32EWM6T+3tWtvq690lakAgAAR57A=
Date: Wed, 31 May 2023 17:43:14 +0000
Message-ID:
 <BYAPR14MB2918A428BA5654A4495321D5E3489@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230531055010.990-1-michal.smulski@ooma.com>
 <ZHd4DJa7ha2Szne5@corigine.com>
In-Reply-To: <ZHd4DJa7ha2Szne5@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|PH7PR14MB6455:EE_
x-ms-office365-filtering-correlation-id: 354d9ad5-e6cd-40ee-42c5-08db61fe82b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 FHkEjL1FXjxByY6Xy7XGOa6p1avoieWzglpSrmubEOfMOzGHpNL+IBskb3+QvS4GSwneUQ9GLDrjP8mCT5hkEL0/QbIn1WAkCrY5K9xHoBu5/uOSXrnihABlj0n76WSvXIRSSYaLOgJODzd5leUNeg3SCDlwv+8AhP4k1jUZhkCXsTYEPcQRMEH6ANc1Jr5lQZhC4A9rxJPlmK0y9ffu9W4lre6jjraXPSxS44RJV5ndyr70/xLxsPAGSKHpj7rlYLE+WjEQsXakYl1jH977i5Dwux59BkmIUrJQ2vuTmDQoIEl66aFGkM3gmQM4NR4QYOkqEnlVjEgBsM/l8wTsfxpDUlJQAYPMlgUG7S8XOSz+MuJexEnxPnwf4BW8Z7cptITgVGemmWp/abDSEaRFuZ9Nkawey6KyQqNk4IeskncKn6+Ts+h2hSIDr9W37w+cZYQh1I7KEZVb939rq75X2ZoqEP9mzqP/qnMTQVMr0LpM3SHUVm/dsrK/Lghl86F4re9zz2M7nXqRdgwEUD4YStR0g+s4246xQcJdHQadqBq6z8KUsUWAAH9TTB7bAuIv2UTQls8X13nu4cqqMBx/67S3WwxtRrVhjuCQ4VA366NWZJTfDle5TU4ul0CutVShmY2wQ3CSANCuyXxeuc2N/A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(136003)(39850400004)(346002)(451199021)(66446008)(66556008)(6916009)(64756008)(66476007)(66946007)(54906003)(38070700005)(76116006)(4326008)(316002)(478600001)(33656002)(86362001)(53546011)(9686003)(186003)(6506007)(26005)(52536014)(8936002)(7696005)(2906002)(8676002)(41300700001)(83380400001)(44832011)(71200400001)(55016003)(122000001)(5660300002)(38100700002)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0QTlXRz+uoLldHHJnJxrcoqwdm9pwytvqYSK0FRVlee00iTJxmoNZf3uAqh9?=
 =?us-ascii?Q?nmu3dyWotxzN+Gd4TPIBRQxRzst+pwPA8ylCBp0TbYitn6O0TEYbw69I5g3f?=
 =?us-ascii?Q?vKmMg5AQowGDUrHkulDogX6HM1886Xu5i7g9yAQISMgCYMfDmwSqm6Vt8jqO?=
 =?us-ascii?Q?PkyWWUI3I25Q5KM0dlCC21m8MFu6iHTYsDq24YtAL1xKuUKX38rTGYL8ZmmA?=
 =?us-ascii?Q?Az5UnqJpoRzfI6ODt0ojf3WyVz7GKEbrHs2HRw98oyT3UXI4YHBTu/qLRX1h?=
 =?us-ascii?Q?MvLo7TbUknmpXwdg4B3aa7TABWFnW9XXem7eGxiwvfYZ9yzX/DUkdr0k6/9j?=
 =?us-ascii?Q?5vMLQ/guRE8X/1YpVxyLqUKvBwIluT4XfiHrGqD9NWLTI17B9RHSGu8dY3X4?=
 =?us-ascii?Q?Q5/kudAyFVZ4qv2R+h6yYU6+vzx6ObEy5Aj0FiV9Wq04kNAZFjF5iVF5tb5Y?=
 =?us-ascii?Q?40l7nt4Jy7voE91Jz5u7RTguHJMZGUw2BlPrNM4fkpSepc3nUrXtdyh3YQLz?=
 =?us-ascii?Q?Pk3sCHcD/r47XMBxHBAucY1nWaU2XDkfp69XllMxd6h6mbv5oOZ+rvVXeUMs?=
 =?us-ascii?Q?5E4NywXTWjvjo8HgxbyupDVQt+ntrPd2DQfUvsJcXRpA9WBV6E1+CObfUAab?=
 =?us-ascii?Q?dTFcNtvZBbTmeh0ixZ362ziKaIzrsapsksuVg6EBTJlYqJncdvkFmVtnxJP1?=
 =?us-ascii?Q?Q3auHEgnTzM+DbleC7wjU8p9b9NP8pl0wkXyEc2bI18zmfQkWXmnCwz9edsa?=
 =?us-ascii?Q?CecgXp7bjI0ZvyVYX6Zbqbs9ZDFanG2pQeGqJpgWAMkLuXeaaZHCTGDcz2sv?=
 =?us-ascii?Q?n1YOBJWs9yezHiPVlUY9XJWEjIe6HpQfxvQme7IMUoncMWAFKsHmh8gHGjS5?=
 =?us-ascii?Q?ytQXafT1vywOQgEzCobdKzm7xKbgGLZ2L1Ek6hMX3YlEYfn82bFFw05/JqhX?=
 =?us-ascii?Q?MFcWDVd0y5E+0RWXkiSIJP3NB5bQ8iEEB06Eth5jMytxAnSF4eHpS3mb/iko?=
 =?us-ascii?Q?3YugqZRo/YYcE3zcKPya/k3DSO8mxG41wuqQKwoFCiIytgXUaizON9499S/b?=
 =?us-ascii?Q?vVMbvFjb8vsE2fNB/P+WKIglZiplKyZ3XzceejImEj7WsGbWDZlIbGMyTAHM?=
 =?us-ascii?Q?yty/mg/qVfBIdn3FV28it15xH3Lt2oI3glXO/k9Nem8dWz6b1F/lV85hbiq7?=
 =?us-ascii?Q?v18t0NQE66d+r4gMjrMsUCZjU3yRU6mI1fifjlrBEDz74p1KUpk4JyxJXg2S?=
 =?us-ascii?Q?j1YfeNaF1unODQ8vYkb5rI3e4hOmYUIQK43TXV1igz4ND+f5O2fKMNDk4TwE?=
 =?us-ascii?Q?ZSL6JRsLqLhWH9OQVO4M+2KVuN8KVPuoX8v0G0aWBbNk08LgAuaSBcT7LM68?=
 =?us-ascii?Q?PcEMcdwy368LcRpoOaKv3bbs7Hfe0o/Ile8fFtDoP50jlvfEEs1Sn7MTON7G?=
 =?us-ascii?Q?E76XY4zeaRJEngz+Waph+xbRi/qKpJRobymDYAUMOEa1AKNI9L18ZCELKTuS?=
 =?us-ascii?Q?t/kpHDfKTwKfBzPB/VBu7MPNmOT9OARsW5EznEbx18qQx3lP+961ZyEyMm9m?=
 =?us-ascii?Q?dEY0OB+tVEiviT7SXfGFHZxTPdPmVMppPK1OH5Qo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354d9ad5-e6cd-40ee-42c5-08db61fe82b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 17:43:14.5015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RvnalAPSGdVQ4xTNiOvhvpT+YkwE0vqECRLnEyZvQethUT3q9NxrSvzB3D/o77Bd5SR3e6jvG8o+oc4Mq4ajtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR14MB6455
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fixed typo and resubmitted as v4 patch.
Michal

-----Original Message-----
From: Simon Horman <simon.horman@corigine.com>=20
Sent: Wednesday, May 31, 2023 9:39 AM
To: Michal Smulski <msmulski2@gmail.com>
Cc: andrew@lunn.ch; f.fainelli@gmail.com; olteanv@gmail.com; netdev@vger.ke=
rnel.org; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v3] net: dsa: mv88e6xxx: implement USXGMII mod=
e for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Tue, May 30, 2023 at 10:50:10PM -0700, Michal Smulski wrote:
> Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.
>
> Signed-off-by: Michal Smulski <michal.smulski@ooma.com>

> @@ -984,6 +985,64 @@ static int mv88e6393x_serdes_pcs_get_state_10g(struc=
t mv88e6xxx_chip *chip,
>                       state->speed =3D SPEED_10000;
>               state->duplex =3D DUPLEX_FULL;
>       }
> +     return 0;
> +}
> +
> +/* USXGMII registers for Marvell switch 88e639x are undocumented and thi=
s function is based
> + * on some educated guesses. There does not seem to bit status bit relat=
ed to
> + * autonegotion complete or flow control.

Hi Michal,

: checkpatch --codespell suggests s/autonegotion/autonegotiation/


