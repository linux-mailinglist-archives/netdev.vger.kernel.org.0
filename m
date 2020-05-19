Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1881DA4A7
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgESWkV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 May 2020 18:40:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:18031 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgESWkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 18:40:21 -0400
IronPort-SDR: PxqtmizAMerb1n5uX5CQ+VBFKZMD6EZzFtqMnAbtJySmgzw6WbZ7k5VpzU36f4J3jwYS6/H2vN
 vsV9PsGZe0Yg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 15:40:21 -0700
IronPort-SDR: +BN4Yym2B6TWMFv6ypI0zhTt651+8uVBVqZPOLQpuGgIlbagG4URnZ+OfglZBTkQwx6tDtjJ3G
 NafzmltzxugQ==
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="268048035"
Received: from twxiong-mobl.amr.corp.intel.com (HELO localhost) ([10.254.97.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 15:40:19 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87sgfxox4x.fsf@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516093317.GJ21714@lion.mk-sys.cz> <87sgfxox4x.fsf@intel.com>
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
To:     Michal Kubecek <mkubecek@suse.cz>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Date:   Tue, 19 May 2020 15:40:14 -0700
Message-ID: <158992801438.36166.9692784713665851855@twxiong-mobl.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Quoting Vinicius Costa Gomes (2020-05-18 12:34:22)
> Hi,
> 
> Michal Kubecek <mkubecek@suse.cz> writes:
> 
> > On Fri, May 15, 2020 at 06:29:44PM -0700, Vinicius Costa Gomes wrote:
> >> Hi,
> >> 
> >> This series adds support for configuring frame preemption, as defined
> >> by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.
> >> 
> >> Frame preemption allows a packet from a higher priority queue marked
> >> as "express" to preempt a packet from lower priority queue marked as
> >> "preemptible". The idea is that this can help reduce the latency for
> >> higher priority traffic.
> >> 
> >> Previously, the proposed interface for configuring these features was
> >> using the qdisc layer. But as this is very hardware dependent and all
> >> that qdisc did was pass the information to the driver, it makes sense
> >> to have this in ethtool.
> >> 
> >> One example, for retrieving and setting the configuration:
> >> 
> >> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
> >> Frame preemption settings for enp3s0:
> >>      support: supported
> >
> > IMHO we don't need a special bool for this. IIUC this is not a state
> > flag that would change value for a particular device; either the device
> > supports the feature or it does not. If it does not, the ethtool_ops
> > callbacks would return -EOPNOTSUPP (or would not even exist if the
> > driver has no support) and ethtool would say so.
> 
> (I know that the comments below only apply if "ethtool-way" is what's
> decided)
> 
> Cool. Will remove the supported bit.
> 
> >
> >>      active: active
> >>      supported queues: 0xf

Following the same rationale, is this 'supported queue' going aways as well?

- Andre
