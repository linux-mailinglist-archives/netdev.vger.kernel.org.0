Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE433ECED9
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 08:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhHPGxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 02:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbhHPGxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 02:53:32 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2ABC061764;
        Sun, 15 Aug 2021 23:53:01 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gr13so779861ejb.6;
        Sun, 15 Aug 2021 23:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cp2iIqkS3nq9qSvD8DNeoWJwVYTZyNF0KPecSRrnaDs=;
        b=kV37+LmlDsuUDNmc70tAzK4kkxK/3n6A9iTjGvh2o5DYbAr8YGxD6P4ZD84i/HjRbq
         +US1vza9Q9UgZA2DwyiA6Gx1OIuRdBNiiF5NkuVT8IP4oc40gCphYV+212nOyXJKPnEl
         gzSciLC3FAI9hofzoyWDOUi52/tLdrUhUQzowMuM2VqLTqNzD4W8xk9noHvrbGA9eJ0d
         TG1PGIaaF2N7XwvIa39w6em231hfF0RcjrdBQy7ZJwc68bpmMOYrwQ2pxSsaYCuMCFOq
         9OhcjCDdgoLbc6XrzIcRNiflbDhR5oh8nNToR6vljyvX9tIDy5on45QckbRdocBiJ8sU
         H0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cp2iIqkS3nq9qSvD8DNeoWJwVYTZyNF0KPecSRrnaDs=;
        b=kgHT1r8qxsh5B5nY/tRWX3p3P3+z22dJG7kNCUSSuIoKa3BjmPYsD42v2ifEWoMwnH
         GJ/Aj/8IfmREgzmU0MBwRf2Ceb91c/P3Qu8zTo5OszV1frRzcX28GS/lsBvm88OTnNTk
         MirtOGaUdnZELw60QKlBf5XsqXAOfHQgfqjB4y/DrF17o4pokgLLECd30jy6Poak5sgE
         XnyxTheD5zkS3roqL1e3cNCrDuPuDUuixJWWdXdjoQ5RwFWrxxDL/CvqqDey0dHhk0np
         Xk/c0KHc82c7k+dENHxRghXEnzy+RMfJCvAYGFIniqEwSSxq56lHRFWmZTWA8avuvo3A
         WTyQ==
X-Gm-Message-State: AOAM532nE0UD5ft6odC2lcPWo9xVugbkaAO+3rMFaMhs7QLE9832yYMe
        TZaGgz99KYl68s8kDTd3+6meyzUj3JQ+cw==
X-Google-Smtp-Source: ABdhPJz8LXaEunDN2fgDjwNxryqHK61pLn60YLmH1jeXuDmhQIcCe6oHjwn/URjvVFqI1q0CV6HCxQ==
X-Received: by 2002:a17:906:e245:: with SMTP id gq5mr14432229ejb.121.1629096780234;
        Sun, 15 Aug 2021 23:53:00 -0700 (PDT)
Received: from eldamar (host-82-55-38-10.retail.telecomitalia.it. [82.55.38.10])
        by smtp.gmail.com with ESMTPSA id v12sm1305843ede.16.2021.08.15.23.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 23:52:59 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Mon, 16 Aug 2021 08:52:58 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, tuba@ece.ufl.edu,
        netdev@vger.kernel.org, kuba@kernel.org, oneukum@suse.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] net: hso: do not call unregister if not registered
Message-ID: <YRoLSvowhZsyKbOk@eldamar.lan>
References: <20201002114323.GA3296553@kroah.com>
 <20201003.170042.489590204097552946.davem@davemloft.net>
 <20201004071433.GA212114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004071433.GA212114@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg, Tuba,

On Sun, Oct 04, 2020 at 09:14:33AM +0200, Greg KH wrote:
> On Sat, Oct 03, 2020 at 05:00:42PM -0700, David Miller wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Date: Fri, 2 Oct 2020 13:43:23 +0200
> > 
> > > @@ -2366,7 +2366,8 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
> > >  
> > >  	remove_net_device(hso_net->parent);
> > >  
> > > -	if (hso_net->net)
> > > +	if (hso_net->net &&
> > > +	    hso_net->net->reg_state == NETREG_REGISTERED)
> > >  		unregister_netdev(hso_net->net);
> > >  
> > >  	/* start freeing */
> > 
> > I really want to get out of the habit of drivers testing the internal
> > netdev registration state to make decisions.
> > 
> > Instead, please track this internally.  You know if you registered the
> > device or not, therefore use that to control whether you try to
> > unregister it or not.
> 
> Fair enough.  Tuba, do you want to fix this up in this way, or do you
> recommend that someone else do it?

Do I miss something, or did that possibly fall through the cracks?

I was checking some open issues on a downstream distro side and found
htat this thread did not got a follow-up.

Regards,
Salvatore
