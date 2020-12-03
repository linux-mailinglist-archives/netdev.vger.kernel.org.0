Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BB02CE00F
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbgLCUtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:49:42 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84B8C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 12:48:55 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id b2so3583318edm.3
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hS5lSqRfdfBiuqR1AoFE8ILAsW/qlUwXCf+O46EByAA=;
        b=t2f7Lg4Xd3p56Dwt3uybrCpw/LabgLH4siDUgzQhR5hejMHPU5mDJYps00TQ5Wnmiu
         kf8BiZjn+nAeYsdZbcMoXTSG3ayCPTApwH8AGXBqqiwE9GOo4Q6u1Bz7Jzzlf0gIHasC
         3IIbSjkVj0foHSgyQm8BuOSr3c66kuDGCOARf2aadHyTLlYruOSxenz3AoEZ6l7fSXxV
         YESUQonMDJ5sP+yu3QrNR8TaDZ5Pza+YpJXmMwQimmA0XJ6Ef31+Q8Fucg1S1uI4L0Yl
         DupR33HHgiGyXxQ8ksIYtCYZzm5KDSbx/2zO21JExQx82B3YSQy3En3YKlO6bIA9BaBN
         qlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hS5lSqRfdfBiuqR1AoFE8ILAsW/qlUwXCf+O46EByAA=;
        b=A9zUcx20EleXjL1QtiUfr1hJpBAaDMpgcAQ07Gzv857iQZbxDPQY8B9i5WjISYDWSE
         Uod+3dNg9DPqKlBKfxwCrQIFv0/L/p4s+95YHfgb8201LEeUQyxmqV5Bm7OFX0QaEdxc
         IvrvLlM3jGp6jQpuNIX2wwOaj6w/BQEcqet78wwtZbjPT8+Hv/MJnbiWr6K1mr8/nOVw
         2Czyy29xIzEwv2ZSgJ/SUiqnXtWiEk0wql28Z3/OFeBgb8NmjN1whmEqeR8n1pT7Y1uJ
         eSq+j3pbprKQOW+kuqRrmtdYanCcLEix6uc80qcbmuiiE8JY7JxMJ2jOhMLd9ylIHNb3
         98mg==
X-Gm-Message-State: AOAM531D21VJlymzH2DYDuNzvlpgH/uqc8pVFfBl4a4gRmGriM8M/VK+
        E18BriB73V9c+rOVEcLAct8=
X-Google-Smtp-Source: ABdhPJzcvn0x69wiyU5eyf3zqNlfVa+PTJ2yki1yEVpijL6C7012Rx5nUQe0OKukj3eThzTHxjI9wg==
X-Received: by 2002:aa7:c603:: with SMTP id h3mr4645747edq.254.1607028534377;
        Thu, 03 Dec 2020 12:48:54 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id e27sm1599979ejm.60.2020.12.03.12.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 12:48:53 -0800 (PST)
Date:   Thu, 3 Dec 2020 22:48:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201203204852.nvbs37m52cigs3oe@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202091356.24075-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 10:13:54AM +0100, Tobias Waldekranz wrote:
> +static int dsa_slave_check_lag_upper(struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct dsa_switch_tree *dst = dp->ds->dst;
> +
> +	if (!dsa_lag_offloading(dst))
> +		return NOTIFY_DONE;
> +
> +	if (dsa_lag_by_dev(dst, dev))
> +		return NOTIFY_OK;
> +
> +	if (!dsa_lag_available(dst))
> +		return notifier_from_errno(-EBUSY);

If for any reason there are no LAGs available in hardware, I think this
should still return NOTIFY_OK and we should not reject it, just not
offload it.

Which is to say that I basically don't understand the point of the
PRECHANGEUPPER checks.

> +
> +	return NOTIFY_OK;
> +}
