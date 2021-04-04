Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD502353952
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 20:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhDDSGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 14:06:35 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:54356 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhDDSGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 14:06:34 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lT78W-0003qW-Qq; Sun, 04 Apr 2021 20:06:12 +0200
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
Message-ID: <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
Date:   Sun, 4 Apr 2021 20:06:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.03.2021 00:54, Maciej S. Szmigiero wrote:
> Hi,
> 
> It looks like rtlwifi/rtl8192cu AP mode is broken when a STA is using PS,
> since the driver does not update its beacon to account for TIM changes,
> so a station that is sleeping will never learn that it has packets
> buffered at the AP.
> 
> Looking at the code, the rtl8192cu driver implements neither the set_tim()
> callback, nor does it explicitly update beacon data periodically, so it
> has no way to learn that it had changed.
> 
> This results in the AP mode being virtually unusable with STAs that do
> PS and don't allow for it to be disabled (IoT devices, mobile phones,
> etc.).
> 
> I think the easiest fix here would be to implement set_tim() for example
> the way rt2x00 driver does: queue a work or schedule a tasklet to update
> the beacon data on the device.

Are there any plans to fix this?
The driver is listed as maintained by Ping-Ke.

Thanks,
Maciej
