Return-Path: <netdev+bounces-12203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E1C736AFE
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3A8B1C20BE0
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9AD812B8B;
	Tue, 20 Jun 2023 11:30:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C830F1079C
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:30:46 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFD31BCB
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:30:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-31114b46d62so4688756f8f.3
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687260633; x=1689852633;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iaGV9Vkt6uMiy3A9mhsCYzY6wrjcrFbO2kNwwXBfvHM=;
        b=B9qIs9U3zIzQCcLUY7xY0W19BIKOTAgMfyMFiu94fA+YEiJAYSfJDlM2nOgInSDHnE
         RpOy/M6YPht6A1fiD9xTfOsQR8a0VtKhwbBuo+rlfWPTVBzkCjxfhb4LzbPRLTW+pM2+
         2szwK1dDsiuCpYwe4VhzEkjTYWgwNMJ3H1zvuarax6q/sxUxw0/2+7vQKE816Z9Wdo78
         5u34N/YJ+KGzbeOlXM51gfpYvFkAUpseLCdk9WjRwoWMViSRvBNQL41uooYaPRz6IApT
         o5oxTXoYZEpcuaNhyUlOwbGPguVUdXCgMKiDdBTiGxcFscw2PXAt55O+C6O5w9HWm7j8
         MaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687260633; x=1689852633;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iaGV9Vkt6uMiy3A9mhsCYzY6wrjcrFbO2kNwwXBfvHM=;
        b=RaM+Zy3caL6V8BbDmbvwKaq26Jb/5X8vUnCuyvBTmDz6XUtUBVTJEZTN2Vm8jGfuM4
         O7eemdOYOlq0cE6N/WzQtYKZ9TTuZ1m5htk+CFgZ0jSbd2JpKb8wmnC1zI9CpWPJmr8I
         MEkM+Mj6RXliTEZi6ZV2QpLfrPmPDCbSEnBivu3fj1gx+WaKlA6TM74hnxWJyHQNNjto
         AMn3DCET8aa2OTphvOYZWZNRrgvDbDx5EiJ5SyCPQtPXw7suEeSlPSTqnyrDWbrm1qqk
         mjBw+dRGRUjOy0rAsmZ6yNIHLOqtztGfOYRuj8UTt4KMxpDkvcjuOiFLf6sy/l6x7Z1o
         OTag==
X-Gm-Message-State: AC+VfDyyZFktYCVmqjHhzWcMRZQYgGeIT57AtLmelngtRxtlwwf0R7ES
	XZE7sTp+WlMUlqaeCChA+6Q=
X-Google-Smtp-Source: ACHHUZ5aC7k1pc18aulstcJcUDJRL0/aG6HAgfZ/J3RLQdvNtV7IBTi2ZsaD+tK7nS7dRdBgA6R/ZA==
X-Received: by 2002:a5d:6810:0:b0:30f:d1e3:22b7 with SMTP id w16-20020a5d6810000000b0030fd1e322b7mr12478895wru.6.1687260632553;
        Tue, 20 Jun 2023 04:30:32 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id w8-20020adfcd08000000b00301a351a8d6sm1808203wrm.84.2023.06.20.04.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 04:30:31 -0700 (PDT)
Message-ID: <0d92dae9-fc21-3f0d-447a-0743b5220234@gmail.com>
Date: Tue, 20 Jun 2023 12:30:30 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next 13/15] net: dsa: b53: update PCS driver to use
 neg_mode
Content-Language: en-US
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: Alexander Couzens <lynxis@fe80.eu>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Claudiu Beznea <claudiu.beznea@microchip.com>,
 Daniel Golle <daniel@makrotopia.org>,
 Daniel Machon <daniel.machon@microchip.com>,
 "David S. Miller" <davem@davemloft.net>, DENG Qingfang <dqfext@gmail.com>,
 Eric Dumazet <edumazet@google.com>,
 Horatiu Vultur <horatiu.vultur@microchip.com>,
 Ioana Ciornei <ioana.ciornei@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
 Jose Abreu <Jose.Abreu@synopsys.com>, Landen Chao
 <Landen.Chao@mediatek.com>, Lars Povlsen <lars.povlsen@microchip.com>,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 Madalin Bucur <madalin.bucur@nxp.com>, Marcin Wojtas <mw@semihalf.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
 Nicolas Ferre <nicolas.ferre@microchip.com>, Paolo Abeni
 <pabeni@redhat.com>, Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
 Sean Anderson <sean.anderson@seco.com>, Sean Wang <sean.wang@mediatek.com>,
 Steen Hegelund <Steen.Hegelund@microchip.com>,
 Taras Chornyi <taras.chornyi@plvision.eu>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <E1qA8Ee-00EaGL-Az@rmk-PC.armlinux.org.uk>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1qA8Ee-00EaGL-Az@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/16/2023 1:07 PM, Russell King (Oracle) wrote:
> Update B53's embedded PCS driver to use neg_mode, even though it makes
> no use of it or the "mode" argument. This makes the driver consistent
> with converted drivers.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

