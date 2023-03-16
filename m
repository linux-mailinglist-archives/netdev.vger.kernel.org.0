Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022B16BCF48
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCPMUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjCPMUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:20:09 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E566B322
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:20:06 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ay8so1119782wmb.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678969205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KVg+HQThYLeKdF+SktSMsvte8PrLc9Lz2m3zKerLoNk=;
        b=ZhDFoWhwconSBXik8/oCRlArTiRy527X7RdRqxrwfyQ5fkRSreWP1etpng7OxaUueW
         SQrrinv9bCUZ+D5Ff5mwash2BmAtm7oAbgK3O8Bi3wPZRCm+Ut0xivl5eDiQcYa/ep57
         a2xNYuT63EgoPoBPAkYf0y+NiFkP/iWwTrhkEmSl4r4t8f5yjureSha3DO9N+EE5JKDl
         4MeCwSpOncYclsC10Kh0fUKE0IiJpKOwRXRNNIlo171Ulk48OikvIORtVoTqRI3lYvVB
         eNuBi2133KWkLMzVqhzdXpwAVlpUopg2WEhHc/ToyZ9fFEAaAv6uSHbudyWScqvFXI5S
         4MQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678969205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVg+HQThYLeKdF+SktSMsvte8PrLc9Lz2m3zKerLoNk=;
        b=a05JJ3Jg++YIZ9mm9h4L+4SeyEynXGiL+E5j7DILjsQyOqakVhma0DC+tX33X1WGW3
         Vbkx5rCCCcGwF31bfKHB/YsrHz4y3kkk0JiEKAb7tjp8mrvfgq2xFKucLGprEaXC062m
         /NBfIGhut1v7ZDKrU2t386VplKOB+0fdBewy2orz1Fmh2IFtd/MUYJpdSZykB07tNGHF
         qbdDl03WjPFxV/3rsqs22CIg4XoHyL7XhhHvKjMIpHkf8tOZ3gNuMyQmBFwoj5ksEwhm
         OHFx6RditbAtLalofvT0mR/8znfKfM5n3rNJAXUpgrA7gUQK6eA68Kiaeps81vvtE16S
         0ZNw==
X-Gm-Message-State: AO0yUKVYnaEVmRAVDmx3o8cT1tTrQUoqHoMOHXkqIuozjtVVTpLYAke/
        QluHZKZ/PwU84vYqYfssen1haw==
X-Google-Smtp-Source: AK7set+HaibucjTBWivbHwnXhA0iqdbe7hqauTwSwnA8PmD5OKUxEllEvl5Qz0afAowWtVk8fpYIdg==
X-Received: by 2002:a05:600c:4707:b0:3eb:29fe:f912 with SMTP id v7-20020a05600c470700b003eb29fef912mr20771676wmo.36.1678969204980;
        Thu, 16 Mar 2023 05:20:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z1-20020adff1c1000000b002cea8e3bd54sm7137333wro.53.2023.03.16.05.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:20:04 -0700 (PDT)
Date:   Thu, 16 Mar 2023 13:20:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBMJc9abj/DP4RiN@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]


>+/**
>+ * dpll_pin_unregister - deregister dpll pin from dpll device
>+ * @dpll: registered dpll pointer
>+ * @pin: pointer to a pin
>+ *
>+ * Note: It does not free the memory
>+ */
>+int dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin)

Make this return void. Function does not report anything useful,
non-0 is only in case of WARN_ON. Nobody is going to check that ever
anyway.


>+{
>+	if (WARN_ON(xa_empty(&dpll->pin_refs)))
>+		return -ENOENT;
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	mutex_lock(&dpll_pin_xa_lock);
>+	__dpll_pin_unregister(dpll, pin);
>+	mutex_unlock(&dpll_pin_xa_lock);
>+	mutex_unlock(&dpll_device_xa_lock);
>+
>+	return 0;
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_unregister);

[...]

