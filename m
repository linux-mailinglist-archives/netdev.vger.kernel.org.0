Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11241B126A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDTRA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTRAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:00:55 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D93C061A0C;
        Mon, 20 Apr 2020 10:00:55 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so1588648pfx.6;
        Mon, 20 Apr 2020 10:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BHSxCs0+zI9VZjGMHWft4UbDRlvs1MXJWg/zkpDRlJU=;
        b=MZ0pdSgO4bMc73BJpJ3j+x5uvN2zk34rLBsrvTudkccgKuEmOfVIhr8YaHA26LLWbC
         Dym/EL4BuM1avyDs1EG3ytQGZ+wN6KN+kj6A7ES3iHL3HF5m0ef2jUBM60oQbOzYYwGW
         Ft2vy4Hri+4RNFmD9I4yXH7WCfilI/nqIhKWXle9QnnbZdd9Jor5HomnJLmZeXwTUFQx
         tkkSdNHJtdy1aLZ7nbKKmgT1mIdEYKu9e2qDk2uPWTAlwPF8+QisIzf9GhYPODNjFLUc
         G11vcqAsn7Te2d3czzj7K+JTfrQsfUw5q5oarjW/TPUa1WT+h2MMUqeQeg7UHQk+nojG
         X/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BHSxCs0+zI9VZjGMHWft4UbDRlvs1MXJWg/zkpDRlJU=;
        b=dkpCTcFgcaWJOp9BlK7/u6NrDy5nffo9jD4hU5hn9OeeLEj9DnRjA0q+6TuYRf797N
         QhH8us6AQ84sGhx8SngtMu3Sb8QcVGSQx/wGBXZPzxr8RXR/k/GsxttZFb6q68gi7cf6
         zfZpYY66kOMYHX8Rm0NhmYPCL2hTKHSi+9cdqGs27iw/Y+Cx6I2qqvBmdAmdmV1ZMqSO
         MlMqOxSaYVlYBb2jUPqEIqDAz/T+t8KzQiq7plIPoFhtSWssQzOvCnLVPVF/xwY6ThV6
         cVptLRT3hExlmq+d4RufnDNbv/3TiD65r3p4ZZEcpztpDZcgLt5uYQimLMFoC0BMDuN8
         W5Jg==
X-Gm-Message-State: AGi0PubqjB6gza0o26VVtq6i3dZOQ+sAhRpfGopmRQ0wciDPAMQLphxM
        zp5+4JTbznrMPEIyIEHrMB0=
X-Google-Smtp-Source: APiQypIgZ34E5sI1wlf1j7rWPBsVNlP7C/4Zz7mK9RBEQn4mFjyLoCFcirDq2FGscberTb6WjkRwfw==
X-Received: by 2002:a63:7901:: with SMTP id u1mr16812904pgc.409.1587402054670;
        Mon, 20 Apr 2020 10:00:54 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i25sm15851pfd.140.2020.04.20.10.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 10:00:53 -0700 (PDT)
Date:   Mon, 20 Apr 2020 10:00:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Clay McClure <clay@daemons.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
Message-ID: <20200420170051.GB11862@localhost>
References: <20200416085627.1882-1-clay@daemons.net>
 <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx>
 <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 04:38:32PM +0200, Arnd Bergmann wrote:
> 
> I suspect we should move all of them back. This was an early user
> of 'imply', but the meaning of that keyword has now changed
> in the latest Kconfig.

Can you please explain the justification for changing the meaning?

It was a big PITA for me to support this in the first place, and now
we are back to square one?

> Something else is wrong if you need IS_ERR_OR_NULL(). Any
> kernel interface should either return an negative error code when
> something goes wrong, or should return NULL for all errors, but
> not mix the two.

On the contrary, this is exactly what the whole "imply" thing
demanded.

d1cbfd771ce82 (Nicolas Pitre       2016-11-11 172) #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 173) 
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 174) /**
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 175)  * ptp_clock_register() - register a PTP hardware clock driver
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 176)  *
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 177)  * @info:   Structure describing the new clock.
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 178)  * @parent: Pointer to the parent device of the new clock.
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 179)  *
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 180)  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 181)  * support is missing at the configuration level, this function
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 182)  * returns NULL, and drivers are expected to gracefully handle that
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 183)  * case separately.
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 184)  */
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 185) 
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 186) extern struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
d1cbfd771ce82 (Nicolas Pitre       2016-11-11 187) 					    struct device *parent);

Thanks,
Richard
