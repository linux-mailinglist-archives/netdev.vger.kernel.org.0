Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CF1123FFE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLRHD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:03:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRHD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:03:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E3AD15039438;
        Tue, 17 Dec 2019 23:03:56 -0800 (PST)
Date:   Tue, 17 Dec 2019 23:03:55 -0800 (PST)
Message-Id: <20191217.230355.1103471479325489165.davem@davemloft.net>
To:     pdurrant@amazon.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org
Subject: Re: [PATCH net-next 2/3] xen-netback: switch state to InitWait at
 the end of netback_probe()...
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217133218.27085-3-pdurrant@amazon.com>
References: <20191217133218.27085-1-pdurrant@amazon.com>
        <20191217133218.27085-3-pdurrant@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 23:03:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>
Date: Tue, 17 Dec 2019 13:32:17 +0000

> ...as the comment above the function states.
> 
> The switch to Initialising at the start of the function is somewhat bogus
> as the toolstack will have set that initial state anyway. To behave
> correctly, a backend should switch to InitWait once it has set up all
> xenstore values that may be required by a initialising frontend. This
> patch calls backend_switch_state() to make the transition at the
> appropriate point.
> 
> NOTE: backend_switch_state() ignores errors from xenbus_switch_state()
>       and so this patch removes an error path from netback_probe(). This
>       means a failure to change state at this stage (in the absence of
>       other failures) will leave the device instantiated. This is highly
>       unlikley to happen as a failure to change state would indicate a
>       failure to write to xenstore, and that will trigger other error
>       paths. Also, a 'stuck' device can still be cleaned up using 'unbind'
>       in any case.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>

Applied.
