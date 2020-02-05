Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F32152821
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 10:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBEJTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 04:19:34 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55119 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgBEJT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 04:19:29 -0500
Received: by mail-wm1-f66.google.com with SMTP id g1so1560638wmh.4
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 01:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i6H/QyNyNq+1Ik65EkQjZHjIndEH5TkQN3D2YteDfGc=;
        b=sE3Ikb6jgOuFcgMeTx0GoZkIya67lOK3J14E4lVh+7TRNq2YtEuTzpShgNVGt7W2he
         XWTiyhwSrZ9qJSooLWHlgIbGW3ypux6Hd6TOVfD1+cXo2fvCjkwf8YKncexg5vFk8tVe
         AiqGb3pi3v1A6Qz8hBJfGYuzeolAinTsdh7Rg2zs8cvdQsP5gYJl0ym51i+hJTaGO8aK
         mKcLxKcJIfOIr1Uq1yjVUnEWN27a5qOWyyA6QjAvEq89wYSyKkItjpsDtgntEhaVERm7
         1GUIGL4EKzPgPc7sJJLeyOE35GcqvmSQrLYqbewKVULPfkKskjrll/8OnHSQTCsQEbM5
         8aJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i6H/QyNyNq+1Ik65EkQjZHjIndEH5TkQN3D2YteDfGc=;
        b=iB8eaW2fy2pl1l0eFKUbzP3WYsDeF4PrW9ukmD61YMyqfIjk/PS2iSLBlS+PQtsNq2
         rH4/dUAl5JJ65UBYAteSbXLA29ISviZQXfUsg4a9gZzPhwCIH9XyYDceQuRUgjQ8KNRv
         cvVNJkB64W9BuSN7aKdnFFv1Bflr37oO9QJlpDYCj5LgHTEdFlSQAdiJVZ11iFEe/gvu
         WQX/B0k4JFISxjg3x3lROwiAagl1MwMD03ynejc0bNVSHlArnH7d4Jl4EIzT5vtrh1UY
         Pu6/h+y56lrvXbS41r4Hs0A8kJ6Ty4aoWkNDgq6o89HPplvFwhQiGYD1RDKq02QSI8gc
         nYkg==
X-Gm-Message-State: APjAAAVerIUiovRagg92DDHMwlopjJ22Fylv/0wZS4CWftlgL9F6oc4Z
        Ss73kPUW6YBJt6S0tPwCq6yYPQ==
X-Google-Smtp-Source: APXvYqyFg48GgOSm1+SP3QTQA6KD8OCD6dLT7Yoc8jB8I6QtYSHQJpgGmv13B6djBo6hafQ2SjeqXw==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr4494858wml.71.1580894365966;
        Wed, 05 Feb 2020 01:19:25 -0800 (PST)
Received: from shemminger-XPS-13-9360 ([212.187.182.162])
        by smtp.gmail.com with ESMTPSA id d204sm7254710wmd.30.2020.02.05.01.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 01:19:25 -0800 (PST)
Date:   Wed, 5 Feb 2020 01:19:23 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>, davem@davemloft.ne,
        mkubecek@suse.cz, jeffrey.t.kirsher@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jouni Hogander <jouni.hogander@unikie.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Wang Hai <wanghai26@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li RongQing <lirongqing@baidu.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] net-sysfs: Ensure begin/complete are called in
 speed_show() and duplex_show()
Message-ID: <20200205011923.536bf3c7@shemminger-XPS-13-9360>
In-Reply-To: <20200205090638.GS10400@smile.fi.intel.com>
References: <20200205081616.18378-1-kai.heng.feng@canonical.com>
        <20200205081616.18378-2-kai.heng.feng@canonical.com>
        <20200205090638.GS10400@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Feb 2020 11:06:38 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Wed, Feb 05, 2020 at 04:16:16PM +0800, Kai-Heng Feng wrote:
> > Device like igb gets runtime suspended when there's no link partner. We
> > can't get correct speed under that state:
> > $ cat /sys/class/net/enp3s0/speed
> > 1000
> > 
> > In addition to that, an error can also be spotted in dmesg:
> > [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
> > 
> > It's because the igb device doesn't get runtime resumed before calling
> > get_link_ksettings().
> > 
> > So let's use a new helper to call begin() and complete() like what
> > dev_ethtool() does, to runtime resume/suspend or power up/down the
> > device properly.
> > 
> > Once this fix is in place, igb can show the speed correctly without link
> > partner:
> > $ cat /sys/class/net/enp3s0/speed
> > -1  
> 
> What is the meaning of -1? Does it tells us "Hey, something is bad in hardware
> I can't tell you the speed" or does it imply anything else?
> 
> Wouldn't be better to report 0?
> 
> Where is the documentation part of this ABI change?
> 

The speed value of -1 is defined in ethtool.h as:

#define SPEED_UNKNOWN		-1



