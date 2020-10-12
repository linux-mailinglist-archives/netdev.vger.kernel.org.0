Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B31A28AC4A
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 04:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgJLCuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 22:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgJLCuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 22:50:15 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DA3C0613CE;
        Sun, 11 Oct 2020 19:50:14 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y20so11956359iod.5;
        Sun, 11 Oct 2020 19:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J7/yqht/DUuz9NMDM3wkUgmSzBZ+JRPjmZmOGIyieZs=;
        b=erW6HAqQEB3HRkJZvQO+93KXiz9QBu2wNA9okKP+42PGlK6rXk4sYREYgBc/HPX41p
         eopTfGDj946U6qdIiFqIz54NuU+CRJ1eCTHKHw0z0PaQPFtQeL/CfHGo8sTplM/+SD4g
         xvp3E0JVO1iR7zTtCPi3MxMxkC5MjUyI4MQTz58M8gARozaEgNuExkRT49H1swkU5PgZ
         9SGEU09GTGDsiPZ/DPyJgQGrX0bKxrs9j4ZrrcHFMp+ZmvpUfZt7EJS8WyaXquNvt1UO
         TZQzPjJT9y9aSF4dj1DtA4M0lMX6zzmWaJkQg0HaJOMUQsOS+Xd05cLUOQAFTsJGPyJw
         CEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7/yqht/DUuz9NMDM3wkUgmSzBZ+JRPjmZmOGIyieZs=;
        b=Gh9gvWlhse5i/gxjSruoCnsA+f9pbksKiMQ53Ydr//m9VM14+mPTyripnrNF6HqZMp
         ehvEhtpDwyiEnoD5Xi1n+fthYAd9ZHvwAfQ8lGlvV9v6uWuUepTxDewoBaQ9eCLsDNSP
         uncktb+FiHuUSjDeIO0eFQbIqEjRNc3Mp91LNN5KTXRB1I79C2ATFD8pjZL2fCWbpzq/
         j8Chnm3Cbj42tIzQWKf/mrCIdo49WALfm283Yb84lAd6B0n3xPyHB8RSh8cCHCMq0zfV
         p60oAy14EYYDSROHt7FzJh6BPKeM4OdrHNWUWr6yXDo8thRU68OO8zjfibBjpMv5gxON
         uykg==
X-Gm-Message-State: AOAM532vOO+MqV3iVl4ndJublTNVWB/yq7Ws0Kyw3qhyjQ1fy42CZ96j
        VvjGGQLx5Z3uvqf+9WKJwzlKtE7thfk=
X-Google-Smtp-Source: ABdhPJwj/44UYAj4og3GzbRGf3IEYgTonNAG/7GKWo06UqzHKQR0eqL5EbsezyeWXEhm4dqtwRJZkw==
X-Received: by 2002:a05:6602:2fc2:: with SMTP id v2mr6644310iow.19.1602471013944;
        Sun, 11 Oct 2020 19:50:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id e15sm8179686ili.75.2020.10.11.19.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 19:50:13 -0700 (PDT)
Subject: Re: [PATCH bpf-next v6 2/6] bpf: add redirect_peer helper
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201010234006.7075-1-daniel@iogearbox.net>
 <20201010234006.7075-3-daniel@iogearbox.net> <20201011112213.7e542de7@carbon>
 <aadbb662-bb42-05be-0943-d59ba0d3f60c@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1992820b-4916-ed42-e1e2-8e37ae67c92f@gmail.com>
Date:   Sun, 11 Oct 2020 20:50:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <aadbb662-bb42-05be-0943-d59ba0d3f60c@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/20 10:16 AM, Daniel Borkmann wrote:
>>
>> This is awesome results and great work Daniel! :-)

+1

>>
>> I wonder if we can also support this from XDP, which can also native
>> redirect into veth.  Originally I though we could add the peer netdev
>> in the devmap, but AFAIK Toke showed me that this was not possible.
> 
> I think it should be possible with similar principle. What was the
> limitation
> that you ran into with devmap for XDP?

Should just need an API to set the namespace of the redirect device -
something that devmap can be extended to include now.

