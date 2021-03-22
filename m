Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061D9345130
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhCVUwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhCVUws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:52:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3EEC061574;
        Mon, 22 Mar 2021 13:52:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ce10so23529991ejb.6;
        Mon, 22 Mar 2021 13:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UNF74mju2yKudQM6M90gJOwGUAJxDsKU0rKDDT/5z9c=;
        b=grU3yVRKT/ol7ZS/+v+2Ri7EqxaAxX79HBuUeyzSPHO0OPFyPNVoxdygLo3S0OzGBP
         8YrsIMse/sLi4lV/SruZ2XFXJ3LKYJMf+dEfB6YmluQpPVaothogQVX7B7F7cSOQlEUA
         9OrSq0fBCzHVC5d0ATvm19FrbOK9vFzR8h7Gxjr5tQ3uUm/R38edNry7N7KFEIYqm5yG
         WB6dVvXqVNxLyF+romR0LQwFT6GA1z6yPbLdDgnp75MUMD/76GZz/DrH5g+YXlwAfpy2
         k0msSovrinz1J0tuB6VLVG1nq3vz6mvvQU1w7XQMDUTjRpiMV06O7Vj6hL09l3OwjrPm
         AaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UNF74mju2yKudQM6M90gJOwGUAJxDsKU0rKDDT/5z9c=;
        b=q+1HEKc5kncjsnp+LDZKConTgkZyththkqVC+7QtWmh10Nu6k5Y5HKZOJP+R8HssnD
         lm0NN+Q5wYT2h+nvy/Q3nb/QNmsDKaznVfdG/7mgwI98qd82gwmr/O43jWmJ+BZNdqrD
         myLbDIK8U3iykjMcG6p7+juqUnV4iI+i4TAJq6N/B8vnHC0lBrOgziHFVpUr5gcv208S
         ooQhCrIcRAozmC0PDuuSGnvN6Zp+n2FGaENozJeLvh7LJn47oI1lsDMeoISbk+M6DX3b
         nRewDUwLA6LmqMBWF2CcGOHpfjFMVC/wtnTYIjW95q2ogfZMQCwXgEyhSHtGUSUuR8/G
         4fxg==
X-Gm-Message-State: AOAM533EasVUbV3H/JilHN+oFYj5y1tnls040YX7rSgSLFu/VGnJTh5H
        xaY6HGApN3pOiX5MWZWQQYdp45pPw94=
X-Google-Smtp-Source: ABdhPJxF0BjsdoPagQhlCHQS7vwmzvCcd9rtPoZNnm+xjhrPY8rAsKPDKV0XbsYaCeTtJNB8mj7wPA==
X-Received: by 2002:a17:906:f10c:: with SMTP id gv12mr1618910ejb.53.1616446366500;
        Mon, 22 Mar 2021 13:52:46 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id gn3sm9856283ejc.2.2021.03.22.13.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:52:46 -0700 (PDT)
Date:   Mon, 22 Mar 2021 22:52:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: don't assign an error value to tag_ops
Message-ID: <20210322205244.qnbyigvyjsniktzz@skbuf>
References: <20210322202650.45776-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322202650.45776-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 03:26:50PM -0500, George McCollister wrote:
> Use a temporary variable to hold the return value from
> dsa_tag_driver_get() instead of assigning it to dst->tag_ops. Leaving
> an error value in dst->tag_ops can result in deferencing an invalid
> pointer when a deferred switch configuration happens later.
> 
> Fixes: 357f203bb3b5 ("net: dsa: keep a copy of the tagging protocol in the DSA switch tree")
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Just FYI, new lines aren't typically added between the various tags.
