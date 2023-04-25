Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B7D6EE498
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbjDYPQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbjDYPQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:16:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D7349CD;
        Tue, 25 Apr 2023 08:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 414F5616C3;
        Tue, 25 Apr 2023 15:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18805C433EF;
        Tue, 25 Apr 2023 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682435807;
        bh=bAXyJ55uGyr4o6x1+TCcIcpy53ynNX5P/NlJkIf4cdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FHcg7mEafbVu64JRX4tHHh2VqSTTlC5YijN65eYFfHpF9FiaZXlsjgfOXCcUl9R0V
         gY5OBJ8d8csE7FHsyF02OC7w0Iyfwon0qxpbP1iYmH7YTPqCjYm5tgQEO7MoOO6xa0
         P2asA+lSeY8q0sfWzh/D6txLFRhP7r9vgIRRTyl46FOLXbvAHi/skk+aYJVfRRnjON
         0ciF+JbbLwNYKwAYhnCPqfpav07uK3yfH6nUdHDmIc1xO7bpcZQinp+hmhQcPmxHV4
         iZl8Hn5w3m3wD/3JTj5yUT2OAeAFg/NZpOOajGIZhkSfXTuhhiDf95I3Kl1kzImTCa
         nZRpnge3NrrGA==
Date:   Tue, 25 Apr 2023 17:16:44 +0200
From:   Andi Shyti <andi.shyti@kernel.org>
To:     Andi Shyti <andi.shyti@kernel.org>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 3/8] net: txgbe: Register I2C platform device
Message-ID: <20230425151644.szqnyqvxpdkoqqb3@intel.intel>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-4-jiawenwu@trustnetic.com>
 <20230425150619.cj7ed2efnbvjk5mm@intel.intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425150619.cj7ed2efnbvjk5mm@intel.intel>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 05:06:19PM +0200, Andi Shyti wrote:
> Hi Jiawen,
> 
> [...]
> 
> > +	ret = txgbe_i2c_register(txgbe);
> > +	if (ret) {
> > +		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
> > +		goto err_unregister_swnode;
> > +	}
> > +
> >  	return 0;
> > +
> > +err_unregister_swnode:
> > +	software_node_unregister_node_group(txgbe->nodes.group);
> > +
> > +	return ret;
> 
> no need for the goto here... in my opinion it's easier if you put
> software_node_unregister_node_group() under the if and return
> ret.

please... ignore, I see that there are more goto's added in the
next patches.

Andi
