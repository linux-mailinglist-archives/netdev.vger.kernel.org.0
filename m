Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1268E65D73F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbjADPaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239213AbjADPaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:30:20 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6AB1B9C9;
        Wed,  4 Jan 2023 07:30:19 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id fy8so19443836ejc.13;
        Wed, 04 Jan 2023 07:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RlY5zc887o4HmnQmxYxtgGa5YwnXO1c9ubHXsFfKj/w=;
        b=pbOa1icFKE3DphJvUEUO+QlWK5zCVsP0PI5DQcHnCWNZFfhX1W51ohvn228RBtGQzu
         CFWAf5bsoM4x61CUXF3bk1PK1zNi59wXfnNlxOoEbVSahX7bfi1XgI9EL3HN29snyqjQ
         cuitpahioxFArY6+AXzoHjUhicXXHkBUz3Kn9TfDwWkEAKXCI954h17Ie1imYZmE7pFX
         z0aP9Qh9rnHChXD2awC47/YH9tf/e1BkFxDRs9LEqzPcaiLb59ODEnJR9nhVVYXeeoNV
         a3ChPIrSrG3LXZ5gRtflQjRu12W2Ia7koQZSA74vSsVqpd82ariTScUNvxj+DQJc7fep
         Woog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RlY5zc887o4HmnQmxYxtgGa5YwnXO1c9ubHXsFfKj/w=;
        b=2QHFw4asUWE2AcleTv19MWlQWOTi4Zqvh5T9HDyKAzSuQa90JlASvmPLrb+6jJ2gnK
         Ruysfo5FqqgCBm8gt9hyqeqq6X3GoJp1BTFK3po2xiECZa/MkuSSb/4HgeJfujGurmoD
         GWdDPVN4FSLQ0RKjaeb4wclYkk+e70jMTNmEf23bjmeIRBrR5VHW+wKmPuS6DB4hoGWT
         4Mm3O692wT4ezKOkD38W3twZXLeFuN8GclTE3F+789Ucbkt/LWjUOwa+40WnfkHAfDva
         YIjRK1kjH8p91B6lGwopeT5duw86ByKpJr0prlC9PNxVXVBzFIN4pIYJXi/mwihuU7+W
         RkVQ==
X-Gm-Message-State: AFqh2kpkpdQjLDwb6GFTXZSlJp1SSGq2mS8V1x75hhbZZl1lLM5mKd52
        CEc8CWPfPwDCuCAxgWT7zLNt4wGLpmmQ32TBdKY=
X-Google-Smtp-Source: AMrXdXvJmnd3SsJYqbXkYBdYE92lok/9FJfVlIXR0snMPyAbpSQeVOltv/RKbd6e3C34bh6SgwpTS1YG31jJ8fMzjQ4=
X-Received: by 2002:a17:906:81cf:b0:7c1:6b9e:6f5d with SMTP id
 e15-20020a17090681cf00b007c16b9e6f5dmr4136083ejx.339.1672846218347; Wed, 04
 Jan 2023 07:30:18 -0800 (PST)
MIME-Version: 1.0
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
 <92eb7dfa8b7d447e966a2751e174b642@realtek.com> <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
 <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
 <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com> <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
In-Reply-To: <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 4 Jan 2023 16:30:07 +0100
Message-ID: <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
To:     Ping-Ke Shih <pkshih@realtek.com>,
        "David.Laight@ACULAB.COM" <david.laight@aculab.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke, Hi David,

On Sun, Jan 1, 2023 at 2:09 PM Ping-Ke Shih <pkshih@realtek.com> wrote:
[...]
> Yes, it should not use bit filed. Instead, use a __le16 for all fields, such as
I think this can be done in a separate patch.
My v2 of this patch has reduced these changes to a minimum, see [0]

[...]
> struct rtw8821ce_efuse {
>    ...
>    u8 data1;       // offset 0x100
>    __le16 data2;   // offset 0x101-0x102
>    ...
> } __packed;
>
> Without __packed, compiler could has pad between data1 and data2,
> and then get wrong result.
My understanding is that this is the reason why we need __packed.

So my idea for the next steps is:
- I will send a v3 of my series but change the wording in the commit
description so it only mentions padding (but dropping the re-ordering
part)
- maybe Ping-Ke or his team can send a patch to fix the endian/bit
field problem in the PCIe eFuse structs
- (I'll keep working on SDIO support)

Does this make sense to both of you?


Best regards,
Martin


[0] https://lore.kernel.org/linux-wireless/20221229124845.1155429-2-martin.blumenstingl@googlemail.com/
