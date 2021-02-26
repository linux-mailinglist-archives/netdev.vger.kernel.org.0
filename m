Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA3A3266C3
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhBZSNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 13:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhBZSNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 13:13:33 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517CAC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:12:53 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c23so5650803edr.13
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=txUiXWCh/KFwT7xS9bLq7PUgANY0Un+NhknyCk+YO7I=;
        b=YOvegM+9jIyss6Cu/qkbWk0dTrezZVKsMBgBjzOARkMHx5cqFnI2Qg5VrcDy7ORuLw
         tdRVZLk+U9sESZK6qmDoHmp1TpWrDU0ntPL0Uf6YwbXU7WIJqEWeQwBKRd8UV3fFx0mo
         vAPORF5Rul9HU9jrfO8k9AQKEa4sbGj9/2VfdsL6aMjj2cVybVRfVXw9FVYODWJrNggk
         4gaTwFUNhX7453wDDh4watOQih2YVfdSOG7NDidJ1K5F7eIVedgr9xy5oY1HEzGLlmUu
         t4YHwFJFcjFelCiMSUvWtMCWYfDh2xtsiy1hfNnsNwmoX7X7gir6KpaZaiHnUkj43z8R
         qZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=txUiXWCh/KFwT7xS9bLq7PUgANY0Un+NhknyCk+YO7I=;
        b=kuhasQJYSGO8e+seye9WwP0sLcEcy8O1ssikbxgQwOK5Fbz7GhPOG3AE9RTVOjdmB2
         iFHVSoZDen/PBGr9fr/ZBz27thjRslHMYo0zSbxSx7++P8kNEbXjVApohReb6A43mF/p
         ybrUabYawmg4ixtsS0AoZuSPEmdnyHQUDBl+I35fACfkxXwWDWvobN4gVVWZ+NTVF5uY
         w9pJI5Ss9ioZsvIbSvPJ17u6n7uYFaAoJkmX2bhwmxYTKn/K82zQTWqfCRYr0Gan3j00
         IsjbHGs6r/RB3v5jKWE0SXEHy04t91tBuzVCNESeb4JCZMGiltA9c7f1CQYn6O/oFnWZ
         a5/w==
X-Gm-Message-State: AOAM530a6zlV0YG1v/2Ula8+uSeN6zIcu00LB2UjkCfsygWFu09kSryn
        hcWQjajVOS43lKi6teJ5+6JOwKUD14o=
X-Google-Smtp-Source: ABdhPJwYtN1L9zSwOmK0HocOgevS6vlCiUcJpls3wfOYjmK6ZXiMMqUlQi/cbcNO8sYq9EKjnWlm+A==
X-Received: by 2002:aa7:d0d7:: with SMTP id u23mr2351666edo.255.1614363172063;
        Fri, 26 Feb 2021 10:12:52 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id v12sm6169630ejh.94.2021.02.26.10.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 10:12:51 -0800 (PST)
Date:   Fri, 26 Feb 2021 20:12:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 02/12] Documentation: networking: dsa:
 rewrite chapter about tagging protocol
Message-ID: <20210226181250.4km4xf4ntxkts6y7@skbuf>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-3-olteanv@gmail.com>
 <87y2fbrivy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2fbrivy.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 09:29:21PM +0100, Tobias Waldekranz wrote:
> This is not strictly true for mv88e6xxx. The connection between the tree
> and the CPU may use Ethertyped DSA tags, while inter-switch links use
> regular DSA tags.
> 
> However, I think it is better to keep this definition short, as it is
> "true enough" :)

What is the use case for this? Build a DSA tree out of old switches
which support only DSA, plus new switches which support both DSA and
EDSA, and have the host CPU see only EDSA, with the cascaded switches
playing the role of DSA->EDSA adapters for the leaf switches?
Is there any point in doing this? If it ever becomes necessary to
support this, can't we just say that you should configure your entire
DSA tree to use either DSA or EDSA, whichever happens to be supported
across all devices? We already have support for changing the tag
protocol, mv88e6xxx should implement it, then we could add some logic
somewhere to scan for the DSA tree at probe time and figure out a common
denominator.
