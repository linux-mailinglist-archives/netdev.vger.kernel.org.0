Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7171D3E3B41
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 18:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhHHQFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 12:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhHHQFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 12:05:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98143C061760;
        Sun,  8 Aug 2021 09:05:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a8001b029017700de3903so17051606pjn.1;
        Sun, 08 Aug 2021 09:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Du89aQgKZdsGf+sWEx87Fhx9ntqBcSvAio1IQ5nV5Kw=;
        b=YCPjiQssqj1+/fIwxKO9r0VHUJxXQgTBGdFbLqB8AUsz1Y2sKHwBHI/jYVN9RK9Xnk
         GghOK1qqjUUfTjKwwd86cmehmj8AxDxt2TmO/xDTitkfcZR8xJMa+VjBv3yK2GFHlm31
         DQ8FweiwpJo7g3s/ogH3YervMwbY39kLp6CvodvsSZ5pcjGB+pyWilH8lSC+ukZ74wGO
         KWnWTr6UQf/1iGTIoDet2kOMExfIzKW6GJzG0seAPsI3gp1XBtJZX604Llzj+/Mxo0f4
         dcnlYuPVUvhnQZlZrp1vGN/0GfzivL7OuoMCP2RNDZG8eNzNQvyq/mfYJSU5PzWVPTfg
         O8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Du89aQgKZdsGf+sWEx87Fhx9ntqBcSvAio1IQ5nV5Kw=;
        b=L2nzXg3Afx5Y9KaB+GIJ4ZLdIh1oyGb3jwYZ6MximziqfR0tUn1eBwhgSfVPezciKP
         qRdrFv68oqVbTmRZhyTM7adlp7NfkNOr27RluzJ7kWsZsH4uJ3ffHOWskL9FSL9EFy8K
         MtKjU5wDKSWRB435N8ptR9D/nzNB20qxrLKB2WBUhSNIiVOCVcMIQWumcJp9BcL5DVAb
         yIKaaoRAi0YvzXwDqJKchQnXftf0r4C04WOkqhy13lwTn6aTCir7tNpeaY6qWyYHolKB
         ikRwEZqLwTao+AkAGxXkj4sQoSgnwtV/vKyCqjrFc8sr7bEavUxUxEC80ffmx6UZCl4f
         6iJA==
X-Gm-Message-State: AOAM532naYPPCWvJS871tFGljtyVCc8yfc9jGDJrP6y5rxOZFxSSqyKl
        940vsnvt3tgpCgQtRBa3PFE=
X-Google-Smtp-Source: ABdhPJxKr0EJyFEAtze/6AJOQonXdnPx4XCIxEBZcnGzmhgP8yeHyMyvFgot4h5xBoVq7fs6I09+EQ==
X-Received: by 2002:a65:6088:: with SMTP id t8mr326413pgu.371.1628438715034;
        Sun, 08 Aug 2021 09:05:15 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id c4sm16623042pfd.102.2021.08.08.09.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 09:05:14 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        =?iso-8859-1?Q?Andr=E9?= Valentin <avalentin@marcant.net>
Subject: Re: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on CPU port
Date:   Mon,  9 Aug 2021 00:05:03 +0800
Message-Id: <20210808160503.227880-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210807222555.y6r7qxhdyy6d3esx@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com> <20210807120726.1063225-3-dqfext@gmail.com> <20210807222555.y6r7qxhdyy6d3esx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 01:25:55AM +0300, Vladimir Oltean wrote:
> On Sat, Aug 07, 2021 at 08:07:25PM +0800, DENG Qingfang wrote:
> > Enable assisted learning on CPU port to fix roaming issues.
> 
> 'roaming issues' implies to me it suffered from blindness to MAC
> addresses learned on foreign interfaces, which appears to not be true
> since your previous patch removes hardware learning on the CPU port
> (=> hardware learning on the CPU port was supported, so there were no
> roaming issues)

The datasheet says learning is enabled by default, but if that's true,
the driver won't have to enable it manually.

Others have reported roaming issues as well:
https://github.com/Ansuel/openwrt/pull/3

As I don't have the hardware to test, I don't know what the default
value really is, so I just disable learning to make sure.

> 
> > 
> > Although hardware learning is available, it won't work well with
> > software bridging fallback or multiple CPU ports.
> 
> This part is potentially true however, but it would need proof. I am not
> familiar enough with the qca8k driver to say for sure that it suffers
> from the typical problem with bridging with software LAG uppers (no FDB
> isolation for standalone ports => attempt to shortcircuit the forwarding
> through the CPU port and go directly towards the bridged port, which
> would result in drops), and I also can't say anything about its support
> for multiple CPU ports.

QCA8337 supports disabling learning and FDB lookup on a per-VLAN basis,
so we could assign all standalone ports to a reserved VLAN (ID 0 or 4095)
with learning and FDB lookup disabled.

Ansuel has a patch set for multiple CPU ports.
