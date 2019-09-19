Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7183CB7A35
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732285AbfISNMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:12:03 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45076 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731853AbfISNMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:12:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so4063429qtj.12
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 06:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tLUrvoaGsFqIP1F2ybycalkTfq5olFXyPEuKWDkHBjU=;
        b=WIjtBJu6KS37SMYYzvdhb9eM5wLYlP25KLIzsGSaKm5dhd4alV3pqopVHbjwCiRRF6
         gKJYCrGzkfK62zFK9VYRWF7NqrSFD+KOvFYWmchNyFv0613nJmKUjEc3SNYMuisaTirl
         Pk6pRgiRJse6Qm3Sl6zWo65RuliMn3CgHmzwC8mT5SAvRuPtIdngf2GNyQwpxzW24MrN
         iXnuv/PPaqIwu99Husc34jsB2Pz20T8wNFLRyNsH/QlAQW6urTP1epBtGdDeArmAuir8
         mYPrstycH16ZzPrukV4Jp/vpISLrveKEcYWgzmmW5xxGpj3wpNS0b6K4qqiIpY2Gu51n
         km6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tLUrvoaGsFqIP1F2ybycalkTfq5olFXyPEuKWDkHBjU=;
        b=LhvSpCPtkTSKNYADB6B69AWQdGWFv/vcilBRPfba3zAdVX3k8d/TnHnaeqi5vxd82V
         0AMHg4EHNz7yJ5tHx4D+TPJ/d5MSScKPOz+dfjrESe+nCkHxC7nuLpP2jo1d5P5Wr+n1
         OqPbv+yBH/RbfvfGalS5ndlRVnmT0Azby3nWKV5LXrc9FfmafEacWQ2K/GoSB5B2Salj
         snZS0ZeRwek14mOqx2vOW7riTfvQFuJm/xFRWIOjQyxjR58/+MeT44c22Jtwj9TVhl2f
         Qc0tixac5b+sYzCw0IXt9pwvg2Iq/6XJMxTm11537k6499fFvVEHKey5qbiclD1y0X3G
         nudA==
X-Gm-Message-State: APjAAAUwmSgSNGuiX2wjzH+Kd/oE1B65dvgv3OpienLAFeGKcFeAodTb
        feiADjBNsxdMKBDq+uuTdZO4YS7XxjA=
X-Google-Smtp-Source: APXvYqwv9Z1FrqI0vnIaY8vg0oOLFYn4Gat4Y6q6jxTBZiDkQIF0IOhmE4TPtSRMRuh0X3vRQDAyPA==
X-Received: by 2002:ac8:110a:: with SMTP id c10mr2984458qtj.259.1568898721227;
        Thu, 19 Sep 2019 06:12:01 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:f587:5f2c:f6d8:fcb7:3ba1])
        by smtp.gmail.com with ESMTPSA id t4sm1612420qkt.45.2019.09.19.06.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 06:12:00 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0787DC4A4F; Thu, 19 Sep 2019 10:11:56 -0300 (-03)
Date:   Thu, 19 Sep 2019 10:11:56 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
Message-ID: <20190919131156.GD3431@localhost.localdomain>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
 <20190919094106.GM2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919094106.GM2879@gauss3.secunet.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 11:41:06AM +0200, Steffen Klassert wrote:
> On Wed, Sep 18, 2019 at 12:17:08PM -0400, Willem de Bruijn wrote:
> > On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > This patchset adds support to do GRO/GSO by chaining packets
> > > of the same flow at the SKB frag_list pointer. This avoids
> > > the overhead to merge payloads into one big packet, and
> > > on the other end, if GSO is needed it avoids the overhead
> > > of splitting the big packet back to the native form.
> > >
> > > Patch 1 Enables UDP GRO by default.
> > >
> > > Patch 2 adds a netdev feature flag to enable listifyed GRO,
> > > this implements one of the configuration options discussed
> > > at netconf 2019.
> > >
> > > Patch 3 adds a netdev software feature set that defaults to off
> > > and assigns the new listifyed GRO feature flag to it.
> > >
> > > Patch 4 adds the core infrastructure to do fraglist GRO/GSO.
> > >
> > > Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
> > > GRO supported socket is found.
> > 
> > Very nice feature, Steffen.
> 
> Thanks!
> 
> > Aside from questions around performance,
> > my only question is really how this relates to GSO_BY_FRAGS.
> > 
> > More specifically, whether we can remove that in favor of using your
> > new skb_segment_list. That would actually be a big first step in
> > simplifying skb_segment back to something manageable.
> 
> As Marcelo pointed out, this should be doable.

And easier than I had thought :)
But please let me know if you need anything on it. This approach is
much cleaner.
