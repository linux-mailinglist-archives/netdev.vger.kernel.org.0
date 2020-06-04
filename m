Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BDA1EE069
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 11:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgFDJBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 05:01:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728089AbgFDJBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 05:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591261283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xh5Mj8Dm7pwISvlFLqL8NiYNfeUBsG7hGmY7DgnArSI=;
        b=fPQzV/7KRd9IVuccwoP4QK4Zaxkn+nMy17G+hkhbnAaHKEFkd9COvX8fE5lbTfWJtdrWa6
        Jfr/TOktw4bGwKujNL8VGtb3LEoYvPecb39qU3FbNG+YdBw2Ato6alSNzY69Pqev9oQyP6
        XGyATlld9INlY1OOujf768kgfB5VPGI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-uoLJFJKONNaLLaZDq-5A9A-1; Thu, 04 Jun 2020 05:01:20 -0400
X-MC-Unique: uoLJFJKONNaLLaZDq-5A9A-1
Received: by mail-wr1-f69.google.com with SMTP id r5so2153305wrt.9
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 02:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xh5Mj8Dm7pwISvlFLqL8NiYNfeUBsG7hGmY7DgnArSI=;
        b=QriDqq1qlFtrp+O6/iDNSKuhuzo1++GrkUB3q9BNUJx3IuIs4JhkZxNQkHvgUzM6Ut
         IhBOx9uuN0qn9jez2ZQvOIWFTF5W2vbdS/8RGbOb/FoK1GfWTsi87/bqFTAa3E8fzViS
         FEjnDSGJ726i+gRvMKzQ6T/LX1Om2Bdka/gpV4VYGTuWuJdHy7wyiJ8mGEGHDpSv0RUC
         pMnRQw6WZVSHeEkb2kt4EtZnKuxzlMKOvZ5aUf4KBvtBUirWyLXnW44Z/AtL0qGqN6t4
         Adnw3lJPZrmg3wVFe+hlfPy7Fe/IJ2HK4gJYN7zFK71WPLYMS5k9HsV8y189kYYNfW7f
         PdmA==
X-Gm-Message-State: AOAM530dsIK5NxylIfzlm5PhvAMpDU7UAJrpHNFiZmoAZinKWFVXhekp
        DN5td0dLWjCe+3XDK852WNLyAsyi/nitOZESTzI2l6loBjn+kolCMgaxkwMVNUUoL1X1HRaVSI+
        iTsWNskyIkQDoxeoo
X-Received: by 2002:adf:ea03:: with SMTP id q3mr3291696wrm.286.1591261279728;
        Thu, 04 Jun 2020 02:01:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/zGaMBjx21Z9cwBMj+pCZMs7uKzsNY9xUq1Big6tLAZfVUSVRfMUci1KnmD6zuRYgAJmYOQ==
X-Received: by 2002:adf:ea03:: with SMTP id q3mr3291669wrm.286.1591261279537;
        Thu, 04 Jun 2020 02:01:19 -0700 (PDT)
Received: from redhat.com ([2a00:a040:185:f65:9a3b:8fff:fed3:ad8d])
        by smtp.gmail.com with ESMTPSA id d18sm6904921wrn.34.2020.06.04.02.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 02:01:18 -0700 (PDT)
Date:   Thu, 4 Jun 2020 05:01:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 04/13] vhost: cleanup fetch_buf return code handling
Message-ID: <20200604050011-mutt-send-email-mst@kernel.org>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-5-mst@redhat.com>
 <7221afa5-bafd-f19b-9cfd-cc51a8d3b321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7221afa5-bafd-f19b-9cfd-cc51a8d3b321@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 03:29:02PM +0800, Jason Wang wrote:
> 
> On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
> > Return code of fetch_buf is confusing, so callers resort to
> > tricks to get to sane values. Let's switch to something standard:
> > 0 empty, >0 non-empty, <0 error.
> > 
> > Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> > ---
> >   drivers/vhost/vhost.c | 24 ++++++++++++++++--------
> >   1 file changed, 16 insertions(+), 8 deletions(-)
> 
> 
> Why not squashing this into patch 2 or 3?
> 
> Thanks

It makes the tricky patches smaller. I'll consider it,
for now this split is also because patches 1-3 have
already been tested.

-- 
MST

