Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854405FE7CD
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 05:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiJND4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 23:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJND4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 23:56:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126C117C578
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 20:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665719763; x=1697255763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E24AgXW7XmNWIhLWpzTHz9jsdaba+cxXPbYpq+sa1Ns=;
  b=lOg3/VEf1eGOTNAl3jq0Cp0SJfn93TTWpv9/V7fLrwknqasS0I3iUgR8
   Jb5stIRJBYnBXHL3IbMS6gu1etqzeBio22iCG6DK0noMdFUhfzTBVQAeh
   Mo69Q1iB+ltoJNp/n7uqCC8ERTlFju84d2Puyqn+ayrHf451UmqmhiZ0g
   MJn04EdTjlBgEipwf0JYtWdJ8i/PDWuZ0W83xkiLVT4s49lJhIk2szkc0
   mjzwLFazC/RVTHSpyKC0boNVqZSQ3XJQBHF0C9y8WrgbyPRdTLR8tcpA9
   9PCbMHFdHWy5+pvcOHZOo4pVv+XhbUU+fsYiXZn2sBZnV4Y+ybR0EvkoI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="304012984"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="304012984"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 20:56:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="872586371"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="872586371"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 13 Oct 2022 20:56:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 20:56:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 20:56:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 20:56:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 20:56:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkJU+M8j1Gj5YIgwC+lAQzMoAcf4oSXUoPByucWjeG4FA7Uz61FWG1yTWMFpUtWyWHkp+MYLloeBos7QC165ZWBOlHu27JdV+nxYfIIb63snzzSe4CC6X18PLc7cu0ggeadYtHtEjuxdC1gEbqA6fbxTiPgVAvMRmygpYimy787osjJhhTF84CoB4EofGpjyJapIG2YUFnVxHP9lkw1bqRuTK2pMTN33H7KcDQH5+Pla04QFC9hscBeGxt2eOZMXvKMOOzP8mlEbY9Rmfx+n/ZNs/uNkskq41IXFs/4Vh1/D5mN3nZcFA5TarJBAyENV01pSuJs+9IWDHY0P2Ltd0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADrlhjlcAYOMjJcRs9iIVF6kGvs/RNCsWz5pEice19A=;
 b=ZFAU2EXILkBE5eg2bTo0uait/+j9jpJIgkAGxGLy9jn0N15/p95REd4DEGX3g09LYekyNShCUhyq2UrYbBhtPy6436GwaDazdaXZamrQS9/LYKgtzhtjGLajCiM99wE/Ok6Xaq9LbgW3Jz9nFThZFDCMPzcFj29ZItXXZ2pFtbUW9SGn+rZOP7hjnPxnMo/XXjZ1G09EzJ4ov63yn5rgHNX9RBurdEwLo72yiwTCJZ3/cdvXBax6avYtEIVB+J9jGFP46i0DVH4F2UkS3Tz+rJwQAP1hT2Bx8Bv87lGK9kQHCUN/5IaGcw8tCucCWOps6DRt6z8zq4ftXABdoUymaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by IA1PR11MB6419.namprd11.prod.outlook.com (2603:10b6:208:3a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Fri, 14 Oct
 2022 03:56:00 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d715:691b:4bde:7ead]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d715:691b:4bde:7ead%6]) with mapi id 15.20.5709.022; Fri, 14 Oct 2022
 03:56:00 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Joe Damato <jdamato@fastly.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [next-queue v4 4/4] i40e: Add i40e_napi_poll
 tracepoint
Thread-Topic: [Intel-wired-lan] [next-queue v4 4/4] i40e: Add i40e_napi_poll
 tracepoint
Thread-Index: AQHY2pVwXvq6Kgg4AUijx6KOGMM2Mq4NTHAQ
Date:   Fri, 14 Oct 2022 03:56:00 +0000
Message-ID: <BYAPR11MB336712A25242107887CE3BABFC249@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
 <1665178723-52902-5-git-send-email-jdamato@fastly.com>
