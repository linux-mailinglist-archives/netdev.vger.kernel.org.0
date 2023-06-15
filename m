Return-Path: <netdev+bounces-11150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8A5731BFD
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C56C1C20EB4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3139412B94;
	Thu, 15 Jun 2023 14:58:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A438BA3A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:58:52 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2066.outbound.protection.outlook.com [40.107.6.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB2D2977;
	Thu, 15 Jun 2023 07:58:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtKWb/OqE9Gaihh0QxYW6Pm55UHa0GK2nSO5HiDnZ8kwVaaST62jGq4vtlCKYf9c2YDjn4G/c+7zrgbqHfgJ917c7gWKnlB1/Dqw5XFl3rHPJa4cXcJrhgI5GhT6RmqQadLUYUf2+7aZO5oSZylIpPxVGBF7bGWjzGH5cUivaagbBd2voVZNCTtQvCMJIUsCZro9efwLarwkYXP9VNMenyku2BknkH20CZaXV1KOBrfaMDUAFyV9wyRLYnMaPzGwdBIGwK2SjyiDbQwx5BXjafze8O0lTrdjXCI2sRl3nJIYwWXEYdT45fs35bvWdkgX3JcFihgfOvTjoRA5Cy7jSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDgjbThfJBMSxAyfE/CSE3PGNboLiqu7wycWewt2L7M=;
 b=hYGseZ49YL8jZeLwparnxE4b0bAHVzXKKaW+hYau3DXhSlkdabL5Kgz/tPlvKWB9bYnXnnBas+gU94vbE2NreGKGk/NOeolSADGA6V1PCNn5Q/gYqLN1S1FRWc1BO2Ggud54t+fMSqpCs+CiRRU5Gp3h9k60iJY4HNqFEXt7arCgDyJ0dtKBkjw/nPmwL8x5LKagptXyyFoCS56EbVNCw2KIj1YsriCmu1+EkVP8ZBGb1cbK5kxOXXpTCRE+9Z1v8LGiJ3xm6tcmsfxodMDiR3H1dfoXbH1O3PM/TQBjjerMrQOA9IbFcCJfhntQhaiEjbe/bXZ3RWD3ml9RHYfmwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDgjbThfJBMSxAyfE/CSE3PGNboLiqu7wycWewt2L7M=;
 b=nlpXGd10VUMLytE4+JGNQVe0ETwUp2qcUydSP8vxBrfjNH4qp/Lf68fuEg6tJz0cYiWLikEC1PCuzSj1Af7GyUUtq9edHiRw5pJJ0b2Ws8yAyyrMGM973OJKxmwP/CY7IY76Phv9rk3K2KJRdoiwVlC6NGqY34sMbNxXvKTTTs8=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by PR3PR08MB5673.eurprd08.prod.outlook.com (2603:10a6:102:86::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 14:58:43 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::33c5:57a:c902:b183]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::33c5:57a:c902:b183%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 14:58:43 +0000
From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To: Simon Horman <simon.horman@corigine.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: macsec SCI assignment for ES = 0
Thread-Topic: [PATCH] net: macsec SCI assignment for ES = 0
Thread-Index: AQHZn3pkm6H56ZX+ME2107dtXGZZoq+L6xOAgAAJngY=
Date: Thu, 15 Jun 2023 14:58:43 +0000
Message-ID:
 <AM9PR08MB6788838DBB214D50AF7F7F5CDB5BA@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <20230615111315.6072-1-carlos.fernandez@technica-engineering.de>
 <ZIse+5VepvY5dXN0@corigine.com>
In-Reply-To: <ZIse+5VepvY5dXN0@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR08MB6788:EE_|PR3PR08MB5673:EE_
x-ms-office365-filtering-correlation-id: 0a58857c-8a68-4e77-35c9-08db6db10337
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ZOsf0J8SDSq4zoRQBnV40rXtX12+HrXlGQ9mQc2KnKndMQfUkl6KRyXe/iCVkiiLxUgVGo3eeqrJKhwVtMrPTiaY1cosoxlH1iHc9JI+nXRmZadYBoh/uz/Fyv8/0nBerROZWV9wCQtS7M6FS/3Jjs+Do2UKrUGsc1CUfsSWost+k7DvwyWTSH9FKGCWhlB0IMdHrz/YMaEKKFzQyr2qO35p2IqZm4ZO/ogsPInNoIaO6vwuMftt/rt/D2PPgOb91beUFi76BKmT0hn3/bVnolutrNzsKujlFa0Uat5beTk8jU5FuJI+hN2x/vCqdLBhP9lBdXR5llbgg1mwRyA2IdkYEAqimPRWlIZT3KgVCQN/ZcyTsHLTIoz0HcC/PPM83BL38hxCoJqquyeyyh96s1uFsQWb+UPSxg4UJ+f6s+19NUfKfOs4R3KpELodG7ixXcQvPJ9ozVpZ8M4PvfjTQiAJMrsXEus1dDlQuxMv6luOy/2d73kIMUmCAhNJVsHI53OW6pHCUVE+O2w9ZeoZE/S1rRYGCBPRvLeLgONwtJ9Lj8iKyFK0WDVqkIZr9uFq4v6XRjRpaWtuhhfB+oNElAt6iXYCGlGoDTffULm2I/KI5BpoLU/WhYyd/I+Eifet
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(39850400004)(396003)(366004)(346002)(451199021)(9686003)(6506007)(478600001)(26005)(53546011)(186003)(71200400001)(55016003)(7696005)(2906002)(8936002)(316002)(33656002)(41300700001)(8676002)(44832011)(38070700005)(86362001)(122000001)(52536014)(5660300002)(38100700002)(54906003)(83380400001)(4326008)(64756008)(66946007)(66446008)(6916009)(66556008)(66476007)(76116006)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GyPFEceCRBbIV0lP/0xAuLjzeXYV0SGbeinKGhYmVEP2mchKy8o8WFvhSBHl?=
 =?us-ascii?Q?Sy7PEE6zy9kYYaQicfCs6GKCyDOnriw5a9pBtL5Fo6sX8/9+bh8fLX7MBLzw?=
 =?us-ascii?Q?wBWa/qDqG4zfD1zr0mZxeINTnOkzHxSANSsr8R0gTZGbERKkBd2Dyv9Zw6Rq?=
 =?us-ascii?Q?oB5BDLooKEm4Fh5cxfTTe8E/7CiqcMM/piDJEyY4zpH3gvVUAKYOrfUA3/iH?=
 =?us-ascii?Q?/HFZI19QBkFhYTbxJwLo7AozCPYkGKYu4usIvVnjC622XTuLETO4gwCq7oJi?=
 =?us-ascii?Q?J5mpvgn4Bf0NC+T+OgAnTsZ8MOKINSsxCYjdWBIk9laBJVvNLzmeviBX4Tqw?=
 =?us-ascii?Q?qcNE5vYQYXEY9359E0bgNzQrd80Ze4YrxDIFL23QDTS1cf99MQB+KQI8+9Nh?=
 =?us-ascii?Q?CDHb6in4hyi/qHQKw8HnZCu3lqFi3eSdWnfCEFGksvKhGW63hhUOgJmjQprN?=
 =?us-ascii?Q?mLw+wjv78bLQfT+RRjeJjPz5G472ydc2J61PZerh2nXiW/xyySUvMuMYACYa?=
 =?us-ascii?Q?epPDYhM2m9L/VKawy9gC0DzAjeeJD5S21pvvBkQSmvNXcZsbieW98KnscYRf?=
 =?us-ascii?Q?IWg2VhfZNaRWt6QXu+ns439m+E8T43FRtRPTl4AOfjV3Vglud0G5S2RgTTtw?=
 =?us-ascii?Q?K0PFkZVRVzlMlec3dD38x1gPA3WIIdeI4jyJCGIBC4WHFdiucPVDvSUyZQoP?=
 =?us-ascii?Q?Ohd4wjiALos2xGBxLZFMcDP4NpQlAo8A2u2TSEYqj1q76WBKuhGkMYD3d4tA?=
 =?us-ascii?Q?BPREdXa894J4Vxeh505n6yGB+D3IEVs8DVps0piRPRtWZeF0bi57R0Oitbtj?=
 =?us-ascii?Q?IMjMunc4r6iDOj5u0/57TCwxuniAALcS5HnzMKFI6wI0mpRQ803rlbzxtqvq?=
 =?us-ascii?Q?aFyYU+7FWgxBNAIy1RXHHHuAK52WWPkzVqlnePpxvr7I1FlSq09PZhCN4fKJ?=
 =?us-ascii?Q?yVn18/FVyJ0BgBu4yY+FD5vsv+CQzXq44yYmhW5BIW3MlHJn4xg1A0tx9Bd7?=
 =?us-ascii?Q?ys73AiN+faGazohCjZBLag0Rql1Tj4Ym3PquRAIoR1cXaDq0jUJWDXfFou8O?=
 =?us-ascii?Q?cwG1BVdoZBE+Sf9FLxcRHvB20o+bCUlABo5X6OKEhSfQsx+p7tNL/KhGa0i3?=
 =?us-ascii?Q?4dR0B2l7SkuJFASSgXgzHYC7QskMujwfbQ1fK/DlAiamuV6rTTA3Qxx4jxrj?=
 =?us-ascii?Q?clJfSrazfi4hDlKkmD1DcM2FqrUlaeCK7QQd7d2R4JauuK+XN5amzgY66j4y?=
 =?us-ascii?Q?lOQ516/WwuB5++rO1+7b4NUu/BbIDWQhyGI08ou4eBIdy/4lTlorBQZcpY6o?=
 =?us-ascii?Q?dUK4mf0kxBt0y62PJVDejjofiPERt+GpNiMx+HUkGFyx2gL1Elb9xBSWYmLp?=
 =?us-ascii?Q?c6gRhJPf9YzJLMeC1iCgW9Bse+rmQz7sdt1etd2usOYJr6uMQqJP/EX033t3?=
 =?us-ascii?Q?65CsAmZU+P/9WxeOekR/vqL/WDAxCSTg3T60peVhPdIoXzmfWMsjDxupJkC+?=
 =?us-ascii?Q?ktUY+5QXvjYPGInj7ZjPCGaqGqNkEviXueYLBQaqSp4NyndugqQQwugGOiz2?=
 =?us-ascii?Q?6lsb29UT/84ShF3WEBhI07veoEbLnu8ecbtLpyN1opKherfr4rlAwit61gS1?=
 =?us-ascii?Q?vcR3UFl5jHrLGFmyGQOOzVg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a58857c-8a68-4e77-35c9-08db6db10337
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 14:58:43.3307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aQKe4Dq1ZD9C9KR9hJzQCmDD/TtoNbKiHAEWP1iR/njCuEcSNAQKE4pwtXeSFbrC1AFDLkCcoI6r4nPUYniesOjLKdZ9F5DJku7BA5EXo8Xs0r+paYXjAMubYlebtFqHVS8/CgnlUpr5vqTDSdaXCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5673
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

Sure, I'll send the patch again as version 2. Thanks.

________________________________________
From: Simon Horman <simon.horman@corigine.com>
Sent: Thursday, June 15, 2023 4:23 PM
To: Carlos Fernandez
Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redha=
t.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macsec SCI assignment for ES =3D 0

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.

On Thu, Jun 15, 2023 at 01:13:15PM +0200, carlos.fernandez@technica-enginee=
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

Hi Carlos,

some feedback from my side.

> ---
>  drivers/net/macsec.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 3427993f94f7..ea9b15d555f4 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -256,16 +256,32 @@ static sci_t make_sci(const u8 *addr, __be16 port)
>       return sci;
>  }
>
> -static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_pr=
esent)
> +static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_pr=
esent,
> +             struct macsec_rxh_data *rxd)

