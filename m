Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCBB142E1
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 00:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfEEWce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 18:32:34 -0400
Received: from mail.us.es ([193.147.175.20]:50930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfEEWce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 18:32:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DB2611ED81
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 00:32:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78A94DA704
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 00:32:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6E5E2DA703; Mon,  6 May 2019 00:32:32 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E731DA704;
        Mon,  6 May 2019 00:32:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 00:32:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5C9044265A31;
        Mon,  6 May 2019 00:32:30 +0200 (CEST)
Date:   Mon, 6 May 2019 00:32:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
Message-ID: <20190505223229.3ujqpwmuefd3wh7b@salvia>
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503154007.32495-1-kristian.evensen@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 05:40:07PM +0200, Kristian Evensen wrote:
> Commit 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
> on flush") introduced a user-space regression when flushing connection
> track entries. Before this commit, the nfgen_family field was not used
> by the kernel and all entries were removed. Since this commit,
> nfgen_family is used to filter out entries that should not be removed.
> One example a broken tool is conntrack. conntrack always sets
> nfgen_family to AF_INET, so after 59c08c69c278 only IPv4 entries were
> removed with the -F parameter.
> 
> Pablo Neira Ayuso suggested using nfgenmsg->version to resolve the
> regression, and this commit implements his suggestion. nfgenmsg->version
> is so far set to zero, so it is well-suited to be used as a flag for
> selecting old or new flush behavior. If version is 0, nfgen_family is
> ignored and all entries are used. If user-space sets the version to one
> (or any other value than 0), then the new behavior is used. As version
> only can have two valid values, I chose not to add a new
> NFNETLINK_VERSION-constant.

Applied, thanks.
