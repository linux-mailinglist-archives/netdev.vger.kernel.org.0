Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314DC529356
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349574AbiEPWHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238440AbiEPWHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:07:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B74E3585E;
        Mon, 16 May 2022 15:07:07 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GEseR0004400;
        Mon, 16 May 2022 15:07:01 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3g3rsqsn8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1BDRIT8occ9En+3hIpBHvoUIYodQwII3dHu4ftY+0d7r6Pnq89LGItzKWyx9hO2UwoQd1Mz3Ir/kt7lf8DRKE+E/GugmSFTyzMnvgIJZR+URds/cXnWL3lDRgS68xv/A+EAg59+3uVoGn1B59hFVI9TCx9p/bhdNeBCVnAGh9uWO7AKQyIyZ4GpXxRC/4JzBJHL8WEqM9/Qj2mIHcVYjEWx1/QsxUsOtyF+D/yhjZI89Gnq2GVaodDRFnXZni+5225a8OlR1/va0g3ANpCph1i+J7WStZzo7XPBPZwgR9arsy2iCSHMKk3ZejrIQY1/mwWoQKoAQwJ2IvsKX6jTaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OOTODjwJIsSmU9kjF5m9CJj/auL6yPlPGWN+gtwjfk=;
 b=oLZMosluY3pkBQBGMNPEsxFHMFqpDlpOwpex2yCGbjXFSzZq42CjvHW55RxG32pI4LTTt4NdQXWrst6ly29RFI37EFVtfEkZ/x8//QFzDoy09UrKXF8o3q7gIMakTqGNC+7z+1TjvOY2VwJliXDUwGflOvdHanLsYd2CfU3DWmP3lOYtYnKg802JXA7wI5jy5eYjz9CNT7ygpH621d5lU63l+6KoCCBcA4n/RDH221diRfb4zQ3zFGrDVhJMLy8JHWcVHpLUpKYScjyDXrZKCIhswqmJ6F4Gq2gpR2S47JNOOpoHJis1AvEKWc5ZSz93/KOMtZa0Yu3NC8eFrnTO1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OOTODjwJIsSmU9kjF5m9CJj/auL6yPlPGWN+gtwjfk=;
 b=N/bO+B/UUH32lodPBqUwh2PWB+7RMM9FFT4Ud/tcJU2IpCq2PgApDvVFA19qdocm/pra4g/S8tn25ovlhDSB2TgciI4ZWHmGEplj3NzvUQc7Yn16cbOordRSgvB1yyUDePDQDGcL9bjXQXyRt6jGAGyjYLYrd9eEW0F0/axvlnc=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by DM5PR18MB1068.namprd18.prod.outlook.com (2603:10b6:3:2b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Mon, 16 May 2022 22:06:59 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::3980:e46e:f615:b60e]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::3980:e46e:f615:b60e%4]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 22:06:59 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Satananda Burla <sburla@marvell.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/2] octeon_ep: Fix a memory leak in the error
 handling path of octep_request_irqs()
Thread-Topic: [EXT] [PATCH 1/2] octeon_ep: Fix a memory leak in the error
 handling path of octep_request_irqs()
Thread-Index: AQHYaHR1Tks+ZqCqYkqTcEMzF5xO+q0iECng
Date:   Mon, 16 May 2022 22:06:59 +0000
Message-ID: <BYAPR18MB2423D0E1D395F112E06015B9CCCF9@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
 <78dcfbb5d22328bc83edbfc74af10c3625c54087.1652629833.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <78dcfbb5d22328bc83edbfc74af10c3625c54087.1652629833.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 702c20f3-b738-4041-e970-08da378865fb
