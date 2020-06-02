Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35951EB5CD
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgFBG2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBG2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 02:28:18 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DE5C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 23:28:18 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c71so1687576wmd.5
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 23:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qb1htMCVM8PIV/AeFxuneJSVBLB/b0Sq14mlHLXwafI=;
        b=1YSbRo84I7RQlpA4EiarKNOI50tFPnPE7ZYd3fVla+xtGBbrUXXIo4K09+sCX/RiPp
         hAJ3tLLmokN9mhft8fYeUoJkMqLaehlC6xys97q+xYDHR3n/YrxKqxZfKMKjGZWSdfww
         GNjAyjcpfAkyrZ9Qle+GjBRw0qM3yaRE1tsUO+l+vGlBmCqzX9dDRIjnjs+xFmZHdpTR
         iwrTW5KHO5WdBv7Ra8itxynVs9UwdnsNcz86VwY848gjEoH0KfoSfL7KnMWRHiXgdXKl
         UhEa8f4qCEd5NeS46B4gxFQLWKtvxlR+8pi64WemRF6VOy2efuVFN6yYDp2gdG7oU/gn
         +HkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qb1htMCVM8PIV/AeFxuneJSVBLB/b0Sq14mlHLXwafI=;
        b=Bpn7Cs9lOK8z4qV6ykmaX5G+Adz+johTv6hUEhGPtrIaw2RPwT1Gl32T3yvjng/5bF
         /Gf0h3VU9/bDExmQKXpOK25bt3V9CFLyGekEvRf7jbZFxESgw1OaeCe5eLd7LLOUi9Iw
         dmptE6kRNmh8BxViwO7HrK8Ak3g3d334eaGPuTyvX0Ii7I4y2vJtWAEiDjZ8OpqYeJLw
         LKBieFqR/jZAY1JV6Eq+G1iYfpYv9BDszGMyBA9OH6qTOcL0SVIYQSxhyBs3bBIyMq9L
         0Xq53LO6YB0GC6kYBtLo4LrhCuWkOIHcQXrHVcsZ56JBx9ZyobvYfwWHYH2fyj5d7elQ
         Az0A==
X-Gm-Message-State: AOAM530arvuLlXVAYLjBh7nc2wzC3MXO9NCVr90un9+W5gtUqVCkUhZ7
        GYn/D+sP2kd1BZAX5zc2i+sj1g==
X-Google-Smtp-Source: ABdhPJxI6yN5ZH3EPXU1qaGjNpK8j83bKiqvBu3FtRC+XUCz2LpVqGslkC+MkzvdFt19ITcx8Hgo2w==
X-Received: by 2002:a1c:1b17:: with SMTP id b23mr2561703wmb.3.1591079296847;
        Mon, 01 Jun 2020 23:28:16 -0700 (PDT)
Received: from localhost (ip-89-177-4-162.net.upcbroadband.cz. [89.177.4.162])
        by smtp.gmail.com with ESMTPSA id b81sm2258171wmc.5.2020.06.01.23.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 23:28:16 -0700 (PDT)
Date:   Tue, 2 Jun 2020 08:28:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200602062815.GS2282@nanopsycho>
References: <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho>
 <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho>
 <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
 <20200601063918.GD2282@nanopsycho>
 <20200601144436.75bab03f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601144436.75bab03f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 11:44:36PM CEST, kuba@kernel.org wrote:
>On Mon, 1 Jun 2020 08:39:18 +0200 Jiri Pirko wrote:
>> > If the permanent (NVRAM) parameter is true, all loaded new drivers
>> > will indicate support for this feature and set the runtime value to
>> > true by default.  The runtime value would not be true if any loaded
>> > driver is too old or has set the runtime value to false.  
>> 
>> This is a bit odd. It is a configuration, not an indication. When you
>> want to indicate what you support something, I think it should be done
>> in a different place. I think that "devlink dev info" is the place to
>> put it, I think that we need "capabilities" there.
>

First of all, I think we cleared that up, params are not used like that
in this patchset.


>Could you explain the need for "capabilities" under dev info?
>
>I don't like catch-all mechanisms in principle. Better if capabilities
>are expressed by the API dedicated to configuration of a given feature.

I see. That makes sense. I was thinking about that, some capabilities
are per port. I think that a simple attribute would do.

>
>In this particular example the ability to do live reset is clearly
>expressed by the presence of the parameter (as implemented by this set).
>
