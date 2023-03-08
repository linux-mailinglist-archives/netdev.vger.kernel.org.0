Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4E96B0FE1
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 18:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCHRLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 12:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCHRLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 12:11:14 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE452685E
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 09:11:13 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m6so22244046lfq.5
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 09:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678295471;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HL+r85YM37OzmoFffP9x9FwY7LucQfD326khWd3q1GI=;
        b=M/oQQxZ86mEe/uTGjvzyQ4Dx0JLQtd8NXHKuVRacTUpK+u4C6Cv2LsgAbzzfEOjcVT
         hwHmL3cGMDGRYv6+2x7lORmEyYgjys9qNoKboGIEHavMWQCfMmFHRgVA+0Ktb+5ZUX4Q
         Bvh3EipE8VQ/INhFHNFH3iJ1bGz8J0U0uRmK+dycyt4a55RNoOoONQKGv6Hf1eOjkjpO
         wE53nZhBEB2fvFfI8n1UoE37IIMwdF855/IvT00LnKrJjJvLu/VDqa2w+04lzAG3Otso
         pN9vjOcmZU6hhalLmr9kFoo1J8yJk95alp2gxMJ3/s5XS6V/ZgTsUEZgnyINsiLYmJh+
         iTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678295471;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HL+r85YM37OzmoFffP9x9FwY7LucQfD326khWd3q1GI=;
        b=tAROiOT0+Ol5tE1LiFft6P3/5/OodU9eFVfH8tvanZelL3faTPesEQKbBhlrYSspRO
         +aV0zATyc3XZ07t/mgRjcgY+hk2bPoNUV94UhIr8aBQVM3F58GE4e0rnyYRPjB3zdKf+
         j2REW2rp/4m8b1eTsCcEpXo7xKuvKfjmAJz5pUSUFPw64zz6qR5k71N81FwxMpf+k1y7
         89N7SL+o3XhVdxXBbxurnkXHEraLipush3uParwQ5FUN8dfrF2lAEhg/4KPw3AG7Htxh
         Jl6rcXVX3t1hAHI4lDXmnFUTLY27XeEVC6R11ScQkhVBONfn5TIL3cci3mqvkLBCSn1u
         VsQA==
X-Gm-Message-State: AO0yUKWM3h5J4oy7oMaOiz89KqIY0z6ZTnjEa7xeVIC/4As27ovWMGYu
        kwrezWe58gK2IGXGk2sWGmFqr8Azu6l9PfvgY5lYCvaoSg73qQ==
X-Google-Smtp-Source: AK7set8AukXdnFy5iwaQFEtfvHEs2TXX3sa24sPtk8rcf9iicEWpo59OcmIkRqmWjzrh6DEx/pmGzrWGqXriKMf9hqM=
X-Received: by 2002:ac2:44a3:0:b0:4d5:ca42:e438 with SMTP id
 c3-20020ac244a3000000b004d5ca42e438mr6006097lfm.1.1678295471168; Wed, 08 Mar
 2023 09:11:11 -0800 (PST)
MIME-Version: 1.0
References: <20230307210245.542-1-luizluca@gmail.com> <ZAh5ocHELAK9PSux@corigine.com>
In-Reply-To: <ZAh5ocHELAK9PSux@corigine.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 8 Mar 2023 14:10:59 -0300
Message-ID: <CAJq09z7U75Qe_oW3vbNmG=QaKFQW_zuFyNqjg0HAPPHh3t71Qg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: dsa: realtek: rtl8365mb: add change_mtu
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Alexander Duyck <alexanderduyck@fb.com>
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

> Hi Luiz,

Hi Simon,

>> +     ret = rtl8365mb_port_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);

This call just synchronizes the switch frame size with the default MTU (1500).

> Perhaps I am misreading this, perhaps it was discussed elsewhere (I did
> look), and perhaps it's not important. But prior to this
> patch a value of 1536 is used. Whereas with this patch the
> value, calculated in rtl8365mb_port_change_mtu, is
> ETH_DATA_LEN + VLAN_ETH_HLEN + ETH_FCS_LEN = 1500 + 18 + 4 = 1522.

That value, as mentioned in the commit message, probably came from
rtl8366rb driver jumbo frame settings.
The "rtl8366rb family" has 4 levels of jumbo frame size:

#define RTL8366RB_SGCR_MAX_LENGTH_1522          RTL8366RB_SGCR_MAX_LENGTH(0x0)
#define RTL8366RB_SGCR_MAX_LENGTH_1536          RTL8366RB_SGCR_MAX_LENGTH(0x1)
#define RTL8366RB_SGCR_MAX_LENGTH_1552          RTL8366RB_SGCR_MAX_LENGTH(0x2)
#define RTL8366RB_SGCR_MAX_LENGTH_16000         RTL8366RB_SGCR_MAX_LENGTH(0x3)

The first one might be the sum you did. I don't know what 1536 and
1552 are for. However, if those cases increase the MTU as well, the
code will handle it.
During my tests, changing those similar values or disabling jumbo
frames wasn't enough to change the switch behavior. As "rtl8365mb
family" can control frame size byte by byte, I believe it ignores the
old jumbo registers.

The 1522 size is already in use by other drivers. If there is
something that requires more room without increasing the MTU, like
QinQ, we would need to add that extra length to the
rtl8365mb_port_change_mtu formula and not the initial value. If not,
the switch will have different frame limits when the user leaves the
default 1500 MTU or when it changes and reverts the MTU size.

Regards,
