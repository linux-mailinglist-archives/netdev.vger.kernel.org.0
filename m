Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC79455465
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 06:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbhKRFrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 00:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243147AbhKRFrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 00:47:03 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58DBC061764;
        Wed, 17 Nov 2021 21:44:03 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id w23so11218617uao.5;
        Wed, 17 Nov 2021 21:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FVy3FNnBFcKLJXcnpbtykq1xYntqBN9ieNbLU4C5z0g=;
        b=aPBHEIevttwCR7gAlJqA1f8miBxmqcPxb6KqW6IroV5/071F9ACwBj8yPoviAhKsNk
         36J3GaCSZnxFpUfa2/vpZrswUca40RvKY9NMyu2XMNDTM3XdCpvVrSksKivYNA5SXBcg
         QV+vz7unBAPyINAnGNRkNFvmg7vMCtag6gEdo/S9d7Rk/UlXbN0jLPt2//Ct1diNs4JS
         8YlNrh8845EfmTiSwJqMmVVZgVH+vU4zCbdsQziadigNKecp3NUhKS7FNOb8TyGpED7P
         3n+Wg9N0Z3pAseB2hmRfX/1+bo2TdnVL048QX3Z6UEXzmRyH0aKGVTuIIfgaVflR3yb3
         jNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FVy3FNnBFcKLJXcnpbtykq1xYntqBN9ieNbLU4C5z0g=;
        b=MSpN+Ia246niMtEU2sw3FVVFTFQ0XSUfNZDbJGA2Lw88QcXnYluyRZw59ncl1r9gnK
         IaRdJQuizgDJPEOlRod1z9/veHBvrzzUI+p5l/OzBZ+vNeeHw92t2hPR+eb48tIF26tT
         szh6DVtlHgSi12RXYvSvRJ72c1V8BfXVURNkPGuA8G0gKCtbPdVpfPhN3Ryf6Cd6pvHM
         yMTnNP1/gglwPeWj4WdAxTY9suyuGsKKtcah1O0cRS+Sy/D255HAery/60tf3PnRqZT8
         dfFxqR7w4D2DA/9+q6mh/OpPkxYtHpuGSlaaYnydayZOQpLea7OqGVHoIsaSFcUyRelw
         A0lA==
X-Gm-Message-State: AOAM53284TFBcyLpOrOnVSc1H8puR0as/uh4Nz2dGUPx23BMWn2p49cP
        PZH1mhphwp/0X/S9z38f/p0rpt7laY8tl5U665SyCaBm
X-Google-Smtp-Source: ABdhPJxcVUaUD0D5mqcyxovyXA/V3u0V9Tcr7bZUEiJPIEfG2nQM2mKdjhAzBbAhK7bm7V6AFI/Vv2NOb2cxxztZKCc=
X-Received: by 2002:ab0:6942:: with SMTP id c2mr32580204uas.92.1637214242701;
 Wed, 17 Nov 2021 21:44:02 -0800 (PST)
MIME-Version: 1.0
References: <CAA=hcWSRO7Khj8XZbq6fzA6sEN0urR4SeJZh2YcrGe6g8d9ZdA@mail.gmail.com>
In-Reply-To: <CAA=hcWSRO7Khj8XZbq6fzA6sEN0urR4SeJZh2YcrGe6g8d9ZdA@mail.gmail.com>
From:   Jupiter <jupiter.hce@gmail.com>
Date:   Thu, 18 Nov 2021 16:43:26 +1100
Message-ID: <CAA=hcWQSCmuWsVNcjeyS5BYY9pFQ12KUzozRY3i=9TnHkGsvMg@mail.gmail.com>
Subject: Re: mwifiex_sdio and mwifiex failure
To:     linux-wireless <linux-wireless@vger.kernel.org>
Cc:     netdev@vger.kernel.org, Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

After debugging, I figured out why mwifiex failed and could not be
recovered, but I don't understand why, appreciate anyone's kind
advice.

I have both mwifiex_sdio and mwifiex modules installed during kernel
booting, here is how I manually made it failure:

# lsmod
Module                  Size  Used by
mwifiex_sdio           36864  0
mwifiex               278528  1 mwifiex_sdio
option                 45056  0
usb_wwan               20480  1 option
usbserial              36864  2 option,usb_wwan
evbug                  16384  0

# ifconfig
mlan0     Link encap:Ethernet  HWaddr D4:CA:6E:A4:E9:D4
          inet addr:192.168.0.102  Bcast:192.168.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:107 errors:0 dropped:0 overruns:0 frame:0
          TX packets:113 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:13059 (12.7 KiB)  TX bytes:13989 (13.6 KiB)

