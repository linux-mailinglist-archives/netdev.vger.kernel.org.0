Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029A55FE4B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfGDV5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:57:31 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37793 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDV5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:57:31 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so10855761iok.4;
        Thu, 04 Jul 2019 14:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nj+rzUZGPqNyT1DZeu2Av7HuuzM7T7JYl6p3NYhknn8=;
        b=Ujp3QmVs+l454k/ITR9Axi10EwfvczIkphlFECMdXBQeuBvmjjJfcVmgJdnwW/+AlN
         IUG3TXy9g8xKjXufXQnQA/DVlYqHnSTRFrD9DEcd+TtRrSnQ3kFRHP9L8O0qOcisu+Lv
         aiAL8wseNs7zTvYeonZkYT0hUi3aRJgBx0hlPK03EUVMocUbjEQogSEME5nBRJ+ricaM
         uV06V5oxmEgjjsNrEKj9YCCyHa01234qXID4WxdUddbXxEkSIeKn+yMLPpfxMRARmwvY
         m3kJiik8YQ3y8R+p/Sir8zZr240zrIdnqrybm9ZjCk7E13Hfp1621AxMuDV6qs+fTV04
         ZfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nj+rzUZGPqNyT1DZeu2Av7HuuzM7T7JYl6p3NYhknn8=;
        b=ERLzakgy8YwwQ+P71ovH6SURYnRrW3SC3ytSpAdvebT829gyzsoMgQjbBgBjkQ6HxH
         elljndwFjRKgsH9X4u5jm7oIqIsEAW99u+iCxjYrqjKr2NhOhT9CON1c3S6S+09rrUF9
         gW4BBPRCpExwWoIu5mlEyNLvCBNAPlpQbGMzPXyWkSq6H/2HuAd3Wj6ZMHpN0XJ6h/xE
         mN9L/kS7NOb/61W5p94NOm9/ajVtgc8/74hNPIl4V/fl3sqt1lFcB0dCYijXjk0g5724
         UOnbdrl5kI2Nea3W3vztyo8MoHbzj9hoqXYtIp+xq2fJvGhNvRtKILEPMSkWZVdAhyqW
         tlVw==
X-Gm-Message-State: APjAAAXJq0n1bVgSEcN5o6m52C7SjvA6Hbt4Fk7ULzMTx5VfdLFVhmuF
        ER4CebFLPSxp4cyZoaZOKbz56dtvgKFG8HUPxk4=
X-Google-Smtp-Source: APXvYqyR6CruPNYROHA1gS+xODfFPQgVwSBzFGUGReZxEolIGxk1Z8sJWGXQQ+OzCtK4IAAFLY2UQJdKdV/SFDZ2eKs=
X-Received: by 2002:a02:878a:: with SMTP id t10mr393023jai.112.1562277450605;
 Thu, 04 Jul 2019 14:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190703171924.31801-1-paweldembicki@gmail.com>
 <20190703171924.31801-5-paweldembicki@gmail.com> <CACRpkdYsA5437Sb8J539AJ=cYtnO2MiD7w7V_Emrmk8dNKbaEQ@mail.gmail.com>
In-Reply-To: <CACRpkdYsA5437Sb8J539AJ=cYtnO2MiD7w7V_Emrmk8dNKbaEQ@mail.gmail.com>
From:   =?UTF-8?Q?Pawe=C5=82_Dembicki?= <paweldembicki@gmail.com>
Date:   Thu, 4 Jul 2019 23:57:19 +0200
Message-ID: <CAJN1Kkydjopnd8tZ+RgRUNXW1k6ygFGaaFZvCzB+RDp1K6KFFg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] net: dsa: vsc73xx: Assert reset if iCPU is enabled
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/19 09:22 Linus Walleij <linus.walleij@linaro.org> wrote:
>
> My devices do not have direct access to the reset line so I
> can't assert reset no matter how I try, if it works for you, the
> code is certainly better like this.
>

In P2020RDB, VSC7385 reset is connected to GPIO. U-boot put binary
file to iCPU and make VSC7385 unmanaged.
However reset flush internal memory and iCPU stop.
In this case bootlog looks like that:

[    2.989047] vsc73xx-platform ffb00000.switch: VSC7385 (rev: 2) switch found
[    2.996192] vsc73xx-platform ffb00000.switch: iCPU enabled boots
from PI/SI, no external memory
[    3.005057] vsc73xx-platform ffb00000.switch: Chip seems to be out
of control. Assert reset and try again.
[    3.045034] vsc73xx-platform ffb00000.switch: VSC7385 (rev: 2) switch found
[    3.052171] vsc73xx-platform ffb00000.switch: iCPU disabled, no
external memory

Best Regards,
Pawel Dembicki
