Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAD23AB7AE
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhFQPlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231547AbhFQPlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 11:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623944371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xNvKLMG23dvwThJDYG7TwyaV7dhz4Izb5/V1BDRJuOQ=;
        b=RfQ/XQFUuqbazbCowMSXVsdOf6nklILRR5AAbCJluSBimgE5BFJre8mZf/54QuLDC7fjYQ
        Sc7+N958fdgqP965M3ABuqX/1qta0f+x3XnEHKlwTYigefVwB2Z/yyFPGTrXw00Q32OWN0
        Pm8RCQ/r+s9xjwt2X+WUyA31LkYPEnA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405--dJUSHs2O0Ka-epXJuV-Wg-1; Thu, 17 Jun 2021 11:39:30 -0400
X-MC-Unique: -dJUSHs2O0Ka-epXJuV-Wg-1
Received: by mail-ej1-f70.google.com with SMTP id o6-20020a1709063586b0290454e77502aeso2434784ejb.12
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xNvKLMG23dvwThJDYG7TwyaV7dhz4Izb5/V1BDRJuOQ=;
        b=FSd+/UPCj0r2GWz49ZSBhRNc1MPK4v6c8Jk9DX8IbXbOr/2DFN72EbtQrRkLRdx3Ir
         q7+9UdmTL8feigUt3EcRJsWzKOm9vbRrhyHZaf756ttuAS/IhOoefQymgsJzAfQeoZxQ
         9HRo2Y8p658m+m0cFoD78wyfL/R3EV07rzb7Mrnj+xCGaocbSo1LvMSVKm/yTVCg+2gK
         jkx/ekdJYRm30Hna7fPpsNNkRRUgCIWAKXrzPEQNaxGWI6WMyzgu42pwK0JN/hg6lOvE
         zFjvzJSYXKpgW3LeLE4hw7b9W6aXV8evRlrczbrPA4hoiDnf7F53VrBcU29L3gFWg80L
         Z1Ug==
X-Gm-Message-State: AOAM531namT4LWevcF70mw1ktloyM9H/zhiAJLRba4iDG8HclLYyDmTh
        NSPlpiCI4f5NpZpNGKDYwibv3W9DR74ZNB5PJ3xOyebxZhZwjywBpowqZt16MdZT+zSFepwLxXe
        Mlpf25er7lsVijvsz
X-Received: by 2002:a17:906:4f14:: with SMTP id t20mr5851051eju.398.1623944368844;
        Thu, 17 Jun 2021 08:39:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb78hCJPdeKI3UGp9ZLlPPiMHCh3AV9nIqODdWRwEXBJ0as5mZNSGeR6x5dbskkfEYEZ/1sg==
X-Received: by 2002:a17:906:4f14:: with SMTP id t20mr5851029eju.398.1623944368604;
        Thu, 17 Jun 2021 08:39:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o5sm4412551edq.8.2021.06.17.08.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:39:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3559A180350; Thu, 17 Jun 2021 17:39:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Juliusz Chroboczek <jch@irif.fr>
Subject: Re: [PATCH net] icmp: don't send out ICMP messages with a source
 address of 0.0.0.0
In-Reply-To: <be61a82e-1a21-d302-dcdc-8409130e8fb7@gmail.com>
References: <20210615110709.541499-1-toke@redhat.com>
 <e4dc611e-2509-2e16-324b-87c574b708dc@gmail.com>
 <be61a82e-1a21-d302-dcdc-8409130e8fb7@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Jun 2021 17:39:26 +0200
Message-ID: <87o8c4ec0h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 6/17/21 9:06 AM, David Ahern wrote:
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> This should be the one that allows IPv6 nexthops with IPv4 routes.
>> 
>> Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")
>> 
>
> on further thought, this is the receiving / transit path and not the
> sending node, so my change to allow v6 gw with v4 routes is not relevant.

Right, so you're OK with keeping the patch as-is, then? I can send a
test-case as a follow-up...

-Toke

