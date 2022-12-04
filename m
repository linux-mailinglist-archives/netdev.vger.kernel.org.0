Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8DA64200D
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 23:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiLDW1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 17:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiLDW1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 17:27:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD5CA44D
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 14:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670192866; x=1701728866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZAMbRy2Kh+vBWWrjGLtpUiZ/4uiQgw6+Viuh3iPk0gM=;
  b=WP4Ipa8pO0YbfgTKs76bk8q87UtbwAp3aCjIBXppIUTO1doGnPV1ulqH
   L4efAACHIuZpTxwQwM7M39/INipSE7b9PeuKJqZ4sIVQPqzTBZN1DcDy9
   ++09jva731vMD7cp1BYwWfOsuvpLqdRvnO8YmLH/m+Op+2Y0cUwbPV7Ub
   i/e6GkTld/Cy78kgi7G/mPwCGb3CIJJC7PdhfFuv33F1ORGUuT4y8QIzM
   lMKYIcF6ElF+KgRXiWmIi9Vsg2l4hXH96WPrmOIwukmQAD0ChVN+X8+Vh
   Yov9EBBgfcclMbOSydv8NREWcP3BmhNVAurZEj3hyuocF7jtSKaPyir1b
   A==;
X-IronPort-AV: E=Sophos;i="5.96,218,1665471600"; 
   d="scan'208";a="189968633"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2022 15:27:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 4 Dec 2022 15:27:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Sun, 4 Dec 2022 15:27:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqzNKg7diDg7PcUw4DjGvnvJ7XN0bM2+GfmGbNHRDVEKx6E6Lt7uPUmzf9pbM5l4OQh8EbLk9WukmSebl14q5iXj9lGmswWnAtIIWrG3n9JIBQgE87iIEXBTjMizRHCGoRHB6Sa5wfSfnpLYLPqyY6/S3Ih9zHkeQsDAGBTp09ccuvpwp59EHTgZlAdWI77Jg/qZKeoV7lrksOwgVIVKIjH1l77c9jo2zUDxs4V6SgVoxW1ckuZ/yeTS1Gd0V+ThFL+8OfrcGAVySG1hJOwCe39HDVtZ0I5POkCE+YzmG0rJHCuWb7z0QYZRvpzVw4drF5kwIpxQLkhM7nB2WUeHig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKkwrOlBbAbWdDi8hXzACy74YXdyHTjpdfDT8F5mVv4=;
 b=R9Wisq9HGkbBs6D1Os5YjsCmSqguHAj/EzQUWij61txAjamHYHvF51Q7v5RayLFZiwxPPy+8M8dQGf3wIxFR2LF7irOGjvNjRq9F8gqFYeC8IqGAjPFizChOaK/jxvY4+tXcGXoSkLkaspFETBz/rFtYx7mZr4NsVxUL9G/7oIPU94tYEFL7suO4aDP3TEikkcgbl9xRGLTER+FwKXMH4r3Lffna+4urJQqdWJwtYWwaZ6dwumxjQwjWW0j5x+JIOvWSTBfBX2hOzC9JcGMiNxTNq2miMN1LN3KupN040EOgfkoZvHetXB3IHUeJRgDKRjt1agxYHnURQSnDd0aX+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKkwrOlBbAbWdDi8hXzACy74YXdyHTjpdfDT8F5mVv4=;
 b=pFcWOgptLK88dfajHgf4Cx0SDfimUnymMEPQX97v9fpO1nzKOqcgF2eidi85dYi+gtbckxqVPlos87iACBoUrjlmPWDE2iBcG9+S3mc53NdRuTuZxVgzPrkq6smPVvXkPRRJPRwwhYNJTsM7PVA9JTrA1/vdAGAykbv2LPQp7KY=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SJ2PR11MB7714.namprd11.prod.outlook.com (2603:10b6:a03:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 22:27:40 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%4]) with mapi id 15.20.5880.014; Sun, 4 Dec 2022
 22:27:40 +0000
From:   <Daniel.Machon@microchip.com>
To:     <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Topic: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Index: AQHZBi4aQTbgRosZIUWfrfvxERABnq5cZT0AgAHw1wA=
Date:   Sun, 4 Dec 2022 22:27:40 +0000
Message-ID: <Y40hjAoN4VcUCatp@DEN-LT-70577>
References: <20221202092235.224022-1-daniel.machon@microchip.com>
 <20221202092235.224022-2-daniel.machon@microchip.com>
 <20221203090052.65ff3bf1@hermes.local>
