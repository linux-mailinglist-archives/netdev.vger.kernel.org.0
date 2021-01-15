Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720782F895E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbhAOXZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbhAOXZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:25:19 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B01C0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:24:38 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id 6so15639448ejz.5
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4DchstVjzWtLHzQA6sUuIQcK1A5kWU+r+LTCCucJx5w=;
        b=EmrNPl7qVXH2773k6g2btQaa1C5bS6N0A94Cb+icKOdkWo5xXiptQ0s056sTPmDv7P
         Rk7E/4M3P5znTfZX4pNkRby7D8QwSPU5HVk+nR8waVsYvg399sblad+Z25BtDFyg0ynm
         H2L+XQOm+PPZxYqUxRHyKfVt/FcEdQKP8gbzTQb9wqASCUfih4hCVqKZ1osw7JaikKiV
         tcAPY3XWF6IhDOafQMTYOGHSEKId8OJgQyC8+d3i6SvcAypeovyBh+x4Br6Q+zPUErdZ
         F2w2wMI/cIMytGGoZSLxAy9omGPkcrjz6GjLmVny7KIWNClYq4TCc33/4RTje/vVi1ug
         ccZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4DchstVjzWtLHzQA6sUuIQcK1A5kWU+r+LTCCucJx5w=;
        b=nBz/TkFWKEZ2ktCyfPDiDUECjFqPZDUvjyP4s6QXlH+AULVDfXDMBmOAuR5S2rhwow
         +L25mkoKJs9ITphf4qWOwvGe6n+UBoRflol7ef6leuatE9rbQOh+xNEjuJlaXzAzdZIl
         TMs8MEiwutT2H1DtWim+9Sz0lXrTv9KfMfDWB6wbA60mDJ/NFqjXwslJB4tDn/zu1sJK
         zKIPKY2t9mu5GQVfT20bVdGABtzaFLbbz4mxvCVyvIxUIh7PkG1nfaW67DgDCRRjQStn
         HNz6oL/aaWyAcv3aXye0H9jHNqjhwGMNHoer2ukawXky+TxbiVYERCj0k2mS2mvVqT6z
         r2fw==
X-Gm-Message-State: AOAM530cnpAbaB5gMyd8IUHMaAsqnZhzSEz4LWDiGr/JtiV9Y1qixlff
        S4MIevB1d1YYhYR3hdOeHUU=
X-Google-Smtp-Source: ABdhPJyZWKJCZej5bnvD4Y4bQztX1OlPFEQzNSUpDkx8bR2WlrfgwKl/src31A+wu/zm3PzMcwZe0w==
X-Received: by 2002:a17:906:3fc1:: with SMTP id k1mr11021558ejj.58.1610753077219;
        Fri, 15 Jan 2021 15:24:37 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e10sm4491801ejx.48.2021.01.15.15.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 15:24:36 -0800 (PST)
Date:   Sat, 16 Jan 2021 01:24:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: LAG fixes
Message-ID: <20210115232435.gqeify2w35ddvsyi@skbuf>
References: <20210115125259.22542-1-tobias@waldekranz.com>
 <20210115150246.550ae169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115150246.550ae169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 03:02:46PM -0800, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 13:52:57 +0100 Tobias Waldekranz wrote:
> > The kernel test robot kindly pointed out that Global 2 support in
> > mv88e6xxx is optional.
> > 
> > This also made me realize that we should verify that the hardware
> > actually supports LAG offloading before trying to configure it.
> > 
> > v1 -> v2:
> > - Do not allocate LAG ID mappings on unsupported hardware (Vladimir).
> > - Simplify _has_lag predicate (Vladimir).
> 
> If I'm reading the discussion on v1 right there will be a v3,
> LMK if I got it wrong.

I don't think a v3 was supposed to be coming, what made you think that?
