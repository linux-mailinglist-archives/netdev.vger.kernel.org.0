Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A1474B66
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390018AbfGYKUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 06:20:53 -0400
Received: from mail.us.es ([193.147.175.20]:49924 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389537AbfGYKUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 06:20:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB8FBFB6C7
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 12:20:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDA30DA708
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 12:20:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D339F115110; Thu, 25 Jul 2019 12:20:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC962115109;
        Thu, 25 Jul 2019 12:20:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 12:20:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6E6694265A31;
        Thu, 25 Jul 2019 12:20:48 +0200 (CEST)
Date:   Thu, 25 Jul 2019 12:20:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190725102045.xrs327ksgkyzzl5h@salvia>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 05:55:31PM +0800, wenxu@ucloud.cn wrote:
> +struct flow_indr_block_dev {
> +	struct rhash_head ht_node;
> +	struct net_device *dev;
> +	unsigned int refcnt;
> +	struct list_head cb_list;
> +	flow_indr_block_ing_cmd_t *cmd_cb;
> +	void *block;

There's now a flow_block object in order to avoid void * which is
prone to bugs later on since the compiler cannot make type validation
anymore.
