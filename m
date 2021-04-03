Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EF63534BF
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhDCQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbhDCQiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 12:38:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6B0C0613E6;
        Sat,  3 Apr 2021 09:38:13 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id mh7so1235327ejb.12;
        Sat, 03 Apr 2021 09:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r7z9PZUHOLRPlsyUlJgKqk0kSJfJAIYpWl69+JjFgoI=;
        b=p8w9WxO9mvUwXBifb2jC2gia/2IL49GV/IWNE5RhAElRlHOgGbSXCqd1uAt1T/l/oi
         E3sFN57uNk9+2vPl14W42U1SuSDkpsguH1laX6/SqMJR3fs8Vh8JhITNq0q0it5qIUqR
         uTI9b4iohZCAhanWrLlDBSjLkp4mZBu+zfXTrxnHRzv0KTCEuyIQ7JUyLnOzKfRneOO4
         uGMLS+ffJwPngqL7xw3QnhTxga+cO6HQgPpAXZXrtFrNBk2XPAamIF0jeUKygQcL8hGB
         Oq/CJN9nFXtndK6CJUStRUy4SNQxBpP5RxqAoPbMuWOAcY5MJjBSnCncwiJOeewCl4Ij
         34CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r7z9PZUHOLRPlsyUlJgKqk0kSJfJAIYpWl69+JjFgoI=;
        b=fapy+BLT1Qx2a1NiOddrxjbEaK3S7hmau16mXPWFotWcIvJFIY7Eq6DKOa97qgRAEa
         Si5lU603NluOJMw9vxYU2mr1IqeaZv3YiF6aa8k98z/XfK+CcSGkk9/urCiJc8UzjFHJ
         Q5SfNDVmzW5+dr2PACOpaQCC/WJO1ILHNpKuPIlRggwNVCr9aIljTxgYbMD7+R01Edrc
         Zs3AZJaB2/ZRD19YpJp00G87IiI+8RgCBR3Yq7n+AY9We+wmaztUukb3rkIcp4u+yVxN
         aYe1UQhWW8qZS2g+Iny853+udWrayWO09uBTJvYltogJrVh1JTj1YtwlEKX0YGlHi3Cm
         L8Hg==
X-Gm-Message-State: AOAM531/6XLCJ8Wg9eeBT4a98uF2qI4RLvyfr9ZYkYO4jlg0o9NqdgZX
        TDhxXGkUn63EStbonauzdgE=
X-Google-Smtp-Source: ABdhPJwKerWFa1OIrj6ZrGjYJSLBWDSIIdqGH0oppIu0Bp8FChk2eAUw95BXiDLpqmFvTj8rh4zO2g==
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr20098498ejc.63.1617467892122;
        Sat, 03 Apr 2021 09:38:12 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r25sm7345698edv.78.2021.04.03.09.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 09:38:11 -0700 (PDT)
Date:   Sat, 3 Apr 2021 19:38:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-mips@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and
 MLD packets
Message-ID: <20210403163810.xut2oilz4d7zuqli@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de>
 <20210403130318.lqkd6id7gehg3bin@skbuf>
 <20210403132636.h7ghwk2eaekskx2b@pengutronix.de>
 <20210403134606.tm7dyy3gt2nop2sj@skbuf>
 <20210403152224.u7vbehkijg2wzxon@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403152224.u7vbehkijg2wzxon@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 05:22:24PM +0200, Oleksij Rempel wrote:
> Off-topic question, this patch set stops to work after rebasing against
> latest netdev. I get following warning:
> ip l s lan0 master test
> RTNETLINK answers: Invalid argumen
> 
> Are there some API changes?

Yes, it's likely that you are returning -EINVAL to some of the functions
with which DSA calls you at .port_bridge_join time, see dsa_port_switchdev_sync.
