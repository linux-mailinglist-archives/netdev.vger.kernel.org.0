Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA58587582
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 04:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbiHBCR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 22:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiHBCR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 22:17:26 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2130.outbound.protection.outlook.com [40.107.223.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C725D43E74;
        Mon,  1 Aug 2022 19:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMNpXqZxFtly4/rQqyj+ZDoM845lEDBKte20o8Gjyvz8hweEf8sBkrm55Hn5uvauwY1Lckk2J8qrmB8puo2F2Iawk4FkOuHuA8TFPPAYCBVeN6lmqrs+js/tRF/DAcPQEG4nEifR5HU7cDmTvvgrXmuCXHsYeauoNxhU8ikUaVK91RBYHJgIthWaOBeSsvfa01wKr9Yh1imcdSYY4wf2wJv9mRzwblq6XEOwqrYC4+oPDSfpfCWtEKARvSw1+n0V/z3K6H4FIqCreqgIgQkFyiGHBhFwIwLCzJXB3hJzHEsuR06hN0HOQNphJbC7FV/wBkuTKDRY07RgyeyHnNLlRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrIW3dBY5vbh0Y/itGbehrxSAFo7mQAP5sUZE7W9QvA=;
 b=NDOCaYqDhLrVr2zXc7m8wIMciA9QsmdZj1nO5VzWeFuAoJnsKzHoJmyqs6/mNe+oV0dbktXK/glWWMy1UpvbdAJs2q+UIwCYWxa9Slv3iK4uTn9R9FU604yMKRtXMnhCNWtwTZtztX7rc1xFTESbUk1jROS+jQ2xRy/gt7zcxsYIKFBV4ik8F42Q2WUE9DIsFAdvycMRaw7ghhzA0A9efgSuj08sZ3wLYY4ojJq99YeAVTtIUT+OL43PHo//a1EoAEbqj3jhfIiluoBeMlrsXm+QRN3dIaJvkkekHk5ebqinnP+FDOFhA+yNqXDNB4C+fbo3zOr3/Pj+Bk3Sk8G4rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrIW3dBY5vbh0Y/itGbehrxSAFo7mQAP5sUZE7W9QvA=;
 b=HgKMig/9CQQHjiZk0hK8Lct7aGmBATDnhd0kxxpCoVSogDxox0QXZbdYE56EL9DGXa0h7WWkeNHXWDSA3AIB9DplXy81OvbwNSPwyAsjxQFzHM+5LUfjK6BFLgseZegnpfEHUR3kOivZiaLi7M8l4Ag61+mMRSeE+pM2McKa52g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5585.namprd10.prod.outlook.com
 (2603:10b6:303:144::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Tue, 2 Aug
 2022 02:17:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Tue, 2 Aug 2022
 02:17:21 +0000
Date:   Mon, 1 Aug 2022 19:17:16 -0700
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
Subject: Re: [PATCH v14 mfd 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <YuiJLK8ncbHH3OhE@euler>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
 <20220722040609.91703-10-colin.foster@in-advantage.com>
 <CAHp75Ve-pqgb56punEL=p=PnEtjRnqTBSqgs+vVn1Zv8F94g9Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ve-pqgb56punEL=p=PnEtjRnqTBSqgs+vVn1Zv8F94g9Q@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e75a64-5c80-49e4-5e82-08da742d2135
X-MS-TrafficTypeDiagnostic: CO6PR10MB5585:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: klp5zM0vszVPu7BI4/RchVrUGUb53+RQSGaaa4gxF+ND0Q1dIYrKXnGflJenSDWdIwDY6QHmJW9l5u6/s7kKK6N15HaJcXR1wyCiAPoyQ7EGrWcJC5+6rdyAVEqZLUlcUBYWhL8I9emgmfjaWDHQbD7x7qAqO5NGB8rOYJjxyM5rk4R+Few7UT5iP4kOV/yXbSstr3McjHopn4k0VRkvjnjmTnHbLRgmDtpjxeDGSKMpyxgXE+vob1pRbW6Pa0o0QpXRQrMdaJdvpyDF/ZDLO1LCFFKzgov+wQACrsNWQEXIY2ZZrfnyqDeowPzkPxeWJNF1Z1AAEbAEgzzGnM40utkklOnIIAjeBydqv/tTyeoLjvZkFAd6g3oH/h16rMrKfMmMHmmUOmlVyovkxYeKZlZsHk+tAtLB6ottfZMpAFgkJdbZZSPD+lR/KuRq4yZlGqhomRyy47nmL0JXxpXZfamjnu4oAe+Cj1SseleugnDolIlIVT4gMosVZX3ulKKVkAX4c54qov/AQP+/505nUmINihxQZ9pee4Zo6j5VoCGld03HaO8DIpPVXH62On1aGFinBXd/1M67X7CcT14kkYVy7getVs6A/vKGNgJxeVch3WpnqF3iPMoXwgnEV6A7HsD1NybboQsfiW1T+jpkX92NwnHvm18NK9SFeI9s936jxW86C61xqxlsHIJ54xjDSYTVzkhibUJmsA7YsN8za8WBmS4LL7Ck3Vv1uuYlY1M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(376002)(39830400003)(366004)(396003)(136003)(26005)(6512007)(9686003)(6666004)(41300700001)(86362001)(6506007)(54906003)(6916009)(316002)(33716001)(6486002)(478600001)(38100700002)(107886003)(186003)(83380400001)(7416002)(5660300002)(8676002)(4326008)(66556008)(66476007)(66946007)(44832011)(8936002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?02E6em1qquWDLHx1I8zebBgWIJ71uPDQqUqdS6iOF2paisFuQ4DFaNtzdXVT?=
 =?us-ascii?Q?H/zM+cywPOYEriChdY2rGFyjC/0ABscJDfOXiH6zo4jU7tUUUlgQVOjN0E/1?=
 =?us-ascii?Q?12Ow5r7nMOttHikZzauExU0jM/J7P/xgrYgYoLSeu4wimd/mG1mIaR2l1fx2?=
 =?us-ascii?Q?VObpbB/jtUFXs/5DekGsjjiJjRiQ3LAYe3DD11KcX7Me8SBcouLSZMHClPeC?=
 =?us-ascii?Q?T7e0qw5b45M8BUWzk6lQzmp8o5xJHTR8GzdRMGk2UoXJJjYzTGVK4oS6PPEZ?=
 =?us-ascii?Q?GDeYoUKTisKyFOv8nR/KMB7eJhnJzELdiTFLohHbjX3Hdy0t5yZ4Dtsww1m+?=
 =?us-ascii?Q?9SUz5qee4QuSPdx9Jg2U8JU6WllY9RLErx72i3KTu8BFrGDvNWqPawZ7bJJc?=
 =?us-ascii?Q?bGMUsDVqEX03qyBAtIBey74UmCQ8LNDAbgXiSl9DA4JEqvcikRRDGTSKKuZj?=
 =?us-ascii?Q?f70qPLQaqOeIoO7ZnpfhXwMBVCTvCDHat44/xr13izfE2yRDgcsIZo4rB/33?=
 =?us-ascii?Q?mia/KSAOzc3UV5WNbyfzMQweBJ8c8FhzJr5+cvdVRiqBupyy15Kc3T9hsdwA?=
 =?us-ascii?Q?BSvJLyusBp5dZv0MleLonw5DcISyOTuyDeEDzqJpzM0AXZa+CMxg2Vl2fIqn?=
 =?us-ascii?Q?tFpOqb88o4W6fPPI2RuxVtxHnZ2TCxwJHN8N36H5QfaYa4Hj98ocMZrNwbjl?=
 =?us-ascii?Q?CvFUD2bbZeLtafPnr1jXKe2tMTiLyXS79ML+FQiykrkpIgMbw2d+5lwTISgg?=
 =?us-ascii?Q?ZL+M0p6tsz4ZjP+RQhky4Z7BOzuS1xQrYD8tVdm3KY8jV/j9smPFxmeBmB8N?=
 =?us-ascii?Q?m9s73v2oE3nd5jpCsjA1yRvuTrp7hsDd9kexhnOsy3oPaWH3GsMe6ccgXBPz?=
 =?us-ascii?Q?jUtj/+jSvdwtkh0DHAeI8isf9oLkh/WNwM32XjLpHGeED0UY5XCuzOzrR3/m?=
 =?us-ascii?Q?yVtkG0lfkxcBpNJ/W4ytBj4hpTcD95CGUt3HaOypnOK8MwFr+CVkb6ZLkBOG?=
 =?us-ascii?Q?RKK1X1vH4VWC2T24M4qtr8cTecTwUotNAL3L28CMVpLFllFwXbTxkaa0FLh2?=
 =?us-ascii?Q?McU6HEmOWGryZItAKIzjg/gf/3Zh7zXB/24nyKN7XlKx9JoGjZ6aju1l8Dw0?=
 =?us-ascii?Q?npPq4aIrRz4/hX+1WcA3rALPUvxLTfzdxe5j+iOrEh9SdGUVyU9+yMHxCmRE?=
 =?us-ascii?Q?xeMtW9+7xkIhR53OXbJ32qiYP+PXU0DH8XVv2x54U3wbbFjHvCZ1A8xlPy6c?=
 =?us-ascii?Q?WQEnkJLVvizS5jgxFzTNNl7ccrGmts2IpD3HtbIYv9Brmsy2mC+W95f8ilRQ?=
 =?us-ascii?Q?oNB6A8xEuHkE0oU27w9SjljD2/ahLcne06r7nvcaAyZEMHY8eGiKcKVgsDuO?=
 =?us-ascii?Q?YKfH4Nbwz53gmNuPGL5zTkWUQN8D1CZBzOmczY0UcGBgq4Y4BmMkMqL11K81?=
 =?us-ascii?Q?tZw7DldN3or38Q1QUo6L2MjzFMnO9w/y0XqMQraxBNbky6Bgn3cYbrMwYGkW?=
 =?us-ascii?Q?H/sX5Syx35vkJShGCvHWW8hZdNG6n3vIQapHLi5mdNgQ9815Q9IbOW2KAhvH?=
 =?us-ascii?Q?kT8lViP6ckPvEYQwyOCxkiQ1eP4POQ7DSAWM8O5cx9UPy68M63f49rDdzHEL?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e75a64-5c80-49e4-5e82-08da742d2135
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 02:17:21.0842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pbrRDsrESAEjM8ofpt3L1PvpNd0f0Fzwhx9lxL4uZHDNJD6z+W/utVtb4JseaYA9tgXVIY7N/DZ/9h10VAJIFtzSENfBuaQY4S3Mm0cfFV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5585
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Apologies for the late response. Everything seemed straightforward, but
as I was implementing your suggestions one thing came out.

I just want to make sure my implementation isn't horribly off before the
next patch set.

Specifically this question (copied from below):
> I'm wondering if you can use in both cases
> spi_message_init_with_transfers().

> > +static int ocelot_spi_regmap_bus_read(void *context, const void *reg, size_t reg_size,
> > +                                     void *val, size_t val_size)
> > +{
> > +       struct spi_transfer tx, padding, rx;

struct spi_transfer xfers[3] = {0};
struct spi_transfer *xfer_tok = xfers;

> > +       struct device *dev = context;
> > +       struct ocelot_ddata *ddata;
> > +       struct spi_device *spi;
> > +       struct spi_message msg;
> > +
> > +       ddata = dev_get_drvdata(dev);
> > +       spi = to_spi_device(dev);
> > +
> > +       spi_message_init(&msg);
> > +
> > +       memset(&tx, 0, sizeof(tx));
> > +
> > +       tx.tx_buf = reg;
> > +       tx.len = reg_size;

xfer_tok->tx_buf = reg;
xfer_tok->len = reg_size;
xfer_tok++;

> > +
> > +       spi_message_add_tail(&tx, &msg);
> > +
> > +       if (ddata->spi_padding_bytes) {
> > +               memset(&padding, 0, sizeof(padding));
> > +
> > +               padding.len = ddata->spi_padding_bytes;
> > +               padding.tx_buf = ddata->dummy_buf;
> > +               padding.dummy_data = 1;

xfer_tok->len
xfer_tok->tx_buf
xfer_tok->dummy_data
xfer_tok++;

> > +
> > +               spi_message_add_tail(&padding, &msg);
> > +       }
> > +
> > +       memset(&rx, 0, sizeof(rx));
> > +       rx.rx_buf = val;
> > +       rx.len = val_size;

xfer_tok->rx_buf
xfer_tok->len
xfer_tok++;

> > +
> > +       spi_message_add_tail(&rx, &msg);

spi_message_init_with_transfers(&msg, xfers, xfer_tok - xfers);

> 
> I'm wondering if you can use in both cases
> spi_message_init_with_transfers().

I could see that implementation getting the response of "what the heck
were you thinking" or "that looks alright" and I honestly have no idea
which pool it will fall into.

> 
> > +       return spi_sync(spi, &msg);
> > +}
> 
