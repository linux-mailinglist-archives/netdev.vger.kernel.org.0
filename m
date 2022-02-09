Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE54AE7EF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiBIEHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347645AbiBIEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 23:00:21 -0500
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23900C061578;
        Tue,  8 Feb 2022 20:00:20 -0800 (PST)
Received: by mail-ot1-f45.google.com with SMTP id d18-20020a9d51d2000000b005a09728a8c2so717527oth.3;
        Tue, 08 Feb 2022 20:00:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9ITXoQHdukMg0AJwxVtuQyXqF9fERtFBbwIwqVY93pw=;
        b=H6S7rODUEJIOuBsLYJnf+JxpHclx16NiSPiTNvDqaiDs35NBGGq2KpPvBJrGYZ4ZLH
         NN4QnjOkf9QakBE5N6SpJuoSg/TwJdLDxyMSt4j1tw5G8OOAbi3o3IERNSQ/7oVy8Z4W
         hHxOhIKi+768GK3yv8PvHnI3Gbtx3396MmZ0uGVIitlSRNYsQOuxzfHkJutep7Kx+Ycw
         7pvRtIcBMj2m6qkVm9U65LfDpnvWKQEkAGyjcsexEFbD7TeBJwCKzaUFS0DR91zN7lYJ
         aS4atEorSsFBL+HoFrmIFJgWkYKlU7CzJxL74DkGua2oe+Z1ZET4WOFOjvRKg+BqYUXt
         CsNw==
X-Gm-Message-State: AOAM532yujHmolIeTNlwhThbqchvgf6s2tKz88WPqN8Qiv3BefFkHzCd
        I6G8Ac6L5TQqo34H/pHM8Q==
X-Google-Smtp-Source: ABdhPJzIyhK7aV/i0m589xp+U8+nFS4mUwYqlnKAbjLef/sAxW2NoG7YmHxD48+bxfUz+DAd1jLJJQ==
X-Received: by 2002:a9d:7e88:: with SMTP id m8mr196111otp.123.1644379219434;
        Tue, 08 Feb 2022 20:00:19 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bi41sm6246421oib.39.2022.02.08.20.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 20:00:17 -0800 (PST)
Received: (nullmailer pid 3626148 invoked by uid 1000);
        Wed, 09 Feb 2022 04:00:16 -0000
Date:   Tue, 8 Feb 2022 22:00:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <YgM8UIEfw+UbDwrE@robh.at.kernel.org>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127104905.899341-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:49:05AM +0100, Oleksij Rempel wrote:
> Similar to the option to set a netdev name in device tree for switch
> ports by using the property "label" in the DSA framework, this patch
> adds this functionality to the usbnet infrastructure.
> 
> This will help to name the interfaces properly throughout supported
> devices. This provides stable interface names which are useful
> especially in embedded use cases.

I'll pile on... The purpose of 'label' is to describe a human readable 
label on a port of a box. It should otherwise be opaque to s/w. Yes, 
there are abuses of that in the kernel, but don't add more.

Rob
