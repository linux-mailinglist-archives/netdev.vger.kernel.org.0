Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5453A668A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhFNMac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:30:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35490 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233076AbhFNMab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=CmesnGB1RYN0/FHBpWhdJza1phU33QfIwJiYsy3F/Y4=; b=QG
        /A1mYNR2BMYXkQfcRIFKIKObv2qOeYHHDkHqjmttirrSCM0Tpk8cPmtCtFxs33yV4DZhMh+S2mmX7
        7iVVTrnpObXFuVycQootzOQ1jbUR42UWR4QmvpYbe3JseSR+IvqylkyPvT1xJMg89y+4pkwL0XnOX
        1x3Ck81gsP60xb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lslhT-009JpL-3e; Mon, 14 Jun 2021 14:28:19 +0200
Date:   Mon, 14 Jun 2021 14:28:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "lipeng (Y)" <lipeng321@huawei.com>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, xie.he.0141@gmail.com, ms@dev.tdt.de,
        willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/11] net: z85230: remove redundant
 initialization for statics
Message-ID: <YMdLYzr4QjrQIe0o@lunn.ch>
References: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
 <1623569903-47930-5-git-send-email-huangguangbin2@huawei.com>
 <YMYw4kJ/Erq6fbVh@lunn.ch>
 <3b15d3bd-4116-ebed-ba86-13efbe7958f4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b15d3bd-4116-ebed-ba86-13efbe7958f4@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 06:16:12PM +0800, lipeng (Y) wrote:
> 
> 在 2021/6/14 0:22, Andrew Lunn 写道:
> 
>     On Sun, Jun 13, 2021 at 03:38:16PM +0800, Guangbin Huang wrote:
> 
>         From: Peng Li <lipeng321@huawei.com>
> 
>         Should not initialise statics to 0.
> 
>         Signed-off-by: Peng Li <lipeng321@huawei.com>
>         Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>         ---
>          drivers/net/wan/z85230.c | 2 +-
>          1 file changed, 1 insertion(+), 1 deletion(-)
> 
>         diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
>         index 94ed9a2..f815bb5 100644
>         --- a/drivers/net/wan/z85230.c
>         +++ b/drivers/net/wan/z85230.c
>         @@ -685,7 +685,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
>          {
>                 struct z8530_dev *dev=dev_id;
>                 u8 intr;
>         -       static volatile int locker=0;
>         +       static int locker;
> 
>     Is the volatile unneeded? Please document that in the commit message.
> 
>        Andrew
>     .
> 
> Hi,  Andrew:
> 
> When i create this patch, it will WARNING: Use of volatile is usually wrong:
> see Documentation/process/volatile-considered-harmful.rst
> 
> According to the file in kernel:    Documentation/process/volatile-considered-​
> harmful.rst
> 
> the "volatile" type class should not be used.
> 
> So i remove  "volatile" in this patch.

Please be very careful to explain exactly why it is wrong, in this
specific case.  You could also consider adding another patch which
replaces the volatile with what is recommended.

       Andrew
