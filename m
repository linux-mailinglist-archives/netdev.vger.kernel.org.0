Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE0B5AE569
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239258AbiIFKcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 06:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbiIFKb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:31:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF324C616
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 03:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662460313; x=1693996313;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=VZLbfPANUhHImthg74XfBWEQ3vO2sOkNvqIScnkNN0I=;
  b=eNzcXM/gId1AYUqK8IA+wQiX919+6VS1OXtZSL4xZ744lK2NSXfBJ6ow
   wFHUKcJyYB9wrtlpM9/X+OlKkionIV457zL8c8u/+uo1pk0Sz4Xav8vKQ
   1AHRFkd5zd99HP7fOjmtZDztcelAYZh4BcEPj9NuzdykTX8XfzMotUAs6
   U9mg+dEGQbKIfCPogQZSHI/lWMBmMeu/zjI8Gmr86mOcU6BszldAG1IzC
   pZKAvItq/S6BiSsLROj1zWUfeSTsqrA6bpoh/yAMs8rgiza24TMHc7uL7
   9fwToK7NMxJYd2Q/qdiWb/LnkQviz+3a6u7K6SE+rjJez/9XRHyZrlqcW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="297345088"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="297345088"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 03:31:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="675636869"
Received: from cjoldes-mobl.ger.corp.intel.com ([10.249.45.236])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 03:31:48 -0700
Date:   Tue, 6 Sep 2022 13:31:43 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
Subject: Re: [PATCH net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
In-Reply-To: <15e9b3bd-5d3d-7b44-758f-4013b61e51fa@linux.intel.com>
Message-ID: <6cceb17f-8010-209a-a845-3fe9bcd332ab@linux.intel.com>
References: <20220816042405.2416972-1-m.chetan.kumar@intel.com> <487238cc-4bdf-b5aa-cedb-61ed1a299f41@linux.intel.com> <15e9b3bd-5d3d-7b44-758f-4013b61e51fa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Sep 2022, Kumar, M Chetan wrote:

> Thank you Ilpo for reviewing patches.
> Will address patch4 & patch5 review comments in v2.

A small correction & one additional item below.

> > > +	read_len = count > skb->len ? skb->len : count;
> > 
> > max_t()

I should have said min_t(), obviously.

> > > +	actual_count = count > txq_mtu ? txq_mtu : count;
> > 
> > max_t()

Here too, min_t().

> > > +		if (read_bytes < 0) {
> > > +			dev_err(port->dev, "status read failed");
> > 
> > Printing "read failed" for -ERESTARTSYS/-EINTR??

Missing \n. There are also other similar dev_err()s, please check them 
through (and perhaps others too besides dev_err()).


-- 
 i.

