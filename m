Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099C241CA35
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345708AbhI2QhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:37:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:38167 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344682AbhI2QhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 12:37:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="204471995"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="204471995"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 09:35:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="538914208"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 29 Sep 2021 09:35:37 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 09:35:37 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 09:35:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 29 Sep 2021 09:35:36 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 29 Sep 2021 09:35:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG2oK6iZyudRnonKb4hJdYKN8kv3qVQKVAOEkTFLPsx6EUdyo48z9tDdINsMgCwQ5Ixnf472NM7KKU5r4fGoSsHOK+wKvIahZGYdXSMcK16eK0Pw5f4HBiHt4/fe7HWTY6FypN2fgLokTGVu2YqEmrDJ1JQURaZ5G8RlPfFizM+C6wW1wscxneurrPjjjKqjZfe5sD47n8tz8pzj51bWEbqwyanH+ZfYY2aCSs6D09o4gCPq20+hWICWCl8kog+XCm19wsxOZMTKJDOGM2nls7grdXmKRg1gALMQrdJTOkZD/8qsApAtQzNh++NKdy2GS2Cp9slyI2vhk64m74QNBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XsY5pHvtmQwXp6ce0V/VEpwAluy49WcsMikITLz9Ots=;
 b=P25ETFa1QiMorV5XTmc50QZcP0Tpbb6JAAowopjvl5hUXEuVbPsAFo0mtxM8kMzbIXpWLf6RY9UMoHvPana/2hxaYwlGNn19R9jRYK+m2KdKqqgFLcDw4KkLlM6kVCIEC9em6Bp6cCxmbu856SyBaFMLmV1Fp8r55xGjmMWgPhuah0jtLq2dg8hwuTxVbNx9LzSrHtnMqkZ1b2O0Qc3lXBwe+8XI+xce6h7dpYCcgmplwjrHSJzBcYqdP4vVqRADOI84qYYErRQ5OJr6qPay4cjBT0nFFLiWZdAPQW7krKvhg3ObL2LEw5o3F7R1BkfaIi+c+PQ3FsB7et2iI19vaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsY5pHvtmQwXp6ce0V/VEpwAluy49WcsMikITLz9Ots=;
 b=QveQKSKhRWQ7FVWkZLdMzva9CBuaROdb01fn1fT+uLkA6j0NpF+KrbiZi/cbKajbI3M9zz9qd2sj4YCMC8Is1TUtHYJaxYaOUv/fkJwXi6SvcjpMMDB3YEHI/enL+U7G6UGcsCe8ynHvCX0i0zIjC4gO2LeOLIg4xlecZu3EadE=
