Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856E7474BD2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbhLNTYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:24:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234275AbhLNTYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 14:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639509850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e4Q8118ENBQYjhr6wcWrNWaO6sryVap1pJx/SOnhAKM=;
        b=eU1UMpE7FlCWLUH447CSdg0vyoSv9mRaCSFouLM59FOF0YZ3rEXKMeq1ETt1yiCjACr8nN
        qqS9GzzsDtyWBXvh0LFFfbi95wpNHW8yn7c/MD2XVp5dK9qRYg1GE9CK+bN+I80MUiRBU+
        20M3RrbueZzqTXeB9RhGHZyDwg64HDk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-VvSMF12CMUemaJS174UDfA-1; Tue, 14 Dec 2021 14:24:09 -0500
X-MC-Unique: VvSMF12CMUemaJS174UDfA-1
Received: by mail-wm1-f69.google.com with SMTP id o17-20020a05600c511100b00343141e2a16so5668619wms.5
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 11:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e4Q8118ENBQYjhr6wcWrNWaO6sryVap1pJx/SOnhAKM=;
        b=SwCursVe5tR8lYnE9J9JXnMDeRfAYlP30g8G4/CSJPlT8824QTd/Uprpvx8zHZMaqm
         t1mo9vpqdQ4yMNxTrrTSXNJywQ6dcqXKowoy4SLKkXBJT/WTsrAnpOLeOrudSW8ElUK3
         ykbbZ5NjTyyGl0W8Wk/zoFb/VGQzbu7sFvuWfJwjONK008b5GKv1jkcGBL4/C4ri0PE6
         6z+6+wEABrnm3lx9ZvCd09pZFTegkR3kM33P2+bZupWRxHONcIx/5lsUsrg7LLCh/nQ+
         FTF6bNWx567l4XcYSfnr7m62lPrjKWX/c0YnDVmQzqgvNFVGkckPy8/ZSxrmYhjvCpQ+
         Zo8Q==
X-Gm-Message-State: AOAM532pd3o88SoEnX+Finh1oX+qZJ6Nf/AusbOcL8WCvJYP65+/7Y6M
        VjJvzcppFL0xsNhzF5dS96IllldF8MLY2q/XnJD9aOyKNZiubMCp5Iiy5H7xB8FIhqWl2TK+F1U
        H4K/vBlMZiIb4o2UF
X-Received: by 2002:a5d:680d:: with SMTP id w13mr1110941wru.674.1639509848136;
        Tue, 14 Dec 2021 11:24:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytgoR8EM7vHvk72s+mTvIGtC/SrwEek3WpV6/VPwuCkKsg2ABmxU38d5C2z2fPxriC2ttosg==
X-Received: by 2002:a5d:680d:: with SMTP id w13mr1110918wru.674.1639509847910;
        Tue, 14 Dec 2021 11:24:07 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id c1sm726909wrt.14.2021.12.14.11.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 11:24:07 -0800 (PST)
Date:   Tue, 14 Dec 2021 20:24:05 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     Russell Strong <russell@strong.id.au>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
Message-ID: <20211214192405.GA4239@pc-1.home>
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
 <20201124152222.GB28947@linux.home>
 <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
 <90fbc799-a9b2-beb1-68b0-2b9a9325b29b@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90fbc799-a9b2-beb1-68b0-2b9a9325b29b@westermo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 04:58:14PM +0100, Matthias May wrote:
> 
> Nevermind, i found Guillaumes talk at LPC on this topic and what the plans are to go forward.

FYI, there's now this RFC:
https://lore.kernel.org/netdev/cover.1638814614.git.gnault@redhat.com/

Note that it doesn't yet allow the use of high order DSCP bits in IPv4
rules and routes.

