Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943925A471
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfF1SqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:46:21 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:42316 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfF1SqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:46:20 -0400
Received: by mail-qk1-f172.google.com with SMTP id b18so5685249qkc.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nz6pAldSAPretIvUM/aJByGgNXEUMa7Xf5lFKwhAYt8=;
        b=wiIMzPqJ1h2GAAV2zIScQmJLVRjE3APEXJfWupDT/MDakM5z2oINHI/pGEp8Cpjexk
         /VXd221ZHGcRQCFdKCHWj712MhgAkMjGOfoPsbJ+WKMmy0dFBfABLoS6CVKFqXzofge2
         NN2D6bthLwZPlsfl4L0JB82DkzNxEDdadpbmDXBJeVtpF/lGQQHkYw3bPfq+TyDjGgE6
         GM3U99ovYHd3D2FAzh/CdGunOO0czM68E+ZnI+GUY4xvwwkfjcv8qQUwf2s/2sUYGvpD
         w9gwU193Qy9vAmcdYfK1obFe4viFLJjDvF3U24GIafFLUoLEuyVSo1eSEr5ksGuu7C+B
         dwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nz6pAldSAPretIvUM/aJByGgNXEUMa7Xf5lFKwhAYt8=;
        b=R8tXzzQygRIV2FJLK8M1WWuXUhgD3oZG1bnSTatwkBE71lcKGWetddgfSb+Lcc/VOw
         KxIW5Re4L10JQ7f19nDdKTUA04cFmfjw4XtpdYz5YXldUWzhkXpmxn8q4weg9P2GUxaK
         7kXxwd5wzwEmVbAZyJu/qr1M3oVYyo3dfqp8KotGWhcsGX3lUTgUHRfe6ObP1Qm5tM5K
         JaAN3u2YrtMlaHMMl2Ih9KX8pWPjPprrns1ijuulFiaLACv+/TiMYcOP1Hvf+QxGwhwz
         g5aebtxQTqRaNbNLfljwJoaTg4bEMq33g9RNJbd+h9kv/NseUIQimhwCZG0PseGYGGzw
         4hEw==
X-Gm-Message-State: APjAAAXfWqVi5ZEot/8uLeRniZ1zyFpKfcAW5+4I4k9Vyj3IqVE5Gv6M
        Js8xntAGShC2nmeRnbvLwlaJng==
X-Google-Smtp-Source: APXvYqyIXXIIWd21G9Nspb06PgiRXPD8RIRKKdtk6cxeayZIbJ1kPQEz4Gje8C2fvxr+fHQlJOV1sg==
X-Received: by 2002:a37:f90f:: with SMTP id l15mr9819614qkj.480.1561747579819;
        Fri, 28 Jun 2019 11:46:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 42sm1417809qtm.27.2019.06.28.11.46.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:46:19 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:46:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute
 Engine Virtual NIC
Message-ID: <20190628114615.4fc81791@cakuba.netronome.com>
In-Reply-To: <CAH_-1qzzWVKxDX3LaorsgYPjT5uhDgqdN3oMZtJ2p6AzDqRyXA@mail.gmail.com>
References: <20190626185251.205687-1-csully@google.com>
        <20190626185251.205687-2-csully@google.com>
        <20190626160832.3f191a53@cakuba.netronome.com>
        <CAH_-1qzzWVKxDX3LaorsgYPjT5uhDgqdN3oMZtJ2p6AzDqRyXA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 10:52:27 -0700, Catherine Sullivan wrote:
> > > +if NET_VENDOR_GOOGLE
> > > +
> > > +config GVE
> > > +     tristate "Google Virtual NIC (gVNIC) support"
> > > +     depends on (PCI_MSI && X86)  
> >
> > We usually prefer for drivers not to depend on the platform unless
> > really necessary, but IDK how that applies to the curious new world
> > of NICs nobody can buy :)  
> 
> This is the only platform it will ever need to run on so we would really
> prefer to not have to support others :)

I think the motivation is partially to force the uniform use of generic
APIs across the drivers, so that re-factoring of core code is easier.
Do you have any specific pain-points in mind where x86 dependency
simplifies things? If not I think it's a better default to not have it.
Not a big deal, though.
