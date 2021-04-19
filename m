Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFF73645B2
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhDSONv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:13:51 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:50201 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbhDSONt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 10:13:49 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MRT6b-1lBCSx1Mvt-00NPDM; Mon, 19 Apr 2021 16:13:18 +0200
Received: by mail-wm1-f50.google.com with SMTP id n4-20020a05600c4f84b029013151278decso6943455wmq.4;
        Mon, 19 Apr 2021 07:13:18 -0700 (PDT)
X-Gm-Message-State: AOAM533PkoFJC64mIl9CfSTKZDMtvWMu8jzFsEkLrth2iWR6p00lQRXH
        Ejj3tvlmnBcX1O+ctQlRP8aKE6Jc0lNklqU451s=
X-Google-Smtp-Source: ABdhPJxfWYQpgkQ73Nyeh2Cp48WIV5Does1Qg89OpygaNxV8Vc57wC3uOquK/ybb1mHpmU/fFGzqMBDByBQcWWgbLFg=
X-Received: by 2002:a05:600c:2282:: with SMTP id 2mr22091204wmf.84.1618841597967;
 Mon, 19 Apr 2021 07:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210419140152.180361-1-colin.king@canonical.com>
In-Reply-To: <20210419140152.180361-1-colin.king@canonical.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 19 Apr 2021 16:13:01 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1X-fNo4PxZi8ZWiRrtdvF0kyB4qYEZYOe81uMgsYy2Qg@mail.gmail.com>
Message-ID: <CAK8P3a1X-fNo4PxZi8ZWiRrtdvF0kyB4qYEZYOe81uMgsYy2Qg@mail.gmail.com>
Subject: Re: [PATCH][next] wlcore: Fix buffer overrun by snprintf due to
 incorrect buffer size Content-Type: text/plain; charset="utf-8"
To:     Colin King <colin.king@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:uSD0cnDzOC2VcjN7ZBcWZ2vvNBUpCz841+gCEkLH5jqq+b3iU+Q
 tzQBON82eKbamHzODxWbZ1sNmLchNWZtXqsw4L7gcEvzN9seh5npI4GnqcWTnpru1RG0LSy
 Tqf72g24MJxZoMnKKdQKxTLVdKVe/oynydBsdv5tonKkDNri+hdm/OC6TcL4uUlHdUPr/1J
 9qetliShfwSKOwzoUgn9A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6mHPdsKEpps=:n7IMC8R//h+tZA7CzdQmjX
 IpSh7Gk1JxEJZLEbTi/9zeJdzEEbZt3NAJMEAQKZK65aW6zWPc9bs0Ed6BcbMEU9Vdoprx++D
 94s4NLx5WPHHhvLCtLXWzL49sJtk2LcWHEHedp58P/k9E9Oi6+K73d69qNZnSLMApnYcUtarW
 YxarviejtZP6lnNjurSvm9i5ThigZfduYrG938IlvsDuCx6IT2F81Qz+P0Qvp/iDOI0q8OYis
 gKcw5SQ7N/ilG3ZuGmpuM8MSI5MaL0b39ZPwFX2otBIQooa1zudH7KR9OBGPrOj+eKthZM30T
 unjtTTGmBwZbfX9zjTgOFtyrPClycOkSSkcoVQ9TZktZT/lqyoCzT9FFIB/R1LpD4PO+4MjbC
 h7HRN1uj6QPPn7ksQX96LHlvygEoIx2JD+ZCDcXjO7+HPymxe1CEUZT2Z8hG/M37mGJVVPMQL
 4eQOcX48DRLIIdxVM+wiQH7UFRJW7fijY6Kzrzolb1GmIJt/OnCp7TNAs8hMTrFV2mr5ztBHv
 6x2g4fSo9/pIZfIBvss2UXJ+hkJC5UoPS903h+WWaiiHK5dxdPIqWy46ddrjiu5KHlvwYkvo7
 AErL3mqW4kNMCiNU7hVXMkt4m1vK25R+//eDhb1Ijx9xd8DJJAGak/WqKlpPL+R0PbtCxoU7i
 iuTQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 4:01 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The size of the buffer than can be written to is currently incorrect, it is
> always the size of the entire buffer even though the snprintf is writing
> as position pos into the buffer. Fix this by setting the buffer size to be
> the number of bytes left in the buffer, namely sizeof(buf) - pos.
>
> Addresses-Coverity: ("Out-of-bounds access")
> Fixes: 7b0e2c4f6be3 ("wlcore: fix overlapping snprintf arguments in debugfs")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
