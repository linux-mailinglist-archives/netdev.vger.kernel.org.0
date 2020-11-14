Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362362B2A55
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgKNBKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKNBKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 20:10:37 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094C7C0613D1;
        Fri, 13 Nov 2020 17:10:37 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id oq3so16415541ejb.7;
        Fri, 13 Nov 2020 17:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a/Auayh2t0n7fed+QDnx8rlYlE47+o2rXNO926m+snE=;
        b=lLQPPF2O/9GF6n73utnM6K55iz/C4aAZOQXqQJ1kaiHJQccu++XEIfauvlB06nhxzU
         qTvqy0TGcT82lu/ktTHj8bcs4irCgSQNQdXbk2oEN89gxVvCWlxf6wJm1cEq649Hn+WA
         bH8CYtBSRz2GdbsM5daGX3gQ8kh1QPEAqNV4hn4sTmnlZFrjFBwX7H1LkO46k3UI0yNh
         ++VsnoBg849VncnDXwjXO8E9QH9KjBbscDyz+7YJ4CuEZoD5l/n418ZXhkn1Drbi5suz
         lduvSHUsNblFOVFMpf+8yO6VZtwpeWF9emwJaZN6H0SNvo0pldnjzDjmLVZS21xE4ev1
         EvvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a/Auayh2t0n7fed+QDnx8rlYlE47+o2rXNO926m+snE=;
        b=YiZ2RKA7eMVkl2xUkoJeGLCfeqmW4w161z3ujaZciPbVJ8DEXUCBKjDqgSrmmXES9A
         5ni4+Px6GRBUfbiRfzh55KOOND7hXRTUIYu1eYRQ7vyTfCFqICGusQ+sYgHN9bz4yC9B
         gyeB1MprhuUbNL51NLLgElVomgMxkWoDZ570MMu3gBiiv08HJ9XfnlBrzMsznU854vfI
         WlaWRL0smOV0wvPGl+XS89t1F1eYk/OSihRE9hFRwAeACA4S/1LW4TwGv6BSdbEx0i8f
         gVfL6lVuU5W5euIlHOnVZhKzI7+XxxIA8OJESXSRR3ONIhxqCqVeiEytQl/ayyA2AM7k
         Gf2g==
X-Gm-Message-State: AOAM5302j3Req/ARo5bSm9sBgu61Q0OHfJuIQEg7C/m5Un+DfdUy2Ops
        7lxd1U6l3TH8gNcz+nJ7Vqg=
X-Google-Smtp-Source: ABdhPJwHqzD15ouIDGoGbAbqj7hOWngFJ13NNLf3oFEKSkdlkCJbRVy/bZInVtQ9ZHXUulzfxwJI9w==
X-Received: by 2002:a17:907:2706:: with SMTP id w6mr4554983ejk.107.1605316235806;
        Fri, 13 Nov 2020 17:10:35 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id qk4sm3264944ejb.83.2020.11.13.17.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 17:10:35 -0800 (PST)
Date:   Sat, 14 Nov 2020 03:10:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: Re: [PATCH v2 09/10] ARM: dts: NSP: Provide defaults ports container
 node
Message-ID: <20201114011033.735e57fywqoye7pj@skbuf>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
 <20201112045020.9766-10-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112045020.9766-10-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 08:50:19PM -0800, Florian Fainelli wrote:
> Provide an empty 'ports' container node with the correct #address-cells
> and #size-cells properties. This silences the following warning:
> 
> arch/arm/boot/dts/bcm958522er.dt.yaml:
> ethernet-switch@36000: 'oneOf' conditional failed, one must be fixed:
>             'ports' is a required property
>             'ethernet-ports' is a required property
>             From schema:
> Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

So 'ports' is not going away and getting bulk-replaced with
'ethernet-ports'. Good.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
