Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9D13AE6CE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhFUKNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhFUKNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:13:31 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E10C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:11:17 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t3so18119607edc.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xmp5jA8pewX2e/ZCJFYCgkXbwOXQrarLGox1UJ84EAk=;
        b=Qzn/fhjBvQM73CiDdR2T1hDdo4qFC/lqf+Fc5rrWDY8xpXCm5Ept045kEwchAueIN+
         LeK3VWVKGKoFyhW1qNvFEf87CxdVQVxwCR1RzFOlIfeXQpHifPFwoIUkQIgZSwMWpGwo
         b5HDTNccFMDzHXEMmNigsd5epkrug0XkXgHwFmflwl/uIhWi+lA6ZiZZkbZS65qKLalR
         jFzP4xyno0iRLpo4QoKUEz5bit9KdxvZ3Qk7Rcwpj9mmx0gBLqeCFop7TSXqOvC9uL4W
         WD0wmYtXdp7xaxgYTj3aIRSHucWFJGRKx4X+POhr5GhuX4+cfGMnGhc7SD8GTuD1s4Cn
         Ag3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xmp5jA8pewX2e/ZCJFYCgkXbwOXQrarLGox1UJ84EAk=;
        b=On7O5/xvN38vjKEVnzw1JKOByeHfVMxgdQBK20Xz8t95x3JIM/QgAaZ6ixZOAQ5YTn
         OD/t/WWKaumtAgkQlnaX6naGzYzX7ojV1xoS0AMUM57rc+h9VvShngjQXXybdMBNH19L
         eSE0BKCw8Ylbzj7YXN1+zCEWCT7mi7NS4nnSaZkeFwgQIXSLyfufm14vdAR7lKj6fOho
         zVPmvKT1CDQFVshQZpjIS+xbjTbH+wkQNgj3ObeNiil5DKvOlbflJ99I0GTjQ5sks4Yn
         1dPaFwKir5JKXr1eZngReCFEAWt0cPRbL+VYexIv0E71cDcYG4PyreVUpSX0SN1fnIqo
         Zgug==
X-Gm-Message-State: AOAM53222VrTjUxdaDKY9lkb2Pp67skcSP0oaDcmu1f5LyuFk9QS62S8
        RCFgSlHyb3AsSzueJ726SIE=
X-Google-Smtp-Source: ABdhPJxz6ulkLGPZ5EuiELu+TQs6gj8QzEj6aoN95jLoE7odfsF/imjJ/s4gFymNTrezL0JWds2cEg==
X-Received: by 2002:a05:6402:4316:: with SMTP id m22mr20442633edc.316.1624270276018;
        Mon, 21 Jun 2021 03:11:16 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id aq12sm4122725ejc.77.2021.06.21.03.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 03:11:15 -0700 (PDT)
Date:   Mon, 21 Jun 2021 13:11:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next] Revert "net/sched: cls_flower: Remove match on
 n_proto"
Message-ID: <20210621101114.26hvcfhsbsagkzru@skbuf>
References: <20210621092429.10043-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621092429.10043-1-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 12:24:29PM +0300, Boris Sukholitko wrote:
> This reverts commit 0dca2c7404a938cb10c85d0515cee40ed5348788.
> 
> The commit in question breaks hardware offload of flower filters.
> 
> Quoting Vladimir Oltean <olteanv@gmail.com>:
> 
>  fl_hw_replace_filter() and fl_reoffload() create a struct
>  flow_cls_offload with a rule->match.mask member derived from the mask
>  of the software classifier: &f->mask->key - that same mask that is used
>  for initializing the flow dissector keys, and the one from which Boris
>  removed the basic.n_proto member because it was bothering him.
> 
> Reported-by: Vadym Kochan <vadym.kochan@plvision.eu>
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> ---

Perhaps not the most relevant crop from the quote, but anyway:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
