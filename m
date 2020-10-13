Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1BD28C66C
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgJMAhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 20:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbgJMAhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 20:37:11 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB808C0613D0;
        Mon, 12 Oct 2020 17:37:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c20so4790336pfr.8;
        Mon, 12 Oct 2020 17:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QguIN+MWkuVrUIVhlT/GAiMKd61MVStubKHegyevkY4=;
        b=D0WspYkOVRlf/Hh2i8c2GZGvwcGuLEh8tWt7/sei3VfZf1AYgafNswQFM17SofrqLn
         ssYcgESBEuHv6PEZY35YQnZoEWP87xauG7Jb7Rlo38BF3Gu9bJIoCCvyukfl8tqWvA7A
         UgnsYzdkIKn1aQbwuzroXgbd0BDwYHpgQMJYYnzAwtf2Al3zzoJ+VHh7ieZ8sjhwv1Nq
         bvLOWAWdECEm686SAqakuxQk2Pnd7E3mrVZXFidZ9k1jq/eOjIkuDGUXySuE7oX8Yl/X
         yPKGmR6n9tyD8wcFb+FbnTjJW+MhMcuRp720uJ/c0WDlWkHaa02doXiRR0E//F7f8djV
         CGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QguIN+MWkuVrUIVhlT/GAiMKd61MVStubKHegyevkY4=;
        b=kyPVD4JkOmGB2fnQL5I7rZ9FBXEeQhefcqNYq8PQmjRupWg07deArx/tOBOlGpS/80
         0RoaTjTD2ZwibH4CqX53V6sTVhnpqwE+sv2C3M9ahAk2czTdQyP/uN5+XzQfhXleCVrn
         23BUVcZ1e1KO3hlCv9pOva0p9lnSB4bjzzXlGqtfwpOkAs9JKFoa60v9ndToB658QOzq
         4pV3v6ZNynf6/7761NAEr5k1UgFr2y2FwUJv5wpr0qD5zsjuI7J4/RK+wEa9NYmpc6lk
         6vb/4uP1RNQRN+GOKWqRnfEfixT7vUMEvHJ0HyfanPM06bSnPFzNxKnyacpxRhZYn7lF
         gbJA==
X-Gm-Message-State: AOAM530RIW46ScLuERp1Qh0sMH76UHFv1FZb0RRE5HzPBE1Rbx8hk4mF
        MDUO/SsdFAyiaTzLPm50m5c=
X-Google-Smtp-Source: ABdhPJzO6K9MfpinQIt3Psy5lJo6ln90V8vgi1VhpKO7OswUKj8pPFqLpr+v0wP3nkPo2aN4UVpvkQ==
X-Received: by 2002:aa7:9358:0:b029:152:b349:8af8 with SMTP id 24-20020aa793580000b0290152b3498af8mr26858626pfn.9.1602549431129;
        Mon, 12 Oct 2020 17:37:11 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id b185sm20580852pgc.68.2020.10.12.17.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 17:37:09 -0700 (PDT)
Date:   Tue, 13 Oct 2020 09:37:04 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201013003704.GA41031@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201010073514.GA14495@f3>
 <20201010102416.hvbgx3mgyadmu6ui@Rk>
 <20201010134855.GB17351@f3>
 <20201012112406.6mxta2mapifkbeyw@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012112406.6mxta2mapifkbeyw@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-12 19:24 +0800, Coiby Xu wrote:
[...]
> > I think, but didn't check in depth, that in those drivers, the devlink
> > device is tied to the pci device and can exist independently of the
> > netdev, at least in principle.
> > 
> You are right. Take drivers/net/ethernet/mellanox/mlxsw as an example,
> devlink reload would first first unregister_netdev and then
> register_netdev but struct devlink stays put. But I have yet to
> understand when unregister/register_netdev is needed.

Maybe it can be useful to manually recover if the hardware or driver
gets in an erroneous state. I've used `modprobe -r qlge && modprobe
qlge` for the same in the past.

> Do we need to
> add "devlink reload" for qlge?

Not for this patchset. That would be a new feature.
