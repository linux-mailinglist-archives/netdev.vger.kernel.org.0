Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACEA210443
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgGAGvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgGAGvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:51:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D18C061755;
        Tue, 30 Jun 2020 23:51:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o22so5564160pjw.2;
        Tue, 30 Jun 2020 23:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EGaj7xMhbOWGnkIO+rCRn2K3ekXBNvA/cE456aUFXSo=;
        b=r4hq0emIeIlOCBZFSFcjbg6UVPc+IMatEcBT4OqUme6OSerXmoMd4O4cy9AZcFkSXY
         QePH9XwEHge+UeangjH1riwtLlHuwwk3Ppmv2qTtYOLHODx/fYYOQhVgSW7l/tLoL2uZ
         0uXgcyde+tmvR+WozThx3HPiJjp57CqDSrW9MiHNeCgj6bLzmcDOLdQn5pu+1F7uUfrb
         DgtD8O9edVAsPJJtgS+/N2tBPmT97fN5mWHPXZgZd+xCiG78E8t9OjHWyExignUY4pKo
         u8EaM6vvSzMsDBDDtgNcUUqcGEWnOXYDt8CJDzogCE7WpVYkkeFydkfTNhQNQRvhDIue
         xADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EGaj7xMhbOWGnkIO+rCRn2K3ekXBNvA/cE456aUFXSo=;
        b=CgPGPHhgOEOyBX/yrR1LB9g8xejZA73It3dHDpV7mpVX6hkVu/nTN8E3tOLvgLK4yl
         Dhg+jMcdQLC4Yhd8pdbWCTUWKFgankBB38lMG87xxXnLqA67/XWbphfvcBuA8BsJArrt
         KLlwyz4NWu0rv6rRqbUP08tF5gRiiUFDpEvR3ZIVDI5mAF96mDjfiUVQ1AsfdLgKsr7q
         mkODWA1emFPm8PALAJDNFF59Peytge8MWqvvT4TTzSuDJF8rx90hbE4rbfdEkE1EyBmh
         W5YmGHeYSZOSwNNbuNpg7mW/oYfVOJBj5TuYNiU+Rh+HsCvBb/6r0vHtdIG+p+KAQ72l
         fCBA==
X-Gm-Message-State: AOAM5333WALZhTIsMgYYQHuE8OP3+00Ng0EgbuzV5C/+UG0czl3miwFt
        TV2XwmZRNZSyshW5elvHKR8=
X-Google-Smtp-Source: ABdhPJxmDX9kWylKd2zVn84/kJKZoarF1ho2myahLV6f8QZQnx82qg6kBCGguqKkEkXkm9oTN/esaQ==
X-Received: by 2002:a17:90a:9a2:: with SMTP id 31mr27066967pjo.181.1593586308676;
        Tue, 30 Jun 2020 23:51:48 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id np5sm4377555pjb.43.2020.06.30.23.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 23:51:47 -0700 (PDT)
Date:   Wed, 1 Jul 2020 14:51:37 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv5 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200701065137.GZ102436@dhcp-12-153.nay.redhat.com>
References: <20200526140539.4103528-1-liuhangbin@gmail.com>
 <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200701041938.862200-2-liuhangbin@gmail.com>
 <CAEf4BzZmwDjWZJJiuiPWD+ByDqugVA3GQSe6OJDZdd0+zf-8JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZmwDjWZJJiuiPWD+ByDqugVA3GQSe6OJDZdd0+zf-8JA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 10:09:39PM -0700, Andrii Nakryiko wrote:
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 0cb8ec948816..d7de6c0b32e4 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -3285,6 +3285,23 @@ union bpf_attr {
> >   *             Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
> >   *     Return
> >   *             *sk* if casting is valid, or NULL otherwise.
> > + *
> > + * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
> 
> We've recently converted all return types for helpers from int to
> long, please update accordingly. Thanks.
> 

Thanks, I will fix it.

- Hangbin
