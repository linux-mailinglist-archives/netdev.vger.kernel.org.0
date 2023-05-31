Return-Path: <netdev+bounces-6654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C75171738C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 04:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7201F2813E7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A691385;
	Wed, 31 May 2023 02:12:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323E61374;
	Wed, 31 May 2023 02:12:30 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0FC11F;
	Tue, 30 May 2023 19:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685499147; x=1717035147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S9ZY3VaSSm7oTSVmj4xojks4eDhPVvbQ02ONH9B76u4=;
  b=PWujg11T3Tml8bd8epfXS3LsmAo6pM731etEoEQBNKv9D8WXIips/Nb4
   G7KMprsmw1lrjiWf2hpLdfipwAdZG3nyDckD/rQbahp1BdTf44pZa7ASI
   z41fYz6abOeNhDD0IPewfep5FaY0EMWqQESrTz/RqFEbKvZu5+gfz6enR
   6EfmlW3xvdZEq+VLDy/OSqsRsxyZB+ZchqMz9OX/hZMNwySvc5fTAGRiR
   nD3Ks3v32R39qjhhbo6+59/NYOkFXzjvmNV111EGDhv0GPVgToZ8+F4xb
   Yl7TRLIJ7HBjDBqlbGe4wisqfB+bwyl4VtULwGUDdJgb1lccqfcsKpT+u
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441466531"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="441466531"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 19:12:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="819082336"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="819082336"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 30 May 2023 19:12:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 19:12:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 19:12:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 19:12:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1NhM2fNi3Q7jyKZBFiN7Owp0dsHjWDBpfySIJk8TH2/NSPXfQa7RW+9peR7mhRl1PhvaeBHK/3An8K2PgB0lJUkNcVt7MLuVg4K4ZKv0iDJ3175EeUZ0/JuQvJQsxDc1pA9QoxCpj3gz/JFS4wkNb6ReN0NZyFYWZUTvYJa2gw+thgH1zS76/cNr9ChSufbQ71mlKxnAQN4VAWzJ7StjLuoGWzDKqvkBsvJO9ES1CfD1hpEMVFnOdYlffA+Vh+Z7hYtDaC72PGUuigDhWoyBbDfgt1kdwENrugzanALO/95OUFG7UtXLlbc5/Z6+Vs3Bqtpis4wdtnkgL/mD4YKGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRspaQqb7kv8meCpkAFmZaLzn8Zfd0Uw1/b8D3ECBUg=;
 b=fatYaHxvCWFWyS3kKY+GJtTTL0NHU/9fpf2UFd4bSGRYHo2e9zpYl5C+T+FjAct0G0brLnXHx1Zn26c8vKibt0Xa0COARLqSe9UQKmunUWX07B41nSWQIp2cGBOma49YWIebj4KnxewVSp9ugMr3qMUMPUV79KVGaRgJrWROvy9tL4ChCRkgetTCfTfg6Y60lmMDfjYqvjGetGjvWTl0NPM+R7t8OTaeJ+a+7UP1+Gg+/nG3GVJiQZKQ38zGD+ckdHR7ZLBpm8iMl5cjU0BPviUb34GtSrJzBcMtATeLwpaYUC1MWHYWMIq83lJO641HXxv/mhHkrPdXhXrBBbAbAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by PH7PR11MB8598.namprd11.prod.outlook.com (2603:10b6:510:2fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 02:12:19 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::4d2e:40a8:ddf4:f278]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::4d2e:40a8:ddf4:f278%6]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 02:12:19 +0000
From: "Rout, ChandanX" <chandanx.rout@intel.com>
To: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"Karlsson, Magnus" <magnus.karlsson@intel.com>, "Kuruvinakunnel, George"
	<george.kuruvinakunnel@intel.com>, "Nagraj, Shravan"
	<shravan.nagraj@intel.com>, "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-net v2] ice: recycle/free all of the
 fragments from multi-buffer frame
Thread-Topic: [Intel-wired-lan] [PATCH iwl-net v2] ice: recycle/free all of
 the fragments from multi-buffer frame
