Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40532256045
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 20:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgH1SHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 14:07:50 -0400
Received: from correo.us.es ([193.147.175.20]:38484 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbgH1SHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 14:07:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2765D2A2BAE
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 20:07:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 19958DA704
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 20:07:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EECB9DA78D; Fri, 28 Aug 2020 20:07:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 668DFDA704;
        Fri, 28 Aug 2020 20:07:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 20:07:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3BCB542EF4E1;
        Fri, 28 Aug 2020 20:07:43 +0200 (CEST)
Date:   Fri, 28 Aug 2020 20:07:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix parsing error
Message-ID: <20200828180742.GA20488@salvia>
References: <20200815165030.5849-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200815165030.5849-1-ztong0001@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 12:50:30PM -0400, Tong Zhang wrote:
> ct_sip_parse_numerical_param can only return 0 or 1, but the caller is
> checking parsing error using < 0

Is this are real issue in your setup or probably some static analysis
tool is reporting?

You are right that ct_sip_parse_numerical_param() never returns < 0,
however, looking at:

https://tools.ietf.org/html/rfc3261 see Page 161

expires is optional, my understanding is that your patch is making
this option mandatory.
