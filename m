Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA36F51C2CD
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380104AbiEEOra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiEEOr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:47:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A1756F98;
        Thu,  5 May 2022 07:43:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y3so9120868ejo.12;
        Thu, 05 May 2022 07:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kq7x0iDA7TltEgWIVyJIVQzjWE+OkQEjaVsIe6ZS4Ao=;
        b=E5w5ThkWzWHdHiANATxpXQPoCQYWruSW9bUtwe/DD+19o5bVlmRPjugZ9g5gY4CpV4
         +WZjTL+smXPm4544qoIoKJo16QKfwBZmoQfZKEzDLkLpCrTVDjLkQhWw3E7Le9q7SiUA
         1qwkU5ivdlBYmDvvHPhJmtvLtV2qQDACHnMhYEUcA3QGBSmifpbx5RI416Y+8i4eeT8H
         Me35vSAeRIRmFoes64+5prFJ7auN7ID+wN5YF3QBS9QrbPCZliOATskun5bkEQWIraUj
         hDTlK7ngJ3NH/i9dAzR6Ctr6tWz9h77CYdV49/ow5R9O1/lfBi3b0l+zruwchO3KHhwf
         2AYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kq7x0iDA7TltEgWIVyJIVQzjWE+OkQEjaVsIe6ZS4Ao=;
        b=XdO8k5hoVbLVQ/TyxKXXO7zh98u0YUnnQIAZHn3xWcKVyTBo35k8Xw+b6Pm6RKXc1h
         WJ6fuQT7cVdKCHK+eNM7EUxenlcI1NNlTBDxQkclEaj5uG++o0T/pvSpD69uglk7doBr
         +ht1BfEHI4lNoQyYX7mXyLwxfGRf+gZpvCq4o2ZjnzuQ0VztdQiTVQJKse7qOpGlKkCU
         8mPjQOpvyQ0FQWXiNIqg3vZ8qijkfzI9B5cZ099p1GXn/15GqsenWqYjkdUW8CIReb9z
         sVAjWcehh2G60H2q5i18TZLqd7Pm8+wnXPXbFP02P+ujyAwvkkZnaHp9VG6MSSke01Yo
         iKrg==
X-Gm-Message-State: AOAM533TZdQo6hVnhRB4Dkff/i+G2P4doPHk/TpVr3Llo36oMTFEXBT4
        SXmWUJ5u0Wu1AbmZzSm3bVA=
X-Google-Smtp-Source: ABdhPJzWi8bjq3X8ViNmZsgDBf1lKrWOyD2iZKjeIia+Ghh7CmycDZx1bK+OORnEBd+nFrKCxrEtmQ==
X-Received: by 2002:a17:906:5d04:b0:6db:7262:570e with SMTP id g4-20020a1709065d0400b006db7262570emr27108890ejt.8.1651761827682;
        Thu, 05 May 2022 07:43:47 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id jz11-20020a17090775eb00b006f3ef214e51sm793855ejc.183.2022.05.05.07.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:43:47 -0700 (PDT)
Message-ID: <6273e2a3.1c69fb81.55947.477f@mx.google.com>
X-Google-Original-Message-ID: <YnPioTGgjQd/PyRG@Ansuel-xps.>
Date:   Thu, 5 May 2022 16:43:45 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 07/11] leds: trigger: netdev: use mutex instead of
 spinlocks
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-8-ansuelsmth@gmail.com>
 <YnMj/SY8BhJuebFO@lunn.ch>
 <6273d126.1c69fb81.7d047.4a30@mx.google.com>
 <YnPdglC+QJ4Gw81C@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnPdglC+QJ4Gw81C@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 04:21:54PM +0200, Andrew Lunn wrote:
> On Thu, May 05, 2022 at 03:29:09PM +0200, Ansuel Smith wrote:
> > On Thu, May 05, 2022 at 03:10:21AM +0200, Andrew Lunn wrote:
> > > > @@ -400,7 +400,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
> > > >  
> > > >  	cancel_delayed_work_sync(&trigger_data->work);
> > > >  
> > > > -	spin_lock_bh(&trigger_data->lock);
> > > > +	mutex_lock(&trigger_data->lock);
> > > 
> > > I'm not sure you can convert a spin_lock_bh() in a mutex_lock().
> > > 
> > > Did you check this? What context is the notifier called in?
> > > 
> > >     Andrew
> > 
> > I had to do this because qca8k use completion to set the value and that
> > can sleep... Mhhh any idea how to handle this?
> 
> First step is to define what the lock is protecting. Once you know
> that, you should be able to see what you can do without actually
> holding the lock.
> 

From what I can see in the code, the lock is really used for the
work. It there to handle the device_name store/show and to not remove
the dev while a work is in progress...

But I can also see that on store and on netdev_trig the work is
cancelled, so in theory the problem of "removing dev while a work is in
progress" should never happen (as we cancel the work before anyway).

So I see the only real use for the lock is the device_name_show. 

> Do you need the lock when actually setting the LED?
> 
> Or is the lock protecting state information inside trigger_data?
> 
> Can you make a copy of what you need from trigger_data while holding
> the lock, release it and then set the LED?
> 
> Maybe a nested mutex and a spin lock? The spin lock protecting
> trigger_data, and the mutex protecting setting the LED?

I need to check what can I do to move the configuration phase outside
the lock.
Just to make sure the spinlock ot mutex conversion is not doable cause
we are locking unter a netdev notify or for other reason?

> 
> 	      Andrew

-- 
	Ansuel
