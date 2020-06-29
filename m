Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACFE20D742
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbgF2T2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732758AbgF2T1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:27:49 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA5BC030F3F;
        Mon, 29 Jun 2020 09:58:33 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q5so17238582wru.6;
        Mon, 29 Jun 2020 09:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EXieR2sKCVcuynFXj2Dp91Rx/LX+vZuPzCYIluYGYqw=;
        b=BdCW9dI6O2ID3uqf56vYmvG7S+fdM8QNerUMd1X2JionIRz+qIPUlM5rWCSvL/+UCt
         zvwMhhwE/TXKbCYG9ID7I9ygUQH+8T9k9KYMvWu+JHNlTbJIFYwJIgVJs5BgGjKU86gf
         kXrJckQyt3K2z59k0OFjRJxmE0ADLVeSmMYS17m3Rhvdan9zDd7VM8GaaUTAw9fApXHP
         PE+lFtfE8xP6ROi7X2UXlG6lttCibWZW/LgUXkH+Sm/g9OgnJAeD57hVdtUg2iLX/Egu
         W9ZG/B64qi8wc2xkGhqiFdCxoPVcr1rpqZi1VS2u4Kt5v/33rcpSfb2H78HjL/acb7KJ
         4j8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EXieR2sKCVcuynFXj2Dp91Rx/LX+vZuPzCYIluYGYqw=;
        b=Y6qXd1tzsxDusZrBWdyTDswgUD7jMetPOVu2H0z/PjeAq3NAneKzluS9TgbKKpq6Kv
         0JtYP+N7nB4EmImABwZHygjSuMblZU+ZXcaB+Q5gdgw/L+l9kaTadNObBnUj9G7FTsFH
         tABPbU6QlBBGtzurRaYaVrwyI9xIdofrUm1zm1jTt90cNWzs/RDkWrYlt59yJj4pbtAC
         2RN9rDS42ZhzsikxcDlMhZBHSdEwvAfLYtaKjMQMxRDsAfUaRmMWAVUf+NiYQ4BNvKTO
         jMIMFSbFS3jKVn7wyTGSCWkRpK1zCQaOfG3GSGWVCT5NxTwqOOiAgqjFOooTeI562oKF
         IZFA==
X-Gm-Message-State: AOAM531+4wOHS7mcs5MExaHM71hNodENrdTsa6jAEAaWfCGrNc0xqMKy
        B5hOJTqixoLYxuoIH+xbqLg=
X-Google-Smtp-Source: ABdhPJyJ5w3YtAo+uLmhSmj4foLwUKDf1M6Afay3gViElI8XhO8rG9IkHCGg5/fyGiENO61wD6cZDw==
X-Received: by 2002:a5d:6802:: with SMTP id w2mr17172707wru.88.1593449912197;
        Mon, 29 Jun 2020 09:58:32 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c20sm460651wrb.65.2020.06.29.09.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 09:58:31 -0700 (PDT)
Subject: Re: [PATCH v2 02/10] net: ethernet: ixgbe: don't call
 devm_mdiobus_free()
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200629120346.4382-1-brgl@bgdev.pl>
 <20200629120346.4382-3-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <daff86d4-f0f1-f4d8-2e7a-1535573f9ba1@gmail.com>
Date:   Mon, 29 Jun 2020 09:58:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629120346.4382-3-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2020 5:03 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The idea behind devres is that the release callbacks are called if
> probe fails. As we now check the return value of ixgbe_mii_bus_init(),
> we can drop the call devm_mdiobus_free() in error path as the release
> callback will be called automatically.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
