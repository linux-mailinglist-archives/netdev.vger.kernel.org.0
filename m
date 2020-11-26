Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0F2C57BA
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391151AbgKZPAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:00:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:59826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389911AbgKZPAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 10:00:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606402800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MN+K+KATzL0V3+o8x50winEV8cRDI7V0yHzEukvAr/I=;
        b=mnXLMbV65ayeOxDZehLW2H/5ikrbBLfEIKpFBbQcuPncs36ZRlctwz0O0xw4YH3OtEAaIr
        UO7XmfWrAobsy3yEHcqe5F2B+edxUAoV8O52IqbF9k6i4FWnNWkmYBK7cPmnBWOijFu78+
        w9CxbnP1iuzqzFFDQbPhJTzzrsQ2Pks=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C159ACE0;
        Thu, 26 Nov 2020 15:00:00 +0000 (UTC)
Message-ID: <986e95f8d75780ddeda90e135237eccf1d9b1e55.camel@suse.com>
Subject: struct mii_if_info in usbnet.h
From:   Oliver Neukum <oneukum@suse.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     hayeswang@realtek.com, hkallweit1@gmail.com, tremyfr@gmail.com
Date:   Thu, 26 Nov 2020 15:59:37 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was looking at usbnet_get_link_ksettings() and it seems in hindsight
that the idea it rests upon makes an assumption about the hardware
that was at the time it was introduced was often true, but today
isn't.

struct usbnet contains a member struct mii_if_info. Why? That makes
a pretty strong assumption about the hardware. Inparticular I see
no way to sanely implement mdio_read() and mdio_write() on hardware
this assumption does not fit.

On this hardware usbnet_get_link_ksettings() does not do its job.
So what is to be done? Technically it is a layering violation. Yet
it is obviously useful to many drivers?
Suggestions?

	Regards
		Oliver


