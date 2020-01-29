Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8703B14CFBA
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgA2Rfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:35:30 -0500
Received: from correo.us.es ([193.147.175.20]:50960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbgA2Rfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 12:35:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8DA2F8D5A
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 18:35:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6317DA714
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 18:35:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CBED6DA70E; Wed, 29 Jan 2020 18:35:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCA2FDA702;
        Wed, 29 Jan 2020 18:35:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Jan 2020 18:35:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C081F42EFB80;
        Wed, 29 Jan 2020 18:35:26 +0100 (CET)
Date:   Wed, 29 Jan 2020 18:35:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     syzbot <syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 1/1] netfilter: ipset: fix suspicious RCU usage in
 find_set_and_id
Message-ID: <20200129173525.ikrw5bckxrgqc52v@salvia>
References: <alpine.DEB.2.20.2001252034050.23279@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.20.2001252034050.23279@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 08:39:25PM +0100, Kadlecsik József wrote:
> find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is held.
> However, in the error path there can be a follow-up recvmsg() without
> the mutex held. Use the start() function of struct netlink_dump_control
> instead of dump() to verify and report if the specified set does not
> exist.

Applied, thanks Jozsef.
