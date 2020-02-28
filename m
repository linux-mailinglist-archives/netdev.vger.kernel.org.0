Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F22172F0C
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 04:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgB1DBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 22:01:40 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33497 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730445AbgB1DBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 22:01:40 -0500
Received: by mail-qk1-f194.google.com with SMTP id h4so1718739qkm.0
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 19:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SxuB25G6FK6qjdMW5Vaf++niTekBbeYkhQkklWHqLR4=;
        b=JPUIcJdEygkAa6/XdDEOwV7IN0qvBWawKUVwmbrZuU4gYwfJ5gKLyFWyhy0B/tEQh3
         7bshqeugR3U/+c5EaaRdXOnZ26G5ShnJdlZsjnOvAd3PLdfI0u/VgGPCtR71NbGIKIS1
         UQZ2vDDzqKS6KOp48E29P8J9vMgDEa+lWLklk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SxuB25G6FK6qjdMW5Vaf++niTekBbeYkhQkklWHqLR4=;
        b=cigjIE/piQdGaqk9TOEUwkLC+KQOrMieK5eOhn/3m5Z/l/QyV7Hicl8ixHTjZXWbTW
         l6STLcqbTgMfTInXw4W79qWD8Wi5hzxzhxUMZj8obwWfwe2VIHnJn0kfydBb6hXJRHd6
         EcBweBm1F0dD6nHICPeNCdoW0E+57348djggfMrnSbNCrpP84el1TgkxpTaWsGGOR6iL
         6EB1Z0e+KvaTMIclCksig9O4JcveYUxmXAvNY0Azb+E8k23/4Kzy7A3iewJGlubBfCiz
         yJ2m8S7kaVdUdTEfj0We1s/dxcptXWiLBQ3YfVWk4FV7peaiI2JYoZb9xhJom4P2M44y
         ABQQ==
X-Gm-Message-State: APjAAAVieArsPizOwu5PMIr1YAl7fRNCHw4OCVgHVAi3n3GevzytYm/V
        786cxo7mJIsUwTnGJmNJzlvHfw==
X-Google-Smtp-Source: APXvYqwOY3FqIDtA5GxCEK5VKr6fa2+wFvME9idQ01MwgsUnKZPvlepbUWcfa6/THqCFt73CDVJI8A==
X-Received: by 2002:a37:48c3:: with SMTP id v186mr2593106qka.188.1582858899128;
        Thu, 27 Feb 2020 19:01:39 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:a58e:e5e0:4900:6bcd? ([2601:282:803:7700:a58e:e5e0:4900:6bcd])
        by smtp.gmail.com with ESMTPSA id e3sm4322378qtb.65.2020.02.27.19.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 19:01:38 -0800 (PST)
Subject: Re: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-4-dsahern@kernel.org> <20200227090046.3e3177b3@carbon>
 <877e08w8bx.fsf@toke.dk>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <3b57af56-e1c1-acc7-6392-db95337bf564@digitalocean.com>
Date:   Thu, 27 Feb 2020 20:01:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <877e08w8bx.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/20 4:58 AM, Toke Høiland-Jørgensen wrote:
>  also, an egress program may want to actually know which
> ingress iface the packet was first received on. So why not just keep
> both fields? Since ifindex 0 is invalid anyway, the field could just be
> 0 when it isn't known (e.g., egress ifindex on RX, or ingress ifindex if
> it comes from the stack)?

Today, the ingress device is lost in the conversion from xdp_buff to
xdp_frame. The plumbing needed to keep that information is beyond the
scope of this set.

I am open to making the UAPI separate entries if there is a real reason
for it. Do you have a specific use case? I am not aware of any situation
where a packet queued up for Tx on a device would want to know the
ingress device. At that point it is kind of irrelevant; the packet is
about to hit the "wire". Further, it would only apply to XDP_redirected
frames which could be only a limited set in the ways that a packet can
end up at a device for Tx. I suspect the flow is more relevant than the
device. When you factor on other details - e.g., bonds, vlans - the
ingress device is not the full story. Perhaps the metadata area is more
appropriate than the overhead of managing that information in the kernel
code.
