Return-Path: <netdev+bounces-6606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8EE717126
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D79828139E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A895234CDB;
	Tue, 30 May 2023 23:01:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939DBA927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:01:25 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBCAE5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487684; x=1717023684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZqSfq4/5gdEQBGUrOKRRFyUPj2/C9vqmdYPnKh5H12w=;
  b=gbndAouj7A3uhe6xvdZLX0B96B6iV+JUF7h2oZnjUo8gZMoOcMuWoMIc
   3PIEWkfZ1Uod1yD22SL4Wbbf9c2TuueHXMlMAmIm6kqC+NqBGcUBsZUnd
   PlZhDaLpybTfSZbnRX02XaFcdJAvGHja0c9LfWAB1WHUnQl/icdYJlOTB
   9u9W1CGWIrOxETRlxrTtPDtxUYXFJTUY2LEwQJXuAjqxaun5PT6jqZ09i
   cUZjxLnHBO9yb79vLpfWJ4/EZBbm485pDu72NktMwox5+0z1sOQ/uSFig
   DUA1UlTsfg0xWRr77M66FR6HADAnIEDwO3pcdLy7PvWcTYzjqKhtd4Hn1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="344573714"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="344573714"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:01:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="776529294"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="776529294"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2023 16:01:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 16:01:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 16:01:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 16:01:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egR3dXfMRT3zg6GQkeAIwREILf+IqIC7KrsQP+4E9r7VOUqVO1ovZCmpi4V5gu0WrA87TQzonSCu9bx9sNIzPbYNwIl6ZhRG2eaxtX+BTCT9Ff1BpVVS6lRuQNKWPFAusfCuBfP4MGFgLHO69zn/4+iEtm1ZaQOxWF4QwM2xtfdpNKvUXibAQIuClVkS7IC9aPaDG8ePpp2F0AqIWuXqTmgk/pvdERuMnGvpK8jofWCOmfSx1Uxov6X9D4igV+hma7CUdw/nGEf/TwWPygBmTuCXwRIWtG16eDGU5VyCGJH6mwcEjr4Mcn6vLM99yV4G9GfHrPySPy1V1n1wCSR+xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0GjN+r6SnujCEBGcDjcyeqEqhNF20xfaymTEVn8cTs=;
 b=WUUXfRHxwc+3mpB/8Xs99iqvmlkFMD6GzdcY6EhJX2cc6Dq4bGT6rIVucFDS3eWhX87AuKwndKPsdvl6OHQ3ZWdXgu8BBVal2krtpXkc0OwhIYIRmG7Cdby1buE5VyXvQkw0BCnwJbQTVd6/G7DH0jzl5hBL7nMuFEDTMXI+lKmfXXBkGa5yO2t2zxEZIeSrYWhChF6ZWReJftKrrFEVweig1uDxiN6IQz6wjm/R4QbHpU308hQEo55KULBjSosl+GSUDGVmE5XO+vfe0qRaDZT+w7zxPbEmOmjfrouCRuQ9pYp74waU3RR+O0gcOdu8mDDBmTRd7bzor44QrUmo4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by PH0PR11MB7660.namprd11.prod.outlook.com (2603:10b6:510:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 23:01:20 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 23:01:20 +0000
From: "Singh, Krishneil K" <krishneil.k.singh@intel.com>
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "willemb@google.com" <willemb@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "leon@kernel.org" <leon@kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"edumazet@google.com" <edumazet@google.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, "Burra, Phani
 R" <phani.r.burra@intel.com>, "decot@google.com" <decot@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 11/15] idpf: add TX splitq
 napi poll support
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 11/15] idpf: add TX splitq
 napi poll support
