Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C52998BB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389707AbfHVQFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:05:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32817 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbfHVQFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:05:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id go14so3722590plb.0;
        Thu, 22 Aug 2019 09:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NxmU91a+hygMveLYANWk4CJyZEkVhJGaWcBlnfdPFlA=;
        b=E9FNR7ftdt48+rCHz2opRWv8qkIJf0+Vao826g86k2XiP+kn2Fy9XzsJiMpyJI9uCF
         Ei3933nhNZl28VIqAp+cp6pVxETs+KERIONH9TsPu7JpYdAyHzZbd+5Xl0t3DhNUpmkY
         2/CEV2lQmMkbzZT7TQd8dEBcJi3zKIl2niW2+rrO1zVsABvJwRX7ceMs5SV+C3P4rmXu
         FGyDUbxNesXsQpSfbtq0gGqwBKKWcgJtu9VwNDcS5Ct1wtWNZNXwMOJp+HJsm8gfDa5V
         E7Edyo4lYTDzmwkyhTCFfb5i9c/7lVPg2lbOKdnS6XPcWcJx5cgl40yzScd/EapRXCC0
         XhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NxmU91a+hygMveLYANWk4CJyZEkVhJGaWcBlnfdPFlA=;
        b=uZLwREPgA6vQKmoa3/Y7sFd0H8YTQ7GJuDVUoovs6MxFgz5h/uWK461kmpZyKmPM5U
         2tswS63M9JBeip9+ovj/c5umNLAf3rbeEsMxEBOdV+rzggdZRAESyzaA4xfslpNMhCrY
         YYs4z40cE5P/yQBQ1ehpR5SNkm+NwXxaJs3uQrDI92DwpX4WVDjfx9uI4mhLoW+aAmUb
         CtzjOW1pGLREM/RQv7Sj13mMQz67GDmnPx6WQd7XJeQdt0tOs8dt4mLnFAB0F6b4aln/
         nxAFyFp6dHaSnTXuBXFsmrhVCjb58HkFVA/6FgXjI1rts4T/GrGKO8uG16EciK/hsSiP
         m08Q==
X-Gm-Message-State: APjAAAVYUQI9eNJupnKTVW8dPqQpZAhlzOjy4JGCevDQUr6ZQa/RgNvV
        veitzCxmzR5Q4JR1TiQ39x4=
X-Google-Smtp-Source: APXvYqzAdayaj4WD9jYfYK8Ekn2rQK4/yQpFcKRi5Q/V4yUHLo/Vyolh7Tm1O3MifUAat1R4wWUfHA==
X-Received: by 2002:a17:902:543:: with SMTP id 61mr40245692plf.20.1566489924071;
        Thu, 22 Aug 2019 09:05:24 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id y188sm27501000pfy.57.2019.08.22.09.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 09:05:23 -0700 (PDT)
Date:   Thu, 22 Aug 2019 09:05:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190822160521.GC4522@localhost>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost>
 <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
 <20190822141641.GB1437@localhost>
 <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 05:58:49PM +0300, Vladimir Oltean wrote:
> I don't think I understand the problem here.

On the contrary, I do.

> You'd have something like this:
> 
> Master (DSA master port)         Slave (switch CPU port)
> 
>     |                            |         Tstamps known
>     |                            |         to slave
>     |       Local_sync_req       |
>  t1 |------\                     |         t1
>     |       \-----\              |
>     |              \-----\       |
>     |                     \----->| t2      t1, t2
>     |                            |
>     |     Local_sync_resp /------| t3      t1, t2, t3
>     |              /-----/       |
>     |       /-----/              |
>  t4 |<-----/                     |         t1, t2, t3, t4
>     |                            |
>     |                            |
>     v           time             v

And who generates Local_sync_resp?

Also, what sort of frame is it?  PTP has no Sync request or response.

> But you don't mean a TX timestamp at the egress of swp4 here, do you?

Yes, I do.
 
> Why would that matter?

Because in order to synchronize to an external GM, you need to measure
two things:

1. the (unchanging) delay from MAC to MAC
2. the (per-packet) switch residence time

Thanks,
Richard
