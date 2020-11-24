Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4112C2A6E
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389134AbgKXOtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:49:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:51023 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388014AbgKXOtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 09:49:12 -0500
IronPort-SDR: 5Oj7SWxwgeWFD5cnX5axRI39L2UjRyuKgwnImZ2xUDzYeNOYVhuEDSELBXw7eP/b4505aaTEfH
 eP1x3bDwAh7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="151214211"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="151214211"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 06:49:12 -0800
IronPort-SDR: SAkfJU2/Op1SYdzAUg4pP4G0GnAwOSA4aCbJQ5NqSBZSMlYANjM2cHQw3T1wrx5VtRryoCb6Zb
 rms5SW+wjq7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="370389355"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 24 Nov 2020 06:49:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Nov 2020 06:49:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Nov 2020 06:49:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 24 Nov 2020 06:49:11 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 24 Nov 2020 06:49:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkSlPaH10/hdTmffSL3IVKYC/YCopF/mioxdOOjBPYe9pgjDblWdjWApu6inEtxDrY165mZIEjauIcOS3Fu9oL/m5S7T0cY0X5RHxwfl5b9JqY+RGMIVMvf4a5pTPPq/Heu/831nUKQQhvJlz/kKe9StFdeBALSH7KpZfKerSW0mzyoBuRZ1rK4QRNhwxVUvLts+5nvpQMXzyxhUhTaKHgTkmTWMC6BviVXD2WdVfzUetgF9Sm5oyVEjoK1bzxmybH7CLeiwh6ROk/1csxuZXqFJunxoeu7i0qaCirEK38Ols2gz8MI7CB7RRX6/EvDpnj1tsdNsi/1usZLh5BdEHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lK5/IZCiE/WZt3NaKoclVDEfdHy8BRhbXLt0abAM7Rw=;
 b=da3RYu5DlS6147TcGgdesdiOvhYOyE5xOZjj4z9ScAmflWlvR5bzYeSVxSeSigGfKUiaB70pVxZvEEoitS2JBW046JgH6OA/S+0dO6CBlBY0icg2VtVR2qbjZqWseTA3k65oep8dMOSoWpy3J7TeAe0J9DDH8TXvNmw4E2XPkw2Hp549voPoMLAAX9p2NfF9zBYSZ5YX7qXCEOOHJKc2mtt12H9QlzAiT6cCLj7jeLlSDEtDBkkkcdlAgFKV4p8927ru1rf/4rt53TRr45tIe1pECeVlP66JB4f73NvzOO4XM2epFGFU1hAxrfM0ZIBkLEoX4+B0cZyl8sHoCfFghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lK5/IZCiE/WZt3NaKoclVDEfdHy8BRhbXLt0abAM7Rw=;
 b=r4+GenVFkXyWZDdhJspe2gJHZnmQEpCL928vApGo2I5R2DHXkq7AYl9l6Klfw1BLCAFRTi6Xnwc9rc7PLPoxc9UjsMqez/+CteaR17wtfK/69CNfYRCUrRkvrn02H2puNYLSJNuSnfTUyjq0oYmudn0gBUFJNmfCfsa9nWCh/mw=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 14:49:09 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393%7]) with mapi id 15.20.3589.030; Tue, 24 Nov 2020
 14:49:09 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: RE: [PATCH v4 6/6] igb: avoid transmit queue timeout in xdp path
Thread-Topic: [PATCH v4 6/6] igb: avoid transmit queue timeout in xdp path
Thread-Index: AQHWuEzayLeESENpYEeR6cE7H02DEanXcCqQ
Date:   Tue, 24 Nov 2020 14:49:09 +0000
Message-ID: <MW3PR11MB45543A4F861FB94DBF2B01589CFB0@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
 <20201111170453.32693-7-sven.auhagen@voleatech.de>
In-Reply-To: <20201111170453.32693-7-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: voleatech.de; dkim=none (message not signed)
 header.d=none;voleatech.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [106.51.234.17]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9420e498-2f6c-4953-0199-08d8908819d1
