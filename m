Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326D614B67
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfEFOB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 10:01:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46454 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfEFOB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 10:01:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id t187so2383853pgb.13
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 07:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=blNElsH0nKttFL9QJoixbJLS8nXkItulDEFRWhW74QE=;
        b=Yv3d3PAdQXN5mSui3Q5+5KwGMkn7hYbhH1JvQwGEdXLT/BncT9ub4ojfSLosEDADKd
         kSR3niAEVGhBQMmiDhtSJxf5QCAi9dujegSGosPxFIt8eUOoMBBIkFSDhR7QCFWTX2vu
         Lc4isCAhJUwnNrYxmQ6Gx80kGwvirlY35V8GEuViFjheWgbtYZgWUhMiNhvSxb+S6k/E
         qEapY3d3BxkES65JF2Km+AhSQRiZXNUdRKfPa7z1ZVSYJL9DOKsnytec25ndkkSL0pjk
         uUT6gr44AZGQrYD02gZyOWW4+ToUfKJjFfwnpHkHlLw5/ApbC0cGmAqm2U+fezMDPLNo
         LIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=blNElsH0nKttFL9QJoixbJLS8nXkItulDEFRWhW74QE=;
        b=ar2KTKpS5lUyGI+sFGDl16V6BEJ4gifLWB0vnO1TjWnd+1y4FXwOajAcUFiEOW5kNH
         F4baNjms3qwKH/E5Ef4/CJhSpXHTv4+8gQigCjD1NTp0zxbLlj2Y7+CiTPlfryvfAT89
         Kn79zBFcr9XqCzPNiHlyh4cSRSpEmk+q+viS4OLGu1UdHdfXxD4yRm5Pp+wWZTpBbzN7
         W6fiKcPoeMnahLcJK0xDa1LNxlWxVKSTNfQEnwsiz2aq47HbtTwzQjCth//vVDnYuHA+
         Gh5TZ5fTl7RxtCMzXtinvtCLLVqa6uy0ofeQmIvvW5azjqStvLuVQqDVT8usitEAeM8l
         7w9w==
X-Gm-Message-State: APjAAAVzEZsdnjaft2Q09ZhpwxI+gklg5C7H+HE2WTXNVQfNhTuUsl91
        N+v3xBIkKVc62ySKXcSsw9SevTc1
X-Google-Smtp-Source: APXvYqwx5lY4yehBvaJR87touvpWL3gGnZZIs3rkLKtG/F0uTYH/UFddbzfgekT9XJ3LZ906o83nVw==
X-Received: by 2002:a62:6b44:: with SMTP id g65mr33565472pfc.27.1557151286818;
        Mon, 06 May 2019 07:01:26 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id v1sm14526926pff.81.2019.05.06.07.01.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 07:01:25 -0700 (PDT)
Date:   Mon, 6 May 2019 07:01:23 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next] macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to real device
Message-ID: <20190506140123.k2kw7apaubvljsa5@localhost>
References: <20190417061452.GA18865@dhcp-12-139.nay.redhat.com>
 <20190417154306.om6rjkxq4hikhsht@localhost>
 <20190417205958.6508bda2@redhat.com>
 <20190418033157.irs25halxnemh65y@localhost>
 <20190418080509.GD5984@localhost>
 <20190423041817.GE18865@dhcp-12-139.nay.redhat.com>
 <20190423083141.GA5188@localhost>
 <20190423091543.GF18865@dhcp-12-139.nay.redhat.com>
 <20190423093213.GA7246@localhost>
 <20190425134006.GG18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425134006.GG18865@dhcp-12-139.nay.redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 25, 2019 at 09:40:06PM +0800, Hangbin Liu wrote:
> Would you please help have a look at it and see which way we should use?
> Drop SIOCSHWTSTAMP in container or add a filter on macvlan(maybe only in
> container)?

I vote for dropping SIOCSHWTSTAMP altogether.  Why?  Because the
filter idea means that the ioctl will magically succeed or fail, based
on the unknowable state of the container's host.  It is better IMHO to
let the admin of the host set up HWTSTAMP globally (like with
hwtstamp_ctl for example) and configure the apps appropriately (like
with ptp4l --hwts_filter=check).

(BTW the patch has issues, but I'll let the advocates of the filter
idea do the review ;)

Thanks,
Richard
