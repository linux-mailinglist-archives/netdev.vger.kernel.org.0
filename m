Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABBF4401D1
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 20:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhJ2S1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 14:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhJ2S1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 14:27:03 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D28C061570;
        Fri, 29 Oct 2021 11:24:34 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id o4so14552506oia.10;
        Fri, 29 Oct 2021 11:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+Vc4iJace+i/FzL42dVlqrN2RKNqU6Za2ltRFYR17IY=;
        b=dMO8w24jhk5d3vwbunyndZlMWm+nEqhkLEGDFP+B7Bd6CXNmenllkminC8agQXi9wB
         xneTYClQnl8Yavp3tEkACuhhUvg84MbRCce2FboJNjgNdKhHa7WPih0pvPf7Y2czVywQ
         UGzI07ZilOoneKg+DdQVTHCo+bV6nZY9n8IlgdkknGmIFDaZ8T7wPBqdo7751XOKpHtw
         7xxPTlVkmfBFfdIVNM/tEzveFUpy0+jYr5fxBL9/G+jEoyZqMSSVAx5FTd7coNcLv46p
         MR5lC0nFZ8jgB50C1DUhH+DQLav5EWJp3WepEhKyQ0rqm9IXS1yxdu/cYzGcWZdpD8Cm
         RgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+Vc4iJace+i/FzL42dVlqrN2RKNqU6Za2ltRFYR17IY=;
        b=W0aJ54Ch/TZObO7f+Lc3sL8/4g8I9wQ+Q5N4kOgkpj8/465wSz2l5ywElz78UdEjiV
         d8J9bCYz1gdoRZqqzQQtseuKmxkDA8MItuxqi2EIoosDGakn7qZ2ep/s5SxXCkyyyoec
         M3jtJFE/Nmk8JQqahCmnVkLBq16Png6TR2y1EfHV4Aa9yHBvvFt7f3mpnTdm5dG7qcPq
         Ug+d51NMkSeBeQRU/eh+p5VMMpfix+aVYpMy07/zcyAoiTK2GTwMyeKoR4KmuHYMB/gF
         +j0v1tzx/MnJfxqzdhWNEOMyqQthWOVWoRIeEa9zQdK6/m4PL7KUwE20f5ELyowcL+ES
         HNfg==
X-Gm-Message-State: AOAM530XjsRNFukVAPNYdV4nDdeOpN1uZu4fnCSyRt+gxmGl09xkXPpi
        8bFQo/Ph4wa0kS2Z1RpTvb4=
X-Google-Smtp-Source: ABdhPJzPuTygDsR+C2LhLewXnY2VnJ9eyAyQsmjF1zExA0KrCUoybSlxoS1bf9hxHOPtqEgV/3gpbQ==
X-Received: by 2002:a05:6808:1a27:: with SMTP id bk39mr15235698oib.89.1635531874155;
        Fri, 29 Oct 2021 11:24:34 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k4sm2034058oic.48.2021.10.29.11.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 11:24:33 -0700 (PDT)
Message-ID: <9ec9011a-d240-e00a-38e2-51f8e2661a3d@gmail.com>
Date:   Fri, 29 Oct 2021 12:24:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH net 2/2] selftests: udp: test for passing SO_MARK as cmsg
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        willemb@google.com
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
References: <20211029155135.468098-1-kuba@kernel.org>
 <20211029155135.468098-3-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211029155135.468098-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 9:51 AM, Jakub Kicinski wrote:
> Before fix:
> |  Case IPv6 rejection returned 0, expected 1
> |FAIL - 1/4 cases failed
> 
> With the fix:
> | OK
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: shuah@kernel.org
> CC: linux-kselftest@vger.kernel.org
> ---
>  tools/testing/selftests/net/.gitignore      |  1 +
>  tools/testing/selftests/net/Makefile        |  2 +
>  tools/testing/selftests/net/cmsg_so_mark.c  | 67 +++++++++++++++++++++
>  tools/testing/selftests/net/cmsg_so_mark.sh | 61 +++++++++++++++++++
>  4 files changed, 131 insertions(+)
>  create mode 100644 tools/testing/selftests/net/cmsg_so_mark.c
>  create mode 100755 tools/testing/selftests/net/cmsg_so_mark.sh
>
Reviewed-by: David Ahern <dsahern@kernel.org>

