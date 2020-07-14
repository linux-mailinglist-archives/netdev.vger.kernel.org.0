Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C89121F432
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgGNOgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:36:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:13406 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgGNOgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 10:36:41 -0400
IronPort-SDR: 5kFZIPyyF5BX1olXUIdtRgpDiSNv3KWZdbkW2Lyhaopl2i8LothharO7VB1ekHbs/xxqdHpo3z
 HloZNSW3DqUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148044495"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="148044495"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 07:36:38 -0700
IronPort-SDR: 02iT5VGUP1t3TkSy4aSEJsgY7sdXokkPQAKZ4y4NCffmb8nZn4lAwYl4GgJeofeS+5NrExA2NR
 0UchQIao64sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="285772370"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2020 07:36:37 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 07:36:36 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 07:36:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.51) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 14 Jul 2020 07:36:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPPKkv3Tp66J/xFMdEN1qor7aGDfRZcjHqCTa1MK6vmuaSYIL/Z8mOqcayIyT6xn3tW5L/hr2nMVWZPpV1h5n4771v1cep5IegrrNzoy79/51yOJuXoa75cp/dlfDKb0Pej/KC+PwO9G1vNRLQTTMo2sesolugGgqbcnCOpbr7uloMa/oKnSkdkZ8/GTldDzrOSBkM7n+e1p+vF5HC92rw6Kt9Apf2+7/fhAbbmmvubo8FuH8mNZszKgStnhkQu9OY6+r/Sx7PGvhhLCjWtpzXTVp8y7nQUceL2EUnWOyk7I4Km32bLYYvpZxGKUlJXjXX3gnweFOGSeBzP3mC4ZZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CV6EG2GNIZI4Gmkg4r1K8J+CUfDyZuArwRXtqXafcgI=;
 b=mEhjod5M/q/YCfloc9pWwrQotMiAd7s/omYRQQsZ730lWGC5UV9NPCoHDC04qRjyRuuNd2YywgWSPNCHZc3pTLlG4+3JyuZjNWykFjkHIaKoeQDortfXmgAK/tPDoK010HwJ8OigHsD/qFt5icJVwNukIwUqm4AOWKgT56qN+aWVAlQzC+ZMJnDYpVuyIqOO/PkA4hm1xEWOzx5BWft1vICtSiSdJ+sXzQpriH72JaosUwZDp+tyZKGz5LDo+fCcLwUNN3+wVTlhbdJTmrasDbjjzi+6jxY1rePejckypkGk43Xy3bNbBR/ywaXm1wzTbmgiKHp/GafTd3Mt5ZQzOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CV6EG2GNIZI4Gmkg4r1K8J+CUfDyZuArwRXtqXafcgI=;
 b=HOrGs+FEzy9D4p4VrLV2TWe6HO55E4Ct/XpoMEA9O29jfpEcBXTmOPUHgoi1cQp/SXizGXSAOBsSaUwU2H5PB7vQdEvOP3w8w/uYWkXEnW8Ckh1muzWFCEXeI8wf1fWP1Whc5mGh9OBhGuMzHP5iZuxp0oBRpVPvVzf57sq1haY=
