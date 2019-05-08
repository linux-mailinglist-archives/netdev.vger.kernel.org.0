Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B346416EB1
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 03:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfEHBmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 21:42:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37461 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbfEHBmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 21:42:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id g3so9600546pfi.4
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 18:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wcnpm+PHCZzxi+MBOGiJBuxfnPCd3sd/IFRH+cWSbco=;
        b=h0M5MFvKNhstSReqMh2rx2OXlm0V+mgkbnD6R7H4IdfYJpsmq7dBuOQ913Ql9Xc+79
         xNmJYh7Gr3PlpuhhrrYZQO6xdy1sk0xbaMSLDz2iqHmwkN/z7cQlIOt9dK7k9RteqAfv
         /WxZ9/TgNCSe0F2Lj5Z3uBSoRazxiJxvxYuidP7DSCWabbTAIYmq7ZFsIBRSk7JsgI7M
         OKX/xodYfSm/PquYFHXrB3SB21pYyOUB4TYZ3VSmY/3aCazhbL9KE0hs7guzoVOW1n6A
         Fxgay33hSLTC7iX7qbYc0VOsG77Lh6wztSX0gmZnAfb7P4cyj6MgwR3fmGSCR5tqomvb
         1B3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wcnpm+PHCZzxi+MBOGiJBuxfnPCd3sd/IFRH+cWSbco=;
        b=F2NGMgZrJM6NS2s5aWS2cvZHrAKnQtI8Mezfme7f8UHpROB1qUtoLHPUvhL/xLb7Tt
         l+uWtr6mKzU8GjTg5z1McYaCgM0KaReuUFEC6r0NcFy3KjC9AtQFDPhspm5pzuq7ikRo
         YBPzoVUWa3d9328TnJwCo32oIqXEm3dmm4B629rgxTCZ+QMyYI+nhAYJfmzo/aJrMG5p
         H5+sar9333iWdTCUElbkP6qgW23NYPcQ+J61t976BlwcPP8969OZgat5g7B2qqJ5cK7r
         YVButFsU0XXxp4z+wpSn6K7VGrehlCPAZTQ2W/CQqvDUPSZv0iWPTIRVmMHPtFLZc2Pb
         AZtQ==
X-Gm-Message-State: APjAAAUNyaAdCE4Ak4uqTmiUpqok/38L/6+xRwPWNik4KygDupAW+WQj
        9jQXalpqyN3Pvl1/hMaXfO0=
X-Google-Smtp-Source: APXvYqw6fAvpSd3pGNX0K76JDrQZ29b0rSqdRpPsQLWD0IsRTRf2MV8na8CHg56mgi1e/yZqW5Dp6A==
X-Received: by 2002:a62:38cc:: with SMTP id f195mr34704661pfa.15.1557279730181;
        Tue, 07 May 2019 18:42:10 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i3sm22196571pfa.90.2019.05.07.18.42.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 18:42:09 -0700 (PDT)
Date:   Wed, 8 May 2019 09:41:59 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next] macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to real device
Message-ID: <20190508014159.GM18865@dhcp-12-139.nay.redhat.com>
References: <20190417205958.6508bda2@redhat.com>
 <20190418033157.irs25halxnemh65y@localhost>
 <20190418080509.GD5984@localhost>
 <20190423041817.GE18865@dhcp-12-139.nay.redhat.com>
 <20190423083141.GA5188@localhost>
 <20190423091543.GF18865@dhcp-12-139.nay.redhat.com>
 <20190423093213.GA7246@localhost>
 <20190425134006.GG18865@dhcp-12-139.nay.redhat.com>
 <20190506140123.k2kw7apaubvljsa5@localhost>
 <20190507083559.GD13858@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507083559.GD13858@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 07, 2019 at 10:35:59AM +0200, Miroslav Lichvar wrote:
> On Mon, May 06, 2019 at 07:01:23AM -0700, Richard Cochran wrote:
> > On Thu, Apr 25, 2019 at 09:40:06PM +0800, Hangbin Liu wrote:
> > > Would you please help have a look at it and see which way we should use?
> > > Drop SIOCSHWTSTAMP in container or add a filter on macvlan(maybe only in
> > > container)?
> > 
> > I vote for dropping SIOCSHWTSTAMP altogether.  Why?  Because the
> > filter idea means that the ioctl will magically succeed or fail, based
> > on the unknowable state of the container's host.
> 
> That's a good point. I agree that SIOCSHWTSTAMP always failing would
> be a less surprising behavior than failing only with some specific
> configurations.

Thanks for the reply. As net-next is closed now. I will post the fix
to net branch after merging finished.

Cheers
Hangbin
