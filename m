Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12C231031F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhBEDIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhBEDIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 22:08:46 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97665C0613D6;
        Thu,  4 Feb 2021 19:08:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e12so2840540pls.4;
        Thu, 04 Feb 2021 19:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oNJHnSGkP+kQDXr2FFghkHFTFu/z2VD8y2pNxAngS04=;
        b=hEwylsyJ8ahYa+0TPVivLT/oFW0ycOAMmeGBt2dCLZUKs0QX8ktEwpXZH4G6Ig7yub
         aJSd9e4ao79qE8wFKFgi9FIMmHjv5HAjRXIg2NCocW6am7D5T1A3zRqyhErq+7nCSETG
         cpDpROrTTQx+fuS6liaIbTANhVT0rROhUPEuob77gS6a7zgnYAaG8mZIFgEBp0dqaD7e
         zPdO+F6h6bqQi3A5VYqudYBK7/KDUkpTqjz6lfP5xjsaXibqoFBhLrivdWxujWAHpSpY
         TFk9iDGICrtRZ6icndZjJsCfCQIKrObgzejgUB0RGZlgrr5WuaByxm2P1DCP/cbJe7QH
         X1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oNJHnSGkP+kQDXr2FFghkHFTFu/z2VD8y2pNxAngS04=;
        b=iX8td2VzTQt032Oxt+QhwdXM37OYmwSyKevbzN4In56aPZVdrHYcyaybeB0mr9+flD
         1cprVLcAeEpXEgDAyaFSStd0ZkVlWQBjjRdkCHGurWYmL7KUgmbxwsCe9Hfp4YttPyuL
         OzaXNU2W9LYWCyU3jQGpZx3HubzEBqu7jEbIMPPqcldJfb2v8SZYuvtcuv2ZCOZP8I5d
         i9kNxiFalw+cOBvqWexrFfgpxfmEiI75Qqc3KlfdHoYh8n6Szt8T1d2wI7+6U+NOFLVw
         bLxdb2ClucD7N1QOUe85plOQMBxOw4mSAusPcryAkfHpI08CCcAvIeCig4is28meqMJi
         ygrQ==
X-Gm-Message-State: AOAM5310zurExMt3+fZbUXjf29gU84nvwbq/coXeBHYu6cjlsLfOzEw3
        cdHm19EEZbzoxMZ99xB/vzk=
X-Google-Smtp-Source: ABdhPJwFGwM8GZoF33Zt8nLs99SQO9vgnFOmsfGm9F9N6l8tA+FUDqzXVwmFKV9g3kBIPQ2Q1Wd9Jw==
X-Received: by 2002:a17:902:bc4c:b029:e1:2c56:c743 with SMTP id t12-20020a170902bc4cb02900e12c56c743mr2275890plz.66.1612494480112;
        Thu, 04 Feb 2021 19:08:00 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s126sm3060677pfs.81.2021.02.04.19.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 19:07:59 -0800 (PST)
Date:   Fri, 5 Feb 2021 11:07:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv17 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210205030745.GE2900@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210204001458.GB2900@Leo-laptop-t470s>
 <601b61a0e4868_194420834@john-XPS-13-9370.notmuch>
 <20210204031236.GC2900@Leo-laptop-t470s>
 <87zh0k85de.fsf@toke.dk>
 <20210204090323.14bcbaba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204090323.14bcbaba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,
On Thu, Feb 04, 2021 at 09:03:23AM -0800, Jakub Kicinski wrote:
> New patchwork can actually find messages by Message-ID header.
> 
> Just slap message ID of one of the patches at the end of:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/
> 
> And there is a link to entire series there.

Thanks for the tips.

> 
> Since I'm speaking, Hangbin I'd discourage posting new version 
> as a reply to previous posting. It brings out this massive 100+
> message thread and breaks natural ordering of patches to review.

Thanks for the reminder. I will not reply to previous version and
will only use a link in future.

Thanks
Hangbin
