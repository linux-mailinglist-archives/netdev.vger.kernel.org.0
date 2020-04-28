Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543A81BB285
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgD1AF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:05:29 -0400
Received: from correo.us.es ([193.147.175.20]:59032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgD1AF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 20:05:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB9CEE16F1
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:05:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD999BAABD
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:05:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2FF9BAAAF; Tue, 28 Apr 2020 02:05:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0C3EBAC2F;
        Tue, 28 Apr 2020 02:05:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 02:05:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B0D9042EF9E0;
        Tue, 28 Apr 2020 02:05:25 +0200 (CEST)
Date:   Tue, 28 Apr 2020 02:05:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] iptables: flush stdout after every verbose log.
Message-ID: <20200428000525.GD24002@salvia>
References: <20200421081542.108296-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200421081542.108296-1-zenczykowski@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:15:42AM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Ensures that each logged line is flushed to stdout after it's
> written, and not held in any buffer.
> 
> Places to modify found via:
>   git grep -C5 'fputs[(]buffer, stdout[)];'
> 
> On Android iptables-restore -v is run as netd daemon's child process
> and fed actions via pipe.  '#PING' is used to verify the child
> is still responsive, and thus needs to be unbuffered.
> 
> Luckily if you're running iptables-restore in verbose mode you
> probably either don't care about performance or - like Android
> - actually need this.

Could you check if this slows down iptables-restore?

Thank you.
