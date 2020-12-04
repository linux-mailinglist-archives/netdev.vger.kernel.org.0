Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AFC2CE482
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgLDAgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgLDAgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:36:11 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4F0C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 16:35:30 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id u19so4093155edx.2
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 16:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b1/uhGE96UYOq0ubxB5CyQ6ODSVFXVsIA7jNr+G+ESY=;
        b=EI5+DeEBZuWOSGkucZplZ6wPdb2xtRyXwbbIpgvB+fZ184K9L3rDbnjFi+RxRA7AcQ
         hWcq37dJ2rrzbL0r7OeUQcBjZJ8zTXrGkfUQIwOHqHQ0hQ7Pc8KiaBwhcIXm+vz+ZS5f
         QOCvjLkvCp2v7TFU8UjeW3/q4GDxOUxvQeDBg1CUc2VsOTOvw8rWro34QnbqaUzAEp2m
         KQKd75qdq9IrPfvWzCpHYRL8JLOoMkxpSjUtv8fiNknePep8wZGKX9ES1BdrhzaJKsYV
         hb/bKt5nwgQAisq+uZgQQ3+X6/CcPCUW6sTIwSl9EPwD9fkcqhu6spfeb8tkXZCDPzMd
         atWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b1/uhGE96UYOq0ubxB5CyQ6ODSVFXVsIA7jNr+G+ESY=;
        b=jNwYjOxBhvRggxsH5tYKyr0HfNI0Xs4AmijhJhCzrdhyLmgL37CUIiuVSTIiqtapXk
         OWDOiW7mN3fjKAvKeY8OqCSAClCfk5P4L1GhHfKBBOxomg1TVK3lKm68Aqbw4AjkjQrD
         0bEF5uXuz9KR7HdFDwNUylWnM7kyXlyMukY63Gx/r1GadUhaPMpNPWTPCyFlbC8mVg0u
         gPpReZGk2sDqRoGqtjDB/6SPHxnZlSApjhp5e2AmwE0EJAW3CAK5hW9fNSKcSCQrwAY0
         q+aHtekjMExnmMm6odpUuU6BXyjd/mf8LIHPqZgJcjClh72sUV0ULV3TEPFe3Ec2JbyA
         gwhw==
X-Gm-Message-State: AOAM5333rQfLawtuCvWIYzK2/IRkOyXSg85BUSXRQcA2BWodgNhW9mP6
        bC4eSaqHnfIx0uo2KoRYi/Y=
X-Google-Smtp-Source: ABdhPJyw+ZTfDd2teNm39zh3C9XYoGMQKWCCYS+D+m3SmYRYFpZamlyfpc0L+6CL0uvLoixhBHDmew==
X-Received: by 2002:aa7:d514:: with SMTP id y20mr5111149edq.384.1607042129332;
        Thu, 03 Dec 2020 16:35:29 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id b13sm2206016edu.21.2020.12.03.16.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 16:35:28 -0800 (PST)
Date:   Fri, 4 Dec 2020 02:35:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201204003527.uvwyem3mlacr5cjp@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201203162428.ffdj7gdyudndphmn@skbuf>
 <87a6uu7gsr.fsf@waldekranz.com>
 <20201203210941.GJ2333853@lunn.ch>
 <877dpy7eun.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dpy7eun.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:35:12PM +0100, Tobias Waldekranz wrote:
> - If offloading is available, reject anything that can not be
>   offloaded. My guess is that _any_ hardware offloaded setup will almost
>   always yield a better solution for the user than a software fallback.

For the case where the switch ports are not bridged, just under a bond,
do you expect the hardware offloading to make any sort of difference?
If you don't, then why would we deny software-applied bonding policies?
