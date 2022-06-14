Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF3354BCC3
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353960AbiFNV2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344334AbiFNV15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:27:57 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2133.outbound.protection.outlook.com [40.107.100.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56AD2936B;
        Tue, 14 Jun 2022 14:27:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gnxvyb0vb7vUxjetrZq4kT3ERKviGI49ZApLKbkHvcrzuZcgf29Ou1w9n3eHHuWs0g/ZMI4yAt1kV4cd+o21Q3fh+mclNc4cS0MSNIeLM1xgnZ3QR9yRIp0fMcXPEvvRH+NH7wQ6JOKrTBGlUCt+hKXHAL9ryMkTLsv3honFZK+yVZx085rjNcKrubPWbzg5tSeTd3VcwTJzBAfzn0McVLgLaGjXvrVEnARlKIhQ+j3Cb+4ML908GkUrqzIRd+uPguOj5/FYeih7DuQXaK04Jkgue1u/WLp2jQl9SwRUntaUpWAf60vSZtnlFG+HaQ4BcFfDZUOXiewiY7xrKRB3Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wJGwi07HtK05NQWgbAZxhWwx1aPuF4EDqd9d0wMruE=;
 b=BNjsd/LyAVs/mg+uNZ3PzDgXlzsiVNoV4Ve96MGsMbivr34JYKqLk5vI40gudWvhwneQMkfTe9zuh5VX1fTpMN0HhdP6YkqDRKi0VaWZ98o/ZotJGImWSdMzeG4+9d4GiTzxaurU4Lqz+Ub+QGUc8impswfyFzjyrS66wl8ZM6AeBj7VwuFKnOunTb+decX+suwmM4v58EOQKRUvqYUeGNzbXJQkz+ENOoqpysOVJOsglWiFb9Xzd4quwYlEv6ewT2iSp3wRjqMhhalkg1+g9Ei0+UtKCpCTQ71pnKQnGMp8m4Cpm3+pO762Vnx/uIWpMsT0D9yb65kCw+NBN+E38A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wJGwi07HtK05NQWgbAZxhWwx1aPuF4EDqd9d0wMruE=;
 b=IgThAm7x9sYPtwDWxaphJaVXFaumsGLbDsIDmAlVfCkNcNs/DOH6FGy0ZRjzcZ/fspaMXZtTF+yuw2clYvcDg3s3V1XTHg5pkxcli9BC3QHDUWaWp4dRvtFpbJz+kJ1KHkBQKItzutXSZ6vzlGqUBR6fl9MRcP3GTrHSXzzRLpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB5920.namprd10.prod.outlook.com
 (2603:10b6:8:aa::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 21:27:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 21:27:51 +0000
Date:   Tue, 14 Jun 2022 14:27:35 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v10 net-next 6/7] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Message-ID: <20220614212735.GA592415@colin-ia-desktop>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
 <20220610202330.799510-7-colin.foster@in-advantage.com>
 <20220614204345.GA2419690-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614204345.GA2419690-robh@kernel.org>
X-ClientProxiedBy: MWHPR13CA0038.namprd13.prod.outlook.com
 (2603:10b6:300:95::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c6fd3cb-4bde-43e8-3605-08da4e4cbba7
X-MS-TrafficTypeDiagnostic: DM4PR10MB5920:EE_
X-Microsoft-Antispam-PRVS: <DM4PR10MB59205AFD785C3491B520FC88A4AA9@DM4PR10MB5920.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FqfbI3nfqA5ClwctQyPsxuxnuXM5OEcs2sKOuH/ehU3yZ72PAc4XqpTkezEBMfYen3PbmqqtU81NeOOmKwnk/ioR/5D3WxfoRbzsjfAnFUWcIWq6FVJGSk+kyqlT583IabwvVuy6aZwPq2+1lfOHxnGtNEaB7kgyv7IVKGLLCH6qV0AlswE3vXMvYw7FxR37dedRtR0oCUc6Wu1Kx2yzbntTerapDDeNuK4nBipHZhz8nna2ZmhX5BNrwjmP9y49jYpnAyFcTaPFtFeVoQncr4JZ4RxXgdkkRk3RwnpYljj5b7xNtDaGBKMDbnqlsLzUQIRQvZhzwOQek2/sf8vriuoC7AaDCVuToCYajzE6adiE99LHFI9cNzEmUVbZSZUgyFjXOt6jvOCLQgU7H6EpedhEQGYx2PVvi+m37YmQdO1Zf9n8DwKp1KT/cHku3ls7VHSYBxgWS6trSozZiEP522t2L5mINQVk6MRvJGHE+hrN1tPz/y5hARe0Ahjr09WaaDkVPClINCVjCAHwuqtJdRCxu6J2+KXPtbqswcItfbzkvrF9cHUn2ijkTlaakKWpdtE8giETQhpHzLMwcgn2oySV1nlLTTvqVL0aoYJ5HX5LdVmfJwwWdxqm1bSiZojBJa/F7hG/KDZhHwEt0FU9zqpAIS2c0Y3O/ZfUitWBTGCVnXqb2Zz/6h6bnSA3wetz3wTn2lawltvd3A2xKhJw8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(396003)(136003)(39830400003)(366004)(44832011)(41300700001)(66946007)(6666004)(66556008)(33656002)(7416002)(4326008)(2906002)(66476007)(26005)(9686003)(8936002)(38350700002)(5660300002)(6506007)(508600001)(52116002)(6486002)(1076003)(86362001)(186003)(54906003)(6512007)(316002)(38100700002)(33716001)(6916009)(83380400001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lCEX1/uCFl7t2X8SASUx5iXBUjQ8jHIgmoDbbUdtJ21OEyZrnHQ/F6EzaGGY?=
 =?us-ascii?Q?LVRZerh6iNAX8TzJV3L9XkvN21jWVxw92lUFVVsqLAicLWHMd0L/JvJFbMuT?=
 =?us-ascii?Q?pqsK2BMFrFJUTL9d4weUafKrNayOHxn5WRDsgkWwEOjGUSQrWBFmN8zubVTs?=
 =?us-ascii?Q?1oYDVyWWA21XX780yJoXU0eRvVQWzrPkWjYnfMygAHulK1nm3BLinfQKn1Cv?=
 =?us-ascii?Q?8F9rIbM5vdFmO+93Ihct2ybI1cfdn3DK5Pper7Yr+Imtw9vLuOJklx/FlPRX?=
 =?us-ascii?Q?ubkPB1rBQIfZJth4/SIkw/5PvwXeAR2yzOwVLdApf67YCqC8jc2apuJH7PLP?=
 =?us-ascii?Q?UolOQa7y0Sope/s/xVmnQdyxLhMU94rbTx7DaqBMvqNcMKAwdqkmKhYj5pDZ?=
 =?us-ascii?Q?p60Lr2I0SMmFYSQqmsZrp0pl+jdXFAhR7iuHIlQzk5TyFnn1yMn2gCavhxMo?=
 =?us-ascii?Q?FInuZMepaJX8ycqj4rOofYWE2PgRJGLYizaibDOEf8yFzh7Q1EWiEGyf2Xg4?=
 =?us-ascii?Q?azBtY0DQuhhpWerXgPoYp+P+ujQt+ELoNiH2EY1ExxvQw7n3ZWtjr3vBRlcX?=
 =?us-ascii?Q?TD7xQ8lNRKN8b1t3tNvlAQoDNvGcbCvW4LgrHIJsUaYAsBC9dA3W5gSNyxtD?=
 =?us-ascii?Q?KmyQCduaSBXaAzAvutqUxwDeuKha4V3XfKkv5nNl+gb47ArTBuUtTxrXqQXy?=
 =?us-ascii?Q?lRq2MLnC+nxsqWB6zHm+06q2QUYiint2lqkUhyH/iwgsbE9mPhXk4GDsxiCs?=
 =?us-ascii?Q?NjloHmMUZU+0V8L/mJqa4OQHV6geoH6g2MygGaMlS81GR3B2/mEUKqGJtmZY?=
 =?us-ascii?Q?5ETzrzf6hcXJF2EwKv0nQ4yadKpKrGGc1WsKOfOAxJIeSL8IajW10sWIFyP8?=
 =?us-ascii?Q?RUea/MOT347zgKD8m4hoFWGH8XfPNWj3ZB5ysSbjXv7YCf6/G8aPWOkExDyZ?=
 =?us-ascii?Q?jhCu7eZ9VNopK1eXxbIgM9Wc9dpEMUL6uY73neRLXNw7lO3BvMVxqfgcsLEi?=
 =?us-ascii?Q?2VgMgW4FxYvYXyoAvlZxNDWL08Z1cs/EJctlEFG3swUvnVnPVy6VODBRusvT?=
 =?us-ascii?Q?+kbUMol7n7kDDZTuVubXIz6m6PwApLxPqtD4bA1Yx4sGJ0NcYrHxfcpOjd92?=
 =?us-ascii?Q?zfLIPD/S2EOtq1QAAOc6eEagUPqK3yyJgN3IqC0IfVepp0wui9vNk87tPoIj?=
 =?us-ascii?Q?nl/XzoVThMWVbW6HHGocVH6hi6wp4qklFUTU3wU+haUqUoel3r4QVGdn3STl?=
 =?us-ascii?Q?wI4k1c8xLCOXiYBoECxR729Z8pc1GxQbvbvkJljPRFFzefUm/LgDYyDu9KMo?=
 =?us-ascii?Q?bCCjXfzi6qlFoZexihF/VvKKp0SxUClNj4dGxlLt0k2FOOcbYaqCDhqVkHa+?=
 =?us-ascii?Q?AMJdBshD1l/WvlavMMikLep+V2eVekGYEb0e7jzsZHYzpKCNGMsc8tA2H8UQ?=
 =?us-ascii?Q?mL1Xvt3/+Ej1fiabZiN2oy/GwRlmEiBu3Ovs3Vp7BcsQDeBqpSXn+zu0Mlrc?=
 =?us-ascii?Q?d9qQwoXHMdUGntOcAsNW8FN+6MOtIblXKpxltnZCy8oof1roRej0dZAb2LOb?=
 =?us-ascii?Q?nw+2MugIcN1NvQSDhigZ2Iy7IfNwNSCbyit+Fpbwd9maPY/uoq8X8AGj0PgR?=
 =?us-ascii?Q?19vD37IN0ikxdJaE4hwVBDmt9bb3jXnXzTkDtdEsY/5EDmy0f9VzfEhw81I9?=
 =?us-ascii?Q?Swcq2gKEpVu9Jw1jHeckQ8rJuFhMo6crT6M7ONMybN39b2nAkBd1V4WInzf8?=
 =?us-ascii?Q?tmFFjj8KUeIndv/pkYf9rh4YlmVTNK0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6fd3cb-4bde-43e8-3605-08da4e4cbba7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 21:27:50.8187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9nmWjCweeEmBvYjftqzRQPbfKubMLXw+JxWy/FKjja+OIkjvdHzTTPjuqARxWnpt+7JqvXGxGnXqy4l/QrCim68By9lTUYyLgTp2M0Kdfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5920
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thanks for the feedback! I'll include these changes in my next set.

On Tue, Jun 14, 2022 at 02:43:45PM -0600, Rob Herring wrote:
> On Fri, Jun 10, 2022 at 01:23:29PM -0700, Colin Foster wrote:
...
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - mscc,vsc7512-spi
> 
> '-spi' is redundant as we know what bus this is on looking at the 
> parent.
> 

Ahh... I see this now. A spi driver and an i2c driver (or otherwise)
can share the same compatible string, and the device tree sorts that
out for me. Thanks!

> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> 
> No size? That's odd given the child nodes are the same as memory mapped 
> peripherals which expect a size.

This one has gone back and forth a couple times. The base addresses were
hard-coded in the driver and kept out of the device tree. But I couldn't
explicitly differentiate between mfd children "mdio0" and "mdio1" below,
so I recently added the address cells back in. This way mfd_cell->of_reg
and mfd_cell->use_of_reg can be used.

Unless suggested otherwise, I'll add size in here. As it is right now,
that size will be essentially ignored though. The resources (base and
size) are all defined in drivers/mfd/ocelot-core.c during the last patch
of this series.

