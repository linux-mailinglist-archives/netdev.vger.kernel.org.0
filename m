Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0B47673D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 02:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhLPBJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 20:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhLPBJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 20:09:42 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9412C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 17:09:41 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z5so81653759edd.3
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 17:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FHIyIUHgABGRTpG8w7V67GIZKBgX3nHebqZRmIuJJJY=;
        b=xZviC8IdrUmSlO817ivxgFljCM7DPxP71a+pj6RNWpAcJDq7U/W1OtAw7pzbHfr4Mr
         EEo7yepTBLG6hHAPdgAHpv5oxct3PqaNyzAIlEBnjoGUMAKWTg54SH+iwWxSblIOPgBN
         MLrpVdIVEcLzErvfAhNjanJCOA6kUsTsVMqQY8Oo6Xq0Ys4Xrh1dltPo7eEdRpqZuLVL
         Un07rN7ToSrdssNbUFUHd2CitTECcv+Qd3EC0Qiu7QhJ9C1AEaJ9yv47RhHHpJnCfecc
         64+qrXWe0ypE9Yvo/5um3Guype3ZY4pI1UnIBki/egbTrjfixsGbfnkwmkXhF7j5zoE8
         w1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FHIyIUHgABGRTpG8w7V67GIZKBgX3nHebqZRmIuJJJY=;
        b=Ds0BiJ7ab9u0CZB+ZOcCE2q140M9onrIAzxDoyXU2rA1KX09vW5VkDsZRcGJl9DkwA
         WjvmUKrY64+Gr+flxdlKV3CHvV+aVkwbCDG7XhIVj8kP1moC9awL09IotyZj4ppMTqTk
         whAlgWKNphuAQBNPbjUzizz1cY+oE5xDDe4GLbuhofGcJCBitemWRYDs5n95TD4UNb6Q
         LiJdHoxJNSMPWTv0dnWziMv+cZZsLdt9J9VC01lw09qvDjO+lvWNUGesiAhAVzpcbjtr
         1KPj0SVIOyFzfrswQTrQDIdrTDR47FaH9sJLDjMiRji2pKdYj6yLoyPtDzZbGo/HMxVt
         OT5Q==
X-Gm-Message-State: AOAM533wYA8y2NkCEgDkun+Pmg7HejuKEqYEXfVu4tyMha60VD/Z2AbM
        pN0uHWLjb0D7OuoIHj3NKHDKtA==
X-Google-Smtp-Source: ABdhPJyPpOoG+ITA8Qth7yHRJ0UTqZ40dsEmeR20fRaqJI6zWCUv/9fRlYGxnAJU6IyVVjyjP3sWkg==
X-Received: by 2002:a17:907:72cf:: with SMTP id du15mr13282231ejc.167.1639616979968;
        Wed, 15 Dec 2021 17:09:39 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id s16sm1615656edt.30.2021.12.15.17.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 17:09:39 -0800 (PST)
Date:   Thu, 16 Dec 2021 09:09:32 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        codalist@telemann.coda.cs.cmu.edu,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        netdev@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        coda@cs.cmu.edu, linux-audit@redhat.com,
        coresight@lists.linaro.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Mike Leach <mike.leach@linaro.org>
Subject: Re: [PATCH v2 6/7] audit: Use task_is_in_init_pid_ns()
Message-ID: <20211216010932.GA2313631@leoy-ThinkPad-X240s>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-7-leo.yan@linaro.org>
 <CAHC9VhThB=kDsXr8Uc_65+gePucSstAbrab2TpLxcBSd0k39pQ@mail.gmail.com>
 <20211215190912.GU1550715@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215190912.GU1550715@madcap2.tricolour.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 02:09:12PM -0500, Richard Guy Briggs wrote:
> On 2021-12-14 17:35, Paul Moore wrote:
> > On Wed, Dec 8, 2021 at 3:33 AM Leo Yan <leo.yan@linaro.org> wrote:
> > >
> > > Replace open code with task_is_in_init_pid_ns() for checking root PID
> > > namespace.
> > >
> > > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > > ---
> > >  kernel/audit.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > I'm not sure how necessary this is, but it looks correct to me.
> 
> I had the same thought.  I looks correct to me.  I could see the value
> if it permitted init_pid_ns to not be global.

Just for a background info, we need to check root PID namespace in some
drivers [1], to avoid introducing more open codes, we decided to refactor
with helper task_is_in_init_pid_ns().

[1] https://lore.kernel.org/lkml/20211213121323.1887180-1-leo.yan@linaro.org/

> > Acked-by: Paul Moore <paul@paul-moore.com>
> 
> Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

Thanks for review, Paul and Richard.

Leo
