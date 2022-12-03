Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEAD6417F2
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 18:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiLCRA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 12:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLCRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 12:00:56 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44756186C8
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 09:00:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id a9so7302721pld.7
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 09:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZclzn0E0lKSdOdVr+Z+IcrnegKjW2jqAzJtyxCCFWo=;
        b=hJZM/yNTdVyCmjVLAvpOQwabROuDKpMAQe6SC0H0OaDIbGOqtWQslcZsiZQVjXKzIb
         YDBdWqK/E1QEAFwHme/fKLZDQts1X/ktw6VMQorr/c6M4JoLGbSc5YvoT5U/6sOR+O5b
         6Idc01xH+jS3lNChoNVzA8wC5GyyWgiGUG+HO2+cBxOHf8qt8fVYi4aguO2UQXf0R04s
         Akxmoz3iU2Y4wickuZPmbmq3TVPk+mtMv2yDp4KKt7zBw5BFiKWRKurAcZ9kiFu+HgKh
         0TpNBhQm2fX7pae0BadAUbCFYVi5f4iVAWJrJ439ql2B0G7hAbtXBzy8hU5uPe1KIgDi
         Fw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZclzn0E0lKSdOdVr+Z+IcrnegKjW2jqAzJtyxCCFWo=;
        b=y+VsCoFS9GuToZL5+6YVmPNOPzSb838Bi4DkC15OD2Zp+to/2iUMQ3MkaoxZOqBG8X
         iASXEUNJPBZN4JP49w2D0TwvY3YTemyY2ICJcaHQ0JY6X6c/v208n8PdgBMDcAwgRp6Y
         R12q7mlp8HAgLkbE4TtYs16W2oAzexX0UbLybYicj2ZwtBebOkLLTO7I2PS8lt3bnSRH
         nYE73Kno5Bk0XwFiumDwwBntlLKqiLXH/GgQXa6EL7jfdkXTPhfjYiIkvQH+SJt68iXk
         Shj6iKxP3Ipd/39Bb5TmRJGESIGDtbZR+mIbKrvUsL+vEuBxhQQot/QvnAYqtDB7EJyr
         Uqpw==
X-Gm-Message-State: ANoB5pluKFDOzDLAKicgL6WshBHv91f2HbrVA8ryZQd1oxkf7vqgfm8L
        axtDtTEHNsBMY1W2rt8lUjqmSQ==
X-Google-Smtp-Source: AA0mqf6hvnWOdNJ9n0SpVUD0bjq/7YG1iHogaZil/SaBwal+TYkPmu1ZtpH4pKJDEbvoadZe1AvhkA==
X-Received: by 2002:a17:903:1014:b0:189:adf6:771d with SMTP id a20-20020a170903101400b00189adf6771dmr16539864plb.102.1670086854764;
        Sat, 03 Dec 2022 09:00:54 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y17-20020a170903011100b0018099c9618esm7619301plc.231.2022.12.03.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 09:00:54 -0800 (PST)
Date:   Sat, 3 Dec 2022 09:00:52 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Message-ID: <20221203090052.65ff3bf1@hermes.local>
In-Reply-To: <20221202092235.224022-2-daniel.machon@microchip.com>
References: <20221202092235.224022-1-daniel.machon@microchip.com>
        <20221202092235.224022-2-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 10:22:34 +0100
Daniel Machon <daniel.machon@microchip.com> wrote:

> +static int dcb_app_print_key_pcp(__u16 protocol)
> +{
> +	/* Print in numerical form, if protocol value is out-of-range */
> +	if (protocol > DCB_APP_PCP_MAX) {
> +		fprintf(stderr, "Unknown PCP key: %d\n", protocol);
> +		return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> +	}
> +
> +	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
> +}

This is not an application friendly way to produce JSON output.
You need to put a key on each one, and value should not contain colon.
