Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F3452A7F0
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350906AbiEQQaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiEQQaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:30:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D7227FCB;
        Tue, 17 May 2022 09:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652805015; x=1684341015;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0NqJ5VwhtJ3tBjditXPJfSf+c2F9/tHzdRAp1qZ01bI=;
  b=j3AfRc0u6OCgoEwPQjh4bdI+1qJ1h9afmuYsbH6RsFzvEOkr7hoc7J5o
   LXchL9r5h3bxJIrV6QosV5BwOqn6TZZlg9nM8veaGnrzGUeGsNzA4FWzM
   HkYg/B+aEdQ8ZkO/MUdJqUV4GiRarnhm/uDSPW/YXPny2ZYSr7NUyi+oB
   aVify6KIhjZbva7ea+b2o37ilAq9NdOmu9Rr/smq2t/fyinqrzgTo7rzW
   X1X9W3YRH3bty1uTDFyQzRo58JAFiep9vEiTPJYx60NY1pYBtg/Llc5xs
   sZFY/lPSTwlwdwk5Hmoux4dlQfFZTDOHuL2dtNASITWI8qKmzhCEwglKN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="271364116"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="271364116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 09:30:15 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626561602"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 09:30:09 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nr05E-0008C4-Vy;
        Tue, 17 May 2022 19:30:04 +0300
Date:   Tue, 17 May 2022 19:30:04 +0300
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
Message-ID: <YoPNjPp3LMF2+qKS@smile.fi.intel.com>
References: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
 <20220507100147.5802-4-andriy.shevchenko@linux.intel.com>
 <877d6l7fmy.fsf@mpe.ellerman.id.au>
 <YoJaGGwfoSYhaT13@smile.fi.intel.com>
 <YoJbaTNJFV2A1Etw@smile.fi.intel.com>
 <874k1p6oa7.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874k1p6oa7.fsf@mpe.ellerman.id.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:38:56AM +1000, Michael Ellerman wrote:
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> > On Mon, May 16, 2022 at 05:05:12PM +0300, Andy Shevchenko wrote:
> >> On Mon, May 16, 2022 at 11:48:05PM +1000, Michael Ellerman wrote:
> >> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> >> > > We may convert the GPT driver to use fwnode API for the sake
> >> > > of consistency of the used APIs inside the driver.
> >> > 
> >> > I'm not sure about this one.
> >> > 
> >> > It's more consistent to use fwnode in this driver, but it's very
> >> > inconsistent with the rest of the powerpc code. We have basically no
> >> > uses of the fwnode APIs at the moment.
> >> 
> >> Fair point!
> >> 
> >> > It seems like a pretty straight-forward conversion, but there could
> >> > easily be a bug in there, I don't have any way to test it. Do you?
> >> 
> >> Nope, only compile testing. The important part of this series is to
> >> clean up of_node from GPIO library, so since here it's a user of
> >> it I want to do that. This patch is just ad-hoc conversion that I
> >> noticed is possible. But there is no any requirement to do so.
> >> 
> >> Lemme drop this from v3.
> >
> > I just realize that there is no point to send a v3. You can just apply
> > first 3 patches. Or is your comment against entire series?
> 
> No, my comment is just about this patch.
> 
> I don't mind converting to new APIs when it's blocking some other
> cleanup. But given the age of this code I think it's probably better to
> just leave the rest of it as-is, unless someone volunteers to test it.
> 
> So yeah I'll just take patches 1-3 of this v2 series, no need to resend.

Thanks!

One note though, the fwnode_for_each_parent_node() is not yet available in
upstream, but will be after v5.19-rc1. It means the patch 3 can't be applied
without that. That's why LKP complained on patch 4 in this series.

That said, the easiest way is to postpone it till v5.19-rc1 is out.

-- 
With Best Regards,
Andy Shevchenko


