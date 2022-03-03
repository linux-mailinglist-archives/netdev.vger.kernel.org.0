Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AAC4CC982
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiCCWzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiCCWzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:55:49 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29E0EC5F4
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:55:01 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y2so3882038edc.2
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 14:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2U1GPPbJK21YKiwVDnUPjmErbxHGz18cbKLQcYZxGkQ=;
        b=Ik3FeQEhd4ld6xRtzQ/Gvx8zghnRZNEHXLW5DevR5hBC4o0Hin6WH707rexNL2jBQm
         /zUBf3pJVUUTFscpuBFznAlINobRx9kEs1UcwBgnpZC9NxfVLeZ9RpR7AzpDGJt3fw8f
         an9BHe9kZK4povuUwEJb5rnBbYUP44zZ41FDhwP5hGDrhQxDM/G/kc1/TBiIBXzNgLyr
         MrzrQB3LK0epMdqGMd3HPXCeUlOABUJ8Et/LpRsSDVsTa9WV3By13/41DeOfwtjltxf4
         3rGuxfaW8/mAiF+/y7dKSaWaqJ2IQVyilZxyJrBNecq3BXcAk0c0ZIY7ppgivWptZMqv
         9VkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2U1GPPbJK21YKiwVDnUPjmErbxHGz18cbKLQcYZxGkQ=;
        b=nDVnND6uWyQAR86MbkaHdWcBftS0N2fWCyb+hrZue2ljSGU/FJC1D2+y3ZW/Nwz08J
         GyYO+XlJWWeUcvgM1+fPMtrICXuDjV3E/JSDdk3CQRlydwvPtZohBQH4RhMLw66z20ZH
         6V6PPsevefFcuY6qcN2MhRMas9XKc5l/lYyrnjGEnS5Dt7ZlpD0I1ZAawrOC3f0sVxxY
         d1mmXloSdrQg6VeJ2unb1ThszXpF28/WHJsXpgQsABb/tM+CoVArAolKH4ge3hRaEUuQ
         Q8Slq3mf0E/E1BaGGTEVYleKs8HBkySKsxi8lmGqe/e+rK2W5eq6ETL6q3PyfkQe9LkO
         7Sqw==
X-Gm-Message-State: AOAM5301+VRL21t4zIX3xd45wwrHr3AD5EfZ4jTDb9h4ir82jUbKTe7I
        OibybX3bMbxXrZFZ92f+vIY=
X-Google-Smtp-Source: ABdhPJwooE32joCe46DEeKZukRSRX3X5+eQGiJY0a95Af6A+LQ2c7ny+jeCM9ESGIPbgDuT0bWFPGg==
X-Received: by 2002:a50:da89:0:b0:413:adb1:cf83 with SMTP id q9-20020a50da89000000b00413adb1cf83mr23478924edj.158.1646348100359;
        Thu, 03 Mar 2022 14:55:00 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id p23-20020a170906605700b006ccebe7f75dsm1134180ejj.123.2022.03.03.14.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:54:59 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:54:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v5 3/3] net: dsa: realtek: rtl8365mb: add
 support for rtl8_4t
Message-ID: <20220303225458.md2kdyh3ruhpye6i@skbuf>
References: <20220303015235.18907-1-luizluca@gmail.com>
 <20220303015235.18907-4-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220303015235.18907-4-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:52:35PM -0300, Luiz Angelo Daros de Luca wrote:
> The trailing tag is also supported by this family. The default is still
> rtl8_4 but now the switch supports changing the tag to rtl8_4t.
> 
> Reintroduce the dropped cpu in struct rtl8365mb (removed by 6147631).
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