Thread-Index: AQHZjQ1sxAMixT6cik+zx9qsBmBSma9zewBw
Date: Tue, 30 May 2023 23:01:20 +0000
Message-ID: <MW4PR11MB5911B771926C5165331EA2FDBA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-12-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-12-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|PH0PR11MB7660:EE_
x-ms-office365-filtering-correlation-id: 878057a5-902b-4ec6-ef3b-08db6161c849
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gIVviAdybp/j94YJ5ELPwww/SgLEy7pwdm9e5tBbhqrNxiSWPVcfuHkZYrg80CELBPWvgDJMSvhSOBuMFUcp2wJFJWq20kADENrRWX1188Q3q0BjDgSBRgNB3wITbkkB0i9fC9N2LUr8hCnZFSVUT+tpq/mXbkQLiwUy9+kDawWJ+el6xvD8jVNKrTpTfXAI6pl9vXY0BPEhoXoq3uMa0qpkq+es2Wg8uZQqb9+cYr9IPaTsMo3kc0EuLNEkcDiPomQYfAxbNvxTfPESU4nWhxplBQ3vvuCPoSvDBf+abCdPNmqx7ArWCH8vMGph/6TJ88a3U1MG9EzPMb5YAQZqfdzzAywIJjZsivFf5qDSYHBRly/HcylBs84FbWr45X/CGDNoAo3SQ9TTNcP67qUdO232BGfqiKvzZ4fJe52uI6JphQC1IfTsXmaWK+0m83vHY5tNCZcXyF2w+/RWiH8UsvyIQM+zyX+LH+L6M/4NR6bqemx4TcBfX0BDSfc05t4ps7qCWX2nrSUkD/qyd8FmZjRl8oOF+L2iMfmmp4jGxvQ9+mPmQKysh/GRT8ANkGwLXqctuNz3vGRnWyFyU9d4RR9VyPrvNc/2IIG8iPl/+Dt70UJaF91qBlXS6h2qb0Iy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(86362001)(41300700001)(38070700005)(7696005)(55016003)(4326008)(71200400001)(316002)(33656002)(66946007)(66476007)(64756008)(66446008)(66556008)(7416002)(76116006)(52536014)(5660300002)(2906002)(186003)(478600001)(53546011)(6506007)(9686003)(26005)(83380400001)(8676002)(122000001)(54906003)(8936002)(82960400001)(38100700002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S07YlMBbzdjBND78lrEl/ZG73JUUJuHncf8TzF5FCdsFmulJqZmyp9q3gYQw?=
 =?us-ascii?Q?pi0sYo46bwljZZD8DPNrWwf7uDvRps0K9vEE1FGO0NTGX8MJLuh0eUXtTcq+?=
 =?us-ascii?Q?UWpB8APsX3AsA9ZBWWWrFqvn0amSHG98WqrUgM+wtLa076mwb2L37cQ3Gg+D?=
 =?us-ascii?Q?gmNYbgPt8Ax64MnNbeZuaMwVfi/JrcYdE/Nh/v1jSIoEc8lwxdKXWxPA4b6d?=
 =?us-ascii?Q?bceREDW3WP3K9aSh1/n0QO40FgIMAaTE8BfttJZyuZqJ/Elh+lfBr82md6T1?=
 =?us-ascii?Q?IP9TG17I9KZeqD49AAbFRwpGzTlvYzflG0r00KqW57h5uf8iQ3Zmr4v7JxG0?=
 =?us-ascii?Q?+bafn5vl6/AOWvgNReibKG8gFkm3QOGV3clnPNztxKPLGIwgdcbjRUr5kyN/?=
 =?us-ascii?Q?zzV5+3hYOWxPxJGl6iEilCssqT18tABYFnONufD5VozxVsp0Cgr/y1obaO8w?=
 =?us-ascii?Q?1KtOzw6hqT+8QvLACnIs7dRuo2EJum+QZt5qkO5cyZJvRjzBBGZ+99/LAwKo?=
 =?us-ascii?Q?jQFfYjdWmarSCCfypnM0bEOFE4KgCOmKOJAvPwRXlaovAsWHerzaFWiPAm22?=
 =?us-ascii?Q?LsrRQhTNfEaK1CYNQB54qcwMremtCAZcfXPbvaqAcsufzqWeUNCHsSWDw75k?=
 =?us-ascii?Q?1h99YJGdftyEZbxF69Hdol89OCC6ujbjOMg5RUxvxGl/VpSxrROjs6tFcJq1?=
 =?us-ascii?Q?4IR8V6GaXK9Rs3BJYWqDZBhvWGVtNG7lNUbf5kMHD6E6IoaIb9L42khbBOtm?=
 =?us-ascii?Q?jnbSaWkBUwvTXwKmZjiPQKkEg5KX3+wXXjH3gFGUdwf8jDlriOjJgN4mJ1vt?=
 =?us-ascii?Q?2mo5zaYqDbwAsfmTxW1k2iF1twjXGOYgdVloWokFFljILMw/hhRqaU+G7g+A?=
 =?us-ascii?Q?Z1PAYvZGYR24xX7sS/rPvw16tv407ziD4Uie+qNc01rlntvLUZLJwActpA0S?=
 =?us-ascii?Q?JkmagAtl0nz9LXLqSJHf4/tRB/mZgIWeS4zWBTDBimelfaBZgSMmz0mRMWOm?=
 =?us-ascii?Q?WVLtF3Xfp9vt17JeQwatHALHMmOFw7pOwPNN+dB5SYFqErvdf7pg+wuu7KeF?=
 =?us-ascii?Q?S9mp4eqfgl2+pIn1NpNGvjT4ojJq4nBZlKTdTSMLRrKXQ3P6nKXA0sQ+SSEN?=
 =?us-ascii?Q?yaa84dkZQ3b/FipH3Nv7byhCX2ZGcR6XSR/ley1If7uWoGicvU4sV5wwJVdy?=
 =?us-ascii?Q?5Up6whyqOVCQcQYJFoNYoTde90K5iwULU42w19QfBbqNRCoQD2/g3mkNhUP5?=
 =?us-ascii?Q?02a7F6CPq3jTPsnYRK1o1kYrGawEbklNHaaWvw95GpCc/VGdw4wB+eDeCf4C?=
 =?us-ascii?Q?h35vI53wpTU8EazhSY3yPQXGVGuMdirHfGCgPx1U8yCpNWMtT1/jq2koccEo?=
 =?us-ascii?Q?EFhiGf+f0YckF+5ZUoLiCKN6YcPis4ViCTHCvOYo5F8iKcNQU9iviOYSeej4?=
 =?us-ascii?Q?S2iXdhuyRpse2flov7PUbol/Zaw+brM+2A6H7gljpAVPp9dn5Iz1aDjxg8xX?=
 =?us-ascii?Q?Iw9TPUn6qY/ZjnyClNGpjuZ+0CdvlpXoJARmbsSNYxiGkMmIQ9J6zkkU81w0?=
 =?us-ascii?Q?/1ggzyNebFIWHrkzHbls42pf6NmR4bg0OphHOOgjhRT1ZVXM9a/ud2LN0Vum?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878057a5-902b-4ec6-ef3b-08db6161c849
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 23:01:20.2660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gc0x5cZYUjBbT01byxfEJHLiFcij/+EYnbrFrAe6hpa9RPNvYa33JsdtReADqNfuCLEfwzsKmufRmWVVSKKvPnSjtkD3g2L91pRy/BQbKas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7660
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Pavan Kumar Linga
> Sent: Monday, May 22, 2023 5:23 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: willemb@google.com; pabeni@redhat.com; leon@kernel.org;
> mst@redhat.com; simon.horman@corigine.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; stephen@networkplumber.org;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; kuba@kernel.org;
> Burra, Phani R <phani.r.burra@intel.com>; decot@google.com;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 11/15] idpf: add TX splitq =
napi
> poll support
>=20
> From: Joshua Hay <joshua.a.hay@intel.com>
>=20
> Add support to handle the interrupts for the TX completion queue and
> process the various completion types.
>=20
> In the flow scheduling mode, the driver processes primarily buffer
> completions as well as descriptor completions occasionally. This mode
> supports out of order TX completions. To do so, HW generates one buffer
> completion per packet. Each of those completions contains the unique tag
> provided during the TX encoding which is used to locate the packet either
> on the TX buffer ring or in a hash table. The hash table is used to track
> TX buffer information so the descriptor(s) for a given packet can be
> reused while the driver is still waiting on the buffer completion(s).
>=20
> Packets end up in the hash table in one of 2 ways: 1) a packet was
> stashed during descriptor completion cleaning, or 2) because an out of
> order buffer completion was processed. A descriptor completion arrives
> only every so often and is primarily used to guarantee the TX descriptor
> ring can be reused without having to wait on the individual buffer
> completions. E.g. a descriptor completion for N+16 guarantees HW read all
> of the descriptors for packets N through N+15, therefore all of the
> buffers for packets N through N+15 are stashed into the hash table and th=
e
> descriptors can be reused for more TX packets. Similarly, a packet can be
> stashed in the hash table because an out an order buffer completion was
> processed. E.g. processing a buffer completion for packet N+3 implies tha=
t
> HW read all of the descriptors for packets N through N+3 and they can be
> reused. However, the HW did not do the DMA yet. The buffers for packets N
> through N+2 cannot be freed, so they are stashed in the hash table.
> In either case, the buffer completions will eventually be processed for
> all of the stashed packets, and all of the buffers will be cleaned from
> the hash table.
>=20
> In queue based scheduling mode, the driver processes primarily descriptor
> completions and cleans the TX ring the conventional way.
>=20
> Finally, the driver triggers a TX queue drain after sending the disable
> queues virtchnl message. When the HW completes the queue draining, it
> sends the driver a queue marker packet completion. The driver determines
> when all TX queues have been drained and proceeds with the disable flow.
>=20
> With this, the driver can send TX packets and clean up the resources
> properly.
>=20
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/ethernet/intel/idpf/idpf.h        |  11 +
>  .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |  16 +
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    |   2 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 795 +++++++++++++++++-
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  40 +-
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   |  52 +-
>  6 files changed, 911 insertions(+), 5 deletions(-)
>=20

Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>


