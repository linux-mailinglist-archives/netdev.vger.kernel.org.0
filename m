Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FBDD9614
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 17:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391462AbfJPP5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 11:57:08 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46599 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389769AbfJPP5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 11:57:08 -0400
Received: by mail-oi1-f194.google.com with SMTP id k25so20447504oiw.13
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 08:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sage.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=9sEGwNR+vs1wvXocKihgDcCfWg7F97MWXpiCKTda+Uo=;
        b=bhBw5IpPG3f7MC1dp/X9TYLBmZE/AL8nW+PBx/BxtAPR6xKfsP2aEKY9GK8XZhV/dc
         cH2ruNlDTzUUq/xMGzZDnu1Edx5oYu0sQXWhPeWYA37KQgj6fhMXdSuLPtT7VejbYfFI
         oxM3bLUnOhIuyFfM5w3akIli/6MA4AedIENPOWe6KZGse1wtkaVWwTaAbypE/nqVEwbt
         Ehsf6JIQXNqo1tqq31Mco6Aqw1gaoxIn4WEbq7ddktKN+vEPMqOAozB+AiKQKVGqPhL3
         66dBefHjoowPqoufa8yUAbONsjWCbFQvjFGaBFvJyOysOd16Jo+w7lNxW+qwjmCEffkz
         KZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9sEGwNR+vs1wvXocKihgDcCfWg7F97MWXpiCKTda+Uo=;
        b=m3OHACZpV1kpGZNa2dgD60x8YaVN/r7anzT/hxCySrMOqkD0HgSOYWWEdiD2qA49XU
         owLvur0G42vR6ncS/tP4o4AXuZ73WzxudNjqMo+jrzmXurqa4KUI9w5XO61MD8DpBXnt
         irhAiAkfDqTvpGtRmsA07w+aYQ10xlLAqnsLi7hz0Oc5ybUV6TvoUxSY2MyI0hEOw3mt
         6AE2uSBuSzL6Pf03AxEXXrGeifZW8tL0Xa/HXiUe4ickHJPCISnEhtS/TNVa9vv92UHr
         EaiGNLbxivdfdNnKgfsXP8adF1CaSSuCeV6ujMZUvTZxaI6nYhJ/XNmEFUFxfNxfKJ5y
         ApqQ==
X-Gm-Message-State: APjAAAVxS2S8Cq+L2VqS6JzqCYy3T7kxv0r1ASk7Upqgg6pdHTOd6QC+
        y4J3aOmN3I5lbQlVxq+60z2t+A==
X-Google-Smtp-Source: APXvYqyF9/9fNqu2WQyi04V/AS2P19dOaZraXWn+HvL6HDyHYW+8OHCldpiO9zJQlqVQFJQTnly56A==
X-Received: by 2002:a05:6808:355:: with SMTP id j21mr3938368oie.160.1571241427024;
        Wed, 16 Oct 2019 08:57:07 -0700 (PDT)
Received: from wizard.attlocal.net ([2600:1700:4a30:fd70::13])
        by smtp.gmail.com with ESMTPSA id n65sm7540433oib.35.2019.10.16.08.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:57:06 -0700 (PDT)
Date:   Wed, 16 Oct 2019 08:57:01 -0700
From:   Eric Sage <eric@sage.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] samples/bpf: make xdp_monitor use raw_tracepoints
Message-ID: <20191016155701.GA18708@wizard.attlocal.net>
References: <20191007045726.21467-1-eric@sage.org>
 <20191007110020.6bf8dbc2@carbon>
 <CAEf4BzacEF0Ga921DCuYCVTxR4rFdOzmRt5o0T7HH-H38gEccg@mail.gmail.com>
 <20191016042104.GA27738@wizard.attlocal.net>
 <20191016153426.1d976f17@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191016153426.1d976f17@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 03:34:26PM +0200, Jesper Dangaard Brouer wrote:
> On Tue, 15 Oct 2019 21:21:04 -0700
> Eric Sage <eric@sage.org> wrote:
> 
> > I'm no longer able to build the samples with 'make M=samples/bpf'.
> > 
> > I get errors in task_fd_query_user.c like:
> > 
> > samples/bpf/task_fd_query_user.c:153:29: error: ‘PERF_EVENT_IOC_ENABLE’
> > undeclared.
> > 
> > Am I missing a dependancy?
> 
> Have you remembered to run:
> 
>  make headers_install
> 
> (As described in samples/bpf/README)

Yes, I've done that. I've tried:

  make mrproper
  cp /boot/config-5.2.18-200.fc30.x86_64 .config
  make olddefconfig
  make headers_install
  make M=samples/bpf

which ends with the errors I described.
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
