Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3AD84BE5
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 14:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387822AbfHGMoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 08:44:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36238 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387777AbfHGMoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 08:44:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so40680949plt.3;
        Wed, 07 Aug 2019 05:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qXLu3bh5aH4CnTaB9M6wXZJXk1SqGmlbkLW4YNgY6oY=;
        b=uO63s1LgDEohVzd+s+Ls6Xzl9O4U1I29sT0C6XcSN8JV8xKV1TU5fq//mMMqfTRZVr
         JGwKFyy5l2+I36IwKGzdYAtsBIBjxNzkqwHPl9lHCiQDx3vJSEDSJQFEcFAvduDyWzEn
         TLb7Nw00zH/aGchFkEqu9RMRzd6MWH0hMVKHQF9ghBmL9HTaF3KhVPtNWUPYBBlcw+T9
         BEOkq3W7/NxDInxBc5jCzd49OXRRaegnNg20vGbAxVy6c/gCFT9KWzXLDyIs1Ht5PLm6
         Im5dJrQF/QT+qH3HHLi7Em/S/5aM1gesaCbRF7PBk/ZT0sjcWoIQLqgO8Mmj/diOL0or
         tqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXLu3bh5aH4CnTaB9M6wXZJXk1SqGmlbkLW4YNgY6oY=;
        b=UxSphfAFkxgwEeV4/Zkl5stNi/7/8eBTM2l/FZ1P+Tse55SpJyxz+IhoEuyMtrVsgZ
         Px0RQvpatxzOh/o6inzu+wqAVrdl66Hsxu4ZC78KLf2uCJ8nqy40YQmH31+uodX8pNuF
         mPlfjLs1oJWCaDHiGXrfvK6VpD+XItM2UwdMSLMsNjajeLTQ2ufWCzxS0/RfdwBqzagc
         YhTXblXDxKbUzaApwraHn3XE4CGNveH+cnzYZ8AK0MXQAH2d8w6POTN5FYJoAYDnz8fK
         NBwijO5BlbSVktac6c+YcezT+1OPGnoAOM7iao/Ucz3/f4mbxXN2Zru4cylG9dFEnFVI
         l25Q==
X-Gm-Message-State: APjAAAV3EqVNCE5mbkeokJE5sz+kxJrEMvxBe9LoyecUA84KIso/c/ij
        uYHG1JvF0cSV78tTdHDlyEM=
X-Google-Smtp-Source: APXvYqyMnVyQfkuz1/W7XkEFYZ1LgYgL+nfI12mHOHEEipu9E/uVDA0CzpYgULPkjh0rjOwuHcjBZw==
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr8440698pjq.32.1565181841043;
        Wed, 07 Aug 2019 05:44:01 -0700 (PDT)
Received: from localhost (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id f14sm90917824pfn.53.2019.08.07.05.43.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Aug 2019 05:44:00 -0700 (PDT)
Date:   Wed, 7 Aug 2019 14:43:46 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and
 rx_max_agg_num dynamically
Message-ID: <20190807144346.00005d2b@gmail.com>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18D06C5@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-294-albertk@realtek.com>
        <20190806151007.75a8dd2c@cakuba.netronome.com>
        <0835B3720019904CB8F7AA43166CEEB2F18D06C5@RTITMBSVM03.realtek.com.tw>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 07:12:32 +0000
Hayes Wang <hayeswang@realtek.com> wrote:

> Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
> > Sent: Wednesday, August 07, 2019 6:10 AM  
> [...]
> > Please don't expose those via sysfs. Ethtool's copybreak and descriptor
> > count should be applicable here, I think.  
> 
> Excuse me.
> I find struct ethtool_tunable for ETHTOOL_RX_COPYBREAK.
> How about the descriptor count?

Look how drivers implement ethtool's set_ringparam ops.

Thanks,
Maciej

> 
> 
> Best Regards,
> Hayes
> 
> 

