Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1409D42DACB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 15:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhJNNwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 09:52:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231365AbhJNNwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 09:52:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634219407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NU91yXOcSHE5nSjfMfHje2UOd8qpOzLy0LtZp6G93T4=;
        b=M4FtwOeDSeX49mu+9oT9hZNNOnDSCenZGvZmkRLhZagAuCvpCkldnT5lyQoTjiJmk7cZUg
        4mZj/vcHgERiVXDjDArej97L3LUcfF+WHSH5KlArPoPCIycH6Ee2KLU34DHE8y3DlMA6yi
        YcT3EiQgQmy5sySU34e7+hFcSe61rW0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-07MxgU9ZMy2PLvK8l51Gtg-1; Thu, 14 Oct 2021 09:50:03 -0400
X-MC-Unique: 07MxgU9ZMy2PLvK8l51Gtg-1
Received: by mail-wr1-f69.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso4634823wrc.2
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 06:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NU91yXOcSHE5nSjfMfHje2UOd8qpOzLy0LtZp6G93T4=;
        b=hfjqaEatiOAjTLXVeyiXeiCw99bA6J/kx95Zz1AJGcw96ZO7cnK0HqE+Z2ciCsQk2V
         5cMdWB4ak164pOYGV5DOlwpHUYviUVJusUp3xd32p2HSz2eXLW3PKZza9Acsp8QVFN6N
         cujQJKbwTlKUMD6j361CBGSldSP5JBi+q3psioYgzSzPyDCFAHA0Q5Bf9KUkEJCPZssM
         thov0BX7CYRgfGD5uYXsPKjF3j1SmUWKOVyxrUfO+lpBQsnloSCkopmnhpSV5fOv0boK
         UMAg5IGnKs/5qGQiYAYP48FOvEfkz8sNT1N6fFQM4OU3NMF+9P+zT9MBf090mO7zLn19
         p4/g==
X-Gm-Message-State: AOAM531AC+Kck7IzNyjWCE499fzc17hItUVTSxpxP97uzPJufBWStoRX
        8traG74S9eQ6NctOWs+U35T/AsuiBlwHwyeR0+4by4vEsj1nw9OxRF+2k6pKvZOZj13BkUsWgri
        VNNf2cQa/ueHEXnNa
X-Received: by 2002:adf:a48c:: with SMTP id g12mr6772212wrb.341.1634219402591;
        Thu, 14 Oct 2021 06:50:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhasqnkH6VqbFgdvBD0W5Dr+k4Bevu249dEYV/bhzX6RKl2KWbGOdZbqz1wCI3B6WA3SqVvQ==
X-Received: by 2002:adf:a48c:: with SMTP id g12mr6772182wrb.341.1634219402382;
        Thu, 14 Oct 2021 06:50:02 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-231-16.dyn.eolo.it. [146.241.231.16])
        by smtp.gmail.com with ESMTPSA id c15sm2496966wrs.19.2021.10.14.06.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:50:02 -0700 (PDT)
Message-ID: <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
From:   Paolo Abeni <pabeni@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Cc:     toke@toke.dk, joamaki@gmail.com
Date:   Thu, 14 Oct 2021 15:50:00 +0200
In-Reply-To: <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
References: <0000000000005639cd05ce3a6d4d@google.com>
         <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-13 at 15:35 +0200, Daniel Borkmann wrote:
> On 10/13/21 1:40 PM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> 
> [ +Paolo/Toke wrt veth/XDP, +Jussi wrt bond/XDP, please take a look, thanks! ]

For the records: Toke and me are actively investigating this issue and
the other recent related one. So far we could not find anything
relevant. 

The onluy note is that the reproducer is not extremelly reliable - I
could not reproduce locally, and multiple syzbot runs on the same code
give different results. Anyhow, so far the issue was only observerable
on a specific 'next' commit which is currently "not reachable" from any
branch. I'm wondering if the issue was caused by some incosistent
status of such tree.

Cheers,

Paolo

