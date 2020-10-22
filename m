Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02ECF2960D2
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368078AbgJVOWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:22:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S368074AbgJVOWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603376524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k7JqFtVwFa+dlMs9LyA/sVrR2AEnGqTrz+eqvL2C9wY=;
        b=XFGn5/o+6xj30bcwKRE7au5nNW//lkSLmnbC2cxTURbN8bfdM56EL7PkJNz/m1RgILByVQ
        mJVlYOPm5K1mCNsQZOCJCB2DIe4wJThQzac823NCLO+st0NgHVYCDDZo0EX37J60mS17yp
        I72gfxl59UFrDrkTjFh+NDeu9OTCX0g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-Ms2-IknMOF-6QZUj5CC5Fg-1; Thu, 22 Oct 2020 10:22:01 -0400
X-MC-Unique: Ms2-IknMOF-6QZUj5CC5Fg-1
Received: by mail-wm1-f70.google.com with SMTP id m14so489052wmi.0
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k7JqFtVwFa+dlMs9LyA/sVrR2AEnGqTrz+eqvL2C9wY=;
        b=PoIjaZM77+u0bgsrn5WazCkHO1xopGE9gJ5YBlyeOHpAFqW6jf+gHq3KOOwED7hAeg
         G3DeHZutJqApMPFAdpxoRju/d4APxQLjl0wwmUP2zpO7b9WWcCBIu6HZa5Rr9LnBfBAz
         eaUURzeZTTutiF8omKuRe1DyGI22SMl6I1K3N6G7Ig0ew4yTqrbvZmVO1ObEIL2qBdDk
         pC3BcgMzKiqCL3EoBiiJqL4SHsGF58w+ePzhLo6VCc4/6YtJUPt+O81Td7uZFDAWifUL
         Nw/lTUbX1J2WAhOtOAOwcFjoosQLlLvk8IW376JbuPPCHJ0vOoNfflmjMldAqo/zJwKM
         vlYQ==
X-Gm-Message-State: AOAM532n8gzfWA1e65COp7QNovmx/i3fi7G+E4cTAOkQcvvnkLqiiTXe
        g4R90DGwkjYph1aUws1eAch1LE8JE8ChD1KzOYqJyYOMj1bvgDO7P64O+nKIK9UfZWVbPzI6tlz
        3wooUnFkwlfQ34mZW
X-Received: by 2002:adf:edc6:: with SMTP id v6mr2935017wro.273.1603376520556;
        Thu, 22 Oct 2020 07:22:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUY7DprQ4j+PNhsakbzDJvOyVMCbL9eumm5LqFolreay0+lvyOKn3WAXjoH7aUuWeaNSjlXw==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr2935000wro.273.1603376520376;
        Thu, 22 Oct 2020 07:22:00 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id a127sm4356805wmh.13.2020.10.22.07.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 07:21:59 -0700 (PDT)
Date:   Thu, 22 Oct 2020 16:21:57 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: Re: [PATCH v2 iproute2-next 1/2] m_vlan: add pop_eth and push_eth
 actions
Message-ID: <20201022142157.GA5100@pc-2.home>
References: <cover.1603120726.git.gnault@redhat.com>
 <a35ef5479e7a47f25d0f07e31d13b89256f4b4cc.1603120726.git.gnault@redhat.com>
 <20201021113234.56052cb2@hermes.local>
 <20201022083655.GA1728@pc-2.home>
 <4eca7616-96bd-9fab-bf15-b03717753440@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eca7616-96bd-9fab-bf15-b03717753440@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 08:11:45AM -0600, David Ahern wrote:
> On 10/22/20 2:36 AM, Guillaume Nault wrote:
> > 
> >> Is it time to use full string compare for these options?
> > 
> > If there's consensus that matches() should be avoided for new options,
> > I'll also follow up on this and replace it with strcmp(). However, that
> > should be a clear project-wide policy IMHO.
> > 
> 
> we can't change existing uses of 'matches'; it needs to be a policy
> change going forward hence the discussion now.

Yes, that's what I meant. Sorry if I wasn't clear.

