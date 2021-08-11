Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C4B3E9654
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhHKQtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhHKQtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628700519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e8eXzyZPU8ibblQCIDVI7DWbw4ntel2kHPrrgJi+qTA=;
        b=NlDgLvScaRpmW5zk5IMhWvYQRdIWIOT8C5TYKtQV4HO4z4NRCCot1lZBDmHvaqjguWW2lD
        ScqmRGiCQPGcIq3lJ5s8BOgm7dzDZ0KBTKDG/EwVW59609ztZuJcoDjGXb2duuIogVD7JB
        CFfIctwfILuwmBqlnhW54mAgZd+jkWs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-RhHhV4aiNceHIL_lX9iSAA-1; Wed, 11 Aug 2021 12:48:38 -0400
X-MC-Unique: RhHhV4aiNceHIL_lX9iSAA-1
Received: by mail-wr1-f70.google.com with SMTP id z10-20020a5d440a0000b0290154e0f00348so960821wrq.4
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:48:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e8eXzyZPU8ibblQCIDVI7DWbw4ntel2kHPrrgJi+qTA=;
        b=n+AIwhpLLvdAvLoLTO5syOf2q/rYBbNUiA+0WlnrxQtp2KwYaVyyK/R4uJ2PUVvg7D
         fJjW4nsGRccSQZ+7Q/FDqnPXG1EEpUkCsqZeIt8+hkCH3uvt/cnPyh7ELKozr1Mu8Nu5
         PB3o6q4OQfalPmVx5sQczMduHZEb1FiZdQ5ofG8EOOJCAgVRp4+gkijuoURrh+1PAz14
         qUzWqoBsNdZpqEkEz+sMeXdRnrxNZPlzIZEDPhA+zqu+99SyAGJEoSS3ml3Hq74hSvwX
         tae8kSDNEbjUTlpBzq+z/7UC4eo5eIYdtHps1WGWaUiavVySgYhk6kLyhWwc2ovfs5u5
         mAvQ==
X-Gm-Message-State: AOAM5325wgzA3r8lVqIPERyfBz5v9PE6mbqu7hbqyoY8nUeddFOIN2gN
        ncCKdCQYDwLCFYCc8jWnRJHZUekEo96ZPH4O3h8snb/eEDVIyI0a3M8D8r30xicpAhqoEtPBovn
        NcDO5NZPkDXqTsiNA
X-Received: by 2002:adf:e804:: with SMTP id o4mr37035297wrm.55.1628700517560;
        Wed, 11 Aug 2021 09:48:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQNOncaDRiHGaJuWs5datwxNgR03HcrIWLnI5EzbF2eCNHiz6yMhv1pomszASSnQhv89n2Og==
X-Received: by 2002:adf:e804:: with SMTP id o4mr37035284wrm.55.1628700517442;
        Wed, 11 Aug 2021 09:48:37 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id d8sm28116005wrv.20.2021.08.11.09.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:48:37 -0700 (PDT)
Date:   Wed, 11 Aug 2021 18:48:35 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
Message-ID: <20210811164835.GB15488@pc-32.home>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com>
 <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
 <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 02:10:32PM +0300, Martin Zaharinov wrote:
> And one more that see.
> 
> Problem is come when accel start finishing sessions,
> Now in server have 2k users and restart on one of vlans 3 Olt with 400 users and affect other vlans ,
> And problem is start when start destroying dead sessions from vlan with 3 Olt and this affect all other vlans.
> May be kernel destroy old session slow and entrained other users by locking other sessions.
> is there a way to speed up the closing of stopped/dead sessions.

What are the CPU stats when that happen? Is it users space or kernel
space that keeps it busy?

One easy way to check is to run "mpstat 1" for a few seconds when the
problem occurs.

