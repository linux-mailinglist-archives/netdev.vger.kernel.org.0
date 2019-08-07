Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBEA8439A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfHGFPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:15:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33387 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfHGFPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 01:15:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so771392wme.0;
        Tue, 06 Aug 2019 22:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pp4YWyx3LNt4h77TMcJoBYvXi28SNsEqSfN2aO+q+7I=;
        b=U7TmMloS6ZPgrtO0DNdyfUQhdDzDaveQh/wpy21Vso8pbhGU7nmfLxkFPFDEDP+8gY
         /T0owknmPaAZaAHpKRL1oTw4iAJRsWWOja5bpjI1BakkWjuPBUsjdc9Qtk+gXyZFpEMP
         f5ckbMlGxl7aasMX0uDdBfqxGdSqSGZtBi6+cz838lDHldApX5+diNrbfqzBcbp4ghgA
         uK+d0ps/rGU5LXmSWmAzfst0J/hjvZXoaJhCtWUSgj49BLkBgSs8xwOLeMGkihK6klbC
         JtJb4r40Vrb7WhIIeCjeOLDfRhrbPKQf4tjsY0E9+LO5cO2rPZYF+vzM66N04st7X4Gx
         IWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pp4YWyx3LNt4h77TMcJoBYvXi28SNsEqSfN2aO+q+7I=;
        b=giD7atKj8itwwgXPtOlwLQ0XLuD0VWKklVxAFlfvZ93I/qS05IatSH1ljYAANT3UUQ
         AvX5DRFHKzKW6fU5g84BXlt1J6APkuj/mMDeFI/UQlkGm4xdOX/cIqRHR5817Fch/5bs
         5kI/DqU08VQ32yenyZm1saLAEw8z+1ofxk9puOtmIXY0LFYYThW1+03ZjL6XVSITd7sK
         5dIjz48aAeigtqo36YG+Octw5mfaNsJApmRSriBy9YiKwNSuxg2HuXATfLFuNEAESezY
         IGZDudh0pb4zoSl0PmfdbslAH1PSyCP9B+rmi8IP15kHOUG4o7lIHKSqddKIux3mOgzK
         KtXw==
X-Gm-Message-State: APjAAAWyXcl/m8nxeRCt2rAZQORKSgMdzE4dLGaj6UicRqYJXq1SNJ02
        emFmqTgWReFUV2f6tVvHX1c7NDA1N0+FHA==
X-Google-Smtp-Source: APXvYqxaBNq7pO+QBEcGdRr/ERy2r5cTPmGpqT6hMJjV0hoAq9A1x3d1yFv8C77BiTXAWV286KbTpQ==
X-Received: by 2002:a1c:5453:: with SMTP id p19mr7686773wmi.148.1565154919396;
        Tue, 06 Aug 2019 22:15:19 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id q18sm111889375wrw.36.2019.08.06.22.15.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 22:15:18 -0700 (PDT)
Date:   Tue, 6 Aug 2019 22:15:16 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
Message-ID: <20190807051516.GA117639@archlinux-threadripper>
References: <20190712001708.170259-1-ndesaulniers@google.com>
 <874l31r88y.fsf@concordia.ellerman.id.au>
 <3a2b6d4f9356d54ab8e83fbf25ba9c5f50181f0d.camel@sipsolutions.net>
 <CAKwvOdmBeB1BezsGh=cK=U9m8goKzZnngDRzNM7B1voZfh8yWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmBeB1BezsGh=cK=U9m8goKzZnngDRzNM7B1voZfh8yWg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 03:37:42PM -0700, Nick Desaulniers wrote:
> On Thu, Aug 1, 2019 at 12:11 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> >
> > > Luca, you said this was already fixed in your internal tree, and the fix
> > > would appear soon in next, but I don't see anything in linux-next?
> >
> > Luca is still on vacation, but I just sent out a version of the patch we
> > had applied internally.
> >
> > Also turns out it wasn't actually _fixed_, just _moved_, so those
> > internal patches wouldn't have helped anyway.
> 
> Thanks for the report. Do you have a link?
> I'll rebase my patch then.
> -- 
> Thanks,
> ~Nick Desaulniers

Just for everyone else (since I commented on our issue tracker), this is
now fixed in Linus's tree as of commit  1f6607250331 ("iwlwifi: dbg_ini:
fix compile time assert build errors").

Cheers,
Nathan
