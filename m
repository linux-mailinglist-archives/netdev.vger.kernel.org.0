Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C732B5444D8
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 09:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbiFIHdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 03:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiFIHdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 03:33:02 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2112.outbound.protection.outlook.com [40.107.100.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF61193C3;
        Thu,  9 Jun 2022 00:33:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dhz7a1/OlccMciAvMBep4NmVL/K0Fp91orKEcVP2zjqAyRhYKPKnT0676qX0e8SfVUaC3vA4IIFjL0FaG0PJd4Wu/IQbrxMPkMT6z6nZdicpnlOBg91whc+UmK+Unvigp7MP21xhzeGEaRtmxQXE/kKwrVu9m6Dhg6iv6VTUJl42VtivxJvNqz0JzjlW+u8x0jl2zVgT5QNJvPvKNayiAvAbkTe13Lj8rmR1L6ittmM047YhAKLrGej4gE2Wp8WUZYGPyBgkJiAXGa0lq/Btm9nJwcpN/d4NuS0Y3xN7yvOBEAb+pnuI2Bv9mjl/JkR0NpPp0zUz4PuFa+FxqTazDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAO/HBAxT6pKMJrVxbGKvkDNhSkoGob78SxwZaEwk4c=;
 b=F+AoH+Vhqi8pJXTonXpfqoLoruir2C7EhV/ptA3Imr05BXWMWkfQP81xIbSWbM81iiSO+OH1AKjFwveJ8u0qyChsahMKfnMYazvyVarStexhoMhEmFuRXyFymhe7XQN4GnKOMaLPmxPuSNTjpC0vv9/5q7n1c0POwJxo6EWiLrQlVnx6rmY5UXJRYwMN+40dKUwtLV1MUCj9kTROOSYC0b7/xlnCH4WgUjuvaaDsG/voewRqEqumRbzvehmyvLMSqEmkNDjF4osNM1Q3DGoqcJhvSPDOj8v9AgdTLC74jbjU3RaAtlJ66pFJKE3zJ0ioELVdmst3OBFVdnlsGx4Z+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAO/HBAxT6pKMJrVxbGKvkDNhSkoGob78SxwZaEwk4c=;
 b=jGKgSiqqeo92U4vMlXuWiYq/JWwTwv40+2YZXrSTzQ6wci2InHhc5T9BTOJkz+LmEfwrRM5hmPX4fClD3r1PSOag70YPZu1Uy5raTYtKmvsBJO8gophHu8trTeFsQ3qcLXJI7FqFavFm+vvt8wYwUxmCginYTP+jVx1CCU7UNww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3506.namprd13.prod.outlook.com (2603:10b6:a03:1ac::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.5; Thu, 9 Jun
 2022 07:32:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Thu, 9 Jun 2022
 07:32:58 +0000
Date:   Thu, 9 Jun 2022 09:32:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] nfp: flower: Remove usage of the deprecated
 ida_simple_xxx API
Message-ID: <YqGiJEKi06k/JVMk@corigine.com>
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
 <721abecd2f40bed319ab9fb3feebbea8431b73ed.1644532467.git.christophe.jaillet@wanadoo.fr>
 <0ad7ff2c-a5ad-1e5f-b186-0a43ce55057c@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ad7ff2c-a5ad-1e5f-b186-0a43ce55057c@wanadoo.fr>
X-ClientProxiedBy: AM9P193CA0023.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 898c8fd3-afbf-4a62-154b-08da49ea468e
X-MS-TrafficTypeDiagnostic: BY5PR13MB3506:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB35060E8EC6F5FD8B130FA4CEE8A79@BY5PR13MB3506.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q77GCjInYISfQhk9DzkggLR95J6UvEew+wrmlezYdBYrGY9Hep02R16q6WItgt4ab6ySq4gJSPbJj22+OlivRscH3Hs2q7AsxohSb8ZUX30SJ2h9JJlAFQ2I2LDl6P+v2237ely8S1JmwKc26jqetGIlKjbGet02ktQw0wow8hNwEW+zXBQyCBAibQW/7qZWSaxhrSWvu3HN4FrHrmSewUZqdTSOajhM83OZITuiUpeukPkLKdH/YQVrT4tkkjBeX5U1oaCxQK2yFNXMc2Q6ftlGBcOGyVSKwHVjJp8s80dXWDD1wwVqkDUg13NPBI6pM4Dpz8HumKMug8g1eEJBiIpMggHWhAnHtoQegl1sL08ah+JRSBDoiBRz7qGGFofMjdZU47m+5HMDua5atPq5xGJqnskYpJmCUqz7BqYust2CypJtzbD4KCPDQzmiJtTMtujilCRVJk4D/X5JCnTNGRxQGKaDqWjjLUkCz4BRSR1/INq2H/1GA32zidqDt51KWOqvvZ9uPxpMInSQYGZZD9lyubYxsx0e2LRCmuUpKey/NYjtKMxcfoKBEu6ITuS6wQ9IrpSFzx0+x9dr1CMWRE9IneShDuVcMsHbPgmLyrRGomuIaBai0L76eLD0YNWIQveMGmVPkJA4kR2PxJLB8ylpcCQ5xc6CbT/M0ymvtGVbmITS7w4DWxh+JHjaGHWH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(136003)(39840400004)(366004)(396003)(66476007)(66556008)(54906003)(36756003)(83380400001)(4326008)(8676002)(6916009)(66946007)(2616005)(66574015)(41300700001)(316002)(186003)(6512007)(2906002)(52116002)(86362001)(5660300002)(8936002)(38100700002)(6666004)(6506007)(6486002)(44832011)(508600001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2E4THVOYWlKbStDaUpCWEZoUUNSaVZnUjN1eUtBc25EQTFIaVRES3lXOU9v?=
 =?utf-8?B?NzAwdDBYWHgxN1hWbFlQak5ZaFhmQ3RoYjNqeG5YY0tvVlJVZWhoYWFPekFi?=
 =?utf-8?B?MTY5d2VNeG9mMzdweW9FOEIwb0c4Rm1SbDRWM25aNDVqYmZrQkhrTUYyc1Z1?=
 =?utf-8?B?ajlibThISjdmTy9STWhtMyswMXpFSHRPQjZtN2hwSHh3MjJiM2dpd2xBemJM?=
 =?utf-8?B?N1ppWmxKQUdHMVBVcWNwbXB0WUkxWllMTzA5dGU4b2RJSC84ci9hZE5zYmJu?=
 =?utf-8?B?cDFhSCtjRisxNXJndDNHaENobVlxcnlwNEFjQlpzWHV6U3UvOXJ5Zldob1I1?=
 =?utf-8?B?Ti93NlRwbEIraUNpbzUzTWlheGFCTkNNTjQxVW5md2RaMGNZQ2pobG9tcU1B?=
 =?utf-8?B?b1J3amtDcU5FbVFidk1tMVRnN0VEZ1N3MmRPRnpLeGRJMkY2c0pEbWFEQUt5?=
 =?utf-8?B?RkhUYVlyNDRSdXBGZUNzWnpLRCtUSW5JVzJoQTVrMFdzYmdHakRqS00vMTVa?=
 =?utf-8?B?LzkzNTNBVUxJNGZQVmcxZnFLaDZoOGMrNjRKaFZ1MFY4dXVTNXM5dEtFdEs2?=
 =?utf-8?B?aVJMc2J4OWFXK1NmL3pRa0RhWmMvVm84T29acTV2enR1TStuS01XU0FxcUhu?=
 =?utf-8?B?R2hEallZNVErWFN4OTVvNys4TWk0Qm9sb291ai8wYjJSdC80WUk2NjBSckZw?=
 =?utf-8?B?ZWdpNC9LTnljOFI1cHRUREFCZEFXeGhRVGRONUYwWXFVQTBNV1BpOVlWY1NW?=
 =?utf-8?B?bUs1dTJKZlVGNUVNbXM4NXpIN3NFd0k0RllsVHhjeEVINklJdG5oQnJhTUEr?=
 =?utf-8?B?MjZ0dWZEMUwzQmI5YTB6ZHhyWUdZc1AvbTlWRzBUVXl4MzFZQUlTTmVhc0VI?=
 =?utf-8?B?eCtmUDFEWWI0REEvNXRqSGl4cFd1VUxmYnlsU2pnNDlnZGFvTE1yeDZMTSt4?=
 =?utf-8?B?b3h3SkpGVVoxbGlKblpWcHdPY1AzR0ZUUit1aEpHSDBVN1Q4VlIvckNzU3k4?=
 =?utf-8?B?RHNDU3ZxVUJKWHJWMFZpbU5zWXZEYUdHbmtrNVFTV2lMaVQ1a1JxclF1WVRC?=
 =?utf-8?B?VzRWSFRjWVc4b1FieWJKZE5LQnRsVUl2WVVjM3F4aUcyQ0t1ZitmYTluQW4y?=
 =?utf-8?B?ZzBaVkltZ0szdzB4eVNCTTNBcEdKeVIrNEkyUFhhT3FTYm5rOEdVSUJIMWsx?=
 =?utf-8?B?TVFlNjF5bS9IQldkVFZlVndOem1vSTZjZWRBd2Nra1VsVURtb1BXNDV4d01F?=
 =?utf-8?B?RzdqNXprRTVtZXduQThGWUsySGN2SitQTWJqKzV3UXQvb0hkZHhQUndqQ3lQ?=
 =?utf-8?B?YlM5M3pXUmgrRytjejRQdG9DSExFTmFXL0F6djhaYjAxVUoweURNWE5OUjJU?=
 =?utf-8?B?L3lhdjZhZFhXMFJPVjlXMmV3YTk3R1lsQkt2enN4V1ZQLzFlMHRRbXlMTzFm?=
 =?utf-8?B?Z21HdE9waElBbVRkYkloS1pRa3lwVjh2OWZZQWpqT2RPeW9ON3FQNGlVdUhN?=
 =?utf-8?B?Y2gzaUZjSUhYOTFCUkNsY0FYRjlWWDJ6OUF1aFdaZllWWHVWRnh3MzR5cXBD?=
 =?utf-8?B?UTRqSlp6Y29SaktHNm8wZHQyOGNKV2VSZTdncTR3T2lpYXdCaThCcjlaSEQ4?=
 =?utf-8?B?bUVpWDRyOGhRdHBEV1ZWazNxM1VEaHRhYitnUDFSRXZXNUsvM3lQc2ZnVFRa?=
 =?utf-8?B?OFE2RVl0cWw0SDM4eGdEM2hJeXRnWWQzSVFvQWZOb29kQ1pNaUExV08vajFJ?=
 =?utf-8?B?V2hpNnVPR2FhVnpXMkF5eFZQU3IyRnNrWGJzQW5Ed1ZBck5zNnBwcW5oNHZL?=
 =?utf-8?B?VmlFUDJQN0dWTlYzbzV1d1JLNEF2SWd3NVN0YTRPVFpiZDZzbjI3amlvVC9Q?=
 =?utf-8?B?Sno5TmxKdHgxSmpURXNVWW5YalBCaG42VmErdDF0bmhDM3lvUWJOWnJDaFZO?=
 =?utf-8?B?UFZlbjdKQmxzUzJQdDM2VERkWnJjWUJMUFpQU05wWHd0OWJrRXpaSTFJeERU?=
 =?utf-8?B?K0UrRWVhUi95ZlphMUZuZnhVc3JTcVRyRXVVSDVsenNDem1HS1BHYlNjN0tr?=
 =?utf-8?B?RUJBdm14YjJWNDVzMW9WVnQ3RVRMLzNRais2bmJmOVZCbDBOaFc2YzRCNGsy?=
 =?utf-8?B?bzdDdndiUURoRHllWXd4MG42WEZ5Wit3T3ROdUluMXA5U0tNRzJLOGd3T1Jm?=
 =?utf-8?B?MHUvR3cvZys3U0JHR3NQUFl3QWZSU1JGc3FrV0FndU5pQ2ZXN0FDeDdhei9o?=
 =?utf-8?B?d0dUMEdianhSbk5UcmRabDhTWFFvUWdhKzhWdEFoVUxxMk5raWNxZER1OXlz?=
 =?utf-8?B?eEdadzBIbTRyMG1MZU5iVnptRXBTY3V0ZmtPYitRSU41YzNLL2N1VE9NMFp0?=
 =?utf-8?Q?psAPoR9cGi4KnZemRIDW9OLWhpWeUlAFWI+hizNf/ao0m?=
X-MS-Exchange-AntiSpam-MessageData-1: LTD28JHB0+eVIfH72sggHORBi+2o9uzMCa0=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898c8fd3-afbf-4a62-154b-08da49ea468e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 07:32:58.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35LSEAiq8tBEgtz7C4UdpqXechAZ4O6NExLaaFHnBYRX5ZubW/LlQ8NE32v346wIPq+C2p6+m25fz66d6+z+fEwQgFCaOQKtkooNPEbRers=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3506
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 07:11:14AM +0200, Christophe JAILLET wrote:
> Le 10/02/2022 à 23:35, Christophe JAILLET a écrit :
> > Use ida_alloc_xxx()/ida_free() instead to
> > ida_simple_get()/ida_simple_remove().
> > The latter is deprecated and more verbose.
> > 
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> >   .../net/ethernet/netronome/nfp/flower/tunnel_conf.c    | 10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > index 9244b35e3855..c71bd555f482 100644
> > --- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > +++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > @@ -942,8 +942,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
> >   	if (!nfp_mac_idx) {
> >   		/* Assign a global index if non-repr or MAC is now shared. */
> >   		if (entry || !port) {
> > -			ida_idx = ida_simple_get(&priv->tun.mac_off_ids, 0,
> > -						 NFP_MAX_MAC_INDEX, GFP_KERNEL);
> > +			ida_idx = ida_alloc_max(&priv->tun.mac_off_ids,
> > +						NFP_MAX_MAC_INDEX, GFP_KERNEL);
> >   			if (ida_idx < 0)
> >   				return ida_idx;
> > @@ -998,7 +998,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
> >   	kfree(entry);
> >   err_free_ida:
> >   	if (ida_idx != -1)
> > -		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
> > +		ida_free(&priv->tun.mac_off_ids, ida_idx);
> >   	return err;
> >   }
> > @@ -1061,7 +1061,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
> >   		}
> >   		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
> > -		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
> > +		ida_free(&priv->tun.mac_off_ids, ida_idx);
> >   		entry->index = nfp_mac_idx;
> >   		return 0;
> >   	}
> > @@ -1081,7 +1081,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
> >   	/* If MAC has global ID then extract and free the ida entry. */
> >   	if (nfp_tunnel_is_mac_idx_global(nfp_mac_idx)) {
> >   		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
> > -		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
> > +		ida_free(&priv->tun.mac_off_ids, ida_idx);
> >   	}
> >   	kfree(entry);
> 
> Hi,
> 
> This has been merged in -next in commit 432509013f66 but for some reason I
> looked at it again.
> 
> 
> I just wanted to point out that this patch DOES change the behavior of the
> driver because ida_simple_get() is exclusive of the upper bound, while
> ida_alloc_max() is inclusive.
> 
> So, knowing that NFP_MAX_MAC_INDEX = 0xff = 255, with the previous code
> 'ida_idx' was 0 ... 254.
> Now it is 0 ... 255.
> 
> This still looks good to me, because NFP_MAX_MAC_INDEX is still not a power
> of 2.
> 
> 
> But if 255 is a reserved value for whatever reason, then this patch has
> introduced a bug (apologies for it).
> 
> The change of behavior should have been mentioned in the commit description.
> So I wanted to make sure you was aware in case a follow-up fix is needed.

Hi Christophe,

thanks for bringing this to my attention.

When I made my initial review of the patch I did not notice this subtle
change. However, subsequently, the Corigine team did notice and our
conclusion is that it is fine: the code correctly handles all expected
values including 255.

Kind regards,
Simon
