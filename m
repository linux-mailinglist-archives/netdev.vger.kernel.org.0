Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4042930558F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316962AbhAZXMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbhAZVkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:40:02 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A2AC061573;
        Tue, 26 Jan 2021 13:38:55 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id f1so21519816edr.12;
        Tue, 26 Jan 2021 13:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0UaWArSz0A8KVjRpfn+obRte2Myxhz1We88E48t13SM=;
        b=ZlA2PIdgNegtp4hYoI5CGtngXjRfaS9rgCn3Cwf1Qy5/pncvcJJF+jURK4USUlkyM7
         yka8URVlrkZdSqGQVJJLdZVAk/EqVeVZN1f9RlO8M7Kg6mvCQ1yL4LZKKewvACZ/udio
         1NNn20n/HRitkim2xqLJxm0m+Wlv5kiD69SVkd66EHvYfBLNc8F8UnOD8ioK6RZyLYes
         rteqbncVM2UQkJqwEqAWUu7jStBL4DgHFIlZE28zAaLZgcHnHRdqAnhxvotNoDQAKBHn
         RZc8LcP1nS5WjSgqtlm4ZKMy0uciK2av6KpQnHTxKxoUrRLxlFmkOSJzzyi/JHwtoVf3
         uarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0UaWArSz0A8KVjRpfn+obRte2Myxhz1We88E48t13SM=;
        b=OIgEhq6nVG9Ix2ijAP1AB01dlfoQrtAN+22eW+h0Iyqac5PcjfDlMBzl417L20GI7m
         b0VaIKTAfPvJ0m4zxss9Qsn7W70hxs1DVR0XKkDIczJvudeqY51k+PzCCW3zOUq5ovwn
         DoTrZItwQ1vhxLzKiKrLwsHyo6+J33JyIZPsmVaaRTS11XXQMvlbmeagWVEFupr+Qgbu
         gc7kqogTvuu6OnfyD0KeDx4ZR6ov7Avai1vs8UDivPYr558/WK2xkU2tnitF9+BJ4dhe
         f9XPRd9crfH6sFYbs/R8GH6LbR1hUQk+J18DR+3CD7+uTGmFkXtcbPVPzAtHsxRZd+VI
         Gwhg==
X-Gm-Message-State: AOAM5338Prqtxjhr2/j/LwNumXYxVjBq3vaatgsmazrPtjlX9HmwDodJ
        +GQzPQpEviEZR0QG1lFVE7g=
X-Google-Smtp-Source: ABdhPJyT0tCcmYN9Mgo81dw6M32vXuQk2GzX0HsZ/wu9ch23XaIor4LIyLT5x4uxR7H8vwS68P6ZqA==
X-Received: by 2002:a50:d6dc:: with SMTP id l28mr6284150edj.105.1611697134569;
        Tue, 26 Jan 2021 13:38:54 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i1sm24417edv.8.2021.01.26.13.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:38:53 -0800 (PST)
Date:   Tue, 26 Jan 2021 23:38:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: dsa: rtl8366rb: standardize init jam tables
Message-ID: <20210126213852.zjpejk7ryw7kq4dv@skbuf>
References: <20210125045631.2345-1-lorenzo.carletti98@gmail.com>
 <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
 <20210126210837.7mfzkjqsc3aui3fn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126210837.7mfzkjqsc3aui3fn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:08:37PM +0200, Vladimir Oltean wrote:
> > and also makes it possible for a single function to handle all of them,
> > removing some duplicated code.

But at least I'll give you that, it is pretty straightforward refactoring.
The register jamming routine for green Ethernet did not check for the
address to start with 0xBE00 before checking RTL8366RB_PHY_ACCESS_BUSY_REG,
because apparently that's pointless, since all register addresses start
with 0xBE00 for the green Ethernet register jamming table. So no
functional changes should be introduced by the patch, and no harm in
checking for those high address bits in order to reuse a common function.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
