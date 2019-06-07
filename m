Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0E63832A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 05:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfFGDeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 23:34:46 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39068 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFGDeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 23:34:46 -0400
Received: by mail-pl1-f170.google.com with SMTP id g9so264765plm.6
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 20:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lOp5EJCfwhs0qJjtk7SC+xnEgWvfC4b7BO3L96tNksk=;
        b=hIznuvFQWVbTjjt+U7YIagCEncAqLRnHHBd4Ef/6kTqqLGqUAudcevosU6mKQKDMlM
         TAiKabk7FFefC44RXyvRQICtqxAo0SUZzJ599p8RCrusNNTYe12JsKsP3u7mYzOIudjB
         TgW7e4OopPhcQXCec3vrRoBtJ5Zq5Oo8VkQSEjCcxccFX3RR+ssqNQniPpxNd0zrHoxC
         nBFjpI5hhCMPi8yitE3ePIIQGKCH3tiFeOt2B2SnznNk+oyam7d67QB0zHtImlGS6/Yn
         DXL1Q7Lj+EEaFuNbe7RyFjk9Tyn3nL+UqTGnEk/dDctfDCPf0at3vvZHECHrcFthBMpc
         6vlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lOp5EJCfwhs0qJjtk7SC+xnEgWvfC4b7BO3L96tNksk=;
        b=Q0MPE3To0sq5vOgb0dX538R5S+JrHzm5OdKhOn46izpevNl59ZfVhevkPccKFn8Dgp
         0iRTzScUrvMoTnB7dZTgSE6JvXGX+l0R66Ua95hLLqhpO/0TB9uMBnyy3gN2dPxWfAxl
         j/wZnvjHsi2OE2wrD93JJLSte1mH92UArHA2rArVZwUv5ZQAzOq/ARZxZK2t3NxUI9ZD
         yjUMmYQC9JKl8KwOgQ5Bo8ZkHeC/FX64stb2yWYR5RKuONrF7r0SI5gMufyF2Jf/qfzM
         c1JT8DE+DxM4cnIVYvCbTYMqNfcvLOtaUX9s6vSL5j3KmYnMDAU0uMIf1rq3bjah71iC
         G7rw==
X-Gm-Message-State: APjAAAVLhmG5oUloDPgGKaNQVv7l4LStufzvvs7jh/JS49g+Knd0LYXw
        Wd3wK9CLsuWJSP6ETyCmxsI=
X-Google-Smtp-Source: APXvYqyBIPnzFOl6dDd13L/YIU8ohoN4opKa7PoHsi3MMzC5Xv1bkFveYD8NaTuh5ysymWreDkwYYw==
X-Received: by 2002:a17:902:d717:: with SMTP id w23mr11579950ply.275.1559878485604;
        Thu, 06 Jun 2019 20:34:45 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id y12sm520012pgi.10.2019.06.06.20.34.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 20:34:44 -0700 (PDT)
Date:   Thu, 6 Jun 2019 20:34:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
Message-ID: <20190607033442.t3d5gpddvne2m27k@localhost>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
 <20190605202358.2767-7-jeffrey.t.kirsher@intel.com>
 <20190606032050.4uwzcc7rdx3dkw5x@localhost>
 <02874ECE860811409154E81DA85FBB5896745E05@ORSMSX121.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02874ECE860811409154E81DA85FBB5896745E05@ORSMSX121.amr.corp.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 08:37:59PM +0000, Keller, Jacob E wrote:
> No. We use the timecounter to track the time offset, not the
> frequency. That is, our hardware can't represent 64bits of time, but
> it can adjust frequency. The time counter is used to track the
> adjustments from adjtime and set time, but not adjfreq.

Ah, okay.  Never mind then... carry on!

Thanks,
Richard
