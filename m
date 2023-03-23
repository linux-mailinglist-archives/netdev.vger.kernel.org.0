Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CA46C5B65
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 01:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCWAfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 20:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjCWAfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 20:35:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3C24ED5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 17:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mfcgFFnhlJ/XM9yirNJ4xFU9Q9qfVSgMoOnPPS8qprg=; b=Y4VUVp/PCj+rdVhl3qI2Mo+B4W
        A11abizg0qnDw4okOliVA5NCa/j0zbAbvg3SwinLGxsZe2WfK8K9qdcTXaWy/a49Aib8xApIUtmmS
        SJUCtn3/t+kGl1NrJnhIRZMpZnL6w0vu4fwsDyHyMS0ZphR9jEkFk4BBpPf9+0U0sfNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pf8vW-00891V-BO; Thu, 23 Mar 2023 01:35:34 +0100
Date:   Thu, 23 Mar 2023 01:35:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, alexander.duyck@gmail.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <06d6a33e-60d4-45ea-b928-d3691912b85e@lunn.ch>
References: <20230322233028.269410-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233028.269410-1-kuba@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 04:30:26PM -0700, Jakub Kicinski wrote:
> A lot of drivers follow the same scheme to stop / start queues
> without introducing locks between xmit and NAPI tx completions.
> I'm guessing they all copy'n'paste each other's code.
>
> Smaller drivers shy away from the scheme and introduce a lock
> which may cause deadlocks in netpoll.

Hi Jakub

I notice there is no patch 0/X. Seems like the above would be good
material for it, along with a comment that a few drivers are converted
to make use of the new macros.

   Andrew
