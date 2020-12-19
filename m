Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A12DEC3E
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgLSAEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgLSAEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 19:04:11 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF80C0617B0;
        Fri, 18 Dec 2020 16:03:31 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n4so3644463iow.12;
        Fri, 18 Dec 2020 16:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D0RZvIvG86U+1zsR82pguJ1E6qLBjHenOu3iVavN9eY=;
        b=H9FzqwUC7S+wtQLW+nkx0uOb32y0I62/9xiIJwcUbFdP0EP3aSyNcsdkhk0MWTJuqy
         zA+IClj+07ZIkBDrbkpTx4vXvewViw90ybyCQfJ5nb6bwUGKKbfalrBCpZMYCBPzm/D5
         UQNrmNaArk8T4Wh0sRP96216RB+WiWL/dAsvV3KeXH1KKR0LbXxszOq+3nL2D0YQtuV/
         I1BmDpHFPaOiOtUg/k+Ufk3z1cAUKcRPm1U4+JcSlObP/w2ZxIkDTEgEhure1WTMLIcJ
         R3AeYrUEBiHOHxi42ktB/tYsbKOBZ/agBJWamh8ONLhvNoHl5Q5vNTrWnlLssIUp9goA
         RoZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D0RZvIvG86U+1zsR82pguJ1E6qLBjHenOu3iVavN9eY=;
        b=HomA6SDgdPKh3oCY2ugaMOTRFc8sYzRE0RAJgvS0Mj3+R1YzrjFjyNCcYaZfhd36g3
         wAXrHL6BlsysgEu2K7oH0Dgwxf2Crbz+lrN4W9oO1Q0KHvB0k2OULEtQvWyz8PHY0u7V
         cboWFpNuEYyFVnFAPLgL1P6I/K9g+hlsWDR51acMNTBfUATdgcsCt7kut2uF+1Q1HerE
         xZtFqdg84fPM+to6b/5S/F8KHx9iwb0mHs+lRvkS5Ajwf4XFEt9c73V1MrJFBDa0nQRu
         QwFLBt03Jelj9c9ui5mZYdemhIbxdb3Ufqh4EAdFc9SrWQxFggoLAdCybtviNKVEtK3K
         hmNA==
X-Gm-Message-State: AOAM533uSXGOTE2q/RS52JLOOfSkukBbyEO49tqCEn5CTlQaT1JAMMvd
        GLTw/PlH5QrSAVfmyqiCHPTglH9NEeoJcsXWPEk=
X-Google-Smtp-Source: ABdhPJxs+8yPIbFg69iS16FXa/io4UzDq3Znbq9QHkgKRE/5fCDhS9E8rPFkPC71dNvKlqEj4UW1/v6OqYK7w/87Hfc=
X-Received: by 2002:a02:7a50:: with SMTP id z16mr6065792jad.87.1608336210229;
 Fri, 18 Dec 2020 16:03:30 -0800 (PST)
MIME-Version: 1.0
References: <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com> <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com> <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
 <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0UdtEJ0Xe5icMOSj0dg-unEgTR8AwDrtdAWTKEH4D-0www@mail.gmail.com>
 <BY5PR12MB43223E49FF50757D8FD80738DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0Uetb7_P541Sd5t5Rne=np_+8AzJrv6GWqsFW_2A-kYEFw@mail.gmail.com> <20201218201804.GQ5487@ziepe.ca>
In-Reply-To: <20201218201804.GQ5487@ziepe.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 18 Dec 2020 16:03:19 -0800
Message-ID: <CAKgT0Uc1Oox3vXmS_EP9Dhwe5=wbjB7yn-ZpB7=gzpNf2=hBXg@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 12:18 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Dec 18, 2020 at 11:22:12AM -0800, Alexander Duyck wrote:
>
> > Also as far as the patch count complaints I have seen in a few threads
> > I would be fine with splitting things up so that the devlink and aux
> > device creation get handled in one set, and then we work out the
> > details of mlx5 attaching to the devices and spawning of the SF
> > netdevs in another since that seems to be where the debate is.
>
> It doesn't work like that. The aux device creates a mlx5_core and
> every mlx5_core can run mlx5_en.

The aux device is still just a device isn't it? Until you register a
driver that latches on to "MLX5_SF_DEV_ID_NAME" the device is there
and it should function like an unbound/idle VF.

> This really isn't the series to raise this feature request. Adding an
> optional short cut path to VF/SF is something that can be done later
> if up to date benchmarks show it has value. There is no blocker in
> this model to doing that.

That is the point of contention that we probably won't solve. I feel
like if we are going to put out something that is an alternative to
the macvlan and SR-IOV approaches it should address the issues
resolved in both. Right now this just throws up yet another
virtualization solution that ends up reintroducing many of the
existing problems we already had with SR-IOV, and possibly
exacerbating them by allowing for an even greater number of
subfunctions.

Anyway I have made my opinion known, and I am not in the position to
block the patches since I am not the maintainer.
