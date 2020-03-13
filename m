Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8349118527A
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgCMXwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgCMXwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 19:52:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B89FA20637;
        Fri, 13 Mar 2020 23:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584143524;
        bh=buyzexwwYTVxUp5UYXW17smeX7BEkmJhwRDsJSMamDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DaDhLEozHIyaWVLlS0unh7m1A8gWb0pzh+mWqv+IXbfZfO3B9Hlv7/WkGEqkxwpUJ
         FVPLoyv4xUaTqnznO2Df2gcsBehTjXqN2Pq+bNPiZy8HcgmTMq4WOJCmhnMomiP5Jo
         T/bndRjQqJ5a97DadRw7itYybOm/VZwUFL6G7SEo=
Date:   Fri, 13 Mar 2020 16:52:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 4/5] kselftest: add fixture parameters
Message-ID: <20200313165202.37d921cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202003131628.77119E4F4E@keescook>
References: <20200313031752.2332565-1-kuba@kernel.org>
        <20200313031752.2332565-5-kuba@kernel.org>
        <202003131628.77119E4F4E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 16:31:25 -0700 Kees Cook wrote:
> > @@ -326,7 +387,8 @@
> >  	} \
> >  	static void fixture_name##_##test_name( \
> >  		struct __test_metadata __attribute__((unused)) *_metadata, \
> > -		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
> > +		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
> > +		const FIXTURE_PARAMS(fixture_name) __attribute__((unused)) *params)  
> 
> Could this be done without expanding the function arguments? (i.e. can
> the params just stay attached to the __test_metadata, perhaps having the
> test runner adjust a new "current_param" variable to point to the
> current param? Having everything attached to the single __test_metadata
> makes a lot of things easier, IMO.

Sure! I felt a little awkward dereferencing _metadata in the test,
so I followed the example of self. But I can change.

Can I add a macro like CURRENT_PARAM() that would implicitly use
_metadata?
