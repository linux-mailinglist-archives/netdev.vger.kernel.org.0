Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C8B1E54EA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 06:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgE1EME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 00:12:04 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:21348 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgE1EME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 00:12:04 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2020 00:12:03 EDT
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DE7EE41EFD;
        Thu, 28 May 2020 12:02:48 +0800 (CST)
Subject: The size of ct offoad mlx5_flow_table in mlx5e driver
From:   wenxu <wenxu@ucloud.cn>
To:     Paul Blakey <paulb@mellanox.com>, Roi Dayan <roid@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1585464960-6204-1-git-send-email-wenxu@ucloud.cn>
 <fd36f18360b2800b37fe6b7466b7361afd43718b.camel@mellanox.com>
 <d3e0a559-3a7b-0fd4-5d1f-ccb0aea1dffd@ucloud.cn>
Message-ID: <9f388f0a-d6fe-7abf-2413-255f9ae32d68@ucloud.cn>
Date:   Thu, 28 May 2020 12:02:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d3e0a559-3a7b-0fd4-5d1f-ccb0aea1dffd@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEhJS0tLSkhNSExOT0hZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw4MxhDGRQ1Q0IeDhUQFjocVlZVSkxKKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nwg6LTo4Sjg*NzhKUTMfCFZL
        FRwwCxhVSlVKTkJLTUhDTk1CSkpCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJTENLNwY+
X-HM-Tid: 0a725972664a2086kuqyde7ee41efd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi  Paul,


I have a question about the size of ct and ct nat flow table.


There are two global mlx5_flow_table tables ct and ct_nat for act_ct offload.


The ct and ct_nat flow table create through mlx5_esw_chains_create_global_table

and get the size through mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);


Firmware currently has 4 pool of 4 sizes that it supports (ESW_POOLS),

and a virtual memory region of 16M (ESW_SIZE).  It allocates up to 16M of each pool.


ESW_POOLS[] = { 4 * 1024 * 1024,
                             1 * 1024 * 1024,
                             64 * 1024,
                             128 };

So it means the biggest flow table size is 4M. The ct and ct_nat flowtable create in advance,

The size of ct and ct_nat is 4M.

It means there are almost 4M conntrack entry offload to the hardware?

The flow table map is fixed in the FW? And the size can be changed to 8M through the following？

ESW_POOLS[] = { 8 * 1024 * 1024,
                             1 * 1024 * 1024,
                             64 * 1024,
                             128 };


BR

wenxu









