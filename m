Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B002528662
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbiEPOFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244286AbiEPOF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:05:26 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0AC3A724;
        Mon, 16 May 2022 07:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652709925; x=1684245925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pFt4HO1TD5VHhoCWTbjb6hXEj0azWY0q/flWLQdVPx8=;
  b=CBgQjeZcJFhufuZvmuRLg0EplJ2zcJ/34W9DKCHfOqMSIUHIHjdU6VQY
   u7xGsw8vtddTu4U1tyPZYhb9eCh3+hlsxD93eMku5/ueHW0sGdWn4a0l9
   RwLnztk0+Alw1wdAAMpdHpYmwbCxKgyZJLmAD2iAS78LBE5BbY2PKcNsy
   trixv4gr8jUdPwwUCjW+diXRzGdQA8VkilJUdOePBz+pHstlY+oC2bH5j
   nw/XAYLyafixci73zyVjj376dO4QFBo7AIBAuyotlRWCF7QAjEq8+X3mz
   2HkDTOlcLEoOYGhCbhj+YpwLhNM/6dRolyj9GPhmE3XexYMEX8UQyTXGR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="270537503"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="270537503"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:05:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="574028618"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:05:16 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nqbLU-0006iR-9q;
        Mon, 16 May 2022 17:05:12 +0300
Date:   Mon, 16 May 2022 17:05:12 +0300
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
Message-ID: <YoJaGGwfoSYhaT13@smile.fi.intel.com>
References: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
 <20220507100147.5802-4-andriy.shevchenko@linux.intel.com>
 <877d6l7fmy.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d6l7fmy.fsf@mpe.ellerman.id.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 11:48:05PM +1000, Michael Ellerman wrote:
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> > We may convert the GPT driver to use fwnode API for the sake
> > of consistency of the used APIs inside the driver.
> 
> I'm not sure about this one.
> 
> It's more consistent to use fwnode in this driver, but it's very
> inconsistent with the rest of the powerpc code. We have basically no
> uses of the fwnode APIs at the moment.

Fair point!

> It seems like a pretty straight-forward conversion, but there could
> easily be a bug in there, I don't have any way to test it. Do you?

Nope, only compile testing. The important part of this series is to
clean up of_node from GPIO library, so since here it's a user of
it I want to do that. This patch is just ad-hoc conversion that I
noticed is possible. But there is no any requirement to do so.

Lemme drop this from v3.


-- 
With Best Regards,
Andy Shevchenko


