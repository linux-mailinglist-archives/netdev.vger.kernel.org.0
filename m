Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794CF361429
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbhDOVef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:34:35 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:44566 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbhDOVec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:34:32 -0400
Received: by mail-oi1-f171.google.com with SMTP id e66so10470237oif.11;
        Thu, 15 Apr 2021 14:34:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kq7mT824FIfH8P0v4e9lP9ngle/tsiNGQv3sPJt/w+s=;
        b=ZrKb2WiB6MTuJq8O++hHqZKDHptH5SUGTB2/E8MZnK9TbKOI6GkgOl5PEmLem+2iIe
         HuId8C1KAR80iCad0RYLbhkPK/QaZU1E8DDjwS93qaOwVWfFXa0kkcvtNxEhrWcwfEhw
         NB9IV75/LSsnOepNhF0yqd8ldrCVq0tPfavDkhaa+KPwIz/XBSnbt+r3niQFmphg/PfF
         7iymqZKnfc+ZHAz72kYNY2YQkXySM49SgyUMvfz/rR6NDkPCL/NhqijZ3cIIxvU6N+aM
         CGLjQcOmMV7Us/B44sj7+fUTSk+i9KvHc8omcQQSHy09cFHWUl5EBDfC/JiYGMxOz+rD
         jVhw==
X-Gm-Message-State: AOAM531Os3saK/f/CVLRDGZmWeTaaG8zLwWNiW5i5xsKCxX0UokrDIcx
        tZvShW7fb2onKl2PCy68Cg==
X-Google-Smtp-Source: ABdhPJzWwJ5zn3ccsPLLFQ5VcvsaZirz0DmrqQFPT8bDCdt8imAzheOAl1gpqVMmxyJZd6NPHzO0Lg==
X-Received: by 2002:a54:488f:: with SMTP id r15mr1215200oic.132.1618522448415;
        Thu, 15 Apr 2021 14:34:08 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 88sm768525otx.2.2021.04.15.14.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 14:34:07 -0700 (PDT)
Received: (nullmailer pid 1919784 invoked by uid 1000);
        Thu, 15 Apr 2021 21:34:06 -0000
Date:   Thu, 15 Apr 2021 16:34:06 -0500
From:   Rob Herring <robh@kernel.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH v2 0/2] brcmfmac: support parse country code map from DT
Message-ID: <20210415213406.GA1912098@robh.at.kernel.org>
References: <20210415104728.8471-1-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415104728.8471-1-shawn.guo@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 06:47:26PM +0800, Shawn Guo wrote:
> This is a couple of patches adding optional brcm,ccode-map bindings for
> brcmfmac driver to parse country code map from DT.
> 
> Changes for v2:
>  - Rebase bindings patch on top of yaml conversion patch [1].
>  - Improve commit log with Arend's explanation on why this data could
>    be put in device tree.
>  - Use pattern to define mapping string as suggested by Rob.
>  - Use brcmf_err() instead of dev_warn() and print error code.
>  - Use sscanf() to validate mapping string.
>  - Use brcmf_dbg(INFO, ...) to print country code entry.
>  - Separate BRCMF_BUSTYPE_SDIO bus_type check from general DT validation.
> 
> [1] https://patchwork.kernel.org/project/linux-wireless/patch/20210315105911.138553-1-linus.walleij@linaro.org/

As that's in my tree, I'm applying patch 1. Patch 2 should go via the 
wireless tree.

Rob
