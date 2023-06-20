Return-Path: <netdev+bounces-12137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A33AB73663C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15C5B2811BC
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A9C8465;
	Tue, 20 Jun 2023 08:32:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942915225
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:32:24 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2054.outbound.protection.outlook.com [40.107.15.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03923132;
	Tue, 20 Jun 2023 01:32:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lb0OWQahDflR5rg8HieTdSD5rFl1PKgR56D4Bc75xRKUP8560KXFUawf39TulwWETpnMhCJTPU7+PplE/y61Xqby+kpWTwyANvxrgKfvcVdgTQ5V+V9BweOZKc88wOrrcs2iisvMQP1ySg7pxE8YU2MuYMn4d5mrULrJIpk16XhzPo5ltsdpeAkEYd24JfRFiPJcrUbMMA0EyVg890nYMPB71M9EoQ+OkdGee3euijY8GDhRxGwDUw+AQD6NQlOWiTtlOCew5LLDif8x2L2DqSxwHA/v2MIZjkV0H5/J3KJdfNzibhH1iPj0LkNzV7Jgo9Br35OL3ZRKkuf2jfoz0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1Wo+lvxybOtumGQbluMlQvAO/wSs2UXtIGUoPng2DY=;
 b=E9iZa9564WTWn0G4JilgvzWXdf1Pg6heCwe1VybJN4zo3jz5l20eMhMkeCbKrRMm2MObA/FP5rfYCxfiH9s9kbKReppHNdKJWVztS784DIWPzMTIZUd8ZIoGd3vSNZVeRb/tro4kbsymI0JGGsXcrFTaSR2rkkREe6gRhJTypyfXRRSTq8RWwYc+qrH5yl8bvr3N/k02ZbEcnIJzLak2ZD/NWyChhWYDJiJenI1jNjMP4yWCusHi1FLDsvGKuuJPjoMZY2nBGYtBlKUmkUm3cX3X8BT3vtktwgURszaXvFXYCrBrdDyyI9KMHg6FOPSjKdn6ej4Hn/SF6RGIujs9UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1Wo+lvxybOtumGQbluMlQvAO/wSs2UXtIGUoPng2DY=;
 b=E7ioLkm/4jQbEPt8Z1mVZAjOqlYsywzSUIZes9OEq3aXOVwaevH6CoNmj30w9NjDC2N3BcHiycfrwxZqubLkWMllYQX9ACwaWD6Iu6FIvlTkNZSQaXMPnY2kLpB6xq/GjKwuD0tzO9wV5Yg6ZoskKaK6/F6YWOfFuNUwzu/hT00=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by DB9PR08MB7559.eurprd08.prod.outlook.com (2603:10a6:10:306::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 08:32:15 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::33c5:57a:c902:b183]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::33c5:57a:c902:b183%4]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 08:32:14 +0000
From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To: Simon Horman <simon.horman@corigine.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: macsec SCI assignment for ES = 0
Thread-Topic: [PATCH v2] net: macsec SCI assignment for ES = 0
Thread-Index: AQHZoDRNK1j/M5MqO026ySyclQ4njq+SKM6AgAE5zRM=
Date: Tue, 20 Jun 2023 08:32:14 +0000
Message-ID:
 <AM9PR08MB6788C986181CC0A0C727AC3FDB5CA@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <20230616092404.12644-1-carlos.fernandez@technica-engineering.de>
 <ZJBceYIkbZHnOSF3@corigine.com>
