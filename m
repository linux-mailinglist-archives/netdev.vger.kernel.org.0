Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB05F4E2C2A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350191AbiCUP2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350277AbiCUP2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:28:06 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73300103D97
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:26:40 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 17-20020a9d0611000000b005b251571643so10739888otn.2
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uaYYePl58qD2iQ93LY0YiSd1GFMq/Ms9P4dOHYbzMlI=;
        b=kDFmbf4AUYcplwDiauwDg1kjxYY9CNrcbJmzEghMFM5UCpt1iKIStezrGUo/lpVXgU
         8MpcjOabilgH+AD6ZYGglj/ForVsTjm3QOGkx91oKL/qrKwAT+zZPwgcmBIk0pEay9c5
         3NgFw4t9WDT3IEXLOQMpoYYHft4yX2vljoDBaUcYgrI4SR0MHggrOEwfWUj6zl0ri+zc
         uP/2/VGpKrE2Ye4WCAZk4pLJYp+JB1wno3oZk004MfMLxrRQz2WE3whQJsGE8JXI4OAW
         wqs8BOQ7nkLXDkUsIsFrpijQUP9nB+5w9T5nyOSmziH1lHCBO8Z9lhJdcotwfOj5PATI
         zB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uaYYePl58qD2iQ93LY0YiSd1GFMq/Ms9P4dOHYbzMlI=;
        b=28/20zBGJI7jUmR4YBfLX+PIUImmvZS+VwJV5F+KGEc7MRoZJUUfGw7W0MMzc8WjB+
         lnNo9OBAUGjHdVsh30ag3fRmtOGQQPJtFoOnA2ygjG+t0xly5hMCP+xbFU5GF7mlWWzF
         s4Vwalj1r/eDd1Syx+0O0Fw8yY2I4vBzL1aNUe33EtkkymJbsAM9PWHZxrz3ewv0fMuV
         /Wa2LfRCYPBF21htsVWxBdUbSFuLt8AbaL+FUOafYhDCObTtvVdB6huHTvsSQ29lONi+
         h+bfOi/XHEYzwklLK6McMWdrge48xMzha1mkWgio+zV2H5VKY41/aaFmNVYYr/5Edcbi
         4qdw==
X-Gm-Message-State: AOAM532rTOxKLd/hg4xG1pArY+FpvY1f3ra6mzG7P3pRpFHqKj0bf/Kx
        FuO+BuKZv3U/5ar07XihEIBe/UcRr6ovLkUQrRpjjLUqVecL5Q==
X-Google-Smtp-Source: ABdhPJzo+Gow3AjJyknC7hnuT59nMcfKj/ZSEALpmQFZjy9h9OILBmdMYSId8bh1qQeBKRysv2Abg9CHQ5XPCx7eBO8=
X-Received: by 2002:a9d:2247:0:b0:5cb:3eef:d42b with SMTP id
 o65-20020a9d2247000000b005cb3eefd42bmr6801297ota.297.1647876399510; Mon, 21
 Mar 2022 08:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220318070039.108948-1-andy.chiu@sifive.com> <20220318070039.108948-2-andy.chiu@sifive.com>
 <557c20e1045320288557c72fd2b9b1fb0899b5a7.camel@calian.com>
In-Reply-To: <557c20e1045320288557c72fd2b9b1fb0899b5a7.camel@calian.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 21 Mar 2022 23:26:28 +0800
Message-ID: <CABgGipW4dU8g5=Cp4725vTsTUXBqMwb+mYdUnUwMe+cuWcuB+Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] net: axiemac: use a phandle to reference pcs_phy
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
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

Thanks for your suggestions. The existence of phy_node looks obsolete
to me as well. I will include these changes on a v4 patch.