In-Reply-To: <1665178723-52902-5-git-send-email-jdamato@fastly.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|IA1PR11MB6419:EE_
x-ms-office365-filtering-correlation-id: 65490863-1ea5-4a58-71e4-08daad9801cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ojOThHFLrKGiDxpOgD9dTsNW1f0QWO8jsYdQd+bFLkF+ioL5bBhuW+AwIr7D0GXdYQVsOIGl6hMVZB+fdkr9xQU5qVpKEgd+JMGOCMfA539tPNlp9tYX+a4DhBCz3O3AuB8bxfQkbYs+chU3E6NIosntU1H6I0sR7j2wzhoj2V0mhfPCdMimzhcxT6qwQfe+otjw8BnCiAtPcpemmqSlwsRU/3jbvOtdu3GWHrP6iPmbOvt29pVnoPz+C00azGXs9lojzL4gt8GFLE2QeUFX7SHVLss96Se7C+3/iFtZ9ZSUvtJOg3lcksEaadxP8oiTQtz3ITurBI+Z/Ry6MkbFB1tyFlZF6vFMgmEfeQO5Md7B8lVCE8XFOvczRHveoqOBUilUDTVRCxf3j/WgpDxyz4vgFRFHxBV3RNpsJpDJrAPHDGcUBXbtzN1ojRPFznwTVA4usuUAMwLegaJ+1B93A+fnwsQ5+e6AwflbAx6Wikq3dkd0yYTu/NH4Kj9F6AVzE2oiSN+8d037zOnaKBbVZg24jYsqHJ8aPyQ0A9n/U6oGSNsCL4bTcgI6hNjLKeOE3dIBPPxrZtaswALs1s1dNFFEjn3f0PhreNEFjPVFtHC3/Dfbk3BBwiKmI0cM5KUZdch2L/hqMRAVOF6vCVEqQ0GmpkDvCvWLni9zd0hH/uA0tZGs8T7kckY/dCIEX6KBD8yJMmbr723HCRh8ckTLBTpiUydYFnV8II83z3A102NJy7jWznNNbPQWK2w9wF884S5+YZ11kA4d9zrMpl0ebQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199015)(53546011)(186003)(122000001)(316002)(82960400001)(8936002)(64756008)(52536014)(41300700001)(4326008)(5660300002)(38100700002)(26005)(6506007)(33656002)(2906002)(66946007)(9686003)(66446008)(76116006)(38070700005)(83380400001)(55236004)(8676002)(55016003)(86362001)(7696005)(66556008)(66476007)(478600001)(110136005)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qlTcHUUwJmb/G5Q2gv0tYqfkgvJA8APrpJX55QQTZuvk/u34B+mZ6LBqTz9e?=
 =?us-ascii?Q?MQGuM8SFRKua8VfVNpQYESXMMsJ4O1PLChlcZmxcuf3O+b2rg9WleIVLj8Yr?=
 =?us-ascii?Q?F7ZSDXi7Q8pisGeWtpmspxSIir3R9bva36b70i7IbHCnaXDhX2nq0n7dPEB/?=
 =?us-ascii?Q?DKuitqmITVl4/ULJ1lOA1792ByRNlQXOkEUU00Zsr8tmA9qZp6L6R36MLEWc?=
 =?us-ascii?Q?qjzKfHThbsHMJQtV3SgNY/O95KUGZZltuU7ih/YLxMZwp9OpZt6GJNvQ2qUL?=
 =?us-ascii?Q?x2JhJnyuBSpUmNo/I3WnxUqBlzTUIKr/Aif2e44Wu1v9MWjTVW5LzUlPb9Io?=
 =?us-ascii?Q?npxTib+yRikGCxUKglJn1aqM/F/DRs2zkZAXyVOa3WaLK56xD/GK9h4FzUrB?=
 =?us-ascii?Q?XfMKHzleRMzW+ZF0klgUiIdQxsfjf3LAHxlw+8q94f4eHvGIq3iUkvAD8d/2?=
 =?us-ascii?Q?cbspzjz3XYlJtrsyd3FSqVfHXNYF8ofuOJssdU87UNFO3pU6GsLXVJDxtN1A?=
 =?us-ascii?Q?g5g1omzH8jJkAHic3/7ovaQ54kE7ixPve+UKXOTzPA7dfDr0dRBcofozO8RL?=
 =?us-ascii?Q?QLpWykfIdT8FvaLzlwO8FCYUA7yv/jT8k4FAyb1IF/Kr2MI0dZ0pXnnq18pa?=
 =?us-ascii?Q?/BIQenVxS6fuL3BKK+06Oz77h6NmFoWrsMT5KiF4aPT4Rw/quQYKuPCc3l0R?=
 =?us-ascii?Q?m6oJzBFkaRQXPhPW9BX5ROQmEc2mbTiSMzjZh4CrACUMQI3RkXU2NVYCphZs?=
 =?us-ascii?Q?vlzIg2p7Szy8PngVSOnIXpNheyfySAX5nMCGZnvU5PHqWf5kt4l9UxQjb0Nq?=
 =?us-ascii?Q?gFdTVVlJU/JCQA6KXrDwTxdo82tHDRr2LY3v8DMrHjor4XX/Dgtj4Fh72aKe?=
 =?us-ascii?Q?T4H9pRGAuuY/oLnIUnLNDd47fuzLtV9nCmJY9gcRkC5jFeORHXrEahUu1Lln?=
 =?us-ascii?Q?RnXoXx1gEvk5DHehbw/bc8izc5JknGYT340B41PsdVZnV2T10tVIzXuDGIur?=
 =?us-ascii?Q?uVzklKIqJcnyM3nYtHhP1ioVvTBjqBKamsFF2PJ8ErStLsl8yBh1+XRpVlS1?=
 =?us-ascii?Q?WWrZI4bWPLOC8FrB6jfmvEzKUZMpVtCrzRvbZ2ELXd2W2Uh7xlKhZckCb2cx?=
 =?us-ascii?Q?IT+RO5GcaPzncc4KH4K915/YdtFG2k3upquc0WPGMnWysb2rh7VjfPSbU3IM?=
 =?us-ascii?Q?1TQ67Lq8LIyKQw+qaZa/1D6ULzurSsKDlXj/tQDoJ4rMAqXe2Pa9AlGZ51Tm?=
 =?us-ascii?Q?Wqs5Fm7Jhf6kTA5JsdMEUfIJAAOtjxnqNK5rxk5Xw0Ns6OxGYO2/OOnDnm//?=
 =?us-ascii?Q?dDXPxKyt+V73bokrHYwr2SpyWv39tpc81b0nzrrYP+6+wEANeBxBOWkZNXU8?=
 =?us-ascii?Q?+pK5e9OcqG0DoaH65Qgd4V1qA37EE6wgM8FyqFuWL3BM4fT42GbJJne7nyRq?=
 =?us-ascii?Q?hNOWz/rOemW3hM6uk0gK2Zo/wC1lYtlxSi/7eKwbVhQQn3gC1afwQMiuHDT2?=
 =?us-ascii?Q?RVaYUuxITm6J1Z/IBex+3zTzO7o2Y4BoRgcLTNaCBaNnJg/AIZmefa7a+ck+?=
 =?us-ascii?Q?YyHaGOywQBdWpKzrWJY05WoWmEAEpud877X8dUSo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65490863-1ea5-4a58-71e4-08daad9801cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 03:56:00.2622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CSYj8ViT1QOimHSNIhcoAmjf+6NzhKTRvNib8XF2Y4ynuRXG+l1LuR/4nX6yZNw35/W75bsihKkjXv6S8MuZ9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6419
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Joe Damato
> Sent: Saturday, October 8, 2022 3:09 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Joe Damato <jdamato@fastly.com>;
> kuba@kernel.org; davem@davemloft.net
> Subject: [Intel-wired-lan] [next-queue v4 4/4] i40e: Add i40e_napi_poll
> tracepoint
>=20
> Add a tracepoint for i40e_napi_poll that allows users to get detailed
> information about the amount of work done. This information can help user=
s
> better tune the correct NAPI parameters (like weight and budget), as well=
 as