x-ms-traffictypediagnostic: CO1PR11MB5027:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB50273E0827492028E20203479CFB0@CO1PR11MB5027.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d/n92Pmw1nJx7/vxbgTJhLVA3TjLZYpoCg664FaKt1nlwkRwrTL3XBQZCqoZpXyWnM+F5ew9I7V0EC9m74nXn0OKfDE2Fg45LFEschRRHd/zdVK59fONokuKNmdFgR8r4Khj+ixVbDOZxw4e16cA5v2IqFXU3X0aZGbbeeUGeQnjTAQJSNZfONzeJhrLLCDyYiObkS/8De5uR2eWxLXgg/CQrNdxQW3EQToCO8uP/sb7TmnAOUpw388QHtVYpD26yzxi3+ymSf8nqXKyc3JyFY1mqygfaYXucT9AFz7E4VNCII6+KVJ4xUSHvZVFV7nE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(9686003)(186003)(52536014)(33656002)(2906002)(478600001)(55236004)(54906003)(316002)(6506007)(26005)(110136005)(53546011)(8936002)(66446008)(7696005)(71200400001)(8676002)(66556008)(5660300002)(64756008)(86362001)(66946007)(76116006)(4326008)(55016002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: u+vC0FwyxM8E3RS8PTnSb9dycCCo69EmJhfEWXZWJlNze+2YJhAgMZTh4tXl4/ex3oN1mcSbyUmtcIZkFRMmKgrLOn/pEHesaasKTFJv5d1se2dfusngJgIzwhUl8G1hIo4HDxLqq+WckuolZhG1YlxfMyEkBdqrHQXHxPqkjc6elmlR7DWM42D16hozNG3Ckx0gXjFQsKO0vgas4BnV6EIdw8OUxsoN8sChEMkVoRDDO+3gdTiozO+X5uEb1I5IrO/JU2p10R5+vo7F+vxDH84sp6nl95vuwEc5AVymM2Z7udeZG3S4npvvwQiWi/ZnxXEpy36uFVBMOyyRvo2rz3knpV5YupUpQay22tESpD3sO2fM0Ep+0D2srtY+nFt6fiXEIfeih6Jo2d7CEulV0MncnMOhhK0v2+X5ri6MiPGxBovj4PJKQn5w7+ynsMzq5TvP8RA9kXWFdvXPJmomYiIbw3xnM/3qEWKtrkFCTJM1IJOlxHgxXKdEHDPDz96iMMJUiCdMtz9V+V+HZeyZfz1IL0qgGNTKcluAVWONQVerwbUcfC93BhfGPm3Q1d+BWnpeyuFrXbrjR/jrrzuHV2j1kvlyQT2xgI1v2Cslh7a1ONR9XohaM/G7zqSUup5tyGr1NyxMd2pqeu5I/H5P6+bvySFn2bmmy7DFkf9FGEiajmFXdTkzinfu4PlWzwPu/NZAgeE5ABaqVOJr+XOWQ4aaaThZ3XSIIRDtVMEd3x17VHPPKpDBcxPGnBLv/dwyZ6+ri8+ILhp2j82nx2AzkOjHx9P+vC3xHEMz9/zCKil/xjIaWHN0pP86uZRJIYckkslYzj2Ty8H3e1YxaYIfW3Vb2+7Q6GP4we2qN5oN/HV373Bv4I1LrJgcYt4/U/fDXHBxF/ME+GN0aowAe/bUvQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9420e498-2f6c-4953-0199-08d8908819d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 14:49:09.4631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3FS+46uf++Wu7M47XEzkBgApQYJZjWplcUIxX8dve8qyxt6id2gbek2m38Mpw/x8PFZ2vM6vSg7fE8BfacCKHe5kCNYtKrqZwPqDCqbw5G0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sven.auhagen@voleatech.de <sven.auhagen@voleatech.de>=20
Sent: Wednesday, November 11, 2020 10:35 PM
To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Fijalkowski, Maciej <ma=
ciej.fijalkowski@intel.com>; kuba@kernel.org
Cc: davem@davemloft.net; intel-wired-lan@lists.osuosl.org; netdev@vger.kern=
el.org; nhorman@redhat.com; sassmann@redhat.com; Penigalapati, Sandeep <san=
deep.penigalapati@intel.com>; brouer@redhat.com; pmenzel@molgen.mpg.de
Subject: [PATCH v4 6/6] igb: avoid transmit queue timeout in xdp path

From: Sven Auhagen <sven.auhagen@voleatech.de>

Since we share the transmit queue with the network stack, it is possible th=
at we run into a transmit queue timeout.
This will reset the queue.
This happens under high load when XDP is using the transmit queue pretty mu=
ch exclusively.

netdev_start_xmit() sets the trans_start variable of the transmit queue to =
jiffies which is later utilized by dev_watchdog(), so to avoid timeout, let=
 stack know that XDP xmit happened by bumping the trans_start within XDP Tx=
 routines to jiffies.

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++++
 1 file changed, 5 insertions(+)

Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
