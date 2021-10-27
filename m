Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BD443D60D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 23:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJ0V4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 17:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229705AbhJ0V4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 17:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5D5B610CA;
        Wed, 27 Oct 2021 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635371652;
        bh=P97TBuOSU6VCfn0fOqxvrzobUnZ38EQAx73aJ380G0I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=M3VfebhT9aqmPN+g46qbnnrewNbanEgi94dTcPhTU7mpjH5jB8Y7+HKwlB8s7jjVw
         AhPYMHtft/LjFNLK9Hsgj2L68/zVZEBGbpWec7MeDUupldbzjTlVnOAleK8/azkKW8
         iFoc69n5G3V3irQEsvfGSmy36nnA8Gg9ufrGzY2OC7kVp2uH4tt5vzrFHWkHMKIJj/
         7wTkzJE1LXtsccFy9kec2XLrFpEWyaIMu7GE41Q4IEaMYAg7teyu8b/AaSKfJARIyI
         Nlg/tP+rBkWt+6QT1/8s4X3SDvNG/rDkbALb4JlBMtTBjRHbngtdRbmIuIn7wfMf0g
         O4mAIg9NwhW1g==
Received: by mail-ed1-f53.google.com with SMTP id h7so16646998ede.8;
        Wed, 27 Oct 2021 14:54:12 -0700 (PDT)
X-Gm-Message-State: AOAM530fbq34jSycT0x21NOeLtHrwJpN0NtDgzse7kJYY+zas2mkQlcW
        hSJ/zyTxheAeFH+pDZuyIBkq+j0spsetsTO7wA==
X-Google-Smtp-Source: ABdhPJz4kxW1DR4UGq5S1PijHQ34O4WuSLKy+4MFc+0p8RGDh6RSrjWvUEec/qgQMkxVs4c2i1XYv6o1JFKR1o6WZok=
X-Received: by 2002:a17:907:7f10:: with SMTP id qf16mr244409ejc.390.1635371651311;
 Wed, 27 Oct 2021 14:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
 <20211006035407.1147909-2-dmitry.baryshkov@linaro.org> <YXf6TbV2IpPbB/0Y@robh.at.kernel.org>
 <37b26090-945f-1e17-f6ab-52552a4b6d89@linaro.org>
In-Reply-To: <37b26090-945f-1e17-f6ab-52552a4b6d89@linaro.org>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 27 Oct 2021 16:53:59 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLAnJqZ95_bf6_fFmPJFMjuy43UfP2UxzEmFMNnG_t-Ug@mail.gmail.com>
Message-ID: <CAL_JsqLAnJqZ95_bf6_fFmPJFMjuy43UfP2UxzEmFMNnG_t-Ug@mail.gmail.com>
Subject: Re: [PATCH v1 01/15] dt-bindings: add pwrseq device tree bindings
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 9:42 AM Dmitry Baryshkov
<dmitry.baryshkov@linaro.org> wrote:
>
> On 26/10/2021 15:53, Rob Herring wrote:
> > On Wed, Oct 06, 2021 at 06:53:53AM +0300, Dmitry Baryshkov wrote:
> >> Add device tree bindings for the new power sequencer subsystem.
> >> Consumers would reference pwrseq nodes using "foo-pwrseq" properties.
> >> Providers would use '#pwrseq-cells' property to declare the amount of
> >> cells in the pwrseq specifier.
> >
> > Please use get_maintainers.pl.
> >
> > This is not a pattern I want to encourage, so NAK on a common binding.
>
>
> Could you please spend a few more words, describing what is not
> encouraged? The whole foo-subsys/#subsys-cells structure?

No, that's generally how common provider/consumer style bindings work.

> Or just specifying the common binding?

If we could do it again, I would not have mmc pwrseq binding. The
properties belong in the device's node. So don't generalize the mmc
pwrseq binding.

It's a kernel problem if the firmware says there's a device on a
'discoverable' bus and the kernel can't discover it. I know you have
the added complication of a device with 2 interfaces, but please,
let's solve one problem at a time.

Rob