In-Reply-To: <ZJBceYIkbZHnOSF3@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR08MB6788:EE_|DB9PR08MB7559:EE_
x-ms-office365-filtering-correlation-id: ae5e0a33-57b0-48f7-87e3-08db7168d9c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 HmqmtcmPTeM/oQiCZO3G4BnjKo9hkGe2/A9JnyXgtqsUl1Y0ve5HOEY1ixTXmK3FR9XpYny8EGKwxdF85lfKSZvWHfqgQERZneAlLEk0uADe9KEta7DWidDltbaqCbSq8gnnJHyhAK74Cf5QUKuSSQI2/npboJzYBPLXxnkOzCnQuEHTMNIg8VH5WZimBFd0ZYTbZmWthUc1AjtcOGOefQFnwVcbl49HBpI3SxH2QtEO+s+NkHHEFUvzjf3kZreEF+8IdBVRJ274ghUSq37hyCvFBn2X5/hJY1pQrONLA5kl/uu8I6P+xnkhDJ/vv46m4xPXzBwNkcQarBjc5hctfINggoFJQsT81aKNT7XOkmISOFEWv7jbZa1j18ywHobU03HOzL4s5h7GvPHbm4B1yYd7NqKWutpl23XW8T1WCnBzgHhEWQM82+ExSSTYaintoq+t0yM+rEBa/r51U+lAw8x13HPK3EbUpr5ipIKQn35gj/8mR+uA+BkmmNpIWI4T09wBab3EcMPMc/o5Arms7PtHixOsGJv+eo5gyTrJmOZH15LeDdjRg+0pYtqdI9oh+5q5wYqk/NEKPN1iFy8ucug8O79Hx3D6HdZpGvoIJPPoSCMximSAfGZtU0gZj/cH
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(376002)(39850400004)(451199021)(86362001)(55016003)(33656002)(122000001)(38100700002)(38070700005)(478600001)(71200400001)(7696005)(54906003)(8936002)(8676002)(44832011)(52536014)(316002)(5660300002)(66476007)(66446008)(64756008)(66556008)(6916009)(4326008)(76116006)(91956017)(66946007)(41300700001)(2906002)(26005)(9686003)(6506007)(53546011)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?O15LY/E05JfPqfYVu2pZTS+6WaU8RXPbE7ohB6LTnKGbIWm9VFZ6B6nqp6yo?=
 =?us-ascii?Q?5kazXMblJQtXBSDXhMaA5DC05DhHN1u7+1EGBPnCJaPBBPMm9rtPbHV3iKqH?=
 =?us-ascii?Q?Dd1KHJDOSjBXfoQheoJUlX0nihLqfNigYqZdT0rDY6e7K0VLyG6nx5shmmFH?=
 =?us-ascii?Q?On+Ob7G8q/LRag62zzdjZWL7fUIrNWrQrt5fwSw/8+tCEvlXc8BwXvJLXGkz?=
 =?us-ascii?Q?TUopV1FQ7nzTWEp55oE1oV0R7UELzIeY1vUvW9DeQkSj69KIjL6Ro1zb4HLP?=
 =?us-ascii?Q?LG/hEDEKPWf6nkhCVl5ICASMEvJGWtydGa9h9Rzk2X2/Gu5u89dYS/RQfd00?=
 =?us-ascii?Q?a6U3LlzwpJUvj9YiS2PkX60979S12qDi/LGJnMcPdtiuJXrtj6qT/BHEzp5U?=
 =?us-ascii?Q?eTXdOZFcRuit7FOaQvOtfi/uPDY79DLsD5nazJNRnHffykp03xxjTPzReIXn?=
 =?us-ascii?Q?MtWhR3LBCGVJz5yjbii5TAC5g11+1cmTd8RRFqHpZT+MfFqKueE3LpWOysGE?=
 =?us-ascii?Q?SrbdCJnOhqRJ+28Rg6b0F5cV4d0B7ACOL0qSIAC6VR20I7MtjcOzegqP6ygX?=
 =?us-ascii?Q?U2e5BT9+KCngdQwuX02E0C3ATrfbabXH0JcnwhT0l7hLymd2+qTHW2AvREHF?=
 =?us-ascii?Q?H7ay66lTxID8Lx+AhJivoPrk8bhergibfJn52h1I9dlLW1VJ13M8rC8u3g2u?=
 =?us-ascii?Q?dnRXL9BYzMczRRCqXjvmDi46lKTq6LmWMT5tkvGigZApeI7qEW12ck3f3ykO?=
 =?us-ascii?Q?iQj8YKSahvowDbm/vLQkV3eWy2Pm2MVlybixUHClFdM5gQTyz1UJULBH/0D2?=
 =?us-ascii?Q?Lk7sPFx9qImSvZPQt/ZD+gTCcLqnXSDDT/afsvibdy5J2gC1jAOwleNvVUwl?=
 =?us-ascii?Q?ZkrmNPZBxHnejoEijw8/bkzMhVAcxDUS8ism7MdASd8vRFYuSe/lmbj/U78K?=
 =?us-ascii?Q?Rgwzh4A8OiiEtB13RT1N5ZVVD2CC0fnfQKm5zA0lpL6QWNUNSO/1Hsb3pOvi?=
 =?us-ascii?Q?ulUlPbHW6ZZq8YAB/7b2oMGxl64V7bszIf4LfA5L/HRsYsGVmiDTrDOjbHXG?=
 =?us-ascii?Q?roRDjoBeBo2kaXEoJu73b5wghprY+4C5TsErZj1/Vhh1JiATl4jSfrixaF4v?=
 =?us-ascii?Q?dgMA9C755Mc2EWhKxhxqkQfBGPQ17MTZtqk98wBea3GRAD4DHa2pFHYlo5XL?=
 =?us-ascii?Q?4ca4GwmA8PlTagkrxu/AQKvVyDwJfL+/bKQx84s/PgQK2vIf1csUJdkZdQXe?=
 =?us-ascii?Q?WdzoSeGIYtCnptF4UZYmqLgSdiBKzdHmjQGi3Ts+VuH2TzvVO2w+G8WO4Q1c?=
 =?us-ascii?Q?oaSMVjiF0Z6krzUzFFkys0WkZJF/mJi9yiA063mbyzafAN0zA0yZxklPR9dM?=
 =?us-ascii?Q?u2X23ye6ZUQep3qAPIgLlaM/Wlf0juaF2wMqgIelLIyiwPjrrN04PnW0ChV3?=
 =?us-ascii?Q?uEEeFNco5NQ6twlx+fx7tO03tYDAQoZper9GKTQeTDE8ASybTsJYGRScTeQV?=
 =?us-ascii?Q?ycvH65RSzubFsiF3zbM5tJpjED2J25wrjJGBG+ixCey7TPEePCht8FKap6IN?=
 =?us-ascii?Q?+FTWDVE+BVk9T6mt1hYZsVNqPw4ukh4iYa4P9n9ZYsKYDnsIvcoUs9yClUHI?=
 =?us-ascii?Q?A+lWAm1WZ0nmmPilTGvvXEA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6788.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5e0a33-57b0-48f7-87e3-08db7168d9c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 08:32:14.6345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8y1XMmRnTf28RYCWWGozQY4HhW4itGyRuhsAhuwEEDbNoWkPBlkXtr539x9eBnWKRJHylyPNFLT13mM7FBUM+hZbyLUsT0zIGQdfUXVN3nc6MXf0LTB+/5QPQZ2RTU1pgKotGTbcZOfx5Zg+D5rww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7559
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,
Sorry I misplaced the default sci initialization. I'll send it again.

