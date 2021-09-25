Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7278418401
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 20:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhIYSjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 14:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhIYSjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 14:39:49 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28392C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:38:14 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v18so14657750edc.11
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=96hmgvLp96+50Mhhv/7CbHAXFj4ja9PZgdWWcuE+r0s=;
        b=aKyWsSunMmgb21q5skLymd3+kgKLr4wXxBr7cMwBWVWRsq9pBDNRjFiypQfCqYH56+
         03jh6+t77GhcwHbkix9+cmTFh1Y8CJgv0RWJPZZ9C3pQbgiZXKZcctSUL48ys8QdUlrd
         FBpLjN5f7D3gf0+Ou5IUzCcaHlt4RMovJo3OUEE5ql2N5hmvLF5lVxxxrrhmQMs52xKp
         joANkUxV3Se8xfMihSHNW0R5Qoa3QcAURN+I0tQNdTy4bRbWpyYYo1YGd5NHTTkLwSH2
         fBD0sWHatqfxgwGced0HqaQSOemvZpT2119EmL/taTYdiHniV4uNF6oa8Twg4z7W223D
         AVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=96hmgvLp96+50Mhhv/7CbHAXFj4ja9PZgdWWcuE+r0s=;
        b=mLSA06WTsTuMCE3VB25vbTJm33saH3u5GApPzOgZ2p2NVJiSJmdlXk04NcEWEIOkos
         Di0534g7PSmTyYU1oRwTJ0sMffrEtk5qrNDtw17WBhwUEJcBqueZxODLodV/4fqA//bI
         6nlv+Uw9hUQ3LBp5jLCQVZnrh0J51FDHDWUvbZVOAqXDnEQn0VwZKteKGgR6px1HMSn0
         YjU4cyLkFKs8yj6B+HWThu3XDSJpAZD89yhHyF2uy9hgqkRv1c8VjJFaYoFLJpcA8Jin
         /ZyLtjbt3xuUaJdGANZcPv/KWdSLyuth5DodgPIbZJ6L+0tIWSjwk/emXy8sU/OBLL3m
         s9ug==
X-Gm-Message-State: AOAM530gWTbLK9FbUc1sf679aV6+67fumhla6WRSX5lSFsGsy07RA7No
        Sqhdcyq0/xi5wQRqEgXlJj4=
X-Google-Smtp-Source: ABdhPJw9jNzHWXx8FXc67iFR9pXEh0gmLukClT28P8cCA/ehuMslUIuJmCcxX+x18bKYxkOin9Ru4A==
X-Received: by 2002:a17:907:20f0:: with SMTP id rh16mr3512754ejb.134.1632595092626;
        Sat, 25 Sep 2021 11:38:12 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id o3sm960648eji.108.2021.09.25.11.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 11:38:12 -0700 (PDT)
Date:   Sat, 25 Sep 2021 21:38:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 3/6 v6] net: dsa: rtl8366rb: Rewrite weird VLAN
 filering enablement
Message-ID: <20210925183811.jsq2qps257jeqgmf@skbuf>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-4-linus.walleij@linaro.org>
 <a4c7ffae-b99a-00ee-6de3-8c7e40ecd286@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4c7ffae-b99a-00ee-6de3-8c7e40ecd286@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 05:12:24PM +0000, Alvin Šipraga wrote:
>  From the previous version of this patch I understood that CTRL1_REG is
> for controlling whether or not to accept untagged frames, and CTRL2 for
> accepting tagged frames that don't match the port member set. Is that
> correct?

It might not hurt to add comments which explain what these registers do.

> Do you know whether DSA _always_ wants ports to accept untagged frames,
> or only if the port has PVID set? I'm also asking for my own
> understanding. In the latter case I think you might have to set CTRL1 in
> rtl8366rb_vlan_filtering() (depending on whether the port has a PVID),
> as well as whenever a PVID is set or unset. Of course it depends on the
> switch semantics - maybe it ignores CTRL1(port) == 1 if the port has a
> PVID, in which case your previous version of the patch would be OK.

Documentation/networking/switchdev.rst says:

When the bridge has VLAN filtering enabled and a PVID is not configured on the
ingress port, untagged and 802.1p tagged packets must be dropped. When the bridge
has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
priority-tagged packets must be accepted and forwarded according to the
bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
disabled, the presence/lack of a PVID should not influence the packet
forwarding decision.

Anyway, I suppose Linus can make that adjustment after the fact too, if
everything else is ok in the other patches.
