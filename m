Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521AD1BA6DE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgD0Osi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:48:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20666 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727905AbgD0Osh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:48:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587998916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1embPqCsonfGXaUQtGeVgNx9N4yCgu9dowyrYp1qyE4=;
        b=YHTO1AVswdmgS5Pa3gPq25awBn2AlNnoU6ocssaCixGqvRB+g93LF/4c8H7UCnLdnTdFWq
        +lqZNiwd0scxaofdhgcbYR8YW8978lewreErFmWXalalmMGeoOGlHRqwpmurzFhvKOtI+S
        LKu/24W5ekJkMgVR0A8aIhjGDOT+Jb8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-PVbu37iCNLy56IeIfkdblA-1; Mon, 27 Apr 2020 10:48:34 -0400
X-MC-Unique: PVbu37iCNLy56IeIfkdblA-1
Received: by mail-ej1-f71.google.com with SMTP id a23so11082162ejv.14
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1embPqCsonfGXaUQtGeVgNx9N4yCgu9dowyrYp1qyE4=;
        b=t+H9e632yb9HuQ72DBB6DtmHj7xotUXyP3LyLFU3m/zQYS52ZLfZ6/EQ/ulCgI7HI1
         tnafmLaVl/pl0j+Z6sHFtXzQkWezjd7sMVJFqKel95/wRu5tiERw7omXuIwuw/+6diB5
         1MT65KwNN9wxvuAVpJoP2j0yRSUBexVgHOynCbBC2Kq/RHbfzqs/1YHPE7qo3Kpojxbp
         Pv9ZmedYfL0NjgIzojh6icnmXtSvO2MQu8jlM3MXow3fBufBM7AsqUnMqRpfkPZV1Hf0
         I5X38XiJ/VxdHb7CLkhhJ1MGRG6qwkRIOQDiB3zqp5zu+3DqYty0nTn/W87fftW+L3ET
         u69Q==
X-Gm-Message-State: AGi0PuadfHbxiyOm2yIpmi6okzwu3wlSZjqHnOlYxyUhtlG42XjTiUFy
        8qgSaKS0WmHbXukpQFVY8QRPMRY/PZHWcI0scrKOYdpmPxIaQiLEhi74am6nqlOg28CkaHeJGn7
        V/SK2Ea8pkpIik5dNIsjexSwxM35+5u7c
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr17760721edx.255.1587998913223;
        Mon, 27 Apr 2020 07:48:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypLj7BHikGEIOZghmumQYfcy90d0PJx0UUAMSgtCa1hAZNTcdL70/jz4lYMLWF46PLnX5BHB8N9pKfeDhd96a58=
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr17760701edx.255.1587998913028;
 Mon, 27 Apr 2020 07:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <a5e26e7eb3172c2ddebdc5b006f3afaf3e4adb5c.1587971664.git.lucien.xin@gmail.com>
In-Reply-To: <a5e26e7eb3172c2ddebdc5b006f3afaf3e4adb5c.1587971664.git.lucien.xin@gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Mon, 27 Apr 2020 16:48:22 +0200
Message-ID: <CAPpH65yW5DKMzUJh2=8yM9Zm80aBdu2SvE-Cym2vnqJxUxib6A@mail.gmail.com>
Subject: Re: [PATCH iproute2] xfrm: also check for ipv6 state in xfrm_state_keep
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Xiumei Mu <xmu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 9:14 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> As commit f9d696cf414c ("xfrm: not try to delete ipcomp states when using
> deleteall") does, this patch is to fix the same issue for ip6 state where
> xsinfo->id.proto == IPPROTO_IPV6.
>
>   # ip xfrm state add src 2000::1 dst 2000::2 spi 0x1000 \
>     proto comp comp deflate mode tunnel sel src 2000::1 dst \
>     2000::2 proto gre
>   # ip xfrm sta deleteall
>   Failed to send delete-all request
>   : Operation not permitted
>
> Note that the xsinfo->proto in common states can never be IPPROTO_IPV6.
>
> Fixes: f9d696cf414c ("xfrm: not try to delete ipcomp states when using deleteall")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  ip/xfrm_state.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
> index d68f600..f4bf335 100644
> --- a/ip/xfrm_state.c
> +++ b/ip/xfrm_state.c
> @@ -1131,7 +1131,8 @@ static int xfrm_state_keep(struct nlmsghdr *n, void *arg)
>         if (!xfrm_state_filter_match(xsinfo))
>                 return 0;
>
> -       if (xsinfo->id.proto == IPPROTO_IPIP)
> +       if (xsinfo->id.proto == IPPROTO_IPIP ||
> +           xsinfo->id.proto == IPPROTO_IPV6)
>                 return 0;
>
>         if (xb->offset > xb->size) {
> --
> 2.1.0
>

LGTM.
Acked-by: Andrea Claudi <aclaudi@redhat.com>

