Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB382EE8
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 11:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbfHFJmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 05:42:32 -0400
Received: from correo.us.es ([193.147.175.20]:42522 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732079AbfHFJmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 05:42:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BAB91F26F8
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 11:42:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD604A58B
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 11:42:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8DBEF1150DD; Tue,  6 Aug 2019 11:42:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C684DA704;
        Tue,  6 Aug 2019 11:42:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Aug 2019 11:42:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D63E84265A31;
        Tue,  6 Aug 2019 11:42:25 +0200 (CEST)
Date:   Tue, 6 Aug 2019 11:42:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190806094219.uwpjjsqkpf5rdi6d@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
 <20190801172014.314a9d01@cakuba.netronome.com>
 <20190802110023.udfcxowe3vmihduq@salvia>
 <20190802134738.328691b4@cakuba.netronome.com>
 <20190802220409.klwdkcvjgegz6hj2@salvia>
 <20190802152549.357784a7@cakuba.netronome.com>
 <20190803070854.zb3nvwj4ubx2mzy6@salvia>
 <20190805120439.40d70cee@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805120439.40d70cee@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 12:04:39PM -0700, Jakub Kicinski wrote:
> On Sat, 3 Aug 2019 09:08:54 +0200, Pablo Neira Ayuso wrote:
> > The idea is that every subsystem (ethtool, tc, nf) sets up/binds its
> > own flow_block object. And each flow_block object has its own priority
> > range space. So whatever priority the user specifies only applies to
> > the specific subsystem.
> 
> Right, okay so that part is pretty obvious but thanks for spelling it
> out. 
> 
> Are you also agreeing that priorities of blocks, not rules within 
> a block are dictated by the order of processing within the kernel?
> IOW TC blocks are _always_ before nft blocks?

yes.
