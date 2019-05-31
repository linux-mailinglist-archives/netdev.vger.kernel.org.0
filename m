Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9609D315F6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfEaUPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:15:34 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42677 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfEaUPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:15:34 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so2431385qtk.9;
        Fri, 31 May 2019 13:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=7YiaoU+6Y9gzcq2vBYFLQx0zIwtw9YAbbdSl0rNCg2M=;
        b=g+EArgwU7pOQMCYAGsyXpcwc98DQ/tqCpUVrBOAY1+cFw/pFWdq/iSTpswQe5hKCyO
         Vigqj+LtA8vpdxhu71aPfCxHHKkCRTPeXN/+IEGcwBKWDN0En+oYQWJsqwARpSsFSIWD
         wWGSDgmUJ7c4SFo0LSTKWK3x4ZO94agxZKGLsfP2bXclFSo+/eFu6g5/95rFkoFBWdiv
         EnIgTWCU6kDnhxQK3sF6Ss0H1WOfsgI9lVCiJ5u21bAdnLqPSPxN14c1blJE6FCaSrKJ
         xFD77UaAejfFcPaxgz7+Esu8gNLODVkFNhGW+5UEwpWPLkLAt1L8NaPL2442y+Tq8xOr
         iyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=7YiaoU+6Y9gzcq2vBYFLQx0zIwtw9YAbbdSl0rNCg2M=;
        b=ueq6QjqxPz2LR5Je/5VKRUQI3R9yBsv6oAzElN2/ijGkDUPjc1GfZpyPuWcoPuFIqo
         ivToPBUmeybcQCfSdCweGc5tmgnE99OctqJdO2PoE7yZzoKnixox3y1uh8B7mphwAQUg
         AYnv7ZulI4ZcLELLEQl1fVR7RtJWHMAf2h80LWBTSOBkDDbrZRggmmqovzCUXX3ipCl1
         NNbmLgJUlGYHFu13qYWwtGQVphpX97LL1dakxDJwTjFn3lQ8gzZ6dn5x+nSrFKuawHyB
         jw9n0r8ZJzoQonLEsnHbkhDE2Mt1Prl3EFCDztS2BkgMVn/nAmjDXyzUKGuypjVawaQJ
         EG/A==
X-Gm-Message-State: APjAAAWFXL4ROYuOOuWYSO/on6Ve0tjwH4maKZhMfgFFHNh2dnK7+6NZ
        a+jH+bfODMFwleEDgtDqvNE=
X-Google-Smtp-Source: APXvYqxVJOaLlxGiq0S4z/F/gpkkYLOMrO0iaoJVD7Rda/MUJBekJ5TA48N6U8lru1+AYQsJSeom6A==
X-Received: by 2002:a0c:9934:: with SMTP id h49mr10703909qvd.146.1559333733226;
        Fri, 31 May 2019 13:15:33 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c16sm3982118qkb.15.2019.05.31.13.15.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 13:15:32 -0700 (PDT)
Date:   Fri, 31 May 2019 16:15:32 -0400
Message-ID: <20190531161532.GE20464@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
In-Reply-To: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 10:35:14 +0300, Nikita Yushchenko <nikita.yoush@cogentembedded.com> wrote:
> When non-bridged, non-vlan'ed mv88e6xxx port is moving down, error
> message is logged:
> 
> failed to kill vid 0081/0 for device eth_cu_1000_4
> 
> This is caused by call from __vlan_vid_del() with vin set to zero, over
> call chain this results into _mv88e6xxx_port_vlan_del() called with
> vid=0, and mv88e6xxx_vtu_get() called from there returns -EINVAL.
> 
> On symmetric path moving port up, call goes through
> mv88e6xxx_port_vlan_prepare() that calls mv88e6xxx_port_check_hw_vlan()
> that returns -EOPNOTSUPP for zero vid.
> 
> This patch changes mv88e6xxx_vtu_get() to also return -EOPNOTSUPP for
> zero vid, then this error code is explicitly cleared in
> dsa_slave_vlan_rx_kill_vid() and error message is no longer logged.
> 
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
