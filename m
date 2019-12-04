Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F76113599
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfLDTXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:23:36 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44204 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbfLDTXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:23:36 -0500
Received: by mail-yw1-f65.google.com with SMTP id t141so159858ywc.11
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUxkaUmtQbpUCJr8ZpcwWbKJcmlT2fymrv39Ke8j/1w=;
        b=nldiMngIVUFVnbe/D2VRFoDLfMsQXKtbCkKpgFzaP66vRavVzrn/LL5qpLbC0nA42T
         vWbphHCuOhI1Zb8SbnKaVPptFE+yYx0bjikuVpiNfiybFVt3ZS3US0IeymTWIUjn6co0
         YfS4UMDgWEsxdsdJxe/j7/kLlEBm9GYTp5myVZIYczm4Oy5dSObGuqZJt8cpXLGEZ/hm
         jbjkl/A/hwxHbVIXXBgy5IxmfU5pGv40L4ECdgW9J3zvTTH+S+ILqXk2JJP9R9yxSMh6
         Pt1NmD69V/67XoOXxLShANVnRLDuUp0LfLxf+ORwr7hmwriuqtIAeE2+DlhtjC3PjNms
         XaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUxkaUmtQbpUCJr8ZpcwWbKJcmlT2fymrv39Ke8j/1w=;
        b=gDJd1ZE4xVVFZWygvTjkjdS48lJgoxJQyjKnIse1F8XruKY2UNgs9jaGaVsY09qU6X
         YfsH3+uqwfCfwlpJV0RRJldKueb8tNrBFspmmUV+zj1pdcIJp6LPAZbuyr4Ydoad5ngc
         1eN0HP3raDcZ8P5n8eqw+9ehYwyBnzyhUfel4EUR6NB5kXiaU2aVj0vrxgmKN5JDa9AV
         ZbCYh/OcYrpjEiC1W0nb292hO9io5lrveN3cVSTr8gQiQkT7Z4m3fImZ4bLf0+oqw4VY
         l7A1ftByGGInsUocjtFETP4ZeFSlRyOEpESr2/A5Wn1umykHhUnsLkJkAH9v3easE55H
         7DyA==
X-Gm-Message-State: APjAAAVj5wmI7S1jBFkij9gBQ3B68aVxnRvyupUek8x017+O3U3ywBXA
        8JLLZRssV6j2IfnRlxzYgqBegqxX
X-Google-Smtp-Source: APXvYqxExVuXlBCEJ5ACPEUiNc/EtDo5IvKLSeTXFsJaaQenzGB171gmdkt2n9laeyUT6onwaYktFw==
X-Received: by 2002:a81:4844:: with SMTP id v65mr3420135ywa.23.1575487414290;
        Wed, 04 Dec 2019 11:23:34 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id h193sm3362135ywc.88.2019.12.04.11.23.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 11:23:33 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id d95so420229ybi.8
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:23:32 -0800 (PST)
X-Received: by 2002:a25:c444:: with SMTP id u65mr3453976ybf.443.1575487411650;
 Wed, 04 Dec 2019 11:23:31 -0800 (PST)
MIME-Version: 1.0
References: <20191203224458.24338-1-vvidic@valentin-vidic.from.hr> <20191203145535.5a416ef3@cakuba.netronome.com>
In-Reply-To: <20191203145535.5a416ef3@cakuba.netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 4 Dec 2019 14:22:55 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdcDW1oJU=BK-rifxm1n4kh0tkj0qQQfOGSoUOkkBKrFg@mail.gmail.com>
Message-ID: <CA+FuTSdcDW1oJU=BK-rifxm1n4kh0tkj0qQQfOGSoUOkkBKrFg@mail.gmail.com>
Subject: Re: [PATCH] net/tls: Fix return values for setsockopt
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 6:08 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue,  3 Dec 2019 23:44:58 +0100, Valentin Vidic wrote:
> > ENOTSUPP is not available in userspace:
> >
> >   setsockopt failed, 524, Unknown error 524
> >
> > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
>
> I'm not 100% clear on whether we can change the return codes after they
> had been exposed to user space for numerous releases..

This has also come up in the context of SO_ZEROCOPY in the past. In my
opinion the answer is no. A quick grep | wc -l in net/ shows 99
matches for this error code. Only a fraction of those probably make it
to userspace, but definitely more than this single case.

If anything, it may be time to define it in uapi?

>
>
> But if we can - please fix the tools/testing/selftests/net/tls.c test
> as well, because it expects ENOTSUPP.

Even if changing the error code, EOPNOTSUPP is arguably a better
replacement. The request itself is valid. Also considering forward
compatibility.
