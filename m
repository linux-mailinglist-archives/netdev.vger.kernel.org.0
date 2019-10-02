Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F993C9315
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfJBUxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:53:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42637 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfJBUxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 16:53:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so185146pff.9
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 13:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Teht8krjV9I4yoAGotugiVYKYlwLiVfKSfSqCO8cNf4=;
        b=jlO+NBPyz5tQDZY3RDxFnyu8Rcjfnq1ndJUH+zU/dejpBmvQ1oYCQL37A62CESeFsA
         OLZXA9IM92ZVhJl/Gdz8aaqfWhniBPVbkgjzL2OhtNuvL8I/qJuWcdMUg6t7T1J7kQ7X
         VED/vH0i8d/iEIoMjDbmzKYBysNutlFszdEVQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Teht8krjV9I4yoAGotugiVYKYlwLiVfKSfSqCO8cNf4=;
        b=F8qtvc22ZpiSDDMIZ46Z2EWakTgy31wxYfnxqzs1EpVdfmfBpVDM9a1xIasTdCh1ka
         68RMbkqQ0cH5f6qZQeAWULHGbj+eTdvD76noH6CtE33122c5tzezbGKSqyxTc224oiuZ
         nu0xZ3YdHyOLgxj9Ay9+CCXq11K+2dpdOrRJ97rQaIIW5MyE2NlDW7vILdgbO25LojjF
         xM+qYcys2YPatAv+8Tt6ODl/LdvTrP3TtWYnCFqw6m0lBCuhvWIV8KwAxSlhjIQ5I+/7
         bzgI0en1ZRd8y5XCrYLVdS3IeauFwW5biFO9r/jOUAFu2CF/oJ3nJtwQOVjoZJaboYYA
         Pi3w==
X-Gm-Message-State: APjAAAWxqq+u/jH3R7tCQRXpK8ZeCpcNovVe5WHHlCq7++lwqzZ2Igee
        uIuBH7qM/5OC9SyG7NUdq+eIVw==
X-Google-Smtp-Source: APXvYqz56NGqvNvM7wNZehM8lOTKZaqznv7OGeNO25LGl5UqtgpsSqdJxQLNnpGeTB2FDnioEMMVzA==
X-Received: by 2002:a63:5356:: with SMTP id t22mr5429101pgl.400.1570049582624;
        Wed, 02 Oct 2019 13:53:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j24sm340646pff.71.2019.10.02.13.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 13:53:01 -0700 (PDT)
Date:   Wed, 2 Oct 2019 13:53:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        pankaj.laxminarayan.bharadiya@intel.com, joe@perches.com,
        adobriyan@gmail.com, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: renaming FIELD_SIZEOF to sizeof_member
Message-ID: <201910021349.9B19DCFD6@keescook>
References: <CAHk-=wg8+eNK+SK1Ekqm0qNQHVM6e6YOdZx3yhsX6Ajo3gEupg@mail.gmail.com>
 <201909261347.3F04AFA0@keescook>
 <201910021115.9888E9B@keescook>
 <20191002.132121.402975401040540710.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002.132121.402975401040540710.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 01:21:21PM -0700, David Miller wrote:
> From: Kees Cook <keescook@chromium.org>
> Date: Wed, 2 Oct 2019 11:19:16 -0700
> 
> > On Thu, Sep 26, 2019 at 01:56:55PM -0700, Kees Cook wrote:
> >> On Thu, Sep 26, 2019 at 01:06:01PM -0700, Linus Torvalds wrote:
> >> >  (a) why didn't this use the already existing and well-named macro
> >> > that nobody really had issues with?
> >> 
> >> That was suggested, but other folks wanted the more accurate "member"
> >> instead of "field" since a treewide change was happening anyway:
> >> https://www.openwall.com/lists/kernel-hardening/2019/07/02/2
> >> 
> >> At the end of the day, I really don't care -- I just want to have _one_
> >> macro. :)
> >> 
> >> >  (b) I see no sign of the networking people having been asked about
> >> > their preferences.
> >> 
> >> Yeah, that's entirely true. Totally my mistake; it seemed like a trivial
> >> enough change that I didn't want to bother too many people. But let's
> >> fix that now... Dave, do you have any concerns about this change of
> >> FIELD_SIZEOF() to sizeof_member() (or if it prevails, sizeof_field())?
> > 
> > David, can you weight in on this? Are you okay with a mass renaming of
> > FIELD_SIZEOF() to sizeof_member(), as the largest user of the old macro
> > is in networking?
> 
> I have no objection to moving to sizeof_member().

Great; thank you!

Linus, are you still open to taking this series with Dave's buy-in? I'd
really hate to break it up since it's such a mechanical treewide
change. I'm also happy to wait until the next -rc1 window; whatever you
think is best here.

Thanks!

-- 
Kees Cook
