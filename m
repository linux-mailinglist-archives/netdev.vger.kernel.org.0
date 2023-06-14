Return-Path: <netdev+bounces-10850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6B57308AB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9080F1C20D7D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B92111CA3;
	Wed, 14 Jun 2023 19:44:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EEF2EC11
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:44:51 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2104.outbound.protection.outlook.com [40.107.100.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F1C171C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:44:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aI/Wfc9qYrdUKk/Y5lMKhkHX5yBIcrGHDo9KbJcd+Oua9WV7CBqdZDJbNIEa5HQzUQFpUET0UCUtjMfgDg9cMiEoriXq1S2AMfXkqtek85z/VmsQ8FWN+yuVb2svGQy5ax4CczykuxTpEfYcj5S+767eQ5NegnMhyTHC5Z86Yy/CHkri6sMPzkwhFlEASB+rpK9DcynIBDNS7ijdIC3EbGiowF20dhOFWV5oduN8HxLDjK/PsPvouVKidgITMV2XJCugwRRp8POR19jlKFqxEDZzxnr+Grna0K2f4igvxkp6G7+1pEhIDf2HR3Lh3Xm81b6+w1KT+hAqnHHhmUFwwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nF6lAbUUXqoqAVLDg90FLJru/bdYK0h//T+tAggTYE=;
 b=Evrkkzjb1IZUHPfKx3prN+4DlBlU9VJlJRe25GrVfj0HAcz2+ocSYJKwPKrSPGI0sr1Iolu+cAoc4WMFwavdnHC/nwZP8tjQnMJhNLzAhri/Nc+xvYw5uDYVBTRmsT4KTbZ849jKN0y9YzgSgQVcO2i1NxUOP2CtMt1Gjo4KQo2oYpr6uFwKhEvMjuRinSERxKGUfjcCP8HIMkEQx/9CBH3Uf6yVvlZpNBq9TTGvUOBiKZpEQadRuLgv1GOC+aDimEEWkcLG24IFcGIT8A8hnZjRTySsZXr4Nq/i7SutkRg3H84dp8nb/4QfLcaAAHeJdEIuRh5OoKzKY8ndzF+8Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nF6lAbUUXqoqAVLDg90FLJru/bdYK0h//T+tAggTYE=;
 b=pVnAMkpZGwd/aJTPns8Y2Q2r5FVJYxOP1H6fqbE7Qqjvioclp7KhjYBity5V1kiSKDbAy30i7z515fGbq1DskSHR76rrgvVpitcqL9E3ikZrKx9Mn2B+X5GggIKPSHY+EjYEIfghq4YZReWSkx5A1z1vjYihLWotDY02mzPSjOc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3830.namprd13.prod.outlook.com (2603:10b6:610:9e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 19:44:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 19:44:27 +0000
Date: Wed, 14 Jun 2023 21:44:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Ertman, David M" <david.m.ertman@intel.com>
Cc: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"daniel.machon@microchip.com" <daniel.machon@microchip.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iwl-next v4 02/10] ice: Add driver support for firmware
 changes for LAG
Message-ID: <ZIoYlZzmK7oR/E7h@corigine.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-3-david.m.ertman@intel.com>
 <ZImh4NunKEpay3zu@corigine.com>
 <MW5PR11MB5811EF2458CF3AC2A083C64CDD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW5PR11MB5811EF2458CF3AC2A083C64CDD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
X-ClientProxiedBy: AM0PR02CA0186.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3830:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eae88cf-19c2-46ff-1e4d-08db6d0fc363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1Saibx9TfaOuAnmyyU0qxQGNvZQLiJM1MModrab4X1qf0PjJOjFklirvHYZZmfSXIz8dBzvpghDDuSoqFQ2zNGSUHWyIblNKK3H/HPOL5FFj4AY25xYU7CKKHw4qo2gjLVJ0ucr8WDu02Ca0pg5saJvrUq7DnvvDjCvANkjeBp1+c+AMA3Z8L46oXQiyHZ1Ksq+dddS2egJgkV8U46TTk2baaN4w63tVn3VE6t/9EOeZpX+ftPIgpwPvomWpwvqlvuJ3vvctkqLqMxUeL3jjHtUDT6lkZVrCKR2VEFlk2NktZJguXolgKs029EeG34RT1Iew+nZDNjGYhPF/h/+74hQJkresEEV+0bLlY3hLwVVO6XRuuS9XmUAn0jdPSKNx9n7vbEcM60tWuFE3gXn6uiRoXsz69d1vws6aQAdn/XsmTa2Yw5ODkErRGOr4IU9MVzvrSUZtxpBH5tFFMjJlxOyLeu0YPM/GLAcnE/CSQoDOgi4QBPnydDDRoiVOaaHs1y8L+6JUYuc9jlzOcTbLJINC+I/+RgHM9b0ChHYa5+3KD727E2HosT0IoRG77Ydwrp6BgpvAoRtboWvkIG81IlNXubApmw6yNC6vXbQ5qF0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199021)(6916009)(66946007)(66556008)(4326008)(36756003)(186003)(54906003)(478600001)(2616005)(2906002)(66476007)(8676002)(6666004)(316002)(41300700001)(86362001)(6486002)(6506007)(53546011)(8936002)(44832011)(83380400001)(5660300002)(38100700002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajF4T2xVdm56RTFVYkdTWUMxOWlPS3E1Yk5LTXV4YWtTTVlFS1JQMFdlUHZM?=
 =?utf-8?B?aFhlOHZuR3pRT0hlcDlXSi9LeDJvcmRlTXVsbSs5RHZHWE5XbUZOTUEwVjd0?=
 =?utf-8?B?d00yYlJab2tXTFRjRHg4T2FzallUWlRjMGxGNlM0Um9wY3pmU0FLeEhUNlpO?=
 =?utf-8?B?NUhKdG9wRmdxaFFDUnplTkRNcVlpTDdIeWZqQ3IyWXVXRldLVXBDOFBPQzhr?=
 =?utf-8?B?ZURIRTJMS2gwTU9FNzNvYnY1UWFZWmVmVHpsTk5YNjZFYVcwTFA4V3M5Vm1T?=
 =?utf-8?B?dzg3cmdMWmo4U3gvOHFKajRHOFYvQ2tPc2VQQkp1R2tqR2hrdjBBK29SVFpJ?=
 =?utf-8?B?TkFJa0ZMUnd3Z2pVVS9uaDJCbXNQOFEzcGhoTUJla2R1ZmoremkzV2d6QUN6?=
 =?utf-8?B?T2xPOEFaRmdMY1pMK0JBOG1lVUgvZkNVY2R6VHA3TnllSjcwLzdqbmJJUmRw?=
 =?utf-8?B?WEo2VG9iYUhtRm5EOTZaL2JOUUhNWFljY2h3aEpjbzNSQnlJMVQ5ZjZLbkpw?=
 =?utf-8?B?WGlDd3J2Y1M2TjdvNCtTTDVaRmdIVlZpeVVVSG1icmVBOTBEU29hV002UDRu?=
 =?utf-8?B?K21ub2VBenE3bER4TEwwU1NBcFl5OUI0VWt1bVZIMmVXemdtWld0Rzg2bnlO?=
 =?utf-8?B?clRzUUc2VnZRS3h0KzJKWGw0MGVqa1dSK2lGQlBtZnNVMXFiWjJuMW0wd3d6?=
 =?utf-8?B?SUdYQWNHOGYwOXdQQTBEN2R6alJ2cHpJRUhNR3FIMlM1ME91RGNIMWphWk9I?=
 =?utf-8?B?RDJmNEdxcW1hUEdNSjZ6VEtrQXp5dmpUcjc1WlhjTDg2UjEzb29xV1VubkxW?=
 =?utf-8?B?SnhyMExwOHNkSGNXU2hvRUpmR3BQSGNjRzBUai9hRmw3T2NEb2JqWmtJTkph?=
 =?utf-8?B?OTNOaFdTZ1JZeWFZQlJodVdpMWFqRHhNZ09HelhtSlNvUFlaQW1VREhINmlO?=
 =?utf-8?B?T0VncjlpdVpvSkNuRW80Snl3cTI2MmtHcDFvQlN4S3pwWndnTVpkSlVaaDdq?=
 =?utf-8?B?Q1BuWi9UMDFJM2J2eHAwdXphVTV5L2VmempvZ1FzVmhhbVlJNHpHV1g0Y091?=
 =?utf-8?B?dERhVGRyQUt6cnZMVlN4LzJxeUlZWWhyclFVMU1POUVFdGFDU1RiaC9sS0oy?=
 =?utf-8?B?Y21meUZxTkNUSjgvV3dtVHovSE1TWjNXbVNXQkpmNXV3NCtlS1hXb3FBQ0lz?=
 =?utf-8?B?S0VxZ2ZlN1pxWlhkOFduTzFpSW5xZEYvWkdvUExhTjJuUVd0dDcyOUpKSElY?=
 =?utf-8?B?UWFMM3BMZFk2ampuVFBHSkx6L3dzY2JPa2w0RVRPWGVSbGxMV2VvZlQrditw?=
 =?utf-8?B?cWxvcTRkTDhOTi9sVmwvUllmOWZHWFpPTFZUbnllbTgxblR3QUFYa2lkREpP?=
 =?utf-8?B?VEtlSjYwS0I4S0JFd1g5NVBSQlFQWjdHU2NLTDcranhJck1CcFBXQkF3L3pi?=
 =?utf-8?B?dHpmd2tCR21GNW13VEVNUDQyVWl3UmR5Z2lvRktVRVZGUGEvZkdZdnBEaUlM?=
 =?utf-8?B?dWJuZFB2MXkxMVp2dGVyZTlvL3NVZE14aUcwWU1aT25NZ1lER2wzWkUrU3VR?=
 =?utf-8?B?My9MSXFZOU02K1hkWm8rcEd3eG5leUZuUHdMMjFVRi9ocDBDRGtxaHNad3dm?=
 =?utf-8?B?c1hyeEptb3dwc2tMUnoweDFuL01MVnZ6a0NibUVXcm1rYUJSMHZub2dhYzNl?=
 =?utf-8?B?eTV3SXdGUlFXYUZ6ODRKR1Z6Ti9mZXljczViYll2aXdlelZxclB3cjJCTUpQ?=
 =?utf-8?B?OGVXWTUyQ0Y4R1RXQU8ycjhnYnlFZ2ViZE9neVplZ2pWZk9nRGY1Y1BJTmRM?=
 =?utf-8?B?aElUZk9IWnJpSzZtb2ZMcS9sUGt1UXJHL0dLZzhwR0pZaFlNWHNBVnRRSXpW?=
 =?utf-8?B?RDZ4ZjVsSFRwZUtzdXNhMzl6WFg3MjBaMFpQWGJXcjlSYnl6cllJZHdyNEti?=
 =?utf-8?B?US9qS1BVcWpwb0pxNnM0bGd4bmF3S3hhd0d5NE9uQXNWNmRLNWF3QXcwWkM0?=
 =?utf-8?B?ek9SZWUwMXZmcVdXdGsrdy9uUWhoTXJGTHdqekRlQ0dDQU1DNlBvWkN6d1NT?=
 =?utf-8?B?c3lQTFRoTWd2cStrQkJQWXl6aEMvMmhqUWJZTVFkUjJkQVhUc3JkQWkwUlVj?=
 =?utf-8?B?VVI0eEhyN0wrZVVmZVhRdjhOcFk4dlJPb0NBcXl1akY2UHJQQ0dycnkvbnRs?=
 =?utf-8?B?OVdRU1dKK0VVNmxPeUt1QUdVQzNrbnBoMDJUMXg1bythSnkxQ2pGRUxyMlFH?=
 =?utf-8?B?ZG10dGxmb2FMWVhVL21Zb2d4VXBRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eae88cf-19c2-46ff-1e4d-08db6d0fc363
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 19:44:27.4234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CXidWWyqrLPbReeFhJ5x20qnAu3LAwHYHRo0+JBkMSKKGXiNeD+MHhJZ1PvMbraE6CY6sEBh31/aNzkcrXUVRSXBZ5vaX1HVsdKNXoh+i4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3830
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 04:56:53PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Simon Horman <simon.horman@corigine.com>
> > Sent: Wednesday, June 14, 2023 4:18 AM
> > To: Ertman, David M <david.m.ertman@intel.com>
> > Cc: intel-wired-lan@lists.osuosl.org; daniel.machon@microchip.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH iwl-next v4 02/10] ice: Add driver support for firmware
> > changes for LAG
> > 
> > On Fri, Jun 09, 2023 at 02:16:18PM -0700, Dave Ertman wrote:
> > 
> > ...
> > 
> > Hi Dave,
> > 
> > some minor feedback from my side.
> > 
> > > @@ -5576,10 +5579,18 @@ static int __init ice_module_init(void)
> > >  		return -ENOMEM;
> > >  	}
> > >
> > > +	ice_lag_wq = alloc_ordered_workqueue("ice_lag_wq", 0);
> > > +	if (!ice_lag_wq) {
> > > +		pr_err("Failed to create LAG workqueue\n");
> > 
> > Is the allocation failure already logged by core code?
> > If so, perhaps this is unnecessary?
> 
> I do not see any messaging from the core, so I should probably leave this here
> unless you can point out something I missed 😊

Let's keep it :)

...

