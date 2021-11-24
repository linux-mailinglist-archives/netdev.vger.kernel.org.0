Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F29745B464
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 07:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbhKXGmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 01:42:09 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:56228 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhKXGmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 01:42:09 -0500
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id BB74320181;
        Wed, 24 Nov 2021 14:38:57 +0800 (AWST)
Message-ID: <e97b2d3ee72ba8eec5fbae81ce0757806bf25d69.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next 1/3] mctp: serial: cancel tx work on ldisc close
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Jiri Slaby <jirislaby@kernel.org>, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 24 Nov 2021 14:38:57 +0800
In-Reply-To: <b3307219-db82-d519-63df-dc246e11b037@kernel.org>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
         <20211123125042.2564114-2-jk@codeconstruct.com.au>
         <b3307219-db82-d519-63df-dc246e11b037@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

> > +       cancel_work_sync(&dev->tx_work);
> 
> But the work still can be queued after the cancel (and before the 
> unregister), right?

Yes. Yes it can.

I should be cancelling after the unregister, not before, so this'll need
a v2.

On the ldisc side: is there any case where we'd get a write wakeup
during (or after) the ->close()?

Cheers,


Jeremy
