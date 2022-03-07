Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E104CF2B8
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 08:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbiCGHjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 02:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbiCGHjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 02:39:31 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1AE5FAF
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 23:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646638716; x=1678174716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LnCZ38klGkJsKsyfKIP+qVSdhFheSD8Ovj2gj1+vv3M=;
  b=iGAWNilnlzW93Q7RDSJEGHC7raKyFYJZKS8jXRyYmw7/A/WEZSleQD6R
   yPgQPpTLr/bdjl+mBOSbDPmdJLnp4leFr8+3HGAmUx7imshJ5WWEfFWOS
   gPbbTreeIBGbcvXq9636J5StYEfobvEOZNkddUlerQCs34TrlIQ2QrlUn
   ZD3TG+2GaYZGKBDzrL9Y8T5dDBL59fxkhYe0iVwX/pPbmYpLtpi223YV9
   0xaWYRoJzfc8X4KX/bUCa2tb4mvMD3b6UxPFDi1SlGsV9wyjxwryawW3s
   c7a3uWozN7bT4fq5UTWEzstYm8fL1JpTcoqoW2xjJv0DgNSBO3ui1G2I6
   g==;
X-IronPort-AV: E=Sophos;i="5.90,161,1643698800"; 
   d="scan'208";a="151064339"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2022 00:38:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Mar 2022 00:38:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 7 Mar 2022 00:38:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaTCAUQthvjKCckoRyKfCOeNn5v+Zg8rKwKSOX1C9xdQAxWcvOxEhTZd2Msuby7x5S4iI9FLbRQqx0/eRfHrH+LbEXc1tFAVA75LwHHjrQQq8tF8xEtcrgBIn46Q3y4KP1YVXT0yF4pVbfawXhavmp4FuwupK1+FZ092ulKuo7CSZbd3kOFOcGAQ790bbPy9DQHjik4YP7onJ4OblGXcg16h68pc9ViNrjkve/WcyK3h2w4OjA/IF5FZiC/pI7v013jPnPqwVY5e0+3Z2/DOxr2pmFeLjjmvKbLBQ4dgLe2+uFTU89X6tEP6qfFd96En8zKp0l6e987EfeiuH9odAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWYDKZ1MlBxiPnqfNaBCNtBkhiF89dAq8ZiwEGX2T3M=;
 b=lYqLYsUs41UEcneR/eMhSNf1FV0F+P3LCqp1r2adOLS3ukVm+PxZL3Q0Egf9YikzJwR1xnE8F4eWvaBPuvbMnzBLAqmWjQym1Jy5gl7Q75WxtGbYad2NNkdXHBw35+EvIDCQ7UOFW1elNohQ/Znam/XKlv3gL8Z8lzu5/fM/IBLxl4JUYXeAzsCNUY5Fr44t+Kfm6V/mgVwDtXdsvyDwjSOES47t1H3HgEu6WyXYVtXTbNJfOrC1WDNhYGt2gGRQBT69727+XUoDed/cdR4k0Q85kYWdkhgoWG56KFQFMTOqHU3YkJCMcmXAZoHlnuwuM5vXcoYGaXYmGMXhwsku4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWYDKZ1MlBxiPnqfNaBCNtBkhiF89dAq8ZiwEGX2T3M=;
 b=kqNeOGos/AaTX2JrqhcKvjnqZKXtVCgP04x1BT+/POQJBS36fH9ve6K1PXtJ36yz3pA0qCGozyD3jqsl48FW2aiYx3EcgMOamZOW6QQyNiq7/aD+aQJsN46EkB5qzUd0k4Q3VVnfDIv2ui4nE+hFCog+j9N0FstFurWI2WcLU0Y=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BN7PR11MB2564.namprd11.prod.outlook.com (2603:10b6:406:b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 07:38:26 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 07:38:26 +0000
From:   <Divya.Koppera@microchip.com>
To:     <kurt@linutronix.de>, <richardcochran@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <yhs@fb.com>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <Horatiu.Vultur@microchip.com>, <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] micrel: Use generic ptp_msg_is_sync()
 function
Thread-Topic: [PATCH net-next 3/3] micrel: Use generic ptp_msg_is_sync()
 function
Thread-Index: AQHYMINA5beFWyq/SE2/w0B+XnneFayzh9Tg
Date:   Mon, 7 Mar 2022 07:38:26 +0000
Message-ID: <CO1PR11MB47712B195EA1C7DB1717FCB0E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220305112127.68529-1-kurt@linutronix.de>
 <20220305112127.68529-4-kurt@linutronix.de>
