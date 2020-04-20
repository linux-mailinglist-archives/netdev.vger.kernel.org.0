Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853C71B187F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDTVeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgDTVeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:34:11 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CC0C061A0C;
        Mon, 20 Apr 2020 14:34:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w3so4441450plz.5;
        Mon, 20 Apr 2020 14:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ngBQy1ShJKeMNEcOYtB0Goj5+Rtf1XPN16PoTzN6Leg=;
        b=W2Us/jbX10J6JgHcI+yTDBmtiIXCW2MFCTUAFrkq9lmd0IzSUCsb6VMRR3yDsW/dfu
         GWdEUrjtMdzc+hFFsRjzH24fON/tRNB8vmtK4JNGXEWElZPD5//pUlH1+P07dvGsKmPH
         xDFzpe2whUTSpZYCZHIgkoJQtz3Y7OxaDLbWIBIaemUZSIelJJ2ZukeLJTn0Ma0GPlDm
         lLjn1xSDgI158rHQpq8qzCW0wTUsXdWNEBDAoB4sxJ+/x4XqBmDrEm7TmKc7dw+SiOLF
         RwZyiBP5JWcxUP5RQsn9/OWkEiOuygonpC9C0WMg6hufuYrd6kDSYRKAv+y0Fjaymyi5
         Vd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ngBQy1ShJKeMNEcOYtB0Goj5+Rtf1XPN16PoTzN6Leg=;
        b=EonIEsDWnYtCo3jAzNdOdsGcgHQvfue+20uRcxPgEeC+xYwSlmsjgeFnhI68tAQ0wB
         ukdqOfD91kpHbWArMeI5qZf56h1A66IO+fT4dmm1zuYXn7k4CCrPS4vtNrC7wVUDJXu3
         MyQkQH4DmLBPNqgWCl1suZHKFuVF5SG94YgVF3YO3WubiZKaqkYQRrqx+JoKCENIPsoS
         mGsSBB2ZkSfxdwV2bTNxyfIZKrwx/bjh4eAyHXgcF4uRSmTgt4uwfGxxOE57ozjwHbgU
         4FySa2Qzz6bNT31u05eQhZr3z5MQtvMTWWXip+96YfoAXXZNH0ybqvxUB0yY1mP402H8
         6PbA==
X-Gm-Message-State: AGi0Puage3GKCy4R7301UaZV3RqmOVOjP34tRuaBbqc5Ej3sjBnVTk3t
        LxspDteV4Qzq04qo7StmZ5is91wv
X-Google-Smtp-Source: APiQypLOFKtNhGFo0UvjO6gLP4+Jh1qO0rA232c3p3m636GsPllrstk3XMhjakiQXenT8r+xhwXdHA==
X-Received: by 2002:a17:902:8345:: with SMTP id z5mr14890188pln.97.1587418449491;
        Mon, 20 Apr 2020 14:34:09 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i10sm416268pfa.166.2020.04.20.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 14:34:08 -0700 (PDT)
Date:   Mon, 20 Apr 2020 14:34:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Clay McClure <clay@daemons.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
Message-ID: <20200420213406.GB20996@localhost>
References: <20200416085627.1882-1-clay@daemons.net>
 <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx>
 <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
 <20200420170051.GB11862@localhost>
 <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
 <20200420211819.GA16930@localhost>
 <CAK8P3a18540y3zqR=mqKhj-goinN3c-FGKvAnTHnLgBxiPa4mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a18540y3zqR=mqKhj-goinN3c-FGKvAnTHnLgBxiPa4mA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:21:20PM +0200, Arnd Bergmann wrote:
> It's not great, but we have other interfaces like this that can return NULL for
> success when the subsystem is disabled. The problem is when there is
> a mismatch between the caller treating NULL as failure when it is meant to
> be "successful lack of object returned".

Yeah, that should be fixed.

To be clear, do you all see a need to change the stubbed version of
ptp_clock_register() or not?

Thanks,
Richard


