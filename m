Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E65247EAF2
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351112AbhLXDta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245534AbhLXDt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:49:29 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9065EC061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:49:29 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id i6so13195309uae.6
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZbaMFC4V19Ior2i4OJlK0LKinH6eJ7rayuM+RGsFwsM=;
        b=dz/Lm8vI1jSC7eYwz9jyOjafg1mr1qj6+V69XPDyBQSeBXHEhJOqNcnXGBPhpFdd7a
         8e7TXb3pF0Yljuvychae4NWUX5z/DFHIRRXm7oamCGY6m3gQVUnODUb3MQtDM6mnPDe6
         ShKQcr7OELogQswYVSZyheV5A1RK9irVXUwq5CL+x+xhdkD2rUENZTAvvtJYWPmdl7KZ
         SXxt0Xg/+93+ZCQJToRc/ZVTcCdtwYKI/DGj5Ptwdb/ZcukATxjlje1NH/bcuconOYHw
         p/sudFK2knWzo0sWDrHMFxlHQ/1kduT70hHsJAOieXhyA5s1lmMb1E44yjKEpN796Acw
         +pmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZbaMFC4V19Ior2i4OJlK0LKinH6eJ7rayuM+RGsFwsM=;
        b=acxTbxYTLFe9gf01qGYaTiFXbubiBnVlI4aO2bUVzHm2VYdakNeGerWO+G0P5QcN3O
         wed3V9sRpoQBl6twFN1kt04O5CO0RLNSxcB3f87v1uFts9YR9EwNKZGqKGuJM/ydrRQ8
         VSaWGtR+CIh16gmikyz4TDFHiWA2uRQjsDvpJpChwamvJkQ42f07vVbRWTxKT1vO1meR
         +q+vAWBOuWXyjlIjsOsUCpA/OvAOOxhUvUb+UdG7g2HhK2/T8b4wBraGEeXymC0pWPo9
         j0abyMVyt+AunyujVRNkU38sAUoH05yeT7eVCJhoKVX8uMqoti4QspVf1mbLGm8r3Tc3
         Larg==
X-Gm-Message-State: AOAM532OpejAhM0o2K/XdK2lFKg33RC+axBjBHJX/UxCUY6yc9ivv5uH
        +hHdwAunRy2sNzlEeuTRfTQ4bmFAGqo=
X-Google-Smtp-Source: ABdhPJwwYvPDvBB0UjFVsHG01ESvBhMANd9vSrDMfzO14a7z+xhpmrpD184Cl6ZEfh65vNfMoB5Lxw==
X-Received: by 2002:a05:6102:240c:: with SMTP id j12mr1529536vsi.26.1640317768584;
        Thu, 23 Dec 2021 19:49:28 -0800 (PST)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id w184sm1382974vkf.10.2021.12.23.19.49.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 19:49:27 -0800 (PST)
Received: by mail-ua1-f54.google.com with SMTP id 30so13163265uag.13
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:49:27 -0800 (PST)
X-Received: by 2002:a67:f141:: with SMTP id t1mr1571634vsm.35.1640317767396;
 Thu, 23 Dec 2021 19:49:27 -0800 (PST)
MIME-Version: 1.0
References: <20211223222441.2975883-1-lixiaoyan@google.com>
 <20211223191922.4a5cabc4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <20211223192256.1c91fe7a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223192256.1c91fe7a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 Dec 2021 22:48:50 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc3-bsLjz+qXKYZ_G-7yUTQnGguzE8mLVFDyXdwvaGFWA@mail.gmail.com>
Message-ID: <CA+FuTSc3-bsLjz+qXKYZ_G-7yUTQnGguzE8mLVFDyXdwvaGFWA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] udp: using datalen to cap ipv6 udp max gso segments
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Coco Li <lixiaoyan@google.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 10:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Dec 2021 19:19:22 -0800 Jakub Kicinski wrote:
> > On Thu, 23 Dec 2021 22:24:40 +0000 Coco Li wrote:
> > > The max number of UDP gso segments is intended to cap to
> > > UDP_MAX_SEGMENTS, this is checked in udp_send_skb().
> > >
> > > skb->len contains network and transport header len here, we should use
> > > only data len instead.
> > >
> > > This is the ipv6 counterpart to the below referenced commit,
> > > which missed the ipv6 change
> > >
> > > Fixes: 158390e45612 ("udp: using datalen to cap max gso segments")
> >
> > I'm gonna replace the Fixes tag with:
> >
> > Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> >
> > hope that's okay.
>
> Or I'll fumble the git command and accidentally push as is... Whatever.

Thanks. I was in two minds which commit to use. From a backport to
stable point of view, it should not matter in practice.
