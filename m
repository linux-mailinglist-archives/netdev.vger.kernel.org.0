Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354D32E6CEB
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 02:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgL2A6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 19:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbgL2A6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 19:58:41 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22781C0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 16:58:01 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id e20so6337797vsr.12
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 16:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IYmN8eIH7rNg13rLJ8T9I7B/b/Ox/WImS0U1BiM5xfo=;
        b=cVOlQXA5gn0LRJIhGclSNTGOOrEdfA0HH5LdJ1TUcRxDGlCkN7BFvcH4flkN0S5pmv
         StmgJzGH6TH8mwbPbJzjv8pjDhQ+z4nkCljMo7achB1b+YB0e4OgoH9NL34qZo0NhzuY
         52VPsre/iIo948PiUXEJdRc5DDNEQo81yfI9kro6B67ooXZmFwVhL8hCzjSYMbG7oGL5
         ZVX4gPZbtxPpOifCNJH62H9kf/hiY1GMbc0S/ABywJmy6G9TW2tOWEYSvZZn+u2PYX6r
         0DbLCmbnuFi7WVoegSDDaTCI4sxFCVqsvIoiDOgh9OiLXqEfwLjoBGcCBLAqQWWtN30M
         Cfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IYmN8eIH7rNg13rLJ8T9I7B/b/Ox/WImS0U1BiM5xfo=;
        b=Wo40KVFjBxvuluqc/iMN8LHZpRcdwu2gqnAvAge9MMhFa0IE+ZHsrXT4HSQwy3PX0b
         JbV8wvPt1YpEcMtW1IJvPpynIZx9kN2/D9DFxA8EHURSATtbnLnAQ2lvUu/qc1+dQPXS
         saxW9CiNj67MuFr2j/fy3p2mGqufMleMGzR1dtV0ca0f49wm8lEUWXVHSJCdqO0eE1l0
         MaLDR6EfnoAAM9loi+DYU1ApmrS4dGL2IROD26CYI1zRo+GD9eULyM4+wH72JcuAC8nI
         KEQtcOgQdt8YNV2kw2crJEMLTNTE0CZurLnnf118keWgaEZPBY1r/e18vXXQYkbTbmcS
         IQMw==
X-Gm-Message-State: AOAM533V99zHbTjf4u46FzEu8QMxS7dFlJY3RDbvg5UpsCGLZZcKLb+E
        Ru3jjz531QloQXAcNOh1tyNZD2PfyGs=
X-Google-Smtp-Source: ABdhPJwWBsCOD3MGxO+mECi3FrX6eFhPWks1ZNbT6yGPZ1fJ5FJimcaPbVg7Vzl+Ny2QDDb4JM2vzg==
X-Received: by 2002:a67:fd67:: with SMTP id h7mr28788872vsa.9.1609203479485;
        Mon, 28 Dec 2020 16:57:59 -0800 (PST)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id p80sm4391141vkp.45.2020.12.28.16.57.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 16:57:58 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id h6so6367336vsr.6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 16:57:58 -0800 (PST)
X-Received: by 2002:a67:3201:: with SMTP id y1mr29582471vsy.22.1609203477776;
 Mon, 28 Dec 2020 16:57:57 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com> <20201228145953.08673c8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228145953.08673c8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 19:57:20 -0500
X-Gmail-Original-Message-ID: <CA+FuTSe630QvTRM-0fnz=B+QRfii=sbsb-Qp5tTc2zbMgxcQyw@mail.gmail.com>
Message-ID: <CA+FuTSe630QvTRM-0fnz=B+QRfii=sbsb-Qp5tTc2zbMgxcQyw@mail.gmail.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 5:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 28 Dec 2020 11:22:32 -0500 Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Add optional PTP hardware timestamp offload for virtio-net.
> >
> > Accurate RTT measurement requires timestamps close to the wire.
> > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > virtio-net header is expanded with room for a timestamp. A host may
> > pass receive timestamps for all or some packets. A timestamp is valid
> > if non-zero.
> >
> > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > international atomic time (CLOCK_TAI) as global clock base. It is
> > guest responsibility to sync with host, e.g., through kvm-clock.
>
> Would this not be confusing to some user space SW to have a NIC with
> no PHC deliver HW stamps?
>
> I'd CC Richard on this, unless you already discussed with him offline.

Thanks, good point. I should have included Richard.

There is a well understood method for synchronizing guest and host
clock in KVM using ptp_kvm. For virtual environments without NIC
hardware offload, the when host timestamps in software, this suffices.

Syncing host with NIC is assumed if the host advertises the feature
and implements using real hardware timestamps.
