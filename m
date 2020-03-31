Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32B19952D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 13:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgCaLOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 07:14:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33806 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbgCaLOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 07:14:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id a23so8013177plm.1;
        Tue, 31 Mar 2020 04:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jfqMPesgkN+7mncezSXPSHTqvyq0LT20OfMYu4n26Qs=;
        b=NgGfU5Bb0Rwj7vg/+L4i+PgKT83GpLY5DNG51ZYfn6BWifbVGFEMdbVM2N5hfx+uGB
         99wPJ3vXyH3XPvndMvodXVZyDYTZDivtL/bPEMqKpfskoNq/ZDfNEJdL1llJg5bTcT5M
         JNEubbr7xlJeJDqYzy1/gRrYb1fh/QDq8Dn9xBSpekTv7CqdqvExHNt9EMGMHp/t6/EP
         K1eNhG3Dh2Mgdaf7lG+RofH39lslahCSTiisl8yCRQ6o9vSUhjyPGcHes2nEI1CLrAly
         OLUYewtOK5N5vqyWo2HM+/BaXNiUEyCbUCWHVgIqfinrdYh0UUbsH/rorUet37iiXfky
         oPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jfqMPesgkN+7mncezSXPSHTqvyq0LT20OfMYu4n26Qs=;
        b=rGXZZZT/0FxJaKccLneA7adnDBT7mJrdJmOYUp+BOrQBDpkPYx5lMn8G9mA3yV+GjC
         UPpfM9I88+fgp4DIScrV7vMaK2Lqjm6wMp9MEkzDMdXKebHfoPzpEgveRnNPnZMcNno7
         c+LbzvoJX3WfSvKdr7nQjlkSI3pmzApOQBuJLhsiQ+gRpcv7r/XM3YiJhT8fjtLWnxSg
         zf9goCyPtap451qLxqpWZelzijOj0tM0Cqpn5OA0VW/OQeuCW997S931n9+A8ESZHRYa
         bGSFWhfapuMSoIZtEWDn6Kgqy/gDsSPurVNGwoHgOocZcd3PSPcMGCv8GcCRF1mvAjKe
         B2HQ==
X-Gm-Message-State: AGi0PuZ2arh0Py4Gw4MDf7cir34d6Nt1rEKvfd0x6UE3NswGaWNkxROh
        vsfNt3HKhfUuKpXsTQ3A4Fc=
X-Google-Smtp-Source: APiQypJ06shRWMde4lJ/waxgyBPfa/BC6ceOEQ3+6imjtew7/jwC9nYpB/5sWJJn+B8wZkll5ynyyA==
X-Received: by 2002:a17:90a:254f:: with SMTP id j73mr3195083pje.11.1585653262666;
        Tue, 31 Mar 2020 04:14:22 -0700 (PDT)
Received: from localhost (194.99.30.125.dy.iij4u.or.jp. [125.30.99.194])
        by smtp.gmail.com with ESMTPSA id c190sm12241067pfa.66.2020.03.31.04.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 04:14:21 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Tue, 31 Mar 2020 20:14:18 +0900
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jouni Malinen <jouni@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next] bisected: first bad commit: mac80211: Check port
 authorization in the ieee80211_tx_dequeue() case
Message-ID: <20200331111418.GB502@jagdpanzerIV.localdomain>
References: <20200331092125.GA502@jagdpanzerIV.localdomain>
 <52358d231e26dcb27b710c22f7993e0d331796ec.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52358d231e26dcb27b710c22f7993e0d331796ec.camel@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (20/03/31 11:30), Johannes Berg wrote:
> On Tue, 2020-03-31 at 18:21 +0900, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > Commit "mac80211: Check port authorization in the ieee80211_tx_dequeue()
> > case" breaks wifi on my laptop:
> > 
> > 	kernel: wlp2s0: authentication with XXXXXXXXXXXXXX timed out
> > 
> > It just never connects to the network.
> 
> Yes, my bad. Sorry about that.
> 

No worries.

> Fix just narrowly missed the release and is on the way:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240

Good to know!

	-ss
