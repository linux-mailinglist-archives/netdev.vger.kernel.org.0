Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2C26BB7EC
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjCOPei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjCOPeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:34:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3783433D
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:34:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m35so3305095wms.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678894474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iSn5kfdhykvLhyEuzFDrK08azEwQSSmZ1qquAFvnjIQ=;
        b=BToH7Z3bKMbzK2RjYie+EhidShhg+xhjJZAE5+GlddA9dzbs0n1hStJfanyTI1tNUU
         8E1aha0lNNN3OjR7fF0Nc/0gKastWb83+rZhAadJO1UCkOyQ9F0oMhQbLabowqy2pg8u
         XEJoo3m4hk9F4wwPsYf2rgKizCMsCzYthDZW1cKkVyXuIFrXms8mWqKNhLHLcBrwoCB3
         dOGWuiSQLGKOQhqryeEpVAWL2t/cpc6J7AnbuxyStvtNbCbDyxHrrGLlJh40OdBNEO+Z
         fwQ4p2pCV2/u6guFFwurxcdXBRJGd+4gx3RM0/eHNNxjXt2KRUAtY6Yl/nN1yyVsK1F4
         MBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iSn5kfdhykvLhyEuzFDrK08azEwQSSmZ1qquAFvnjIQ=;
        b=cVSY4MunozCVzuaJJ5H3EaTc1UDMBptn70kjEMVwgqDYTAGvq0Fq0pilHXVW3rwl2I
         XG0H/tXoOxjwNdCzdItstRjFhl8u1x/UtsOwcw4deKn2RTggxwBVccdfRbOXZTylL2Ok
         9bA/WkZuhAPQks6fMY9DNtivj+Y/UOFbkwy8MgIkj+1yJfFHfNFwDGjO9qyJH/zEcBNE
         grp9aYk5VsESRJ53iDuza9ZdV4zQdgkeZQtoaF1qR/6MqG8EghSMDD18w1BrMKnj9Z5D
         ui2HvQ0EzJ+uUq3dS2kn48qfMocj1P/ZpgghAFALig4bNg2TR3OVQL4E1qFlcImCjlQ9
         1j8Q==
X-Gm-Message-State: AO0yUKW0EvEq85FWWQhM4S6wChBxOBa3EtV18eKWocX/4KUFOZT0OZJ5
        dE51G/B7meYr0nePh8ov+kx8dQ==
X-Google-Smtp-Source: AK7set8Yoa8+IOiarZ3IfL/VWla0xR5U0UapuEedg4o2wA11yz28lAI5nnin9ac7ZaYZUjGvpdwgrg==
X-Received: by 2002:a05:600c:3c9e:b0:3e1:f8af:8772 with SMTP id bg30-20020a05600c3c9e00b003e1f8af8772mr18006250wmb.9.1678894474641;
        Wed, 15 Mar 2023 08:34:34 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o23-20020a05600c511700b003ed29b332b8sm2643610wms.35.2023.03.15.08.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 08:34:33 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:34:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Message-ID: <ZBHliPPS+e5d5JQe@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-7-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-7-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:07AM CET, vadfed@meta.com wrote:

[...]

>@@ -4226,8 +4377,44 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 
> 	ptp_ocp_info(bp);
> 	devlink_register(devlink);
>-	return 0;
> 
>+	clkid = pci_get_dsn(pdev);
>+	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);
>+	if (!bp->dpll) {

You have to use IS_ERR() here. Same problem in ice.

[...]
