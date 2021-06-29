Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323613B784B
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhF2TOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:14:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233916AbhF2TOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624993892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQbKJDDcSDig+ZoAeWjxtVythqP5H1mHSwjXk0i1+DA=;
        b=cgOKIyvytVibtn96Mz00EQFk/XsBio9T8ZsDYiayc/9P2ZQEPOQF7K6D6xBB7XLRqx4Fbi
        LYT58ngSuv8e/AOeTGjtIT1CK96DfTwz9CVrw29algc6ZMAdlMq+U3cMunCTVrtt05RQsW
        FysRP0zt0wK8HQWF4pZVoOTxUXsCvco=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-bzfWpom-M4KgESoPWVGJNA-1; Tue, 29 Jun 2021 15:11:31 -0400
X-MC-Unique: bzfWpom-M4KgESoPWVGJNA-1
Received: by mail-ej1-f70.google.com with SMTP id p5-20020a17090653c5b02903db1cfa514dso6092098ejo.13
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 12:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hQbKJDDcSDig+ZoAeWjxtVythqP5H1mHSwjXk0i1+DA=;
        b=WTEyte4kuHeo3xNMsrMJUjT8Dj7RHleFSVRBzPDT6ZLMIQcw1mo4laKZp4wABaDyP/
         IXTemDrfYnCxQlAr7GQoKjzB+rZmUAXJAwVGU71BEwk59vs4/IghOT5JINQnhG93zaE3
         jpqKRFAOWdsE+NYmKibSTZ9g/xmTadAAZasPoZ0/SmKQehqZhC0rsZWos/+HD+iGKc8w
         bJz6CjBC9HEHykxedSZJSv/b1oBpSRKs+EGq2ICU3EDOyC7Xf/pawqXww0RjVCDFrpf4
         8k7hQvvrMhIOYEzCDGjZZu2vngDEvQPg6zJOOhopVjZwnTk6yxngJES8Q793cly0RvJN
         wQVQ==
X-Gm-Message-State: AOAM530vM+0n97/ErHxPGUhpWHhbHxpQD4GQgBQTnOLyZFGaYzieHwDI
        A/Aa1QcFxwmlaektomJ7TESMso6grvQ6tv+puYbXvRPJ0VWfaKIF+9GxkcnnfquCMgmv0xOFp9e
        BMVRnEvdMWL8XnEXd
X-Received: by 2002:aa7:cb90:: with SMTP id r16mr42469797edt.121.1624993889968;
        Tue, 29 Jun 2021 12:11:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYfiAdRV7D9nbJlFYuLhJYgtRi1/mP11UguePTeWSxfBXzg7z7ozLYXvwGM8BWUH2BqP+sHA==
X-Received: by 2002:aa7:cb90:: with SMTP id r16mr42469769edt.121.1624993889846;
        Tue, 29 Jun 2021 12:11:29 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id n4sm8519460eja.121.2021.06.29.12.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 12:11:29 -0700 (PDT)
Subject: Re: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to
 skb_shared_info
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
 <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
 <YNsVyBw5i4hAHRN8@lore-desk>
 <20210629100852.56d995a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue1HKMpsBtoW=js2oMRAhcqSrAfTTmPC8Wc97G6=TiaZg@mail.gmail.com>
 <20210629113714.6d8e2445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
Message-ID: <e0b50540-0055-1f5c-af5f-0cd26616693a@redhat.com>
Date:   Tue, 29 Jun 2021 21:11:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629113714.6d8e2445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/06/2021 20.37, Jakub Kicinski wrote:
> On Tue, 29 Jun 2021 11:18:38 -0700 Alexander Duyck wrote:
>> On Tue, Jun 29, 2021 at 10:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>> ack, I agree. I will fix it in v10.
>>> Why is XDP mb incompatible with LRO? I thought that was one of the use
>>> cases (mentioned by Willem IIRC).
>> XDP is meant to be a per packet operation with support for TX and
>> REDIRECT, and LRO isn't routable. So we could put together a large LRO
>> frame but we wouldn't be able to break it apart again. If we allow
>> that then we are going to need a ton more exception handling added to
>> the XDP paths.
>>
>> As far as GSO it would require setting many more fields in order to
>> actually make it offloadable by any hardware.
> It would require more work, but TSO seems to be explicitly stated
> as what the series builds towards (in the cover letter). It's fine
> to make choices we'd need to redo later, I guess, I'm just trying
> to understand the why.

This is also my understanding that LRO and TSO is what this patchset is 
working towards.

Sorry, I don't agree or understand this requested change.


