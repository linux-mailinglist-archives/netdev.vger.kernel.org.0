Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A79445E25
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhKEDCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 23:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhKEDCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 23:02:01 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054BDC061714;
        Thu,  4 Nov 2021 19:59:22 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso8441427otg.9;
        Thu, 04 Nov 2021 19:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XnI9g132VVmuM0dfdWaa2DPIJ0tMZeltl/rjMSrblFY=;
        b=JPKA+MVwu2XoHKfEKhyPsXKhRCpdGY65L4ypNAmzP+fWraigSMOeaUplsuSLJpYM3x
         l1hr/oGmWbMODwUGYG7ll0nqtR5h+S/u0iRWKYBduFnDSk9hMdQdyFT56aGGVMBpcCdO
         DhF5jRLMK0e0WwEXdbx8OF9ydhWqzCrSkqhSXIZFtHLAV5d+4XtM/7qrECPbAKjn6kkX
         r48vE8xmY/gbGK68cEmvHz8BnDKEfpPfGI2XILG/V1gzOy6RCqYs+CBa1RoC0+oM9Rw4
         2v148QRsMVSltkM5JS8OG/Kfs5ql68kx2s3MakNn577CZ1XJrCUddbSxNQNKv38QLMkD
         cfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XnI9g132VVmuM0dfdWaa2DPIJ0tMZeltl/rjMSrblFY=;
        b=kQUZyJ+2lm9Wd5X1W3McmRwDFP9+nIY8Strn53ZnSvX4dyQVjx3xLQAHXZEdHZ7xqU
         RYruYwd3lXklzE/q7XyjwDXkaYNoMF7iypNDo/IdH/uTIUwrc5vK02PwxyPYUV1F9yBH
         gniZdKoGfDpibuO2hVuQF1/nUDCJQ1FphoIxgBPWFpcYlAKK10mj9BVuXPcWIeF6MewQ
         Y9vxHnqyOBGIkAIzrGBgjOA5A8MlKbt66nq3scQnuTDBfKwxHu/UeuDSxoG0TSHo01s/
         5NODWeCfuqGH+tgbOENFdSBvi2fsSw5vfclFa8QoJCEgP9c1XShLL4LboJ8wPS30LFhi
         hD3Q==
X-Gm-Message-State: AOAM530VOx+7M79gRskT7c+b5Vi54KjD2fezD9K4uRZ10emoaIk0aNgL
        IeHxTXOW1B7tJWnbghpNJ/kByKBGrxE=
X-Google-Smtp-Source: ABdhPJwknlXw++6iy8k7nRavsdW0Uev9fTWlo2k2Svdvwm5pmMouWH41OIa/6ueOqAiNbZyJHSGkcA==
X-Received: by 2002:a9d:730b:: with SMTP id e11mr17295524otk.212.1636081162352;
        Thu, 04 Nov 2021 19:59:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t12sm2014179oth.21.2021.11.04.19.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 19:59:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 4 Nov 2021 19:59:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     kuba@kernel.org, andrew@lunn.ch, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, taras.chornyi@plvision.eu,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <20211105025920.GA2923425@roeck-us.net>
References: <1635485889-27504-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635485889-27504-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 08:38:07AM +0300, Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Add firmware (FW) version 4.0 support for Marvell Prestera
> driver.
> 
> Major changes have been made to new v4.0 FW ABI to add support
> of new features, introduce the stability of the FW ABI and ensure
> better forward compatibility for the future driver vesrions.
> 
> Current v4.0 FW feature set support does not expect any changes
> to ABI, as it was defined and tested through long period of time.
> The ABI may be extended in case of new features, but it will not
> break the backward compatibility.
> 
> ABI major changes done in v4.0:
> - L1 ABI, where MAC and PHY API configuration are split.
> - ACL has been split to low-level TCAM and Counters ABI
>   to provide more HW ACL capabilities for future driver
>   versions.
> 
> To support backward support, the addition compatibility layer is
> required in the driver which will have two different codebase under
> "if FW-VER elif FW-VER else" conditions that will be removed
> in the future anyway, So, the idea was to break backward support
> and focus on more stable FW instead of supporting old version
> with very minimal and limited set of features/capabilities.
> 
> Improve FW msg validation:
>  * Use __le64, __le32, __le16 types in msg to/from FW to
>    catch endian mismatch by sparse.
>  * Use BUILD_BUG_ON for structures sent/recv to/from FW.
> 
> Co-developed-by: Vadym Kochan <vkochan@marvell.com>
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

Compiling this file on m68k results in:

In file included from <command-line>:
In function 'prestera_hw_build_tests',
    inlined from 'prestera_hw_switch_init' at drivers/net/ethernet/marvell/prestera/prestera_hw.c:788:2:
include/linux/compiler_types.h:317:45: error: call to '__compiletime_assert_351' declared with attribute error: BUILD_BUG_ON failed: sizeof(struct prestera_msg_switch_attr_req) != 16

The size of struct prestera_msg_switch_attr_req is not well defined.

struct prestera_msg_switch_attr_req {
        struct prestera_msg_cmd cmd;			// 4 bytes
        __le32 attr;					// 4 bytes
        union prestera_msg_switch_param param;		// 6 bytes
};

The compiler may well decide, in this situation, to generate a structure of
size 14, not 16. The error is therefore not surprising.

Guenter
