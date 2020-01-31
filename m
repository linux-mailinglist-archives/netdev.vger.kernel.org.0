Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5F14ECB8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgAaMt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:49:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41042 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728511AbgAaMtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580474994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=thKT8DzQcwLXJKx1s2Tqrpfn3G/m+H88HumfXr9NxWc=;
        b=eEwjf/AWqBfQ5OerlxCUO4KvHwQ8zPLkipgHwxWY5G8GxBJbKv1xIMEvAiEqYQht4o4O+F
        iEWB2JZEFrcLA2l6jLotyW2udU74F0xR1WOrqGj9m0FISFp9lA28Ld+qjg1XbMunbg6kbZ
        WedSrF1fq46BNUjacWKE/PtwILQjScQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Y1O6z7KyMw63FTUvrYqDug-1; Fri, 31 Jan 2020 07:49:52 -0500
X-MC-Unique: Y1O6z7KyMw63FTUvrYqDug-1
Received: by mail-wr1-f70.google.com with SMTP id a12so1612553wrn.19
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 04:49:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=thKT8DzQcwLXJKx1s2Tqrpfn3G/m+H88HumfXr9NxWc=;
        b=Eg5iTkxbeLO4+FCoIdTFsUfpi1PRD+YgFpM8zTvCubtJ6VdnZhBw58w5GQtS2sHeyO
         CumUdEmTX7UuD+vJ3LFwI7d2h5Gd40FVw4v4j8l86Pj+HSQhjI+T9CKwDhqZ+fSVE/iJ
         fZ0fmN091HIHEYtzpNmhTGkxfI7mI6UVoUL4IuwLb9wvifSp3oLL1gnCkjMhtZJc8+Av
         6mbiRmezaJlzC6njKDG2oZ2Qr/03VICKUC0mKP0co5Pg9pClM90RTd9A/Qyl0gK1MGjc
         WXb6HYfOdk+kjUCJmNBSwrmJMbRAdFDUbd3MZatvtzYvBo9R8he6IG7qkGgaeWBFbAlQ
         ZOXw==
X-Gm-Message-State: APjAAAUa4A9sm0Q+YSWYioUcaZX0XwA+wJ0pK5MfsCc6PIvAxjvreCXC
        RBffB3ekSvrrNAEAZ5Ua9zcPYRf262pb+cLj2m2tCCBAkelW1QJ+XMcdzNExjbBodCRNB9Z1Sz2
        fqzThJvij8RGyF52x
X-Received: by 2002:adf:fbc9:: with SMTP id d9mr11924083wrs.20.1580474990937;
        Fri, 31 Jan 2020 04:49:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxM7ASc38AtInotjWSWC2Pc/A62ONfB+yiop/pWc9Ree73Qlh/5cy9Wljq9h5a0DtK7fMdMQ==
X-Received: by 2002:adf:fbc9:: with SMTP id d9mr11924068wrs.20.1580474990685;
        Fri, 31 Jan 2020 04:49:50 -0800 (PST)
Received: from pc-61.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id o1sm11600927wrn.84.2020.01.31.04.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:49:49 -0800 (PST)
Date:   Fri, 31 Jan 2020 13:49:48 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     James Chapman <jchapman@katalix.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200131124948.GA32428@pc-61.home>
References: <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw>
 <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
 <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
 <20200129114419.GA11337@pc-61.home>
 <0d7f9d7e-e13b-8254-6a90-fc08bade3e16@katalix.com>
 <20200130223440.GA28541@pc-61.home>
 <95e86df4-0fff-5f41-8556-eeaede23340d@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e86df4-0fff-5f41-8556-eeaede23340d@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 08:12:01AM +0000, James Chapman wrote:
> On 30/01/2020 22:34, Guillaume Nault wrote:
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
> Yes, it sounds good to me.
> 
> Your proposed approach of using only the session ID to do the session
> lookup but then optionally using the 3/5-tuple to scope it resolves my
> concerns.
> 
Great! I'll ask Ridge to repost his patch then.
Thanks a lot.

