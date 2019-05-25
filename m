Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075002A6E2
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 22:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfEYUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 16:09:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38777 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfEYUJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 16:09:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id b76so7290908pfb.5
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 13:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RgPCIfxuZ555TvIgZetIb3MKb+1IZVq/PG/zzoybCLw=;
        b=f6PCNT+KbyNH9XDsMP4I2Lzq7C2iqzb4jUh+UEFRfZLxBiSOvtaVfcEUip+0sl2VlV
         MEKJxQJIDUUTest+T7tuD6gxJlkp2mHdH5SVG1g3PY/WMu6EvhNKkPrDVzz0R1kCqHt0
         WUA1fwMvRztMYvYTUMoSLwwhNLtZwHNB52EUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RgPCIfxuZ555TvIgZetIb3MKb+1IZVq/PG/zzoybCLw=;
        b=RwJaWyeUvCHjsNtmlTKi7YbGDFzbe0Vw32g2d5oFtuBO8bIgkXiLuGrJ4cZ+yVYeqh
         I8OqYxtus91FgmZqtpcLgmgSAuJlIp+iLoq3Ee0Fkl1F2gNJapwjS+YOovcXbqGv2udi
         v4SM6IUHg8FlVJ5VkLCxvblvU5zTUaExj/+yvrXe+VuSq16YkCiD1ylRLtT2Y3QKk8tM
         /kL36amJey0j684Q2Jq/82ynjLRm3Gs09j9S7fHVWRppAekTCcfBYsN2G6rPzL5eGLq/
         Is1RT8t15bgA6Gsw+NQCzIkbeIBVw08yjZwc5tV9ozC+yJFJ5+D2NjzN140hp+cBUjND
         0LBg==
X-Gm-Message-State: APjAAAWrj92Ur8MOzIHyO69GywzIkVnNy83TsdA4+NAlj/8B2eD+glM5
        Nlf94KR7YFu4ITu+txPxXYloow==
X-Google-Smtp-Source: APXvYqySEgcKPmmo4fwPbOtEf9K0ORowxlH1vXJoq79O2o2u9E7lsGoEKiUWAO4Ma4jKRCgVmaOFLQ==
X-Received: by 2002:aa7:93a7:: with SMTP id x7mr123334287pff.196.1558814976191;
        Sat, 25 May 2019 13:09:36 -0700 (PDT)
Received: from [10.0.1.19] (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.gmail.com with ESMTPSA id 206sm5235555pfy.90.2019.05.25.13.09.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 13:09:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-+4g-HjmCnDWaVfdsyruePXqYeUDJgnffz9ro+rgNGv1g@mail.gmail.com>
Date:   Sat, 25 May 2019 13:09:33 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D37889F4-104C-4E9A-B5CB-A0FCCEFF2D93@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-+4g-HjmCnDWaVfdsyruePXqYeUDJgnffz9ro+rgNGv1g@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 23, 2019, at 2:59 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
> what exactly is the issue with IP_TOS?
>=20
> If I understand correctly, the issue here is that the new 'P' option
> that polls on the error queue times out. This is unrelated to
> specifying TOS bits? Without zerocopy or timestamps, no message is
> expected on the error queue.

I was not able to get to the root cause, but I noticed that IP_TOS
CMSG was lost until I applied this fix. I also found it confusing as to
why that may be the case.=
