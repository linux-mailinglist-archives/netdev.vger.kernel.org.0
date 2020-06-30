Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85420EA28
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgF3AXL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 20:23:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:35538 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgF3AXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:23:10 -0400
IronPort-SDR: rhcz58BoY4QTFbiwY/wKe4Bn72LNZwJQqCxzG6HTLF0KL4OENeI5srPYqnfNr6VF2fa7Q0oGLd
 KzJCsbqzUKzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="125737999"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="125737999"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 17:23:08 -0700
IronPort-SDR: 3schkN4TTgq9JBq62uwdZncAF4vA3fEyF8QB4sNUtLDW/WmmZFstiwGOzanIJgImGrRZ4GTmGM
 4MxdmmaqACtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="277252852"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga003.jf.intel.com with ESMTP; 29 Jun 2020 17:23:08 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 17:23:08 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.71]) with mapi id 14.03.0439.000;
 Mon, 29 Jun 2020 17:23:08 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Guedes, Andre" <andre.guedes@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Subject: RE: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of
 ptp_tx_skb
Thread-Topic: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead
 of ptp_tx_skb
Thread-Index: AQHWTCXsTTAAFvg3U0eh6m/k3SxvaqjsVHOAgAQ2vQCAABZIgIAAIFUAgAADeoD//4sgcA==
Date:   Tue, 30 Jun 2020 00:23:07 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D9404498741999@ORSMSX112.amr.corp.intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
        <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com>
        <20200626213035.45653c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <159346389229.30391.2954936254801502352@rramire2-mobl.amr.corp.intel.com>
        <20200629151117.63b466c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <159347562079.35713.11550779660753529150@shabnaja-mobl.amr.corp.intel.com>
 <20200629171927.7b2629c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629171927.7b2629c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, June 29, 2020 17:19
> To: Guedes, Andre <andre.guedes@intel.com>
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brown, Aaron F <aaron.f.brown@intel.com>
> Subject: Re: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead
> of ptp_tx_skb
> 
> On Mon, 29 Jun 2020 17:07:00 -0700 Andre Guedes wrote:
> > > What if timeout happens, igc_ptp_tx_hang() starts cleaning up and
> > > then irq gets delivered half way through? Perhaps we should just add
> > > a spin lock around the ptp_tx_s* fields?
> >
> > Yep, I think this other scenario is possible indeed, and we should
> > probably protect ptp_tx_s* with a lock. Thanks for pointing that out.
> > In fact, it seems this issue can happen even with current net-next code.
> >
> > Since that issue is not introduced by this patch, would it be OK we
> > move forward with it, and fix the issue in a separate patch?
> 
> Fine by me.

Since your fine with Andre providing a follow-up patch to fix the issue of missing locks, I will go ahead and submit v2 of the series with the small fixup in patch 1 that Dave pointed out.