Now I made it failure:

# modprobe -r mwifiex_sdio
[ 1609.691798] mwifiex_sdio mmc0:0001:1: info: shutdown mwifiex...
[ 1609.774118] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
[ 1610.019431] mwifiex_sdio mmc0:0001:1: deleting the crypto keys

# lsmod
Module                  Size  Used by
option                 45056  0
usb_wwan               20480  1 option
usbserial              36864  2 option,usb_wwan
evbug                  16384  0

The WiFi interface was gone.

# modprobe mwifiex_sdio
[ 1634.073391] mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
[ 1634.080781] mwifiex_sdio mmc0:0001:1: WLAN FW is active

[ 1644.176847] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
Timeout cmd id = 0xa9, act = 0x0
[ 1644.186272] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[ 1644.192181] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[ 1644.198224] mwifiex_sdio mmc0:0001:1: is_cmd_timedout = 1
[ 1644.203691] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[ 1644.209181] mwifiex_sdio mmc0:0001:1: last_cmd_index = 1
[ 1644.214563] mwifiex_sdio mmc0:0001:1: last_cmd_id: 00 00 a9 00 00
00 00 00 00 00
[ 1644.222127] mwifiex_sdio mmc0:0001:1: last_cmd_act: 00 00 00 00 00
00 00 00 00 00
[ 1644.229767] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 0
[ 1644.235576] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 00 00 00 00
00 00 00 00 00 00
[ 1644.243565] mwifiex_sdio mmc0:0001:1: last_event_index = 0
[ 1644.249200] mwifiex_sdio mmc0:0001:1: last_event: 00 00 00 00 00 00
00 00 00 00
[ 1644.256667] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=0
[ 1644.262386] mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0
[ 1644.277044] mwifiex_sdio mmc0:0001:1: info: _mwifiex_fw_dpc:
unregister device

That made mwifiex_sdio failed and no longer be able to be recovered

# lsmod
Module                  Size  Used by
mwifiex_sdio           36864  0
mwifiex               278528  1 mwifiex_sdio
option                 45056  0
usb_wwan               20480  1 option
usbserial              36864  2 option,usb_wwan
evbug                  16384  0

# ifconfig
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:102 errors:0 dropped:0 overruns:0 frame:0
          TX packets:102 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:8222 (8.0 KiB)  TX bytes:8222 (8.0 KiB)

Is it because restoring mwifiex_sdio could not restore crypto keys?

Could you please advise why running modprobe mwifiex_sdio is not working?

Thank you very much.

Kind regards,

- jupiter


On 11/13/21, Jupiter <jupiter.hce@gmail.com> wrote:
> Hi,
>
> I am work on a Linux embedded IoT device including both 4G LTE and
> WiFi modems, I use linux-firmware-sd8801 and Marvell driver
> mwifiex_sdio.ko and mwifiex.ko drivers, it works well for a couple of
> days, then the WiFi failed which could be caused by low WiFi signal
> strength level, but that should not cause the mwifiex_sdio errors.
> While the connman was able to switch from WiFi connection to 4G LTE
> connection automatically, following error messages popped up in
> console and kernel logs every second to consume lots of resources
> despite the 4G LTE being connected and worked perfectly.
> ...............
> [924785.415505] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
> [924807.818102] mwifiex_sdio mmc0:0001:1: Ignore scan. Card removed or
> firmware in bad state
> [924808.406775] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
> ...........
>
> I am not quite sure if the error message indicated the mwifiex_sdio or
> kernel crash or not, but given the 4G LTE was connected fine, the
> device was still in good operation, I don't think it is a kernel crash
> sign.
>
> My questions are:
>
> (a) Is there any way to recover the mwifiex_sdio or reset
> mwifiex_sdio? I tried modprobe -r mwifiex_sdio, modprobe mwifiex_sdio
> and modprobe mwifiex, but that crashed my debug console despite the
> device was still in good operation. I could only make it recover by
> rebooting the device which was not a good solution as it was operated
> 24 / 7.
>
> (b) If there is no way to recover or reset mwifiex_sdio, are there any
> methods to suppress mwifiex_sdio endless error messages to both debug
> console and to kernel logs?
>
> Thank you.
>
> Kind regards,
>
> - jh
>


--
"A man can fail many times, but he isn't a failure until he begins to
blame somebody else."
-- John Burroughs
