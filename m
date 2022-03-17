Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9A84DCC7E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbiCQRc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiCQRc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:32:58 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DF4215453
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 10:31:41 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id g5-20020a4ae885000000b003240bc9b2afso7256702ooe.10
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 10:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9UHalmioQQvUWvJNuzTIkwKwh00iyQc5ZCTi4nT16PE=;
        b=Z11lyEwLRGdlPvJJKMAXYd/IyClDFa/XKu45OySM3wQgxW17bxprKjx9VEeI9WjhGy
         3/khJNhFtjVLtokVbtB2dF7EMa6lx+vOSkqFdZeNyE+S9AooPmqQBwNSLBK8Tj4WdtHx
         kAyxOQCTD23dvlqyCmAoE/abtX3Ng0D1RR80TK03kZrss9wBxUeH0U//BL6lWyyV6Gtk
         QkapYRfh7Q427cGULJfAol5sJW0wMk7iwVlb4Wu1ktZ3zi+1EQaABJ21vTHgMIeUJb/i
         5EoZyEc7CGNskGhtBGgucXB5bxzsLQ8AFLLTpiyLxFaJj7AoaBMz9+7IdTPPa8OugzF/
         ZIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9UHalmioQQvUWvJNuzTIkwKwh00iyQc5ZCTi4nT16PE=;
        b=QcSaHPjY0dwm6BGVkk0J42qQTibMAnqO92961jZ8U3m5pnYjPHLNmBU5aJExepeeMV
         XZ3sNW2RaeAYmF0Ml/+CLIhaazozPt2wjtN5n1sZRO+DHpe4ukU0PS3ytyFeb+SF2d0T
         5RkV5Y4ri95XszjsiQeT7DTZBIYBB86sZ+oWJUxy1yABApL3jIeXTlPmY0wt9bp7ExhD
         oH99esaNfv1JAYIZPS1SjKmR8zGYzWEBaQn0n0xE1ic+8bWDY47/CE57+Fi2rXupN0l4
         Yz9yNpZDuTj3zmRD1aWMYsUNMxEn/gwWjb+4Jx1gNw8ApTQ8+J9moWZ2T9LJdKz7ozcL
         ORPQ==
X-Gm-Message-State: AOAM532oexSTI8Ms7tkghBH2AkQTPl6AHGhbR03EEDFXAgNLO4KkGSiQ
        d8/LqJw3SkTzHczeb8TyVYcblLMy0P1lG8j/8pTw6Frl55s=
X-Google-Smtp-Source: ABdhPJxCjrETCPKtDG7sfTCMJKNVxlc8pvzVk50qGCs2dygjKpQmW2PMx6bWXAvI7uIGS2IsG3txWC+y9aVOLqz94v4=
X-Received: by 2002:a05:6870:2105:b0:dd:b1d0:6a27 with SMTP id
 f5-20020a056870210500b000ddb1d06a27mr2188263oae.285.1647538301173; Thu, 17
 Mar 2022 10:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220317091926.86765-1-andy.chiu@sifive.com> <CABgGipUd67TSoPz3eeKf2kXzzwy8NWJMkGYtkikdcBKiaJd8Bg@mail.gmail.com>
 <27534eccd05cd035773c1a4f1ea55fe6bd4a3f48.camel@calian.com>
In-Reply-To: <27534eccd05cd035773c1a4f1ea55fe6bd4a3f48.camel@calian.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Fri, 18 Mar 2022 01:31:30 +0800
Message-ID: <CABgGipXJKmRgq5ZVcw3uZM7Mqe-=QxFUyzQbWObVbnaUCtU7Vg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: xilinx_axienet: add pcs-handle attribute
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the explanation,

I will include that on the v3 patchset.

Andy
