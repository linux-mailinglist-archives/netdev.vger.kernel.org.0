Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6822E2EF293
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 13:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbhAHMdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 07:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbhAHMdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 07:33:42 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D683DC0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 04:33:01 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id v14so7682529wml.1
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 04:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0DfxTDBws5F5Kj7gtapc66RegEcvin0l3tdCyyCUswo=;
        b=mepmLmlzTfpooLgI8E5yigUdyXHcySb1ftfOemd1T1x5olulk6XFiPELGk7jAAsalW
         pQjKlPywTSxkuhuUY+adiLHW/+hTYiEy3I1YWnhnHThwOnrBrzdWUcmrUNF0jv/7Zun4
         d5Dq+ZQuLDhdhUWPes9uDzdgKlqT2JNXeTCht5vYoBqDihaSQTnx+BzWg0MlSZd78r8u
         GKxJkiIkdVYy5fqUCgY1Dr3Xgi2t37LGUxPQZuJTkhvQuGuXwGwt9TnWo9IGuqTab5hS
         z80v5KUFylUpWV9YhAaYM93+I0tsqLmy9CYr82dkOsgr6VjBmEcQ5pZVatWTz8GoXD+/
         1brw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0DfxTDBws5F5Kj7gtapc66RegEcvin0l3tdCyyCUswo=;
        b=B4AMCyFwrWc8EyNVNG8Jb32VZhQuL2jovRHc4SURqiCsnuOC2+g3C4W0AyacAanjHg
         PsMHbZm/BdDZFHPMx9gl3sqTSK/Dky8hucLKxBZbCzWvzdjxKLjKw2MzJklWr1hCCBeX
         pSnocHia97s/005e3EVRgf3WOKgLwQSA2igJvbuCLMfQ7oToE/FykZiDXGClk+B1M1Bj
         iQve1N3Y2WW8DI1J95cwwhHAr6Bv7Cawify/gNjCPNG2hf02D0+h6+yru0bGd2LvBE3A
         2LpviAPknlo8vKyQqWOk0p0WeTtxeUDGspj3XakOg+aNRWwaNUZcdSFb5ruBbs9wQ8EV
         tltA==
X-Gm-Message-State: AOAM531LrrjBrIG/2wj5y9PVjkaSLH/Oma2dySGHD/xtbWbMuc+T80BQ
        P0lcvg2U5NYX75NY4QGRq1A=
X-Google-Smtp-Source: ABdhPJwLewbvVgznGpZD4OCNp/rwxCTHVyMqdg7pLVZ89GVC8bAa5hnRX0hZ4Op7j4fk4rpzmLFUNQ==
X-Received: by 2002:a1c:bc88:: with SMTP id m130mr2946698wmf.82.1610109180634;
        Fri, 08 Jan 2021 04:33:00 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id s63sm13546879wms.18.2021.01.08.04.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 04:33:00 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net-gro: remove GRO_DROP
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20210108113903.3779510-1-eric.dumazet@gmail.com>
 <20210108113903.3779510-3-eric.dumazet@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <92939962-8b08-a1fb-4ea5-4eeea6a3709f@gmail.com>
Date:   Fri, 8 Jan 2021 12:32:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210108113903.3779510-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/01/2021 11:39, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> GRO_DROP can only be returned from napi_gro_frags()
> if the skb has not been allocated by a prior napi_get_frags()
> 
> Since drivers must use napi_get_frags() and test its result
> before populating the skb with metadata, we can safely remove
> GRO_DROP since it offers no practical use.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>

Fwiw,
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
