Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B21AC113
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 14:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635484AbgDPMV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 08:21:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49789 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2635424AbgDPMU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 08:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587039654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N//aUi9ilfSYZbtt9uubNhdLlMHa9VPzC/9aWc7u2N4=;
        b=TV6CBrEOpmWjIdSjNFIyBBxbVxnW1vZwBpM+nEFbziHjfTD1lMafWgBfFgYEMhlzSjVvFP
        43eL+wswiT81sTOO5cNMAWYDWpvy8gHKTWn7Rx39eLEUeTPBr3z7rAaoWYThPYk4OzPtGO
        LrBlUIsyBa20ny3ZniiYZ4eAt6gWVnI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-In7NjUJRMDiV9wbasaRc9w-1; Thu, 16 Apr 2020 08:20:52 -0400
X-MC-Unique: In7NjUJRMDiV9wbasaRc9w-1
Received: by mail-wr1-f70.google.com with SMTP id o12so1617560wra.14
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 05:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N//aUi9ilfSYZbtt9uubNhdLlMHa9VPzC/9aWc7u2N4=;
        b=OKq6Z6xj7keXeuEe8tRVpJo8YAzE77cteatzrq20NCG67RzjqJRonxlnlf/5F9/ZAZ
         nkIY3ZSoAjoMmDxjtB7UbQkrKElN0xUs9nbyUoh24tbvUlm3vCmHJ3bhJ8QolYlhL0Ik
         Qmrvb8IsnYYCTnpODBF7pGlmbJJHPbdtvohziEy62TbDHXcreusGYTLNS77N9QgGY/K0
         mIGBe8BFSyW1zw67/l/IP16q1GzqUDWD/En9/ni8JEfiAA1Xp1U824jneCJGu1pW7BgY
         /FeLSdMtUYXpkBefRRlTLIPIV/TGhhb6tnEi6p9dVZKoIbaVcLFvDE2ekLuIMskzLblM
         6VYw==
X-Gm-Message-State: AGi0PubDHXUhnQTMrzGX6yIo6oK/uT4/+9m3qitGa4sF7ELviLyi3KNU
        XhIq5nCyWP9kpMBPCtFddoT1cDm5KrBaXQO6GQQmHfHtB+nh3R6zam1+8J7mTeeXG50hKRCHLhK
        O6xI1mY5i7z2PCf/J
X-Received: by 2002:a1c:a344:: with SMTP id m65mr4634836wme.20.1587039648641;
        Thu, 16 Apr 2020 05:20:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypL7Zr1AmadDiZcqsAC7y2lchYjfJabub1W1Nve6Z9EGEGzkMDXcyVU803uWBITr/U3dkRDooA==
X-Received: by 2002:a1c:a344:: with SMTP id m65mr4634814wme.20.1587039648429;
        Thu, 16 Apr 2020 05:20:48 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id a67sm3645719wmc.30.2020.04.16.05.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 05:20:47 -0700 (PDT)
Date:   Thu, 16 Apr 2020 08:20:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, ashutosh.dixit@intel.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        eli@mellanox.com, eperezma@redhat.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>, hulkci@huawei.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        matej.genci@nutanix.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        yanaijie@huawei.com, YueHaibing <yuehaibing@huawei.com>
Subject: Re: [GIT PULL] vhost: cleanups and fixes
Message-ID: <20200416081330-mutt-send-email-mst@kernel.org>
References: <20200414123606-mutt-send-email-mst@kernel.org>
 <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 05:46:33PM -0700, Linus Torvalds wrote:
> On Tue, Apr 14, 2020 at 9:36 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > virtio: fixes, cleanups
> 
> Looking at this, about 75% of it looks like it should have come in
> during the merge window, not now.
> 
>               Linus

Well it's all just fallout from

	commit 61b89f23f854f458b8e23719978df58260f051ed
	Author: Michael S. Tsirkin <mst@redhat.com>
	Date:   Mon Apr 6 08:42:55 2020 -0400

	    vhost: force spec specified alignment on types

which I didn't know we need until things landed upstream and
people started testing with weird configs.

That forced changes to a header file and the rest followed.

We could just ignore -mabi=apcs-gnu build being broken for this release -
is that preferable? Pls let me know.

-- 
MST

