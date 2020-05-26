Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DAB1E29FF
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgEZSZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbgEZSZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:25:58 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2805BC03E96D;
        Tue, 26 May 2020 11:25:58 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g9so18449956edr.8;
        Tue, 26 May 2020 11:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=afKePXV5UqK2ZUvdMymIq9tPCqQ112HpkYrwABU1zys=;
        b=plsjLQU/KzwWN+TjdGYXz8YVIQm1239ou0S/5f4jCz3we8r1Qke+/ts0DI3PeVuh6q
         CKByTKnGyQ1iQaedMldR6pNpKsarP9nHRolpXCallJMpZENuq8sI6EN+3Pvo9tyWT8tj
         JCDwK89P6jFFhPr0WlYTIwva8Vytyq0c8isR9+CHB+4DxJP9d9nYCx1mC5OF8eG3Np2Z
         lZtfKGvFRkgFBB35MR4lDzVT4S7O4E+iv3Q+FZ2JvUs7+G2iuyN+YhMBaHWiijdumWEt
         KanGWC1YQLH/IR9t+DoZn3y8NOOFE/OU/vrV1rwZHciT2nPrJ4u3v2prYAbzXBLN3Ky1
         shSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=afKePXV5UqK2ZUvdMymIq9tPCqQ112HpkYrwABU1zys=;
        b=gaGKBQnKWGKSqGCjmB8QRDyHyBqOI8cAil5Hb3gq4N8AY2Fm/Q0dSGQLfheFqy3I0L
         GuQmT6ie1+Lq8PNsq8rBg3G3ZXRfn/ggVZ560xODB39Ngrxy8iu2II+CQ/G4RJUp55hV
         DeK6yMocgPIH+w0jZyj7yaL0NX4qs0LJ5JM5LkPCUx36uCvJVV3UUyk/f7AAsyKUEhHC
         rlY8zg7dnyfYYAcIp+OQUDjar62moQM4sJy8ElwotZNXRSkLDYdMKXRGmxz3Pd9BLO2w
         XDgFFV0v1ElGjLeZCyP5UYF424nnsv1XaiarAacE3rzyd2O1cGBkv+R5hs9r3xR20qhD
         Krtw==
X-Gm-Message-State: AOAM531vo1nZDzDT3+ea8d2ZgDZDayrE0ymr5Zo8+9qzJbaag62h06vn
        ROJXGsUKZFOCA5mrad5hM6BVQB+E4fXbGonDvMM=
X-Google-Smtp-Source: ABdhPJwsR1pqQeQXVBF9HsfqPyD6Jf+HlQNxH16z4gWGUDFriR0DiCQ9c6m7YstoWMpumx7pSDsBYSFEhAx+d8iNeW0=
X-Received: by 2002:a05:6402:2213:: with SMTP id cq19mr21276373edb.337.1590517556754;
 Tue, 26 May 2020 11:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200506163033.3843-1-m-karicheri2@ti.com> <87r1vdkxes.fsf@intel.com>
 <CA+h21hqiV71wc0v=-KkPbWNyXSY+-oiz+DsQLAe1XEJw7eP=_Q@mail.gmail.com> <a7d1ebef-7161-9ecc-09ca-83f868ff7dac@ti.com>
In-Reply-To: <a7d1ebef-7161-9ecc-09ca-83f868ff7dac@ti.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 26 May 2020 21:25:45 +0300
Message-ID: <CA+h21hp+khuj0jV9+keDuzPDe11Xz1Rs8KKkt=n8MeWVHkcmvQ@mail.gmail.com>
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Murali,

On Tue, 26 May 2020 at 17:12, Murali Karicheri <m-karicheri2@ti.com> wrote:
>
> Hi Vladimir,
>

> I haven't looked the spec for 802.1CB. If they re-use HSR/PRP Tag in the
> L2 protocol it make sense to enhance the driver. Else I don't see any
> re-use possibility. Do you know the above?
>
> Thanks
>
> Murali

IEEE 802.1CB redundancy tag sits between Source MAC address and
Ethertype or any VLAN tag, is 6 bytes in length, of which:
- first 2 bytes are the 0xf1c1 EtherType
- next 2 bytes are reserved
- last 2 bytes are the sequence number
There is also a pre-standard version of the IEEE 802.1CB redundancy
tag, which is only 4 bytes in length. I assume vendors of pre-standard
equipment will want to have support for this 4-byte tag as well, as
well as a mechanism of converting between HSR/PRP/pre-standard 802.1CB
tag on one set of ports, and 802.1CB on another set of ports.

>
> --
> Murali Karicheri
> Texas Instruments

Thanks,
-Vladimir
