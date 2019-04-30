Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A618EEE0
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 04:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbfD3Cyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 22:54:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36434 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbfD3Cyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 22:54:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id w20so5413133plq.3
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 19:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zGYP5aYJGcKAooYX/Oqa4cT8dTQeQlbEVOcPRcoj6mA=;
        b=Exsz4xnMnQWv2zgDA+ocLP8xnI8iBWQNiYfm2vp12UVHKrCdr6vy3q+3XC8vL7cue0
         cBtmaBilKT22lTMXA+s2lRbRtBLCXBEuKhMEL4Ifu9NEkk6oAV57uHMCoSkbvv7zPs+O
         JQflFLsGljRJxHqARIVZ9Og2ZLGBkVICi41PSqQg92OuQe48gyeN0R/Q2wl/5oWucK1/
         AeKw5Z3f28hI09RzosatqsNWHpxevuonKrBfdeRDbbGJ9tlLSzhMI/8VSA2EOi3pWLyB
         o+6NpKLXMm5umztcbYa1pLnbjPE4Y41mSxorDebhIAnnKclU4fTZn6ZKtfVW15N5d2hl
         O+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zGYP5aYJGcKAooYX/Oqa4cT8dTQeQlbEVOcPRcoj6mA=;
        b=g45b+2a4zCo66vww5JuHqOFQQVH/48Tk5/I1BFcdTOAndNQ0cmm86lxH+OTPUUC027
         9U9qOAkg33ubQur6xpx2NsnB6rRmKPuXtahpDbg8l6eG9NcX9dp+dhXr0hVTnL24AFLO
         iK6r8jnyZNa7UYiHRWdYRJHyXAM1XLIkLdV/GeOfUnYFMyv+mk9R4kF3J64QXMEUVbIj
         Ka6bdHyFO/jPh4fuQ4YNeNWCf7CXX59UUqrJ3gfN8kHzWl7bmT6P9PEUP05Ffpazb3vn
         40L+6FSP1m4SkZSvg2RG7fnxGbVoOK+1OwoTHU5MYbhaXtmmIaCkOsA5mtcuwx3mhl98
         5TBg==
X-Gm-Message-State: APjAAAVmxclxBERV4dAAc0AzDym+L9CC5HSuF4YV/UzAxUclH2sHB+Jt
        I+FwOQaw2CD30xFMY8X7eTGZIQm1
X-Google-Smtp-Source: APXvYqxWsPU5XKwUN7Q4OGU02OMzvH2JwVfKxgAzZXo7ZXbdjyGjrlnVrdSfQGtYxMBwIxOvUHsCrQ==
X-Received: by 2002:a17:902:1003:: with SMTP id b3mr66977334pla.306.1556592884956;
        Mon, 29 Apr 2019 19:54:44 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u5sm50251780pfa.169.2019.04.29.19.54.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 19:54:44 -0700 (PDT)
Date:   Mon, 29 Apr 2019 19:54:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Stephen Mallon <stephen.mallon@sydney.edu.au>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net] ipv4: Fix updating SOF_TIMESTAMPING_OPT_ID when
 SKBTX_HW_TSTAMP is enabled
Message-ID: <20190430025442.pjvjh22ccexz7fwt@localhost>
References: <20190428054521.GA14504@stephen-mallon>
 <20190428151938.njy3ip5szwj3vkda@localhost>
 <CAF=yD-JLcmyoJ6tq1osgrQbXs6+As0R+J-ofU+XwQWcvaW+LBg@mail.gmail.com>
 <20190429150242.vckwna4bt4xynzjo@localhost>
 <CAF=yD-+EdbxnSa1SUqPamdxeDN_oPd4-kXAEF6yV1o_Zwj+LUw@mail.gmail.com>
 <20190430011732.GA20814@stephen-mallon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430011732.GA20814@stephen-mallon>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 11:17:32AM +1000, Stephen Mallon wrote:
> 
> I've found that SOF_TIMESTAMPING_OPT_ID already works with hardware timestamps
> for TCP just not datagram sockets and so I though this was a fix.

Right, so if HW time stamping worked for TCP but not for UDP, then I
would call it a regression to be fixed in stable.

Thanks,
Richard