The indentation of the line above should be such that it aligns with the
inside of the parentheses on the previous line.

static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_prese=
nt,
                              struct macsec_rxh_data *rxd)

>  {
> +     struct macsec_dev *macsec_device;
>       sci_t sci;
> -
> +     /* SC =3D 1*/
>       if (sci_present)
>               memcpy(&sci, hdr->secure_channel_id,
> -                    sizeof(hdr->secure_channel_id));
> -     else
> +                             sizeof(hdr->secure_channel_id));
> +     /* SC =3D 0; ES =3D 0*/
> +     else if (0 =3D=3D (hdr->tci_an & (MACSEC_TCI_ES | MACSEC_TCI_SC))) =
{
> +             list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) =
{
> +                     struct macsec_rx_sc *rx_sc;
> +                     struct macsec_secy *secy =3D &macsec_device->secy;

For new networking code, please use reverse xmas tree order - longest line
to shortest - for local variable declarations.

                        struct macsec_secy *secy =3D &macsec_device->secy;
                        struct macsec_rx_sc *rx_sc;

> +
> +                     for_each_rxsc(secy, rx_sc) {
> +                             rx_sc =3D rx_sc ? macsec_rxsc_get(rx_sc) : =
NULL;
> +                             if (rx_sc && rx_sc->active) {
> +                                     sci =3D rx_sc->sci;
> +                                     return sci;
> +                             }

I wonder if this can be more succinctly written as:

                                if (rx_sc && rx_sc->active)
                                        return rx_sc->sci;

> +                     }
> +             }
> +     } else {
>               sci =3D make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
> -
> +     }
>       return sci;
>  }