> debug NIC settings like rx-usecs and tx-usecs, etc.
>=20
> When perf is attached, this tracepoint only fires when not in XDP mode.
>=20
> An example of the output from this tracepoint:
>=20
> $ sudo perf trace -e i40e:i40e_napi_poll -a --call-graph=3Dfp --
> libtraceevent_print
>=20
> [..snip..]
>=20
> 388.258 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth2 q i40e-eth2-
> TxRx-9 irq 346 irq_mask
> 00000000,00000000,00000000,00000000,00000000,00800000 curr_cpu 23
> budget 64 bpr 64 rx_cleaned 28 tx_cleaned 0 rx_clean_complete 1
> tx_clean_complete 1)
> 	i40e_napi_poll ([i40e])
> 	i40e_napi_poll ([i40e])
> 	__napi_poll ([kernel.kallsyms])
> 	net_rx_action ([kernel.kallsyms])
> 	__do_softirq ([kernel.kallsyms])
> 	common_interrupt ([kernel.kallsyms])
> 	asm_common_interrupt ([kernel.kallsyms])
> 	intel_idle_irq ([kernel.kallsyms])
> 	cpuidle_enter_state ([kernel.kallsyms])
> 	cpuidle_enter ([kernel.kallsyms])
> 	do_idle ([kernel.kallsyms])
> 	cpu_startup_entry ([kernel.kallsyms])
> 	[0x243fd8] ([kernel.kallsyms])
> 	secondary_startup_64_no_verify ([kernel.kallsyms])
>=20
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_trace.h | 49
> ++++++++++++++++++++++++++++
> drivers/net/ethernet/intel/i40e/i40e_txrx.c  |  4 +++
>  2 files changed, 53 insertions(+)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
