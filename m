Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E332953B76D
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 12:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiFBKjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 06:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiFBKju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 06:39:50 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17FD2B1948;
        Thu,  2 Jun 2022 03:39:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiKIxq8tze1Oj/0osaTRxCK+QVOB0ANJzRV4O93QjWiIEh1KNcTuNicSBvRNpYTIE8cmlzI/GfDiOZoii6tcqCcLdwsiyASYcw0Fyf0cGPunOjxmLGCw5OwuSNwMYMTAb9HHajkal9cESRAIo4BULY4TT4TlqTGPbOPbCYUbKVW64LCW91H19Wj20C2TRuSxK1uxNwHER/HgUa3BRem6HFvvRVHwbwwfhhRS/oPTKq1C35vJzVKypUNtmQ7PQQdJ6ALF5uDKyz1W7X88mewyqIybK4TlNJGwWAGXZCbuVviIFc6Rx9ZGYxAidr9YwMJwiG0QAynsIj+U6THoO/Mbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Hti23nIs2ldA8URv63TWmu8urjddBIYQjraIy/empM=;
 b=gXjW8dPcfk8/SSo9HsdE+HXIyWt0BnLa7+S+7mphr95ZxsHP77SdczPowu6hzMayyGK22QFCoxEOHFyQmgKtAyGIa721TvvHxTtseQoFB8axrKF5K0SP10HNd3FTh4uJP4zw53gOg7uRj10lDX3IuiGWhCUkTM3bwU1370CxOiWFxsWNruoByV17NjDzJGZi/cK1238skKUppq5sQp+qPfFqxK+G3K7v3R4r72re6GlYOd/VACHMk1AHKEdQ7oEO6OFsXccM9uODTkWLAjvtSyUotXDJuL9YGWC4Em4dBu96DzR9SJrzj+MCNx5hi/M1hmfnbWHTPfkLbS39ps/6CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Hti23nIs2ldA8URv63TWmu8urjddBIYQjraIy/empM=;
 b=DZsVZT5ONS7KS8MslJ5s7sR3CftB/l9EBW7lkbSnQEQ8GqWtbOISephYvEI8tr/vSO1fPQRUf+0ezGL8ODahw5XpI+4herUmxZNDClNp1XqOYMjPIfroOGhiy+R9FMif1DN9BvkLNITRHRXwaZ4+tNkh5XFxZchUr7h4mX0NP4GtcfDqRHofQN8ZlFBXTplMc01S46FEDDKkHHkyIRetaEqL1eh/eo45P0vaN9Rpfg56jmd9shaKVdHreaGXlsI040qqW103fG1ru81fHFKUOg0sajGwHe+mDII/AfRqLd03SOwTQyR8Uqlg+hhXY/awvKIAotxwXL+CekaXFqusyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3643.namprd12.prod.outlook.com (2603:10b6:5:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18; Thu, 2 Jun
 2022 10:39:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5314.012; Thu, 2 Jun 2022
 10:39:47 +0000
Date:   Thu, 2 Jun 2022 13:39:40 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Hans Schultz <schultz.hans@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <YpiTbOsh0HBMwiTE@shredder>
References: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder>
 <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder>
 <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder>
 <86y1yfzap3.fsf@gmail.com>
 <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
 <86sfonjroi.fsf@gmail.com>
 <3d93d46d-c484-da0a-c12c-80e83eba31c9@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d93d46d-c484-da0a-c12c-80e83eba31c9@blackwall.org>
X-ClientProxiedBy: VI1P195CA0060.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::49) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc81194a-eccb-432f-2e0e-08da4484369a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3643:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB36434DE79F978864921073B2B2DE9@DM6PR12MB3643.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z51/a6yWwYHJBWleTap3bbpv25V6GdJTEBtbQo7REobTVBe7aza/YPMzJBvBX2BpSh9PE9CBBasG/3VCVGXZHtWf1+yZIKftDJhzl09xBbcnxTdQR4hqTcyqpZWR+iEby7nTBekAUueMUheGsDHTNlNRuMTov6YNpxMWCCFTL0iXF+a4r/NQV66JgBU+d2mmiTZ11KotZ9Bz79T3xr6yCZJXaAi7yPBB32TfV7RfWYbc7UW96GzupJaGOwyK0xIpBOYu8aDLNE2AxwyqmoRltcfBzrQ4su0lXOsmZ7FCvaDiYoJWdHIkdRUXXZ99qNh1ZzLyDrm6PXS3Xo73VFyM0rsC9lZf6b4QWQCFJVjbw2iFOFJaU3MnDwU+uAeo1wwiybyNaNQXSI8XlLSxQ00q2KRElvRu5PAXwA5VRSORwntYG081ZQf5tkM7t8zrToFQUhKDfP0n1e/vDCof+oWb5JQhxZUvGrx5k5B4AtFgj1Zrw0fW9W77lXvBjJ3r/fZKGUsW5sT1gonatSUb2+OwYx67cqsCchU9Ucv16aRtFA0MCHQqpjD2Au0Vh4gkbGbyzLccajE8AcC72xb9BuFoG/e/FQhMnvqoUt+GEjJx7YjwJlVdTK4WG5vVJc36GXKn/DG5WtZQdPxwERXnhO0vBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(83380400001)(6486002)(186003)(53546011)(54906003)(6666004)(38100700002)(6916009)(316002)(5660300002)(8936002)(7416002)(6506007)(508600001)(26005)(66476007)(66556008)(4326008)(6512007)(8676002)(33716001)(9686003)(66946007)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hvYbZk7GANGFXKIzpLDGtD1yCCXXUSynfU1Cf+4Ou+8zNVoJvnQxInkkpfJ0?=
 =?us-ascii?Q?dlRc1ulEmmrs3s6TSj/ideWujmHyiyt9j3sNhxaqmu/el6yxVT+RB+0fLpw3?=
 =?us-ascii?Q?CZ0fpXIdv1dK2D/BE7T04j9HFEwBinwWdtlyaQMPu5tKq5FnvtJpx9YRjhZX?=
 =?us-ascii?Q?2ayb0lIVSo6NYHxiUK+H8IhuvNdsoUIRGtKuiUhAEnvPzXgMGmvM2G6zuQP4?=
 =?us-ascii?Q?gn8YqCsaYRkgevIFy9/Txgvnrt9jMj8xnMVnxrYvuVKK3P5RhRX+CMTRz+HX?=
 =?us-ascii?Q?5ug4i2Xvi5fQOzoJxY9M4z3Yvq9MV6KhkyDdKqOpxXDOrKgymM5kwQXIaVqM?=
 =?us-ascii?Q?NguXh/xdQRBQ8Qh9+OK2rulPGCHK0w9yW78I4NvbLqj0jRYKeV4v2f4iGfR2?=
 =?us-ascii?Q?vTHGdOAnrEB2su1rLm+RDG48mUM90VD/wsChK5znrQJNAm06Yh2fsz3mR0eA?=
 =?us-ascii?Q?PpNXnCoS5Lk8SKMXvCR6H35FYyncDKX8OPFHJiJwE6UijPwBKccRoeg1gnep?=
 =?us-ascii?Q?cuNZ+/FdP2JPi00AStEWIfz1hGdXaeANdutPckZR7gq66A1eaokPCqFVoDFE?=
 =?us-ascii?Q?odYqwhXcxP2v1Jim26+Q05dbHhOk5TgxE5SG5FxZicOrxQwv1zzHEqIowdZK?=
 =?us-ascii?Q?sllmNYMg+6XNOKZu4vs3aJ98k71u0iMe5oFhR1DEban7e6x90J1+7iCr9dIn?=
 =?us-ascii?Q?0rKiG7B6r2qmmIAtYZpF5iiJhglKFsiv9cXjUtbSeqc9S1dAgf/OUms3z3KP?=
 =?us-ascii?Q?QTXocywM6Uw6knfUnnqK492gsEjFy7ZRLmC42mNdiwqEDyWbqlnFiHUdauc0?=
 =?us-ascii?Q?LS3I1KZsajKi4+mEfR5RAdIIgZ3a7bDFmwnI7eUiGjCAWpSuVke9Eq9yaURT?=
 =?us-ascii?Q?xfhP7nBejAw+zCvlbniYhrIO6JgQS696stXfEF2C4/CAaPMzFFyJCew4EGDG?=
 =?us-ascii?Q?z7LHqwMaf1ZiIl+ICMiawb3/pQSrSElU9SmQxfSjULadQMgTxrpsmtIEtfz6?=
 =?us-ascii?Q?N/P/VQ3KfQ2mLEKKYaqStF7yr1cIETq7EgqA9DA0cOtZw95qoma/yJpwc0jp?=
 =?us-ascii?Q?UqAASZ7K1tMYTy9TjdRsPjyiILTMBlR7EJwg7XwfVqfN0xmelPqqmSaAPu/e?=
 =?us-ascii?Q?VFgvbmUXh1odrX4T7sjWcasmpw/3Z4tUHd5zze/Di4mBbXk29aNRji2GZseP?=
 =?us-ascii?Q?4aUX7wxgV2Vg2zL21fRALPTnWN0pXbFw/g29GoF49jMYvyj2AMvy5ReJYdln?=
 =?us-ascii?Q?t2QF12MAfTG2RgN9Df283Rao1wgJy7soVNyRwN7M7OIYpoSw0hMG1hgi4EEl?=
 =?us-ascii?Q?5cAz6j/PMQ1ivOhcH72gzvBtVNbVE3CoE7Y+6nmas6p9ckcmz2WmcoY4Y5EH?=
 =?us-ascii?Q?f881R5w/ev0Ryc/VTs9lBTY+4hE2BqdW8JaBBtusgOnAy6E5ZXjHry3eQohf?=
 =?us-ascii?Q?83fuhcaGBhMN8sLxvvk2cudV/9zdGOy/wurgK4aytV9YOaAxDQ9cacGqYfW9?=
 =?us-ascii?Q?xQp5xeRxCu/eBsWWsGLDqkUmc7XTOKZ3WQGc3WA4qDF6XxlwEaVwp2HqGYmg?=
 =?us-ascii?Q?qYu+wC7qzk5zclyMcl8yRt8Ere5eJZtl4wtwK4QjvMAB/yt88jWcg9F08mQR?=
 =?us-ascii?Q?oIpNtPY+axC8Rn9zD+l+dVq5yyMcDKbr2TJ50+4bg2nStY6cFQhT3uj7SXrO?=
 =?us-ascii?Q?QB87ZXn46073c9FwBa83N5uETkOcYXlvcCnbyO3vIeEdIZVpWlP/CLY2iF91?=
 =?us-ascii?Q?8G8zpYZ9Cw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc81194a-eccb-432f-2e0e-08da4484369a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 10:39:47.1135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q458DZd4favqNssFgNFI9LPsrYZRlVIRccL8dUEgGPX/FdonJIbrFkozCdOxG7veHXtwAlLdo10f18MVlzRAjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3643
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 01:30:06PM +0300, Nikolay Aleksandrov wrote:
> On 02/06/2022 13:17, Hans Schultz wrote:
> > On tor, jun 02, 2022 at 12:33, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> >> On 02/06/2022 12:17, Hans Schultz wrote:
> >>> On tis, maj 31, 2022 at 17:23, Ido Schimmel <idosch@nvidia.com> wrote:
> >>>> On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:
> > 
> >>> Another issue is that
> >>> bridge fdb add MAC dev DEV master static
> >>> seems to add the entry with the SELF flag set, which I don't think is
> >>> what we would want it to do or?
> >>
> >> I don't see such thing (hacked iproute2 to print the flags before cmd):
> >> $ bridge fdb add 00:11:22:33:44:55 dev vnet110 master static
> >> flags 0x4
> >>
> >> 0x4 = NTF_MASTER only
> >>
> > 
> > I also get 0x4 from iproute2, but I still get SELF entries when I look
> > with:
> > bridge fdb show dev DEV
> > 
> 
> after the above add:
> $ bridge fdb show dev vnet110 | grep 00:11
> 00:11:22:33:44:55 master virbr0 static

