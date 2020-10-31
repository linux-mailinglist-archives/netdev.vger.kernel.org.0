Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2457C2A18E0
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgJaRGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgJaRGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 13:06:06 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B80BC0617A6;
        Sat, 31 Oct 2020 10:06:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id z24so7500543pgk.3;
        Sat, 31 Oct 2020 10:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=PJHbuD1ltVI0+cZw86Qwo4FowrGthROROrCs8U5sdJM=;
        b=O5bDW1vEAkiK5WMud4wlTl1HA8aCm+ouXIOtRAvOFRy1luu9VshEuHk24IFcPvJe5Y
         JM3W3GWtIVKqqpe/WWVRjA9aJaCABoFxLmRNS5PRedYCINhzUcqth3TRx0NH4oEeIPfA
         yLJaQc56YGLuHAQPm6SZHYXSVfzpiC+/cYjNjLVj9rHhIk0h8LXgzAgaLAmWTOCIEO11
         1hc2ZTuzHf9YxrBtaJfF2e/QD3B9PaqYNZO/J2SkziSZtvCu3erPRcMkcgBX2VWTUyxS
         +yQauRfcZyQvvS4Qn7V/J5OmmD2n8/Zb5XMHnG7y8TKryn1X2TFbgqb8a2fCHfpmtPlF
         tTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=PJHbuD1ltVI0+cZw86Qwo4FowrGthROROrCs8U5sdJM=;
        b=ePvqF6I2NHxgwKb1PdAyKnYASj0igOihDVXCN4EHW0YEbOkBpu51LxxFiuQWLVlYsZ
         /BFZT6bTIhXH2W5GfZMwXyaV50kPqpKNI4kv3TECpHsj3/5Nc0JYN7W0fGVQRQi4UG6y
         vGHkLsIyVmK27w2OZ+lFOHNjmQdhbdjIEKs514xKGb7jIFKezpNLeoWfPJ4osyoqcFyA
         CP/i6s/YdrpgIRHafTLkou7cbKsB6vBmRPp8EmO1wJnRYL/+NEznk5eD0jgk6H/AFGaf
         NTtq6TXSRSNYH1WWuH+n6lUkrcxEVGheg5HFqtWEKW4IMD5wze5X0FoF2Wndx6xnaOwV
         zn5w==
X-Gm-Message-State: AOAM53057IdQBhCpgTON7UZdPmISKRFfKTPzIq44tgl7rEAUOPGVBh1U
        Tm47UjU08Ioz3rC0m6RaXCZroVpxn1ycpa1tdCE=
X-Google-Smtp-Source: ABdhPJyfWol8wiYd2UtlMYDjwgdFMax1fOhwHiKrHUdy1nSByTrQzNXamHikLt58N0kwiSa1IZrAIJ5RFZFrqt2YGPQ=
X-Received: by 2002:a63:3581:: with SMTP id c123mr6962424pga.233.1604163965043;
 Sat, 31 Oct 2020 10:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201031004918.463475-1-xie.he.0141@gmail.com> <20201031004918.463475-5-xie.he.0141@gmail.com>
In-Reply-To: <20201031004918.463475-5-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 31 Oct 2020 10:05:54 -0700
Message-ID: <CAJht_EPH74jjUWjW8DhZpb=dD-7v7oL9g7UzZ-mRo9doeHJLAg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 4/5] net: hdlc_fr: Improve the initial checks
 when we receive an skb
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 5:49 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
> the second address byte is the final address byte. We only support the
> case where the address length is 2 bytes. If the address length is not
> 2 bytes, the control field and the protocol field would not be the 3rd
> and 4th byte as we assume. (Say it is 3 bytes, then the control field
> and the protocol field would be the 4th and 5th byte instead.)

No, I don't think adding this explanation (about why address lengths
other than 2 are not supported) is necessary. The code of this driver
completely doesn't support address lengths other than 2 for many
reasons, not only the reason above. The code for parsing and
generating the address field (q922_to_dlci and dlci_to_q922) supports
only 2-byte address fields. Also, the structure of the sending code of
this driver can only generate headers with a 2-byte address field.
Frame Relay networks usually have a fixed address length, that means a
certain network usually has only 1 fixed address length. If this
driver sends frames with 2-byte address fields, it shouldn't expect it
would receive frames with 3-byte or 4-byte address fields. There are
too many reasons, and I think just saying we only support 2-byte
address fields is completely enough. Explaining the reason as above
seems weird and inadequate to me, and also unnecessary to me.

Therefore, I will resend this patch series with this explanation
(about why address lengths other than 2 are not supported) removed.
