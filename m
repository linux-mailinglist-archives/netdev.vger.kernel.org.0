Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FF23DE83B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhHCIV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbhHCIVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:21:54 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038BEC06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 01:21:44 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c16so24324147wrp.13
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 01:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ff8CbE6jGXEso54aflbQk2VZqd85TX8kAjjTf3E2Nkg=;
        b=UW5t912ieE7zLk/2pH3wZsrM17q1hsTlAlclN64xIWil7pk1ce2fJQUPAYgm6L+02k
         m+Bs4HvqS2BUzuUN/NKy1VP86NV4Zn051TYa4G3XJafiMqcti1+EUN3v42jEfFO8aLy6
         WMxmqfpT865mtkM7UQDrjHn2co5uvB6672vKTPQkRep+f+5ybkBkIBFBMnhi48cyA9IA
         9TDTFchguVODAsJXpri63+A/u1JLIgBEUV1RFK+OhDlY0NLkT85zIGNMlnSJSsL2oDDl
         eCIkZj2YxwFzyFguXIeyqCHu/yNp5x1ojPw5BgE+keosUIrh2jXhHpajIimolxbnPkmN
         PltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ff8CbE6jGXEso54aflbQk2VZqd85TX8kAjjTf3E2Nkg=;
        b=YyIbnpFFX3DuzgOrCl7qFzK/JS53btO3vJhCbF2r5jJQIvEwTi/+n/Uf6d24lsGRNB
         rGxAbcpIsDizMVzupgzzuDXP+pUqHUobcgF5m/n+lCMA9gkHscqbYRbW47xVn8PbHn4+
         EBIy5D5WKNHrsUm+feR+Ji/bHdswqPagB75TxnwPLGp3WR4qAPkZTNLVouGuqid8gOt8
         p2jWR2ZPOcf2dpwK4job6g2813QA6xT3hBFPRBC9Q4ADl1COhSZVha2A6GjgUShwbhCf
         2dlfMkU4xpS747ZNKOKGg/DrJSaRNKO8D5KqZf++MqXaBcadsyt/9m6Y26ppiqLzTS/C
         iUeg==
X-Gm-Message-State: AOAM532VUZkCtA1tfDUGmgKptVppmE3cL+tIHueNGq2Bc/5VyL8WTmGC
        midWiLaSAau1ihGA6rFijyQNvA==
X-Google-Smtp-Source: ABdhPJxdD7RF3mIAbn9PzHNHSEOPHH2/jZSzAf8dHX8Fxu5P1cY3R+EphN1AFxnu5QF6SD/R5lnScg==
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr21518572wri.261.1627978902501;
        Tue, 03 Aug 2021 01:21:42 -0700 (PDT)
Received: from localhost ([2a01:cb19:826e:8e00:1497:8bbf:2d4a:ce01])
        by smtp.gmail.com with ESMTPSA id y197sm1839739wmc.7.2021.08.03.01.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 01:21:42 -0700 (PDT)
From:   Mattijs Korpershoek <mkorpershoek@baylibre.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Bluetooth: Shutdown controller after workqueues are
 flushed or cancelled
In-Reply-To: <CAAd53p4Ss1Z-7CB4g=_xZYxo1xDz6ih6GHUuMcgncy+yNAfU4w@mail.gmail.com>
References: <20210514071452.25220-1-kai.heng.feng@canonical.com>
 <576B26FD-81F8-4632-82F6-57C4A7C096C4@holtmann.org>
 <8735ryk0o7.fsf@baylibre.com>
 <CAAd53p7Zc3Zk21rwj_x1BLgf8tWRxaKBmXARkM6d7Kpkb+fDZA@mail.gmail.com>
 <87y29o58su.fsf@baylibre.com>
 <CAAd53p4Ss1Z-7CB4g=_xZYxo1xDz6ih6GHUuMcgncy+yNAfU4w@mail.gmail.com>
Date:   Tue, 03 Aug 2021 10:21:40 +0200
Message-ID: <87a6lzx7jf.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai-Heng,

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> Hi Mattijs,
>
> On Fri, Jul 30, 2021 at 7:40 PM Mattijs Korpershoek
> <mkorpershoek@baylibre.com> wrote:
>>
>> Hi Kai-Heng,
>
> [snipped]
>
>> Thank you for your help. Sorry I did not post the logs previously.
>>
>> dmesg: https://pastebin.com/tpWDNyQr
>> ftrace on btmtksdio: https://pastebin.com/jmhvmwUw
>
> Seems like btmtksdio needs shudown() to be called before flush().
> Since the order was there for a very long time, changing the calling
> order indeed can break what driver expects.
> Can you please test the following patch:
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 2560ed2f144d..a61e610a400c 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1785,6 +1785,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
>         aosp_do_close(hdev);
>         msft_do_close(hdev);
>
> +       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> +           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> +           test_bit(HCI_UP, &hdev->flags)) {
> +               /* Execute vendor specific shutdown routine */
> +               if (hdev->shutdown)
> +                       hdev->shutdown(hdev);
> +       }
> +
>         if (hdev->flush)
>                 hdev->flush(hdev);
>
> @@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
>                 clear_bit(HCI_INIT, &hdev->flags);
>         }
>
> -       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> -           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> -           test_bit(HCI_UP, &hdev->flags)) {
> -               /* Execute vendor specific shutdown routine */
> -               if (hdev->shutdown)
> -                       hdev->shutdown(hdev);
> -       }
> -
>         /* flush cmd  work */
>         flush_work(&hdev->cmd_work);

Thanks for the patch and your help.
I've tried it, but it seems that it does not improve for me.
I'm still observing:

i500-pumpkin login: root                                                                  
root@i500-pumpkin:~# hciconfig hci0 up                                                    
Can't init device hci0: Connection timed out (110)

Logs for this session:
dmesg:   https://pastebin.com/iAFk5Tzi
ftrace:  https://pastebin.com/kEMWSYrE


>
> Kai-Heng
>
>>
>> Mattijs
>> >
>> > Kai-Heng
>> >
>> >>
>> >> Thanks,
>> >> Mattijs Korpershoek
>> >>
>> >>
>> >> >
>> >> > Regards
>> >> >
>> >> > Marcel
