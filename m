Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3871802B1
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgCJQBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:01:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45354 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726913AbgCJQBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583856098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hL7G/7r8D/a1fNb9RcQkn8oY9S6QSw32jUrSTW5+CpI=;
        b=MfI1BDR7Q1aAtxRCehDtYz4FwYIIzvSD5AG6t5+VPtMulmbMAVwnjMMPtFOAXRf3qndBT/
        qQXM5eE4upSjfz+jwv5Gukb/GaDObchxjxJHCmLkdLszI55s7WE1iSh58CI0uxTRckXvV0
        yqmb3hBNlz5+S5vZgtgMvHKlZyaeJ6U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-ihv-l3JnOC2WfsY0PX4oBA-1; Tue, 10 Mar 2020 12:01:36 -0400
X-MC-Unique: ihv-l3JnOC2WfsY0PX4oBA-1
Received: by mail-wm1-f69.google.com with SMTP id f207so555898wme.6
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:01:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hL7G/7r8D/a1fNb9RcQkn8oY9S6QSw32jUrSTW5+CpI=;
        b=kklFwsNeJSH+aLyj1O6A1rgHxoKbl5j3rbcx/GGbF2BmUPZO3aHqZVlQ3xAwSdD7Y5
         9Di1rBYPlrlylr/PIAJctQ9I1bdtYADt3eU6LcpQOCVYU7IQpEmbOeVqjqZdGcSmB1xb
         UFpPAr5r6F976vbotlp/dip9NCBwDEoTl2EvPOBURWN/vX6KlZzp/MmTAOvZWk2LHTyv
         jEJphrJPEc0gCxx6jerPoF+3lPcBVYGIa0A6+oPEgZi6vFAafFZIGI0A6GK7cWt6EYO6
         XM4sFDn3nAJ+bmo9Ns9KNbS3raWJajWlwOoQ8if1tc7zIhKYZAoOxq057g18JWjYcNYR
         sXIQ==
X-Gm-Message-State: ANhLgQ3UgIgi8AxJ6wpySz4Qs3vybF9c6WpIRYeqV3LZplajGI9nJKZt
        wVaEXw0Rv8/5dGe52kTmZBoZE/Y451ay9jDm0WTdEgT7q8kVrX0Ee5hPsgdwHh1QOBr+r2s3ZH/
        4AMtJkfGEaeeias1v
X-Received: by 2002:a5d:4450:: with SMTP id x16mr28537310wrr.106.1583856095434;
        Tue, 10 Mar 2020 09:01:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuHScaDOBnNmd3n32aRR1KhDwLOo3jHmrlWifwIq4FXfPUAjXuiFSwqKHtMTUY9BnZEOcD3Kw==
X-Received: by 2002:a5d:4450:: with SMTP id x16mr28537287wrr.106.1583856095272;
        Tue, 10 Mar 2020 09:01:35 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id o11sm57514235wrn.6.2020.03.10.09.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 09:01:34 -0700 (PDT)
Date:   Tue, 10 Mar 2020 17:01:33 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, mmhatre@redhat.com,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>
Subject: Re: route: an issue caused by local and main table's merge
Message-ID: <20200310160133.GA7670@pc-3.home>
References: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
 <1441d64c-c334-8c54-39e8-7a06a530089d@gmail.com>
 <CAKgT0UcbycqgrfviqUmvS9S7+F6q-gMzrz-KKQuEb77ruZZLRQ@mail.gmail.com>
 <20200310155630.GA7102@pc-3.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310155630.GA7102@pc-3.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 04:56:32PM +0100, Guillaume Nault wrote:
> On Mon, Mar 09, 2020 at 08:53:53AM -0700, Alexander Duyck wrote:
> > Also, is it really a valid configuration to have the same address
> > configured as both a broadcast and unicast address? I couldn't find
> > anything that said it wasn't, but at the same time I haven't found
> > anything saying it is an acceptable practice to configure an IP
> > address as both a broadcast and unicast destination. Everything I saw
> > seemed to imply that a subnet should be at least a /30 to guarantee a
> > pair of IPs and support for broadcast addresses with all 1's and 0 for
> > the host identifier. As such 192.168.122.1 would never really be a
> > valid broadcast address since it implies a /31 subnet mask.
> > 
> RFC 3031 explicitly allows /31 subnets for point to point links.
That RFC 3021, sorry :/

