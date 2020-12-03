Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3545A2CE0D2
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgLCVgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCVgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:36:01 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C44C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 13:35:15 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id z1so4215904ljn.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=dtycNcYPPC2hp7PqLbGXpuy7zc9dQtMhlYyIu2c12oA=;
        b=hgGAduhh7x6yws4KUC3/h+aZsXHkFEDzCaRlGE/IXqxy1De5qPLGpipDS+snaa1AKS
         NdVyF2EB9vxInacrv9sxaft+SpgINAD3V3fU6N5FfdmIH0Qg/0J6gyx+mYFDEsiiYjGy
         v89GxJFE8a+yJyrHf45DIicvnxS/HaI/VmuE9B8EnSmTpUmh78JonfP1CnebG3Kr5DsC
         eNiK57Qcr/waJG0ez44JdZp+L/ysbhEx05QxbrwjfeT4cdmIMPSVrcy3cNXLoAmOT9qv
         qN9o5jLhFR//fyg0vOCUbs573jqXhOs3Cm5PuY3sqBDLgsPZLjZhJshH7sEDKq+jCXNl
         I1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dtycNcYPPC2hp7PqLbGXpuy7zc9dQtMhlYyIu2c12oA=;
        b=X94j/tB80lGyCkwm+IRAzMRDbZWwsauJoQSvefHbTTwyL0oY5LIJnw5kppMguZVaQq
         O5cFV1tCmJjtNSaPTVRQyqKaeikPiVS/m705V3wiTBbLdrOC0+v7Mm5cFnmkEDyC7ZtW
         U6Qk/jvKABVTa43u04BY3IqWfPjLX4g1y/Vvc9M9/8VrA7Nw6QpwnRfeo7Yfk5t1nv4W
         hZ1gLxbSLKMxiPOPfZQxEs/97SfVzz2HEveQiqtdgDz1hWnZDO/eI+Ou0jlx7SVOyVk2
         1vAMgJm55hve6YxKKXNBnGfpABGIQMr5oju24Xsg37CiEqPIgwxTsL/cNRm4hjvw+ssT
         5tYA==
X-Gm-Message-State: AOAM532KoJGqUy6kW3FzoOt34F2ZgC3EVnMAPvcpFOxJAq7jM7TEak53
        2Z6qvXuz846t6DFiP6qdtxC97A+VShaKD7PU
X-Google-Smtp-Source: ABdhPJwZ9CAtt631kN0NN6by37H7QlhpakejzPgBc618CXg7QrItppSsmU8nESBXOA8uD9jOGfiz/w==
X-Received: by 2002:a2e:b5d9:: with SMTP id g25mr2095591ljn.234.1607031313685;
        Thu, 03 Dec 2020 13:35:13 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id 136sm928951lfb.62.2020.12.03.13.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 13:35:12 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201203210941.GJ2333853@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201203162428.ffdj7gdyudndphmn@skbuf> <87a6uu7gsr.fsf@waldekranz.com> <20201203210941.GJ2333853@lunn.ch>
Date:   Thu, 03 Dec 2020 22:35:12 +0100
Message-ID: <877dpy7eun.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 22:09, Andrew Lunn <andrew@lunn.ch> wrote:
>> One could argue that if Linus had received an error instead, adapted his
>> teamd config and tried again, he would be a happier user and we might
>> not have to compete with his OS.
>> 
>> I am not sure which way is the correct one, but I do not think that it
>> necessarily _always_ correct to silently fallback to a non-offloaded
>> mode.
>
> This is an argument Mellanox makes, where falling back to software
> would be a bad idea given the huge bandwidth of their hardware
> accelerator, and the slow bandwidth of their CPU.

Yeah when you have 100G interfaces the choice becomes easier :)

> If the switch has no hardware support for LAG at all, then falling
> back to software is reasonable. It is less clear when there is some
> support in the switch. If we do reject it, we should try to make use
> of extack to give the user a useful error messages: Not supported, try
> configuration XYZ. But i guess that needs some plumbing, getting
> extack available in the place we make the decision.

I do not think we need to add anything. Looking at mlxsw, the extack is
available in the `struct netdev_notifier_changeupper_info`.

I am leaning towards the behavior you just described:

- If there is no offloading available, accept anything and let the
  software take care of it. The user wants a LAG and that is the best we
  can do.

- If offloading is available, reject anything that can not be
  offloaded. My guess is that _any_ hardware offloaded setup will almost
  always yield a better solution for the user than a software fallback.
