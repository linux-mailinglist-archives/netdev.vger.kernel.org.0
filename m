Return-Path: <netdev+bounces-4050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 787A370A4BA
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32FA0281B0E
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB83636;
	Sat, 20 May 2023 02:56:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A6B632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 02:56:10 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D45E56;
	Fri, 19 May 2023 19:56:03 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d247a023aso1745686b3a.2;
        Fri, 19 May 2023 19:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684551363; x=1687143363;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E5K0XSnuggQzl66TnVryLtl5FsI/fKwZrTaWimyrTi8=;
        b=NMQpSUjljrUyn1TajFIvBynaXV14wTHQcuIWpGc/Yj3avfgveJ2QoRyo7XL7ejS7SJ
         swBuZ7llp0wQaAz7GVnLw5P5lAlungF37W88ZBnJBuH/jR2BwzDi4q1+lomdHMkXsj+G
         J59g8/Z93N9QA/5w3lqbEujpxHo/uBtji5/YRS6lAiqQdojz9k3wLPhk8gChzYS2xULx
         dLHd+886VudkaZASVWhjnJLtYp2W5uEFDDkG+b9BGsFdsRSNxGQWraLWP9npblo14d7x
         /TGvUimjqp0vVZaERYkifelF4tRxYiyAFfoC788+hb4GFIZd8n0OHK1OSTo3Byc8BLpZ
         7MBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684551363; x=1687143363;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5K0XSnuggQzl66TnVryLtl5FsI/fKwZrTaWimyrTi8=;
        b=j59M8GSsGYJfKUeKxcP57WqEtbKDUinmpjXc6ToW+oy93s5t01VJZuqiSZG7uVMl5D
         d4BbXWF5KLBX5TOLub8v58CzxuV6+i50Wgz5oFHH7eFWgLZBni6cCCPX4nAg+2hPj05g
         AN8zw1nR221+qmLpc2vfE3CO0KKFon2QvHtBX3x09EEcnDOrEVJyV6Ypj7YGYAUZFmU+
         FAaSImkgJxYUQprAU3waJxA4W8YwvG0PuD0XfWCv8i6k/PrEF3dzENKlEeR7ssAf0SUd
         0eY6y1nMx2pA1Rm81IVtepBsyhj/gYWoSKGk3wYadN/N2VxaLtgHI+5jadHWzRPP3mkM
         0jBA==
X-Gm-Message-State: AC+VfDxs6mTSbow0+xjXz8c2+NYZxDTpRPt8ICQyxq64z9NTWLXYlIwB
	J5cxgWW67+nP6G1PamLZT3k=
X-Google-Smtp-Source: ACHHUZ6ROO2aN94rbTNNpDC49zVPRAG9XW2Xt2qXPh+bfrjxhsWhHVcP6bD7nYYtMWMY+YzfxZKu9w==
X-Received: by 2002:a17:902:c944:b0:1ab:675:3e0c with SMTP id i4-20020a170902c94400b001ab06753e0cmr5981268pla.33.1684551363000;
        Fri, 19 May 2023 19:56:03 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b19-20020a170902b61300b001a9884c02e3sm347013pls.10.2023.05.19.19.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 19:56:02 -0700 (PDT)
Message-ID: <291695ff-cb34-99f6-2e29-4b7390532b6a@gmail.com>
Date: Fri, 19 May 2023 19:56:00 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v2 6/7] net: dsa: mv88e6xxx: pass mv88e6xxx_chip
 structure to port_max_speed_mode
Content-Language: en-US
To: alexis.lothore@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Richard Cochran <richardcochran@gmail.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
 paul.arola@telus.com, scott.roberts@telus.com, =?UTF-8?Q?Marek_Beh=c3=ban?=
 <kabel@kernel.org>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-7-alexis.lothore@bootlin.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230519141303.245235-7-alexis.lothore@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/19/2023 7:13 AM, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> Some switches families have minor differences on supported link speed for
> ports. Instead of redefining a new port_max_speed_mode for each different
> configuration, allow to pass mv88e6xxx_chip structure to allow
> differentiating those chips by known chip id
> 
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

