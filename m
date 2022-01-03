Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2273D48381C
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiACU43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 15:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiACU43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 15:56:29 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF78C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 12:56:28 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id o1so59732689uap.4
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 12:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zpDNiFRKfImv7MDSXbb/NGdyBh+9ckXgR0tfwN/V9XQ=;
        b=aaix5x3VVPJNLluAGtiw/rWhqEPElOUzcCZdyZORQ1LM23pHBA8sU3G1FDA0M80RdR
         xdW9zSFF0OseUfDN/IJG3aHGaFtF+9P+esiRkfYjHL5T7eds9JiRw19smU8MI3X7LOSS
         9S2xVdh8ZxW1wEVCK70jMKr4cK03FJC4hG62jVFPLjtwzhhz0yU9Wj/cXbOrNLBuO703
         MlMRJnqnQx0/m7aXuMMsfhKNR+7y78nnK66wXOHZfioZ5FxsWwOtQksR2YmYu4/Z5k7a
         XTML+NpfobP9kzd38P/E8RMSfNo+leHBYvXT21bEVjMVFqqzxI0my8P4GJZRUzL6hEBr
         K2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zpDNiFRKfImv7MDSXbb/NGdyBh+9ckXgR0tfwN/V9XQ=;
        b=riHyErpTCvpb2a5dEhoklVXoKa/f/DDxl3nr2JhdlyS68LY9ImT4OjVTMTTIYuwb9P
         +wMp1PYu/qH1b7pFEEZg4+Ske/nmmeOC4XrfhCw9tvuK+DQc4L4nlFd2ZML7XfAxsYbv
         EvKfWSEspCrWSRkKobwq06UZvrCU/FMbD6EqUeMmRK0Qb/2JRRyvH4qahc+vCJb4sdm4
         0QjTSy+lbPMqeJkBW184DCJcMa99EPww2Pdph1ab6pl1bpN5gyL5ynVWJMh5EcVY3idz
         IUxZCRN8GzJaDpHleQJ6kFFTYe3el+HBX69lNrELDr1kBwCleqhs76kSqTfM59XMvsCD
         e69Q==
X-Gm-Message-State: AOAM531Oy72TsrWHwlKrfLYzVqvbkUR7HQtggJu4LqzIz7G5sC4uOx9f
        xJ2SgwBdavPSKSi++jYPihhCS2Uas/8=
X-Google-Smtp-Source: ABdhPJxQvGavhqe2XGfcOaKbKU2r6yBTGWuYq+BuVdJfCzFJmnYflrFnPZHDY4rkAL7PM50PjvQ7jQ==
X-Received: by 2002:a05:6102:e89:: with SMTP id l9mr15003029vst.80.1641243387863;
        Mon, 03 Jan 2022 12:56:27 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id x4sm2981419vsk.24.2022.01.03.12.56.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 12:56:27 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id j11so22827217uaq.6
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 12:56:27 -0800 (PST)
X-Received: by 2002:ab0:69c5:: with SMTP id u5mr14598741uaq.92.1641243387152;
 Mon, 03 Jan 2022 12:56:27 -0800 (PST)
MIME-Version: 1.0
References: <20220103171132.93456-1-andrew@lunn.ch> <20220103171132.93456-4-andrew@lunn.ch>
 <174b5c36-c42b-cff3-7608-58b95af50604@gmail.com>
In-Reply-To: <174b5c36-c42b-cff3-7608-58b95af50604@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 3 Jan 2022 15:55:50 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfJws07XZjL6d5C01ofhKcnLS=AHWkDtEKKGQdmuM-XBQ@mail.gmail.com>
Message-ID: <CA+FuTSfJws07XZjL6d5C01ofhKcnLS=AHWkDtEKKGQdmuM-XBQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 3/3] udp6: Use Segment Routing Header for dest
 address if present
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 3, 2022 at 12:35 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/3/22 10:11 AM, Andrew Lunn wrote:
> > When finding the socket to report an error on, if the invoking packet
> > is using Segment Routing, the IPv6 destination address is that of an
> > intermediate router, not the end destination. Extract the ultimate
> > destination address from the segment address.
> >
> > This change allows traceroute to function in the presence of Segment
> > Routing.
> >
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  include/net/seg6.h | 19 +++++++++++++++++++
> >  net/ipv6/udp.c     |  3 ++-
> >  2 files changed, 21 insertions(+), 1 deletion(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
>

Reviewed-by: Willem de Bruijn <willemb@google.com>
