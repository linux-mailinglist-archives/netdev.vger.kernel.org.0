Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F6235F89D
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350347AbhDNQFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhDNQFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:05:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CE0C061574;
        Wed, 14 Apr 2021 09:05:26 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s14so5659596pjl.5;
        Wed, 14 Apr 2021 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pNpXA6x5/nPga5oEMbCsiILe6WyaovQXAKF5BJRiD2M=;
        b=mP4d271Dto5ywro/TIArJGuK5mX+HAWP6IcadJJ3AC3XGR6POTD+pzdrBm/z47UyB4
         flgm125LOo86pzVNweZLwVoNXuEXFjWprJA/Tc2Id7ARn32Tj2AI3AcAdktmKah2RzCY
         qLUqWoHftubcH04UD2WtF8spK6c49iC9OuhJsaKRjKEv2gUJSdEiZiGt5WiBntcBxahb
         J58KnG27sCMhtVZKWIzM5zVKQ4INKtgtlFhlutEcNFjes/NVQPRjGRzlzlbJgzgk0DvY
         GTVlzjjCstSplndbuPVRF/SPLEHQ8A6qu8MWcumX2WFlke5KaeCVP3WxEIcOAUtb7Hvk
         n2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pNpXA6x5/nPga5oEMbCsiILe6WyaovQXAKF5BJRiD2M=;
        b=AnHQFlHO2fEnC1MATdc1D3AQU3tDYCOFpGs0Sx8mqA3aQWn095ih0zERquDlSEHyEl
         bDGMy0TCLG4BSHOSEk6yaMMsB146UFFmrMF28mtlp/XG9wAe52ki+2gxqVSugGjryodj
         2VAiZTj+c2Dm72Twmg10EJs/xHf14p/C8rVuend92/6C0xtypS4uZeABKvQsyRxfXAvr
         hTP7meIXHZJsOpYG8bzunc+aQa7jz5U3x7qVedbgrXZwPhbxIs8P/VgrMMxHybJo1Lkd
         D+984Sm/9jiJoMGfMx4IUKUwnLneLpieINjLlYh0gax7g0VIiwrozkm5Jo3Mi6FaJvPv
         DZ3g==
X-Gm-Message-State: AOAM53342AWaPqa+1Lko7ww4p9jd0DgCJFzinAqP2QuMPd5CHOs6h4mY
        yADb31rvCx287q4dmQ+9gbg=
X-Google-Smtp-Source: ABdhPJyvoKT/IW8cSj8lS0Gu1VGt87xTvpG8KvG94RTyo7PMKxBzwqa+f0hGgLkDLu9kVkUyZ6DZSA==
X-Received: by 2002:a17:902:c407:b029:e7:2272:d12e with SMTP id k7-20020a170902c407b02900e72272d12emr38063062plk.52.1618416325810;
        Wed, 14 Apr 2021 09:05:25 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id 205sm15386643pfc.201.2021.04.14.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 09:05:25 -0700 (PDT)
Date:   Wed, 14 Apr 2021 19:05:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net-next 2/2] net: bridge: switchdev: include local flag
 in FDB notifications
Message-ID: <20210414160510.zcif6liazjltd2cz@skbuf>
References: <20210414151540.1808871-1-olteanv@gmail.com>
 <20210414151540.1808871-2-olteanv@gmail.com>
 <YHcRNIgI9lVs6MDj@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHcRNIgI9lVs6MDj@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 05:58:44PM +0200, Andrew Lunn wrote:
> > Let us now add the 'is_local' bit to bridge FDB entries, and make all
> > drivers ignore these entries by their own choice.
> 
> Hi Vladimir
> 
> This goes to the question about the missing cover letter. Why should
> drivers get to ignore them, rather than the core? It feels like there
> should be another patch in the series, where a driver does not
> actually ignore them, but does something?

Hi Andrew,

Bridge fdb entries with the is_local flag are entries which are
terminated locally and not forwarded. Switchdev drivers might want to be
notified of these addresses so they can trap them (otherwise, if they
don't program these entries to hardware, there is no guarantee that they
will do the right thing with these entries, and they won't be, let's
say, flooded). Of course, ideally none of the switchdev drivers should
ignore them, but having access to the is_local bit is the bare minimum
change that should be done in the bridge layer, before this is even
possible.

These 2 changes are actually part of a larger group of changes that
together form the "RX filtering for DSA" series. I haven't had a lot of
success with that, so I thought a better approach would be to take it
step by step. DSA will need to be notified of local FDB entries. For
now, it ignores them like everybody else. This is supposed to be a
non-functional patch series because I don't want to spam every switchdev
maintainer with 15+ DSA RX filtering patches.
