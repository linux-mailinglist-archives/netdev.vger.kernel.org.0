Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98360215E5B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgGFScS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgGFScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:32:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4926FC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:32:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q17so17300747pfu.8
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GrX+V4MpE6PWPi/82Y3YiEWhym0Z3uGDlKAfxIvrSG4=;
        b=ISINL683XZKvUoHdyl79/ptwsl9xvXPRIm7/YG5jJS6Drh75qsEBDoQoTuvcLLd7Sq
         8EdzrDIBQx0DvkNsR68c9/IjAS0RO4h27VI6RD64XmljtAF4Dxoz3srT5tIlE3JEzTXN
         sqaKJNlpgevnuz1qgOzy76Tw998VRXN2akj7cBA791z4M549cXsds2CKhLw6uwCAE4zl
         oz8lke+kC3y4TvftQTyzYp6aqcAXCBJaOxm1ZDmVe6HSgn/ka4165IWNxjX/CNjgcTxB
         0QkTTJLm1iN+EnCwuei0ivnNEixoOeuhO1hykknHJEB5bYlvTpG7QnQupVwOfiXsKy0o
         nLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GrX+V4MpE6PWPi/82Y3YiEWhym0Z3uGDlKAfxIvrSG4=;
        b=R+MY4fEK7Spwf83MPNRWpt5E4bQvPXT/NR8yfHisSC4um2xkRbl/7nDkqC9w//o47+
         1Fu9NYQjTNFnbpvqQ6kD36Q7Oj9LK6ZgCZFNpxRJGORwBkZLAaLHfdvDGTqPVKKLU4ca
         sLaibr3oNWkwH6IVS+p0qN78QPUw1X8xfYG5yKeveVvhU+uXgN5THRj1FyoEWVVFECrW
         pciBp5oAGKHarZAk+5TtVuoFxYTlq8Q0XzbVSQJxx/Y5QYZ54whhVwUOJZYlrwd1dbof
         wmW3XJGnUhfDsaDxOqbPPJaPQkcOteS8JWe28cWveP+4E0wf5WzF3a+NN7HYvckVfxT0
         AXYQ==
X-Gm-Message-State: AOAM5315spgDihZYp9iEXmO1dqfx4bZsN+0c9YbaXWlP32voGjBRxKzz
        1JZnLBZhjbJT9CrU/VfqqJQgGbjA10c=
X-Google-Smtp-Source: ABdhPJxA0uvOB2jmx2FuiUl2SbzQbSp/L++LiSyR85iCpNYzNRe3LfgnKBNbah3zTAGqn/GTjwdjKQ==
X-Received: by 2002:a62:6446:: with SMTP id y67mr39423849pfb.299.1594060337856;
        Mon, 06 Jul 2020 11:32:17 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d37sm20527438pgd.18.2020.07.06.11.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:32:17 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:32:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
Message-ID: <20200706113208.672ce199@hermes.lan>
In-Reply-To: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jul 2020 02:08:13 +0800
"YU, Xiangning" <xiangning.yu@alibaba-inc.com> wrote:

> +static inline s64 get_linkspeed(struct net_device *dev)

This is not performance sensitive and should not be marked inline.


> +{
> +	struct ethtool_link_ksettings ecmd;
> +
> +	ASSERT_RTNL();
> +	if (netif_running(dev) && !__ethtool_get_link_ksettings(dev, &ecmd))
> +		/* Convert to bytes per second */
> +		return ecmd.base.speed * 1000 * 1000L / 8;

You need to be more careful in handling of devices that return unknown for speed.

> +	return 0;
> +}
> +