Thread-Index: AQHZhzScMA5fWn4lFUmjVHedbw7jwq9zu2JA
Date: Wed, 31 May 2023 02:12:18 +0000
Message-ID: <MN2PR11MB4045234F7E5F0A97EACB39BAEA489@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230515135247.142105-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20230515135247.142105-1-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|PH7PR11MB8598:EE_
x-ms-office365-filtering-correlation-id: 30328b96-ebc6-44c2-be52-08db617c760b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: loCwSD2wex0G+JkDjDTw3u2ewUbB0seyE5s04aJxs7rt2NfhFm5zSPIhs2/LHevqBwURPmmJNj490FkKLGHuVZ6TbjqwCrZsX4CEgXXaaCbyZK2xaCFpNtQJRhyrl6RqsKXS7w6m7O0OM450QKy/YtyzUhy+JMZ15RdvNzs2EpGpxnnPLUdUZ5YbFr4yBqR6oSVf8RjJCNySJClcYI9sjcBAqn+Q/GRoWUOXvPKwaK/TZjJlZ7RwFGxbmYMutv1xnQwUs/U80txi1hPI7BGW5yF0bs/ZE4HvbnYv6u7eKJAVxikRokZt0tZZlDpTgnDmpeMqZruAzxJKsCyl+tE+rp9CRHQ7xc/k0A89eICqUo96w431CjeILQJjxu29lFuLVQ8TrJqZP+FD5S/smAik3jVjxK2t8bQ4yiV8+lZnedQLM1RCl+/F12tH+7/C84L+GMsaxqhZDtn90373u0TQfMB8fp9qP1PvezWmyszrXObezV0J5QVRtIMYQI3SeMKajFIgn4NEGvzeFi87jOkJ7BW/dz943TfgMeMkpFT0FV0LbUVKxvcn3FJw5BRjKzFS+Q0dkBeTvvi1qLCQazqQUk5ZMJoCgiT+kihE2GVITcNveergK9Yp3H4RKd8pa0mp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199021)(82960400001)(122000001)(33656002)(38100700002)(110136005)(54906003)(478600001)(66556008)(71200400001)(66446008)(66946007)(64756008)(66476007)(76116006)(7696005)(41300700001)(8676002)(52536014)(5660300002)(8936002)(86362001)(107886003)(26005)(2906002)(55016003)(9686003)(6506007)(186003)(83380400001)(38070700005)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oaRJvBmA3+HKGVsqNoB9mSQcQJNYNt5UsXj+6ICO8Unfcmu0S6+kgyZpu+f8?=
 =?us-ascii?Q?7N1BbM+t+Ed0zqXKCHddBP3d6n/ES8zKu/TqwZNWc0m/OV3IWiWYqKLf/SNz?=
 =?us-ascii?Q?+HAvGrLDillRc10BbQroe9IHlvyK3VJ2eqX+H7QSvOyNdatnEiUCIvNWt3LH?=
 =?us-ascii?Q?mAQmd7ZexOM7p6Xwg6AED1MC/BWZZPExGJpJe5Eokd3fAnOKxl/izKcOb5F+?=
 =?us-ascii?Q?lcFY9KKTE/TkttaU/NzoytDxNE+3ROrSxWmrpExOurogo7A8xQqg35x2FEM4?=
 =?us-ascii?Q?SeSvz5pVbZcpmyNcvzdYuwB74kUgyt3kE1czX/EpdOrAIVSIsqA5OtF+wJr0?=
 =?us-ascii?Q?hsKqatRl55MwW9+55fzNJ3N8yeN9iV8Bz2+Sfm07kC4jmh70lcjA0CmKYaC6?=
 =?us-ascii?Q?8AvxvkFeZXHdSzhIFb/DeBU5FqYZEs9kI+Vg5o2DqgObNj7oEKdPVSKtyeEc?=
 =?us-ascii?Q?MrmIl+AV1kNRF/ZxL/LZWYfSFJZX0cPBVdFNSAf3SP1RetyRKFiDM/+h+Eqr?=
 =?us-ascii?Q?dMw4IXS3Zb9DZOWFGlOykaV5e1oUNUggsWUpNZLG5QccQTdEIg+iyBPBghlk?=
 =?us-ascii?Q?eHBOd/bjHsKQ+Fwpz4wYaLJHoPr3jahG1ubLWI9APCpoM0xVvjzFpt8UnwAg?=
 =?us-ascii?Q?MWOGb9dvHaOnY2UYxQ7JemlAAGcJ9rBEofdinMgBD0qqKG+i8E7U/0MV0Fs5?=
 =?us-ascii?Q?W/iT1O+LfRwIAet87QXtHGOmEjyv5YZR65yU1LN7R1TzwdpkPQxARMbFpVri?=
 =?us-ascii?Q?HETrP4+sKaEPeSafn5N7xSAIDyJ5/QHKwszdev6xluqfnXKhI2bjN/0wQQCj?=
 =?us-ascii?Q?FnntWksPQq8Ofdhqnr3inIIS929EJiRjeiOq4uRiUzqjOTt+Y087m8PKk+rl?=
 =?us-ascii?Q?x8eR4TVjHhzn4OdH1UzQ9+df3cG0etXA2cONik8vu/6gqyjVnsR672+/i/r+?=
 =?us-ascii?Q?wPM0uVvhymedJPdcAM0Oc8C8mf7RPwGme27i9afQzjquIHWmmZCYg8Whxigy?=
 =?us-ascii?Q?1dSNO6N3aekNPG6Zwa7eyJ3T9HGbdOKK5o/upgPJArNL/W6V++j/FYX0DeJr?=
 =?us-ascii?Q?/82RZR0IFYefKLkS3xtNdA6cS5OFFrR7AFy0m7XBnCerlHqJ5yv/94M7rKAn?=
 =?us-ascii?Q?8qL4WhA6ghATZ7eXzjVLyKLymclzeknRayJTq1Y98IktJq41YpOs5A4hi21x?=
 =?us-ascii?Q?5whOf1moCewt33YKDypvk/K3w7Gl02a0MM/Ngyhfy3Xd6pepr//vzlFPrnok?=
 =?us-ascii?Q?VWX0oA/mSw7ZdFe2fv6y60a7OS6iBLiduzDvnJVytezFdYFjUMSVG2tQKVqg?=
 =?us-ascii?Q?tv7xTEqkI5QAegheFdS7UMbuOvqRGNIYSDYfXvJbSrkd18tc13Wv8rjqMPXI?=
 =?us-ascii?Q?a2DZHIuigqfmvLI9eGXKNttsyXra/VwCn3frMzMcWlBHFg0z6P8yqr9STfGK?=
 =?us-ascii?Q?ZuF7NfppBpdjWbchMKOfeo2TsBdaWvj4OUHPwU7gm0I5zSYQHX55AuYRd0QB?=
 =?us-ascii?Q?gxdKQEY57Sudjid9Z93y196hWPOYswRBAHImxkKyfhQhvuxiUbh4nFoZ9QeM?=
 =?us-ascii?Q?ULsqIU3oaWipAThw2GNFfqYBoPGsumBZi8mNuh3z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30328b96-ebc6-44c2-be52-08db617c760b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 02:12:18.7081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B1helIWq75/k+9KsWRhetzB08BPE8Wus5JDpcgH43Gs8YBEgdBccOEw3Qqtr2N3NQqGhryWn03sb4gf7K5O/Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8598
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Fijalkowski, Maciej
>Sent: 15 May 2023 19:23
>To: intel-wired-lan@lists.osuosl.org
>Cc: netdev@vger.kernel.org; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; simon.horman@corigine.com;
>bpf@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH iwl-net v2] ice: recycle/free all of the
>fragments from multi-buffer frame
>
>The ice driver caches next_to_clean value at the beginning of
>ice_clean_rx_irq() in order to remember the first buffer that has to be
>freed/recycled after main Rx processing loop. The end boundary is indicate=
d
>by first descriptor of frame that Rx processing loop has ended its duties.=
 Note