Received: from CY4PR11MB1253.namprd11.prod.outlook.com (2603:10b6:903:2d::7)
 by CY4PR11MB2040.namprd11.prod.outlook.com (2603:10b6:903:29::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Tue, 14 Jul
 2020 14:36:32 +0000
Received: from CY4PR11MB1253.namprd11.prod.outlook.com
 ([fe80::a420:1acb:6c09:c5a8]) by CY4PR11MB1253.namprd11.prod.outlook.com
 ([fe80::a420:1acb:6c09:c5a8%9]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 14:36:32 +0000
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "thor.thayer@linux.intel.com" <thor.thayer@linux.intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dalon.westergreen@linux.intel.com" 
        <dalon.westergreen@linux.intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "Westergreen, Dalon" <dalon.westergreen@intel.com>
Subject: RE: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Topic: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Index: AQHWVPkVfRS7e+4eCk6tElo6txFdaaj98fQAgAk8H7A=
Date:   Tue, 14 Jul 2020 14:36:32 +0000
Message-ID: <CY4PR11MB1253B09441D400910C611807F2610@CY4PR11MB1253.namprd11.prod.outlook.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
        <20200708072401.169150-10-joyce.ooi@intel.com>
 <20200708.103354.707974548958033107.davem@davemloft.net>
In-Reply-To: <20200708.103354.707974548958033107.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [1.9.122.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fb501b4-5930-4507-f532-08d828034d75
x-ms-traffictypediagnostic: CY4PR11MB2040:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB20400FD7FF1C1117E5A85E70F2610@CY4PR11MB2040.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JGT61Q4ptzq49sYCI+qFJJStZg/cRSQaozHC5lnWSSykd1Lz9/Yz7JUljc3Bzpbg8cJk+VzSSgf77We5ZV+4PnDHiZ5t9qOL4tbTYjdS1yX5hj3YYRswzsg0HLaQR5lWHliAGsrv6DWNO4Hx4lpfVQPeRfa+Mgg3wlsKiFZRaGaGSxwKcXSaurcAuKwN2S8Fs+GzJqARDYckSYICfCbxnmncWYfDOmE4xejQQFpunv4KbgTSGNMt965w2OlZ11x/lxKc3J9ukPHK0vdBp+xZFZJ5QV7CiWkYDE4ILLCo9IIZ7p+FRuOPb+g4riohUyDy0v0SXMQmS5sZSVxu0kP0gA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1253.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(2906002)(6916009)(316002)(186003)(83380400001)(76116006)(26005)(66476007)(64756008)(9686003)(66946007)(55016002)(66556008)(86362001)(478600001)(66446008)(5660300002)(52536014)(8676002)(71200400001)(54906003)(55236004)(7696005)(33656002)(8936002)(53546011)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /Gb4i8gN1wJMYvrrnA66s/AT+DFI+KssGj8UotlZKSf9hML/QgyTcEscIFjC0z4O+mnY5K71nONBkkaDK+auuvwTTBkB113AUKBMSf6MHPRSNUJUAoQQJKIT9dPvULEyTmEYAVLXKIDwgB546hz7UyeMUXI55TXluCJICF7HviH4fwnVb+oc7Ij62cRCUQTxGFnPGqJHrWI9E48XuNgV7l83wFexk3nJfDDtyQqkAElix/vfL9wT34dL6ZZ84y7VfG7qJpjAEMM1lqWpyYBm2Zbe95cesNtxqq7f7mDzOwOqh7Hdy8vpPYf5AGMc4x7buM8ZwtjL3lFDC/6Eo7wGTtOOPzy5s2V9LHVQs+l2HAVjJCAOD4qo6knNpjm9BOmO9F1oauT07vjT0k1DPO9DQPco8rszI1MXZaq/DTlXtWDLFrertvwWdW9KGexABjW0tz5KIAXEb+hGc+9Xz3rudhBpoiBBBFLRzzgDSLzJTZ4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1253.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb501b4-5930-4507-f532-08d828034d75
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 14:36:32.0695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4//UWvUgIzxSO2dpkX6E08S4wWHoCfFDXVSIfx3r9Qc98pWPEB94do+QeCBsgdHWIAFWttSSFRLgN9oQq+rPtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB2040
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, July 9, 2020 1:34 AM
> To: Ooi, Joyce <joyce.ooi@intel.com>
> Cc: thor.thayer@linux.intel.com; kuba@kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; dalon.westergreen@linux.intel.com; Tan, Ley
> Foon <ley.foon.tan@intel.com>; See, Chin Liang <chin.liang.see@intel.com>=
;
> Nguyen, Dinh <dinh.nguyen@intel.com>; Westergreen, Dalon
> <dalon.westergreen@intel.com>
> Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
>=20
> From: "Ooi, Joyce" <joyce.ooi@intel.com>
> Date: Wed,  8 Jul 2020 15:24:00 +0800
>=20
> > +int msgdma_pref_initialize(struct altera_tse_private *priv) {
> > +	int i;
> > +	struct msgdma_pref_extended_desc *rx_descs;
> > +	struct msgdma_pref_extended_desc *tx_descs;
> > +	dma_addr_t rx_descsphys;
> > +	dma_addr_t tx_descsphys;
>=20
> Reverse christmas tree please.
>=20
> > +netdev_tx_t msgdma_pref_tx_buffer(struct altera_tse_private *priv,
> > +				  struct tse_buffer *buffer)
> > +{
> > +	u32 desc_entry =3D priv->tx_prod % (priv->tx_ring_size * 2);
> > +	struct msgdma_pref_extended_desc *tx_descs =3D priv->pref_txdesc;
>=20
> Likewise.
>=20
> > +u32 msgdma_pref_tx_completions(struct altera_tse_private *priv) {
> > +	u32 control;
> > +	u32 ready =3D 0;
> > +	u32 cons =3D priv->tx_cons;
> > +	u32 desc_ringsize =3D priv->tx_ring_size * 2;
> > +	u32 ringsize =3D priv->tx_ring_size;
> > +	u64 ns =3D 0;
> > +	struct msgdma_pref_extended_desc *cur;
> > +	struct tse_buffer *tx_buff;
> > +	struct skb_shared_hwtstamps shhwtstamp;
> > +	int i;
>=20
> Likewise.
>=20
> > +u32 msgdma_pref_rx_status(struct altera_tse_private *priv) {
> > +	u32 rxstatus =3D 0;
> > +	u32 pktlength;
> > +	u32 pktstatus;
> > +	u64 ns =3D 0;
> > +	u32 entry =3D priv->rx_cons % priv->rx_ring_size;
> > +	u32 desc_entry =3D priv->rx_prod % (priv->rx_ring_size * 2);
> > +	struct msgdma_pref_extended_desc *rx_descs =3D priv->pref_rxdesc;
> > +	struct skb_shared_hwtstamps *shhwtstamp =3D NULL;
> > +	struct tse_buffer *rx_buff =3D priv->rx_ring;
>=20
> Likewise.
>=20
> > +	} else if (priv->dmaops &&
> > +			   priv->dmaops->altera_dtype =3D=3D
> > +			   ALTERA_DTYPE_MSGDMA_PREF) {
>=20
> This is not properly formatted.
>=20
> On a multi-line conditional, every subsequent line after the first should=
 align
> with the first column after the openning parenthesis of the first line.

Noted, will make the changes.
