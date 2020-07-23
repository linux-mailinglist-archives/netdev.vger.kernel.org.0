Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B222B66F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgGWTIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgGWTIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:08:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D40C0619DC;
        Thu, 23 Jul 2020 12:08:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C215513B3DA09;
        Thu, 23 Jul 2020 11:52:08 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:08:52 -0700 (PDT)
Message-Id: <20200723.120852.1882569285026023193.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
Subject: Re: [PATCH net-next v3 1/2] hinic: add support to handle hw
 abnormal event
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723144038.10430-2-luobin9@huawei.com>
References: <20200723144038.10430-1-luobin9@huawei.com>
        <20200723144038.10430-2-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 11:52:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Thu, 23 Jul 2020 22:40:37 +0800

> +static int hinic_fw_reporter_dump(struct devlink_health_reporter *reporter,
> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct hinic_mgmt_watchdog_info *watchdog_info;
> +	int err;
> +
> +	if (priv_ctx) {
> +		watchdog_info = priv_ctx;
> +		err = mgmt_watchdog_report_show(fmsg, watchdog_info);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}

This 'watchdog_info' variable is completely unnecessary, just pass
'priv_ctx' as-is into mgmt_watchdog_report_show().
