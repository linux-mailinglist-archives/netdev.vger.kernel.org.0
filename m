Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296032906C9
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408451AbgJPOGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407839AbgJPOGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 10:06:40 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6FFC061755;
        Fri, 16 Oct 2020 07:06:38 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t21so2526805eds.6;
        Fri, 16 Oct 2020 07:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=14AwbVOrANvmd2gKmULXHCvQZTcutgOJ9S2hV+uQszg=;
        b=mlcbpjyup5uC61aRrI0uoa9OlUEVuiNpADGxMgDLPgxCS5zss/NFh/07BPV+xm2Yxo
         JRp0EqaWAvzc0E+ttAVBjF9PfJxUTT4wGc36Ysu6BWQUsyaXI6P+hdhavAJbr3hTdkoe
         CebKBQS1aoe6Il0JY4u1tLISgXXnYUUkpFVyOkFULScFO5qRvXbHjffDD8ySa6BpeJUH
         ZPynLz2Nyc2ZDl+rxaDPGZ5cDxXxP5cAX9YWmQSpr25TRquVYpWq0SAgXKEvepwNC8ZR
         NRXlFa3kvEe+hsKQgjAobIf2AG1xKIm3ToJPfzBy79G5YCAE1eC2nKdDMXyPmbpWXbnd
         vduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=14AwbVOrANvmd2gKmULXHCvQZTcutgOJ9S2hV+uQszg=;
        b=LBN7si6qnssFngfqJr4B6ZPhF63WQRkD9vvL0ZQ5ccGnTutHR7ihkefDKghtv1BuCv
         M1zHRy5aPeGOKNOe7MQm0ArxtgUwqFRonbfTR5sfesizPqaGNMdZFF98w6N/2FUWAAyr
         ne/9SwCXoz4FLxj1jnMpyGcjFTYFGJNmSSVwMAAmXYZJMGAu3tUsfMo9SNHbIKB8EntI
         Cv/Rbe837QnmqX6f+RKJB0dgJ7EVc76uW6S9FdaCrKlly1Mlh/fgJwr2/GhNMN956hZ0
         Y4sZPhS+jxQ0tV96QjFz+oUJydpOIkWSubX2CY5nI07bzGyUcMhoMD99az3+0wkVH4k3
         etEw==
X-Gm-Message-State: AOAM530D4hDpREWuCMyjbhwM0KQMaXrusJIhrImYZNwd6fI1x+BgOgOQ
        VxBhoGdrmI73jeTGpTxTdb0=
X-Google-Smtp-Source: ABdhPJxbp62Z7v6JbeH/zHwSreP/1hdqrrmW0xN5OEgNffPh5wVqTKklmHpJ0/TloyJ14I1StYyyCw==
X-Received: by 2002:a50:d2d3:: with SMTP id q19mr4257026edg.22.1602857197110;
        Fri, 16 Oct 2020 07:06:37 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id mc4sm1678438ejb.61.2020.10.16.07.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 07:06:36 -0700 (PDT)
Date:   Fri, 16 Oct 2020 17:06:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: don't pad a cloned sk_buff
Message-ID: <20201016140634.acu6v5igxih2xukf@skbuf>
References: <20201016073527.5087-1-ceggers@arri.de>
 <20201016140036.GC456889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016140036.GC456889@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 04:00:36PM +0200, Andrew Lunn wrote:
> On Fri, Oct 16, 2020 at 09:35:27AM +0200, Christian Eggers wrote:
> > If the supplied sk_buff is cloned (e.g. in dsa_skb_tx_timestamp()),
> > __skb_put_padto() will allocate a new sk_buff with size = skb->len +
> > padlen. So the condition just tested for (skb_tailroom(skb) >= padlen +
> > len) is not fulfilled anymore. Although the real size will usually be
> > larger than skb->len + padlen (due to alignment), there is no guarantee
> > that the required memory for the tail tag will be available
> > 
> > Instead of letting __skb_put_padto allocate a new (too small) sk_buff,
> > lets take the already existing path and allocate a new sk_buff ourself
> > (with sufficient size).
> 
> Hi Christian
> 
> What is not clear to me is why not change the __skb_put_padto() call
> to pass the correct length?

There is a second call to skb_put that increases the skb->len further
from the tailroom area. See Christian's other patch.

I would treat this patch as "premature" until we fully understand what's
going on there.
