Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE2D2A1BA6
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 03:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgKACBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 22:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgKACBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 22:01:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11360C0617A6;
        Sat, 31 Oct 2020 19:01:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k9so6281042pgt.9;
        Sat, 31 Oct 2020 19:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a7o4jROBnfdJXuhZxO8G3X3b5+22IcMn0QJHe1EfYyA=;
        b=A5lHhiwgQzpwq6/6EyDExcgcJAQRhIVrVdbWWkDt6SX3Y9654TOaQgGOSTBBQNSt9U
         l2KRVoAQ+m2sPVrXpUYbwbu/WafTQFc2q+wlITg43z03SMgcdDPPF2zqqbbQn+dL4fks
         gBiK9yfRLeOLzVHtjY2hcMKGw0RpE1Lv0TygMfPbTidoj0merEugXz/iBt0E2wI+jfD2
         Um32ccDp3Y9MBeCRkb5ULXnDyd2JnFtJeJMOzYt57cPW/RmPW+V/jhL8dx1IcpeduA2z
         D/oBPAEutRxWQ9Tw/2WoejxJ9i9o+uWz/6eM93XbUB1g7UTkC3gx9Iq8ao48qHlr01i/
         QmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a7o4jROBnfdJXuhZxO8G3X3b5+22IcMn0QJHe1EfYyA=;
        b=Hg/GuZQimchMzS8DJj0mfez8XfwdFTcqphkbscaDJNI1diykNxCga9VpYRB6gMdh/8
         gsPP42/1zguwFrx5UNaZyBrId8VaIDQWyZnamii40x7P8mBMazfzic0BaxPZQB6Ow4ce
         UUxUYhk19R1il9p59wCRjsju3GvnT5lksgkf5GdWWHwG/FRo1yvVKGa4VOhi9BfrL0kN
         YeRrjrrcL6mqXJyHT3xtvBIs+uJh6b1a/UPjrJSeD3xK49YzHIR+Xp4q6xxbpschP4Zk
         l1yGwZ4tFwBW33dEiGDtKNNqT5Qlz0BlgyOYDc8FdgP0eWWshPnThJ9iPHKIChGgSb6P
         sNPw==
X-Gm-Message-State: AOAM532pRruRIeu39ZSDwxSD29jsn9jGogGtT1/R6voRWj1c1A+vzuyW
        r1ZjfKl3gq84CwqQjxHeBuA=
X-Google-Smtp-Source: ABdhPJxmzixU22h1FH7oamz0b1uIIivni8AvRmO2GKxJrsV+G+zZ0Tpr5CMrYex3o8aFi66aZzQQPQ==
X-Received: by 2002:a63:1649:: with SMTP id 9mr7774516pgw.91.1604196104635;
        Sat, 31 Oct 2020 19:01:44 -0700 (PDT)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j6sm9130978pgt.77.2020.10.31.19.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 19:01:43 -0700 (PDT)
Date:   Sat, 31 Oct 2020 19:01:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next] selftests/net: timestamping: add ptp v2 support
Message-ID: <20201101020141.GA2683@hoboy.vegasvil.org>
References: <20201029190931.30883-1-grygorii.strashko@ti.com>
 <20201031114040.1facec0b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031114040.1facec0b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:40:40AM -0700, Jakub Kicinski wrote:
> On Thu, 29 Oct 2020 21:09:31 +0200 Grygorii Strashko wrote:
> > The timestamping tool is supporting now only PTPv1 (IEEE-1588 2002) while
> > modern HW often supports also/only PTPv2.
> > 
> > Hence timestamping tool is still useful for sanity testing of PTP drivers
> > HW timestamping capabilities it's reasonable to upstate it to support
> > PTPv2. This patch adds corresponding support which can be enabled by using
> > new parameter "PTPV2".
> > 
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> CC: Richard

Acked-by: Richard Cochran <richardcochran@gmail.com>