In-Reply-To: <20221203090052.65ff3bf1@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SJ2PR11MB7714:EE_
x-ms-office365-filtering-correlation-id: eb75d47c-b913-4702-de2c-08dad646c13c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V0qCG5fEmt7Nc0XtaoVeO/hG33ZgcwoUhIJZ0M71MsIh/m2wYEFx55uAFQ6rofv3irEByvHXIYyDIHLDuxLybApOk9og4I3oIodFNDwRAliHA1oODNEHy6VyFCKtaYWA01vlPUqr1DJa/cCwpyqEoq9PQC7xfqG5UzZPUNwfn7a2WWU0sXnwROAN4Q9vKrrYvExgfNnj24z6Y1wlYC1Eeo88AwY1MFHFbIxnt6jcUxQ4qEyoOg1Q2bYPUCdNhJBBqGWaEf+lLeMzb10dOGv2ivAIVt84yYUTji4dgNgOIek/GSlqsdkG4TDs+kAdNejjKF9jgQIbKnowPHjrgpY7nOnDTenj2OulFqqeuHFw7ik4R2T/GdsJ806LXOldNg/VLnYjMu8NN0nr6sgyEqHoDfjmzhE/JO5aZ7lL2AIwn/T8wpLg1onv8273KOYflPjrTDGcwrnlFl5ukc9iwxw5snGX5gczGxLsAg6X7PC55XlO0IlUOofKr8+j2u1nj7/eOJ1Ig65RzJDjoraAobEtpohpkM/p6aT5BX+G4HVgOM9/oKGWslpz+53W46N2+dc/paA3r1tU+xLBHhGyu0BB6HjQUFB/AXeh6iSY2JVNitbzKVZ6tqpgM/lgTZNTFjj2D711/qAS1BduwujO+c7AOYhEJ+z5S5/AkE3mFQ7A14CkM88K7gXcNgxD+q8h1R+64SQYJ0/vznIGUVBnOeplBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199015)(33716001)(186003)(86362001)(122000001)(38100700002)(38070700005)(41300700001)(66556008)(66946007)(66446008)(2906002)(91956017)(66476007)(8936002)(76116006)(4744005)(5660300002)(316002)(6916009)(54906003)(107886003)(6506007)(9686003)(6512007)(478600001)(6486002)(64756008)(71200400001)(26005)(4326008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+UzkItjMhA/PFvlmuoer46L1ch0u5cVeJxpQJUTm3bca+nQEtnXr0GuBNNE6?=
 =?us-ascii?Q?5/VF/NyN/l6d4NxYFy4y4xTiyawz6dEo3E8cVnmQEkz8VY8rkjOuDLP/vjM7?=
 =?us-ascii?Q?LdXtOVgb1GWnnw5l3VjTbVU+ws0xaRWSq/xXD4iQBOFhiqqb9vA0drJyj70T?=
 =?us-ascii?Q?mX87kNjzM7EKYnbtnN7Z9sTgAoYur50mpXVwc8Qxa7lR429K2auStPbQ7g9m?=
 =?us-ascii?Q?wrHtxTfpLeyA2ZHKFrzpT7p5TNMMkIUAvDnBYYqa23SpcuP+NFJO6gOXpr1Y?=
 =?us-ascii?Q?cbBcCjvOPwdZGUZmQJ3mY3ESwgE9cPGaZUhHdnSFafBNP12xY7QJNds83J+P?=
 =?us-ascii?Q?7r4z3I/F6XvMZWgD/SBP7vkzlXRcZ0ye3FDGXixhD9Zx1041SPyw54EWYWVC?=
 =?us-ascii?Q?JMR/fKH3oQwlGf2/FYrCMOjNyPy8bwyl6/f5rKtB/nBQPVAoVjZoDCsswT1K?=
 =?us-ascii?Q?4gPR9tZvGcd1WTSi56+3qO8PEej+X+giPiiTrPA6G6Q9ATetRS1mUiGBLtTT?=
 =?us-ascii?Q?3zWYe4RF2weUl/lf2FQsuYW9oMzhWz44egwKKmRWCOIbtY9H1bf+ydA3ZFBh?=
 =?us-ascii?Q?lXkCU+SDEO2sIbRJppaJRL2oX/qpHU2ElbTK/rTca1PdA9GVu6g9VpiPK6ZX?=
 =?us-ascii?Q?o7b1qw/YxtkfUe7I4vdRZX8PP7yVmGb+K/Iv9lEjilct+cWqs+vOG9ff9SP0?=
 =?us-ascii?Q?y5uAspO0WqiCxpiPNzliVO2RBgt8SLJHFw+SO6+A2f1E/6M0jiW3euyoKeRl?=
 =?us-ascii?Q?4dGqi3Q41XdomYvUlbU5ehQVf1wZnQyVhJMW2TlvrLwzicY8bRMP+iUqbIzl?=
 =?us-ascii?Q?uZoMayE6IZIO6djyud0Ko9CBOIk4v+L+FSZHaMnax2xEybMYj1wil22Xf/ik?=
 =?us-ascii?Q?HOyuPWvcB9ArlYGmISg8ADd8NC+dkxk/unZXZCIB6xWF5cGtNlju5731KOgc?=
 =?us-ascii?Q?4ACVFKq1zYznbLZY3MA3mKp+3W0v9JULjbTLO2+YArHMnIEZJGxi/F8gNzbD?=
 =?us-ascii?Q?N43+LYg31GGnRql3Xd11vR7msAH6rbCFxjyXsxwfVWtGttP1FkMw1gpAxzjn?=
 =?us-ascii?Q?dmybS80ZqHdF/7/MmF9QE/ZvaIUJpOqYlSfPgS3SW1m07YMFa3MNRD8HKpkH?=
 =?us-ascii?Q?Yc3XxARBATccagflzpo5rhkPckgcUqCAX8/YilU4EwD2n/mR1bXm2sDt9bak?=
 =?us-ascii?Q?9oAbE1sSNe5371Ug4+H9ElSeXsJPKe+n2j9ltmA2B0HSu1ZOlqRQwuxYxN55?=
 =?us-ascii?Q?0dYxyes3Nile9GaLVViffXmz3PShgqoxU2vvtlMpIGCBFY4pOIbJr6rqcLJK?=
 =?us-ascii?Q?P3NiU6zK8QxnhgalGvLmO+pZZ1VA0E+2E7H23sOojIE9zSk2kEnzOWeStLnB?=
 =?us-ascii?Q?1O7lNEumskyoMWGRA/eqRf2/DABIbvIgt/X3xnQ4APVK3j8sPe5FVPOapDST?=
 =?us-ascii?Q?d+JpE0XaTnd9HFimG56yZcLeqvSX4xDMhgjFblaxSO97h7WnpSg/lfsgJk0w?=
 =?us-ascii?Q?9kXHVU9eOvmYb0iHYrUUN8eRXy0fdj5tfItW1XYQwj0LQtOCz+9LyyXHUBKX?=
 =?us-ascii?Q?Cc5ExVYwsuVIsUafwTYBk40Vlwz4XIaEiDA44phI2HymgN0qMhCPnjnpdeYR?=
 =?us-ascii?Q?dCBs2zQksoIgj533q7yzXpw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B0CB86EBFAA0A248B65DC18D7CA9488B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb75d47c-b913-4702-de2c-08dad646c13c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2022 22:27:40.3768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bGgSk59SqQn3Sz3p1kRphwJiNKvCyTOu3gNkA9yYUHGm0CrInPeTpVNQyJCLaZ17x33LWG/szH9mFf+5+BU8h+o1CuHwt7NHDzQHKOCN9jM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> On Fri, 2 Dec 2022 10:22:34 +0100
> Daniel Machon <daniel.machon@microchip.com> wrote:
>=20
> > +static int dcb_app_print_key_pcp(__u16 protocol)
> > +{
> > +     /* Print in numerical form, if protocol value is out-of-range */
> > +     if (protocol > DCB_APP_PCP_MAX) {
> > +             fprintf(stderr, "Unknown PCP key: %d\n", protocol);
> > +             return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> > +     }
> > +
> > +     return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
> > +}
>=20
> This is not an application friendly way to produce JSON output.
> You need to put a key on each one, and value should not contain colon.

Hi Stephen,

Trying to understand your comment.

Are you talking about not producing any JSON output with the symbolic
PCP values? eg. ["1de", 1] -> [8, 1]. So basically print with PRINT_FP
in case of printing in JSON context?

/Daniel=
