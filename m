Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DC14FBF1B
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347281AbiDKOcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347203AbiDKOcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:32:05 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EDB3B293
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:29:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWWe2ZWjggsCmckzh+6qpN/cyEmvHph65RL5B+WJDs/19kjy0PUjQnSnUA1De4E4thUJI3J9O/19zfPGyZ1e3M2/q1ld+dv/pdqqEqgvDk0VwLkV0W68Tit8wfJ+Vguj0q9cFgCaqrmAtqAk4+I22xvLZL0RAAab1lvjOV0R+SivD0HpaZFl66SJsxfkz3f8FRlsmairt4el+F4Yq81vZfSzyrxyNeNhMLOcOJKb7gaO3K1h5yQiLgKfC9GA+/Yy9y7m1EVmhaYBsfXzUcAckOawBpSpCsk8DGBoTqL069P+Edeg5P2U1T8C+NhmEZjsvmasC9gyj3yMD806DvKs4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPF7/H++AxMfyeqY6KDHmUhNUUQB484loj1U5hwJRro=;
 b=kVJQ6R/E4Do7lFpaZTAnO63Dp3zaXvFYwTLSzld6mBVuXtpLnrKfS461cNizzhPPY138DFFLe2zpCDH+aWgMq269mgTNpw6xupEDbBIrIEA74rkoipwOygWW3t/ZIWZ2KdQtLCwbx2UXN4eev0HyM/D/DgGMF4qtb+PNL/D1cxqlkuMwyMBZ3RlcVQAQEGDs9tVuUm9uYY06KkXAm7bnh2Y/pexHKELmcfcsfmXnmA1TXNIUgJSXxefI4cdB1+7vrrnCNvpxK5SNIsFkWJIj4++5vuakqWAX/DHL6vRTQ6Jx+WawfdCnfqEANyODFfFVYN+KSUrNhftpv0x7zWmWng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPF7/H++AxMfyeqY6KDHmUhNUUQB484loj1U5hwJRro=;
 b=BXJW6s8/zVxtizzSuKMY8gHz+1NRpqIVLQYq+MFN81Sz4/6qkvJG/TqZ7YJjhjUHziSZA7WSOdRY3S93KvvDEe1BRUvS8A6CInuLLh07nDNfZpeFWh+nqF2QrOMqneJpq4GiNnltqUtQ3GZQazzFxh7m3XIJhAMsn8Q9jNj4d/Cm9sIMGE0rniQl3LCnj2UrZzoMsC4JX4AKQ2lucxtXrXymnKWN/l/Rj0Af0UNdbVMoRsDZ9YZb7pGAjKqMm4BWdcctEfq64qajMDf88QKoRDdgw9FvmDR9XROxuV0DBHh/ba9f96URX6r9EsU68SS4ehj9ryJ6OL0xn6LqrRG3eA==
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by AM7PR10MB3975.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:137::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:29:49 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:29:49 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Schild, Henning" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>
Subject: RE: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Topic: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Index: AQHYTaW3YftshBPJT0uGZWTNekz6x6zqtO4AgAANVECAAAKNAIAAACoA
Date:   Mon, 11 Apr 2022 14:29:49 +0000
Message-ID: <VI1PR10MB2446B93B94F897274943D1D5ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
 <YlQtII8G2NE7ftsY@lunn.ch>
 <VI1PR10MB24463A87DC9BED025D377CD8ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <YlQ6cm/BYbrWejW4@lunn.ch>
