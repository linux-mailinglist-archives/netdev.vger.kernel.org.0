Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B89465640
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhLATXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhLATXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:23:18 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AF3C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 11:19:57 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id t13so51267144uad.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 11:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=88OGwaTzogdv9EvwjwZwdMjE77fRE7nweThuCebIBJs=;
        b=EB8Mc6zz2YJVZOVO3CpWN99VvtDFgsJp48RbyjJxHRvf4H1GIf7r2MVF6dl5bBaHn6
         kRGd6/g5R4LwcvdktZI13VDniKJp/lY6Xy5lVkkOGObFldg3gdmt+AfQi+PSUkNyduz2
         zm52ziFHW6thZa+Xv9RbxCT/fInpImBZpyw/mj92XXwurmIwLt+nPVuTYuH4vq6UQvMA
         ujodRxRS64YTsKlaInQtE1VZ47M9zoWBnheSJ+XyHDkPRv9SCWytF5UaR1/AUJRZvstM
         Gfe41QR8VS3KGBwavrP1HSFzhsJSZfBwbRylH70TDMOhYngXc9gvSouDSOeJXmFlwD1g
         rwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=88OGwaTzogdv9EvwjwZwdMjE77fRE7nweThuCebIBJs=;
        b=8GdgNWajG69EOuZjCfraOVFmHrHaILXxjJ/aNutWS6TRtsdcjXG+ixbBjrImWnz4MP
         j36BRMf27WULUWjn+rWQVNP2Lf2VR65DKnqLTzjdJfoSQEJprpwNwCmh3YbvnVWB7FDz
         tJZClhfYPVaYsxcvOfVwPOAGAfSAbzxYlB+62q4gj/WvukY4K4wtth4aFBEoEEItgc1Y
         mZjSVCTGDq5A6Kah5klydD6EDp9m7g0k/TgU0pz/TIck6VDrKu6FPp22qygQaSGhIaMN
         oC5wSHHz9s3i1BmwKTGBZkpIBYcMBLb6gjErRfcmBHuxHgcjj2sAN2w2BYdcKGZ1Eq2P
         L9FA==
X-Gm-Message-State: AOAM530lrnCyVmFsZVDB/ludRbe9H83a5rnG/ALOrsfj0FFqSiLsV9zN
        ytKajAgY2kXv0ML1qeFb0Tfwwc9ucHagNA==
X-Google-Smtp-Source: ABdhPJwn0KYx8zX0hYtcJ+UGWImvyJw50PC/dDUk74gTd+K9tov4w6UNHhpc4Q9VGRkGDFx8AitgAg==
X-Received: by 2002:a05:6102:38b:: with SMTP id m11mr9745669vsq.36.1638386396965;
        Wed, 01 Dec 2021 11:19:56 -0800 (PST)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id w22sm383450vsk.11.2021.12.01.11.19.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 11:19:56 -0800 (PST)
Received: by mail-ua1-f47.google.com with SMTP id p37so51220106uae.8
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 11:19:56 -0800 (PST)
X-Received: by 2002:a05:6102:3053:: with SMTP id w19mr5158445vsa.60.1638386395854;
 Wed, 01 Dec 2021 11:19:55 -0800 (PST)
MIME-Version: 1.0
References: <20211201163245.3629254-1-andrew@lunn.ch> <20211201163245.3629254-3-andrew@lunn.ch>
 <CA+FuTSfLxEic2ZtD8ygzUQMrftLkRyfjdf7GH6Pf8ioSRjHrOg@mail.gmail.com>
 <Yae6lGvTt8sCtLJX@lunn.ch> <CA+FuTSce_Q=uyn9brCDmwijf5-zOp3G9QDqSAaU=PC7=oCxUPQ@mail.gmail.com>
 <YafG5hboD7itUddn@lunn.ch>
In-Reply-To: <YafG5hboD7itUddn@lunn.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Dec 2021 11:19:16 -0800
X-Gmail-Original-Message-ID: <CA+FuTSdjd2yrD-t8E=KuvEix3dJmgrtpEktZTKEPQ+ExwvoNqg@mail.gmail.com>
Message-ID: <CA+FuTSdjd2yrD-t8E=KuvEix3dJmgrtpEktZTKEPQ+ExwvoNqg@mail.gmail.com>
Subject: Re: [patch RFC net-next 2/3] icmp: ICMPV6: Examine invoking packet
 for Segment Route Headers.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
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

> > Then if the packet is not shared, you can just temporarily reset the
> > network header and revert it after?
>
> Maybe. I was worried about any side affects of such an
> operation. Working on a clone seemed a lot less risky.
>
> Is it safe to due such games with the network header?

As long as nothing else is accessing the skb, so only if it is not shared.

Packet sockets do similar temporary modifications, for one example.
See drop_n_restore in packet_rcv.
