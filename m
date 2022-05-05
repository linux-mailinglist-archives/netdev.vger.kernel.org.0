Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C08251C510
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381929AbiEEQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381910AbiEEQ1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:27:05 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4B25BE53
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:23:25 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so4028884pga.0
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 09:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k7gsNgCyT247Xr3GRAEbCammiSXa3uZGYJnST76Cxwk=;
        b=RVmSgg0C3UldZ+RyZHl8yul90x5S8rTQUwsgOGpohyALNMZJb/dKn2xVWmFGTEdiCF
         icfX7tNfqVo8lyPRr4qhsubbnPL6smsK5FrE89rk26zXP9NU1q5YzSGTVVsN+a9RvN3j
         7Nh4h4OV9IkVcLQcUo42aryIa4qPP4r88jB+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k7gsNgCyT247Xr3GRAEbCammiSXa3uZGYJnST76Cxwk=;
        b=rlCiWOoalG/xny7nOCG+OpeG8GCzblECXaPtl+yQqcFsPhjFJ6AEVPJGjvqjsSVyk1
         t0FsWDtmUCqEniJr1gA2gbROjt907kfqTdYBRn2jl2WcWoT7TL5XZIN79YPY5Z+bm9hE
         g2ym48y/FtlxP7WHMkGjekCWyLxjfACexF/U6JQnaBZRBfb+rWlfQJ9AhMplSzRmfqi0
         xsJ3IRTyFwtWu/2g4doFv/d2R657hwcdUn9QN2/yC4yOmY3sVJwnhKHbnhiDNu2Nlj2a
         A/A92HgsKOx340E7qvFD6AtZIUj/oqEgBqwL4kS/0vm3kWpuIJVgBGuJxrchQwclCpkl
         oCMA==
X-Gm-Message-State: AOAM531D6OoK5lSNuosJBqkB9Rgu95HyomWt0B9+fAmQN9RK/70YrcXD
        AiZrLNRU0bOb+OcLlR2VQLrZ/w==
X-Google-Smtp-Source: ABdhPJyCbUJfJSClHIgPHI9ZfCXrp9dbwQQvNWyR2JsIOw5em9iwuILh3Nu7K4NFe7FWksDwPqmjug==
X-Received: by 2002:a63:2c53:0:b0:3c1:7367:3a0 with SMTP id s80-20020a632c53000000b003c1736703a0mr22747842pgs.516.1651767804424;
        Thu, 05 May 2022 09:23:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o184-20020a625ac1000000b0050dc76281c3sm1555418pfb.157.2022.05.05.09.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 09:23:23 -0700 (PDT)
Date:   Thu, 5 May 2022 09:23:23 -0700
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
Message-ID: <202205050919.496AC46@keescook>
References: <20220503144425.2858110-1-keescook@chromium.org>
 <20220504201358.0ba62232@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504201358.0ba62232@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:13:58PM -0700, Jakub Kicinski wrote:
> On Tue,  3 May 2022 07:44:25 -0700 Kees Cook wrote:
> > Using min_t(int, ...) as a potential array index implies to the compiler
> > that negative offsets should be allowed. This is not the case, though.
> > Replace min_t() with clamp_t(). Fixes the following warning exposed
> > under future CONFIG_FORTIFY_SOURCE improvements:
> 
> > Additionally remove needless cast from u8[] to char * in last strim()
> > call.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/lkml/202205031926.FVP7epJM-lkp@intel.com
> > Fixes: fc9279298e3a ("cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()")
> > Fixes: 24c521f81c30 ("cxgb4: Use pci_vpd_find_id_string() to find VPD ID string")
> 
> Is it needed in the current release?

No, the build warning isn't in the current release, but I'm expecting to
enable the next step of the FORTIFY work in the coming merge window.

> > -	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
> > +	memcpy(p->id, vpd + id, clamp_t(int, id_len, 0, ID_LEN));
> 
> The typing is needed because of the enum, right? The variable is
> unsigned, seems a little strange to use clamp(int, ..., 0, constant)
> min(unsigned int, ..., constant) will be equivalent with fewer branches.
> Is it just me?

Yes, due to the enum, but you're right; this could just use min_t(uint...

I'll respin!

-- 
Kees Cook
