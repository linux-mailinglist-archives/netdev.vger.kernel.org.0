Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBB6343772
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 04:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCVDas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 23:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhCVDaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 23:30:14 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110F7C061574;
        Sun, 21 Mar 2021 20:30:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v3so7733296pgq.2;
        Sun, 21 Mar 2021 20:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YC55n+nEQVXWx2jWMnvmQnF5PDmoYdD2StH0ZPzYESE=;
        b=ngiALxpO6zUsiAPQy3oR0GiT54vhutwDNc247RMHNWbOQ9XCnQus1mjUtZEmNNXySr
         ozhI3Ewg3hMMNgMVa/YDHph27Ak2wI+mlrcA3mn+um/ZgaIhV4+0JL6VPR1/f1yYMk+s
         e0TT+SFLJVRO7QAbL6aVG6wnRMliBDG8NuO5b+ml7yQxKZHAEmH+XhuijBCDq4xCXyCd
         aGXqPE+J8mEb24oL6abR6AucfHLiEzJcZdWTmheudDGooDLYS3G1sHLSK7mqeGBe0rgR
         Y+ecaVd9cA0P7KBCiRQxGBihawCsaqwtGtHadp13ZhpRQnpRehKUA10QByATfC5tVZK6
         MGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YC55n+nEQVXWx2jWMnvmQnF5PDmoYdD2StH0ZPzYESE=;
        b=EyWygjZGR5V3xoYsBY9Mx1BPD1bUeXLmNA3/yMnWgYg/kfjWsVSSgVtYeCNtQqHvzD
         Tfu2bM1H7NEE/vdVjS7WwhXjjvv8LTL3fJtazj7FhtOZ3UPoeoFUeevIA0pWLUTcLlxm
         ihJCODXzEXdLhg2BcF5MJgKCuxRQR4eTGpDyp9PsTx377a1DI9r4hmSp9k0Yfq+7g87t
         pk1ptcpxIIgGlELCuSP09vXiM/5AxlLW4btCnee5Ch6kYG2zChZk+P4CNM1wc2MZi8hY
         7vX5XmZgYkTTOzu4gZpf9ckKOEtggvZ6pqTBUailEl1TtwoTV5egLyi8HGJbZESLkxYM
         /aWQ==
X-Gm-Message-State: AOAM530+DwSwvP+THtTFBIlnCg3yzmwMee9uEhtydhMiEPX4yW8MZG/V
        5eY1aBmg7VqRTKOSgTojkE1F7Y8RZJM=
X-Google-Smtp-Source: ABdhPJxikkODGWqC6H/nFrMgDo437J9DOX54/CKLLhSXZw7jbQdoT3eH3eX2K2YaF2D5gp4zwImtxw==
X-Received: by 2002:aa7:9e5b:0:b029:1f1:5ba4:57a2 with SMTP id z27-20020aa79e5b0000b02901f15ba457a2mr19647252pfq.59.1616383811020;
        Sun, 21 Mar 2021 20:30:11 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b24sm10824272pgj.58.2021.03.21.20.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 20:30:10 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
To:     Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
 <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <17876c6e-4688-59e6-216f-445f91a8b884@gmail.com>
Date:   Sun, 21 Mar 2021 20:30:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On 3/21/2021 4:29 PM, Cristian Ciocaltea wrote:
> Add new driver for the Ethernet MAC used on the Actions Semi Owl
> family of SoCs.
> 
> Currently this has been tested only on the Actions Semi S500 SoC
> variant.
> 
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

[snip]

Do you know the story behind this Ethernet controller? The various
receive/transmit descriptor definitions are 99% those defined in
drivers/net/ethernet/stmmicro/stmmac/descs.h for the normal descriptor.

The register layout of the MAC looks completely different from a
dwmac100 or dwmac1000 however.
-- 
Florian