In-Reply-To: <YlQ6cm/BYbrWejW4@lunn.ch>
Accept-Language: de-DE, en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2022-04-11T14:29:47Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=1516477a-b461-49ca-b2d9-5b9af2f539fe;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09b81c79-32cf-4292-c4da-08da1bc7bbe6
x-ms-traffictypediagnostic: AM7PR10MB3975:EE_
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-microsoft-antispam-prvs: <AM7PR10MB3975BB1914282BB614A3F166ABEA9@AM7PR10MB3975.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TJRRb0StoTWEGiYGMdQjOEPBytQKWDNGfJRD1ckwCHlFUSwf0wEUP+LLCVsjkyIRVlCvKIcIj7Le0WobOY+BOCoVrhgUG/6L8J1ejP6WXhsMBsZGwzVTz+oZUuqr5iE5LU7YN8DSZ6lHCreIykz6WLoe2l/N70wBLLhysztfHeWqMQPRJKWaQqcxP2ZF1F94EIsDYAy37geb3armlbTk/LERwdcKaNQ8hqmksXeYwl/CsHFvXZMDrDRSlbcn2IK8qH71i9/akCro4V4TJ0aAjtmm6UuAzhnsNu1lsZ3PjTWejm6IPoLVqhyWeQa751dhriXQ4yuQ+BcjMlJdakNKNjS2tu19OECRr9fAPMz6Bxq+tu6bjPc6tmdBIAAKEGs4WyccxbK6DZWB7qbKP1RanJgNcOruJRd4HDxQG9Oj5X8HD2y/z+fnYXrUmPrbxdvvHIgk0mMXrgjyiEOfjLnUC5Yk7HP1qgrpssK5XFluw7a5p8qiA1sjMYtAOWNpJNd7hQ5z6niGwdy6dBmJ4TE6O/aTJDeFP8SqFcTzNZfMkqKmawZCLZfOh+zQWNG/H4SsHRjfQgK5o8qcP85JYTAZJEaEOHcBSgg5MebM8qBALmrXckSrKxto45CFPo3n85vF7s8jyHlzRiGl3odBV1iQdeYSJjPpyTiJFRFeU5mTv4lzNwI2rJNzom7l06ehEOm9SuunU1fo0hlMp3kNjabNuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(38100700002)(64756008)(66556008)(66476007)(8676002)(66946007)(66446008)(186003)(86362001)(52536014)(5660300002)(38070700005)(2906002)(76116006)(122000001)(82960400001)(83380400001)(9686003)(7696005)(6506007)(107886003)(53546011)(4326008)(26005)(316002)(54906003)(6916009)(71200400001)(508600001)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C8TvfjuZinyQvL8DdNjjT9puEY2Zti/W1QZEAeQPxdgpm9VylaieIm8ocmRE?=
 =?us-ascii?Q?iN4mTAhb9kKwCd3EZc349CuD2YvbgD1YPCWTAHpzPiYcN3kYzOEo4w84H1pm?=
 =?us-ascii?Q?IGnvF65IKNSnUxMPDOUsE5G9HGjuCAKJQw3XG9FbLIsBE24UaUiSkOucKFHa?=
 =?us-ascii?Q?iMEh1hx6EPnuJvtEMwPRb41mw6Mo9lMqXn1lkN7ixkpT7YsKaum/QuMMhruM?=
 =?us-ascii?Q?PD+WkxTXoRvJW0lzNWDTmiArvPpCwK1H2ifrUVh0OnE13mr2mH2+gktrEMOp?=
 =?us-ascii?Q?WB1ucAHIuvxi7fdN4HPr8pkmCe33MH05Yzo9HYtkxAKgt2IGQypz3Y3150jZ?=
 =?us-ascii?Q?CA+oaFDXssd8z83h3C4pqLZX0qsxsThZuSyDofTE4v0+kT/TYYaph0OOfkWm?=
 =?us-ascii?Q?ljtHVVnP+KORM6Zy2XY1o6NAIPaS73qWJzzTuBYwecOATDzrwPCwR3y0yYfQ?=
 =?us-ascii?Q?dM/2jqZFySLSlphQ0leY9+aCKI+s9uDOGX913A/kAIBCui2PMAtywEvFW8gv?=
 =?us-ascii?Q?KlPhw7Xc02BEeppx0bhqIvSqd9+7v8WnFRD1AoFyACfZ34WWybDkuecbz7Mk?=
 =?us-ascii?Q?WITa1176tQiulczpfQkbMeo5BqjRx70ixiir5XuRl57ZJlC/ngnGgQJBkJof?=
 =?us-ascii?Q?+L+hx1fm6nM7AIofJEFmWyI2hWcMbiKxFJeHuPZFvLP3K+fQ/XzJVs2Y1xJm?=
 =?us-ascii?Q?W7To4Q2tKHfB0jHWJEUQt/qE6rziskcFEV4fwBtGWEfrPScui4bqiBzZ/uf7?=
 =?us-ascii?Q?ubXDCRONViWH3iPJuMdYShSap4wjWMzfUmWC1KtPGDWBTclcTvxTaBL6s+VC?=
 =?us-ascii?Q?2/C5kig3YYPaJoU7sHoYy5WN2m2V9wWanPp8V5GrtW6eGmywXsxFXicH+y40?=
 =?us-ascii?Q?d2JBUScgTAQClokm8p3xeKUIk2We/lyWUXIAnW2uJC9kTXZp1JZWeigpSZ4m?=
 =?us-ascii?Q?Bj0jg9VaXpVahPqTN6hzv1LSM/sxhHY63Erjs4/j+jc3iRla5JyG+wwhbf2B?=
 =?us-ascii?Q?XFUbC9s/YyaZfHWvT9DnzQvQTeo3DWRwk54S1NCtiWjcPF2S5JIf5O/XoJsl?=
 =?us-ascii?Q?BeoH9vQG5e4Gr2+3QPAOwYzBRJEEn3Zgxxv8NPNldPR9fwQP+X7Rl6I3muds?=
 =?us-ascii?Q?JyeuoUNj/CH+AxwUEC+Z/0lQhR0nMP0SnwFyhgieuTsdJhD53xlbU6HdeXxa?=
 =?us-ascii?Q?ieQLQtJF//jlum4FTFcK87jKHKu+MH3yfxq+uPwqXWtbTexx8s9AVqXDxIMD?=
 =?us-ascii?Q?nux5IlX3X3UxdMvV92NJGQFG2gI+7Hc5Tg0+ZMqdT3vskruud0H+7N7NlYLG?=
 =?us-ascii?Q?G+inVmKJwVPD5WuprJHItmm/ybqFg0BNEcLFl8DiLKGPB/CAO5sLdTt/2es3?=
 =?us-ascii?Q?o3aA0q36sCUTTLKoG+KWdC+0thlebvXfCqia8s7GMntzZUe92tEBaXiG7Msx?=
 =?us-ascii?Q?nqeTFHXWCtoUEtu9Vr2sFlW/79slobHJvd6evrdqfNPt1Lg7JF/dw/5MaAmI?=
 =?us-ascii?Q?fpgauFV4d4PmSAGECCJL12GHrJ47hT6NCTBMPK6ZmPh+cwKpKS1maKexYCsS?=
 =?us-ascii?Q?Sw3OBNDm90Ze+TPrWttPAF/AXkRRWN2dZ8/2ceTyjRZtSlFCju7Uy1VcQdTe?=
 =?us-ascii?Q?8DfkOfcxeZL8DGIRuTCf8O17bf1jhuwqge+MEWK8MGFBnvwVCQyXq4rAwo8j?=
 =?us-ascii?Q?4tsYyhiSBjgrFrXm3BoyEQEnbKVq/Qo6qJKKpp6ckPkQQpELfkMY5GmqFi2+?=
 =?us-ascii?Q?7sD2Lg4fR+NaxLRDUTaDJoib1/RykT8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b81c79-32cf-4292-c4da-08da1bc7bbe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 14:29:49.0626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NNb/o/luXhDVw3LnzAusR+8eEDNmnCsD5qsnv/x31hU3rCj5Vwz+UEB37WT128HQFKkHoBGb1ww1xw+FJzAih0ZOy4b/270nGj3dkXlky+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR10MB3975
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the code is GPL, as the code comes with Hardware,
And the Hardware belong to a third party ...

