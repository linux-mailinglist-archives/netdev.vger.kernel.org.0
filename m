Return-Path: <netdev+bounces-4047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEE670A4AF
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDD7C281925
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8434E636;
	Sat, 20 May 2023 02:54:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778F8632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 02:54:27 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FAFE40;
	Fri, 19 May 2023 19:54:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae763f9c0bso16246645ad.2;
        Fri, 19 May 2023 19:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684551266; x=1687143266;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c2rzwYYXKWFHgDPhp3B8AxT8fYGqy1x+hXNCAOOF+rU=;
        b=H9pGo0mNsukNcDeK5MYfW8+4HiE46Dv4No/4SNVu5SJALNWw7GDNJdXGosRPoz7B+G
         4RhbhIkaFmsJHFNyv2JvbdWHEFe+ityp2L88UC+YZRKtzqTpoCdxuTX2Haa9QZkTBEjF
         P4jENKrbDDYnQa5HlLrRv/WLRX5r43eCp7io5usCnBKFoGk3EUXWe85VgAjkoDt0shrd
         5vE5T28vZjK9BpaOYKETrv/GMpCKD0maw7QaNkN67tCAilw8pBjKS4EE4SRjECtqKttt
         Qs1cgft6fJhqNdddlZbx67KBV8AmyZLGgs8L29NRpDk+8U8SR+efcONBxyztq0UfIUmq
         LuiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684551266; x=1687143266;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c2rzwYYXKWFHgDPhp3B8AxT8fYGqy1x+hXNCAOOF+rU=;
        b=RturKCZ7kiYKVGAWwO6tLhwPn2oZ/E4bMACpa3CDirdmbg/Xz/48FcR8T/aL5bkMIF
         RgNIyuYx63p8Gvtnf0Tpo6kbIbZdQwIxCCO7xPVA0cO5z10hh8fRKu+t8rI18k+5Ybxy
         oFaN9F9c1JmmcsWAB0iQieaXK8kPhUZYN9VTBAqVNJe67Z8HZgP7fVeFEafS5c36294b
         OMT6kVYjSf2f7sOgdAtX7w6Y0cCJWU2sH7pt33xdmfS7J+hcFwHmk4m8Aacgas28AZs+
         TqAaaG/GH7BZdcD2BCZFU6H5fdReT8NyMCs8iITGPkBEn8q6eYSJhwgPyJ38WEYBIw/w
         AxgA==
X-Gm-Message-State: AC+VfDz8iDYIn7edhczwPFjXGvhtn1e0exQ/7FKMBP0vdwVjT9tt8vKp
	Wz0105FAo4zartGxnkigULk=
X-Google-Smtp-Source: ACHHUZ6GMu5GZjNTT7nAyN5Rw2bB7cadrRkdsWFY2Fv/KkH+YtwtHfoAQu6/Rwm8TVBClgQNVGFMig==
X-Received: by 2002:a17:903:18d:b0:1af:98e:5b98 with SMTP id z13-20020a170903018d00b001af098e5b98mr1708278plg.69.1684551265738;
        Fri, 19 May 2023 19:54:25 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g16-20020a1709029f9000b001ac2c3e54adsm327199plq.118.2023.05.19.19.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 19:54:25 -0700 (PDT)
Message-ID: <0a64ac13-0c8e-f066-2bbd-27b31880b6dc@gmail.com>
Date: Fri, 19 May 2023 19:54:23 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v2 1/7] dt-bindings: net: dsa: marvell: add
 MV88E6361 switch to compatibility list
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
 <kabel@kernel.org>, Conor Dooley <conor.dooley@microchip.com>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-2-alexis.lothore@bootlin.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230519141303.245235-2-alexis.lothore@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/19/2023 7:12 AM, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> Marvell MV88E6361 is an 8-port switch derived from the
> 88E6393X/88E9193X/88E6191X switches family. Since its functional behavior
> is very close to switches from this family, it can benefit from existing
> drivers for this family, so add it to the list of compatible switches
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

