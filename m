Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37F21DA4A5
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgESWkC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 May 2020 18:40:02 -0400
Received: from mga12.intel.com ([192.55.52.136]:15184 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgESWkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 18:40:02 -0400
IronPort-SDR: US3O/oWUdiGEA6vDld15I7eRMdTBV1kSLP7QtlkI5+EcQzxbSbYPz3gfduzPQaAvN3Dkk0D9p1
 7/Yh7ynPKRgA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 15:40:02 -0700
IronPort-SDR: /Th1+z8ehhqt38oT9/3cHmqcYgThu7VTOmYANFyXjdfXxutI415n3IMm2hMdxZtfJRnmt0ojIQ
 mHReObVM8IJw==
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="289134456"
Received: from twxiong-mobl.amr.corp.intel.com (HELO localhost) ([10.254.97.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 15:39:58 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200516012948.3173993-1-vinicius.gomes@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org
Date:   Tue, 19 May 2020 15:39:54 -0700
Message-ID: <158992799425.36166.17850279656312622646@twxiong-mobl.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Quoting Vinicius Costa Gomes (2020-05-15 18:29:44)
> One example, for retrieving and setting the configuration:
> 
> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
> Frame preemption settings for enp3s0:
>         support: supported
>         active: active

IIUC the code in patch 2, 'active' is the actual configuration knob that
enables or disables the FP functionality on the NIC.

That sounded a bit confusing to me since the spec uses the term 'active' to
indicate FP is currently enabled at both ends, and it is a read-only
information (see 12.30.1.4 from IEEE 802.1Q-2018). Maybe if we called this
'enabled' it would be more clear.

>         supported queues: 0xf
>         supported queues: 0xe
>         minimum fragment size: 68

I'm assuming this is the configuration knob for the minimal non-final fragment
defined in 802.3br.

My understanding from the specs is that this value must be a multiple from 64
and cannot assume arbitrary values like shown here. See 99.4.7.3 from IEEE
802.3 and Note 1 in S.2 from IEEE 802.1Q. In the previous discussion about FP,
we had this as a multiplier factor, not absolute value.

Regards,

Andre
