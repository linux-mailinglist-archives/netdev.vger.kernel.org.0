Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919CE17ED7
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbfEHRGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:06:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45608 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbfEHRGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:06:33 -0400
Received: by mail-pl1-f194.google.com with SMTP id a5so5278292pls.12;
        Wed, 08 May 2019 10:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=75HU3h4OsAx80C+4HKmkW9WgCjMZ+3MuLOv2/tSvsf8=;
        b=jQl6hDH30YowXP4QHSAKi9IE+6WlJEE9nvbFJQjRbUi7SHucchoX5QX0FEPCcs+kkL
         /jpbzu3fEJoqC4nfdct9P3686RvwnXltHnptuE6rWvUJqv6WrstRah+XYV+aRESaYFn3
         jFlNYGFTnsq7c6nSR/FxyByvG87taz9YhTSvI6cGnvoO5Qfl5OoZqQTuX8wBXJn+ss9d
         0U31LGy5ye/WnB3tucJRtX1bxu/FPDmIq6nqHk2nl515S9PzPdxO9m0clWWhIAvzSPyt
         mkqzEJ8W17t6yXjMve4NC7Px40RyKcqnY7HOmzaicZhAa/EtdMIsysIHDQJ6aZsARyIL
         N5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=75HU3h4OsAx80C+4HKmkW9WgCjMZ+3MuLOv2/tSvsf8=;
        b=Q7LkCV6+EyyNixvR476rE3e8vYCxNayAcWB367Kxpj0EvM/nZzwxaGXRqNFdt3naVz
         KSgPOQo9Url7jJuHzpcy7ij48TC5tigbGcMn8qw3L8+NHz+S+BlHdqXOOu3mw7Pk2h50
         Yu3qGUVpbO9a+YZVLMCAQHYXNVB29EcQEo7Ln+rHqCF2BUP/4K8Tu5kf1IukEJbL/86u
         0pU6yteF3vqtO3pwd8vp4395dAw5EC96v2vn4PY6FQEJ7FDyZn8tjQurfNsKd8sCBQCe
         UHepYy8uahlQfkr5610KWOzFD3jel0doImWjEQxdmXCbG/oY7ZmpwGB2QMG/ruC2O92M
         8nVw==
X-Gm-Message-State: APjAAAXhzS4cFBb+4e4k9FVEbaGw0MVyzrlBJcIsFS+Nk0HyIypwLi2z
        6Dhj+8xmEJmmdjnqtUN0skDP32xG
X-Google-Smtp-Source: APXvYqz2ig4LTc8BeA++POHhfq31FLeFbtUnhNuxJeCOWUwYOUw7UcTLduomkOhdm3P5hDWJB/4mKA==
X-Received: by 2002:a17:902:b489:: with SMTP id y9mr17545441plr.70.1557335193074;
        Wed, 08 May 2019 10:06:33 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id o10sm26434215pfh.168.2019.05.08.10.06.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 10:06:32 -0700 (PDT)
Date:   Wed, 8 May 2019 10:06:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Leo Li <leoyang.li@nxp.com>, Roy Zang <roy.zang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>
Subject: Re: [EXT] Re: [PATCH v1] timer:clock:ptp: add support the dynamic
 posix clock alarm set for ptp
Message-ID: <20190508170629.me5smui6n7n62x2l@localhost>
References: <1557032106-28041-1-git-send-email-Po.Liu@nxp.com>
 <20190507134952.uqqxmhinv75actbh@localhost>
 <VI1PR04MB51359553C796D25765720FCC92320@VI1PR04MB5135.eurprd04.prod.outlook.com>
 <20190508143654.uj7266kcbhf744c3@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508143654.uj7266kcbhf744c3@localhost>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 07:36:54AM -0700, Richard Cochran wrote:
> No the alarm functionality has been removed.  It will not be coming
> back, unless there are really strong arguments to support it.

Here is some more background:

    commit 3a06c7ac24f9f24ec059cd77c2dbdf7fbfd0aaaf
    Author: Thomas Gleixner <tglx@linutronix.de>
    Date:   Tue May 30 23:15:38 2017 +0200

    posix-clocks: Remove interval timer facility and mmap/fasync callbacks
    
    The only user of this facility is ptp_clock, which does not implement any of
    those functions.
    
    Remove them to prevent accidental users. Especially the interval timer
    interfaces are now more or less impossible to implement because the
    necessary infrastructure has been confined to the core code. Aside of that
    it's really complex to make these callbacks implemented according to spec
    as the alarm timer implementation demonstrates. If at all then a nanosleep
    callback might be a reasonable extension. For now keep just what ptp_clock
    needs.
 
> Here is the result of a study of a prototype alarm method.  It shows
> why the hrtimer method is better.
> 
>    https://sourceforge.net/p/linuxptp/mailman/message/35535965/

That test was with a PCIe card.  With a SoC that has a PHC as a built
in peripheral, the hardware solution might outperform hrtimers.

So you might consider adding clock_nanosleep() for dynamic posix
clocks.  But your code will have to support multiple users at the same
time.

Thanks,
Richard
