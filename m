Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42045365F1E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhDTSU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbhDTSUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:20:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33623C06174A;
        Tue, 20 Apr 2021 11:20:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s14so15447913pjl.5;
        Tue, 20 Apr 2021 11:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yCrEj9yYdXVSKtChQ/1RpMTsKkgPbphqTGR2dyGixC0=;
        b=Rw80zM3ZcoVQQnFLA93slfwIHlA7tgXu82V3HvAyOJ7Ovps+KXMXm8YGNv19Qpd46Y
         jvyoWLNAku+Q4JhFrltv3UR3VPLza3/3gog20bKMHaWLSrqBUVYTMHbCs0XHUTvcH/zH
         kkJxHlc1cmQExqR8/xSBz8njZPxq0ias+cHHhXo/f36On0MYamY3WVlOHF9gzJtqzZGC
         iLcUQkH9Cg1PawZ4AF8RszzKuHgXLO61eoNGiF/emYLXUFeZPXb+gbe1xzVsDaFneSLr
         P/ZW8HGvOBd9R4WQmI/5Pa1e4Ssdo2Nkx/+oeuymwKT+rviRuKnhxqi003Yww2w7PeIi
         eysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yCrEj9yYdXVSKtChQ/1RpMTsKkgPbphqTGR2dyGixC0=;
        b=g+L9c/vhgp4NFEqq8HI+jMpntfwZLR7vrJvuZMNSk/QFSoFVfR4Y6jBb2mt+aaMVqU
         ny0LjxzX2XUf4IwbLI5JXoPuxQB5AHTrEil+l1hfulSDcx92bWU/Xe41fvSkxfCP8YKW
         H30hEPlBVzMCMfbmv7YxUw7O6T0i4X0CoUSBB8pl2ULTBmO0h29Z7yJ38oz3uHY1eRL2
         4UVjC6x3GEzAXCohU7y9MTQId8auXooNDb/msa4qBmaZVNmcbQTJdg1nSyma68FNW2IP
         8nEXWphbgRA/g02QpcFJrUSTeh0Pjp6PPsBJMvy5Nj519+NkGE812f5wQKslp5L4LAJK
         hfog==
X-Gm-Message-State: AOAM531rkR7PV4g/ixklF8sa4fOlT4GguxEo6PSlrkGBTT728h7I16Dl
        qUeIBW3SiFdxmu2nnGP3eR88ykPSReulOA==
X-Google-Smtp-Source: ABdhPJxGajhevkCeTlOdkjG0yl9YNXUqxUGWUgZxgnlnhwDJRx4UiObt7ph4c0SAKEIbeVzlJ7KSMA==
X-Received: by 2002:a17:90a:cb10:: with SMTP id z16mr6325524pjt.106.1618942821795;
        Tue, 20 Apr 2021 11:20:21 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id nh24sm3066539pjb.38.2021.04.20.11.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:20:21 -0700 (PDT)
Date:   Tue, 20 Apr 2021 21:20:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: enetc: automatically select IERB module
Message-ID: <20210420182012.jzlbj4qi4j2bq73t@skbuf>
References: <20210420142821.22645-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420142821.22645-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 04:28:21PM +0200, Michael Walle wrote:
> Now that enetc supports flow control we have to make sure the settings in
> the IERB are correct. Therefore, we actually depend on the enetc-ierb
> module. Previously it was possible that this module was disabled while the
> enetc was enabled. Fix it by automatically select the enetc-ierb module.
> 
> Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
