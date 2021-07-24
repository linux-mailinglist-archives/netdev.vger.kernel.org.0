Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E6F3D4426
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 03:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhGXAUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 20:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbhGXAUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 20:20:47 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FCCC061575;
        Fri, 23 Jul 2021 18:01:20 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso3806024otq.6;
        Fri, 23 Jul 2021 18:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tGlN8HSaV9k0jITj/r2jo/8d/MRHinWIK/4HAcGZpRE=;
        b=uCiSmPZ/SSWBI7v/vnDLUgzDt+u5Cz6QmIY2k0rNcq1jahE/jP8uCQQpyl3YG/bejN
         Q9ZKztsOMYtEn1fGkqdUO9F8t6uGou5m/PVpGjAPi6qb5fZExlCn2RzwUYQCqJAoIAvn
         32rl4avypbXv8xgc0ZhRiEQpkrjUgUVvRYculc/G0Q4z5o38jo0g7c5aj7nu/TTRiIOa
         Lvw05q13xFszEhD+hVNGNR6MKpyprG4s8uiYviUnGyFHTejki8dBUxLklpMmdcNnJWVQ
         MquGiji7eAZPJ38gtsr+fbUpS9Wy9M1vZMNnG1xxWKIclUrTgEZaFJOzSD4M4liJUqVC
         +vnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=tGlN8HSaV9k0jITj/r2jo/8d/MRHinWIK/4HAcGZpRE=;
        b=hniUVOY+iyH2GLYAD9A8huvJ9V/v5GzNRKp2J/yasKkTaazmZxCdQIdWyhKqvSZurX
         60rjCL4ZFYcZf0lMyIWTSWkPYU1stMy7+Z+t9fe1yU5/8pnOF2u8GCQqlF0MC8nmbfEO
         7e3r57ZEJcSmR5vnLaRAoiP+92tkd23gLayo0avyH0NY2DKwxqmZ9fcfHtpRPzDsIcxO
         VPN5OC6DOzUPg9GX1vmFjVjfThHOkVUUTPKSKOt7ClCugnryEgTLZmL5m8+wNPR6tq0i
         fC3KKDzM23azoUDl6wNqXrTpUwEzmB9gIZIvV9bAbKBaFSgBWZnOyo5avD8/mPJVdaeD
         7xPw==
X-Gm-Message-State: AOAM530ZqNA+WUdEDA7XEHqNEBogwwtEVt4rlXkCGAFxS+SXLkrwW4ch
        x6JWlJYs51RygjGulBtouK1gWRYDS5xZ
X-Google-Smtp-Source: ABdhPJwCS6j7fngJUKTOLTY3hReu6SmW+4wZ1hGLObgwp/mydJnu1wCwIYT1fvkexCxFg6XZRW08hQ==
X-Received: by 2002:a05:6830:4188:: with SMTP id r8mr4791119otu.53.1627088479993;
        Fri, 23 Jul 2021 18:01:19 -0700 (PDT)
Received: from serve.minyard.net ([47.184.156.158])
        by smtp.gmail.com with ESMTPSA id w16sm566518oiv.15.2021.07.23.18.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 18:01:19 -0700 (PDT)
Sender: Corey Minyard <tcminyard@gmail.com>
Received: from minyard.net (unknown [IPv6:2001:470:b8f6:1b:444c:e3ba:c3cc:726c])
        by serve.minyard.net (Postfix) with ESMTPSA id 6503A180058;
        Sat, 24 Jul 2021 01:01:18 +0000 (UTC)
Date:   Fri, 23 Jul 2021 20:01:17 -0500
From:   Corey Minyard <minyard@acm.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: IPSec questions and comments
Message-ID: <20210724010117.GA633665@minyard.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Bcc: 
Subject: IPSec questions
Reply-To: minyard@acm.org

I've been going through the XFRM code trying to understand it.  I've
been documenting things in the code as I go.

I have a specific usage question, then a general question:

1) In struct xfrm_dst, what is the difference between the route and path
fields?  From what I can tell, in the first element of a bundle they
will both point the route the packet will take after it has been
transformed.  In the other elements of a bundle, route is the same as in
the first element and path will be NULL.  Is this really the intent?
Can path just be eliminated?

2) This code is really hard to understand.  Nobody should have to go
through what I'm going through.  If I can convince my employer to allow
me to submit the comments I'm adding, would that be something acceptable?
It would obviously take a lot of time to review.  If nobody's going to
have the time to review it, I don't need to put forth the extra effort
to make it submittable.

Thanks,

-corey
