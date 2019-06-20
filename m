Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DC44DB8C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfFTUmq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jun 2019 16:42:46 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:44995 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfFTUmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:42:45 -0400
Received: by mail-ed1-f41.google.com with SMTP id k8so6524571edr.11
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:42:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kg/vXKsNF33eTvftr/hHbD2ELxSm5XGUTYV0HrDOTPw=;
        b=FGlalMY9hkPDasbNf6/XN8KLgwErXFr6Da3pryp8ekbnTbfEimQTpDyMoFXb8gy4f5
         saLgE3QAJuJ/G5YBHPLW4CaVzJygZwQlW8sk2TJ0qCiQcFgxTI1NDaLJponfswhrjbOl
         rwwc57Ky8vmSFdlsgcD4m7IiHMLuybrs+KVGa9OK8tQqnmamb4HH5rm9E89Y/0W2TAxx
         ZJ3dIW634+djdAedYk6teVZmE8Ek4eRN7wcD9IAjfgEXx/4tAID1NJY8PWTvu2Jpo0v2
         9D+TmdOU2E3FxIi+mHPQGc8hL2+4gb5Fm+zH2Ct7kP3qqAmExwtyJt9UXlMPzMhGuY0k
         NRag==
X-Gm-Message-State: APjAAAU9XuzbTWjv/OXOfWqPJraJeMkj1MvSjbOZgTk83sEgT9J2o0bd
        EkVUdGZWQ4YPS7YZyf2wlKEmSA==
X-Google-Smtp-Source: APXvYqxm6YtOspkLjredVVCfkyeaTOtUQvWN3OQCfOTmE/G9D4JjUmzJsJML4w1yC4UbD58XiQofMw==
X-Received: by 2002:a50:cc47:: with SMTP id n7mr22159808edi.58.1561063364270;
        Thu, 20 Jun 2019 13:42:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f36sm172258ede.47.2019.06.20.13.42.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 13:42:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5EC171804B2; Thu, 20 Jun 2019 16:42:41 -0400 (EDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, mst@redhat.com,
        makita.toshiaki@lab.ntt.co.jp, jasowang@redhat.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: Stats for XDP actions
In-Reply-To: <44ae964a-d3dd-6b7f-4bcc-21e07525bf41@gmail.com>
References: <1548934830-2389-1-git-send-email-makita.toshiaki@lab.ntt.co.jp> <20190131101516-mutt-send-email-mst@kernel.org> <20190131.094523.2248120325911339180.davem@davemloft.net> <20190131211555.3b15c81f@carbon> <b8c97120-851f-450f-dc71-59350236329e@gmail.com> <20190204125307.08492005@redhat.com> <bdcfedd6-465d-4485-e268-25c4ce6b9fcf@gmail.com> <87tvevpf0y.fsf@toke.dk> <44ae964a-d3dd-6b7f-4bcc-21e07525bf41@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 20 Jun 2019 16:42:41 -0400
Message-ID: <87sgs46la6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/18/19 8:24 AM, Toke Høiland-Jørgensen wrote:
>>>>
>>>
>>> Understood. Hopefully in March I will get some time to come back to this
>>> and propose an idea on what I would like to see - namely, the admin has
>>> a config option at load time to enable driver counters versus custom map
>>> counters. (meaning the operator of the node chooses standard stats over
>>> strict performance.) But of course that means the drivers have the code
>>> to collect those stats.
>> 
>> Hi David
>> 
>> I don't recall seeing any follow-up on this. Did you have a chance to
>> formulate your ideas? :)
>> 
>
> Not yet. Almost done with the nexthop changes. Once that is out of the
> way I can come back to this.

Ping? :)

-Toke
