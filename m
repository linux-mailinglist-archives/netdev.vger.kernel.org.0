Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB055B8120
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 07:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiINFzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 01:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiINFzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 01:55:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D655AC75;
        Tue, 13 Sep 2022 22:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663134938; x=1694670938;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/Kok8QcTrx1w4Mm33cZGUh8x9aDy/k6r+LHmTh5k4OU=;
  b=Sc/Tu5y+bng0mRC2fLJlDUMSk9u+y2ma9wKLdOHconIsk2jUVAUE+9QM
   CLDDz4E7dgRe1J9xRzc/sIc5vtnFnO70EYFWLt9g5qp5UCcD63LuXZ2Cg
   7PzbvDo7Y98DmxsfzWapQRxlmUgGo6qlLltr4kPoqlFoNreGs7wcUQhfN
   iHB3lWhzGLTSrET9g8ULzHL9a35NO/Dgcr7hNshAQVy+S+uYxas4LYMGt
   mP4LzkrabIB2DA1k71kFBCz8E5J+/uv7TkEOovWs8SYtIld2IZ2/S1XJF
   WOynVTLxcxQAJ2Qwt1ax63D/1IUW0KBopvUuAIGbIh3KOeRTJiKeiOiAd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="295928329"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="295928329"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 22:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="705838950"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Sep 2022 22:55:33 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 9F1C7F7; Wed, 14 Sep 2022 08:55:50 +0300 (EEST)
Date:   Wed, 14 Sep 2022 08:55:50 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, jingle.wu@emc.com.tw,
        mario.limonciello@amd.com, timvp@google.com,
        linus.walleij@linaro.org, hdegoede@redhat.com, rafael@kernel.org,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "David S. Miller" <davem@davemloft.net>,
        David Thompson <davthompson@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Lu Wei <luwei32@huawei.com>, Paolo Abeni <pabeni@redhat.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/13] gpiolib: acpi: Add wake_capable parameter to
 acpi_dev_gpio_irq_get_by
Message-ID: <YyFs5q67RYR2aAy7@black.fi.intel.com>
References: <20220912221317.2775651-1-rrangel@chromium.org>
 <20220912160931.v2.5.I4ff95ba7e884a486d7814ee888bf864be2ebdef4@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912160931.v2.5.I4ff95ba7e884a486d7814ee888bf864be2ebdef4@changeid>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 12, 2022 at 04:13:09PM -0600, Raul E Rangel wrote:
> +int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name,
> +			     int index, int *wake_capable)

Here too bool.
