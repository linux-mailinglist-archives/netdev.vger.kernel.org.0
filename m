Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC54C43E2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbiBYLsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237962AbiBYLso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:48:44 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0481B158D91
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645789693; x=1677325693;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zH4b+OPsc/eRXIFFSyTGqOkoK5ujPq95ixybsZet6EQ=;
  b=U1zZ4DSprtfHd0kV0Ac5CRP6kHPQ2F4z/7FPKZoc5lKaJtn5osSEzwqJ
   L/4PUA1RfvtDzK7CixVL8B9FwhY2ht+JbA2XROgD8Gy9qNT6dQzOeO5Nn
   ZydunXprENWe+PhlB8LhY7v256s5bv7GPOpbt4eQaPVV9YHjHff/SOBDe
   eowOWgF1Ve7E26gEC+86CYNL5FcLbuWiG+QjHt9rIkYbyj0XZ4xcHbSRh
   /Ku6V6NcO08D62P8bqxEkEPcWwxngnrP6OOMDPVX7bRVEAo0NPFjdB+Tm
   OPzkXKYs9t11twYBg1BHS5d7+Uayjxn4OKht37u02/+TbfVCA19fVCuHS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252210894"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="252210894"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 03:48:12 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549231300"
Received: from mszycik-mobl.ger.corp.intel.com (HELO [10.249.159.102]) ([10.249.159.102])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 03:48:09 -0800
Message-ID: <f11878c1-2486-b777-9701-912b048e5f0e@linux.intel.com>
Date:   Fri, 25 Feb 2022 12:48:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v9 0/7] ice: GTP support in switchdev
Content-Language: en-US
To:     Harald Welte <laforge@gnumonks.org>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org
References: <20220224185500.18384-1-marcin.szycik@linux.intel.com>
 <YhgKO8rdxMxclZPm@nataraja>
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <YhgKO8rdxMxclZPm@nataraja>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

Thank you for reviewing the gtp part!

On 24-Feb-22 23:44, Harald Welte wrote:
> Hi Marcin,
> 
> On Thu, Feb 24, 2022 at 07:54:53PM +0100, Marcin Szycik wrote:
>> Add support for adding GTP-C and GTP-U filters in switchdev mode.
> 
> For the changes to the gtp.ko driver this v9 looks fine to me.  I cannot
> comment about the switchdevs bits, those are beyond my expertise.
> 
> Regards,
> 	Harald