clang-16 complains, as I understand things, that if
the else if condition is met above, but sci is not returned from
within it, then sci is uninitialised here.

Perhaps that cannot happen.
But perhaps it would be better guard against it somehow?

 drivers/net/macsec.c:270:3: warning: variable 'sci' is used uninitialized =
whenever 'for' loop exits because its condition is false [-Wsometimes-unini=
tialized]
                 list_for_each_entry_rcu(macsec_device, &rxd->secys, secys)=
 {
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ./include/linux/rculist.h:392:3: note: expanded from macro 'list_for_each_=
entry_rcu'
                 &pos->member !=3D (head);                                 =
\
                 ^~~~~~~~~~~~~~~~~~~~~~
 drivers/net/macsec.c:285:9: note: uninitialized use occurs here
         return sci;
                ^~~
 drivers/net/macsec.c:270:3: note: remove the condition if it is always tru=
e
                 list_for_each_entry_rcu(macsec_device, &rxd->secys, secys)=
 {
                 ^
 ./include/linux/rculist.h:392:3: note: expanded from macro 'list_for_each_=
entry_rcu'
                 &pos->member !=3D (head);                                 =
\
                 ^
 drivers/net/macsec.c:263:11: note: initialize the variable 'sci' to silenc=
e this warning
         sci_t sci;
                  ^
                   =3D 0

...

