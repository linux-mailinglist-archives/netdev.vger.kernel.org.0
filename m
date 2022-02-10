Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B44B1174
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243451AbiBJPN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:13:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243267AbiBJPN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:13:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4083A137;
        Thu, 10 Feb 2022 07:13:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHP+KLSGV63rOf3m0XN+MX+YYSdpGM4U+zCj+7mlZmkmp22X395411cA0WYkxeLt02/P0+TSVGhzHg2wvwNFC+7bCDtj450BlJV0c3odhuOvY8s92sbF+QZXBm1IMBxZj6bLtfDWkW1edq0/2x1RPg3muDSesWyWXjd2+i1NlVX1pPJ50xnDpczKfk3QxeTIYSIIuwTu0/IHNAlU4Q2Gy/lIhvzspudN/197pXpnaQ+gSdIBYngSnOoe2g9Vm9gbBbxvtvKwuHqacop7e+kjgtL1+3AVfiPh1Z9mJ96Ha3ydivhtdsngy7FgQzzP72K6+3hDfZudskezFbAjm76brA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4W1tDUBMGjvkLDBU5YF1ncnLJVd3Zu3+GdSGRVtEtrQ=;
 b=QRa3tnxIMv5phI2Bd4ENO/MEOMJXb8gfOfXjL/HqRBlEhBdt3BubUAz4ySR1fHybrxJuU3xTaQVGV2+6kFm4m7uca65fFEY4U8G8TaXBTXP2zj5veb8VALYpIk/0EPZq5EsK+i3zBUCGe6S6yCpqGbq2RzpC68GTAJYVi4z+jl+LJOKJcRkP/j7gsDo1HKc8LvqbCCwJHK2i3z+I54Xna7OKSuFa98Qp2HDM3GNiVWDh9CyWAsnSl+t9vAoxW7EqgKgKluLMHHIwdUXulHi9qdzONJwhEINAWn5j/UYmJl1TWDeoLdfXQAgF3h5DG1G9wx7CF55Lg1Fltl5g0BT65A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4W1tDUBMGjvkLDBU5YF1ncnLJVd3Zu3+GdSGRVtEtrQ=;
 b=U5rCCDA4uaaZ1KLvb0mtXwBWH5Vq5XDvSEhw/iuFxqb/bqQkSYuGAXunk7stdmLcao5phlgjDxbLuy3pvM4sV/T3cs49RRq/K4JiCLQDgtZ8O6wS0jwbwLeuRIdelBQ8qbVstCKprwi53nBlxQFP1KZnhXhshmL08Pg/X8BZpwU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Thu, 10 Feb
 2022 15:13:24 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.014; Thu, 10 Feb 2022
 15:13:24 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
