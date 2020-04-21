Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2B51B2D32
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 18:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgDUQyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 12:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725990AbgDUQyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 12:54:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1206C061A41;
        Tue, 21 Apr 2020 09:54:19 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jQwA4-00DZGc-W4; Tue, 21 Apr 2020 18:54:17 +0200
Message-ID: <0ccfa6d0e8b982c9c64ca3de913b0142c58317f1.camel@sipsolutions.net>
Subject: Re: how to use skb_postpush_rcsum()?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 21 Apr 2020 18:54:15 +0200
In-Reply-To: <a8b99311d732d2627d57beb3970fab9cdcd0e4d2.camel@sipsolutions.net> (sfid-20200421_172029_839677_910E826D)
References: <a8b99311d732d2627d57beb3970fab9cdcd0e4d2.camel@sipsolutions.net>
         (sfid-20200421_172029_839677_910E826D)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-04-21 at 17:20 +0200, Johannes Berg wrote:
> Hi,
> 
> This is probably a stupid question but I'm hitting my head against the
> wall ...
> 
> I have an skb. I have this:
> 
> 
>         if (skb->ip_summed == CHECKSUM_COMPLETE) {
>                 printk(KERN_DEBUG "csum before\n");
>                 printk(KERN_DEBUG "  hw = 0x%.4x\n", skb->csum);
>                 printk(KERN_DEBUG "  sw = 0x%.4x\n", csum_fold(skb_checksum(skb, 0, skb->len, 0)));

Never mind. The csum_fold() there is obviously the problem - that
shouldn't match, it should match the folded skb->csum. I have a missing
~ basically.

johannes

