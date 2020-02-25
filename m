Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B280716EE85
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgBYTAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:00:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48664 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbgBYTAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:00:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A63413B3AC16;
        Tue, 25 Feb 2020 11:00:34 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:00:33 -0800 (PST)
Message-Id: <20200225.110033.2078372349210559509.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        elder@linaro.org, m.chetan.kumar@intel.com, dcbw@redhat.com,
        bjorn.andersson@linaro.org, johannes.berg@intel.com
Subject: Re: [RFC] wwan: add a new WWAN subsystem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
References: <20200225100053.16385-1-johannes@sipsolutions.net>
        <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 11:00:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 25 Feb 2020 11:00:53 +0100

> +static struct wwan_device *wwan_create(struct device *dev)
> +{
> +	struct wwan_device *wwan = kzalloc(sizeof(*wwan), GFP_KERNEL);
> +	u32 id = ++wwan_id_counter;
> +	int err;
> +
> +	lockdep_assert_held(&wwan_mtx);
> +
> +	if (WARN_ON(!id))
> +		return ERR_PTR(-ENOSPC);

This potentially leaks 'wwan'.
