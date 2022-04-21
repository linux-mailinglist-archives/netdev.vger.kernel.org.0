Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE95509534
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 04:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383853AbiDUDBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 23:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiDUDBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 23:01:49 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F792E0A6
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 19:59:01 -0700 (PDT)
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9AC473F1DD
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 02:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650509936;
        bh=IiYhDkBxg42hecLjhxZWOT2Ofh69UeO2F0VLO5lZVVw=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=ob9uldVtuCjJUoxqH6BOVDqFF/5aGkBKTqkiyCElGHZxY1xmbhPr4zEfKamvot82+
         ufjir/oMMdfg5oQR/NUzZr4DY99yoErd/i3o4/ZejuN9Vxdh/0eASzQMdPeWyrdn8C
         5zUJbD0ofw+tQ3DpAscDGSvuU71mkYz9Z3u2ymIsa5CIwYvzwvfe7k/3PCgp0sj5x4
         QekCXJqVaSLmVtCMZpUW1IHDvhKR3L0IncN7VvKi2QsJyZakl/bmRqeQrFkYlvsVSr
         1iWF3r9LOEjakigRYgRVglglgchD3a5N+neNc7rjtBB9l+6xojKf4d/ntl8F17MmCF
         bveXOGAj/UN0w==
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-e23ecc2de8so1609170fac.4
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 19:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IiYhDkBxg42hecLjhxZWOT2Ofh69UeO2F0VLO5lZVVw=;
        b=Vo0CE7YvnIU9QRACc/t0LsYzdcHHL1e6Vyod4WRLo/bth9daagHjLJbEm8F6mOktXA
         zIjK2ZgKmNgOXkF+sP6OibjRggqggpTcPlyie13GRvi4JHYbc2xs9hLFpBmIhyVC7Bdz
         ngIELL7UUrHUe5D1I/mLmsMH1a2kuQZ7UuwgYII2KbX++S+m00byNNY7jrZQ4y7ykx2L
         6nAxDxKCzxmAsWQ/vWFmfdiT7txXDILc4ew9OOBrhNIsC1K++k88NqjIw3lTh5a5vQl4
         hQOvR3m1Jy0G4XAHXBM2Ns206ra5xk/w/PlM0SXIrF274B5FailfYj1G4S/VSAhSfXVt
         boeg==
X-Gm-Message-State: AOAM532aM5CnsrOqpHORE5sfXx4buiS4YEtx+GObsJRFpUpQu2kZueu0
        qVd7rFMID6U+VCmIxwk3kHUBXAQH32B1ZwCrwE9oHCbVTAfbiCduFADKN6Hr1Ads11YWguTBfkm
        BySB9aZi2KiM1m/57nwlcaQy3bSstchce1Fn3M2X7JO7AnuEi2Q==
X-Received: by 2002:a05:6870:a98e:b0:dd:c79d:18a2 with SMTP id ep14-20020a056870a98e00b000ddc79d18a2mr2817474oab.198.1650509933099;
        Wed, 20 Apr 2022 19:58:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYILGLtCmKpsBFaOaeTACV/xwcPOnnYnY6uaubtc1tiAiFVCYxzwNiCHEhu1L9CkqiGY6AR5yAvGf42Z1giAg=
X-Received: by 2002:a05:6870:a98e:b0:dd:c79d:18a2 with SMTP id
 ep14-20020a056870a98e00b000ddc79d18a2mr2817466oab.198.1650509932780; Wed, 20
 Apr 2022 19:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-2-kai.heng.feng@canonical.com> <YmAc+dzroa4D1ny2@lunn.ch>
In-Reply-To: <YmAc+dzroa4D1ny2@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 21 Apr 2022 10:58:40 +0800
Message-ID: <CAAd53p5Wwn+HOMm1Z0VWcR_WrTzRvAGZOYg4X_txugSFd+EsDQ@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 10:47 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Apr 20, 2022 at 08:40:48PM +0800, Kai-Heng Feng wrote:
> > Not all PHY has an ACPI node, for those nodes auto probing is still
> > needed.
>
> Why do you need this?
>
> Documentation/firmware-guide/acpi/dsd/phy.rst
>
> There is nothing here about there being PHYs which are not listed in
> ACPI. If you have decided to go the ACPI route, you need to list the
> PHYs.

This is for backward-compatibility. MAC can have ACPI node but PHY may
not have one.

On ACPI based platform, stmmac is using mdiobus_register() and its PHY
is using autoprobing, so masking all PHYs from autoprobing will break
those stmmac users.

Kai-Heng

>
>         Andrew
