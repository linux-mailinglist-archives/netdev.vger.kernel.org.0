Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E1A3F2CCB
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhHTNJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbhHTNJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 09:09:11 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928BCC061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 06:08:33 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id l24so7403287qtj.4
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 06:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TUaFXYR3HgX7rq/VVrgPte+1/jUiDRhyGavFeUWW8ns=;
        b=qyykdYkmfS+sozWV6prsKemkogSdt6dw3JI6xplGBEyTZrCLVw/V2WrXps+vMYETkc
         8Te8E/naVt9sCYftHN+RQWgeipXTUxRrtvWgldkYCu2Cbe9g6ADwtRoynUE5z+qBzTjG
         54yO9pPGaOTEYQUVc1FEW/T8RQKm7EsP8D7GtvNgk4bFWoxEOLRtHkxavfl9A0+APfke
         fUSP5CH+beQOqMRPOpWAxyXQpPSp8NBKx7ZcRxpsbapjzzBlp12z8K73a7u/zLR3Yi/5
         /eO+ssNjqZxgkZLIbtO1QrlN47VLwXpLqfNwD+gSTbQel6v8qOEG9qHA3WYS7WzopQpP
         XncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TUaFXYR3HgX7rq/VVrgPte+1/jUiDRhyGavFeUWW8ns=;
        b=GqnYb8my1QZRQ1jtZBmZ7EetHCNYkKEAh4M32iW2NVkyVUHfLkqgGXuz+tatxxWAP+
         HI7BiFqYegtIa9vnup+/zr+IwM8ZttpVViPnFaSwgBRV0vbWB1BZETfUZ82PGOWYOt3m
         qMegJJbcA/l1zzlcl4QOWcK45dfb/YWAbXuvHlTzav8PCvEE8Pc1II00x//9lBMwbilf
         7fF3vj1bsj0VrqwD9E1V0nw1nyI+2RUudT+l2uhxPvj2GE8ER73V0pYGikB8G1iN6l57
         QU5vXKXsKMelHRRAj/hP5hTt5pkf2kPrMoWxvW8uhfdN75Dj0KUgLb/x45gP39be94fM
         JU8Q==
X-Gm-Message-State: AOAM5323LJra/P1s/Kntqb3tqT5AmLp5CGOG2oT8DGU2LXCKsXdY7tcC
        aKBcIqAWjsCcGwi//Zqjt+KZWd7ngPwM8HLhCwGY8Q==
X-Google-Smtp-Source: ABdhPJyHXvzqFdkh92xFSl2Tfgr6Wq+GnxyuqFmSQJ3g0FPjwxN9S26JOc0IArVq879EP1YIZ1goBTULRA693ce45J8=
X-Received: by 2002:a05:622a:13c8:: with SMTP id p8mr17705841qtk.238.1629464912762;
 Fri, 20 Aug 2021 06:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org> <1CA665D1-86F0-45A1-862D-17DAB3ABA974@holtmann.org>
In-Reply-To: <1CA665D1-86F0-45A1-862D-17DAB3ABA974@holtmann.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Fri, 20 Aug 2021 16:08:21 +0300
Message-ID: <CAA8EJpoOxerwmwQozL3gp1nX-+oxLMFUFjVPvRy-MoVfPuvqrw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/15] create power sequencing subsystem
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        MSM <linux-arm-msm@vger.kernel.org>, linux-mmc@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 19 Aug 2021 at 18:23, Marcel Holtmann <marcel@holtmann.org> wrote:
> > This is an RFC of the proposed power sequencer subsystem. This is a
> > generification of the MMC pwrseq code. The subsystem tries to abstract
> > the idea of complex power-up/power-down/reset of the devices.
> >
> > The primary set of devices that promted me to create this patchset is
> > the Qualcomm BT+WiFi family of chips. They reside on serial+platform
> > interfaces (older generations) or on serial+PCIe (newer generations).
> > They require a set of external voltage regulators to be powered on and
> > (some of them) have separate WiFi and Bluetooth enable GPIOs.
> >
> > This patchset being an RFC tries to demonstrate the approach, design an=
d
> > usage of the pwrseq subsystem. Following issues are present in the RFC
> > at this moment but will be fixed later if the overall approach would be
> > viewed as acceptable:
> >
> > - No documentation
> >   While the code tries to be self-documenting proper documentation
> >   would be required.
> >
> > - Minimal device tree bindings changes
> >   There are no proper updates for the DT bindings (thus neither Rob
> >   Herring nor devicetree are included in the To/Cc lists). The dt
> >   schema changes would be a part of v1.
> >
> > - Lack of proper PCIe integration
> >   At this moment support for PCIe is hacked up to be able to test the
> >   PCIe part of qca6390. Proper PCIe support would require automatically
> >   powering up the devices before the scan basing on the proper device
> >   structure in the device tree.
> >
> > ----------------------------------------------------------------
> > Dmitry Baryshkov (15):
> >      power: add power sequencer subsystem
> >      pwrseq: port MMC's pwrseq drivers to new pwrseq subsystem
> >      mmc: core: switch to new pwrseq subsystem
> >      ath10k: add support for pwrseq sequencing
> >      Bluetooth: hci_qca: merge qca_power into qca_serdev
> >      Bluetooth: hci_qca: merge init paths
> >      Bluetooth: hci_qca: merge qca_power_on with qca_regulators_init
> >      Bluetooth: hci_qca: futher rework of power on/off handling
> >      Bluetooth: hci_qca: add support for pwrseq
>
> any chance you can try to abandon patching hci_qca. The serdev support in=
 hci_uart is rather hacking into old line discipline code and it is not agi=
ng well. It is really becoming a mess.

I wanted to stay away from rewriting the BT code. But... New driver
would have a bonus point that I don't have to be compatible with old
bindings. In fact we can even make it the other way around: let the
old driver always use regulators and make the new driver support only
the pwrseq. Then it should be possible to drop the old hci_qca driver
together with dropping the old bindings.

> I would say that the Qualcomm serial devices could use a separate standal=
one serdev driver. A while I send an RFC for a new serdev driver.
>
> https://www.spinics.net/lists/linux-bluetooth/msg74918.html

Any reason why your driver stayed as an RFC and never made it into the
kernel? Do you plan to revive your old RFCs on H:4 and H:5?

> There I had the idea that simple vendor specifics can be in that driver (=
like the Broadcom part I added there), but frankly the QCA specifics are a =
bit too specific and it should be a separate driver. However I think this w=
ould be a good starting point.
>
> In general a H:4 based Bluetooth driver is dead simple with the help of h=
4_recv.h helper we have in the kernel. The complicated part is the power ma=
nagement pieces or any vendor specific low-power protocol they are running =
on that serial line. And since you are touching this anyway, doing a driver=
 from scratch might be lot simpler and cleaner. It would surely help all th=
e new QCA device showing up in the future.

--=20
With best wishes
Dmitry
