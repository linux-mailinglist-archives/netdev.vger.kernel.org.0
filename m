Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3712B347409
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 09:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhCXI5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 04:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhCXI5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 04:57:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E216C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 01:57:10 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so31530683ejc.10
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 01:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bGrFoUWO78DHinCnOm8Cd58bA9eS8nD5CEjgHc47CWU=;
        b=xkodvHDrCcm1mswly1za4QGf6ZYnOgQE5f2au/oESMx8I5h2ptJirNaU0N1uFCDLxE
         e0BNzu7HuM/ULiCLPYp76cMv3qtgpd3RgyVcP6sABo8hVer4WQHhq7spzcrjK6etWmI+
         KqPmMymhqALvhT5mQgHHVySBkZ8GCjT9yMsA6PsPIGc4csqsTNrPEEvItlctaD1of15B
         k0NeSlSpm2mAUYeoie9NR1PAK0wxuuLaK7bzAW3WrpXPfvpaHm1Eg7+JDDxseYG6hjVh
         4jL3ifJ2S3VxMTJIS4uem4cC9e7gaOiVGYtsFCCtnukKZlol9aIAnE6nsYIjG/sfjgxM
         lc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bGrFoUWO78DHinCnOm8Cd58bA9eS8nD5CEjgHc47CWU=;
        b=Qyq90E1J3WGbxqkz8g0d3ygHsHlcmNG0qIiTsLdgdrbaR0XEiR3c1WAQqlcGCJ+1wr
         3ydXLu3LHbizgWffJvYTiQzWHJPVdAhNUsbo6+7lBK4DNSP/tO3IdWU7KdQ2fZxYXeVz
         XqO4aLfs+h6RClcMSZqNBCkQVXKpHneVEWFPt1T98LpxBIWhDOKCSgqv9dQ8JzDYrVAM
         2xC1kltDIju7Y1oDpc/HkQtnyPMuBcTwBVx2Fmww1TiFSnHRJWrCsU0HexaxrQN70j05
         Aer6pYmB2q9b0LHf4WPr25w1+4cHUVkb0o6yzke8ujtSP9PGUMUOLuOCWhLZ+ucAd+hF
         G0Dw==
X-Gm-Message-State: AOAM533C2asBDVbvqcZcaDwryyqXt8GqETdLTArUMrXiXOy52pXzsvqh
        vsPmPPj1H61NzGvJ3yZbor+d4AbQQWzGJY5XaAEr
X-Google-Smtp-Source: ABdhPJy1amFIC8PhAf53lebi6UrN3nLJlRvNr8nkHWtZ1LH1vCCA+ReclSL3bXScIhTgASF5pFEXwnHMDawdZcwejYQ=
X-Received: by 2002:a17:907:a042:: with SMTP id gz2mr2474707ejc.174.1616576229395;
 Wed, 24 Mar 2021 01:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-11-xieyongji@bytedance.com>
 <9a2835b1-1f0e-5646-6c77-524e6ccdc613@redhat.com>
In-Reply-To: <9a2835b1-1f0e-5646-6c77-524e6ccdc613@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 24 Mar 2021 16:56:58 +0800
Message-ID: <CACycT3uosBGNwTEaW7h8GdDvHjoXWR1Se_kszQJ5Vubjp5C8MA@mail.gmail.com>
Subject: Re: Re: [PATCH v5 10/11] vduse: Add config interrupt support
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 12:45 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=81=93=
:
> > This patch introduces a new ioctl VDUSE_INJECT_CONFIG_IRQ
> > to support injecting config interrupt.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> I suggest to squash this into path 9.
>

Will do it in v6.

Thanks,
Yongji
