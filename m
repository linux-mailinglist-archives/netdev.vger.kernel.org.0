Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B26284CBF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJFN4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFN4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:56:35 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CF9C061755;
        Tue,  6 Oct 2020 06:56:34 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id p13so7716305edi.7;
        Tue, 06 Oct 2020 06:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cz40KVmNgOYFQOZJ05GYZpHq+jELy+OO58/2i9DcBhs=;
        b=oeNxVmq3GucY1ng6CzrU5lKB5c6sa4MmlwCd+Oijv+aQ9RC+ily+kcCwQeUumRUh9b
         i5UaaR5w6lOicX1W/FpXaLFoB/OX6PPikttUAGINHXPoP2yVmx8cnZS5M5Mdgj7BBgK7
         DtwV8a8ARB2sAxihXTtTaCroUu3OhTjMiQB5fApo20B+94+CMfpK9pUyyDzmNo2yqPkS
         v44Eg5EF5kL4LOUN2w3/HW/qGy/LdqfG5IYRVoIBOZUCU2mfX0SQ6yIaklwhOt2RPpIO
         oW+zQLABLyG5KvqqZ7rV5AXwjrvgIAEW9VcrpP1zevDul46kSE7g0396BiU+0Sik7wbG
         Zphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cz40KVmNgOYFQOZJ05GYZpHq+jELy+OO58/2i9DcBhs=;
        b=UbNdDhamoVBoF9J8wBUky/IWUvO+2hpI8SDzPTipc/GObfCb4CgQrlin9Cx6/GT8hN
         fqHLTT+m7FmFy0TwvbuE6lBwY2Pe8DGV8nW7jD9TEr8N0jEKya43lgZ1cPknyotQaPaT
         ovvl21/a4kzzgyIXhTDyK7OQ0LYdWdWdvWwQFkD2cjslYy1sKO0iUySlS5I4zN+nqGIx
         mam7TX8zTHQAQKOS+YqhfWLWLmOPK6idvCLIBFlrfj4+Mwpdx37XjdM6AGQQZXcr9quk
         1uexJmB5F6OFSjD55oUbMT9T+57YcHLbVVhxmkMs1fRItYEctTSAhEBR0/oIIMhdUkWh
         Y4MA==
X-Gm-Message-State: AOAM533Sd2T5rc5fqCYRUmYkTgaPLdHZfRTqAks3pPG9gPZqsqfJoURi
        r/+0ZZgmmkN9xHF7YtCA8Q0=
X-Google-Smtp-Source: ABdhPJxAwoM27FXwivVZdMwIJWCs7P1die4z1Bi7l+2mEgNYrdoja17mtCrn7Kekun7v3mAhIMnBlA==
X-Received: by 2002:aa7:c1d7:: with SMTP id d23mr5439653edp.205.1601992593114;
        Tue, 06 Oct 2020 06:56:33 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id bk9sm2192796ejb.122.2020.10.06.06.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 06:56:32 -0700 (PDT)
Date:   Tue, 6 Oct 2020 16:56:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201006135631.73rm3gka7r7krwca@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
 <20201006113237.73rzvw34anilqh4d@skbuf>
 <87wo037ajr.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo037ajr.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 03:23:36PM +0200, Kurt Kanzenbach wrote:
> So you're saying private VLANs can be used but the user or the other
> kernel modules shouldn't be allowed to use them to simplify the
> implementation?  Makes sense to me.

It would be interesting to see if you could simply turn off VLAN
awareness in standalone mode, and still use unique pvids per port.
Then you would have no further restriction for VLAN-tagged traffic with
unknown VLANs or with 8021q uppers having the same VLAN ID on multiple
ports.
