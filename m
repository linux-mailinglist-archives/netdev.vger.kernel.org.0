Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DEC24587A
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgHPQKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 12:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbgHPQKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 12:10:23 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45D6C061786;
        Sun, 16 Aug 2020 09:10:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d190so11387085wmd.4;
        Sun, 16 Aug 2020 09:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kzPWzjQvi8NpvEpIwSDOHsaGenvBxgt2JfoJa42hJWw=;
        b=GmztMXO2c2Zhl7t2IAvPbr0OckCKebPFn2JOJLajjyXOzdnHjM3fmvJhsFbeKzc4OE
         V/FsDyKbtwgVSbOX4A1LKzeN9zVkTijtHisk5Hr1keTE4acnQhusnJ5LwzEOu2RXCEHc
         FGeBPeweHJq/8K7zLtbuLKYG0NiaARDwgOAL5bwXD576ilfNPesulN4tXY20mZDMJVMx
         mt61DmZalFgiNDW0fQB1bUfMX+pDKiSOxYlSFRL/aOhHOsdJemdPN4IXfkYSHW5837nn
         ubFOwqY9KzM426thaZ6X5CJl3jm+5OfclgWRaviAzWx1PtPReWO51NC6nTwyscB1ZQWQ
         L16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kzPWzjQvi8NpvEpIwSDOHsaGenvBxgt2JfoJa42hJWw=;
        b=g+nNbIfpe04SEk9ik1iKj3AhTIZQWACUVr1IPub5ni7XnCjGkkn02CAKF1/cOR3y4Y
         bNpL/u0gsefPAi+LIdTF2JCoIMUXrODdSQjEvc/reKrFfdEb1/Iq/FoCkGWK/ZxgyIrC
         g+TwcRwRvLpmXm67LX0oD8DiRhrgPu1ZGuvT2ZGzy81EIPjeB6ZTIwkkwLCSaMIfJgCb
         NYXf/DvMUAWwdokXUkNKJF8TjQ8yOt18rW8Lnwr8VWzst+Rqy0nSb/ZwwoDw87upQg0i
         iRR2oFQcA9RxggWL6puOhHvEDJbf4AEIhjzE5Fi6Wn8EPZUvHVeyb8ZQ9uhmiBZTPMvx
         LjRg==
X-Gm-Message-State: AOAM533I1UccZgPAFejeffQEWIXcoTAh87qp0F/Hp4EIjoqZF0PDGDYL
        bP8czZsXQ9MusOOgaj3zWQ==
X-Google-Smtp-Source: ABdhPJxZv3EKUCY2FjhObxKKJNAwkdTv96jEXKV1rwbZ780fLWncv/CGF6Jcc1OBNVkDfL2y68aJXQ==
X-Received: by 2002:a1c:e0d7:: with SMTP id x206mr12212606wmg.91.1597594218748;
        Sun, 16 Aug 2020 09:10:18 -0700 (PDT)
Received: from localhost.localdomain ([46.53.254.111])
        by smtp.gmail.com with ESMTPSA id a11sm28853412wrq.0.2020.08.16.09.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 09:10:18 -0700 (PDT)
Date:   Sun, 16 Aug 2020 19:10:15 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pascal Bouchareine <kalou@tfz.net>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: add GFP mask param to strndup_user
Message-ID: <20200816161015.GA242961@localhost.localdomain>
References: <20200815182344.7469-1-kalou@tfz.net>
 <20200815182344.7469-2-kalou@tfz.net>
 <20200815224210.GA1236603@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200815224210.GA1236603@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 11:42:10PM +0100, Al Viro wrote:
> On Sat, Aug 15, 2020 at 11:23:43AM -0700, Pascal Bouchareine wrote:
> > Let caller specify allocation.
> > Preserve existing calls with GFP_USER.
> 
> Bloody bad idea, unless you slap a BUG_ON(flags & GFP_ATOMIC) on it,
> to make sure nobody tries _that_.  Note that copying from userland
> is an inherently blocking operation, and this interface invites
> just that.
> 
> What do you need that flag for, anyway?

You need it for kmem accounting.
