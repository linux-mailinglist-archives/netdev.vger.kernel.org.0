Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C0D69090A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBIMjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBIMjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:39:36 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2069.outbound.protection.outlook.com [40.107.105.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1919F5AB3B;
        Thu,  9 Feb 2023 04:39:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+VoHm9O/l4T+hiIC0wFDDDVUhfCXBNmXgZjpAsduV0XazxXTXpsDceh/IGnP3VdcLtsJOyV6iHkkFoVAtw48pF+W5lwt0Y+UnBQqRuDqWsecdMNkrb/WNeKnqBRHF52G5l6/inVi5zudnualodi4OZFqNIriW7UyGAqDRykowghQiHaWr43sWjT4R2oZjivFzOiW11Iov3ZGkNL81uRlVGmnB6FnFG6g4mjszVAzvNlmQgeB8N/llT4byPzZ79x9O3+bsK8cRSKOSp496CFhaTrYWYqPh8IUaHbEUt09zFPPVRLayAp2yNO6q6TfJ97f2JPYjdt/izKR1QrK2fI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ln8TLT6525EVeHH9+iA9rqveRL0eHPKYEiRCKRSmPBg=;
 b=YPBAdLtu9H/1LIg2aG9QAehdfPeLYz+XpVaTADmDaVEiGI54hVE74IcbnKlEtwq6cbGcErAHPFqgz2YD6mq9yUcuMcDX6Kx9dRSb5R8sTcVozW/RyTnEgQyw2FWcblBPppUA9B+XxGY84qBnRsApSxRV52b1umSHyiuc3zO+mv9OoNhd0fpVdH5kJMGQsVQGi4k8Sa5ERVoVl7UZGDF3K7JastP7RAI6J010BHYQSFl07ibfqpzldwf7UOsNn6teaxRmzmkXZkPbwrmpeL1DpXaDSbvqiBUBO6MgfUhd2yVdMUfDxWXjRWw1Niq+UJ9hY4EwAvSj+fYpVAxS/IpD3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kococonnector.com; dmarc=pass action=none
 header.from=kococonnector.com; dkim=pass header.d=kococonnector.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=KoCoConnector.onmicrosoft.com; s=selector2-KoCoConnector-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ln8TLT6525EVeHH9+iA9rqveRL0eHPKYEiRCKRSmPBg=;
 b=Wr0hzWnFHieQT7aeED+77xWfuSkpDAOzCLKOtKy/ZvdRS26tCoZPGe24cZHz2vJub0EGGXqqMg9oVfibGsVCENBjynkMSih1oPhPWH9yeLkfyAZUkCNMfqY9j0k+8FFyrjWvLbiMw3VuwVOd3sUMLUF1rMXRNojj+a5KSTHwEus=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kococonnector.com;
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com (2603:10a6:20b:281::9)
 by GV2PR09MB5795.eurprd09.prod.outlook.com (2603:10a6:150:af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 12:39:27 +0000
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::e9ab:975f:f6cf:e641]) by AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::e9ab:975f:f6cf:e641%3]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 12:39:27 +0000
Date:   Thu, 9 Feb 2023 13:39:17 +0100
From:   Oliver Graute <oliver.graute@kococonnector.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC] linux: net: phy: realtek: changing LED behaviour for
 RTL8211F
