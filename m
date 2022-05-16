Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E785286B2
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243193AbiEPONR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244080AbiEPONN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:13:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9D832066;
        Mon, 16 May 2022 07:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652710392; x=1684246392;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q8T0jBh7cGQQ4AUWl+1aBVbwpP+Txn2+ZD1GDsXUmwY=;
  b=M49qI2RJYNeFyww4GpPEloAJZf3RvDjzRG/yy1d94WdKvwT70eNfFVah
   rHztlRV/mWPf6deUpgZmot8zsEE3Sy4c/WuAal94+s7f8JXFx2DBmFSEJ
   LJ/nAuUNJhgdsbdkTnhBU+aPmZqkuYbowLgerMOOuCzCnpZ7+BFG4OOUG
   E5oQgCkYYpvy3ZH2pI4dWq1GLRVAS14Mc3vr9ZJme/SJAHxU9qCXD4JuQ
   BDOOW2soJYlGtKzCHw7/1xW9gkEGPhH/YmvpaVjd9dorsFmN8inO1eeib
   YgU4SB2U0qnzuooP5UuyHm64U2EzZu1f37bbqi0xs4zewgcHeRUaZ5voi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="252906637"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="252906637"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:13:11 -0700
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="638258613"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:13:05 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nqbQv-0006ib-VU;
        Mon, 16 May 2022 17:10:49 +0300
Date:   Mon, 16 May 2022 17:10:49 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Wolfram Sang <wsa@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mark Brown <broonie@kernel.org>,
        chris.packham@alliedtelesis.co.nz,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Subject: Re: [PATCH v2 4/4] powerpc/52xx: Convert to use fwnode API
Message-ID: <YoJbaTNJFV2A1Etw@smile.fi.intel.com>
References: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
 <20220507100147.5802-4-andriy.shevchenko@linux.intel.com>
 <877d6l7fmy.fsf@mpe.ellerman.id.au>
 <YoJaGGwfoSYhaT13@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoJaGGwfoSYhaT13@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 05:05:12PM +0300, Andy Shevchenko wrote:
> On Mon, May 16, 2022 at 11:48:05PM +1000, Michael Ellerman wrote:
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> > > We may convert the GPT driver to use fwnode API for the sake
> > > of consistency of the used APIs inside the driver.
> > 
> > I'm not sure about this one.
> > 
> > It's more consistent to use fwnode in this driver, but it's very
> > inconsistent with the rest of the powerpc code. We have basically no
> > uses of the fwnode APIs at the moment.
> 
> Fair point!
> 
> > It seems like a pretty straight-forward conversion, but there could
> > easily be a bug in there, I don't have any way to test it. Do you?
> 
> Nope, only compile testing. The important part of this series is to
> clean up of_node from GPIO library, so since here it's a user of
> it I want to do that. This patch is just ad-hoc conversion that I
> noticed is possible. But there is no any requirement to do so.
> 
> Lemme drop this from v3.

I just realize that there is no point to send a v3. You can just apply
first 3 patches. Or is your comment against entire series?

-- 
With Best Regards,
Andy Shevchenko


