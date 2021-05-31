Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD3D395AB9
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhEaMlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:41:32 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:51780 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhEaMla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622464787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LlSiVV81Pz6ePMTZ7hKgyw0CcFhLY+GD/1rSLfsvaV8=;
        b=P7+kL081IvM0ZlpSPSzkjrFSGFDLFLECNmnyHOIZJjyvvFZJKRGcnzosYEo3NgX+nUs6X9
        QF5+4UMhVbL4bzI2m/1X4+NlC0jsiaOaRtXPy14UujH0FoRuLFZIA4QmQMVwAhr8XmbgDv
        X5bUYOYnXD3puxReitP3H6Qcr++vsec=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0fac3d09 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 31 May 2021 12:39:47 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id e10so16390240ybb.7
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 05:39:47 -0700 (PDT)
X-Gm-Message-State: AOAM530309kP/6LaRRNmrzHVgQZ0Ym2kVP47+7fUHLciYyEvXFsHoxih
        PKkcn2QLQw001GSrZvPaRgrt6hnzLxWsMPvqym8=
X-Google-Smtp-Source: ABdhPJx5wkjfsZJrgS2FWPypbKZWICDUKgEXrjkEMhOJzAqVgWWUsv380GYmlauRKrPI9C4xRP+y1i1uD9rBCbovqdg=
X-Received: by 2002:a25:f206:: with SMTP id i6mr30304781ybe.123.1622464786729;
 Mon, 31 May 2021 05:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210525121507.6602-1-liuhangbin@gmail.com>
In-Reply-To: <20210525121507.6602-1-liuhangbin@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 31 May 2021 14:39:36 +0200
X-Gmail-Original-Message-ID: <CAHmME9rYp0iO_=c_+UxvU9+UpHnnGkQVJYoikyjwav04UwZwBQ@mail.gmail.com>
Message-ID: <CAHmME9rYp0iO_=c_+UxvU9+UpHnnGkQVJYoikyjwav04UwZwBQ@mail.gmail.com>
Subject: Re: [PATCH net] selftests/wireguard: make sure rp_filter disabled on vethc
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 2:15 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Some distros may enable strict rp_filter by default, which will previent
> vethc receive the packets with unrouteable reverse path address.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/wireguard/netns.sh | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
> index 7ed7cd95e58f..37b12f642254 100755
> --- a/tools/testing/selftests/wireguard/netns.sh
> +++ b/tools/testing/selftests/wireguard/netns.sh
> @@ -363,6 +363,7 @@ ip1 -6 rule add table main suppress_prefixlength 0
>  ip1 -4 route add default dev wg0 table 51820
>  ip1 -4 rule add not fwmark 51820 table 51820
>  ip1 -4 rule add table main suppress_prefixlength 0
> +n1 sysctl -w net.ipv4.conf.vethc.rp_filter=0

The VM does not ship with sysctl, and you'll notice that other changes
go through /proc directly. Since it's a trivial change, I'll rewrite
your commit.

Jason
