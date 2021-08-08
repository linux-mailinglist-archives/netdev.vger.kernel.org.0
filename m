Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1C73E3CDE
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 23:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhHHVOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 17:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhHHVOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 17:14:37 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1EFC061760;
        Sun,  8 Aug 2021 14:14:17 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f13so21497250edq.13;
        Sun, 08 Aug 2021 14:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4jBI5fwS+8PcqcFnWHTT4nTI4zqvMfHeyhnQQ2c+hc4=;
        b=V2Mx3EVNdOgB5oUMJEZpZGNuRL45Bt2CgsuyTZPescuYmeinTUEPbeo4ayGCSQhiKu
         EhJQbQ6jW2/4Ukxr20IxGtjqbLFGCdPmQt4m+6bWrEyuqVQqjKkK1ikarpHCg7sQ2TKC
         6j5UhXVBnNGQx3naZZkkBGNv+DAgwS4HnL7Hi9kFQC65x66oTBY9LkhVb3Re3h+iv26t
         LfhamzG8n5bvaGtLRMJed+gzv8u4fWzIoXzjYT37Ao4hJKGrwYcbV1h/I9cxHO/mp38Q
         lAUThEdNu+G9qy77VgK7KM9U8p9Bu/74XgQ79l4mDfUr8NRt8jUpnELFq3mB0teLhCSh
         WqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4jBI5fwS+8PcqcFnWHTT4nTI4zqvMfHeyhnQQ2c+hc4=;
        b=r8JmlBGcIg/G0Nm0Gy/J3QvQNoQKY4BWFc7UFWr3I1DUP6SqgHXUuR/ajGFVLes/1c
         oZiErAe5ruuDARHwAYTSXjhenTSEYvR5QtE3RPk5iyHE3sDb4ZqdekkzEkrGtZbKh4My
         9F6kDFQqRdxhbsrWe62ceX10eLmOlxJeMtd6U6U+JRv5hiroPs1iIEAYaMTO44Y5YLIy
         y2U5/Qpn/IToBAlpW/t3AA2BnyFC53f1z5bn+1Gv77eUIjWEpXsV6/KVgZ5vrksc1rSc
         YyCvJ1wnTkaTuecpae7y9kBi9IfdMhC1CiS+/dmzz0CpQoFu47N1dFccJxVJh1KDBFlK
         7LMw==
X-Gm-Message-State: AOAM531HYQolf801Oz34idz+lJQU5QtLdDY4yFZvKFptpmgPxYrhVIjZ
        gOUlc2VHL6cciiSlDrOnwf0=
X-Google-Smtp-Source: ABdhPJzokKec6876qc7sH9rHOWFh83ObCR0CU5Rnz0C7t90O42gKw1/ACD11OnbtczG4JBKYNGEb1A==
X-Received: by 2002:a05:6402:1a4c:: with SMTP id bf12mr25632909edb.137.1628457255713;
        Sun, 08 Aug 2021 14:14:15 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id t17sm1193073edw.13.2021.08.08.14.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 14:14:15 -0700 (PDT)
Date:   Mon, 9 Aug 2021 00:14:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?utf-8?B?QW5kcsOp?= Valentin <avalentin@marcant.net>
Subject: Re: [RFC net-next 3/3] net: dsa: tag_qca: set offload_fwd_mark
Message-ID: <20210808211413.33voutdjlz4qavzn@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-4-dqfext@gmail.com>
 <20210807225721.xk5q6osyqoqjmhmp@skbuf>
 <20210808161224.228001-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808161224.228001-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 12:12:24AM +0800, DENG Qingfang wrote:
> On Sun, Aug 08, 2021 at 01:57:21AM +0300, Vladimir Oltean wrote:
> > In this day and age, I consider this commit to be a bug fix, since the
> > software bridge, seeing an skb with offload_fwd_mark = false on an
> > offloaded port, will think it hasn't been forwarded and do that job
> > itself. So all broadcast and multicast traffic flooded to the CPU will
> > end up being transmitted with duplicates on the other bridge ports.
> > 
> > When the qca8k tagger was added in 2016 in commit cafdc45c949b
> > ("net-next: dsa: add Qualcomm tag RX/TX handler"), the offload_fwd_mark
> > framework was already there, but no DSA driver was using it - the first
> > commit I can find that uses offload_fwd_mark in DSA is f849772915e5
> > ("net: dsa: lan9303: lan9303_rcv set skb->offload_fwd_mark") in 2017,
> > and then quite a few more followed suit. But you could still blame
> > commit cafdc45c949b.
> 
> The driver currently only enables flooding to the CPU port (like MT7530
> back then), so offload_fwd_mark should NOT be set until bridge flags
> offload is supported.

Ok, I missed that. Please squash this with patch 1 then, please.
