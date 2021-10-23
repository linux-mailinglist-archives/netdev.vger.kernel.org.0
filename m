Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EAF4382A0
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhJWJ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJWJ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 05:29:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D69C061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:59 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id u13so3376716edy.10
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gJRFfMZYPb14NKzU3kMaWiQx1HoSJ1p8J7zNb38IwLU=;
        b=QxbhRlKiZ19Eb5Wnl8o6NspprEiKrxzjjLiqkqt+9HsLI98kquarWkcBDZixniD1Gz
         pcr6JHfw7lCujZARsROUwgcrweqR3wY0MrKyI5YfCPUjmUPxe6HXv7lFU5/I9jZvcI2L
         UvjoJk/xKRientvf1lEiw5qSBTEEEmwsMlIIoam3lKZWVgZe+JUbt/4najvCpze5vgqW
         T9DnzEj97GMmraD4XJwruq60fL64xsELZ7iH6r8iDjNZVZDu2YMYiSGcP3lVhYPA2pBX
         A4zqF8vUKmnA7c+Y9JJbznGOEOKyzlA2vP+u0pPNHCdHGW2WIoaaOe6NLtwOvmGi/3wO
         J/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gJRFfMZYPb14NKzU3kMaWiQx1HoSJ1p8J7zNb38IwLU=;
        b=IeoOZgIKh7fofztsweCCchdBVbQxQXhI+egpNDYybgmvEup/lrE3q6L8+4KTSvQNLX
         f7/+g27+sqCDj2rzjv38+dJSiFml4Ak87aQZJ7ffGtZM1Pnbs084nyJaDn5layny0tLA
         txvFEcjZCJkgefTCXE92nxgfMcgyGkYHqAsJ80oDHQxsstDvQaUq/grPLsHcQWU7c3S5
         s8qO/WCY6hA/4lFfSxelPXLbDQWkoUQOEI3nYddI+GZMMBz+VPLtx8jP4c5wGN8dJ8Yf
         eiBZQlv2XyxhdG3S83SwJpiHEKoWm2KMlPj5L7vKE0ESFQwD1sFrhfPKc+vQmwMvPUYN
         9+vQ==
X-Gm-Message-State: AOAM532krITKAUNh3h+AU8PBIWfIrRwxjjQUKAj+FCbn+QccIoIGs9RF
        5fAEKBvY8M4Mtw0AEA1FZmLz5lA14AE=
X-Google-Smtp-Source: ABdhPJx714c3Lp1YCvR7rZjHvbTpVwZSzH28hWP5OteP1oRchc4YbeFq2dl0udzlfmP+Us9ou982tw==
X-Received: by 2002:a17:906:c1da:: with SMTP id bw26mr6377388ejb.253.1634981218395;
        Sat, 23 Oct 2021 02:26:58 -0700 (PDT)
Received: from localhost ([185.31.175.215])
        by smtp.gmail.com with ESMTPSA id v10sm5651781edt.24.2021.10.23.02.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 02:26:58 -0700 (PDT)
Date:   Sat, 23 Oct 2021 03:26:51 -0600
From:   =?utf-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: qed_dev: fix redundant check of rc
 and against -EINVAL
Message-ID: <YXPVWzH/ecvMl/vP@mail.gmail.com>
References: <cover.1634847661.git.sakiwit@gmail.com>
 <e7289c4e6a57f9a98a8f3fac1d5c7c181cbe8319.1634847661.git.sakiwit@gmail.com>
 <20211022144720.7d1d9eb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211022144720.7d1d9eb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 22 Oct 2021 14:47:20 -0700
>
> On Thu, 21 Oct 2021 21:37:41 -0600 Jεan Sacren wrote:
> > From: Jean Sacren <sakiwit@gmail.com>
> > 
> > We should first check rc alone and then check it against -EINVAL to
> > avoid repeating the same operation multiple times.
> > 
> > We should also remove the check of !rc in this expression since it is
> > always true:
> > 
> > 	(!rc && !resc_lock_params.b_granted)
> > 
> > Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> 
> The code seems to be written like this on purpose. You're adding
> indentation levels, and making the structure less readable IMO.
> 
> If you want to avoid checking rc / !rc multiple times you can just
> code it as:
> 
> 	if (rc == -EINVAL)
> 		...
> 	else if (rc)
> 		...
> 	else if (!granted)
> 		...
> 	else
> 		...
> 
> I'm not sure I see the point of the re-factoring.

Agreed.
