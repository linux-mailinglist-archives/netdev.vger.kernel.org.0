Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49F4356049
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhDGA1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhDGA1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 20:27:46 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3657C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 17:27:37 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id z16so4283464pga.1
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 17:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=pt6ZKleyTYUGFrVTUkzzZcvJ2htaDhYo6N2jnbYloeg=;
        b=FnleSlBYyBv5jo20WSg9RbQswQZSYwHzZMmty9z7H8sTBS+RVtEZjbZn+HC5Qo6E8/
         ALgqsPZUG+BgxJ46O93zrjVzVDJUPj909WIhXgsIKcLcjd+szhtbct1l9hUJ84jEWYpl
         GNmRffoKa1TWgWgUoE0C/rsOjGrDS2ljB6PFs804y8/X9qJVGFxAw/XTn7D558qQI3j5
         gMrLMpW0uPkmiKslFMxnw76pDnepw7+myZX8OYSCIdSWg8v9FCdin2la4/9qaZl4DdHa
         G7ygQroP2/jU9lWJcg1YHFL7XS4ke1IbgCNvtLbF9I7tcfUgVGhqd84jj++Zds3EMfU7
         fj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=pt6ZKleyTYUGFrVTUkzzZcvJ2htaDhYo6N2jnbYloeg=;
        b=sXbqqsxIu7HTCJJo9jmLdPqBY9kCBGtQiZCxSoQji52dVsLFpvQO8BMUysuA+kNEvD
         RVZlnPCfiE7FCLTeTdNhmsaQgIeHlv5Upg3WSTNZhSWlg2zd1wLmcFVdP5IsjLLeUao7
         22KoN9Stdx1657qgBqYP4D0mMji+wlrBGv9bsLbgaj/6LdcpVLAHzOR7bQSR9qPq6K1T
         GEaWXiyi8dcxjyfvMz5CUsHPGY45KToFd0FipwJSAjbWw6G46jskolM5pmTFi7ORgAj0
         CiRF5aGCKrosHCLhusuCNj2EFF9M5HAGYlY/+hEcF6gonZM7hW+s4pe3cb+NM5H0F5eT
         qcug==
X-Gm-Message-State: AOAM531CNZlHCe2MKPEvjChvNEWQg1vil/HRstS9brG7BkCwJnapWUxs
        VtxQ6v0YPoV9lTB7atUdWhg=
X-Google-Smtp-Source: ABdhPJy2FGQ47KuYMBhJCiHBLtSnbBwcoJQHcYlzTW3soQtAAE1pKNo8TtexzuPGAGosBQEEWoHmgA==
X-Received: by 2002:a62:7ccd:0:b029:1fb:2316:b93e with SMTP id x196-20020a627ccd0000b02901fb2316b93emr595315pfc.34.1617755257301;
        Tue, 06 Apr 2021 17:27:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z192sm19255400pgz.94.2021.04.06.17.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 17:27:36 -0700 (PDT)
Date:   Tue, 6 Apr 2021 17:27:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
Message-ID: <20210407002734.GA30525@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
 <20210404230526.GB24720@hoboy.vegasvil.org>
 <9b5d20f4-df9f-e9e1-bc6d-d5531b87e8c4@pensando.io>
 <20210405181719.GA29333@hoboy.vegasvil.org>
 <ac71c8ad-e947-9b16-978f-c320c709615e@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac71c8ad-e947-9b16-978f-c320c709615e@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:18:00PM -0700, Shannon Nelson wrote:
> On 4/5/21 11:17 AM, Richard Cochran wrote:
> > On Mon, Apr 05, 2021 at 09:16:39AM -0700, Shannon Nelson wrote:
> > > On 4/4/21 4:05 PM, Richard Cochran wrote:
> > > > This check is unneeded, because the ioctl layer never passes NULL here.
> > > Yes, the ioctl layer never calls this with NULL, but we call it from within
> > > the driver when we spin operations back up after a FW reset.
> > So why not avoid the special case and pass a proper request?
> 
> We do this because our firmware reset path is a special case that we have to
> handle, and we do so by replaying the previous configuration request. 
> Passing the NULL request gives the code the ability to watch for this case
> while keeping the special case handling simple: the code that drives the
> replay logic doesn't need to know the hwstamp details, it just needs to
> signal the replay and let the hwstamp code keep track of its own data and
> request history.
> 
> I can update the comment to make that replay case more obvious.

No, please, I am asking you to provide a hwtstamp_config from your
driver.  What is so hard about that?

Thanks,
Richard
