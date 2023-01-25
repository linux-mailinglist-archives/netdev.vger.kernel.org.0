Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A886D67AD64
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 10:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbjAYJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 04:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235009AbjAYJKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 04:10:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115C942BD2;
        Wed, 25 Jan 2023 01:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674637802; x=1706173802;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UvW5S0LJWAahqv1jsGj5wFg5oygg9gkQSJazBmcLTo4=;
  b=GLPEO4DBazihkRnZm2WEzlfPdP7ncbg63dNtjQCi3VZGVLBIDE5Hr52P
   XldlNgYpbNMcyI9EltrPJz/zRX0GKKoip3vThrAYy6xygTP+EXTdaSINW
   P97z0WSWtO43bR9rhh6WMC8HxkrgGRXShN2PJesj96Q1KEZxq4FWh1wcr
   3lV25B3z8R8Z//4EbxlzAC9j2+zeHuzMoYrLCu2Dix9e7DKA/IYXXePQv
   5kArQJ2uyVUyfQ0F9/WZkSV7PS3AbCzK45tS6wL/wfr17SW+V1q82ae+J
   VXdjiXw8bwN+8z9AxH4wdI6696+dlntl3Z+dwYviJ1w9jixCktOSI1VPI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="391017970"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="391017970"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 01:10:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="836287610"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="836287610"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 25 Jan 2023 01:10:01 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 25 Jan 2023 01:10:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 25 Jan 2023 01:10:00 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 25 Jan 2023 01:10:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IssJ/WdgNxwGWTyYmsjd+xPnZf6nsuoEtfrtRaN0y2Ed4PaL5pbQuaNvYnKpdLvYZjx1f9AceRWqm1GTb3XitRUpYRduy41V0WaJp93r1j2XQw3vVUQloOuzmdqV50qLDXnOki8lzFjXuqUtQv8zy93u0ce9tlMFEfwW0CYSSqZeScsU37sQkpCqqbO6+YHKjvFbApYmjYDrNbosF+rUYsi5bR2a1FrRM/VlLEK7sB7VlfwH+Zn5/Qlhi/FWS8qKOcmgV6yFjSYPlT3j7B5T+w0aSBafuPCEG0E/kq2DuKetwpVWlW5/B/fxpegG7FptpXbpnRYEwixqhuU3ELepWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kajx3WU1ZLpx/yTGR1BSPOQiZl5nvXOc8yVhrERZB/0=;
 b=lWwCDynP2mi4doIKB5etTJ1fwQ8MzOuvtWDmKPVGAO1z4wF6/aOGfCJkjLuJytsFwM3kCu304MVSCHJz87LCnMuKbao9Grya9bLy84vTD2Gg32A3aTi8dJo2JbWq5q+z4+ndcd88luAC0FXdCh9LrAaOW+r+E5bmgNfV5vxsIPX24in3jBiHjW3PE68VH8MEFckfrOFiTmr1nizpv0TsTK2ybNY5XQoK6nbwUySMeX80Fr6I0QdKALdeGh90d3vut4vkwuN6DS1+G3CCcQZ0oijlyHChOBP9ElWg8W5Mv8n4oNRUjmSJuQLGwNiv1VRtGCgWaZp+a5Qxra419wZ3aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by CH3PR11MB8154.namprd11.prod.outlook.com (2603:10b6:610:15f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 09:09:58 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 09:09:58 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH 9/9] ixgbe: Remove redundant
 pci_enable_pcie_error_reporting()
Thread-Topic: [Intel-wired-lan] [PATCH 9/9] ixgbe: Remove redundant
 pci_enable_pcie_error_reporting()