Message-ID: <20230209123917.GA1550@optiplex>
Mail-Followup-To: Simon Horman <simon.horman@corigine.com>, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20230209094405.12462-1-oliver.graute@kococonnector.com>
 <Y+TRj2hehU76+Ytu@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+TRj2hehU76+Ytu@corigine.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: FR0P281CA0089.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::11) To AM9PR09MB4884.eurprd09.prod.outlook.com
 (2603:10a6:20b:281::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR09MB4884:EE_|GV2PR09MB5795:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f81bea4-901e-4623-4afe-08db0a9aae88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9AVtj1nJWfqF5LffEVqsiwxqxP3D/d/GDFN7ZPNFi3jDEQesbUyJ3jde98uIlV6w6gANSnpnaV+7pK4sT+W0CUqKlADTOg3kWsAB840w2opbJXNRZePXA2F52d8ZdfhihlhOj4Q4rqLdTCEPJhy3h9tgooWlJ2kzzRv75EL3JTJkHtykpP6vriFyR+4+hILR2de0ft1VmrtdSdhjkH22Js2FvTqwZJ4SWaUgOCEkkv/dexinu++FTBZ0hR8n4NZzt85yhAoZPTjKZPU4apIeBK5UOol5lgFaqqdUfvm7ywn+sDGwqAzmn6a2mskRTxVv9+VNQu/Z+WU9ZTiSAWroko4vOjKfF/3DM0sxpbFV0uQ0Qji4Si5m72SMu0PYdUaCfLUa8p/um3FCRGuc4tsvRZp9l2blG9KcG1kSSjAvXpvNZ9yhnC0NoUr74u++EBbihqbIAn/hIQ2bd1Q77FrisPMPqOd1WOoctS1rndYfwnroMk+Zwvw5QADS9SuayIJx7L/gMipk3DA+YVLRj1GkXOPUJbOqWXRRXEGU5jaCqfxQg6wV7BPtPHHq/HNLKLrU8ECRQ977JQSef9GE8DpIWrXJYV7rVvyC5foMJlm8YLhRcdXF6SAokTjbzLnlQJsQJWsL1CZP/MC5qZxccdCQ90jLJZL3muH0E9fbpIDjGmv7hin57O0OHgN0Xpk407MIz2P6kzd0DV50R1ac3VDdFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR09MB4884.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(346002)(376002)(396003)(39830400003)(136003)(451199018)(6512007)(44832011)(186003)(9686003)(6506007)(26005)(2906002)(1076003)(6666004)(7416002)(33656002)(5660300002)(478600001)(6486002)(8936002)(41300700001)(52116002)(8676002)(66946007)(4326008)(66476007)(6916009)(33716001)(66556008)(86362001)(54906003)(316002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n7TJQ+mSWFpiP1r30FF4XnN8Xrpe8sq5TSflHWT675K+RV0nGVv3lfwO9OO9?=
 =?us-ascii?Q?Mobq6BWycim/95LsJpNVYxZfQX1n0xjmk1SxyXXeKl8JTL6108H2+t7cp3SN?=
 =?us-ascii?Q?0w45f2FNtEvzuhzJVWXiR4pUxsSDU5bRGy0TZXUDKJj9P7cZMjMB1p72QXwC?=
 =?us-ascii?Q?dSDeZVxtRzQWAlP/JO+UEAbQ9z/hMvgpbUvN73Laht+ZNXK+dIPxWEl3933l?=
 =?us-ascii?Q?yeERMy28f65kRSoWymcjU6UkGA1RKE37YH0C6WF1JQsHQLbJczgJK2Ps4qDd?=
 =?us-ascii?Q?IyDeZeARdmZYhd0xu1lyLFSknOG7f5s2QvYs9LAGYNSjXLPx0h1Lx4cOiH9I?=
 =?us-ascii?Q?CRxQo1KNN4vVfQpoENYOUOEMR+yIyu0Bg9NqhwsYDYzy66FfTDQPzoUe5Vat?=
 =?us-ascii?Q?G51zdYlMDLC+K5MccNdQLYEXKiTvkhvF1kPbQS1zG9ZMshfY9cihf1eIbCnG?=
 =?us-ascii?Q?/x9C44ub27fx78eUJVaSWoNNSH0CB+KqX9+vkCI0JpkWH1psuuUPSJHZJxcj?=
 =?us-ascii?Q?XQ1uk1zwFTK1QHDDvXsZv+g8baQshmeKHxMWM/Ny3CV3MRBovGdlJb93tHy1?=
 =?us-ascii?Q?womuePS0xanoIcfTAIcytA77LoP9pe873CKDkNiVc8MJOGofkqTX/T9ejztv?=
 =?us-ascii?Q?gtTjvWmdhEsaBnzBtOHyUUsnJgZH1vTYgjf6E6/GJ8hSzg1kYEAK2nzcOOJZ?=
 =?us-ascii?Q?xS3GMved5d1SjTFiRW+X8/il9PqBZExBl4yyq+SOb56MMH/g1uJmPw09GSEk?=
 =?us-ascii?Q?+MQ23/dzigZvCzinRtOCq/DZB3UtLk/+piCsJFYl6F7fYBJRHrO/VeUbFevM?=
 =?us-ascii?Q?0f2DTQ6RAFRHgTZun4xjQllHP/u2109qDLD1DlupLiukaU9jJ5H9K2YgpK97?=
 =?us-ascii?Q?qb7VjO1PUAyosYD1lJOukocxVgWKVXxHPSYMbx7kuYShbQ5vyhqjLJqu635O?=
 =?us-ascii?Q?NZrogCq8+sIzV63t3ojp9YHa1gqpvXiXrz4v5XCRFF1Oy2GiX+iBue0kMf97?=
 =?us-ascii?Q?OOyOmtz/gj0wp9biqHyhBO/bWlyhnA1tq7bfL3le0JnRchGcLOvfL9Ajs4e1?=
 =?us-ascii?Q?IyGRPZCh5VrRJESbeEneEwcOcNGDP45ClPUUSX+o4GzeKuYIHsGN3ssVbV2z?=
 =?us-ascii?Q?8H13Lrd187OVf4ama+QazLo7Fg7sFwtFp2lqT1/CxRv9gRSvgzXAXlS5Dh+Q?=
 =?us-ascii?Q?qo+ZzJHuixA4JmcKBJlUJcqHyiRPDO3alAuUKsqtZA4fBsCK9xzj2VyNZwy5?=
 =?us-ascii?Q?0LTax8M+jnRDp3aEJRGfU5+yiwrYYlbAiXLxW53OnfDtGbcvQPEyrwtsQMzt?=
 =?us-ascii?Q?Q+1Q/tMTJxQz91ATLYYMD5m+qUH9U+WvulX2isNiLv4zuTgL6qbOdo/IWd7M?=
 =?us-ascii?Q?pP+CQYfXT64qI7ZwG1fgVZ9UIhguOxM+f4P+Zy+4/+SQ0FQxsuLz6vZyVSmx?=
 =?us-ascii?Q?CeNKvkOz+p0iUdXJJm1usC7sKizKvPKzA6ElsKZPTyLVj7u8p3O4uTcIY5nW?=
 =?us-ascii?Q?O/07WE9benBXytaNHl83h6NmZn8e8KZGWlfoaMIQ1cgCPMNh39dGK2j/eOeR?=
 =?us-ascii?Q?sCWPNUltOBh1R/Jah9Nh6QmktY/8AqgUgJypqPEc8eM0twteo3vkHXG+4TJs?=
 =?us-ascii?Q?8rmJ1v7FEBn/JQmOVjLiI0s=3D?=
X-OriginatorOrg: kococonnector.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f81bea4-901e-4623-4afe-08db0a9aae88
X-MS-Exchange-CrossTenant-AuthSource: AM9PR09MB4884.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 12:39:27.4028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 59845429-0644-4099-bd7e-17fba65a2f2b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzxPPZmgE9fX2KQPy7LCNb4ghDzbMg+i8j2I5l0Lv19R/L3VdVMsjRgWNYfyNpK4hdBgz0Tqp/QQrmPN0jqaPtUj4UuhCvV7xOdLR1oF+hQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR09MB5795
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/23, Simon Horman wrote:
> On Thu, Feb 09, 2023 at 10:44:05AM +0100, Oliver Graute wrote:
> > This enable the LEDs for network activity and 100/1000Link for the RTL8211F
> > 
> > Signed-off-by: Oliver Graute <oliver.graute@kococonnector.com>
> > ---
> >  drivers/net/phy/realtek.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index 3d99fd6664d7..5c796883cad3 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -416,6 +416,11 @@ static int rtl8211f_config_init(struct phy_device *phydev)
> >  		}
> >  	}
> >  
> > +        phy_write(phydev, RTL821x_PAGE_SELECT, 0xd04);
> > +        phy_write(phydev, 0x10, 0x15B);
> > +
> > +        phy_write(phydev, RTL821x_PAGE_SELECT, 0x0);
> > +
> 
> nit: it looks like the indentation in the new lines above should
>      be using a single tab rather than 8 spaces.

thx, I will fix the indentation. 

is this the right place to turn on the realtek phy LEDs for RTL8211F?

Best regards,

Oliver
