Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260F4509F7D
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383661AbiDUMVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383632AbiDUMVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:21:46 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A4F2D1DC
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 05:18:57 -0700 (PDT)
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 02DED3F32C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650543535;
        bh=4bYptzY3YzLmhGBN6lm6r5JMn01LLupyoyy4UGqZLCs=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=bcJeebugbFQ7Rfggv/ktkacFmuX83d96vz2tXfeudbTsVInFFuu6OJXjkh9sDsJmm
         /lnZUN3zoVl5z/L037gVGQg1j3lwuSRrNgSuZPj2Sc9e56YzMDFF1nqlDljGvHq6s3
         jkRazmDZw6Gi5diwbSbUd1BbsZm58jck2lfdqBg20aHsyq3l0ldOgvHa36Kw0AkRWZ
         7o3ZxoNjZ6ZJ2WII0S1ziMwICW9pdbCBOULKzNYyfZ1NhtGIf3OmrfB8Jk9PWjDNPK
         G2jBOzP2c1ehKpSJuy/u3bP7BCzDrLnIjxSk5XSdfmEvxpL9R25wJ9jrch7mKUwwes
         BoO/Of/Khjnfg==
Received: by mail-oo1-f69.google.com with SMTP id j15-20020a4a888f000000b00321764d8f14so2401913ooa.14
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 05:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4bYptzY3YzLmhGBN6lm6r5JMn01LLupyoyy4UGqZLCs=;
        b=owut1SSbY1uhxJLhQpafIIq6ayIWx1lg1M4Xpds3hojJ0D6XBByo2SFE6L9pcqwqPq
         PyX8SfUfvSfBhrD3qv6gEsji9YQ5wgWd4ODU+mjqVxfyhWjf3FDMWp+zp0Z8ZOwxmNSV
         3jd8s3VnU3PKnkKLo5ttO2AvkCiIO+PGmAJvLk3+FxnUxwft16nRcA4SkwRFR4TbhH8X
         kAJgPOS+l600eepKNsqRF98LFH3FI0yjjyNJkfucYju6e6Gjp0Ox1Fz6gwexlx5HbxMW
         dl0Zhpizq7m9IkNwfaUTBGE/7f+2czKjM/9MxjekwetCvZoDovlWla/Ro/c31mRPZzg8
         MTtQ==
X-Gm-Message-State: AOAM532pDZzpeErsFuQgVi3kW0pU0XLCwtTsNeZ+wVpC+D5bhxcDYVXC
        ABPP1ZP8KpHuQS9GFqDJqLUgEiCmEHlAosLGLgBSBS55MGiTqhcNvp0DaHUvP6e/QPqcHx0ePgY
        yDKLUJgEp2du2VcIEFgkdHBoACtWGoHvbkP1B7xEM9JYFFad1tg==
X-Received: by 2002:a05:6870:a98e:b0:dd:c79d:18a2 with SMTP id ep14-20020a056870a98e00b000ddc79d18a2mr3460017oab.198.1650543532716;
        Thu, 21 Apr 2022 05:18:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5OQzv+iidRy4CedEneehsPXtQOwhdGPI+31vMY5vFpqfcuR9Z9penNJAsByljzHp3wKGE/pNbIqbAbO2ZhmM=
X-Received: by 2002:a05:6870:a98e:b0:dd:c79d:18a2 with SMTP id
 ep14-20020a056870a98e00b000ddc79d18a2mr3460004oab.198.1650543532392; Thu, 21
 Apr 2022 05:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-2-kai.heng.feng@canonical.com> <YmAc+dzroa4D1ny2@lunn.ch>
 <CAAd53p5Wwn+HOMm1Z0VWcR_WrTzRvAGZOYg4X_txugSFd+EsDQ@mail.gmail.com> <YmFCxnYdRnnk41QQ@lunn.ch>
In-Reply-To: <YmFCxnYdRnnk41QQ@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 21 Apr 2022 20:18:40 +0800
Message-ID: <CAAd53p5KjYD9O_HHNdQYYUY9POzUtCe8Zaj1NeweAmy8S9zK1Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] net: mdio: Mask PHY only when its ACPI node is present
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 7:40 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Apr 21, 2022 at 10:58:40AM +0800, Kai-Heng Feng wrote:
> > On Wed, Apr 20, 2022 at 10:47 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Wed, Apr 20, 2022 at 08:40:48PM +0800, Kai-Heng Feng wrote:
> > > > Not all PHY has an ACPI node, for those nodes auto probing is still
> > > > needed.
> > >
> > > Why do you need this?
> > >
> > > Documentation/firmware-guide/acpi/dsd/phy.rst
> > >
> > > There is nothing here about there being PHYs which are not listed in
> > > ACPI. If you have decided to go the ACPI route, you need to list the
> > > PHYs.
> >
> > This is for backward-compatibility. MAC can have ACPI node but PHY may
> > not have one.
>
> And if the PHY does not have an ACPI node, fall back to
> mdiobus_register(). This is what of_mdiobus_register() does. If
> np=NULL, it calls mdiobus_register() and skips all the OF stuff.

The equivalent to this scenario is that when MAC doesn't have ACPI node.
But yes it can unmask the PHYs if no ACPI node is found, then call
mdiobus_register().

Kai-Heng

>
>          Andrew
