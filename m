Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24CC14FEAB
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 18:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgBBRsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 12:48:53 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45495 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgBBRsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 12:48:53 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so14057114ioi.12
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 09:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s2EI1ApfBfKbij97H0qgSeC6DTQ7nOZfOCFqPsWL974=;
        b=hfgaD7f+9WY5q6YG7vJKwugnA70v7Bb1/FY10UW+Py26zz0eDHuEPV9cJOaJX29KEE
         Rcls/EtZ/JoSjOzkewg9zlpTvAgAMJyxwe/wJMs+whDd9lbnwhPPUdoJQRtm5gIHbnZI
         eBQKRAu/nMNjPrU+bDp8JWFp41zS8gZH9GclF5rpdL5rK2NM0TBMYpZme/fWD6j7rjX3
         X08XG+sPiaumowda8PpiU5Q2PZk8hilgPVzGnS1Z5ikaFa/Ya1WZrSAQiXGiJMhf1bDY
         F2WJcCVlWpyWUOXATUz1ujFjVM24Lrbz1efxsPmEln5vdBqytBQfxDySRio8dVKQKw8a
         iHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s2EI1ApfBfKbij97H0qgSeC6DTQ7nOZfOCFqPsWL974=;
        b=fFVOt17+QRnoyTuFBBPkBQfwKExUUkdlUSoF2BnAOZ77FuU4eZQ/erGhH1EDk4qasL
         JcAfhJLFwMJcB+0ZRDI1gyh/01/GSBWxf1wCuOm/3Zipf0g+DFi3Cv01qUURB/DV8j1n
         eBldJQdnr+j4XgeVjbmsZqUdljdGtLdSjgnl7QlrCJO49tWL7Q2mRfA3CjbaXAUH7rHd
         ziffILBtKoKhDOLpAfPSTtHyB4ubj9IOZM78JaQNLFuS1G7fEreE8uBx+iJ6utClEQQo
         Dz5KfPeU8AiKWwvlDw2ZdgwfRXxXFXMwWUBTrAw7CWDkiO+S7IjfnI/fNGID5mjWiOP9
         2U5g==
X-Gm-Message-State: APjAAAWQNjS5HKd6UWqWgIcAkE44czptcJP8FKcmOZZEYLpsTsfhAOgq
        zd/EoY7v1sKneBO81+rgREy+foCL
X-Google-Smtp-Source: APXvYqygydksMUumG6bcGcmhZxKeW6+j4IgpYCAOkpcQgxPylrDjcn4+bSMvDrxHWHJSkeIi3SJ/og==
X-Received: by 2002:a05:6602:2188:: with SMTP id b8mr15470199iob.248.1580665732823;
        Sun, 02 Feb 2020 09:48:52 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2529:5ed3:9969:3b0e? ([2601:282:803:7700:2529:5ed3:9969:3b0e])
        by smtp.googlemail.com with ESMTPSA id z21sm4675690ioj.21.2020.02.02.09.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 09:48:52 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126134933.2514b2ab@carbon> <20200126141701.3f27b03c@cakuba>
 <20200128151343.28c1537d@carbon> <20200130064517.43f2064f@cakuba>
 <87lfpme1mg.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0666c3d2-af39-d44b-2def-c8569634deba@gmail.com>
Date:   Sun, 2 Feb 2020 10:48:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87lfpme1mg.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/20 9:03 AM, Toke Høiland-Jørgensen wrote:
> I think it would be weird and surprising if it *doesn't* see packets
> from the stack. On RX, XDP sees everything; the natural expectation
> would be that this was also the case on TX, no?
> 

Yes. XDP_EGRESS should be symmetrical with XDP on the Rx side.
