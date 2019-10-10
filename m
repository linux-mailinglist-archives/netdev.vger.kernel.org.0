Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38590D2E5B
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfJJQJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 12:09:53 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:46405 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJQJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 12:09:53 -0400
Received: by mail-pg1-f170.google.com with SMTP id b8so3953031pgm.13
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 09:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wjUtvmCvo6VYYgZT2v5u95hguSn59IwTnB2wH040nJo=;
        b=iWEfxrka27vrUmPD6BpuuFz8uC7/FCxQh6KvQ2g08MxqdMhDgPc5bDcCGDXaNgrLar
         BNUJhck8Xp36Vm8bduSDttRVqCaHZAArKfJBJGmx+bah/BgfyDOr5u6J+JKk1iEymqwi
         Qak4ls0ENUQWNAb9+FucRIl41wkIhyPvDLq/Eccp0Kptm7StQPjGNW4o2lxHhyVXISqK
         CMdIKYD/+0a6QYMiVzxL2k9ut6RHlLgnTuIW8zhcEhuqgWs2Aa9xmNgIy6rsU2G5LMqo
         UKA1L06krRKqqq4/vloC3f3xk/7GbqoM4BDADpWzjqvUhN22mpQgiUHdrqHanpHX7S9u
         AW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wjUtvmCvo6VYYgZT2v5u95hguSn59IwTnB2wH040nJo=;
        b=GRIDvAQo0NzJD09rFaqEwZioKbzAjxcrgRliQNc24J8HK3mMbB6lmrmqmEfI2Qp/ZP
         LUP7aaXyfvpwK1Bi1WzhHA8WFv1wcqxOuWQ7VbmN4oD0NucDMIUFUX4XYxPJV3sxPA2c
         0+kE3c7S2MZ3F822ZrcNg008NbjStlTYRq3HidsaTYoIlmEahc+7+mQ/M4PkfwQqS0XB
         aZsiB9a1Y1V99SDkZjbejgCs4Z50q/3Lqwjewy+Nz1cIDwCWIrXdkW/hnWEQX6pfYGcZ
         1UfD5/ciTmN2UQElm45djKxl+VIijEZ+BRtBjnZShH3/FuRChvJ4hW+llPohBv7jngm9
         notw==
X-Gm-Message-State: APjAAAUaFIuc8qEhvwmaxUzDvsyWkf880BYAnvVANyjc4OkWx49efQpg
        r6tLMFFmA0vBG6jg1sqtxrCfJQ==
X-Google-Smtp-Source: APXvYqyYOgzEy0p2PMFXuxOb2LUFozsIMxutL1ql14QpVj1R/s39oIOOqHcdDYMHtJrOeNyCJqmhcw==
X-Received: by 2002:a17:90a:654b:: with SMTP id f11mr12235276pjs.49.1570723791193;
        Thu, 10 Oct 2019 09:09:51 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id m68sm7036770pfb.122.2019.10.10.09.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 09:09:50 -0700 (PDT)
Date:   Thu, 10 Oct 2019 09:09:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ayal@mellanox.com,
        moshe@mellanox.com, eranbe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/4] devlink: propagate extack down to health
 reporter ops
Message-ID: <20191010090934.4e869113@cakuba.netronome.com>
In-Reply-To: <20191010080704.GB2223@nanopsycho>
References: <20191009110445.23237-1-jiri@resnulli.us>
        <20191009110445.23237-3-jiri@resnulli.us>
        <20191009203818.39424b5d@cakuba.netronome.com>
        <20191010080704.GB2223@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 10:07:04 +0200, Jiri Pirko wrote:
> Thu, Oct 10, 2019 at 05:38:18AM CEST, jakub.kicinski@netronome.com wrote:
> >On Wed,  9 Oct 2019 13:04:43 +0200, Jiri Pirko wrote:  
> >> From: Jiri Pirko <jiri@mellanox.com>
> >> 
> >> During health reporter operations, driver might want to fill-up
> >> the extack message, so propagate extack down to the health reporter ops.
> >> 
> >> Signed-off-by: Jiri Pirko <jiri@mellanox.com>  
> >
> >I wonder how useful this is for non-testing :( We'd probably expect most
> >health reporters to have auto-recovery on and therefore they won't be
> >able to depend on that extack..  
> 
> That is probably true. But still, what is harm of carrying potential
> error message to the user?

Not sure, it just makes the right thing to do non-obvious to someone
implementing the API (below level 7 on Rusty's API Design Manifesto).
But I don't feel too strongly about it.