x-ms-traffictypediagnostic: DM5PR18MB1068:EE_
x-microsoft-antispam-prvs: <DM5PR18MB106840AB514BCA5220332F15CCCF9@DM5PR18MB1068.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EXCUixiR7PIcemS3+JaO6ryjrqhL4it6YE6RVDAzBVjh/QuodymuNa5DEYam1DybY7Bk3oFkz1DIOwfNFyNeixqypq38MOisLWuxoQiUNIgPDOh/BbP2hBLlaKV4l1+qYJZituooa3QjK/u3TPJM6ONwLvivts654kKO5YxJ99czkluXOG5yOymHhsv+eYFWmqboghL9lZMZd7bxBxiynDYHr3c+tGeItoNmbBfVCIMKvmw7/Pt5HZoXLoaVQmXcfSRRohkbiC6mDGX6+oFeJ4RWioWyxr5JM4MyV3q1JjA6slQ/56Eo+8z39RuzO3a6ztcO5xv48LK39DbNoj1aJllizbzMUxS6K8J41NUVnlfVQ48WWeTkS7hE43/Mxy1e7r3OBnY8w3DroooYlPbaRbX8k8Bk1bbPdPIvolF82Flf4tsvijZ8wm5ffAX+7erhs9d92T7xD/XwvxC5jOP6GRV6mCg4JeihYZIPky+QJX/d+r2hVgWH/QCPUPKlpEuAx5rNsssnMHujmq3weg1Mh0kPqasLyuzJP9UyYmnP+y76YcMnRCFv86Z/RM+jY9dNO0wq26C3wRke1XbTkJKWN/xoHa1lnK9fWRX2vHez1LxV6fJWXtuBDqOulfW8nrdikR/bdIpFu0yEeIK8+TpqlomowxW5UGTcwyRccHeRmnVXAPP99DNb98o9xGsCDKCI2Cdh1ZA45HRio4gViCaJYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(54906003)(122000001)(316002)(6506007)(9686003)(2906002)(110136005)(38070700005)(52536014)(71200400001)(53546011)(508600001)(8936002)(66556008)(8676002)(64756008)(66446008)(66476007)(66946007)(86362001)(26005)(76116006)(4326008)(7696005)(186003)(6636002)(33656002)(38100700002)(55016003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2QNTpWEgS67eStKpLzd598dfS7EQh9/+2XVtMtVfppgVTfknSwPNNGgy7o1m?=
 =?us-ascii?Q?TlYseSlCwfoNmomDXe3w4otD5//tBoh9LR4M8lFZBAIfBGT8F1ctcSe8Q+/P?=
 =?us-ascii?Q?AM2kmaafNxtWSGvNcXk+VRRTOvIhbUBYfJjA5fz+cp1j6DlZNsb5LT4I8yhl?=
 =?us-ascii?Q?RBgi7qwQWH23LoeRh5AkuBMHzsvn1Bk6E1w5Qlgn6iz/Ey2LK8hHsYBfgAyY?=
 =?us-ascii?Q?KbdN65PqwKHXxAvq7B0O+mTJA2gP6I1h4xVNC8yeczcyMxgezHAOH7y/NHpX?=
 =?us-ascii?Q?oFsJSPglaY9Frat663TpaR/RauMFnz+z0nGmun5gEXSeaVgzV3M+4sWXiXhm?=
 =?us-ascii?Q?aC2lMb3TM7ObY1dJoYrWuwoLslCKFc+WhWLBk/emNwpQtxsuxSf4xatADSCn?=
 =?us-ascii?Q?c+SPsqAVJxrsUbn4OoV1Z6pg8tNI/x/a/HctgUOjcGNOU6XufOd7fqZMWi7c?=
 =?us-ascii?Q?YD9dlZH93u/1Cy+AQZxc7zQyj8BiaGlVBhCvc1PzVfp7VDsGze0bMGNn/JZn?=
 =?us-ascii?Q?M7EY1O4axsO0xXvTKJtIpHH+GuUPAPC1zRXPgXuN7Ed28sJYrmfbG22VGLef?=
 =?us-ascii?Q?ogq6eY5YFU8dajQd8+r3PLlfOKCIae+NkJNmr39SbR7/km0GYqSv2PXkM/xO?=
 =?us-ascii?Q?4N67AC3seOlIifxBk/gqArTz4T2MHGBo9y6Nu6TdqWo3uKGRO8Do3159Z3P+?=
 =?us-ascii?Q?dxQJUekqQ+J6gKiokzVz17N2WbGoCy9EYM3r0bipERE21bOQbHNG53YByTC3?=
 =?us-ascii?Q?U8W2FrM19j7nB1+c8P72YZpgOQbsygdXblCyy/j2tKyO0DdKlDa1GVxU/MDl?=
 =?us-ascii?Q?nQJdbceKjJmGPHYt0xE5+685Wpv1E9To+g5fAVz8J9n+lwFW0bWqCdJw7EHW?=
 =?us-ascii?Q?//16OdQZ7AacggRr84xjvyH+03wyk054TBcJY/wJBWN8FllFe4GLaj6/W2wT?=
 =?us-ascii?Q?tsYRXDpILtqTx9upTeGsSiPvqQNq7DWoeMF8OMan6saI5pKCzmhOEw9TdaLV?=
 =?us-ascii?Q?DudzqDmcELsKW9qv0Q4rq7xQ97rnucklLM7Xb/ERplyeOiQOq4jIN7fgi7Tg?=
 =?us-ascii?Q?T3jut/oGkXk9uk3v0gNjj2mvUo21kSg0jVTnGvaQInDMvvm6Vl3NaT/e2jks?=
 =?us-ascii?Q?FSRL2Ep+Y3Ey16c6rrt27bGDKl7Ck1jt4FvK/aiE/CtHG7RskxD//6uDfKhJ?=
 =?us-ascii?Q?ppu8ZNAxlAweXHzEgGrfTYsyeSmH8zzEJiGbLrKq96xnzXsl/8TJJOkScJOH?=
 =?us-ascii?Q?8oWWpIrUljqtwmwe2mpJK+YSVht0LfbawXPtfbPVYcVHgfMVr08m264Ef8ID?=
 =?us-ascii?Q?wl9kT0qN/+MA5B+qO36rOa9YE5tJeeDtKXbSIfi0UZqXgW3DFsokLjDSBc2m?=
 =?us-ascii?Q?gA+zbaQM6afMin8CbTo9HfRgRCECZ1X26O/r88y40DitJEvn4T6AsT8RRlLO?=
 =?us-ascii?Q?mE03A5HUwqKbYdIkkkO9ob5DdlM3EpkC6q3Ua3cZtVVZ3/9/SETAdnAhMiIA?=
 =?us-ascii?Q?nc9QDi9QW+UWcgw6A/dWIvIMuGKivrqKIfzCyzjnLCF7fZmCi0pIEX9dtFAG?=
 =?us-ascii?Q?iPlZVfxNRJhWOoShV4zuqB6tJWWdg1QJK5ukcbJTM1UXmcn3g0RcRg1edcfu?=
 =?us-ascii?Q?7IP84c5vOKrFIESOqsENGKzMHcnGRN3TjpiZ7j+eXdqJDTVSDtlKGXeM8Hmp?=
 =?us-ascii?Q?Jijclre1kFsc9eGA/yJHaLW29Aa12g3YMoHDWiSH7DAXKqbEeAF25PFG/Gkf?=
 =?us-ascii?Q?11DHU2rwyw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702c20f3-b738-4041-e970-08da378865fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 22:06:59.2278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G8QnfvnTmMuCLFyUvMrNNPFBWNAD7fa5BinERzpEIjeQ4B8kldGbS/qas77YEZpX5au0INeXlAjM2GxWibfJpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1068
X-Proofpoint-ORIG-GUID: A-hnpXWXA6xzdi02R4awY8Em1TL6-x1e
X-Proofpoint-GUID: A-hnpXWXA6xzdi02R4awY8Em1TL6-x1e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, May 15, 2022 8:57 AM
> To: Veerasenareddy Burru <vburru@marvell.com>; Abhijit Ayarekar
> <aayarekar@marvell.com>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Satananda Burla <sburla@marvell.com>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org;
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>;
> netdev@vger.kernel.org
> Subject: [EXT] [PATCH 1/2] octeon_ep: Fix a memory leak in the error
> handling path of octep_request_irqs()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> 'oct->non_ioq_irq_names' is not freed in the error handling path of
> octep_request_irqs().
>=20
> Add the missing kfree().
>=20
> Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt
> support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index e020c81f3455..6b60a03574a0 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -267,6 +267,8 @@ static int octep_request_irqs(struct octep_device
> *oct)
>  		--i;
>  		free_irq(oct->msix_entries[i].vector, oct);
>  	}
> +	kfree(oct->non_ioq_irq_names);
> +	oct->non_ioq_irq_names =3D NULL;
Ack
Thanks for the change.

Regards,
Veerasenareddy
>  alloc_err:
>  	return -1;
>  }
> --
> 2.34.1