I think Hans is testing with mv88e6xxx which dumps entries directly from
HW via ndo_fdb_dump(). See dsa_slave_port_fdb_do_dump() which sets
NTF_SELF.

Hans, are you seeing the entry twice? Once with 'master' and once with
'self'?

> 
> >>> Also the replace command is not really supported properly as it is. I
> >>> have made a fix for that which looks something like this:
> >>>
> >>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> >>> index 6cbb27e3b976..f43aa204f375 100644
> >>> --- a/net/bridge/br_fdb.c
> >>> +++ b/net/bridge/br_fdb.c
> >>> @@ -917,6 +917,9 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
> >>>                 if (flags & NLM_F_EXCL)
> >>>                         return -EEXIST;
> >>>  
> >>> +               if (flags & NLM_F_REPLACE)
> >>> +                       modified = true;
> >>> +
> >>>                 if (READ_ONCE(fdb->dst) != source) {
> >>>                         WRITE_ONCE(fdb->dst, source);
> >>>                         modified = true;
> >>>
> >>> The argument for always sending notifications to the driver in the case
> >>> of replace is that a replace command will refresh the entries timeout if
> >>> the entry is the same. Any thoughts on this?
> >>
> >> I don't think so. It always updates its "used" timer, not its "updated" timer which is the one
> >> for expire. A replace that doesn't actually change anything on the entry shouldn't generate
> >> a notification.
> > 
> > Okay, so then there is missing checks on flags as the issue arose from
> > replacing locked entries with dynamic entries. I will do another fix
> > based on flags as modified needs to be true for the driver to get notified.
> 
