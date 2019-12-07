Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68345115AF8
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 05:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfLGEqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 23:46:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGEqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 23:46:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BC521537CAF2;
        Fri,  6 Dec 2019 20:46:18 -0800 (PST)
Date:   Fri, 06 Dec 2019 20:46:17 -0800 (PST)
Message-Id: <20191206.204617.258963174428895178.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net 0/2] Ensure egress un/bind are relayed with
 indirect blocks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575565415-22942-1-git-send-email-john.hurley@netronome.com>
References: <1575565415-22942-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 20:46:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Thu,  5 Dec 2019 17:03:33 +0000

> On register and unregister for indirect blocks, a command is called that
> sends a bind/unbind event to the registering driver. This command assumes
> that the bind to indirect block will be on ingress. However, drivers such
> as NFP have allowed binding to clsact qdiscs as well as ingress qdiscs
> from mainline Linux 5.2. A clsact qdisc binds to an ingress and an egress
> block.
> 
> Rather than assuming that an indirect bind is always ingress, modify the
> function names to remove the ingress tag (patch 1). In cls_api, which is
> used by NFP to offload TC flower, generate bind/unbind message for both
> ingress and egress blocks on the event of indirectly
> registering/unregistering from that block. Doing so mimics the behaviour
> of both ingress and clsact qdiscs on initialise and destroy.
> 
> This now ensures that drivers such as NFP receive the correct binder type
> for the indirect block registration.

Series applied and queued up for -stable.
