Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7721B2401
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgDUKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:40:18 -0400
Received: from correo.us.es ([193.147.175.20]:52576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDUKkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 06:40:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C97C6B6C82
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:40:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7FD4100799
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:40:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 947A4100788; Tue, 21 Apr 2020 12:40:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A45C0FC54C;
        Tue, 21 Apr 2020 12:40:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Apr 2020 12:40:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8568C42EF42D;
        Tue, 21 Apr 2020 12:40:14 +0200 (CEST)
Date:   Tue, 21 Apr 2020 12:40:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] libipt_ULOG.c - include strings.h for the definition of
 ffs()
Message-ID: <20200421104014.7xfnfphpavmy6yqg@salvia>
References: <20200421081507.108023-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200421081507.108023-1-zenczykowski@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:15:07AM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This resolves compiler warnings:
> 
> extensions/libext4_srcs/gen/gensrcs/external/iptables/extensions/libipt_ULOG.c:89:32: error: implicit declaration of function 'ffs' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>   printf(" --ulog-nlgroup %d", ffs(loginfo->nl_group));
>                                ^
> extensions/libext4_srcs/gen/gensrcs/external/iptables/extensions/libipt_ULOG.c:105:9: error: implicit declaration of function 'ffs' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>   ffs(loginfo->nl_group));
>   ^
> 
> Test: builds with less warnings

For the record, what compiler is triggering this? Or you use different
-W options there?

I don't see these with gcc 9.3 here.

> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  extensions/libipt_ULOG.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
> index fafb220b..5163eea3 100644
> --- a/extensions/libipt_ULOG.c
> +++ b/extensions/libipt_ULOG.c
> @@ -11,6 +11,7 @@
>   */
>  #include <stdio.h>
>  #include <string.h>
> +#include <strings.h>
>  #include <xtables.h>
>  /* For 64bit kernel / 32bit userspace */
>  #include <linux/netfilter_ipv4/ipt_ULOG.h>
> -- 
> 2.26.1.301.g55bc3eb7cb9-goog
> 
