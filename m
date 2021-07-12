Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400C03C5E66
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhGLOgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:36:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230297AbhGLOgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 10:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626100433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PitmdPNRgB4Ww+PRriSdy+Kx9NXDX5mf2EpvY/3yxk=;
        b=fEPKpFn8Vlc5Yf5G817Tp+6R6O68aHaEko1/3ZOp9RRZPHHgBRgkiPm3Wnfr7dQGckJ6yM
        le81ZyloWJNeYTN+ropM68ZTP68/178kqnYzEQyypsrTaRMqYNF+JF0dLq0yxaJZuFdeQf
        4IQhiCDv8n7IkMWPNkxbEIFRKNUFIyg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-bG_mB-JJPUqgHRyLuufe8A-1; Mon, 12 Jul 2021 10:33:50 -0400
X-MC-Unique: bG_mB-JJPUqgHRyLuufe8A-1
Received: by mail-wm1-f72.google.com with SMTP id l6-20020a05600c1d06b0290225338d8f53so79741wms.8
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 07:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9PitmdPNRgB4Ww+PRriSdy+Kx9NXDX5mf2EpvY/3yxk=;
        b=HgQoU2c8AN+k1I3ftXNAQe2QV6kJypuo2fXGy6oJMbc705hFxauP0tuqrU8AGk0aiB
         xh/OOA6KN0h/AU/uqCaLhiqs71YmEbTaoTY7clpe8j8vlE/nReUwy4v5b5MGs5BzK54I
         lCRN08OjFqz9u47+PDgMIyzbIu2e4cVf51+r4JGq2Y9+YK3CtEUUBo8v+Hbq70uZp8+S
         CESzZ/djnPMTXXF5KLhPROhef8PepVJ3s8Uffh42IhsmHIwyPUfaZN2jJBhsf+l3wEzl
         9Tt6aWhgZdP1Kl7PWOF5X25UCTNIygafh2rsyHufrC2M9jsFVCoAmMvw8vRi5YTSjyLt
         WWpQ==
X-Gm-Message-State: AOAM530vmv1YM+Hs6AblUzZ65Y8G8DZvj8izh5ULxr1lZdlNMWsYf/c8
        V2MjLeXfSusnSITZGS3XH4JNz7EBFySi10iINx6IqFf5dmq+7yQEFv+drMRzUDUat5ziaqnu/jo
        AIrU+8S7PuP4N0PLY
X-Received: by 2002:a1c:f616:: with SMTP id w22mr14821398wmc.73.1626100429113;
        Mon, 12 Jul 2021 07:33:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwo7/l+S6G7YU2UXn+yZSJvdfO+Io6oucm/QVD2ofexZIMEu9oQUsppwcY1wySb4tK3hBHp8Q==
X-Received: by 2002:a1c:f616:: with SMTP id w22mr14821381wmc.73.1626100428873;
        Mon, 12 Jul 2021 07:33:48 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id j21sm9533358wms.2.2021.07.12.07.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 07:33:48 -0700 (PDT)
Message-ID: <08924f8e23ada7c1581f2d13e595955ed2eca262.camel@redhat.com>
Subject: Re: [PATCH net 1/3] udp: check for encap using encap_enable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Mon, 12 Jul 2021 16:33:47 +0200
In-Reply-To: <7da0e1e0-7814-4179-ba04-d578b380fd8a@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
         <20210712005554.26948-2-vfedorenko@novek.ru>
         <b076d20cb378302543db6d15310a4059ded08ecf.camel@redhat.com>
         <6fbf2c3d-d42a-ecae-7fff-9efd0b58280a@novek.ru>
         <970fa58decaef6c86db206c00d6c7ab6582b45d3.camel@redhat.com>
         <7da0e1e0-7814-4179-ba04-d578b380fd8a@novek.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-12 at 15:13 +0100, Vadim Fedorenko wrote:
> On 12.07.2021 15:05, Paolo Abeni wrote:
> > On Mon, 2021-07-12 at 13:32 +0100, Vadim Fedorenko wrote:
> > > On 12.07.2021 09:37, Paolo Abeni wrote:
> > > > > Fixes: 60fb9567bf30 ("udp: implement complete book-keeping for encap_needed")
> > > > 
> > > > IMHO this not fix. Which bug are you observing that is addressed here?
> > > > 
> > > I thought that introduction of encap_enabled should go further to switch the
> > > code to check this particular flag and leave encap_type as a description of
> > > specific type (or subtype) of used encapsulation.
> > 
> > Than to me it looks more like a refactor than a fix. Is this strictly
> > needed by the following patch? if not, I suggest to consider net-next
> > as a target for this patch, or even better, drop it altogether.
> > 
> Looks like it isn't strictly needed for the following patch. Do you think that
> such refactor would lead to more harm than benefits provided by clearness of
> usage of encap_enable and encap_type fields? 

Yes. That patch is invasive and the clarification is quite subjective
IMHO.

Cheers,

Paolo

