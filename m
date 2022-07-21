Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0084F57CD23
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiGUOQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiGUOQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:16:34 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD632BD7;
        Thu, 21 Jul 2022 07:16:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f3-20020a17090ac28300b001f22d62bfbcso1551862pjt.0;
        Thu, 21 Jul 2022 07:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wf32qAwriumt3y35I2RkCV8Imv2K/N8sm1rGj9XR+F4=;
        b=MdOeBQKMPkDzHr55sn2/XYuc6zGtYNtjqr6NXnCiNQI+m5xad1S46to0VQysbkABgd
         hmdR13nawtQANHOQfwPBXDV4JAlzJhwRV879jBbcnmR0BPTM9YtzkZaNkYwhGUfW5Cn5
         6ViPZM+FnJdIY5G4hAm594bttRTOXvHG1rvC4ltAvBhBGG4bSM0ydK+vsphFhL+onygV
         GyOfcZgB8oTlBrtd2U8Do5RUoP2n4Mk+P/0KlWOPbY2cW9SUrWqwKTm3oFqUDsMJr+nM
         GVVBF7BMyilsPEPW6wc/9Rty4GgVmkkcGD8FkQP0D9UDrDqkTUq/MVnlTdPogwyu6Dy+
         xbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wf32qAwriumt3y35I2RkCV8Imv2K/N8sm1rGj9XR+F4=;
        b=qUKZsOQ7/eKmktoQCFl1kjJG2fjCYD9jwdO4KyglZH53Im9RFRswuerFF7bnbqby0A
         JHWwJpFFuM9zkOSbqofRDFGJ+qKJhziachFo4CQl2Ud4gGAXtKYRDmVyG/ghlKpCuwdi
         aJa9pAKCMW7uqYFr9v9h4HrLJlliSCIxKkkje50WFngVZm9F4psbvQpLYBQedGYp7J8Y
         0/Tqe5vbfqfo0WlDzPnODk1Wcj/wVRxWgPxWHyE1A8fa2M9JBnZNqByhikzvYlQB692C
         JqJNo7XsfcoVzFwbuWDleNjXZ8Z0N2G3DjcVQxcKUz0DI9/is0EhakF4g2WtYY+eBVYs
         oVlw==
X-Gm-Message-State: AJIora9BO+rgWoeRIBUMhh+UAzRbQn0gS8WgnM2f1P/wopmMqACRyjDp
        Q6RwlcSQ8VG884de5S2iphA=
X-Google-Smtp-Source: AGRyM1syr03DlqfOxjJ/UEYA0iAxsOLobsv3GCgEZW/8MBOi+gSSePBl+3sGVZJX5ngaZqUqbjP4Ww==
X-Received: by 2002:a17:90b:164c:b0:1f2:31f5:7d68 with SMTP id il12-20020a17090b164c00b001f231f57d68mr3258745pjb.5.1658412993417;
        Thu, 21 Jul 2022 07:16:33 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090a0bc200b001f239783e3dsm894163pjd.34.2022.07.21.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:16:33 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:16:30 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Divya.Koppera@microchip.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com
Subject: Re: [PATCH v2 net] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Message-ID: <Ytlfvqns1Qp4/UWA@hoboy.vegasvil.org>
References: <20220719120052.26681-1-Divya.Koppera@microchip.com>
 <Yta4BFfr+OkUmOhl@hoboy.vegasvil.org>
 <CO1PR11MB47715323651FBC994C4C918FE28E9@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB47715323651FBC994C4C918FE28E9@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 04:32:55AM +0000, Divya.Koppera@microchip.com wrote:

> static int lan8814_ptp_probe_once(struct phy_device *phydev)
> {
>         struct lan8814_shared_priv *shared = phydev->shared->priv;
> 
>         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
>             !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
>                 return 0;

It is weird to use macros here, but not before calling ptp_clock_register.
Make it consistent by checking shared->ptp_clock instead.
That is also better form.

Thanks,
Richard
