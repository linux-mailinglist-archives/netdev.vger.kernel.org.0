Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1451CCAC
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386677AbiEEXZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386709AbiEEXZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:25:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E94B606D5
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:21:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so9316085pjb.3
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 16:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FsJQBm+KiPbU5oZFlb156b8rhBJ4Uorz+AB43axdvEs=;
        b=b4QBt9I2EvR67CODikPi0a9mXhgWqX571i5/EdReKIE9EODbHkItMvjvwDbOCQysfV
         OYPj+ES6jzaUAcaXntn5yP9xnuimsNNoETSjjEpKqFnZJq7HiU4QIoUizYG8dqlIAlRt
         KFEUvFE02VVTOS1MXYfEMUXarlkOSW796wnzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FsJQBm+KiPbU5oZFlb156b8rhBJ4Uorz+AB43axdvEs=;
        b=jn8j/UW26UVNzijl7yRixPiptWm2E95hj/ZdnLRcs4EczlE3PgsHSkC747aT7ym9je
         /N1J1fstPDfhYtiSKiHl4GziyBqgPprU4JVHau8SMTiPfI8VTVMGrjv/q4rjHnS+wPuS
         uRzb4x9IlxRlA0gXcY6iEeewKEqdwbl8E14npJw9rJt9Dy6lMQONyRKkreEqRX4NsJyx
         4iF8OUe/vNdHW2QrK/ye6GRf7LfaELu1Z6W0/QVtPsSu52Gx4Dji28NzvouS3+X2jtVL
         rDFTpc9EYAUTqIqiPKL2/0Y54E6iMAjmktwyLJEJUUPelFdrm7ywS+ORKXpesYFyCQuY
         vv3w==
X-Gm-Message-State: AOAM5328xla4lsKZ7aO+dMchj0mxUc3T/j6S4sUMfnun2TmIwZv89Vq1
        xZQHhIUyE9tFxWWb+OpGQRxsfQ==
X-Google-Smtp-Source: ABdhPJzP9zRP08NXdI9jDsvHPqaceGoA2zYTGlw+nZr3rV2CSebijDo0y4t+sdVuBwBLJoTyc6pOsQ==
X-Received: by 2002:a17:90a:589:b0:1d5:e1b1:2496 with SMTP id i9-20020a17090a058900b001d5e1b12496mr8887205pji.209.1651792907648;
        Thu, 05 May 2022 16:21:47 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y19-20020aa78f33000000b0050dc76281b0sm1912701pfr.138.2022.05.05.16.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 16:21:46 -0700 (PDT)
Date:   Thu, 5 May 2022 16:21:46 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: chelsio: cxgb4: Avoid potential negative array
 offset
Message-ID: <202205051611.7C4B6EB86@keescook>
References: <20220503144425.2858110-1-keescook@chromium.org>
 <20220504201358.0ba62232@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504201358.0ba62232@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:13:58PM -0700, Jakub Kicinski wrote:
> On Tue,  3 May 2022 07:44:25 -0700 Kees Cook wrote:
> > diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> > index e7b4e3ed056c..f119ec7323e5 100644
> > --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> > +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> > @@ -2793,14 +2793,14 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
> >  		goto out;
> >  	na = ret;
> >  
> > -	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
> > +	memcpy(p->id, vpd + id, clamp_t(int, id_len, 0, ID_LEN));
> 
> The typing is needed because of the enum, right? The variable is
> unsigned, seems a little strange to use clamp(int, ..., 0, constant)
> min(unsigned int, ..., constant) will be equivalent with fewer branches.
> Is it just me?

I just chased down the origin of "unsigned int", but it's actually a
u16 out of the VPD:

static u16 pci_vpd_lrdt_size(const u8 *lrdt)
{
        return get_unaligned_le16(lrdt + 1);
}

static int pci_vpd_find_tag(const u8 *buf, unsigned int len, u8 rdt, unsigned int *size)
{
	...
                unsigned int lrdt_len = pci_vpd_lrdt_size(buf + i);
	...
                                *size = lrdt_len;

I'm not sure why it was expanded to unsigned int size, maybe in other
call sites it was easier to deal with for possible math, etc?

Anyway, doesn't need changing. I'll send the int/unsigned int shortly...

-- 
Kees Cook
