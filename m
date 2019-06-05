Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F30362E8
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFERpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:45:51 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:45974 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfFERpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:45:51 -0400
Received: by mail-pg1-f175.google.com with SMTP id w34so12769658pga.12;
        Wed, 05 Jun 2019 10:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KYW9KV6F1PtzowYTWfsmNqq6dd/6chryOsDLvsNtyTo=;
        b=sL8inHr1zWJMoN1ayK98BtdafqYf8wYCNcQFNbzFl8NqJW6oj3f0drmAK2osJPuKsG
         iVSu5cJx2YBZY9AcNPyHhMCltwE/iLIt8Af2UB6BJC89r+qhLtcbJFUGPaFFnCjQWgYp
         jEzt4fnwW94T7h62EnLnRGtAuu9Zk6G7ub6t8ChMwWLkD3xu9gCOqlpv46VQdy5lz12B
         5/n2OkcT9OtNsFlXQr8lppCWFjUrGz1hpaD1JPsRlu/5rRBwzpx4FbPfhoguIElSI6Ze
         Ib5DKJS33FK+vLSLBPRXQgGJ/6AgO8JfPMqhftWNRHyrBU8UHpZgOqI1gk0/uVuj++R6
         4UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KYW9KV6F1PtzowYTWfsmNqq6dd/6chryOsDLvsNtyTo=;
        b=cpIxNC2CqfEwgFlgyVyB1e9MAIRxPSNHT2O3c79Xppi+wZiBbVxW9XiyCQRKPn7DO1
         XQryOs4/LzUjAsQsZlJJtGN2VF4cVWlkMRMgRV2i6jkyHQ+hc7l35H+6CtpE32xUf+Nq
         jnXODPCUqyvMoQVobeXVU1w5Ov+h6H68IIorCchTnpS+OFBxt6EhDCGQR1IGx9STB2gQ
         1beZBOpQi90aHjzr4TA5SFuPo3tPwz/H0fdCgFpfDPgWE6RN3s+vEsc7DMrWOKUBYVCn
         hWTEphoktS0rKrUwixvK0DAmStqKyHtQ4hvziFy8lO0t4Y3ZzB/YoEcBhstOFG/qmcjM
         /1ig==
X-Gm-Message-State: APjAAAXhJsx++bqMfOKjqJ91lUsrx81RATTZZl1oiewsZSrXO6aChqZ0
        DpVxf6Du5r+OaLHxBejwFEY=
X-Google-Smtp-Source: APXvYqzwc5YfCZGZcbV6OFOIE293LbKgnSaHgJ29Xl7c7xf+ElXIfPjKBkNxpPDSEeSdXjTu5TjcxA==
X-Received: by 2002:a62:1412:: with SMTP id 18mr14544166pfu.135.1559756750934;
        Wed, 05 Jun 2019 10:45:50 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id l1sm21086073pgj.67.2019.06.05.10.45.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 10:45:50 -0700 (PDT)
Date:   Wed, 5 Jun 2019 10:45:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
Message-ID: <20190605174547.b4rwbfrzjqzujxno@localhost>
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:33:52PM +0300, Vladimir Oltean wrote:
> In the meantime: Richard, do you have any objections to this patchset?

I like the fact that you didn't have to change the dsa or ptp
frameworks this time around.  I haven't taken a closer look than that
yet.

> I was wondering whether the path delay difference between E2E and P2P
> rings any bell to you.

Can it be that the switch applies corrections in HW?

Thanks,
Richard