In-Reply-To: <20220305112127.68529-4-kurt@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 099135ec-696a-4c8d-3061-08da000d7763
x-ms-traffictypediagnostic: BN7PR11MB2564:EE_
x-microsoft-antispam-prvs: <BN7PR11MB256449D5FFA6E633B8D8E194E2089@BN7PR11MB2564.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iG2TXJUvKfuEWaiuO769dOuYxBw+oG1oUayobRxiDUk2mWXl/CZRJAeAoihd/lnkPHRi06HhbFapFTP0HXVUmbXn9zoyqRT8qutDuPp8X3i943laD4lmIm2Dn+adVMuXy7scCt+W54sAu+ruD4xzxI83Vy06zOrMEK0jelRS2ghe4WisQhOqvWMqB+auVgLI8NdUa2Khmm/7vXT5TauocJjvxXtNbIjx8gmKTOl900AywK/Qb4KwZ5iGmzh8C7/4Kj+b26xdOB1zGh/B6CTA4kqbaibGmzNFAQXAKcd3yibDCT43Cghi0SUYDsMQuNB4x6XJB/OCvH3RXiQX6rpUzKLv9PfJFvgNjmBNSdCPWLpIqYCXOkzvCpIVSov6HzkRX7zTcrBGvGJQDCbTHXBtnC4IYRJQvizjpElgbWq9dAPSIqxoUI7aQffOCF49pKy2y03SK/AMalcy1/2NRo/LRbetG45mqyZk0lymGhEskJZPR56R6jV6a9FrpqkJpYuEQc71dd7yWsztoiys9mH+ni2LCkIKmbsB8UBT09kpjOFWz2Fd8MQnWw3Jp4zUTJBAAS/OMgBiplaPHJrTHjnPBQFJy/LobGd22Sgd3/foV961Jo6zFKC9w4qPJEXPDismqlv5eEP8vBV2+1q95gjmm1kr91SBlU9Nz/thq9tfqilJJ48ktiyOKqF31HtUJSWv27nt/mvmZ2NW9ZYIX8APwVM3GhP6co+frfqnu+zXI9Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(7696005)(53546011)(508600001)(71200400001)(55016003)(9686003)(26005)(186003)(33656002)(83380400001)(76116006)(110136005)(54906003)(66946007)(38100700002)(66476007)(66556008)(66446008)(8676002)(4326008)(64756008)(316002)(122000001)(8936002)(2906002)(7416002)(5660300002)(86362001)(38070700005)(52536014)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bR7E3XCYQvy86uCdH9MX2NwM79n+NuQOx3Hvxz5dvJgA6zD4RafAIoIwIzVm?=
 =?us-ascii?Q?K/PbPH3wIeRu+IuSBt7+BNGjzWubBqnq/2dTdDT41w4ZnOvu6BPl/70xCKBr?=
 =?us-ascii?Q?FAPXN6HY+LADihT/ROq8AZwYB8XCtDcXRy8bHvQrg8wA5B3Q9+AnBMQK3pjo?=
 =?us-ascii?Q?La3LuXB6ZVQSk/pMDQysY5CEwwmHXasBEYMPdRme9SLSTuGGj9r4R7PgKctN?=
 =?us-ascii?Q?wehWHd03ngjD6W4eFL5KQiiM5NKdqY6LneIAzl1tD1N8U5G0dTqQOa6KwBh3?=
 =?us-ascii?Q?QDxv4HQI8FocpGIzw/v+Yg08IoQnvzHFHXl8xmxU83ZG7b4C4WO7WMRUAIVJ?=
 =?us-ascii?Q?jGLEBGih7A/b3Q0YIVcdWkCWHTaphtSfi5uH7GYJq/4m2tbcNVbELI6rWLxv?=
 =?us-ascii?Q?4xqeJMvUdQnWhUJVOe9j9Qhjcn7T0L4Z+T0wqJIRZL0A53EHvov3t75ILJSW?=
 =?us-ascii?Q?1uTbSJvBbIS3pR3GnINbURK/+3j8d1ExJF7HYq9JrCKBUJBqcGv+Q7hSiJEw?=
 =?us-ascii?Q?g0OPirmNPQvk7Tk122pehFm4J4t08vuqFHl7iGWqHfWENvfnBVl0X6x/Z44L?=
 =?us-ascii?Q?+DBd5NTLD2RHVClgd1KYmkVkrro2kn+i80TbzIxIMNkNkHWmhcxDgVwuKISy?=
 =?us-ascii?Q?DF7iBaSgk8t+qKxrLmZYAhqRbFvmTWk3aDrxLO4Ga9a2BETXIZeGx7pmjpMq?=
 =?us-ascii?Q?cHbCNvMFco0aaMfNPBQ6mwHzKqARpbu2Z68mzt4xt+qov3pULoxdFgujcM4V?=
 =?us-ascii?Q?x6WPTorFql6qjROguYbu+dnvHWoLSoZzRefhVe/qb56EAaub4ZGQcerjKB6m?=
 =?us-ascii?Q?8XYXuX9NHVhMnTUFKlE1EXZRZfOBjCGIPtXH79IMnCsLfYtIPzNjHYXeRiEV?=
 =?us-ascii?Q?jEWuqydCbpv+Ib0IQB9qFFDGpalhdXE6Uo1+apzBhUmOR2qZsa7puE1B6EYr?=
 =?us-ascii?Q?24Itf+Xv6V+IkTiYz2UgPuc75Yvgxld4gMZUOxUS83dyllH6iJE6lliN+cI5?=
 =?us-ascii?Q?MxpF9Xj5d/UsX9xDqwE+MYR5+FvC/TQG8VRRgRNV81oIDbFazT01qK3gJUqV?=
 =?us-ascii?Q?/XTAjbBzioorEnWcqJcHm3XEI8txVBMRuyoyUg4RjasTRcffRBPzhk9Acvm7?=
 =?us-ascii?Q?XvN+YZQfF1kH4pIrzExuSUFUa913uzkfXubZ2wBGsKiqkmLWL/gjJG1Iy4ef?=
 =?us-ascii?Q?haYlmMsCUNmy/cPkoTaLGrToMHR4Ve54tSWggp/NRott4Hg/ypp7CfiJoDGc?=
 =?us-ascii?Q?PbaI/WUM8BsUglbZcek3658uDxHvOnyS/7aCFepHYuVWDLXeXSIKlFZ/vhRS?=
 =?us-ascii?Q?af+eD3ZpjINPbx/op3UgpyplkYrAAK42ZZ+nV697Yp25A3+ufn8uoe/vVZwV?=
 =?us-ascii?Q?+6ve83rgYl3YnO6uq3db41AAmQ26zrElnAVmt6WzFvADa1dngxXqd2d8SQQ1?=
 =?us-ascii?Q?llAyPir3gjKgt0FrW5TLBvQI48eWm3utHtoEwA0gVw1FDVOmwXZfms3Y9EVC?=
 =?us-ascii?Q?0h7/VBfTbLJLWklUxbiSU0QWPnBMpLRaiBID5Pzi67R9XsI16qgRJXufNjgD?=
 =?us-ascii?Q?ZAGesfJ/Q55d4TBNsLVn3IBkjijsaxdcbWDLpRmeh31EvQqYqbhWYRFuMaUw?=
 =?us-ascii?Q?ye+/XS9/40txZ4qX72lTIgCd3sWAOMtKP9Zd1ULUpETp5q3ZOdVgzF1n0H3h?=
 =?us-ascii?Q?M8URfQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099135ec-696a-4c8d-3061-08da000d7763
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 07:38:26.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrHSHM4O4EsCVSksz2vTr8p+CuyWJCUCvmkgwnQW00cIr/jkTD0fbw94wJVv/VIPkWZrmmWWsfjdAzFbQ6aTrEna7CS8Yc6sfGDpPmp4Y4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2564
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Kurt Kanzenbach <kurt@linutronix.de>
> Sent: Saturday, March 5, 2022 4:51 PM
> To: Richard Cochran <richardcochran@gmail.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; Yonghong
> Song <yhs@fb.com>; Daniel Borkmann <daniel@iogearbox.net>; Andrii
> Nakryiko <andrii@kernel.org>; Divya Koppera - I30481
> <Divya.Koppera@microchip.com>; Horatiu Vultur - M31836
> <Horatiu.Vultur@microchip.com>; netdev@vger.kernel.org; Kurt Kanzenbach
> <kurt@linutronix.de>
> Subject: [PATCH net-next 3/3] micrel: Use generic ptp_msg_is_sync() funct=
ion
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> Use generic ptp_msg_is_sync() function to avoid code duplication.
>=20
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/phy/micrel.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> 81a76322254c..9e6b29b23935 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1976,17 +1976,6 @@ static int lan8814_hwtstamp(struct
> mii_timestamper *mii_ts, struct ifreq *ifr)
>         return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EF=
AULT : 0;  }
>=20
> -static bool is_sync(struct sk_buff *skb, int type) -{
> -       struct ptp_header *hdr;
> -
> -       hdr =3D ptp_parse_header(skb, type);
> -       if (!hdr)
> -               return false;
> -
> -       return ((ptp_get_msgtype(hdr, type) & 0xf) =3D=3D 0);
> -}
> -
>  static void lan8814_txtstamp(struct mii_timestamper *mii_ts,
>                              struct sk_buff *skb, int type)  { @@ -1994,7=
 +1983,7 @@ static
> void lan8814_txtstamp(struct mii_timestamper *mii_ts,
>=20
>         switch (ptp_priv->hwts_tx_type) {
>         case HWTSTAMP_TX_ONESTEP_SYNC:
> -               if (is_sync(skb, type)) {
> +               if (ptp_msg_is_sync(skb, type)) {
>                         kfree_skb(skb);
>                         return;
>                 }
> --
> 2.30.2

For the patch:

Tested-and-reviewed-by: Divya Koppera <Divya.Koppera@microchip.com>



