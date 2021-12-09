Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC40746E144
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 04:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhLID07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 22:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhLID06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 22:26:58 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D13C061746;
        Wed,  8 Dec 2021 19:23:25 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id bj13so6953820oib.4;
        Wed, 08 Dec 2021 19:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xaiQdEjeQgtiO7My0G1bhU9pQQQWDld/fjZwkvTV2qg=;
        b=cij8CdkzIxcadjQ1Oc8n960V/si9bwcrKT/VG+JdU8NN79NdVwJfuohpULmFpH5w9J
         MGPVbXS49aSwYI/onvRBWAYXQ+mmSnKE5P1KrLFsZ5KGZ6nsZ6oXAuasU5mBgZG4OHaR
         iXAbgIAN9wlKbtHyiQXBGwm6/CeH1KSK83h2AYBN4WE8Pt3+MMG/vBzx5AXx/vMiakGZ
         a4O0+4fyZ2O3tUltgWGHtwKycrNrAOmjR1UbVAMMCJnE4amBNYMKpX7gVVDjwS+UBu5A
         JYrr0bBj5Pq7OtWocTFSo1ZezViBPtuh+1DlYowPZw95dtKQKR64h3xW5imAUIKFgA7s
         Ev5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xaiQdEjeQgtiO7My0G1bhU9pQQQWDld/fjZwkvTV2qg=;
        b=jKyZMgyuDvpUWGlV/nLASYEBvrXXDw1ivZq4cJek5NDLMn5isQRjgtc1xr8BSQNkcc
         axLvMfU4zVfM54XEUzfKuH4vDFq7lkumPI8fcneBqUoGrkmtMbItyrkkfkH/nasSiJf9
         ccfgb4rbz8nclyoL8Dk9Xkd4sapI17xviGkvvoPzRvfHuKj1mLPOvXUWwtxuaLL+ixDE
         kZJ5BcpRJRYKG8JdqSt0S3YKFGUeythF+e5ZwScOsqlB3RnlsaohIR+bFNwkAjdzqKYF
         zpcrGDXXgR2ldafkoDKcZCMkJ7Q6es/wRxIkuVhiDdHwMpiBxK04y2S8w8Mr7J9TZ22a
         2rCQ==
X-Gm-Message-State: AOAM532lAnpGtT2zF835ILalB3t4jaRQRR4iuyatoFF3JejyGQyYQJS0
        Hl8lOB25LBmjBd/GxVEleFk=
X-Google-Smtp-Source: ABdhPJyImiy3jkcr5GmEBihnV7J2/At9FjEdELP4kpcSWoPLuCnnKRXARbWbmfoLR4qIuEpG86bW+Q==
X-Received: by 2002:a54:438d:: with SMTP id u13mr3562445oiv.156.1639020205149;
        Wed, 08 Dec 2021 19:23:25 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id q2sm880384otg.64.2021.12.08.19.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 19:23:24 -0800 (PST)
Message-ID: <0a2668a6-e819-926c-f8bd-069957cb3db0@gmail.com>
Date:   Wed, 8 Dec 2021 20:23:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [net] seg6: fix the iif in the IPv6 socket control block
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yohei Kanemaru <yohei.kanemaru@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20211208195409.12169-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211208195409.12169-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 12:54 PM, Andrea Mayer wrote:
> When an IPv4 packet is received, the ip_rcv_core(...) sets the receiving
> interface index into the IPv4 socket control block (v5.16-rc4,
> net/ipv4/ip_input.c line 510):
> 
>     IPCB(skb)->iif = skb->skb_iif;
> 
> If that IPv4 packet is meant to be encapsulated in an outer IPv6+SRH
> header, the seg6_do_srh_encap(...) performs the required encapsulation.
> In this case, the seg6_do_srh_encap function clears the IPv6 socket control
> block (v5.16-rc4 net/ipv6/seg6_iptunnel.c line 163):
> 
>     memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
> 
> The memset(...) was introduced in commit ef489749aae5 ("ipv6: sr: clear
> IP6CB(skb) on SRH ip4ip6 encapsulation") a long time ago (2019-01-29).
> 
> Since the IPv6 socket control block and the IPv4 socket control block share
> the same memory area (skb->cb), the receiving interface index info is lost
> (IP6CB(skb)->iif is set to zero).
> 
> As a side effect, that condition triggers a NULL pointer dereference if
> commit 0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig
> netdev") is applied.
> 
> To fix that issue, we set the IP6CB(skb)->iif with the index of the
> receiving interface once again.
> 
> Fixes: ef489749aae5 ("ipv6: sr: clear IP6CB(skb) on SRH ip4ip6 encapsulation")
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_iptunnel.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

