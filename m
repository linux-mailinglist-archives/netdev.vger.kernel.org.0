Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B9120BD25
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgFZXbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFZXbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:31:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480A8C03E979;
        Fri, 26 Jun 2020 16:31:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A42331275891F;
        Fri, 26 Jun 2020 16:31:01 -0700 (PDT)
Date:   Fri, 26 Jun 2020 16:31:00 -0700 (PDT)
Message-Id: <20200626.163100.603726050168307590.davem@davemloft.net>
To:     rao.shoaib@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        ka-cheong.poon@oracle.com, david.edmondson@oracle.com
Subject: Re: [PATCH v1] rds: If one path needs re-connection, check all and
 re-connect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626183438.20188-1-rao.shoaib@oracle.com>
References: <20200626183438.20188-1-rao.shoaib@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 16:31:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rao.shoaib@oracle.com
Date: Fri, 26 Jun 2020 11:34:38 -0700

> +/* Check connectivity of all paths
> + */
> +void rds_check_all_paths(struct rds_connection *conn)
> +{
> +	int i = 0;
> +
> +	do {
> +		rds_conn_path_connect_if_down(&conn->c_path[i]);
> +	} while (++i < conn->c_npaths);
> +}

Please code this loop in a more canonial way:

	int i;

	for (i = 0; i < conn->c_npaths, i++)
		rds_conn_path_connect_if_down(&conn->c_path[i]);

Thank you.
