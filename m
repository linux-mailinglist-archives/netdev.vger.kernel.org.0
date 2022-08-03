Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE90588F47
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbiHCPV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236714AbiHCPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:21:55 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C906FD05
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:21:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y141so16744758pfb.7
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 08:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6kFVTMABIBVizXQc3wXzEInC/HU3ORY+wYhC85vpaF4=;
        b=LG077KjqrabiAVdKcTlGnpAfC2Kl7mLDqSXmCDcVylAvmX5+Edam2mw8Q+3551EOEv
         G3MTV1/olWeokHdMl8wty3n6/zjid7WQLSZLAF0YpYNT8+9lSJsInmQMymXugaFvziIC
         MAxS2NJekbmmjsc3AUqr4vxRKyLKpbiL6lkrWjlZG2nnQe4lrcjchIWOstlMZTCR/QEt
         zGx/rsAVW10wLSUfT8cUIZo/9LKW2jHVKDSFrug+Ffo/k3+VmMbN4fVzF2skhbg5hIit
         qP0N2FRALThxoTXvS64o6n5AMwN6NUaVP1Fw4bih64aYsQBWWhrzXFN59vE5fQp+FjSn
         kWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6kFVTMABIBVizXQc3wXzEInC/HU3ORY+wYhC85vpaF4=;
        b=KVs9ejO1Hm36EwNgzbGkafMCuev8zjRchxtPbDMpzHdAilMK0D1kezWYAZS7VVU9gx
         4V3D1lHx1PcUvZrFQM4KY3fJPfwL5QPZxWxSDrcwOjWN05zgoVSPoJx7uOHiFcRqMJZp
         UYPKqy3YPcXqHpDSw7+ZgCgQbPhZoPHW1DBkgvByK1249DrHrvqgujewlK9vw4VEnWOJ
         9IkGCqv/zPtAoi3fLQ6Vc/47TYuzy8KssJwV5ZFKL/EZfZ/vUKOV0q1dZS5cL7Ok6fWj
         05/OybrPhixj2CSwby84oQxKm3gQ8snk9T2dE+jYtPBtWiK+o9M0ovA7lXHMyug1n2dJ
         Q7Lw==
X-Gm-Message-State: ACgBeo2dZAXjLg27yR5/kUDEXBzU1L1GsO6VmsmpCY+pAhMfZOq9lkoL
        ivh4vbYtnOw3IAZxTIaKoDeErnk6tUXRURUZ
X-Google-Smtp-Source: AA6agR5AogMYxoa8fOgzRsSP2Yn/QI6dXGaHEKNEMfjOsPTGZHkCFec4ln/5MYXo9J4tcbsNVXWMcA==
X-Received: by 2002:a63:5616:0:b0:41b:fb43:d04c with SMTP id k22-20020a635616000000b0041bfb43d04cmr12689971pgb.508.1659540113832;
        Wed, 03 Aug 2022 08:21:53 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p14-20020a170902780e00b0016bfafffa0esm2095888pll.227.2022.08.03.08.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 08:21:53 -0700 (PDT)
Date:   Wed, 3 Aug 2022 08:21:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] dpll: add netlink events
Message-ID: <20220803082151.14c32a57@hermes.local>
In-Reply-To: <20220626192444.29321-3-vfedorenko@novek.ru>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
        <20220626192444.29321-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jun 2022 22:24:43 +0300
Vadim Fedorenko <vfedorenko@novek.ru> wrote:

> +
> +static cb_t event_cb[] = {
> +	[DPLL_EVENT_DEVICE_CREATE]	= dpll_event_device_create,
> +	[DPLL_EVENT_DEVICE_DELETE]	= dpll_event_device_delete,
> +	[DPLL_EVENT_STATUS_LOCKED]	= dpll_event_status,
> +	[DPLL_EVENT_STATUS_UNLOCKED]	= dpll_event_status,
> +	[DPLL_EVENT_SOURCE_CHANGE]	= dpll_event_source_change,
> +	[DPLL_EVENT_OUTPUT_CHANGE]	= dpll_event_output_change,
> +};

Function tables in kernel should always be const for added security
