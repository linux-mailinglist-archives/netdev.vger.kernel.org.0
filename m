Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF7352288
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfFYFGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:06:43 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:34398 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFYFGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:06:42 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id A2C4A2DC005B;
        Tue, 25 Jun 2019 01:06:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1561439202;
        bh=ciUqZASdiG9qaTP/PKSFriQCA2JczzepFyCfhQPhnVk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K4gLgQWu25eleaN8DIeSz5E82cI8K0smK5D3ZMpLjBFJrknUqV9V+eylalpbQXRAM
         nmEfhzWvgda7JuxTqo/SzkupuQp4odwSE5eKSMo5RCVBzSG9hQgA/2yqBEFIexBxOT
         i9vCKnVN9a9mDTxg3U1oNbYXq0GD4w40bt+gnrvVfRfHlUt7CzmQxv2ITaF01BU5v0
         qZonJ/jE4kiTWy7bQrfjqbazrpEygb0DU6gCobQX5qblC7fRwhvF4Sq1I5FxM2qyhg
         8GI0GBlW0Lvvwa7ilfXZ4x3AaZQNQL9XQbQNvJOLXG+h38c4UU6rLCHqjUeiUTV7I9
         9YOGia5GJedY1w/4Tr8d8CBihfAg/swFyuKTugjzhJ3nduRG/LNj+cPcUZRU9QpFNl
         2JMD91ZFIq08WBl0d90UMFWl7mSZfbGc4bFGkopV/6ReOk/vUtz69zueTfYfrFWzSU
         s+Er1jtAFNs/BmK+rQ0XkTqVSRlwAjaqyFZOLj6kw381sp7VTpaEupsP/8y3Je8A6v
         4UugchG2zDEWWEYN/tFyApbfSvLIe6pKK/LvgAQvjqkwlyRa0sBz8pzBqHKDxO1zyV
         JYMRMzTpGfe9MrWWhqER/P+y3YGfeX1gbEPw1Scpeut1XCY2CNUcsoDJlTQlBXKJk2
         DpMk176r7iASSHUrxiLPF0zo=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x5P56DR4022607
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 25 Jun 2019 15:06:29 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
Subject: Re: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Date:   Tue, 25 Jun 2019 15:06:13 +1000
In-Reply-To: <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-5-alastair@au1.ibm.com>
         <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Tue, 25 Jun 2019 15:06:37 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-24 at 22:01 -0700, Joe Perches wrote:
> On Tue, 2019-06-25 at 13:17 +1000, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > In order to support additional features, rename hex_dump_to_buffer
> > to
> > hex_dump_to_buffer_ext, and replace the ascii bool parameter with
> > flags.
> []
> > diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c
> > b/drivers/gpu/drm/i915/intel_engine_cs.c
> []
> > @@ -1338,9 +1338,8 @@ static void hexdump(struct drm_printer *m,
> > const void *buf, size_t len)
> >  		}
> >  
> >  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
> > -						rowsize, sizeof(u32),
> > -						line, sizeof(line),
> > -						false) >=
> > sizeof(line));
> > +						rowsize, sizeof(u32),
> > line,
> > +						sizeof(line)) >=
> > sizeof(line));
> 
> Huh?  Why do this?
> 
> > diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c
> > b/drivers/isdn/hardware/mISDN/mISDNisar.c
> []
> > @@ -70,8 +70,9 @@ send_mbox(struct isar_hw *isar, u8 his, u8 creg,
> > u8 len, u8 *msg)
> >  			int l = 0;
> >  
> >  			while (l < (int)len) {
> > -				hex_dump_to_buffer(msg + l, len - l,
> > 32, 1,
> > -						   isar->log, 256, 1);
> > +				hex_dump_to_buffer_ext(msg + l, len -
> > l, 32, 1,
> > +						       isar->log, 256,
> > +						       HEXDUMP_ASCII);
> 
> Again, why do any of these?
> 
> The point of the wrapper is to avoid changing these.
> 
> 

The change actions Jani's suggestion:
https://lkml.org/lkml/2019/6/20/343


-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


