Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061E558022A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbiGYPrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbiGYPq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:46:59 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2099.outbound.protection.outlook.com [40.107.243.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316A6DF06;
        Mon, 25 Jul 2022 08:46:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emLakIN4NEblN+n52U07fRjY6KaEvQpswrAylTHDd+Q6eHN8XOi0d4DmpdKTb5Sb7pe+wqBxS+Z6IveOKGLDgI4cGaOBPdgvooocKdbwOSzBi4NzLP2aTtiQAHILG6ev+7ELA7jkECzyD/lWW7Iyt9qQMuGjFLGcHwG3UdoGzhsKmnK5WwX/cfkOO5Xt/nn1RNPJviL6+ErpZXTjWsV+Fwg/8TMWSJttKN10I8IbW/xjcqq0nCDxGMGBzsHCN35+vdzO1Kwb/hOom1rPbar4mx6HdfdA1CqeGy6oj1bpeyuYmF2/azTJoFdkgFL5CBaCk187D8/aYDZFEZ6BmJN1Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvzEFsQvfoucMUwQEygxc1gL/FCe7i/yVd0DTEkXF2I=;
 b=GBq0Cy2LXWsTx06uwA1LjxzZj/3BwkqVX6BUnM/WPc4RXV5X98v2tPTEJXf6V/IKcLRzD320q8YHSoRq8FIzSQfutIoF+xVx2lM2P/KjZnTC3IvLAQgvqH8yDeK9c4l9Mrz7MeTtWwH9Aq0Nqe+o7k1TE6s9z8RhdjIgA0MhpPNsj9DcfMlXnE5R9orzm03Gl/qBcmHWS3quuLToyZYYypl5drtWQQ87xyqslsYfVHnG8PgBC59yaawBcCqKCxFm4qXKKHOhpIG6quVtaA00Ub62nAQDxA77nkLUeTE401AIX0xwqUY/giDDtKWaBwtZw9T0AIttmch7nmvN07rREg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvzEFsQvfoucMUwQEygxc1gL/FCe7i/yVd0DTEkXF2I=;
 b=isqgSTH0+30cFyxGfBhB1jwBsMjmETMg+liN7xyLqKxfQG+5YqUC6eZbaa+pTns4GbfZ/MmbcJbryu7lszbObKHq/6c1ILNGJYcHiDCFLJvAu7//I/kbhZg1mrsYL3NG6kmaJRb0BsR/1kciauWaakNxIYVFcbWRcyUS/H+zb1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ1PR10MB5907.namprd10.prod.outlook.com
 (2603:10b6:a03:48a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 25 Jul
 2022 15:46:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 15:46:51 +0000
Date:   Mon, 25 Jul 2022 08:46:45 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: Re: [PATCH v14 mfd 1/9] mfd: ocelot: add helper to get regmap from a
 resource
Message-ID: <Yt665a77awMYDqrN@colin-ia-desktop>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
 <20220722040609.91703-2-colin.foster@in-advantage.com>
 <CAHp75VdoBO8nKvGicsMhtY226AmL6nzt_52W+fLjeTkndwV7Aw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdoBO8nKvGicsMhtY226AmL6nzt_52W+fLjeTkndwV7Aw@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0175a93f-8ece-4d2b-66ff-08da6e54e3f1
X-MS-TrafficTypeDiagnostic: SJ1PR10MB5907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C2x7A4Wl7R3FGST23GehZUlwlqiyQSQbHiJdgWZk40dkatnGF7ih8eNnEPFZpDGB04rUo6lq1d0zyCg8WLTPsjbgHORZRzGKTYeAglXSM7OGKoWlBkQZamBqc56/Qoem43L8BK7cG8XNPO+PiAgAUh/DIc6PjKUfvLjiV2SWxqyHT+AKd5ul+SN9I2FAqP6UCRK5JRXjq2jSYmwuq8hPQXgtIXJvivmxB9rXZsX3AYzbey5lO8f2rPAGotB7vtCedUIAzDZb2T+jIIqJuu9W0/V0gpmG/cKAOo7eIm+H4sYKUAGOWOUbV2p1TX+KjbPf5bDcOWv9iLbUzjESPyt53Gas915r9Uj269HMw9k//ub0ps/uBF9ggjPcdgpuQ7b+CseBbJsVSXy6z7DshOSFsDo13OwehDrI3O7E9WgLLHNI04bmHappU/U7kufLNYP4s5nj3ctgG/pJKU4upQfqJXdJii2EA754EQJGq2TmP458M8+9Rmrotmn9gtj9c1q4S6W2TQhDrS/blKCL++SmXhy2gabkg5ZSbqQdMQJsseksB/ZZV7UN4HjtH6BD7jTfRR5B8Gn8yOuXlnLoSLc0Jvy32GoNN7/RJPkyGY1xrI93SoABFC/n6psiudSgO+c+mHQrg8sYWW5BSVOO3WFPNVU3eUIheFQdCYCZdHjgOso9Vzz61J0bn2VGU9PEG/3Hjuhk0nGvxnWFAApQaDGe0Rpg6lNoYzlhXPJyjEAakQBNj9Lf4ALMQsGXe6QFcncL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(376002)(136003)(396003)(39830400003)(346002)(4326008)(41300700001)(6506007)(2906002)(6666004)(44832011)(6916009)(54906003)(8676002)(66476007)(9686003)(66556008)(8936002)(66946007)(6486002)(478600001)(558084003)(7416002)(26005)(107886003)(38100700002)(86362001)(6512007)(316002)(186003)(33716001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZK7omif8VgWQnGZ/7kGEJbwxW7AvPVeM8Lzg53Iy6tcCF91/HTMGmEhL146?=
 =?us-ascii?Q?Wcq23T+g368JSK5EP58sVFgarGPhnJfMpJ+OPbRRj7y0LU2pchvfuzSm4ETs?=
 =?us-ascii?Q?X3nQt4uiQEJl4hoAWtT4ut+Yc8IqoARDUdmsP1UFu81BdA64SAX0+3n/urGv?=
 =?us-ascii?Q?+olm2yOHqPlcaodlmPbVhxQGNTHrQ0xyIctCFlfwQLF6xHefjGKrZywX8UaD?=
 =?us-ascii?Q?nJ+h0+44seYrZ7A7VHKHciZmBJ/s5C4NoR6BjiPaAGLTW0IFO4jRlZagyHUA?=
 =?us-ascii?Q?F8A33+fk95w4q33SoZFD43XdXokTGsLdbtDvEEV0s6iDhH8e6A1XPntnWUZ/?=
 =?us-ascii?Q?/mwk3ZaQ+nwbUu56adjvbehM3s4XOp1E8MkjHvgR5Os+bOi7wlEEFGnSU3YX?=
 =?us-ascii?Q?hjDAsP670pWJwGdV05MG0gXbJhXBhic7Hg2HW4OkG9r+fdArYa+cVJKDEN9y?=
 =?us-ascii?Q?XrTkRHMj5quypjJcs4GaWKvqM9F2WKU365Z7KsS495vIxKspoWmrrnxTIKD8?=
 =?us-ascii?Q?gAiuiyfAoY/XC/4aIPcZxKZKsU2Hb9B6F3scnHe+Wo3PiJSpRND8LL0QkQjQ?=
 =?us-ascii?Q?DAP6t9r4o0DyqC3R52wKjtAskSURWfco7ThjsL8tCpYQZD2Jgg+88a66z6l+?=
 =?us-ascii?Q?qPZMC2CxQXrCkdKO+a3mfq9mAENzIBuqFZTslt3uRlYQF+at90wTMYTlPuhS?=
 =?us-ascii?Q?5NjxS4eHWeMKmwTrHaPn2vRjV61upn64jYEgrsLdDoULKPX64FscUlJVQpOv?=
 =?us-ascii?Q?nna5TnQGuTrTDX7Si8XBcuRS2rGzq+8F0PdgL6GbGkmW/feFjXcHYTUzpHlc?=
 =?us-ascii?Q?RPleFKPGACwzmtc/zExlH3Rk3dmTUkw8qk9Zy4ENC+V8CJaFvKppmX2J0ers?=
 =?us-ascii?Q?mavNj1P8HXUVDyvt0JYPsAJwMeTUfiR3SHcOlUHVo4131SqdtcVIYIQNFV6d?=
 =?us-ascii?Q?kDQIugnpbekFhaGmUoB05Kpa53SEpEDBlk4zjqD7ivKvFHjw2FUm7DNnlWNH?=
 =?us-ascii?Q?7nP5OYUWNKE3nvnn4q4JM5XvtGiACL1PtC1e0ScaXfav5WBjYdBkE0L0SdvL?=
 =?us-ascii?Q?Rgl13SGIDDdS+gqZg1dNIY2STTm7IJRNdsUZGLx+C/k3Q48cpNRn+Wj+EwuG?=
 =?us-ascii?Q?mHlk5bhjeK1tj+h+9BryAK2yq3IId2Rn3lujbVqOmo7jJuL3H73HzAMiJnch?=
 =?us-ascii?Q?f4etfZcajMu2PTLugFgquFUqTb7rg5sS88SXaKg6FmGyhdCN+GZLtRgHfMUe?=
 =?us-ascii?Q?bHKRPnsbwu8ZrgLmNJdFz0mpMIp/aHMgzyYAGMG/nqw/OGBtQnw6Tbmw0YiS?=
 =?us-ascii?Q?X9UMyDwSshDLaSpi50iCArXIW8mvP0Lww1mhmBo24St6nrME4OT9AhpJeIjT?=
 =?us-ascii?Q?2YFa6vzIysqRbhHzfTkc5Yppa8+2JJqdBeAatVX7qxvzd1+mfiRnkyQ2j1HK?=
 =?us-ascii?Q?IKgDTOo8XvdCJDx67be4nPEpN7ujwbYFj1oX5DFjBH7wv6hD5YLDCEy+T5ei?=
 =?us-ascii?Q?loT95ZPLzXdt0mG/EnkJ8SCeNZuSAM8HXjybAGzJs58PSrx9lECEL2IyTUJQ?=
 =?us-ascii?Q?ynHMGrmvdKVTceK0tzv9SHDcxLh/ImDI6q5VpXocB8xfE/35aBbcFS6OhFOR?=
 =?us-ascii?Q?RYiUwz2rh3Z/TIWODIvG6SI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0175a93f-8ece-4d2b-66ff-08da6e54e3f1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:46:50.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cS5f3q/Q/qO1YhVDpWgEjmPgTaQPBy6NKIVKyVVgliFZSAcMzR8ZJi3+KyTq3cuYqnoxupJ+e7kl06aglOa8qbUJE4IewjQqwcaHKPLsYlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5907
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Great catches as always. Thank you.

I'll wait for Lee to take a look before blasting out another version.
I'm still holding out hope for this upcoming merge window!

