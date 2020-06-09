Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A340A1F4780
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgFITtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730817AbgFITtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:49:51 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE47C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 12:49:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v24so8443302plo.6
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 12:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BvJL0NnPvCvmgi18G3mhBmcGgjtdbtuvzl/q+YeofAg=;
        b=DVmRoNDbxYwgNkXXvYn3CI1ZI04NkDYqyMipEJpQRuCUounr0HWR806J2iZRNc3hx3
         sw6R7lcSY+tVBAKjajmkBjFh9fMItc5ScRd6O8YMt2dRpK4Xe3eMFuMq8VDepqIzHpfb
         S8WXDlzBRdReP5RpEVEolQ3Om7T31YcXnLfCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BvJL0NnPvCvmgi18G3mhBmcGgjtdbtuvzl/q+YeofAg=;
        b=VZE2V5/spmMsZ2lPHqqzkdTzBpHxwb8rkrM5PxpV2X/6RNTARHyn+t9t6N0KQZJyXA
         4dzkD8llNgF10y/yJnAwzTkAj8qgR2ZiVzW9tFFr2vL+p2epv03FwzIuHEUdxujPRpe/
         x1AkAnycbGI/StcbS+4XGZ4aSCfxLmntBM6tpb+kIuUKS1tp5LJoIVarXJPCq4+A9aTr
         kTag+V8EuZqntDVQFRFKDzh2QvnkY15FxmguLjplrcEH1RSoKW1SVtjwlhJF3Hxptehi
         epOiQhOwPobSP5ExWu/5g7PQELV0mLo9wn16+NGKR2O6ox2I+V1i8CJC6gjrhh4v9T//
         ZNAg==
X-Gm-Message-State: AOAM5306xqxw+N9YHm9IQPmTtkbsqx+tvGeMuVnNGw8CZAYv0QWHSl2h
        Uk+0OAZ1oAAoAUDpzm22Am4+GA==
X-Google-Smtp-Source: ABdhPJwh7dWUg2DG7fQ0330c8rWga5xNXIbFNx16XXw8rCe8jyOWReYRCqTemZ/4aIcoimSvV+rHiQ==
X-Received: by 2002:a17:902:9882:: with SMTP id s2mr27567plp.112.1591732190608;
        Tue, 09 Jun 2020 12:49:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 145sm10933362pfa.53.2020.06.09.12.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 12:49:49 -0700 (PDT)
Date:   Tue, 9 Jun 2020 12:49:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Miller <davem@davemloft.net>
Cc:     stephen@networkplumber.org, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, corbet@lwn.net, mkubecek@suse.cz,
        linville@tuxdriver.com, david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mkl@pengutronix.de, marex@denx.de,
        christian.herber@nxp.com, amitc@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <202006091244.C8B5F9525@keescook>
References: <20200609101935.5716b3bd@hermes.lan>
 <20200609.113633.1866761141966326637.davem@davemloft.net>
 <202006091222.CB97F743AD@keescook>
 <20200609.123437.1057990370119930723.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609.123437.1057990370119930723.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 12:34:37PM -0700, David Miller wrote:
> From: Kees Cook <keescook@chromium.org>
> Date: Tue, 9 Jun 2020 12:29:54 -0700
> 
> > Given what I've seen from other communities and what I know of the kernel
> > community, I don't think we're going to get consensus on some massive
> > global search/replace any time soon. However, I think we can get started
> > on making this change with just stopping further introductions. (I view
> > this like any other treewide change: stop new badness from getting
> > added, and chip away as old ones as we can until it's all gone.)
> 
> The terminology being suggested by these changes matches what is used
> in the standards and literature.
> 
> Inventing something creates confusion for those who are familiar with
> these pieces of technology already, and those who are not who are
> reading about it elsewhere.
> 
> Both groups will be terminally confused if we use different words.
> 
> For such pain, there should be agood reason.  I don't accept Stephen's
> quoted standards bodies "efforts" as a legitimate reason, or evidence
> of such, as it has a lot of holes in it as Edward pointed out.  I
> found the Orwell references to be quite ironic actually.

Okay, for now, how about:

- If we're dealing with an existing spec, match the language.
- If we're dealing with a new spec, ask the authors to fix their language.
- If a new version of a spec has updated its language, adjust the kernel's.
- If we're doing with something "internal" to the kernel (including UAPI),
  stop adding new instances.

-- 
Kees Cook
