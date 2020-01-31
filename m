Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055C014ECB9
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgAaMu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:50:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50079 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728500AbgAaMu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:50:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580475055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQdfYs6m1PIY/KYb2XC8zs3buJwpVsuZJ9Imcy0toDk=;
        b=UyhMdvc2K7ibwGxv3CxHWCghk4+MK+Q0q4jQ7jw/4ng+RfRlmlQS7FHUyp958shBodCcL4
        GlX4H4CawB71Ssd+fBNSXwovGh8CXGS0RW9Ojg5AxjsovsGPkRClkhZfRHrmF9YFMQHFLu
        FQWFG/gsZDM842VgVZlZMuzqxwU3TmU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-MY6XfPj8PvywJbxhz2443w-1; Fri, 31 Jan 2020 07:50:54 -0500
X-MC-Unique: MY6XfPj8PvywJbxhz2443w-1
Received: by mail-wr1-f71.google.com with SMTP id b13so3273145wrx.22
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 04:50:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IQdfYs6m1PIY/KYb2XC8zs3buJwpVsuZJ9Imcy0toDk=;
        b=sHhEKgn6dg57Mk4Z3pBeFeZmW9Ng3hgfH/4pjiQ9IAihaAZTrNoz00+F1WkVJ5Adw1
         x1hg2wZayQM6UnaHOwkudPSDWZsIiXtUWp0nYR012j+9FWfFocLjZ+WybpDkeP9UdV77
         1As1XHnqSFwvTBqr4N9urruiLx3wzPH54PVIKzhyvQZXcwc6mU8dyVpc1vgJC3FhXZKu
         5vi63oXAYL6bL4LI39clri048wwxgZWdCCkwz3vo+DBcaOkkSQuDYPKZwsqYg4VrThYa
         /DTY+ysCljMPnnXLjntZLINs6+TgM2P4bbjjSQLE4rqQeETnxShxYajoYg311qxCiWoI
         DsKg==
X-Gm-Message-State: APjAAAUDbTNAbhX2KeUQpCyTp7CHyw9uc6LKqzStnVUR4iJJkNwxxk/M
        BapSJGhuWWz0pP2iJYjjf8N+alRi+6Q0r7MKwx9duQSfthgjjW9p2G3f6+6Yx5pRp4kLcACfxv4
        7eZfGQQNhaC5bwaEg
X-Received: by 2002:adf:ecc6:: with SMTP id s6mr11551258wro.345.1580475052837;
        Fri, 31 Jan 2020 04:50:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqweB/7L086idovP3/4SPgeGs1xIZM42ItW5l1pfn10KHGPWX7CSxHQKj/qrkrY1oQZyKkUwBw==
X-Received: by 2002:adf:ecc6:: with SMTP id s6mr11551247wro.345.1580475052667;
        Fri, 31 Jan 2020 04:50:52 -0800 (PST)
Received: from pc-61.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id p5sm11546624wrt.79.2020.01.31.04.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:50:52 -0800 (PST)
Date:   Fri, 31 Jan 2020 13:50:50 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     James Chapman <jchapman@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200131125050.GB32428@pc-61.home>
References: <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw>
 <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
 <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
 <20200129114419.GA11337@pc-61.home>
 <0d7f9d7e-e13b-8254-6a90-fc08bade3e16@katalix.com>
 <20200130223440.GA28541@pc-61.home>
 <20200131095553.GA4245@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131095553.GA4245@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 09:55:54AM +0000, Tom Parkin wrote:
> On  Thu, Jan 30, 2020 at 23:34:40 +0100, Guillaume Nault wrote:
> > To summarise my idea:
> > 
> >   * Short term plan:
> >     Integrate a variant of Ridge's patch, as it's simple, can easily be
> >     backported to -stable and doesn't prevent the future use of global
> >     session IDs (as those will be specified with L2TP_ATTR_SCOPE).
> > 
> >   * Long term plan:
> >     Implement L2TP_ATTR_SCOPE, a session attribute defining if the
> >     session ID is global or scoped to the X-tuple (3-tuple for IP,
> >     5-tuple for UDP).
> >     Original behaviour would be respected to avoid breaking existing
> >     applications. So, by default, IP encapsulation would use global
> >     scope and UDP encapsulation would use 5-tuple scope.
> > 
> > Does that look like a good way forward?
> 
> FWIW, this sounds reasonable to me too.
> 
Nice to see that we're all on the same page.
Thanks!

