Return-Path: <netdev+bounces-6577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E67F716FDB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10F15281334
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625B131F03;
	Tue, 30 May 2023 21:39:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5806C200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:39:45 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E3A107;
	Tue, 30 May 2023 14:39:35 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d41d8bc63so3971816b3a.0;
        Tue, 30 May 2023 14:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685482775; x=1688074775;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hpYvhVTjZdMJvafiF5KeDRaJxYCBLlgjL89QGECGd2c=;
        b=VEtP8MlZUbBdCeag89T6zqxQ/9VbRcsFGtw5aENS/07d2LPfUlaKj+jvRTabjG8XZQ
         TfxkKPscjIaSfgzLJKs0RqOztakMfu0Mv3Flui6h6NS8Fyjsh0GdJif2fQdtpvm6LKzB
         rqx+MgT7A3uAfw4c9yStaoq74JbNbwuzIbwr4jyvwBmfYOj694o0KP5socGqmU33UTqY
         Xl48QqV/dxLiieWbYLlPw6FmoK2PltfVqKS370q70dqHEta5nTaGyEFconDj2A8ykhcK
         4kNgQw9dv/ePUNOsDM9xR3x6hveuqIi7Z22jYs4xVT3GMIkGuDAssRza2Pwlj/X65v0c
         sbfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685482775; x=1688074775;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hpYvhVTjZdMJvafiF5KeDRaJxYCBLlgjL89QGECGd2c=;
        b=gCS5fc44AGLMkfAzF2ql2AmXI5GUznLAA4f+DUpibkhaWDjSDxLSZ2dxf5OotVwpY/
         QXKhlsXvoDzpWYE6OlchUXC+JD0T/yvcgbFd/NJ/l7BOy1RI/bj/+rzkGZsZelMoCj14
         cNsIVW9VtEpw/0u8oos1euKhROkSmYsip6bUzloHDq4yttzDGJjNIgD6ekY+pmnwRDm1
         B+KCPE2jlLCqUQBnyKrFTLYPxtuCF/RFKM83ciFe/UxlGWd8bnxOfvjaSohIRzZy1B0G
         ZWWnRFkyS5daiklz4v+SPdhD1eWVAyuXcuEbjxvn7j33dHwBnOuRACXV04GdBRFxUCQz
         HyqA==
X-Gm-Message-State: AC+VfDz/fdsYkCDVIH3qigQvzV9MhwrPJkwo0tvXrtJhhY3Qz7kXebmp
	BvW3WALbnlKcKpYvLYXkwsYnNTKGoXAH5w==
X-Google-Smtp-Source: ACHHUZ7t9gh5pLLnj1uDj4zm7URp6+6nXn1PCHcmEpJFIBsMX5xvRzBSoif/mjJCWSzh0dIfg3TLvg==
X-Received: by 2002:a05:6a20:ae1a:b0:10b:92b8:9845 with SMTP id dp26-20020a056a20ae1a00b0010b92b89845mr2902340pzb.7.1685482774686;
        Tue, 30 May 2023 14:39:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z5-20020aa791c5000000b0064fabbc047dsm2100744pfa.55.2023.05.30.14.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 14:39:34 -0700 (PDT)
Message-ID: <c4008f3b-455f-5e8a-7381-6a73c192f675@gmail.com>
Date: Tue, 30 May 2023 14:39:20 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v8 3/3] net: dsa: mv88e6xxx: add support for MV88E6071
 switch
Content-Language: en-US
To: Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, Russell King <linux@armlinux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230530083916.2139667-1-lukma@denx.de>
 <20230530083916.2139667-4-lukma@denx.de>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230530083916.2139667-4-lukma@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 01:39, Lukasz Majewski wrote:
> A mv88e6250 family switch with 5 internal PHYs, 2 RMIIs
> and no PTP support.
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Same comment as in patch #2.
-- 
Florian


