Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003016B1F6D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjCIJIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCIJI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:08:27 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2129.outbound.protection.outlook.com [40.107.223.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2800311E98
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:08:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2HI0t913vse3czNvkR9NxNKEa1QIUYJJuiBnopa/rFlQDAb7GSmvLl8VwWusaLnPFyLbXoH2nIG1emF43pfTqB9FVjIgqxeiYMd5cfUMNq7TXtOtAvzrXrmYyWmHU+i/rDFaMqB2kDoaSRCiKqoYIigbsG28cw47i6VsT735qaUdl7H8c0xzv7iLTIIV1/gtuiy7FCffsXX+b8pi80sg7ppSHlMHZK2T7Qf6KbXAhkFpI+9AG1V+TTwaclvxyU0HMP8SJoqGiFwZ/x3NsDLo6TYjiLd6w8BOP/9xD8+MXq6pS3BvcvX492yekjbL4CYRAMiwZHwYXTbV+LTyWxacA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rs4TvunfBN9rNDJf83YL8S8WMpkDe68PramF9PVgNI=;
 b=d+4/WPfnBuKe8uh/59+wQ9G/uWIoKbYqr7ntSVK6xdxxLoP7tqlyQUTnP3Q53elhIzdbFQWosv2q2dOJ5IUaV299XkSGgyPWPD9nQHmjn7zJ//W4bqnEXMl2KFJMROawTicPE++zj9gKCEoNoC3X4SXOocuX1o/AoN1TaVdnhAPP1g11pjYJRyJhxTrbeVunLQu80GyRuCzv0z78mrRXjpNXwQGeEVJXYP3G5cNA2iRAmJG2h/qgXO3Odm1/xo2pArCKzKiYrCTh0BMDlw1krA2++FlrpocDP2rumjzDN/ke85o6WACGiF4OB/F3ft8sz9m2yINTCIdt+y/XO7PJdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rs4TvunfBN9rNDJf83YL8S8WMpkDe68PramF9PVgNI=;
 b=MZFQ2bCUIL2AtUst3BD4BreT+7tCZqzUto3R6g8okg9xQtkLV6ER3z4AdMEhgahMabcH1vhNY1okUHQ1Fopj/ps7RW4mVyTnDWxjkQZm8/P2LM3DrFdkmr8r2HsKTvtQC4gYr0SgXtnxYOcUzBN38DYYXML5+ZnL/286H5uVr+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5703.namprd13.prod.outlook.com (2603:10b6:303:165::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 09:07:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 09:07:57 +0000
Date:   Thu, 9 Mar 2023 10:07:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        pabeni@redhat.com, robh+dt@kernel.org, krzk+dt@kernel.org,
        arinc.unal@arinc9.com, Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net-next v4] net: dsa: realtek: rtl8365mb: add change_mtu
Message-ID: <ZAmh54kNGDUEay3H@corigine.com>
References: <20230307210245.542-1-luizluca@gmail.com>
 <ZAh5ocHELAK9PSux@corigine.com>
 <CAJq09z7U75Qe_oW3vbNmG=QaKFQW_zuFyNqjg0HAPPHh3t71Qg@mail.gmail.com>
 <20230308224529.10674df1@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308224529.10674df1@kernel.org>
X-ClientProxiedBy: AS4P250CA0025.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5703:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d716d11-dda0-4574-352b-08db207dc646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2QyWgFXW8NaDZ7sYVV5PfE9Knscn6Xe63zDFpNkGTFQKUmEMWSeKaI6JacEeGo3P+n+pONvhKFEP+5L/uy4V48Gx29cTl4QNPh/H6QLAnGpyLbz2wo66wdruMpoQpb148+hxqt1AOMovGCOfuTZOKSCjkkwvIm+Zw+xWvbsF5Ga1D/VHqokevkcnoA0Vte4wsQ/+3FlDhfnGogL90WG0zAz+O8DQJrKb1giSGWgqvfVxapva/dFPQoVgxgDvJ0ZBV88L3YDSYI5+ARnNWGiE9Dz2bZsAtdkVMtirq2Pkz8v+izM7V4h0OpzK4CqNeFfz9N7NglNNAXGh8eVIBV1loV80CloPpB0Rh0YQTjBy6st6N9WlGi4Oj9pLmseJNC2o+yOKUZ53KWpFcChocmRoUEvwEgiiY9f8ho70Ez2vxlVwHjSYWlw2RLczaOoKKH6RLlK5mPN2zwxoWWRy59RSG48q5WuOeH64NRxNTwb39ZnVuh731U2nHQ1ReOw8+Zl8k+byAmCAvK7DaNp7ssxW+xOp4hqcmSU2p590jEdGIL3uNoVcOZXi98HafkeXdMUZ+WFuWtCruNXdjMlZZ50fwB/6qQrtm7UFFaihtYhXZevouNWMZ5ET5VWc6Afxn9DiAD28d6lK8WI8g8/077jww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(346002)(376002)(39840400004)(136003)(451199018)(36756003)(316002)(54906003)(478600001)(6486002)(8936002)(7416002)(5660300002)(2906002)(44832011)(66556008)(66476007)(8676002)(4326008)(6916009)(66946007)(41300700001)(86362001)(38100700002)(186003)(2616005)(6666004)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/zbrU+4alRjT4cVtm8or7xutOZ3MozkLZEfnYP0S4nIsfAk+6uFnbgLkVcVy?=
 =?us-ascii?Q?NsCMOWYdWzCi4NDpxRnaJB14LNzbv6cs6T6GIYAS80vY26032PEgzw+VMvBI?=
 =?us-ascii?Q?9lgIQgzBRsV1K8NaJxuqimF26T/CsXjUxSpc3BpEJRrZF7WrGXuL8I7mjOX4?=
 =?us-ascii?Q?/7H0bF1hzeVfNMOnkFXt1e8U/Vtkk0/K/ObrUJdY64OsKNlVg8BPSjk+K87/?=
 =?us-ascii?Q?CDQ8LLRyaQGr+iteMjf8DPsvsTqwM6qf5s8UIzuNtImy5/0vx9n7Ztt/2DAT?=
 =?us-ascii?Q?/UL8LVkdSYjVxZvfEjH98DLV3HMdH36nyyCNuD4S/dGJCiFmYaBaXQidCRNT?=
 =?us-ascii?Q?8dYeKGiDWbiv/Evov9N9GxWh7d1fVJTIoCnbDuro/OsM0phd/uNOdEbgp/pt?=
 =?us-ascii?Q?/KTsVwuexE+isZhCgJYY+zqIKdWpDLEOZt/OQsfcGcHxJIjbDMiTAn6bUCD1?=
 =?us-ascii?Q?U+UiIbojeC+iNmMRXkkcRoVysbNeMw9MLQRB0CT/kWuvHR1Lt5Z3B8wBrDF8?=
 =?us-ascii?Q?NSPl11dEGiYoOYCXqAAz0Z0HXGeKh5VoAGrKNyB5blkoHT4MqG6hXetzYmIL?=
 =?us-ascii?Q?SNLdIuH9Xv94X7hUS+liJJkNAz+Hx2ex5u0+eHyAYq/UPkiUqhsyoFwcd2Fe?=
 =?us-ascii?Q?kuW+w4neF3L0cOGY6cSPqgl4Bfnmrxz37scslhkayCBbF0nAtYtrwC0rroTZ?=
 =?us-ascii?Q?J/U+lU6x26qeu3LMJzLS6JBjXghNMm4rrqOizJz4dv78ECdc7YvNecmJAjn5?=
 =?us-ascii?Q?z92tQmnr1DdzCru4D1p4aBZIhV6jRtwm5Iq+xYOVmrFJw5fnFS8VD63crYUa?=
 =?us-ascii?Q?8mIT8M4NgIuF7lcWIwDJHHbk/cs3aq2PJA8I5l4VIWm/LNquaC4ovaG8Dvag?=
 =?us-ascii?Q?NI/yOWNkvoJNpBWY3Or00uw765N1MldpzZqTOyReHqc3I+oMrknn0R02B0Yu?=
 =?us-ascii?Q?mzj8/SgdVXVXjOXkgO2eDbgboRXB2dY++4YloK2MPrn1OfIYHCykgiK71H5+?=
 =?us-ascii?Q?z33mDOl863R282B9hv+/jl/Mej7WgZbYfty5FdwMpeukATnn6hdOKbRXbnXx?=
 =?us-ascii?Q?cDsv3vv/R0+oaIlQe7d5PIHIuB1KUgAreRwV51jleQe61gRvrQDAbKM6k0c0?=
 =?us-ascii?Q?OTvIBRHnPALmpQe3axg0LJrI6J7pmZFdsohriHP2e7jUwIHXxReeZ5h64YHQ?=
 =?us-ascii?Q?y5bU6r0vDal/28hfk0WhGzsZbLYYpYwlAblaXNefO2219ONhhPpxMuCfmfjz?=
 =?us-ascii?Q?4yzbUz0nJUr3nbU7fLZFYc3jtjD3sgR0FsWmahCfR18rWmhpOBnCdZ8IN3VE?=
 =?us-ascii?Q?Fw7njc2O+8nGGv5XIGi5mR5vJzO1qsW6PegL4aGQovSOiH6Dc86erFlYbK+a?=
 =?us-ascii?Q?2yUaj9ZFAaKbGye0SQ8XCSAIMr0XcbpMAEohP90htM6Zvjkf5uWkcWkPLPl2?=
 =?us-ascii?Q?0SiVToP6kDNTjSBp4mzvG6PIgsEecYYE9iNxADp99XFVi2CSl85A5pEX61yw?=
 =?us-ascii?Q?7NnW/ccpoP6eSQCmCgnBD+Ttc2LgQj8+5Anc63yrpeLDKr74qZ84b85xbHI4?=
 =?us-ascii?Q?R8holnUVUmyO2TvbFNvT80Yq0ORahy0nv+W/mXsSx8bT4m9JNvqrFLtHJlUe?=
 =?us-ascii?Q?nhGvdZBhhRE8voOMRaArZK175N9Rj8s+RfQUr/bpSl868wI43+I9947iBEOI?=
 =?us-ascii?Q?KNNEAg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d716d11-dda0-4574-352b-08db207dc646
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 09:07:57.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nCGkN8wDw0RGZU+tIknqjX5VnT+FgAz2yX/aeDcE06Y9PdqIAmDKUdanPfk4R9AJ9X6LTic7c9MVJulpyQZXFQz1J1eJNJpK/5piVu4HNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5703
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 10:45:29PM -0800, Jakub Kicinski wrote:
> On Wed, 8 Mar 2023 14:10:59 -0300 Luiz Angelo Daros de Luca wrote:
> > > Perhaps I am misreading this, perhaps it was discussed elsewhere (I did
> > > look), and perhaps it's not important. But prior to this
> > > patch a value of 1536 is used. Whereas with this patch the
> > > value, calculated in rtl8365mb_port_change_mtu, is
> > > ETH_DATA_LEN + VLAN_ETH_HLEN + ETH_FCS_LEN = 1500 + 18 + 4 = 1522.  
> > 
> > That value, as mentioned in the commit message, probably came from
> > rtl8366rb driver jumbo frame settings.
> > The "rtl8366rb family" has 4 levels of jumbo frame size:
> > 
> > #define RTL8366RB_SGCR_MAX_LENGTH_1522          RTL8366RB_SGCR_MAX_LENGTH(0x0)
> > #define RTL8366RB_SGCR_MAX_LENGTH_1536          RTL8366RB_SGCR_MAX_LENGTH(0x1)
> > #define RTL8366RB_SGCR_MAX_LENGTH_1552          RTL8366RB_SGCR_MAX_LENGTH(0x2)
> > #define RTL8366RB_SGCR_MAX_LENGTH_16000         RTL8366RB_SGCR_MAX_LENGTH(0x3)
> > 
> > The first one might be the sum you did. I don't know what 1536 and
> > 1552 are for. However, if those cases increase the MTU as well, the
> > code will handle it.
> > During my tests, changing those similar values or disabling jumbo
> > frames wasn't enough to change the switch behavior. As "rtl8365mb
> > family" can control frame size byte by byte, I believe it ignores the
> > old jumbo registers.
> > 
> > The 1522 size is already in use by other drivers. If there is
> > something that requires more room without increasing the MTU, like
> > QinQ, we would need to add that extra length to the
> > rtl8365mb_port_change_mtu formula and not the initial value. If not,
> > the switch will have different frame limits when the user leaves the
> > default 1500 MTU or when it changes and reverts the MTU size.
> 
> Could I trouble you for v5 with some form of this explanation in the
> commit message?

FWIIW, that would address my concern.
