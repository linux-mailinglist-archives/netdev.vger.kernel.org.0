Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9578A6E13AC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjDMRlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjDMRlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:41:35 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EC219A3;
        Thu, 13 Apr 2023 10:41:33 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id jg21so39035589ejc.2;
        Thu, 13 Apr 2023 10:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681407692; x=1683999692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eIiirAaDA9eFVxHe7848A9thDVoy/Iisyo0XYKsmV0o=;
        b=HgLQzS6hpyE1ox3/UQZbfYrUg+fXCMocSiDRxSrIGBjrPBzPqXOJUbiMV8NCUVxh/B
         1ymadqD5jQ6I+DzdMmfxZ/1JSADwiCoWjOLc9jTx86dHwt7ABINegcDwoHOxFAzepYUx
         nt+Erld+cUwRDlzVbA1hjCpP/78cRv00dJ9th0mrTJOSsERaGQIejvqWPW+5iWjaCMdv
         Mkbew89xglCbWfDmOcgGVZzCUwVeFEA1mN0JQweGzgjZp0xe7TtWRm5ByRJbFKznJ289
         b13iy7mAKHNwbh8MdouO8Bk7Umt9DbFZF/B3gCjQOwhE5dJkMvpoWU51k4cWmX8Sv0vH
         loHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681407692; x=1683999692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIiirAaDA9eFVxHe7848A9thDVoy/Iisyo0XYKsmV0o=;
        b=MTrEiuOX3vXRDliR90uCoAzBbYV4PZ8SsgK4Ouidf+5+BVZcqhlzVPJri/iJ/di5Tb
         OcTa7xoXANw5G9zzCMZOBDbEGHwQ7uKJc4fchTZqogNwIkrxrOPsQ1tJpM5feWfenS3o
         pSQE4n/cZHU3CmDZ+rNrD+hZqXbkQdHGXwQKWVl2gOt7boJyfVarGTFvTPVea5VwWlRH
         bxhgyepcbXFAmPmA23N6P0Bk0aAHWC1UwYNN31HxBg6RaVDmWbugxKPeSDNm8SLa2BrC
         i+LXWhMtn9SRKlDCOEb2YmW2Htwnfum9Pa6OrpzdNghNaDVWRhwonIZLW6Mc2CdO+3f+
         GwLg==
X-Gm-Message-State: AAQBX9fuFScQ6BHDWYr3KENEz1bNFkRU1Pgt+0NrOD/k8x7k0zohf/Ll
        oNUOOeM8UeB+qC+3S3QYgXGMAn7yK+RU0g==
X-Google-Smtp-Source: AKy350ZE2BCCFRavI9mkoSpNE4Y8ZHG9SeqJOo39sTOdjgfl+1wMePHFAuxOqUolWX+bSNK8+peFVA==
X-Received: by 2002:a17:906:cf9c:b0:932:f88c:c2ff with SMTP id um28-20020a170906cf9c00b00932f88cc2ffmr6641850ejb.34.1681407692066;
        Thu, 13 Apr 2023 10:41:32 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id mf12-20020a170906cb8c00b00947a40ded80sm1253991ejb.104.2023.04.13.10.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 10:41:31 -0700 (PDT)
Date:   Thu, 13 Apr 2023 20:41:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Yan Wang <rk.code@outlook.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, kuba@kernel.org,
        mcoquelin.stm32@gmail.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "open list:STMMAC ETHERNET DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: stmmac:fix system hang when setting up
 tag_8021q VLAN for DSA ports
Message-ID: <20230413174129.dafmlq57a3pc2ppn@skbuf>
References: <KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <01ef9d4f-d2dc-d584-4733-798cffda49a1@intel.com>
 <298c045a-5438-6761-46d8-c46c57989812@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <298c045a-5438-6761-46d8-c46c57989812@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 10:15:55AM -0700, Florian Fainelli wrote:
> On 4/13/23 10:07, Jacob Keller wrote:
> > On 4/13/2023 8:06 AM, Yan Wang wrote:
> > > The system hang because of dsa_tag_8021q_port_setup()->
> > > 				stmmac_vlan_rx_add_vid().
> > > 
> > > I found in stmmac_drv_probe() that cailing pm_runtime_put()
> > > disabled the clock.
> > > 
> > > First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
> > > resume/suspend is active.
> > > 
> > > Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
> > > will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
> > > The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
> > > registers after stmmac's clock is closed.
> > > 
> > > I would suggest adding the pm_runtime_resume_and_get() to the
> > > stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
> > > while in use.
> > > 
> > > Signed-off-by: Yan Wang <rk.code@outlook.com>
> > 
> > This looks identical to the net fix you posted at [1]. I don't think we
> > need both?
> > 
> > [1]:
> > https://lore.kernel.org/netdev/KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
> 
> Unfortunately both still lack a proper Fixes: tag, and this is bug fix.
> -- 
> Florian
> 

I guess that would be:

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")

although in this case, that would be only part of the story. That commit
split the runtime PM handling between stmmac_vlan_rx_add_vid() and
stmmac_vlan_rx_kill_vid() in a strange way, where an added VLAN RX
filter takes a refcount on the device, and a deleted filter one drops
the refcount.

That is... strange?! but it worked in a way, I guess.

Then commit b3dcb3127786 ("net: stmmac: correct clocks enabled in
stmmac_vlan_rx_kill_vid()") came a few months later and blamed that
oddity on a bad merge conflict resolution... ?! Basically, from what I
can tell, it's this later commit the one that broke things, for using
runtime PM only for stmmac_vlan_rx_kill_vid() but not for stmmac_vlan_rx_add_vid().
