Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647E1B67D2
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbfIRQOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:14:07 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40157 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbfIRQOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 12:14:07 -0400
Received: by mail-yw1-f67.google.com with SMTP id e205so141028ywc.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 09:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iu6BzlSLNxYmh+knfX9QBmKNYdjeUDSew9kI0JrERHg=;
        b=nENCCsrLX2NJWm6vqDs3/x+bDVgmkBgwb5nj3carM2z/aAPuvsPPNDTpIbJNHaDD6i
         zJfrpXPIaJo2++2pSJa9TPrzJJp4H5O2w05Wnq6iA+dXsW4P8JNWdWZ/hogu0J6Ducio
         QWrfR0eduuaEV+kpjMZUDjnsaJN2jvvJhzgdEZvRvbNJ7HNl5jOvJT+LfPbFqyjVCYnC
         lP332/1+FReEXFekrubspBXSMPQiq4J+LqQbmkILi346GMicZdr9KBSxlr69jlpjydfv
         /8E08c9nQJ8WEwaUPR4p/z2tAK5HBkrw/C90CRBsMkF0VxIgoc4lM6MK+ziEucar02hI
         1IXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iu6BzlSLNxYmh+knfX9QBmKNYdjeUDSew9kI0JrERHg=;
        b=a26Y5l6msqxYkVwUdIRdZmpKkqia5JmjPg4jsetAUbb6JmdQPMIO0FVe4ePGgyDAJb
         yKPNffOUZ9aiBnLTneU9rsIZ51EM+jXd1eXZMxBQFotSUQDofm5iKjAPY3XoiRrmze6m
         HXpIRDW9TF6JvmasEhgxYBvBFFOI7PoXADzQu/W8ukira2cEOS2vDmAelpnzCBboOEDN
         dNHtkMIkUTBUnypebscaQiF3YUvR7GF2kx1KVUSJFfe1KOGlRgis2VQQXsTlOFkchmQs
         geP3FYG5IgnSqiVJwKRBYy/Bh33wKqivbmv57kPyEhxdP6CtJTA+iA2sx0WTAvdX5SeQ
         X01A==
X-Gm-Message-State: APjAAAUpVHhJvJSXM2hI6ym2VI9/qdTxRHaiPRR+jO04wXuDtBF4hy6v
        kR8Gwn7L1tIMjrs+NDJj9NlLkCmr
X-Google-Smtp-Source: APXvYqzPAKJUPg6FVDcep1e/e/03xK/C8qxuoMfLi61BQVNYW/tPNsEwAwodYscORvJp8mZfzPsyew==
X-Received: by 2002:a0d:ca03:: with SMTP id m3mr3854977ywd.209.1568823244940;
        Wed, 18 Sep 2019 09:14:04 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id 83sm1223089ywd.51.2019.09.18.09.14.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 09:14:04 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id f1so20442ybq.11
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 09:14:03 -0700 (PDT)
X-Received: by 2002:a25:6dc3:: with SMTP id i186mr1968126ybc.125.1568823243492;
 Wed, 18 Sep 2019 09:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190918072517.16037-1-steffen.klassert@secunet.com> <20190918072517.16037-6-steffen.klassert@secunet.com>
In-Reply-To: <20190918072517.16037-6-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Sep 2019 12:13:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfSpzHCCpDRD2s0fP3u2oyKVKQPOVAp0LLPMPV+W3kFtw@mail.gmail.com>
Message-ID: <CA+FuTSfSpzHCCpDRD2s0fP3u2oyKVKQPOVAp0LLPMPV+W3kFtw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 5/5] udp: Support UDP fraglist GRO/GSO.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch extends UDP GRO to support fraglist GRO/GSO
> by using the previously introduced infrastructure.
> All UDP packets that are not targeted to a GRO capable
> UDP sockets are going to fraglist GRO now (local input
> and forward).
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>


> @@ -419,7 +460,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
>             (skb->ip_summed != CHECKSUM_PARTIAL &&
>              NAPI_GRO_CB(skb)->csum_cnt == 0 &&
>              !NAPI_GRO_CB(skb)->csum_valid))
> -               goto out_unlock;
> +               goto out;
>
>         /* mark that this skb passed once through the tunnel gro layer */
>         NAPI_GRO_CB(skb)->encap_mark = 1;
> @@ -446,8 +487,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
>         skb_gro_postpull_rcsum(skb, uh, sizeof(struct udphdr));
>         pp = call_gro_receive_sk(udp_sk(sk)->gro_receive, sk, head, skb);
>
> -out_unlock:
> -       rcu_read_unlock();
> +out:
>         skb_gro_flush_final(skb, pp, flush);
>         return pp;
>  }

This probably belongs in patch 1?
