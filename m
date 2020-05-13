Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E751D0433
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbgEMBNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbgEMBNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:13:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A57C061A0C;
        Tue, 12 May 2020 18:13:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FD151287B5DC;
        Tue, 12 May 2020 18:13:45 -0700 (PDT)
Date:   Tue, 12 May 2020 18:13:42 -0700 (PDT)
Message-Id: <20200512.181342.2250607825098375089.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-security-module@vger.kernel.org, paul@paul-moore.com,
        ppandit@redhat.com, matthew.sheets@gd-ms.com
Subject: Re: [PATCH net] netlabel: cope with NULL catmap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <07d99ae197bfdb2964931201db67b6cd0b38db5b.1589276729.git.pabeni@redhat.com>
References: <07d99ae197bfdb2964931201db67b6cd0b38db5b.1589276729.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 18:13:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 12 May 2020 14:43:14 +0200

> The cipso and calipso code can set the MLS_CAT attribute on
> successful parsing, even if the corresponding catmap has
> not been allocated, as per current configuration and external
> input.
> 
> Later, selinux code tries to access the catmap if the MLS_CAT flag
> is present via netlbl_catmap_getlong(). That may cause null ptr
> dereference while processing incoming network traffic.
> 
> Address the issue setting the MLS_CAT flag only if the catmap is
> really allocated. Additionally let netlbl_catmap_getlong() cope
> with NULL catmap.
> 
> Reported-by: Matthew Sheets <matthew.sheets@gd-ms.com>
> Fixes: 4b8feff251da ("netlabel: fix the horribly broken catmap functions")
> Fixes: ceba1832b1b2 ("calipso: Set the calipso socket label to match the secattr.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable, thanks.
