Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C958A4CC97C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiCCWyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiCCWyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:54:35 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62375EC5EC
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:53:49 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x5so8501114edd.11
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 14:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Usbd3mnQSbfNAOrCITjjjVvCVB3dSHLgmyzkUP0TdvU=;
        b=qZPBXo4vZ1fGhhPnOHweYdctcMCf39BR1L7GHmay+FKC9Xm62S4IzAlxgfOIpq81dz
         un1sxhZurt4C8/9cfSaFOzuWEMZ32VevHuPdMeEkY0rxk/XevME8176+ELV4gZFnqQu8
         KKHAKar8lnUP/h2LRG+/pc6zP7bkOL5slwYc1XBHgtUTk8xZhTXSNbliOuf0qOVc0ALr
         tMSTLcbT559GuvQ4gv9sIU43rC3BbfjfKtwGhx+938cy6V1zgfHNFzGkdaHGOtdCAinS
         SEz9NPXrNnkLQ8Fb8/e++2tyHrjz9jIMIaSe2ktVwBdPwb/gvbC4ZB9LHao5z+b4yuzF
         rlhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Usbd3mnQSbfNAOrCITjjjVvCVB3dSHLgmyzkUP0TdvU=;
        b=7YnhqJM4lWRgs360QAhGGYadTdtLyNBPA7aNJuWx9LcRU+R8gEWhf8OzWHjfGLRDWN
         Mq/fFrjdlBSPv42PvBX0u8r7TZQmNPMF6c3m3slO8Uf1ianuf5qUVbJ/oVfuSjprEtYQ
         7DGVT//OAgmOeEeLt35jpQF3CAUocGzCp84eSEnQfS56a5hLswfrNXmnLnBqP65nCcyf
         FbbhquUkIgAhtS95XdqNutS6vVtw++2wvw4sUZzdAdSePYnu1t7WX/2CiaCf7207fwWP
         QNNo7wDlZ/kTsfeqaIbnlXVaLuzdiK6XmvqKwZjuHMI1+bFO2cE+tcv4TvScK6popmOZ
         OD6w==
X-Gm-Message-State: AOAM531e6KKslezrcdirVvp6a9Lrq4bAkHeMbNVZjQRcn8WbyQX5O7u4
        53J+5eFOH8sKX9z9hhAz/rw=
X-Google-Smtp-Source: ABdhPJy/jwOKWn0AqQt68T78PA574t4KhL1E8YrV7f+ZfIsWpp6NedcoOSER4Ia00urKeMDluG2lYQ==
X-Received: by 2002:a05:6402:f2a:b0:415:a3b3:2019 with SMTP id i42-20020a0564020f2a00b00415a3b32019mr11542175eda.177.1646348027903;
        Thu, 03 Mar 2022 14:53:47 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id m12-20020a1709060d8c00b006da972685bdsm834101eji.215.2022.03.03.14.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:53:47 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:53:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v5 2/3] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Message-ID: <20220303225345.wui2gkxqpvejirq6@skbuf>
References: <20220303015235.18907-1-luizluca@gmail.com>
 <20220303015235.18907-3-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220303015235.18907-3-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:52:34PM -0300, Luiz Angelo Daros de Luca wrote:
> Realtek switches supports the same tag both before ethertype or between
> payload and the CRC.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
