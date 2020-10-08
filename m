Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A120287E5A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgJHVyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHVyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:54:47 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B06C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 14:54:46 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h4so1446098pjk.0
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AF/59GQna/pKMoaMTpKpioGIW/gKIS1uWFWO9z+xOX4=;
        b=RNazFesbNaDJzpsCBG7HF4DMp4qFtH5q3kDDWx83vuCTi0zrcFDRToMMMVX8MqPzZR
         g0G1w6D1PqxvB7CvMuwvXxlzdzxc8t/EGUjxYTRTu8tr7kIZalP9u4es9Cq7zI/hNvhM
         M9+Z5t8tDogAlV0EnzyQbSIC32bPm223k/tkt0y6Q1FBD/zpNI2hJzZMGzs68YDrpOJf
         alHq/Rrq6IUeoYTnf6hkRwRBnBlAEHHOG5ZbOBbfYsnu4zkzQdbbwTD6uwK74PySe3Hh
         Wf/qoXKRuSjNEkkezlY4xiFGzWtfXQrK7dUBjCtlVbmwjNC10S9EGOYCsQIsY895KOMo
         Zdtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AF/59GQna/pKMoaMTpKpioGIW/gKIS1uWFWO9z+xOX4=;
        b=NSGHReWGhBgDLd+1phUQORA4xgPqdIfsvJBokiSIxcnHS88HqiJGEia3VmEe3d9lQY
         4FVLjQ/1t9UYWMfqdhsCvzRoCIF+hremZvAuYpreXPwliortc4M4eviqunF6bvfRCvun
         dhL/UrhUgEPkLUyWrXnYNEXLktbq2gz4TxrTwWO/kMBnEMvZG7bwGd2L1Un3pV8a6JQp
         RccnAv5ZpSrLTCHY/f+pZAz6e8nV+tP7Jsqx36uoaVfHKVmkLWEOutSRtuix0UqU07KB
         WszXQ2y1pJAhiCJQtdY/LlGLZF3InhMxFyGp/qwQO1lZesjohC8mS9pwerrRUcA+Z5/R
         jotg==
X-Gm-Message-State: AOAM531WbDtPy3Ljns/aeJobCkq2gqrv+sc2Ud9En93aqYFLsp5qZUKI
        05d0ksrPC4jh5PWZkJu+k7tGg3ntDBrNJZnnmzw=
X-Google-Smtp-Source: ABdhPJyravd7HsBiEyNgnZcVGGFHm7x3xww9LICvH+mAlD4NdKjJ4CcZBE4CzffHPkUSnvNkvA/K3w01Lt7oVcnwLDU=
X-Received: by 2002:a17:902:c154:b029:d4:bb6f:6502 with SMTP id
 20-20020a170902c154b02900d4bb6f6502mr2724065plj.23.1602194085679; Thu, 08 Oct
 2020 14:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
 <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com> <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
In-Reply-To: <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 8 Oct 2020 14:54:34 -0700
Message-ID: <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 2:48 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > I see the ipgre_xmit function would pull the header our header_ops
> > creates, and then call __gre_xmit. __gre_xmit will call
> > gre_build_header to complete the GRE header. gre_build_header expects
> > to find the base GRE header after pushing tunnel->tun_hlen. However,
> > if tunnel->encap_hlen is not 0, it couldn't find the base GRE header
> > there. Is there a problem?
> >
> > Where exactly should we put the tunnel->encap_hlen header? Before the
> > GRE header or after?
>
> The L4 tunnel infra uses the two callbacks encap_hlen (e.g.,
> fou_encap_hlen) and build_header (fou_build_header) in struct
> ip_tunnel_encap_ops to first allocate more space and later call back
> into the specific implementation to fill that data. build_header is
> called from __gre6_xmit -> ip6_tnl_xmit (or its ipv4 equivalent).
> This happens after gre has pushed its header, so the headers
> will come before that.

OK. If the t->encap_hlen header needs to be placed before the GRE
header, then I think the ipgre_header function should leave some space
before the GRE header to place the t->encap_hlen header, rather than
leaving space after the GRE header.
