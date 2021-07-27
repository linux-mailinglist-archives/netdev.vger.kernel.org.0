Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593263D832A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 00:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhG0WlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 18:41:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232336AbhG0WlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 18:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pmcqorDtNtoD1g0ufe4Uy6O//KZkJ4mkvGlwp8H6qmc=; b=a7GbZNXpXwi2yZ6GNzX5yM+bX2
        SIE2L8vR3kJDTO2xUad3wLZMXQOwFFHPKgCsIBRWHS8lTmQOcnFGOD8sW12X1YebHS94hwihdmdbZ
        qE4f0SJ38dA2WT2adbX78YXuv4DyqGu5wcHjkq3BRuGz/Q9/zNKVGzRx2kouAtHDb45c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8Vl5-00F5hR-4C; Wed, 28 Jul 2021 00:41:07 +0200
Date:   Wed, 28 Jul 2021 00:41:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] tsnep: Add TSN endpoint Ethernet MAC driver
Message-ID: <YQCLg3iLubJW+3yB@lunn.ch>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-5-gerhard@engleder-embedded.com>
 <YP8pM+qD/AfuSCcU@lunn.ch>
 <CANr-f5y7eVbAf_NK3puJa3AcnkLXMbhzfwwmZ+r2KuWMbDhhsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5y7eVbAf_NK3puJa3AcnkLXMbhzfwwmZ+r2KuWMbDhhsA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I also expect some discussion about this feature. Mapping device specific
> TX/RX queues to user space is not done in mainline Linux so far.

That is probably not quite true. I expect GPUs do it, or at least
something very similar.

> I will follow your suggestion and drop tsnep_stream.c for the moment.
> Any early comments about this feature are welcome, because the direct
> use of additional TX/RX queues for real-time communication is the main
> feature of this device.

I know enough to know i don't know enough about cache management from
user space to be able to make any sensible recommendations.

You probably want to start a discussion with the XDP people and get
them to agree XDP does not work for your use case. Also, the people
who implemented zero-copy, MSG_ZEROCOPY and make sure that is also
unsuitable. Then see if you can reuse some GPU code which has been
well reviewed and tested. You will get less pushback that way,
compared to your own code which will need a good review by somebody
who understands all the issues.

    Andrew
