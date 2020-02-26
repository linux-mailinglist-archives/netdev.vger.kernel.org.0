Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B801703B9
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgBZQEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:04:40 -0500
Received: from mail-qk1-f177.google.com ([209.85.222.177]:43671 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgBZQEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 11:04:40 -0500
Received: by mail-qk1-f177.google.com with SMTP id q18so1536782qki.10
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 08:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PdV3aV1pCpoXQD3p7Noc2dkN9/8NUodekoiHxaSf+z0=;
        b=JB7by65P+FADg4ejR2c+R27+bsyI9BJ58ru56JhoycKbaDLbryNo6Sq/OjORAqCkAB
         5j19FgXDy70ci4jtCiCx7Z1mBb/5sp1Fd0u7mWVY6kFamvngyncCwN029i/sFflb6+Dj
         9qSu18qWKUMopmGjHVgusBmVgCFWZxwccowU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PdV3aV1pCpoXQD3p7Noc2dkN9/8NUodekoiHxaSf+z0=;
        b=BWLm6d7xfYr6WSp8pqh5QfWrMH1tEesOL+nSbOg1BoM9M3IN5OY7YEm4OVbGcZot79
         XcEotf6CavM1cO5ewUFQidJf4fanOlUFirhbJknon5vZqnpQz9JQq6qqKSi5VPHnkhjT
         cI/b4VlieLWLKS9K1k5XlRWiXLyB+TfLwWO3hQlXVYR9Qt+4X+M1UXe8o/PNfMKnGOpZ
         uaNusBymHHLTPU4kgIz5Htw8neTprywbBeLBmC3gDO9+WGKDKpCQcpA+YIokLuAWH4Pc
         smZzuL0ddbejk6L5ENk6kigTgZWv0yis+FdiyclPAhECEhUMuEQfeRcPWGwYFW5jax53
         lYDA==
X-Gm-Message-State: APjAAAV7ZWVrEnzvdYArzva4wGcND5gANm+E/n/88h/BGURha4IeEmrg
        YLgo13l6o+7L78EvbwQXo3U/TsZJ77mNqvi0
X-Google-Smtp-Source: APXvYqzsjGMzKeUZTiydRCPbky1ABYm9Vi3l873Ptt4J1JlAp8QEcEkv1Ep4wmdHXY7w3XIeK7axjA==
X-Received: by 2002:a05:620a:22ea:: with SMTP id p10mr6050275qki.75.1582733078489;
        Wed, 26 Feb 2020 08:04:38 -0800 (PST)
Received: from [10.0.45.36] ([65.158.212.130])
        by smtp.gmail.com with ESMTPSA id p126sm1346512qkd.108.2020.02.26.08.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 08:04:37 -0800 (PST)
Subject: Re: virtio_net: can change MTU after installing program
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <07bb0ad3-c3e9-4a23-6e75-c3df6a557dcf@redhat.com>
 <bcd3721e-5938-d12d-d0e6-b53d337ff7ff@digitalocean.com>
 <d4d65b88-b825-b380-22d2-bc61d50248b4@redhat.com>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <87251eff-b30a-9c4d-25fc-5cd900d0ad8d@digitalocean.com>
Date:   Wed, 26 Feb 2020 09:04:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <d4d65b88-b825-b380-22d2-bc61d50248b4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 10:53 PM, Jason Wang wrote:
> Yes, that's better. But may requires changes in both qemu and virtio
> spec to work.
> 
> Do you want to address them? Or if it's not urgent, I can add this in my
> todo list and address it in the future.

I do not understand why a virtio spec change is required, so sounds like
something you should take care of.
