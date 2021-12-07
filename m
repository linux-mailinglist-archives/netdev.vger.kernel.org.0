Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA71946C0DC
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhLGQoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:44:06 -0500
Received: from mail-dm6nam11on2139.outbound.protection.outlook.com ([40.107.223.139]:15360
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbhLGQoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 11:44:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hF26qskfeHlbOCmxX8FjDbqkFLST01lBeo4vQdIzBbUMK1TcNC9krpmVs6/Hagg4kWrNysoMOm+n7aFH7JQdTGBYgvel482CddRHCzq0B/LE+DMswWAxfrvEzCGlBpdL4DKnuD4mp4ER6A4Ra8DbWWvUs78xMb+LOZ7MC3jLj2BcNKInZKKkY2WoaFgadzjqvjiTXFdC5Jw2zsaMlMS6CCVnopWMDQeLPmKSY07mhOm2vKlzFE4aAwT+T2QxNXrQohm9szL56YWeK/xrtaaIdzrd0bih3HC+HiyPYvV3WKUPWPoMqB0eN1UtR6kP7g7DkigR7SWlrlH2MosiS0rC5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZButlkzGAV4iIu5Jbk0GV12oevlBAmkdGrphFjBOsbw=;
 b=LvZQI121npmtCS21UQn2boGvFOZW9ai7mtGDDgXeDkvknwYtJGCl69bevVbtxtszTSvpCNjiuV+vqNWIrAOahDeH80KR2Rck8QiqN0L7cl29MOCwujHeDklQIMXcDkhe6rZC1KuVbWKq34hIXTDQn90rL2RkWZcUOQ6nv6Nq/oz3W3nkzdDeYArO37EESls5kCMTKmK/qRSKG2jlL5YYBoepyD+nilTpe/H+6fxVDHerE9g6DFRBpJELJ//cDk18T9GHO6EWQ1jRvrIuxp5T1zOqKGkn5rC1nljQrn9I9iMQxjMyBZx/MromXbIH3Qy0WzAXEbPz9dw2CBojJa/wCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZButlkzGAV4iIu5Jbk0GV12oevlBAmkdGrphFjBOsbw=;
 b=LJ+lKM4N4WfE5+GUJ7D/+3UWSoWB5bZjugFDktmu5bSFXLkjh73nXrl0LO4ypl4tOGRCs+kjjAVBHncJsc0izHmgcbEAzVZkLs1gO5R0NElrs0xyaeX9Pu7jQ/x2m/Jc4X3z2JiEX7jkixAFb9zBiW94EUEvGTFqUz9ph1U75Kc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2174.namprd10.prod.outlook.com
 (2603:10b6:301:33::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 16:40:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 16:40:31 +0000
Date:   Tue, 7 Dec 2021 08:40:25 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Message-ID: <20211207164025.GA464@DESKTOP-LAINLKC.localdomain>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
 <20211204182858.1052710-6-colin.foster@in-advantage.com>
 <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Ya9KJAYEypSs6+dO@shell.armlinux.org.uk>
 <20211207121121.baoi23nxiitfshdk@skbuf>
 <20211207072652.36827870@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211207153011.xs5k3ir4jzftbxct@skbuf>
 <20211207073900.151725ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207073900.151725ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MW4PR04CA0356.namprd04.prod.outlook.com
 (2603:10b6:303:8a::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MW4PR04CA0356.namprd04.prod.outlook.com (2603:10b6:303:8a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Tue, 7 Dec 2021 16:40:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb411867-aafc-415a-9e56-08d9b9a0485d
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2174:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB21744D4B36806FB06A567207A46E9@MWHPR1001MB2174.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FSvRaPTExq9nxCT1Gh1IphgMzQ/lTlzXPfAo4YWZIKSzVUprn/ASOnDbqS90KFa5HTGbCg47JJqyQ0+xtPe9j7s3ja8QxJeqL3yZSXyrfe95WFimhh8Z0xb2eYt4HIHHJjEaUqrtVWDW8svhrzlPw6DTEkH4MfiLBAvDJ9DURHp9uqZUwuhtSi5LGXTre/+V9rvP6KCra3nbcG6PwkFO0OB1dfz2hINVVsQqEvGgWIhGR0bi76Ld7/AKmGpx8IwcsDVSAxGSNEiWRFf8pQ+O3JWH2nDTgKJVuWVvO5k71F3DQWiMDWl7uT8wo4TE2gbYtBQ9mxx349NUA/6U23EhgEADYvemkHXZ8b6g78YAEJVmtzFYWZXPnHUsLNUVBZT2Sij7E1/SXQWjHv0Zp/VMdKk7R6cIHVPEVa+YoZOmUbFstoP15rGS/gOwv+P1ensgzRFlq2W0LQrz7cMIvrQc1iuyCYtzWii+LA00b97Xwx4XUnA56Q0Qdz1aDYGabCw1bmDZhjxoTIRKHEiwgw33cgx9YkVtTwMSEgO+AnA3mtFOOXX6ga9EiHsqFhJoNBa93CfJGtYvcLUItI8L37uWdaOsm0DxGh/ZjKnIGeCwuvvhdWA+Adox72Y6VRvwZcuCvsMLum/gRULfmL57XfkuAeGsB/r403oBgljURW1nfzAogdHB7WqYWz63eRiCuUUITVyQps8z1dAXLqizNo1h5YjcEqVcM+mk0cDFwFrpz4B+oWeSuh/gK5Ayxgse0bxpxs64erEWsMvHlSGtddA574qqlXbpo6vEIv7vQHdx7eBzCTH0d6irz8HctsteUNAQoiXAFWPKTQZD5lXSaz4YCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39830400003)(396003)(376002)(346002)(86362001)(6666004)(33656002)(4326008)(44832011)(1076003)(8936002)(956004)(55016003)(9686003)(966005)(54906003)(186003)(2906002)(66556008)(316002)(6916009)(66476007)(83380400001)(508600001)(38350700002)(8676002)(38100700002)(7696005)(52116002)(7416002)(66946007)(6506007)(26005)(5660300002)(55000400008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G5z73mNc3UKZ/TiliomW2I1GpG2AMCvQry6TzY524ErV+e+toCX22hfbhViB?=
 =?us-ascii?Q?UYGdKw63/8Wk0r/TLD/2nZGqXbNPOwpwPy3BV2maAtlbpMYKaZztcIz+oQup?=
 =?us-ascii?Q?pnB5ZclG9SiPzFG/5vlI22hZiqJrUvSHIwj7jlMFdRj4uSOjZTf6r8ykRdag?=
 =?us-ascii?Q?aTnWWC4Vi/va6pMtVzOja4ZnEwXPXDM4hKfoKBG15tSAjY4zrrmoUS3PtaoR?=
 =?us-ascii?Q?Jpy1vROKLnbp9U21We0YjsSz5eGjkjFW1n0hEU9OIB9L58uEPxVAc6PpUy8N?=
 =?us-ascii?Q?D+nsck4+etHrKvzgGamkd4t95ztEO4MwQcx39tLbA0wflkYs7aJJmvyz7mw7?=
 =?us-ascii?Q?bOkBb4vGjtiqlo4xdVs1LJLd4J4+HPGGZl4K+lDjgNg7PVcllsYpdPY4mZta?=
 =?us-ascii?Q?8I2gpMG4wdQJVEObEI86TWzvYN8Otq9jhvH8TDcLotEGt9sZILRDqynV36ix?=
 =?us-ascii?Q?tj9XYhj/g9HT0azPLjIc9gKTgNDZ5qpkEOCXcGJaupXQ+5CRCJWk61yRmqmt?=
 =?us-ascii?Q?XoufKPLjDzsQzUrh0yGvXr/X4olGhpLQir9AJ92e0Dycjy6Qo5A8wrXfaL88?=
 =?us-ascii?Q?cvIWDNXIcDKfAP58Hle9lokUpkjSc/VA4BepZ/Xyi9wEJ3mXN5RrtYOroHlK?=
 =?us-ascii?Q?UrWBPgoPAlM40XhEfVMaFIxKWdpsSgBCq6H7mn7KCXCJoAl6WHC8VbMemU5x?=
 =?us-ascii?Q?JZB97mqbPbnjUHdDddhtMuEgLT1m+G2tw5XYHlTVbmah44e0/Wi1eXkaOYks?=
 =?us-ascii?Q?bBY39fB9AyJ5Nc1HstKGwhA66xLiY28SoDvtFxCCJmE0RjvpG/GM0KjgmMPb?=
 =?us-ascii?Q?qNi6EyF5cqIOVick9+8bimDYYGIuIhC6mAfbO7u46heiAL2jH6F1pTaVQX+E?=
 =?us-ascii?Q?NtuE0l9NoIX6FIQ3dl4me5lFkuwG8qkxIm97Q0RCeg3vL3YgCiXIrXRoXKIH?=
 =?us-ascii?Q?OjE4YLu6FvLGk4ynfLzmV3ECAstXOwIrJZ17v4+6gb2azTNbxCQOo5dgSwof?=
 =?us-ascii?Q?v767Pujzd/fnoNfa4hzaNj3ZE+Vq4rh1a0EA1HU9aggQmqvKy5TMaF74/FSF?=
 =?us-ascii?Q?KHWIox83bHwF5vcs5MGdGROwMPu568WMyDeIlq9EbNTWPFCGjsIEVTu+XCML?=
 =?us-ascii?Q?uoVO5dDqRg0WWstcHjAno+uhojFDhhljFphTgrQNncrYcrPQr3nuZ4TmeRI0?=
 =?us-ascii?Q?LyBUYssDbyR+DuC/a6lZBA0lfg1eh5693/XHkY2Zzb2M+HHBgAe+Rh8cQCEf?=
 =?us-ascii?Q?C+/qdZt/fPd+NeKs+Ti3xA7E39KSy1MbJvDpB5TEn3k+UKGh+wScMzf9uTqr?=
 =?us-ascii?Q?tbbY3YJ3ySC0kibffjPoykJwAI1qCMecSc9RZS4lls4ExjeHMo3oO4tIP/oJ?=
 =?us-ascii?Q?W9SB3on043e3JAyqJaZuqH+xkid0hRXs4GHPdF8Ct30OeZZJuXspYBW2U5tx?=
 =?us-ascii?Q?7ICxL235RMjJWI5PujlkMaXpTp1eDLo/CAyqD0GTZXnaIEeFGAFPqRGu3t1E?=
 =?us-ascii?Q?RXfvoSzvYgJGHFB0gA1qJ2OiWlrwwgLD+2GKogLz5tqTnu8YYPzjUPNbmqMF?=
 =?us-ascii?Q?33qy7QQP5g1ZXb7oQ59+c7lWn5h6ancD4v4z2G5B8eKBCYWqZVEwvMxRegGq?=
 =?us-ascii?Q?W4P7MQXVZrqs1BtUYbtUB2AyjhNAyY1JtVP4jH5tWefoMCG15u/S4Uzrde7p?=
 =?us-ascii?Q?1tkHzA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb411867-aafc-415a-9e56-08d9b9a0485d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 16:40:31.4503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIJJXK1GrWvblv8YlD+2BEcUsmykYfJzECc54j38Lk1LLv84wiVxpRNMqBasyEhg23L201U4zIqDJsoTUj9EBjz+HZMIVCFm6okqxEjJp94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 07:39:00AM -0800, Jakub Kicinski wrote:
> On Tue, 7 Dec 2021 15:30:12 +0000 Vladimir Oltean wrote:
> > On Tue, Dec 07, 2021 at 07:26:52AM -0800, Jakub Kicinski wrote:
> > > On Tue, 7 Dec 2021 12:11:22 +0000 Vladimir Oltean wrote:  
> > > > I'm not taking this as a spiteful comment either, it is a very fair point.
> > > > Colin had previously submitted this as part of a 23-patch series and it
> > > > was me who suggested that this change could go in as part of preparation
> > > > work right away:
> > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211116062328.1949151-1-colin.foster@in-advantage.com/#24596529
> > > > I didn't realize that in doing so with this particular change, we would
> > > > end up having some symbols exported by the ocelot switch lib that aren't
> > > > yet in use by other drivers. So yes, this would have to go in at the
> > > > same time as the driver submission itself.  
> > >
> > > I don't know the dependencies here (there are also pinctrl patches
> > > in the linked series) so I'll defer to you, if there is a reason to
> > > merge the unused symbols it needs to be spelled out, otherwise let's
> > > drop the last patch for now.  
> > 
> > I don't think there's any problem with dropping the last patch for now,
> > as that's the safer thing to do (Colin?), but just let us know whether
> > you prefer Colin to resend a 4-patch series, or you can pick this series
> > up without the last one.
> 
> Repost once it's confirmed that's the right course of action.
> I'll merge it right away.

I should be able to repost today without the last patch. It is an easy,
and resonable one to drag along with the larger ocelot_spi patches I
have in progress.

And I appreciate all the insight and feedback from everyone. Thanks for
helping me keep keep me on track!