Received: from SJ0PR11MB4814.namprd11.prod.outlook.com (2603:10b6:a03:2d8::23)
 by SJ0PR11MB4928.namprd11.prod.outlook.com (2603:10b6:a03:2d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 16:35:35 +0000
Received: from SJ0PR11MB4814.namprd11.prod.outlook.com
 ([fe80::9d2b:4020:9210:a7d]) by SJ0PR11MB4814.namprd11.prod.outlook.com
 ([fe80::9d2b:4020:9210:a7d%7]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 16:35:35 +0000
From:   "Liang, Kan" <kan.liang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>
CC:     Like Xu <like.xu.linux@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: RE: bpf_get_branch_snapshot on qemu-kvm
Thread-Topic: bpf_get_branch_snapshot on qemu-kvm
Thread-Index: AQHXtUsCll+d9db2OEyfPrzZnzZB7Ku7M+DQ
Date:   Wed, 29 Sep 2021 16:35:35 +0000
Message-ID: <SJ0PR11MB4814BBE6651FB9F8F05868FBE8A99@SJ0PR11MB4814.namprd11.prod.outlook.com>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
 <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
 <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
In-Reply-To: <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcf0fec3-64a3-491f-2230-08d9836729eb
x-ms-traffictypediagnostic: SJ0PR11MB4928:
x-microsoft-antispam-prvs: <SJ0PR11MB4928BC324655A0A64BEA81AAE8A99@SJ0PR11MB4928.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nOpMnIApeVboB9lKOBVyFOutbLgKwPRyig6pmhxdN3kATVUS4iaueJGIbTS3KLfzzl9ViSO8bEpxqoxjThxvZACj7YSdPDqWb3Nz5Lzj6yf11KwlxmoGJwZNvEqVTayshiIuP3ctP2sNykGjuS/y1p6RF7VFiq2dpCbIdX8PFZn9s3U6JH94rC/oMJ27ohbMmxf6h7iN3/7prthiIrT2YmC2nn0IaAXURJUkr3FOYyH6TQXZ3Ckd1qNx9A5OU/SHT+LA0YSDWUyqsNp4KAL0iH6aH1+Rl4MCZAF7vi6JWvuSXnG6tK8XQMF9MbzobREL/LDQICmQ0DYkP+ydqsTjCxK3uP3UhNqffEnihQZ3dxvVCqE7ICfplmPulMVtKsNd495zImOUzh+Jv8wK6MbrBjSyeDmaR2+2c6Vfkiq4OFfycFFXa/hImL1iZ/Z2sU3m2NbwcwVeHj7WUxy1b+qNmpsJtstwmuJvYivx26lmZ4XJ6jNA0OS4DgO6q1h0gu+ENX44KFUugJFR732z7wo1dRsrJ+diR+q2Ljvh8y/yXNh9Kb1FqU2iHziV4woDiITKJe2ANBKkQPvNk+9F4DAmS3hDblA4tQyNoWujFc0vPmshSs5cHcCP5F/hLjeiazEIdfm+XPBTyTRcZTS62ADTHBV2YB2n/yl7Z81Vnp4aMyT9vnYgBtkMFGWRrJ3ncwSJD1/wET2ca61J7EUd063ugQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4814.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(5660300002)(54906003)(110136005)(8676002)(38070700005)(122000001)(316002)(83380400001)(4326008)(9686003)(8936002)(66446008)(64756008)(2906002)(76116006)(71200400001)(6506007)(55016002)(508600001)(26005)(7696005)(86362001)(52536014)(186003)(66946007)(66476007)(33656002)(66556008)(4744005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4nobGvB+YVp2fTWj6+aW3HDwaa6MVRRg5POetsm5ERCWck10JGSK92mhkT77?=
 =?us-ascii?Q?NUZlzOQUo69JstgSlZIwpQQKPXDT896TWrASXHAGUfd4AEzQMg8ltaz844h2?=
 =?us-ascii?Q?Upmq/Opm5RPuwNW74BdDf/SIkV5CQgRcsUzyVmjh6V2FmzOB/0GdxmZ2DX4y?=
 =?us-ascii?Q?TQlx2AkHZZ1T5wZY8ziQc/v4SW2OJNbD2pRPRKcuOlc/xwjzY2xLeCX0Xogm?=
 =?us-ascii?Q?hgNunv4N/xJ8sl3zZPsX4lPUiRNvymbLmVNChOf8b0vAmA14DNzgfwbOJCM9?=
 =?us-ascii?Q?k//mIs/3vMuUgTVrZ8iQqFhgF07BPaZNM8oEgYH58f5ESQN8GKfINdPt8hEW?=
 =?us-ascii?Q?Ox7cJdrMI2cBB0MEdb0/zZDB09tIxjgUdN5/hIIRZA2Oith7xEvbnTqpAWBq?=
 =?us-ascii?Q?OluPHIoR3pbqmhij5mS8i/strxMEBBCk8qpjRPavae0XpSRQEi2xAjn1Twyh?=
 =?us-ascii?Q?B05SK5V1GKZDDypZOEFMQbFcmD6TS1F47mTSd1B3yMz0QKbebf4mRcv83GE2?=
 =?us-ascii?Q?DiOVe9lR7qTLDBx6siQWnlZdJbYHllrXjV8X+KSrGq/Gd0rxekL7+0vDtIQ9?=
 =?us-ascii?Q?am1GY7SNUu7j5IxS8HjuQ62AnIkCQGMjWVNrKP94CZjWLfFewehehk21r7Ii?=
 =?us-ascii?Q?ylDmZ5lAVeiU+k9NM3mRCJdCNU0o9DIFrS1gLUrEgvm7yrQroPDynGynGllh?=
 =?us-ascii?Q?+60cz0/E2eFWq3n3wuDtQkeS0JndmAnGn+iqUPmgwmF6o4wASl5EenMyPs+1?=
 =?us-ascii?Q?LjL1bRinAI6tkU6M5EH5dezkaVyKtzaRDD3SU42KaHVSMKK9T2UTN6PuYWeJ?=
 =?us-ascii?Q?+JiIuOQh1q63DJxmzWujSswG8Z/I+Rb0JANg3ZTuqnAsUM9sHA67ZB8KZ25J?=
 =?us-ascii?Q?OTRc2MuiaDcVK9cWQn7Lh/PeL2Is/XlhVUu8GKoPPrzYpaomFGDBbujBuyrP?=
 =?us-ascii?Q?bP/EEIuUhvP/P/IVQ+IMPc67HRijI1wBW59VmHSayX33r+MSjWDjqiJraZdE?=
 =?us-ascii?Q?L0L6ul7me8xU7oeLWzOBbCP4sBbhvTTQJpXg1x3VHLdBrjlN981SWlt3dlP1?=
 =?us-ascii?Q?Ib3Er5NONs3wgSIZTT5krGz3iUGg7P3BXGTQTD7kNTx0xP6sxyWLFceIt7P7?=
 =?us-ascii?Q?FPzY4xrv4c+W4+pofhc4JxONkYJRLwppFt1/PGN7n5jMt6JeCZmQzg1tSLgL?=
 =?us-ascii?Q?gbMAmmpMFSl81ufUCF8PeYwfTJBPGBZj3yc4uayyEaT4tSt5mgJuj+plLAjI?=
 =?us-ascii?Q?wIiU8vKpCZhBo9+xyCyNag0yXCJKPz5f7tO2qUGz9KSVDkF0Wtl08SN3VXPW?=
 =?us-ascii?Q?/gaNdARyh3nTpyoO8vr+kcd4?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4814.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf0fec3-64a3-491f-2230-08d9836729eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 16:35:35.6945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hl268Grd2irNFa/Uu5A3yN1hh1Fcw81HQhU2jTvnmLYFW3BlDA3R11MVoUT7iXbjwoktpj4ZeMfSaCy+NMGhqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4928
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > - get confirmation that clearing GLOBAL_CTRL is suffient to supress
> > >   PEBS, in which case we can simply remove the PEBS_ENABLE clear.
> >
> > How should we confirm this? Can we run some tests for this? Or do we
> > need hardware experts' input for this?
>=20
> I'll put it on the list to ask the hardware people when I talk to them ne=
xt. But
> maybe Kan or Andi know without asking.

If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymor=
e.
It doesn't matter if PEBS is enabled or not.=20

See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
access in PMI "). We optimized the PMU handler base on it.

Thanks,
Kan
