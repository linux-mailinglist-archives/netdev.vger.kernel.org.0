Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF3E4215D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437701AbfFLJtU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Jun 2019 05:49:20 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35508 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFLJtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:49:20 -0400
Received: by mail-ed1-f68.google.com with SMTP id p26so20739952edr.2
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 02:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ujsbPGv9AR0o0HwNo1EU5+glXlY5BpGwIqXyg9FzEwk=;
        b=t8+LdLsRE3axIgdGXdpCAjFKfbKhvNtVo5SXeIF0jr2lnUTQtXCgsFDpyPO6iUWCme
         nJJ/R7qayOIbMHVn+wqKmqsbPBb58SW6jKDHxxdh0CwGn/LmZxSU/F58YaSCTry1fvNO
         7QiB3bCrRqVLn5CHhPGKY0r+q2vdOYTsce7IDsOlf5AtNV9IjqS3pnC8aF4ZzIve+ktu
         H3hXmXqEuIWWg1wibGl2m8RDi5YcIO/L8549Cme6sdI0V1dc3l8SQ0aF8EBXz50yp9wE
         SoPeM7xMZqpDIG4ftgjdpT9jaWK1Pll0q/+boFYlBGXEb18a5JpNc+nuD7ZMn+nkek6o
         UXiQ==
X-Gm-Message-State: APjAAAV7yOi1erM6SElx1yeuREXeWKYaGWOLIeq8V9MfOxV21RN1AL6b
        WtyKSGPbCbpI0YWltL01enuHhA==
X-Google-Smtp-Source: APXvYqxFgl6+aK4vSA6NuTMMe/gsI8wpaAH0244xTCEZ3LxEdhzMDelLINz2Y1H0D9iuW/lCqfG/RQ==
X-Received: by 2002:a17:906:c9d7:: with SMTP id hk23mr27188858ejb.260.1560332958958;
        Wed, 12 Jun 2019 02:49:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g37sm3823649edb.50.2019.06.12.02.49.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 02:49:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D1D9D180092; Wed, 12 Jun 2019 11:49:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] bpf_xdp_redirect_map: Perform map lookup in eBPF helper
In-Reply-To: <20190611144818.7cf159c3@cakuba.netronome.com>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1> <156026784011.26748.7290735899755011809.stgit@alrua-x1> <20190611144818.7cf159c3@cakuba.netronome.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 12 Jun 2019 11:49:17 +0200
Message-ID: <87k1drf80y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> On Tue, 11 Jun 2019 17:44:00 +0200, Toke Høiland-Jørgensen wrote:
>> +#define XDP_REDIRECT_INVALID_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
>
> It feels a little strange to OR in values which are not bits, even if
> it happens to work today (since those are values of 0, 1, 2, 3)...

Yeah, I agree. But it also nicely expresses the extent in code.
Otherwise that would need to be in a comment, like

// we allow return codes of ABORTED/DROP/PASS/TX
#define XDP_REDIRECT_INVALID_MASK 3


Or do you have a better idea?

-Toke