I understand the reason for users. But like ant rule. It should be used pro=
perly.

This patch is really small and could solve many future TC issues.

The current state of many TC callbacks does not make sense.
May be it is time to do some cleaning?

Just hope a light the way.

Erez

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Monday, 11 April 2022 16:26
To: Geva, Erez (ext) (DI PA DCP R&D 3) <erez.geva.ext@siemens.com>
Cc: netdev@vger.kernel.org; Vivien Didelot <vivien.didelot@gmail.com>; Flor=
ian Fainelli <f.fainelli@gmail.com>; Vladimir Oltean <olteanv@gmail.com>; S=
udler, Simon (DI PA DCP TI) <simon.sudler@siemens.com>; Meisinger, Andreas =
(DI PA DCP TI) <andreas.meisinger@siemens.com>; Schild, Henning (T CED SES-=
DE) <henning.schild@siemens.com>; Kiszka, Jan (T CED) <jan.kiszka@siemens.c=
om>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information

On Mon, Apr 11, 2022 at 02:17:44PM +0000, Geva, Erez wrote:
> The Tag driver code in not by me.
> So I can not publish it, only the owner may.

If the code is licensed GPL, and you can fulfil the requirements of adding =
a Signed-off-by: you can submit it.

However until there is a user of this, sorry, this patch will not be accept=
ed.

     Andrew
