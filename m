Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384263D3AE3
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhGWM1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 08:27:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36413 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S235119AbhGWM1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 08:27:14 -0400
Received: (qmail 39326 invoked by uid 1000); 23 Jul 2021 09:07:47 -0400
Date:   Fri, 23 Jul 2021 09:07:47 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
Message-ID: <20210723130747.GB38923@rowland.harvard.edu>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
 <20210722144721.GA6592@rowland.harvard.edu>
 <b007e1e5-6978-3b7a-8d7f-3d8f3a448436@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b007e1e5-6978-3b7a-8d7f-3d8f3a448436@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:05:09AM +0200, Krzysztof Kozlowski wrote:
> On 22/07/2021 16:47, Alan Stern wrote:
> > On Thu, Jul 22, 2021 at 04:20:10PM +0200, Krzysztof Kozlowski wrote:
> >> Anyone hints where the issue could be?
> > 
> > Here's what I wrote earlier: "It looks like the problem stems from the fact 
> > that port100_send_frame_async() submits two URBs, but 
> > port100_send_cmd_sync() only waits for one of them to complete.  The other 
> > URB may then still be active when the driver tries to reuse it."
> 
> I see now you replied this to earlier syzbot report about "URB submitted
> while active". Here is a slightly different issue - hung task on waiting
> for completion coming from device ack.
> 
> However maybe these are both similar or at least come from similar root
> cause in the driver.

Exactly what I was thinking.  :-)

> > Of course, there may be more than one problem, so we may not be talking 
> > about the same thing.
> > 
> > Does that help at all?
> 
> Thanks, it gives me some ideas to look into although I spent already too
> much time on this old driver. I doubt it has any users so maybe better
> to mark it as BROKEN...

Whatever you think is best.  I know nothing about port100.

Alan Stern
