Return-Path: <netdev+bounces-9978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE8672B8A6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D2E1281119
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCA8D2F5;
	Mon, 12 Jun 2023 07:34:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1E1AD2C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:34:10 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8E819B1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:29:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGNKB2wTzCMLEdhTsTvdfo70eZ20dkDeGdEuMqKR7OOPVW3crumRIILPayXdXWdcXlb1+/mTjEwDxvR4aUZMCrW1oUYt/kjEuqDgGR9PlLKNLyPUFatHaqvkNWYRUTtmjW85Cy56xVsS0yViZuxSkzrvYDwrnAruF63EKHTBDNTqmGGBfdvYzrFa8HSTE5ENDtKMOhQucjpdJoqV5aGNA7zLsKS37NJvkttthnsYNJK5IwVr6vQcMRmF95UDawIjU7Txxs/AT4Va1vMmbxaCTA+lVEQTJHCEank63kEmvQapDGTlRuYn9Jml+KHWUybbW754cliDZzb2BLqKwTsgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxeg+JjKT4NLb1EbPGOrytzusqDWd2xkOBl+u54wKPo=;
 b=OgBw86YJqkiqUPZWMT68ViykMAEA7uUhTCIWRNipg9lbO+0OR414euxU20BA+cqU0Q0NVaQQior8qnVdVGkz/eCa1OaH2qER9yRrrLDRWhQJ2jqdr/gfoOVvTLGLkc7XcXgk4rBdMOZnuWiexL5Mu4W6d8maVXYMT6y2gKd41efFsMF3RNcFAjw2cS2vGsBNxvDywI7K0lE0sFiHKfIcNQDl4X9lhSicewZ/AUC6A1NsHOgBO67G+V8T6N7UwDsW69CCSa/5Dpsxmhct2f/gF7H4RIdfc5Pqek+KNooypS0uoaNZGJ4dStyYKKWDZTpk55x5cZM0tlDSfFmdlGAaXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxeg+JjKT4NLb1EbPGOrytzusqDWd2xkOBl+u54wKPo=;
 b=CvY26uTi+IS+6DsnJ9283i0w/a3E0eARwgmWvVq2b6qpeN+dxdXRGppytAwFHhawx+mgJm3mQDjLaZQDDQG67QfzDrNHtvfGQpZ/oisF2h7ukl1PsLIA/K3i5LVmCtKoHI7/y8e4f/aJKHxrYCHmSkUaWHv+srYGpgEZy1BQgwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4723.namprd13.prod.outlook.com (2603:10b6:208:30e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 07:23:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 07:23:52 +0000
Date: Mon, 12 Jun 2023 09:23:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Ertman, David M" <david.m.ertman@intel.com>
Cc: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"daniel.machon@microchip.com" <daniel.machon@microchip.com>
Subject: Re: [PATCH iwl-next v3 06/10] ice: Flesh out implementation of
 support for SRIOV on bonded interface
Message-ID: <ZIbIATgSmqdPfWil@corigine.com>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
 <20230608180618.574171-7-david.m.ertman@intel.com>
 <ZILqX7x7RP/cN5+0@corigine.com>
 <MW5PR11MB58110D453C6E6BB15AD4A53ADD51A@MW5PR11MB5811.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR11MB58110D453C6E6BB15AD4A53ADD51A@MW5PR11MB5811.namprd11.prod.outlook.com>
X-ClientProxiedBy: AM4PR0902CA0014.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: 2302e987-3dcb-4b6a-6dc1-08db6b15f94c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gPX8pxBZKyFXHEgLRvEu9VpYWAOwA9XnypgVBFfklY39ENjsg52qIoX2dQjzAQCK/wGuo7XwVo/yaGf1GulUqZuwr/lutxYm6yId/WzMsB8BGqytH6WAUixJlpsFGHRRTZeGVKKohgCjUrFC/GJAoPfzyKXz+wNy6oQuQv1CzLUsf1tGofHIUYRA6IsJRtSQ8IZu6gcNKc9blXt4c3cnmr5NQmp5i/y7GkxufKA2K7HB9n/iwLN0icRfMBtNjM8WvUSmjzFRybA6+iSaahtJ+gSaWwY5GFwdhXK7q2oHsNVc68KeNtouhGg9iL1qRaD+s1tjHL00hbL0ggFxLpt4Swu3YV+MbdbemY38s6KKoiQgKzxasxNI/sM+5kcUuzRdVv3JjBDYGCJtPQRyFWn28TgJSPMi9gWIVjD/2HeEivrCh5wc78KwX6LoxX0N05YbVg+x41NjDocGB6qdINg4lQFv//pwTaKZOplxApBzXkzKgtkgmhlO4prm1AvhlJ02Mh2YHQj1RgxO9twdq/Qcki567vO5YbGA7rgMKY+GPNSHBjvIUN83McxPr8MdFLMKPu1EeXf03UuTVgV4ITry8pmjbnjV26k0nSc1juNpR7M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39830400003)(376002)(136003)(396003)(366004)(451199021)(66946007)(66476007)(66556008)(54906003)(478600001)(8676002)(5660300002)(8936002)(36756003)(6916009)(6666004)(4326008)(41300700001)(6486002)(316002)(38100700002)(186003)(6512007)(6506007)(2906002)(44832011)(86362001)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sMAVFteU/1BL3Ee0USoujUEOIWSISFe4eyI5EO05II904aDkH2l9tVg7Otw2?=
 =?us-ascii?Q?UXlZuw5aGizdE+lF9SQhTnXtV/0Ml6Gkqw2gmruP2YshHKvmh2+YPnOn3MOF?=
 =?us-ascii?Q?ZCK2FoouLpWxwXqM6tlnmiZomtudQua9/BmGPw1qi9xhiL7O60QBOu10B+We?=
 =?us-ascii?Q?nxS6bU0ZQYyuhCM0dbW4FK+IDJL3Ts8+QDbq9dJOvC6/h1sY4pOm1XRlg7IJ?=
 =?us-ascii?Q?tNuMhzYwtohjOCPLAEswVAS4nzPSS/rjkKdxdFb6MQQ2ZUX8Yxy+rKY9sKVH?=
 =?us-ascii?Q?bY+/Uk6QGBqV6UOonyQLcH5JF7se9sd9QNU9oarMHQdO3xy5Hw/XL5NJnmu7?=
 =?us-ascii?Q?G1Tn7dXRdOhkiD0/7J3hio9u6380cPUCZm15Qy0NjVPgzUo5Dde0EGzQaz76?=
 =?us-ascii?Q?kAeML8w9/Zzn4zMBnQv8syZtj7VqfsBPzVlZskaC4/u9MqCy2ApM3xBQ2Ost?=
 =?us-ascii?Q?w3RwOTKKVzmUmWaYvR6y80aZxHPv2gT+CXy4os5ybugpg6a+LCXMS+GP9bxt?=
 =?us-ascii?Q?VM+XGU+gNvS1Sf3rd25AkJKaa9cMRSc0B0sLvtDYhLykGuCTmtRSUyhV8avv?=
 =?us-ascii?Q?pq3RUDavfK1GLrWrm1ChZ180k0mDECxB2p/o4+Y+R5VOCgkNvxC1jKyLfcdk?=
 =?us-ascii?Q?IFBlqykySQVgbDPA50spbEPY/0eFjYMXAQneK1trq8iirAmf86pA+gisnP7W?=
 =?us-ascii?Q?H13ZHmlgxuvCkqTJrtXX0S3DMhWGhP5J0ki3b38hF9L78/62exkVxmR3Bnuu?=
 =?us-ascii?Q?STGkA/TDlsafdujlt8d4Qu20o/ZjvkSrkmarp9sPdhBm8c44FMTkiaYRCI3Q?=
 =?us-ascii?Q?pJZq0eycJZKJ67yqHMhNJNJiZFXAb8IVw2aWEg2Cxtx17b8mzxvQbHFp8Drt?=
 =?us-ascii?Q?NA7/06n9KvWynkDiyn9fCT8yZrZYQnqj5u968NI9rtX4sp66JhhaOaLsQ7Te?=
 =?us-ascii?Q?NMfbD6PLGgR2lEc8yj9/X9F+JoPz2b2zjiR443ECXXtk1+MMbxw2bSRCakvk?=
 =?us-ascii?Q?kI6750GWOtzfIMCpm5lcALkVPl8PWig8YfOL+j3GpDMcta74xaYDKAg7ZTFF?=
 =?us-ascii?Q?rL+YM5jz5l/3CemMwZjd9kUXRL4Qln5M46W4Y+2i+zAqeI1w6QpmP2KvBOjj?=
 =?us-ascii?Q?s5OA7vvs4+xUf7mWoeG9cQ+I66KllnAeSuMC8vSeinoeEzWi9g6xyfjyXX4g?=
 =?us-ascii?Q?0cl/AH0qMgEOgnHPnECFjZZ4BJp+qRbaii2Zf/gXQJ0YJRRwfzo9jZLWJrVZ?=
 =?us-ascii?Q?l62O9JomhPvlcz3UJY0h63MsAcalRH8X/OoDx4l8/+UEANik5ljbM3I1u9eV?=
 =?us-ascii?Q?aTaiQU515MjluM2hGwn/P16fIaXukYE7YXTGtW1msxa9dFjQROf51WzOUQ1e?=
 =?us-ascii?Q?sp4yCNQWe4e922z8nsqNI4J8jW90zZcRp/ilqmNzsbKLOW9slZMpHPoDQ5Uh?=
 =?us-ascii?Q?JrsRQbEysM5Ev684pG7KBIubc/jECDtV1fi9sp2e37iBJTXrIllDSisrQ+Gx?=
 =?us-ascii?Q?VbLYqyKkaUzJsBnlsgFw0gfDTTarYPaeXX3NDVmyBMIYwr7vStZz5t7C2Ok8?=
 =?us-ascii?Q?bUkahBwbdB3bMtDOeOngNi0DqsIApZUGngxjHlu2fYrPvUv7AHzZ0yLedMon?=
 =?us-ascii?Q?41XHwKOdGCfVDjrDb0NK4xRKCS31RgS8s0eQlff/8pvWB3oR7t4WCB2B1Plb?=
 =?us-ascii?Q?rkoqhA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2302e987-3dcb-4b6a-6dc1-08db6b15f94c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 07:23:52.5645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TA6XZaaRmsqkj4O2EelgnqCVPbH/OomZnXavOaSBsyAGnfvFxl3AuIpFl7rS3p8aNXbfIDgrvmZe+k+w8m+b7E0e7cJSRvx4Ay2clp0UcvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4723

On Fri, Jun 09, 2023 at 04:32:27PM +0000, Ertman, David M wrote:

...

> > > +	/* find parent in primary tree */
> > > +	pi = hw->port_info;
> > > +	tc_node = ice_sched_get_tc_node(pi, tc);
> > > +	if (!tc_node) {
> > > +		dev_warn(dev, "Failure to find TC node in failover tree\n");
> > > +		goto resume_reclaim;
> > > +	}
> > > +
> > > +	aggnode = ice_sched_get_agg_node(pi, tc_node,
> > ICE_DFLT_AGG_ID);
> > > +	if (!aggnode) {
> > > +		dev_warn(dev, "Failure to find aggreagte node in failover
> > tree\n");
> > > +		goto resume_reclaim;
> > > +	}
> > > +
> > > +	aggl = ice_sched_get_agg_layer(hw);
> > > +	vsil = ice_sched_get_vsi_layer(hw);
> > > +
> > > +	for (n = aggl + 1; n < vsil; n++)
> > > +		num_nodes[n] = 1;
> > > +
> > > +	for (n = 0; n < aggnode->num_children; n++) {
> > > +		n_prt = ice_sched_get_free_vsi_parent(hw, aggnode-
> > >children[n],
> > > +						      num_nodes);
> > > +		if (n_prt)
> > > +			break;
> > > +	}
> > > +
> > > +	/* if no free parent found - add one */
> > > +	if (!n_prt) {
> > 
> > Likewise, here too.
> 
> Actually, this code was refactored out into a subfunction in patch 10/10 for
> this series.  In the subfunction, n_prt is initialized to NULL (for purposes of
> using it as a return value.  I need to move that refactoring back into this
> patch since there are multiple uses this far back.  Thanks for pointing this
> one out to me!
> 
> I will send this change out in patch set v4!

Thanks,

much appreciated.

