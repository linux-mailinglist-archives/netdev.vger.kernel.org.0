Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA80947581B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242184AbhLOLqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:46:05 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36592
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242166AbhLOLqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:46:03 -0500
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E65083F177
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639568754;
        bh=5tMBnwEs/vWNX4NTSLds+QqZD5aWu/S+gNf17CfK8JM=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=gKAAjWnf6eyvld4pu+iUzfSt7aerWYN2egw9cjUkQjlR9UPwgfaem8gvsCwv3pXpX
         leq353L6I6W1r1/iv4im2lL0HY67Gg2Cvd7CgqVAhihguLRb+pmvQEEDHzY58ty5L3
         R0QtKfPy5jkDa4cx8aUSzGmalEnCquX8FENOM/TslbcR4kf5+Rt8lxxlEbVUAUSP14
         +X0BIwC0t2v+7jT+waOK3nLLXkajMLISgHwjoojhrTIdQDCg469ovbw9oQmyvvbL2/
         /cuFAVgie8VddgkRXGoE3qk2npCtvFuLfl7gSG7xL9akqGarHLyBMsxZirU9XaLmqM
         Gm72Myrn3b4sg==
Received: by mail-ot1-f70.google.com with SMTP id c22-20020a9d67d6000000b00567f3716bdbso9627828otn.11
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:45:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5tMBnwEs/vWNX4NTSLds+QqZD5aWu/S+gNf17CfK8JM=;
        b=55inTLI5h/ibGoBCHGqQ+MSjhW9fPwi7qsg8HAXUPpJF+i5epGexRl7C5Me5gpr90H
         zWDEGFhD+kjs9r6uYX4qn47lqfAzQqhXA5LCjJPjvIFCaXwqjIxdXa/b25XCbev3yoH1
         UoBti19PINKCWbwp/WZbkjasufI9TC+3qFFtYlMlMGVY/97o+p+2K4v5e/6H3qwBswsq
         1PrDRqcgsTlK+aX09NU4CDM9aDAtJ/XBOVoOCj6YrYVPgvrAP/Q2fFYJ4VU7ip1m/HwN
         VuItsEvyV+GiMDwA4bMKtF+H8hOoDZpLWE/l702zmr5G+TU4OKSTuzRWToQyUJQHIBAS
         UKtg==
X-Gm-Message-State: AOAM531cCwZYNWPEXBbl5dEX+jY+VOHybCh+rmDTbbzrRUPYnUg8TD3I
        F7XuQCvbRDNjGp5w/w5oA1opQzpHiTwfmmUvUEQK4G3aCHC7YD/TRd5GzMGkQ0VaPWIYuu0pAKU
        wvuzu8UBMLf2cf3fotys2gjSQeBgjkB3549i2anu9SwLYG38k/w==
X-Received: by 2002:a05:6830:1d87:: with SMTP id y7mr8276899oti.269.1639568753843;
        Wed, 15 Dec 2021 03:45:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUZs3tekHx4L7AzmeZS7ZHKZrzmVXmBqWxSo92TBMGIxeMG8WyBZlVeLYPA06s3SesslmBxwaGtWlDT9HtkMs=
X-Received: by 2002:a05:6830:1d87:: with SMTP id y7mr8276881oti.269.1639568753625;
 Wed, 15 Dec 2021 03:45:53 -0800 (PST)
MIME-Version: 1.0
References: <20211215065508.313330-1-kai.heng.feng@canonical.com>
 <CAPpJ_eff_NC3w7QjGtYtLjOBtSFBuRkFHojnuPC7neOmd54wcg@mail.gmail.com>
 <1bf16614c29e47d8a57cfd6ee4ee50ae@realtek.com> <CAPpJ_efxbsd=DuP6gq-YB4q195oa+wtZ9qaPdT=o20b6Ojy9Gw@mail.gmail.com>
In-Reply-To: <CAPpJ_efxbsd=DuP6gq-YB4q195oa+wtZ9qaPdT=o20b6Ojy9Gw@mail.gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 15 Dec 2021 19:45:42 +0800
Message-ID: <CAAd53p76S7kgHerKosj3P+u2h6TBAS9H0kK_cHDQqGg1SC=83A@mail.gmail.com>
Subject: Re: [PATCH v3] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
To:     Jian-Hong Pan <jhp@endlessos.org>
Cc:     Pkshih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 6:07 PM Jian-Hong Pan <jhp@endlessos.org> wrote:
>
> Pkshih <pkshih@realtek.com> =E6=96=BC 2021=E5=B9=B412=E6=9C=8815=E6=97=A5=
 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=884:03=E5=AF=AB=E9=81=93=EF=BC=9A
> >
> >
> > > -----Original Message-----
> > > From: Jian-Hong Pan <jhp@endlessos.org>
> > > Sent: Wednesday, December 15, 2021 3:16 PM
> > >
> > > Tried to apply this patch for testing.  But it seems conflicting to
> > > commit c81edb8dddaa "rtw88: add quirk to disable pci caps on HP 250 G=
7
> > > Notebook PC" in wireless-drivers-next repo.
> > >
> >
> > I fix the conflict manually, and the ASPM setting is expected.
>
> Yes!  Same from my side.

Sorry for that, I used the wrong tree.
Will send a new one.

Kai-Heng

>
> Jian-Hong Pan