Thanks,

________________________________________
From: Simon Horman <simon.horman@corigine.com>
Sent: Monday, June 19, 2023 3:47 PM
To: Carlos Fernandez
Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redha=
t.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: macsec SCI assignment for ES =3D 0

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.

On Fri, Jun 16, 2023 at 11:24:04AM +0200, carlos.fernandez@technica-enginee=
ring.de wrote:
> From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
>
> According to 802.1AE standard, when ES and SC flags in TCI are zero, used
> SCI should be the current active SC_RX. Current kernel does not implement
> it and uses the header MAC address.
>
> Without this patch, when ES =3D 0 (using a bridge or switch), header MAC
> will not fit the SCI and MACSec frames will be discarted.
>
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de=
>
> ---
>  drivers/net/macsec.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 3427993f94f7..ccecb7eb385c 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -256,16 +256,31 @@ static sci_t make_sci(const u8 *addr, __be16 port)
>       return sci;
>  }
>
> -static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_pr=
esent)
> +static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_pr=
esent,
> +             struct macsec_rxh_data *rxd)
>  {
> +     struct macsec_dev *macsec_device;
>       sci_t sci;
>
> -     if (sci_present)
> +     if (sci_present) {
>               memcpy(&sci, hdr->secure_channel_id,
> -                    sizeof(hdr->secure_channel_id));
> -     else
> +                     sizeof(hdr->secure_channel_id));
> +     } else if (0 =3D=3D (hdr->tci_an & (MACSEC_TCI_ES | MACSEC_TCI_SC))=
) {
> +             list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) =
{
> +                     struct macsec_rx_sc *rx_sc;
> +                     struct macsec_secy *secy =3D &macsec_device->secy;
> +
> +                     for_each_rxsc(secy, rx_sc) {
> +                             rx_sc =3D rx_sc ? macsec_rxsc_get(rx_sc) : =
NULL;
> +                             if (rx_sc && rx_sc->active)
> +                                     return rx_sc->sci;
> +                     }
> +                     /* If not found, use MAC in hdr as default*/
> +                     sci =3D make_sci(hdr->eth.h_source, MACSEC_PORT_ES)=
;

Hi Carlos,

sorry for the slow response.
And also for asking about this same topic a second time.

Does the list_for_each_entry_rcu() loop always iterate at least once,
if the else if condition is met?

If not, sci may be uninitialised when returned at the end of this function.

As reported by Smatch:

 .../macsec.c:284 macsec_frame_sci() error: uninitialized symbol 'sci'.

> +             }
> +     } else {
>               sci =3D make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
> -
> +     }
>       return sci;
>  }
>
> @@ -1150,11 +1165,12 @@ static rx_handler_result_t macsec_handle_frame(st=
ruct sk_buff **pskb)
>
>       macsec_skb_cb(skb)->has_sci =3D !!(hdr->tci_an & MACSEC_TCI_SC);
>       macsec_skb_cb(skb)->assoc_num =3D hdr->tci_an & MACSEC_AN_MASK;
> -     sci =3D macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci);
>
>       rcu_read_lock();
>       rxd =3D macsec_data_rcu(skb->dev);
>
> +     sci =3D macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci, rxd);
> +
>       list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
>               struct macsec_rx_sc *sc =3D find_rx_sc(&macsec->secy, sci);
>
> --
> 2.34.1
>
>

