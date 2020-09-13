Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F233C267FB6
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 15:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIMN5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 09:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgIMN46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 09:56:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78538C06174A
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 06:56:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so4113905pjd.3
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 06:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yNE1kMlTeWsuob5PdKjP2m8LI8u3onriul/c8mh7EfM=;
        b=KgcZ3oKTk5bGi5/M68UwRkxgembsOuvGia5x+8w/73TFqX0Pr3FDwOFABm7ouBaH4U
         I7vwvSm+z6nH4ZYCNj4494wKi8Q0MJd9o0PkIUwNmW13pk2XGadb/b00YstQPtBinXuV
         QoCR17+g71/v7Tq1fpMUrsMpJoSXEc+LtFoA4E9MBVdTmTlARXnPHSo0tv/KB4kr7UZj
         faCCxdJDdakR8OjuYFEY5yekCLNGiXjWaIa1RSVWSmNWHyr9t/cKqjPMHJsWxGdBYErd
         Ab6lJPicZdTdumB0cS05E/sqb/wJNx/B595hEajwpIYfywX4u9kviW+1Gx2EEQloh4Na
         8suw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yNE1kMlTeWsuob5PdKjP2m8LI8u3onriul/c8mh7EfM=;
        b=L0nqU4Unp9qKLoG/VywScSSqTCbLQUtIhHTgiWIbZ0+arCNzH/F7S13CckSAduDelA
         ZcDNeFcHYaliKwsz/qGOgTf30GbHSfDP03P3BUYE59Xzxr3o93nq7GPUPm57FyBYMZMn
         VVD+n+M0y/9ao+JE6wDu/B06782z8RV0qR7OaQYOPgWOS0VmGLIacRJmVTOpdLNlEIVI
         Xlz7Q38MFMG/eo/IjS8AECsVAKkU3fEy82SYc0LEfTBUO5I7rRp37sW1t4VsBfy9ij6t
         P55kQRoo1kSJoo0svPzu6ezg69XWzfbN0LXcS63BvqqTpyKqBXDLJ7hDkIM+wieX3UEy
         /8fw==
X-Gm-Message-State: AOAM532tw9E1U953BJVQ8qHhQ+WSRilvMHX+EHhuXn8TjB58Fjt1t2WG
        F/zkYZknH7c8yq6sisOCCPaTcpNKLJs=
X-Google-Smtp-Source: ABdhPJxMXjOJHo2606sfTIUlr3R8vZVF+qQ1TgJXc+gq+XtDmblfakXw5nIhBgF7EJCnLnyfupsCxQ==
X-Received: by 2002:a17:90a:5b04:: with SMTP id o4mr9896986pji.128.1600005415089;
        Sun, 13 Sep 2020 06:56:55 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e17sm7298944pff.6.2020.09.13.06.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 06:56:54 -0700 (PDT)
Date:   Sun, 13 Sep 2020 06:56:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvpp2: set SKBTX_IN_PROGRESS
Message-ID: <20200913135652.GA11540@hoboy>
References: <E1kHM5A-0001Hg-Sf@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kHM5A-0001Hg-Sf@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 08:05:52AM +0100, Russell King wrote:
> Richard Cochran points out that SKBTX_IN_PROGRESS should be set when
> the skbuff is queued for timestamping.  Add this.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Richard Cochran <richardcochran@gmail.com>
