Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9458532FB08
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhCFOFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbhCFOEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 09:04:43 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D65C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 06:04:43 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r17so9621242ejy.13
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 06:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QrrXrmaB32wAR6Wb3DiAef2AkNJHh+7Pa4h8DhhudkQ=;
        b=nOCT52yriRqDAJ7eYBG1SFoqMTG6wcwZuO2lP4GWoEjoA/n6128+5qaotz9+QWJjJd
         kHBNAtuagIQdUE37rsETPtPFYwBD7Pv1RHY8y01UnE4TXmsO9T4Pgy99nVgP8VmDNyQa
         n33gUwRC+qW6z9Xuh1nx8pYn1oTmkY1eccLNjvJviImVFTzu2c+jdwcrw+mFKpSP/iVq
         oqitGszfLncO/0KcHZgaS93Oj4Vm5nK6Bfjpxw4S8J46CpQllUAOtDoMMRAAt5rTbSyy
         a703RdeBe1XU+4IfFAZaOg5nPRYe7C6cBMlLpB0hlkMj31P4OpKPUxoE0m/N8hBSstk8
         /mHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QrrXrmaB32wAR6Wb3DiAef2AkNJHh+7Pa4h8DhhudkQ=;
        b=TWiArW94mrNvjCMbMVaE1bSZsQnlPSGPubm5e5+5R+2fTH8CtUuVqqQAaoFd/cXE6U
         PmYTWBmoksjZSeDaRjNxZtL17XPn89hDY90qLer6BFofs2/RBGlieQ1sSWZ4NjU2B84n
         RVhoGdNCOvSqf0wiy38e/on8QVVPfR/1t6w9giCynTMgDNcXiVF0D7XQaFJTccbFXM62
         3DzeIWZ83ak263cyLy38x0FJ0eKKGHTFD9cwMOcbKIuIQifJxluQQ0cAw0h0NniVgRiB
         cG7NsPju+lk6T2Us/GtRfim8OGwG1knzen4U3VcCjn+bhNYA42EvufgKWQbLRh7nG+lW
         T1dQ==
X-Gm-Message-State: AOAM533wx+fLMh4nmGqOEbrqjWh1XbAaFbYjRNKXvo23+IryrM9e079w
        q0GH4BI7qt4VMAxUj1JcXSk=
X-Google-Smtp-Source: ABdhPJyav2GBoUoZNna6Loy5YHUpBkx2d0u16MNq0mWNfh6SZEdPHrl0ifI8GSgolbjviuQnYs04fw==
X-Received: by 2002:a17:906:3388:: with SMTP id v8mr7126417eja.278.1615039482192;
        Sat, 06 Mar 2021 06:04:42 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id c10sm3323830edt.64.2021.03.06.06.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 06:04:41 -0800 (PST)
Date:   Sat, 6 Mar 2021 16:04:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Always react to global bridge
 attribute changes
Message-ID: <20210306140440.3uwmyji4smxdpgpm@skbuf>
References: <20210306002455.1582593-1-tobias@waldekranz.com>
 <20210306002455.1582593-3-tobias@waldekranz.com>
 <20210306140033.axpbtqamaruzzzew@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306140033.axpbtqamaruzzzew@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 04:00:33PM +0200, Vladimir Oltean wrote:
> Hi Tobias,
>
> On Sat, Mar 06, 2021 at 01:24:55AM +0100, Tobias Waldekranz wrote:
> > This is the second attempt to provide a fix for the issue described in
> > 99b8202b179f, which was reverted in the previous commit.
> >
> > When a change is made to some global bridge attribute, such as VLAN
> > filtering, accept events where orig_dev is the bridge master netdev.
> >
> > Separate the validation of orig_dev based on whether the attribute in
> > question is global or per-port.
> >
> > Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
>
> What do you think about this alternative?

Ah, wait, this won't work when offloading objects/attributes on a LAG.
Let me actually test your patch.
