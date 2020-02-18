Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14AF6162B19
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBRQxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:53:12 -0500
Received: from forward501p.mail.yandex.net ([77.88.28.111]:56282 "EHLO
        forward501p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbgBRQxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:53:11 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2020 11:53:09 EST
Received: from mxback24j.mail.yandex.net (mxback24j.mail.yandex.net [IPv6:2a02:6b8:0:1619::224])
        by forward501p.mail.yandex.net (Yandex) with ESMTP id 3BA2135003A6;
        Tue, 18 Feb 2020 19:46:13 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxback24j.mail.yandex.net (mxback/Yandex) with ESMTP id jpTSG45VG1-kC3qCLnv;
        Tue, 18 Feb 2020 19:46:13 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1582044373;
        bh=PwgYVVw1oIGB9Hl/0V4jKODFEu4KX9uNEZ/At5TbUK0=;
        h=Message-Id:Cc:Subject:In-Reply-To:Date:References:To:From;
        b=dXro3LdXqdGqFZXr18D8FzrefelZzfO3cKeAi2rlaoBzJBTUBAsPX/TMFU/fXrCOt
         26O2b/mhCo5W6eLpNlUQWsyR7Ixv5ZUTwdJdy9nyRTd8ngXy19V4BBu0IIge2E8LMG
         L/ilaYZlaxYMXfw4K/4/Gi+sbzrOvkpvruiQ4Rzw=
Authentication-Results: mxback24j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt3-4825096bdc88.qloud-c.yandex.net with HTTP;
        Tue, 18 Feb 2020 19:46:12 +0300
From:   Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20200218163030.GR24152@zorba>
References: <20200217172551.GL24152@zorba>
         <16818701581961475@iva7-8a22bc446c12.qloud-c.yandex.net>
         <20200217175209.GM24152@zorba>
         <20200217.185235.495219494110132658.davem@davemloft.net> <20200218163030.GR24152@zorba>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain messages
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Tue, 18 Feb 2020 19:46:12 +0300
Message-Id: <23716871582044372@myt3-4825096bdc88.qloud-c.yandex.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

18.02.2020, 19:30, "Daniel Walker (danielwa)" <danielwa@cisco.com>:

> It's multicast and essentially broadcast messages .. So everyone gets every
> message, and once it's on it's likely it won't be turned off. Given that, It seems
> appropriate that the system administrator has control of what messages if any
> are sent, and it should effect all listening for messages.
>
> I think I would agree with you if this was unicast, and each listener could tailor
> what messages they want to get. However, this interface isn't that, and it would
> be considerable work to convert to that.

Connector has message/channel ids, you can implement this rate limiting scheme per user/socket.

This is probably not required if given cn_proc usecase - is it some central authority
which needs or doesn't need some messages? If so, it can not be bad to have a central switch.

But I also heard that container management tools are using this, in this case disabling some
things globally will suddenly break them.
