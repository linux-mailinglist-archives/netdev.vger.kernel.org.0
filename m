Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259361E2A1B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgEZScK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgEZScJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:32:09 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 298452068D;
        Tue, 26 May 2020 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590517929;
        bh=f7HsF7gIxwekjNNzLV9W5uWS5vyCr42uPVuFWrSmonk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PycT5/ibnoGjtX+bhdtlmgWZDx/F7AJ0Qkd1G1egnXEQjKPpJC1JAIWT5KiTXxSnQ
         Jkr7CLeWAY5rxVtiBc4MFjs5IJ5kp4EcEvEP7/0sVvGu84L7blDOI6grpNwsXrHlKb
         UE7T6sBYY937DFcS2BVKi8jtzBJEGjgKK8GeHTwM=
Date:   Tue, 26 May 2020 11:32:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        jhs@mojatatu.com, jiri@mellanox.com, idosch@mellanox.com
Subject: Re: [RFC PATCH net-next 2/3] net: sched: sch_red: Split init and
 change callbacks
Message-ID: <20200526113207.31d1bec6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <b761925f786dc812c75e4d0e71c288909248216f.1590512901.git.petrm@mellanox.com>
References: <cover.1590512901.git.petrm@mellanox.com>
        <b761925f786dc812c75e4d0e71c288909248216f.1590512901.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 20:10:06 +0300 Petr Machata wrote:
> +static int red_change(struct Qdisc *sch, struct nlattr *opt,
> +		      struct netlink_ext_ack *extack)
> +{
> +	struct red_sched_data *q = qdisc_priv(sch);

net/sched/sch_red.c: In function red_change:
net/sched/sch_red.c:337:25: warning: unused variable q [-Wunused-variable]
  337 |  struct red_sched_data *q = qdisc_priv(sch);
      |                         ^

Needs to go to the next patch.

> +	struct nlattr *tb[TCA_RED_MAX + 1];
> +	int err;
> +
> +	if (!opt)
> +		return -EINVAL;
> +
> +	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
> +					  extack);
> +	if (err < 0)
> +		return err;
> +
> +	return __red_change(sch, tb, extack);
>  }
