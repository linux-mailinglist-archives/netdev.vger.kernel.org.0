Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B66511500B
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfLFLuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:50:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726134AbfLFLuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:50:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575632999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5RR6KLkjGa/8eRR4rRRgqmD+G4XExV/5X+PUROOT5uk=;
        b=TJnkptervBqgYrpeFz7HUNxfcWmw0ftfv8kb8VvkXxwYE66yowXn29HVmZj0b4XKO3qTc6
        4MUJoHapSe7azKKmAYtWbjYmIRTibzb20gfO3n+p3cwudFWYpEbUA1zRzN83rlEbYpUh+f
        5zjLWMHmkMC7Nzt/wYFkIbYaTYNfNXM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-m5a7d5R7OTyJSKa5q1tkvA-1; Fri, 06 Dec 2019 06:49:58 -0500
Received: by mail-il1-f198.google.com with SMTP id t15so5057516ilh.2
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMgqP5QkEQk+UGVCfwxxpts/u/6TCN2bLU9ruGzSCGM=;
        b=j180s1Ld++iA712Vxo1FGcClacEbGU87VljCYRZWM6lVZk3zQO96uh3OcW+RtyMTS+
         xeNksqTCGqXEHls+SEBUi2GJf95CmAiZZfjkbAjs1ekIyODN7YFxiBGYK72tS1JCMu5i
         yPecHoukcD1QupKzP+igVq8Aevk0tDph8WH/YtK0+OOChfgq6BdOGNrjhqepJ7DG2Exl
         zvsWtlpZTGYm/mbH+jGpnN++gfi23p8cC4T8y9Iu0o1qYVetGltXgX2SCxsIPYbaw3Su
         wASaKgDYDJo2aVvKVCFw+tyj5mBhBXdL9Ao+vR26Eheq4olwpCFKKXtMQjZTiYRYRE8z
         ja9g==
X-Gm-Message-State: APjAAAWGz/7JRFvFdOE+ZeeyHEQW1klj9k0feY0wdhGL6DlQLdZg2N1n
        lkIZSMGXOM789gM93cn+X4m+ITVNFnFknBo05BMdGK3WJhmFsco03lt0WodMgFUdJlq8YnxXexC
        GbrWoqY7dUForwccA90Wkx8PmnC1Mbyuv
X-Received: by 2002:a02:52c9:: with SMTP id d192mr6673862jab.29.1575632997721;
        Fri, 06 Dec 2019 03:49:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqxj4W0kDb+q81Dqkn33R+dFWOSbz/Elbzu/vyIKfz9jeVH/R7FsKEbasShS4hYVH5i5AV6gbmxG1Oq3wTpzLBo=
X-Received: by 2002:a02:52c9:: with SMTP id d192mr6673845jab.29.1575632997454;
 Fri, 06 Dec 2019 03:49:57 -0800 (PST)
MIME-Version: 1.0
References: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 6 Dec 2019 13:49:45 +0200
Message-ID: <CAJ0CqmW8TYO4jasC4UVXALWHkvaU+S7Uu0V=TDojwZwiJV2TxA@mail.gmail.com>
Subject: Re: [Patch net] gre: refetch erspan header from skb->data after pskb_may_pull()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
X-MC-Unique: m5a7d5R7OTyJSKa5q1tkvA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> After pskb_may_pull() we should always refetch the header
> pointers from the skb->data in case it got reallocated.
>
> In gre_parse_header(), the erspan header is still fetched
> from the 'options' pointer which is fetched before
> pskb_may_pull().
>
> Found this during code review of a KMSAN bug report.
>
> Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup=
")
> Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

> ---
>  net/ipv4/gre_demux.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
> index 44bfeecac33e..5fd6e8ed02b5 100644
> --- a/net/ipv4/gre_demux.c
> +++ b/net/ipv4/gre_demux.c
> @@ -127,7 +127,7 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_=
ptk_info *tpi,
>                 if (!pskb_may_pull(skb, nhs + hdr_len + sizeof(*ershdr)))
>                         return -EINVAL;
>
> -               ershdr =3D (struct erspan_base_hdr *)options;
> +               ershdr =3D (struct erspan_base_hdr *)(skb->data + nhs + h=
dr_len);
>                 tpi->key =3D cpu_to_be32(get_session_id(ershdr));
>         }
>
> --
> 2.21.0
>

