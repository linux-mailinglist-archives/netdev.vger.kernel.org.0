Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C088A295A7C
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508136AbgJVIhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:37:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503152AbgJVIhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603355822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eGQZb/KXMIHaskS+Kcn9Rje/EuhYhf4evjpU37MP9eQ=;
        b=gNzXS/5ea/iidfZwu0pV5OZHJKrIP3JYZER701IbYtArwpm1dzUI2MIF5DsGK5qP+5eiJB
        tTqB1I0rWGxTRJ+URF0BySL6G78QjOYksRdPPmAhECzEsu8KDMt5rMMYVNCRa5zJ9ybE3y
        ZC5OWqow0M15wUm9WWiPo8ZdRAPeA1g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-qhuDEXaTMY208_UWPnEjvw-1; Thu, 22 Oct 2020 04:37:00 -0400
X-MC-Unique: qhuDEXaTMY208_UWPnEjvw-1
Received: by mail-wm1-f70.google.com with SMTP id g71so337770wmg.2
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 01:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eGQZb/KXMIHaskS+Kcn9Rje/EuhYhf4evjpU37MP9eQ=;
        b=Rh/WxC2SOlwZfK5SFXZ43EtIpfyvtCKiTd1TF0UWyGYtEsCH9v8WZuqeUyFAEPQmW5
         ifSwxyW1PW9NtZa9LkH5fzZYshFU7Zf5qjPq2RMQEyro9Wpo5FOn7fpXbcDXguVpheWt
         MEyHzDl7IVUvUCQye0wAsYz9jynh4YprX5etNGBukSx3qGuZFPuly4zJlpXVk+pJhP5T
         UVEmv88NVcKcZufm1hb4AHaCf85f30s2jyz2Dcjttdb/lI3iL6Bfk26BZz7aEnuP8Qgq
         PwcX3rYAd8Htw1KEIAQydfkchLTDo2r9rPmf/rMsqPN/P9XlDB2tddeqjeQ7KtZkOepV
         6nbw==
X-Gm-Message-State: AOAM533/9e7KbTb5qQPRldK2rcq3GhN36EAqHOFLa7zskKkvfevTxB7s
        /Wj8jOWoXsvUrvEyJ/Nhtl4/DamfBKS5r/VwcmTCqNBir6uaW0FFlczSu7FPCFwiQWlIXgF1jqE
        sYvPczrx5IjCt3DI2
X-Received: by 2002:adf:e8c7:: with SMTP id k7mr1473739wrn.102.1603355818333;
        Thu, 22 Oct 2020 01:36:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztu6pjDuig7uOEbV4MQZd6NtskL1eF1nPF+owKxj5iWxg1JtVVjS/r0BEnbJiHITxRPlNHEw==
X-Received: by 2002:adf:e8c7:: with SMTP id k7mr1473725wrn.102.1603355818154;
        Thu, 22 Oct 2020 01:36:58 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id y4sm2236666wrp.74.2020.10.22.01.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 01:36:57 -0700 (PDT)
Date:   Thu, 22 Oct 2020 10:36:55 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        martin.varghese@nokia.com
Subject: Re: [PATCH v2 iproute2-next 1/2] m_vlan: add pop_eth and push_eth
 actions
Message-ID: <20201022083655.GA1728@pc-2.home>
References: <cover.1603120726.git.gnault@redhat.com>
 <a35ef5479e7a47f25d0f07e31d13b89256f4b4cc.1603120726.git.gnault@redhat.com>
 <20201021113234.56052cb2@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021113234.56052cb2@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 11:32:34AM -0700, Stephen Hemminger wrote:
> On Mon, 19 Oct 2020 17:23:01 +0200
> Guillaume Nault <gnault@redhat.com> wrote:
> 
> > +		} else if (matches(*argv, "pop_eth") == 0) {
> 
> Using matches allows for shorter command lines but can be make
> for bad user experience if strings overlap.
> 
> For example 'p' here will match the pop_eth and not the push_eth.

Well, the action names are tested in the following order:
  * pop (old action)
  * push (old action)
  * pop_eth (new action)
  * push_eth (new action)

Therefore, 'p' matches 'pop', thus retaining the original behaviour.

I realise that for m_mpls.c, I put the 'mac_push' action before
'modify', and thus changed the behaviour of 'm'. I'll send a patch to
move the 'mac_push' test.

> Is it time to use full string compare for these options?

If there's consensus that matches() should be avoided for new options,
I'll also follow up on this and replace it with strcmp(). However, that
should be a clear project-wide policy IMHO.

