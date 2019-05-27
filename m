Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075DD2B98D
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 19:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfE0RvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 13:51:24 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3928 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfE0RvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 13:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hhLJjZyrWxWbv2nHbTpcVuYfjsiR3xD3ZYf3qZ2XmP4=; b=eSzYuqkA7M7cWqOWs3ePcE2d3a
        K7ryWpptHEvgUDRjXOU5beGD2oRSmjDI+a3bez7GVypKC8dcGKkAxzHT7QseMRoBq/xQCQx9x8g3o
        iHAcHGgunG/8RcxFPxx8lNxFcOc7Ogku6YM5GsS286b+A0zwvTC/n8Yc3eVGWu892SHo=;
Received: from [fd06:8443:81a1:74b0::212] (port=3580 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hVJmN-0002m9-Iv; Mon, 27 May 2019 19:51:23 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hVJlj-0000sD-Nb; Mon, 27 May 2019 19:50:43 +0200
Message-ID: <b45afe989054df3a087ea5f21b7b9a62c97fd5bd.camel@domdv.de>
Subject: Re: [RESEND][PATCH] Fix MACsec kernel panics, oopses and bugs
From:   Andreas Steinmetz <ast@domdv.de>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Date:   Mon, 27 May 2019 19:50:58 +0200
In-Reply-To: <20190523.091106.645519899189717299.davem@davemloft.net>
References: <32eb738a0a0f3ed5880911e4ac4ceedca76e3f52.camel@domdv.de>
         <20190523.091106.645519899189717299.davem@davemloft.net>
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch will be worked over and split. I'll need to investigate one more
problem. Split patch will be resent when ready.

On Thu, 2019-05-23 at 09:11 -0700, David Miller wrote:
> From: Andreas Steinmetz <ast@domdv.de>
> Date: Thu, 23 May 2019 09:46:15 +0200
> 
> > MACsec causes oopses followed by a kernel panic when attached directly or indirectly to
> a bridge. It causes erroneous
> > checksum messages when attached to vxlan. When I did investigate I did find skb leaks,
> apparent skb mis-handling and
> > superfluous code. The attached patch fixes all MACsec misbehaviour I could find. As I
> am no kernel developer somebody
> > with sufficient kernel network knowledge should verify and correct the patch where
> necessary.
> > 
> > Signed-off-by: Andreas Steinmetz <ast@domdv.de>
> 
> Subject lines should be of the form:
> 
> [PATCH $DST_TREE] $subsystem_prefix: Description.
> 
> Where $DST_TREE here would be "net" and $subsystem_prefix would be "macsec".
> 
> > +     /* FIXME: any better way to prevent calls to netdev_rx_csum_fault? */
> > +     skb->csum_complete_sw = 1;
> 
> Create a helper for this in linux/skbuff.h with very clear and clean comments
> explaining what is going on.

