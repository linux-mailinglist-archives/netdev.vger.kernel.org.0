Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90C321E452
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgGNAJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGNAJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:09:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99DAC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:09:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30E491298136E;
        Mon, 13 Jul 2020 17:09:00 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:08:59 -0700 (PDT)
Message-Id: <20200713.170859.794084104671494668.davem@davemloft.net>
To:     george.kennedy@oracle.com
Cc:     kuba@kernel.org, dan.carpenter@oracle.com, dhaval.giani@oracle.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] ax88172a: fix ax88172a_unbind() failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594641537-1288-1-git-send-email-george.kennedy@oracle.com>
References: <1594641537-1288-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:09:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>
Date: Mon, 13 Jul 2020 07:58:57 -0400

> @@ -237,6 +237,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
>  
>  free:
>  	kfree(priv);
> +	if (ret >= 0)
> +		ret = -EIO;
>  	return ret;

Success paths reach here, so ">= 0" is not appropriate.  Maybe you
meant "> 0"?
