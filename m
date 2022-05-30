Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18F7538617
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 18:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240442AbiE3QYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 12:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiE3QYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 12:24:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33C8972B5
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 09:24:48 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 137so10529209pgb.5
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 09:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dlsMpwkjFYlcA1tSH/psh8tHd6TweyM25CcpCdyyBSk=;
        b=OS9Sebvzy2HN8gBRsMojGuOKWa35xwZ41q43R4TiE2qZVXSDDCC0BEeJd8JgBRgyiJ
         SHx1c0MgsKI3nbmLoWCyRxbiCVKsjlmmevwzz7XUWGas7rr9jcyOWzCG2x2ix2lJZPml
         DIgDEJA/KiIzD5nPGeYVezHbOCoYui3utsQ99ynViUfTz9iVgYDf8/YaFHrn51qxHtdV
         ZdtyKxvWcVXMTuyiDEbLhDjKZY29H/1jsyxELnQJH4fiYnWc8Y9W06leY1d8G2MgbP/7
         bBle7gR0KYf0kOcqqU3v/hFUPIi4di1RTdmIqSRGZ8LYjJiu4cFonEA1efIf4pvbOSD4
         xlYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dlsMpwkjFYlcA1tSH/psh8tHd6TweyM25CcpCdyyBSk=;
        b=LI+Cw2JipqSFL1+43R48F2Ehw+xdlO0Jbb8S5cRZt5sBPuB3T204n1u7jCenRGSvpS
         a7ri6zLT5oCntSJ8aU6O6JcamX1k2skVvkINMF+41v5X0UZuz5HJGFBTnazfFuB+d4VZ
         a82QgMh2O0x+onyJ85Zn9+H7jF9qmFFagr+f8bEv49MxppQmOK0zvfVRHgfxD0LkIT11
         9RadqLsUJNFtkdoDVPfZSv7XnvhSqMyWinUOle4DPgEZcYk0r91s1+S0rgA3NtRabyRL
         yKM+tZwVJKbPw0naeQZ4dnforxBuPF/hPg3jRNq66XhMMuswtfTlhc7OLpzDFcWB95wL
         jI/Q==
X-Gm-Message-State: AOAM5309c9JqYYYpEB4zciRd7c0sbqBxQviqcxuyRgUDqPH2JZNW9PIq
        eZXmX+6CQRTnt2ik+02/FGCCEQ==
X-Google-Smtp-Source: ABdhPJwO6yW+s2IuwkAKT4EN6UgYw3WVcUJDwG5+Wdkcb2Ox7W8d88SugFq1k6vCdNf+x2qyhzbu/g==
X-Received: by 2002:a05:6a00:1582:b0:518:7aa0:d6d8 with SMTP id u2-20020a056a00158200b005187aa0d6d8mr47373758pfk.27.1653927888316;
        Mon, 30 May 2022 09:24:48 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090a668900b001e0899052f1sm7297455pjj.3.2022.05.30.09.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 09:24:47 -0700 (PDT)
Date:   Mon, 30 May 2022 09:24:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Message-ID: <20220530092445.5e2e79d6@hermes.local>
In-Reply-To: <20220530141438.2245089-1-maximmi@nvidia.com>
References: <20220530141438.2245089-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 17:14:38 +0300
Maxim Mikityanskiy <maximmi@nvidia.com> wrote:

> +static void tcp_tls_zc_sendfile(struct rtattr *attr)
> +{
> +	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
> +}

I would prefer a shorter output just adding "zc_sendfile" if present and nothing
if not present. That is how other optns like ecn, ecnseen, etc work.

At some point ss needs conversion to json but that will take days of work.
