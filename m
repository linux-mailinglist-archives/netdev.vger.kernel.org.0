Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A1B27664F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 04:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIXCSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 22:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgIXCSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 22:18:21 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEFCC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 19:18:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b17so764037pji.1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 19:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JKpS1EEybDWJcL7roiOItPRiFvYwyOuJ6Na2dWY/I9E=;
        b=ULEauTEM9pdh2ssTe/sEbvJQ/op261Hl6CLMTo3M2z667oziSmwUkblsC/p72ROWe8
         7mIh7RPU0obu/u6hEgtdBkBmHp2wH/jrGox7HODG1lQJSeHQ3nq4y1/fwOJ+/j2WrroA
         dI0feSSvMQGOaydpYdgNxS+MdI/DgJUoCGt6a8AAl/bNeU68y5M8g4nKh8sI3P5vxpKD
         zV5SU0Mvyldx8f/VnwcSr96A7Ob+ywN/TpSK4XEf0Mecv8b4NC+s4J6eW9DdkLX6avyx
         9TtyESE+R+O4WmA8D1GQ0/joy5BN9nD9UlcwdB+DxzqK2ywQo53fke7wX6nHXBUqdrdD
         avoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JKpS1EEybDWJcL7roiOItPRiFvYwyOuJ6Na2dWY/I9E=;
        b=D5VRbc8PC/5DASoXbZbPzod0yH6PNVWzIeadnaiO1ALfife2hDynozTdx6nDO24uO/
         D/dVoa+SJ0kYWXH/LCkHs47dsxRYyE0UieLQ3GbL1iQx5nn4ksmbWXGk+UoXZuToejTU
         ZycxY3rwNtgKxnTPQpC9+nhvsnAbNtfJdeLtANHvXeWjhG3KmbMq9BHYvulYZO7Q1j74
         LAjaRjeYHTMdfGGsuX5HsTBoRNZ8ULlL7RD3JhR8phIlKAYDiKX4HFDm7Qua8wkbQyCW
         tmTz52kDEb1qgpn6rasPJj1WyvVIuGO4nxe7Q2awcr/kPln2oth0VACN8cyDiu+Ywbps
         pu5Q==
X-Gm-Message-State: AOAM532H15vMkIQzFOUhBWXXCf8smQWZ2v6kGXNqo6R/UEyaea1JOL2+
        GMnNFnWsQsI1TMw8To4ZvCA=
X-Google-Smtp-Source: ABdhPJxJOeOeXbaXYm1lvVCOBCahWYNQF3jT3vnCbdXdHrLZT17RU1AsJUb1GmX5u21U7hS0JaOj2A==
X-Received: by 2002:a17:90a:e2cc:: with SMTP id fr12mr1921055pjb.125.1600913900508;
        Wed, 23 Sep 2020 19:18:20 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r4sm623992pjf.4.2020.09.23.19.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 19:18:19 -0700 (PDT)
Date:   Wed, 23 Sep 2020 19:18:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Message-ID: <20200924021817.GA6273@hoboy>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:24:20PM +0300, Vladimir Oltean wrote:
> Currently, ocelot switchdev passes the skb directly to the function that
> enqueues it to the list of skb's awaiting a TX timestamp. Whereas the
> felix DSA driver first clones the skb, then passes the clone to this
> queue.
> 
> This matters because in the case of felix, the common IRQ handler, which
> is ocelot_get_txtstamp(), currently clones the clone, and frees the
> original clone. This is useless and can be simplified by using
> skb_complete_tx_timestamp() instead of skb_tstamp_tx().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
