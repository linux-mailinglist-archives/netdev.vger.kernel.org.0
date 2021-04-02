Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD07A352DF2
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhDBRAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBRAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:00:21 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88009C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 10:00:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gv19-20020a17090b11d3b029014c516f4eb5so1041268pjb.0
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mjhdWdxhulnEwCie232G/07GzPUc1kE9v9ZDq5mv/CA=;
        b=rk7pH6eUkvyXSZkzYoflb1ndht4LSToY+3jL01kky3thWVEfOUkyVilNN0HjPpclRj
         68u47ztcPLK3R2UKox1cSRnFBHfS1RGrdXW+845jzBSwhOgcCKzsICeAEg4AwqhknWQh
         zwmPysHbITpGGCP6UZ76/1u8J04W0Pbmr+t7n/CTuU0Bny26UyFPwtw/G+/CAItrvt6T
         a765bcMujV4bqMFrtkPzwJfk+Qc2CC1HphFkD7IlM4oA1c9Cd69B95gg/Vx63vz3aBb2
         xTnsSDNLJzTBcefyDes0PqxcfCdsk/oF9wWardw+DO99ceQqx7XjMMBgUVh9YrqB2VaH
         OFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mjhdWdxhulnEwCie232G/07GzPUc1kE9v9ZDq5mv/CA=;
        b=kTgXgcKy7GWnM8dxqlGLtegWysrHm+krUvVF99Flqo6K67MXalEq+jgBbGmM9VGi7m
         oiRl5P1QofGeBPcJ7QWaynJnesYvHF3tcWff+syWQcmjdtmqzOC3TUcUqbr0TcL5l9fv
         meaQG1STBbFGZExVbo7ZJ+emg0pu5pXpWJLyk7F1ehCKW/F7uA6mdp+Z3oBupFVBIUyP
         VNiIlBb1WW9TGK3BGJ+7ecAwqc2c5bunKdJbkzcdvzQUPKSkFzD9bDFgfyAyQ78AN5tR
         RMw8f+YjfqrU2+6oK7PtMd7prp7QWSkpNRPQEj/YO3SBKkpiYbpvGNps3HZ5hYCrKpe7
         eFJA==
X-Gm-Message-State: AOAM53067x3yKu1GMhajaOSnZN3L+GobpiXWrwExv65DrLTHUzZ6Y6Zp
        bIoGRnLSUxKmS2/unrQdjE0=
X-Google-Smtp-Source: ABdhPJxpRcZ9L2nhteb2vnf0u0vkZhhZ1FPXYsBOpIrGbCeNlnO8D983RiR708DYz49sm80/eer7Sw==
X-Received: by 2002:a17:902:9b8a:b029:e6:17bb:eff0 with SMTP id y10-20020a1709029b8ab02900e617bbeff0mr13522569plp.54.1617382817401;
        Fri, 02 Apr 2021 10:00:17 -0700 (PDT)
Received: from gmail.com ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id o1sm8773716pjp.4.2021.04.02.10.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 10:00:16 -0700 (PDT)
Date:   Fri, 2 Apr 2021 09:57:52 -0700
From:   Andrei Vagin <avagin@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: Re: [PATCH net-next] net: Allow to specify ifindex when device is
 moved to another namespace
Message-ID: <YGdNEADhQnT+Jmi7@gmail.com>
References: <20210402073622.1260310-1-avagin@gmail.com>
 <20210402082014.y6efckcpx3y7heo6@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210402082014.y6efckcpx3y7heo6@wittgenstein>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 10:20:14AM +0200, Christian Brauner wrote:
> > @@ -11043,6 +11046,11 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
> >  			goto out;
> >  	}
> >  
> > +	/* Check that new_ifindex isn't used yet. */
> > +	err = -EBUSY;
> > +	if (new_ifindex && __dev_get_by_index(net, new_ifindex))
> > +		goto out;
> 
> Should this maybe verify that the new_inindex isn't negative and reject
> it right away? (Maybe also right where we first retrieve it?) Otherwise
> __dev_get_by_index() might pointlessly walk the whole netdev list for
> thet network namespace.
> 

I think __dev_get_by_index works fine for links with negative
ifindices, but there are other places where we expect that ifindex is
positive, so I think you are right, we need to check that it isn't
negative here and we need to add the same check in register_netdevice
too.

Thanks,
Andrei
