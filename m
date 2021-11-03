Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F320444A7B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 22:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhKCVxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 17:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCVxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 17:53:45 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1947AC061714;
        Wed,  3 Nov 2021 14:51:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id j21so14196042edt.11;
        Wed, 03 Nov 2021 14:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7OcZIhudGFzvRt013KeFNV1kJPl7S2GSbEt5QowUR2E=;
        b=VyP26HeYZr1T1u107XSYuTLIm+eXmHYvQewARi2F3OGauywNZtUiI53vrN3TZ5n4k9
         mV+Cro3OFhIM+24VyFYNe4ApYy8d/43DVfB1TsVLEzTtpp+cdoLMa1fkbY1KsNdQ2UHH
         xbNdWRL4Mv7Agwk7h6AzBmdpOrE6/B/p0ulEuC0zypCNVbIlWPMkNoA+dHCG6aznx6xN
         eSJbkfAMxVjKK+k/jdTSVgRwTrLffncuCzBR3AR6zY/3tKkOWHMYQtnASLeORVWqxgHs
         PXRenasXj6DNnoX7z/l6VhI19J7PJhw8KYNGqPnMxn4tH8tYzoBiFR1KvpefREwkHLw0
         svRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7OcZIhudGFzvRt013KeFNV1kJPl7S2GSbEt5QowUR2E=;
        b=zK3QPyAuMDx0VbrAE8W2UEysceBjoPcR7sB78XeN1Z/bwsJ9PD7nGINraC9sc8dBjD
         FSuEg42RUWX0tDbo2gSFRMNNI0hDXrGIbH/q4CiOiKNjegGr+5NZkcGmbvXXftl0IRWf
         /tu7e+6IMINM979psR5zCg/RhkU3IUk+NtN1b/acU5nKgkEVCMChuDehD7xM3VQw2R35
         baBHzMSi+i/lqaDWT6wc876gWwuVvK3ltVpo2mc4PqSkBJIafAxh0y9TM2ve8XDzN1rW
         0dcD88IX94enGTKTx1w3DlMsl9f0h5qu9yi0B1sAq2VJirRnIqTi3LvdhIDGv8NiVOSL
         Ka6Q==
X-Gm-Message-State: AOAM533dQjuzojNlHgfntgTL8CSTkqrKKdpnNcdEuQr7+YoqY4sKBZWQ
        mB/Noai3hWE4T9U2L+Gu8EzYTXTVmT+u7cuN2fw=
X-Google-Smtp-Source: ABdhPJyIwYKcjVc7PLDW4XsdWFtHIEsVMr4uKCTCvtgwHzDRZ8qegkwwyYgwj7BOn8XgoNXIIbe8CRSo1pnELvFXFL4=
X-Received: by 2002:a17:906:2887:: with SMTP id o7mr56276433ejd.425.1635976266640;
 Wed, 03 Nov 2021 14:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211103201800.13531-1-verdre@v0yd.nl>
In-Reply-To: <20211103201800.13531-1-verdre@v0yd.nl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Nov 2021 23:50:29 +0200
Message-ID: <CAHp75VdmynnjFnmxy5ebJ44BpikYt+WaqEhVB6qkftVHGoa2FA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mwifiex: Add quirk to disable deep sleep with
 certain hardware revision
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 10:19 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
>
> Fourth revision of this patch.
> v1: https://lore.kernel.org/linux-wireless/20211028073729.24408-1-verdre@=
v0yd.nl/T/
> v2: https://lore.kernel.org/linux-wireless/20211103135529.8537-1-verdre@v=
0yd.nl/T/
> v3: https://lore.kernel.org/linux-wireless/YYLJVoR9egoPpmLv@smile.fi.inte=
l.com/T/

Not sure why you ignored my tag...
As we discussed with Bjorn, it's fine to me to leave messages splitted
to two lines.

> Changes between v3 and v4:
>  - Add patch to ensure 0-termination of version string


--=20
With Best Regards,
Andy Shevchenko
