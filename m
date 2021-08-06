Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB8D3E22AD
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 06:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242734AbhHFEkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 00:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhHFEkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 00:40:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 492AD611C5;
        Fri,  6 Aug 2021 04:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628224806;
        bh=nvFMt4PbVOSjw9AF/7nA43J6gtfYsIRT4xo7EOVQ3EE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tGE6YChgml8dtCcmbJSKKXJQRepMLkDrRWrpqj94wK1Ee4W//xcMY0Ilk12EA/OHI
         WWvV8SFP2k0iU8GqNI4n91+3Gt/KKSkVxIVdwB7yVFxS4qXPCOXZ8DLp4pa3eULelp
         gpXnHlui9/qT3tlkkmhhGC8P1W/E8LYhdV6SbqkY=
Date:   Fri, 6 Aug 2021 06:40:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
Message-ID: <YQy9JKgo+BE3G7+a@kroah.com>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 11:53:50PM +0300, Martin Zaharinov wrote:
> Hi Net dev team
> 
> 
> Please check this error :
> Last time I write for this problem : https://www.spinics.net/lists/netdev/msg707513.html
> 
> But not find any solution.
> 
> Config of server is : Bonding port channel (LACP)  > Accel PPP server > Huawei switch.
> 
> Server is work fine users is down/up 500+ users .
> But in one moment server make spike and affect other vlans in same server .
> And in accel I see many row with this error.
> 
> Is there options to find and fix this bug.
> 
> With accel team I discus this problem  and they claim it is kernel bug and need to find solution with Kernel dev team.
> 
> 
> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: ioctl(PPPIOCCONNECT): Transport endpoint is not connected

These are userspace error messages, not kernel messages.

What kernel version are you using?

thanks,

greg k-h