Thread-Index: AQHZK5dL+2cRUCQxxkW3v/EjtMm2Ra6u4kkg
Date:   Wed, 25 Jan 2023 09:09:57 +0000
Message-ID: <BYAPR11MB3367AC0791822F3AAD3EECA3FCCE9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-10-helgaas@kernel.org>
In-Reply-To: <20230118234612.272916-10-helgaas@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|CH3PR11MB8154:EE_
x-ms-office365-filtering-correlation-id: d822cba9-d941-40f6-ff59-08dafeb3ee74
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J0zeGtQqOVecLiCxbyxyAVd9oF8zKykFTETeM1I7NS2nhgL9nvTk+YfMQ4XBleob03HzLiHUcDugesSuv1dFGz77FrTGlIP6TcJkzlB55ttzicqIwOhceLDXRUBkdBavHhGQdMGiriK1+3dMqOeuaX8i+1th2Z5Snlr1ln67nv6iCq3DfXB0R6nodLbiwAndVli/3VORPry7h02drSl6xDsjl+3OPzkrxyd9D6EhXjziKmud/amAhxQzhHtQ0AJq+T/WKIeQ63886sxGa8duyfIdsLF0Iw3c9xi+LzRj4NKiKiwy8D4Nyov5SpL5BYcD0ZpH7V8TO64KmQPIXAa7VWlqyl6evu7v9iGOY4daQDnVD8v/XwGhYM9sW7Ry40vEIXMLcWbIe4u/OriU4vRTCVusqLjrMO6PBzb09x/iaj39ULX5lusfGXm35aAQS56G3G8NHbR+XEND7bOA85TtXhg+Cbs3Byl4zi6QEuufuldzBxMvCvdMuGXSTJFrYjZ65oPmoLMgR2M75YyZaqfD4JUmXJJnCq3RtnpD+7bic1aA1M3O3r8mq578pUUr6YbE5A0k431umzrElViCIscde47zlnRJRPMaXR8B+r3mIXJ4apfPCyuwxuVXKMWN57+3Mzo7fE4195G7BIJPzbvR1tOq8JvSUfdX+d+9w+mZaf1AUcfrNfCUfzH6uNerdL2ZEAsJR7G5HeHNS1YyV7AY1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(33656002)(38100700002)(82960400001)(122000001)(55016003)(52536014)(8936002)(9686003)(186003)(2906002)(86362001)(53546011)(6506007)(107886003)(66946007)(41300700001)(26005)(5660300002)(316002)(83380400001)(66556008)(64756008)(478600001)(66476007)(8676002)(38070700005)(110136005)(7696005)(71200400001)(76116006)(54906003)(4326008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ePW0Zu2d+v/etuM/g2d1rWTec0rB0R/BnyDO0/FPV/OAHHeDF/CP9jK6ZlbL?=
 =?us-ascii?Q?mD+01tHPMW6/iATKL6JwTj18KCNHybZBZ/I2CD6UEFaYpN6sUPsljgwLw5/o?=
 =?us-ascii?Q?A5Me6fYio65XErjX9/zntuLJwtCYoVsXX8i+DvAPj4P/rdwz/6RXmZloKdAL?=
 =?us-ascii?Q?h3AL8ar1P/N57mRB/yeYiizpuHIw7/SsopYfsiDbuL04mHhzZ+IzvCUpe53w?=
 =?us-ascii?Q?gsm256eSHZ+MyxjZmf7plkF50DqBMX+E5+BJNODVeSL0pzI0Jm0Lh8BeTJcV?=
 =?us-ascii?Q?V+r6qRAhotFr3Il5V5rUFn4UGfTTD7cza46FJ9853KZAdv0rPoEDOC8URFUs?=
 =?us-ascii?Q?OVmWRxtw12dhGKyZOpvtUkp3rdKwjwwXCDnbOG5R9X2zs4gBdLj3nGcas8MM?=
 =?us-ascii?Q?6q0DHfwGTVFpA4LUNkjleH3/Nj+zil/XrPLL3fmwnJYYgzlmq6jFj7IHhDPM?=
 =?us-ascii?Q?g43kWSK33Fn4WSg8r2TA/lOqxUQpQEBYOkCmBptxq+IOCWjcig9+Gmd6N4PM?=
 =?us-ascii?Q?rb2PThM29xtzpIM0CCMyp+M/hf7gxl0BeJrsW1lKKgLhLb1GSU+a+iJ/j14k?=
 =?us-ascii?Q?L8IdSuoEtaWLZtp7IUqwduht/39Rgi3qIiuJE1xW8DPZRdvxxTtBM9rCy6kS?=
 =?us-ascii?Q?/BZctBRno9m5Gbp7yiWlXCiC2ezEyHj94i2NTT95due5FKc2gG4TDPaaRFqc?=
 =?us-ascii?Q?We+8J4o2D+8iNKkcBG1PwQ65QTY1HYxP//hy9Rvlw05T4L3tnznvqDzTbZRs?=
 =?us-ascii?Q?3LUkBeObnKTyt9YktcaOTbkjy+HVbLX1/8d4keZNxIoos3iP41/wTuBB8zSh?=
 =?us-ascii?Q?18dsEMD7bnikvK9m9RibfbAHPeNSa8+MVYzeeM/wHitxqgu/GRk4CD7rxADv?=
 =?us-ascii?Q?BJusp0aFssfewrnAxgeOUkiIaTF7x911Xt0K2p/LEX0ZpDDIwlvRM4hg4fgC?=
 =?us-ascii?Q?qjVUJp66wwwCphs1Q+qJQfuvqH5447bJDxAHT9n9KJ9vs0NUNy8NHeYKX1sp?=
 =?us-ascii?Q?/1MtJWEJYQyhtlTcY0BkJYhh0u4DhNiv/N2mmCd0Q3QYDvra8bF2xHRaJSHr?=
 =?us-ascii?Q?uhk1ELmqVAkY167PVtUj83FZpX2baSZKHLTbq2uSxXRuX2HwkY8B9IJRhlSs?=
 =?us-ascii?Q?a3haH1CB0k1VXmFcmmcsgLqf/T5hqi86H+bmXMXBdA8PA3mYY7G4H/g2GlCJ?=
 =?us-ascii?Q?QdBfcGVq2arK26e8hTtYKWUcLoIQhyMqo5dMwMlhx6kO53ncnGpPXPKI1bnb?=
 =?us-ascii?Q?iu1rp3+vtHmg5EpmPQiUXhJdOHDh2DQCSlq6gP2cOt3Hi4pd0UlezKZl6OQ7?=
 =?us-ascii?Q?DwZRv2Fcvordx3bnfuvTT8TRQ7oddrSRHRG4v73/lML3us4U0Qc/v9ZKzNhk?=
 =?us-ascii?Q?pgwNE3kjX7vVrzQ+RVDUkrsqE0q0oLKGCBnL1lX6+cRwxdbQX2LvbY6CUqAn?=
 =?us-ascii?Q?LSgZp8oFmBYuV8h3Rv4b0cMqFbJvTWiOyt9jL6hRMwEQWriKrLsMS+1CEwEX?=
 =?us-ascii?Q?+V+LgrMUZ+OtGQxESYXHeEDgOog2/VH13K0iAErW1uFlGYiJhnksRSKx/u0N?=
 =?us-ascii?Q?fXMNdTMBtms6/umfux8Piin69PzuuqElaImmT+n1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d822cba9-d941-40f6-ff59-08dafeb3ee74
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 09:09:57.9280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MMLP0ToEaSom4SfUJNbzH2MU0cSTjhrpGWsNzjX9GNhfNehjahCJ6pcCmT5c7TfiUvIJvrCI3ALESUVKwikyqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8154
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
> Bjorn Helgaas
> Sent: Thursday, January 19, 2023 5:16 AM
> To: linux-pci@vger.kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Brandeburg,
> Jesse <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org; Bjo=
rn
> Helgaas <bhelgaas@google.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: [Intel-wired-lan] [PATCH 9/9] ixgbe: Remove redundant
> pci_enable_pcie_error_reporting()
>=20
> From: Bjorn Helgaas <bhelgaas@google.com>
>=20
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER =
is
> native"), the PCI core does this for all devices during enumeration.
>=20
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
>=20
> Note that this doesn't control interrupt generation by the Root Port; tha=
t is
> controlled by the AER Root Error Command register, which is managed by th=
e
> AER service driver.
>=20
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