>that if mentioned loop ended in the middle of gathering multi-buffer frame=
,
>next_to_clean would be pointing to the descriptor in the middle of the fra=
me
>BUT freeing/recycling stage will stop at the first descriptor. This means =
that
>next iteration of ice_clean_rx_irq() will miss the (first_desc, next_to_cl=
ean -
>1) entries.
>
> When running various 9K MTU workloads, such splats were observed:
>
>[  540.780716] BUG: kernel NULL pointer dereference, address:
>0000000000000000 [  540.787787] #PF: supervisor read access in kernel mode=
 [
>540.793002] #PF: error_code(0x0000) - not-present page [  540.798218] PGD =
0
>P4D 0 [  540.800801] Oops: 0000 [#1] PREEMPT SMP NOPTI
>[  540.805231] CPU: 18 PID: 3984 Comm: xskxceiver Tainted: G        W     =
     6.3.0-
>rc7+ #96
>[  540.813619] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS
>SE5C620.86B.02.01.0008.031920191559 03/19/2019 [  540.824209] RIP:
>0010:ice_clean_rx_irq+0x2b6/0xf00 [ice] [  540.829678] Code: 74 24 10 e9 a=
a 00
>00 00 8b 55 78 41 31 57 10 41 09 c4 4d 85 ff 0f 84 83 00 00 00 49 8b 57 08=
 41 8b 4f
>1c 65 8b 35 1a fa 4b 3f <48> 8b 02 48 c1 e8 3a 39 c6 0f 85 a2 00 00 00 f6 =
42 08 02
>0f 85 98 [  540.848717] RSP: 0018:ffffc9000f42fc50 EFLAGS: 00010282 [
>540.854029] RAX: 0000000000000004 RBX: 0000000000000002 RCX:
>000000000000fffe [  540.861272] RDX: 0000000000000000 RSI:
>0000000000000001 RDI: 00000000ffffffff [  540.868519] RBP: ffff88984a05ac0=
0
>R08: 0000000000000000 R09: dead000000000100 [  540.875760] R10:
>ffff88983fffcd00 R11: 000000000010f2b8 R12: 0000000000000004 [  540.883008=
]
>R13: 0000000000000003 R14: 0000000000000800 R15: ffff889847a10040 [
>540.890253] FS:  00007f6ddf7fe640(0000) GS:ffff88afdf800000(0000)
>knlGS:0000000000000000 [  540.898465] CS:  0010 DS: 0000 ES: 0000 CR0:
>0000000080050033 [  540.904299] CR2: 0000000000000000 CR3:
>000000010d3da001 CR4: 00000000007706e0 [  540.911542] DR0:
>0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
>540.918789] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>0000000000000400 [  540.926032] PKRU: 55555554 [  540.928790] Call Trace:
>[  540.931276]  <TASK>
>[  540.933418]  ice_napi_poll+0x4ca/0x6d0 [ice] [  540.937804]  ?
>__pfx_ice_napi_poll+0x10/0x10 [ice] [  540.942716]
>napi_busy_loop+0xd7/0x320 [  540.946537]  xsk_recvmsg+0x143/0x170 [
>540.950178]  sock_recvmsg+0x99/0xa0 [  540.953729]
>__sys_recvfrom+0xa8/0x120 [  540.957543]  ? do_futex+0xbd/0x1d0 [
>540.961008]  ? __x64_sys_futex+0x73/0x1d0 [  540.965083]
>__x64_sys_recvfrom+0x20/0x30 [  540.969155]  do_syscall_64+0x38/0x90 [
>540.972796]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>[  540.977934] RIP: 0033:0x7f6de5f27934
>
>To fix this, set cached_ntc to first_desc so that at the end, when
>freeing/recycling buffers, descriptors from first to ntc are not missed.
>
>Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
>Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>---
>v2: set cached_ntc directly to first_desc [Simon]
>
> drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)

