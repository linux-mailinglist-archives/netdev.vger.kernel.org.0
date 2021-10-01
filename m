Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C3941F123
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355017AbhJAPYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:24:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:60177 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1354920AbhJAPYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:24:15 -0400
Received: (qmail 506376 invoked by uid 1000); 1 Oct 2021 11:22:26 -0400
Date:   Fri, 1 Oct 2021 11:22:26 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Jason-ch Chen <jason-ch.chen@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [PATCH] r8152: stop submitting rx for -EPROTO
Message-ID: <20211001152226.GA505557@rowland.harvard.edu>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
 <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
 <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
 <20210930151819.GC464826@rowland.harvard.edu>
 <3694347f29ed431e9f8f2c065b8df0a7@realtek.com>
 <5f56b21575dd4f64a3b46aac21151667@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f56b21575dd4f64a3b46aac21151667@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 03:26:48AM +0000, Hayes Wang wrote:
> > Alan Stern <stern@rowland.harvard.edu>
> > [...]
> > > There has been some discussion about this in the past.
> > >
> > > In general, -EPROTO is almost always a non-recoverable error.
> > 
> > Excuse me. I am confused about the above description.
> > I got -EPROTO before, when I debugged another issue.
> > However, the bulk transfer still worked after I resubmitted
> > the transfer. I didn't do anything to recover it. That is why
> > I do resubmission for -EPROTO.
> 
> I check the Linux driver and the xHCI spec.
> The driver gets -EPROTO for bulk transfer, when the host
> returns COMP_USB_TRANSACTION_ERROR.
> According to the spec of xHCI, USB TRANSACTION ERROR
> means the host did not receive a valid response from the
> device (Timeout, CRC, Bad PID, unexpected NYET, etc.).

That's right.  If the device and cable are working properly, this 
should never happen.  Or only extremely rarely (for example, caused 
by external electromagnetic interference).

> It seems to be reasonable why resubmission sometimes works.

Did you ever track down the reason why you got the -EPROTO error 
while debugging that other issue?  Can you reproduce it?

Alan Stern
