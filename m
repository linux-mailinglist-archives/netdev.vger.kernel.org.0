Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5712A0B25
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgJ3Qb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3Qb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:31:29 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E364C0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:31:29 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id t67so1573456vkb.8
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qThycZlY35Fu+nFZrEYkIAp2vY16f57fpwiIrImev4U=;
        b=USzDLSqj6P9+1PDXDZy/GxdClMB/FrmI85QN6u1p5FV7sx7jBEzc/ETKwhdrtJvdFF
         jLi6B5LQjYj8CDrccioG3mTXjleUAOJ1lbZR2V0Q7kYiYDtfY0Kl/esXgqrVDyOyG4KI
         Xv8ylF3Zh2JOvvTh3YVPh1SnbjWwh1gTxzdKEv60szxT9Zgbs/mOFHYFZ18oYpTQZZ5G
         MnY1q/u+iE1Zw0z6KmHXkdf+vj20bn6PK3pSNrhS5aJDWgmU/QgGsrm8Qo/+T4x7XAZi
         k/Z4vLQcIgFDTjV0XKdUogJhX9+1EdIzP1uPo5UM1rsFkc+tGFNC/h1s+x1vwsdrmrRv
         8/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qThycZlY35Fu+nFZrEYkIAp2vY16f57fpwiIrImev4U=;
        b=kqf7o0WpdE8Rx/oRhcYGc61wqZ9ou44ebkoF7XFO3QojCsaEogApl93ZC6rEG/Dzcu
         AevnEa7WqdOhEPZMPCBtFTMluFiJIaOLBY3h5DZc84eAQ7VXz545378Gyr3JURKUqqWO
         63ZD+8/SEyl24Of/waGaIZniH7whi3PmCPKikIkUwdiI+AXBC612+B2/P2/Iw2Gzuz6Y
         NAhqY5CoWV27Arn54J3fh0cKm2abAnxlyXxtbimm8q4zOi0CGLHtcVL07uxyfHoP++jA
         k574L6oOxjaqGP58npTppZxdRRYvoSnVDbnnSm8jTa5r5bLCJz3Rsqsc3/QmPBs8Yz7H
         ptjQ==
X-Gm-Message-State: AOAM533AIQSa9/6JAFp/VHVTmjyQADbDUMVrcOHfTYdN25/h874BE1aW
        MypziUzlDlq9Tu9KEyGiOFqWOc1q07o=
X-Google-Smtp-Source: ABdhPJyM1AxPWSFtckvM2Ww/7OcaC+MNirXRXhr6kGeF5yh53osDB1MKODSy5i/rrL6rb2zdYZiB+A==
X-Received: by 2002:a1f:a94c:: with SMTP id s73mr7848023vke.19.1604075487812;
        Fri, 30 Oct 2020 09:31:27 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id 15sm776012vkx.19.2020.10.30.09.31.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 09:31:26 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id b3so3720438vsc.5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:31:26 -0700 (PDT)
X-Received: by 2002:a67:b607:: with SMTP id d7mr8286222vsm.28.1604075485686;
 Fri, 30 Oct 2020 09:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com> <20201030022839.438135-4-xie.he.0141@gmail.com>
In-Reply-To: <20201030022839.438135-4-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 12:30:49 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe4yGowGs2ST5bDYZpZ-seFCziOmA8dsMMwAukJMcRuQw@mail.gmail.com>
Message-ID: <CA+FuTSe4yGowGs2ST5bDYZpZ-seFCziOmA8dsMMwAukJMcRuQw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/5] net: hdlc_fr: Improve the initial checks
 when we receive an skb
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:33 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> 1.
> Change the skb->len check from "<= 4" to "< 4".
> At first we only need to ensure a 4-byte header is present. We indeed
> normally need the 5th byte, too, but it'd be more logical and cleaner
> to check its existence when we actually need it.
>
> 2.
> Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
> the second address byte is the final address byte. We only support the
> case where the address length is 2 bytes.

Can you elaborate a bit for readers not intimately familiar with the codebase?

Is there something in the following code that has this implicit
assumption on 2-byte address lengths?