Date:   Thu, 10 Feb 2022 16:13:16 +0100
Message-ID: <39159625.OdyKsPGY69@pc-42>
Organization: Silicon Labs
In-Reply-To: <87ee4a3hd4.fsf@kernel.org>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <4055223.VTxhiZFAix@pc-42> <87ee4a3hd4.fsf@kernel.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR2P264CA0045.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::33) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce58b25f-569e-4e3d-1c35-08d9eca7e1b8
X-MS-TrafficTypeDiagnostic: BY5PR11MB3927:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB3927831E42CBA7056DDB895F932F9@BY5PR11MB3927.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQ7bhfdYri6+g0QWum2DpNJiDg8S0CoTqLL7eTlkDtD2QGlZf3zy9qkz5gbIJC3PsNW4oZOYqoNDBDINTITbTM1VEMG14X3W3Aj3YL2Rx4xKYYqPON09P69xpXRl3XisfIA2PC6KSy8F+DTbM/7VMcTO49nM7E5R0e+gG+6hlaQ1/ulk9A8oqFCdgzqRj9rwlcRm6rileeP8EyJzpe8K/EkzZ93Tjy5vUm244GsVlFQSeIJeMXjmYuDdLWycUraCPVn2GrmNwrwcuix6nslxIscKGatGv9272erwiHT3QF1JdZhKr9G/suPVCLXpyj/9xAsjhdzyJWp5fiKi2gTYj+F+Eo6SXzVbBH8YfSTHs4KgwIGigd4N5Evn6NJB2Lp6NC9TPrRvBtxmaI/vj8sUtKhw0tPcAm27XV/YvEORLoQtsxYxn3mJ2FAzdD0f/gggmqLLQ5aq06BJwJx/Brviw0/c18dt+dvK/2TqetbTd610joq/ccK7mVzoZpbFOGpLSRuZLwxF7pYX+LwYsXnUCIWXy6Ou24wy+Q+P5f57LY0P6ZWlT5d3UhjcjoTdwJrXZmaVNip3C38eVHmkmzUtJ9t4YdA7nqzvf5rRwmva2tNWljFkfBD9moG7zGBos08AnSHg6kSND/K8AMb1Zar0fpRdapl+oC4utAotekDDg4mIM27B7byFHkEnL3lC+htmjg6fUZLYUpkeDf86Hw+GLevZ2iIPUFf4Slqei57pYYk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(8936002)(66946007)(508600001)(86362001)(54906003)(52116002)(33716001)(6506007)(36916002)(316002)(38350700002)(8676002)(6916009)(9686003)(66476007)(66556008)(6512007)(5660300002)(186003)(83380400001)(66574015)(7416002)(38100700002)(26005)(6486002)(4326008)(2906002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?I3+dqSU2Md0Dr7fS9oa+kB4Vqn6XROHqUN3ZXnaB6ApHYiWiB8Em3RhMe0?=
 =?iso-8859-1?Q?tj0b9HzO4GRbMgum+t+N458YCVcVHFm47JesiI/EJuxbFCkReTpsUWSQwc?=
 =?iso-8859-1?Q?YLvhmSfov3GiBF7leOZbRzTyMe0XTLryXX+v+sGLynvg6x7leOTellg+nz?=
 =?iso-8859-1?Q?5YxR2kdxXhP0RaLtbhYqwC/wM1WeMNoPu+YbYbzxdFR0g4iM204H0J1Q2k?=
 =?iso-8859-1?Q?EhreXqiAPUBeRBfSPb2WEkEWdB1CY7EKNh+QFY9ZkXYZzYX97b8tv9jCI8?=
 =?iso-8859-1?Q?hp182Iq5xdcnNMQt1pDLExNxb7IzUNrttBu9Nkj9LmJKaD1tqt07XwpGNm?=
 =?iso-8859-1?Q?oh2OVzCcY+US3Ln1tm7GiLApV0W13j7a1iHq/XQVWA+tXzb7sPZseO5iDX?=
 =?iso-8859-1?Q?E/mVi5KwPtudh3w0f4CQ16tkUM0Z6EI5g2Ky+L7h9j8X9B4wfn7KwfPxOW?=
 =?iso-8859-1?Q?hTE8GhVVNk5ajlUB4ZfMzqExaG+3mSr3yAZbypLTIe6dWtfoHmWOffZvLq?=
 =?iso-8859-1?Q?GEUW0pAW84ABnk9Zi6ZAqgXIMyvL3QiVmSE/eV8mA2Ghag5ZRWL2uStDtR?=
 =?iso-8859-1?Q?+wfGAb4PeQtwAw0AGjoWvl7XtFz+ZgWpRqQKDQxElRzdV7+0dgc9bmHEEn?=
 =?iso-8859-1?Q?iL/baoP7khbjQ1uohoWYhSBh89Rrszu1WemRSZswY0keYnnkFfHMu5slp6?=
 =?iso-8859-1?Q?bNSZRyf6WaIoPXBg0Dcph0tb7WX8i6Ykq68gRteQZKBNoEPefdzLFhWPcv?=
 =?iso-8859-1?Q?68D7YxpolfoOMJcNYrSNHXdM67fOTKsxQo9rSeZAdtXz4EMnDU+u7xYZjD?=
 =?iso-8859-1?Q?kfnBYHIzu7Ml85FbSaev89VSCNfRd1MrtYvObQs8Ld/EDTjyVF7Pf5Y+qs?=
 =?iso-8859-1?Q?eiE7rBxp3sJxD7pjWhQ2Dblru6KZydQpCBXhz9vrrQuYVHJIz5b6QehYDX?=
 =?iso-8859-1?Q?GkPH5wflpAO5kdYK49h3BTIDjrhT1UTqvJtfB4/Z7degvMq3wpqXv3+VYH?=
 =?iso-8859-1?Q?iEzeROMNzsbe4cg0hOUmcd5xzvgT9H1uFvqabtOSA9dXl7nInw8NEmGexg?=
 =?iso-8859-1?Q?aF25klocoDR+qzCt3IWN16KQK3+l5gr6lB5AjkNMAocU8yjn0YBnt7GZ2V?=
 =?iso-8859-1?Q?UvW7v2vdj0oQlpZN1pHZ6CT5ryB0Bnw/zYkiehywuyvFXTqMj6xvBa+Wfy?=
 =?iso-8859-1?Q?9YpWvLuO4yz/9pkmDLlW6iKWoYT56feMVsDcZuzZZAavm0wXBEZeAjnWeq?=
 =?iso-8859-1?Q?Y46jKwc7DZTEwJttJ08aQGlOiTdln7XXAjVjrQz/vaG6+P5B6ovjlXHRSn?=
 =?iso-8859-1?Q?0DRtsNUY9J/aYueMZcK9XU2F65FaiITocidCJ1NYzMxSO5Ch1DN94mO8RA?=
 =?iso-8859-1?Q?OHxVYBVWQ7tqBUlNoBNbxV47OLcsvDekeT0hKmHttH+o3LKOvBIMazK9lw?=
 =?iso-8859-1?Q?KrU/sh8u20Li+FCC+7CGbySS3yr0jDH1EFd8mWCirlIjB1n0w55yQfDA9E?=
 =?iso-8859-1?Q?YuBx9DiGh/YRCHWPzVffsz15phEWy/Zio6KUKhVWLPyHTWpm52G2b9zJnw?=
 =?iso-8859-1?Q?9l5zkRzmsUdRepPQdwrVCxOe8QHgn2Oa+XU26DWRVQe454d/RUVbie9Jw+?=
 =?iso-8859-1?Q?Ag3r44yBD4LL6zDOxSYNYhMwkTqG2suEo6WfV94y787kiPya+v2bUwYk0d?=
 =?iso-8859-1?Q?yx45COqNa4zxs5NWnbY=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce58b25f-569e-4e3d-1c35-08d9eca7e1b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:13:24.2769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqpakgH/vVpWhT6fHz95FsBkkDefp6NmOEPHuxlnagA/nrFuUa5OInP+YMkq1yfU7x01h2zwhJMUopzqYG3cjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3927
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 10 February 2022 15:51:03 CET Kalle Valo wrote:
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> > On Thursday 10 February 2022 15:20:56 CET Kalle Valo wrote:
> >> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> >>
> >> > Kalle, is this function what you expected? If it is right for you, I=
 am
> >> > going to send it to the staging tree.
> >>
> >> Looks better, but I don't get why '{' and '}' are still needed. Ah, do=
es
> >> the firmware require to have them?
> >
> > Indeed. If '{' and '}' are not present, I guarantee the firmware will r=
eturn
> > an error (or assert). However, I am more confident in the driver than i=
n the
> > firmware to report errors to the user.
>=20
> Agreed.
>=20
> > If there is no other comment, I am going to:
> >   - submit this change to the staging tree
>=20
> Good, it's important that you get all your changes to the staging tree
> before the next merge window.
>=20
> >   - publish the tool that generate this new format
> >   - submit the PDS files referenced in bus_{sdio,spi}.c to linux-firmwa=
re
> >   - send the v10 of this PR
>=20
> I'm not sure if there's a need to send a full patchset anymore? We are
> so close now anyway and the full driver is available from the staging
> tree, at least that's what I will use from now on when reviewing wfx.
>=20
> What about the Device Tree bindings? That needs to be acked by the DT
> maintainers, so that's good to submit as a separate patch for review.

There is also the patch 01/24 about the SDIO IDs.

I think the v10 could contain only 3 patches:

    1. mmc: sdio: add SDIO IDs for Silabs WF200 chip
    2. dt-bindings: introduce silabs,wfx.yaml
    3. [all the patches 3 to 24 squashed]

Would it be right for you?

--=20
J=E9r=F4me Pouiller


