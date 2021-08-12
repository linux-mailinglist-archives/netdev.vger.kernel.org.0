Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4132C3EAA91
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhHLTEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:04:49 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:43745 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhHLTEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:04:49 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M7sM0-1mAONY0pLm-004xUp; Thu, 12 Aug 2021 21:04:22 +0200
Received: by mail-wr1-f44.google.com with SMTP id x10so3418903wrt.8;
        Thu, 12 Aug 2021 12:04:22 -0700 (PDT)
X-Gm-Message-State: AOAM530ZPDXRS+I333rSnecsu4DBcfnLBbdy4ZdhfjZ8BQfy0DMT6pZ7
        t6/gb/Wyd7/HQSdNAOC9fUiydZ2AOt2mYHS5DiU=
X-Google-Smtp-Source: ABdhPJwBocUi3IG3QsUz224NwVKkev4OE6vxz7Ij4AkaNFb1lK+hCfJT6oe6ooopUT7Q+AcNXTWPi+MoDVi3X3dAUSc=
X-Received: by 2002:a05:6000:46:: with SMTP id k6mr5826569wrx.105.1628795061835;
 Thu, 12 Aug 2021 12:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210812183509.1362782-1-arnd@kernel.org>
In-Reply-To: <20210812183509.1362782-1-arnd@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 12 Aug 2021 21:04:06 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1p3pXUj+baf=eqnL9_rRF7sJ0=YwmrL=XvS51uP6PR6w@mail.gmail.com>
Message-ID: <CAK8P3a1p3pXUj+baf=eqnL9_rRF7sJ0=YwmrL=XvS51uP6PR6w@mail.gmail.com>
Subject: Re: [PATCH] ethernet: fix PTP_1588_CLOCK dependencies
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Shannon Nelson <snelson@pensando.io>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:OMFCTCcAdV7BnzwJqPXPrGFrLO+rG/yxxFvtzA1gab3ip3elix5
 wsOTsZvIVpu4DoBepDNTTuD+1S5Q/Q5UIUkNcelqrXQZsQl8QfZk+e6upVRGlcH+3KcieAR
 wT+wds6vhLK7wKkhA4Mh7YQL3ySpj7L7ZT3tJSvh38HLnEKS8FB0WnTB0hsCB/LsOlaDX93
 6CbbTGRkSlZoHTjrQ4AmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Xk8EzanSYjg=:+WdZANwZvad1zwHpktqLwe
 nX1B5jOWgCJVVGwGfd/Vr96O+CWWNR+YpQAUBNvuXU49/a5Uc1pL9q5TQnbZ5avIGaU/i22Yt
 eTi1Hlk5xcUqY5EBSTvzSzb19/j3BtrH+ZQdHTMGJPGsTRjVWVqC3+8InVgo7J/Qeoaoa7ppm
 HVlrJb7ZChcuTIE5Qnbllzu1L/saJa+nBK7FCX6XfTg4Bjpe117CbFtT00HJbu4TbTSZemkdB
 +sPBBfpM9vJa4xakCXfaPPR5usRbPf7YDfSPz3I7NiNfVODME2saAROIY8l4xM39pcyheXdaM
 tHMYcdc07jGM8iBlLPrYOCUH8Lhl9bfbhtwgupHG7OadAVLXt0gThIP9a5huahgKpUKa4R6tS
 gIeA5+FaGHQMcjy5rvJ2uqgyygdXfwfzTdS3jDanR40B4DtadjWf44v8WsstBOTg6pyqYdtRP
 65x/SzTiBOxvjmiQ0iIbym9GbnA+wVbL5smdnD/eW/jnc2/vmHOOy2B3xtV6b5H2fME0YCUPK
 1fqD4wvJp+6024MGf+x1vj/dZXBWTeGxdU9+EDnCeNOfwoahpnCOsL//M+QT1vTuiAnurA4j7
 PWbtnso7qrmtRduQ8nQSv0jun5mcQxPWgDUpv//C/R9Oo1Hxrh6YfZgj9/6/0nsIk+PFs6Ich
 JRfhe2VKvyRzimJol/vK2ReIL9op6Vml3sDU9mcGHwNKOFFdFpfus1B9EpKXjbi0iuHRvem5G
 bFhj/+H+6UyUzWCpN2/MzH3xvWpVd18LHSuXRLqau8oFk9dQLxRJJCcE4/58dEMB+hzJ1p3Kh
 QC2WRrJ0CZkvd8iDOegKEFeVHMqCMaXi35KbEj1oP27WXDJAri0t1DffOYVzAjkUEnkpeXFIo
 DT8zxmKTiY0KSK15P7Z7SPvU/fFHvtdLR3yo8NDq4wgEBVWOE1oxTWmdijudgt9Hs1QM8QVm9
 t/vfLxwmJTNna+dqAKhzOYzT/dF6ulV/6pE7I8ldW959iyBRpfkKs
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 8:33 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
> Link: https://lore.kernel.org/netdev/20210804121318.337276-1-arnd@kernel.org/
> Link: https://lore.kernel.org/netdev/CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/20210726084540.3282344-1-arnd@kernel.org/
> Acked-by: Shannon Nelson <snelson@pensando.io>
> Acked-by: Jacob Keller <jacob.e.keller@intel.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v6:
> - remove an unneeded dependency in MSCC_OCELOT_SWITCH_LIB

I just noticed I messed up the subject line, it should have been

[PATCH v6 net-next] ethernet: fix PTP_1588_CLOCK dependencies

      Arnd
