Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6E34795F0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 22:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbhLQVCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 16:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbhLQVCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 16:02:06 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4284C06173E
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:02:06 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x1-20020a17090a2b0100b001b103e48cfaso4976897pjc.0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zb80lUtz8TIrMwIl8Mq7TS3TuTjpivrPThPX+10XdfI=;
        b=H7dQafYYV6AiiOtbuD+6XV6BxfKK9UXz1nH2YDo5PmPeXuQmIVNeFhyBMz7dXDSf8S
         ai2UWX8rWnkEKgnyzjbNnY3ttEWquajMdfZTnvHHG7ufmASztW7QpiLgDlQvbcZH4wyi
         bJX6+eJBgRRIUQPvAsDNYc0GA2eyEksOHVmQDv60AYcVRW4qdmZpyEIT3YN9rB/ehrwt
         zYQg7CYSSUegjuJyBpDGhbXPyaW7XpEmKIzHnzduT4xNfjjfTjlxygyICxLP3Q4UaoRd
         Rv9X3KYShDAsqEnpl2c+mFOkMD9gK4ILBrmk7NQXhSmBJXklc34vhpxJJmV2n/5Dya1J
         RCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zb80lUtz8TIrMwIl8Mq7TS3TuTjpivrPThPX+10XdfI=;
        b=ylBLarWA3ozKcj7jIUW4RC5u9Yu6bCRE9uZpx4xxcQCkdrcJaAFAgJal6EDnR57w4E
         4RSuKAgWmqyESd+/8sPOYMrkPltTcQU+p9V892ZflsffA4OxVi5hI2StBqatNqQZICGN
         fR8lB5ukGytmAkr+MrHBHMPhwyDNmVfSdN2hEY/6sWKLeMKWLmjwwXgCOPSBLqKXOAJx
         ynMaE0yX3J+OmTxCXiuI/HPyw04T9lZkkww6TB0Wtnp+kMLU2svkPvhtt0RtaCN72Fmy
         POBgJGFwVO1+N/wQYxw824runjhKJdccicrUnkSC89NbGHtmRL2Zpx1zk4oAvrj/rAzQ
         QXCg==
X-Gm-Message-State: AOAM533RQ8NgNOiIr8WB1DaU0h1TkfDi5cbhp7clb37AlHlz7Z0giw0u
        3DhVsFoh/O2jXgx5esIHAzJQoA==
X-Google-Smtp-Source: ABdhPJx3vvWuEHUqFG5EEydz2bNM2b6Br0aLcEErjqjr1tQXxas8MSJ7fFt0mGEBewXigJzS4qn1Ug==
X-Received: by 2002:a17:902:9a43:b0:148:9d8b:bead with SMTP id x3-20020a1709029a4300b001489d8bbeadmr4952878plv.76.1639774926165;
        Fri, 17 Dec 2021 13:02:06 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c7sm5314519pjs.17.2021.12.17.13.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 13:02:05 -0800 (PST)
Date:   Fri, 17 Dec 2021 13:02:03 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net: marvell: prestera: Register inetaddr
 stub notifiers
Message-ID: <20211217130203.537f6dc9@hermes.local>
In-Reply-To: <20211217195440.29838-6-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
        <20211217195440.29838-6-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Dec 2021 21:54:37 +0200
Yevhen Orlov <yevhen.orlov@plvision.eu> wrote:

> +
> +static int __prestera_inetaddr_valid_cb(struct notifier_block *nb,
> +					unsigned long event, void *ptr)
> +{
> +	struct in_validator_info *ivi = (struct in_validator_info *)ptr;
> +	struct net_device *dev = ivi->ivi_dev->dev;
> +	struct prestera_router *router = container_of(nb,
> +						      struct prestera_router,
> +						      inetaddr_valid_nb);
> +	struct in_device *idev;
> +	int err = 0;
> +
> +	if (event != NETDEV_UP)
> +		goto out;
> +
> +	/* Ignore if this is not first address */
> +	idev = __in_dev_get_rtnl(dev);
> +	if (idev && idev->ifa_list)
> +		goto out;
> +
> +	if (ipv4_is_multicast(ivi->ivi_addr)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	err = __prestera_inetaddr_event(router->sw, dev, event, ivi->extack);
> +out:
> +	return notifier_from_errno(err);
> +}

Your router is quite limited if it only can handle a single unicast address.
