Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0F42A542
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhJLNSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:18:49 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:33773 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbhJLNSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:18:45 -0400
Received: by mail-oi1-f169.google.com with SMTP id q129so8289175oib.0;
        Tue, 12 Oct 2021 06:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H1gCfeZM8D46sKt+LlwE0xSTSKdW6wn+1al3obvMhhw=;
        b=GOHrE+c0YLe01qmAPk9T9JCm8e52vgrMmc1emIk5kmP2Hs7ZAHXEqSYI8H/D7mCPG8
         rdC1Xg8pd8cAN4ffF4Uri4w3KgnUxP4/0a+N2lkamDUp9UQwVTL6qD6By9M7ZzygcRyk
         M0IWXthzC/6YF1EQV6w+27UPWRzMg/rX1N3IRtFWbqCloVGoejeEIJ6zdu0Qjl04Tl5I
         Lqhloy0tPPQjDA5pLl+OtfHaWiCwaMDh8Nwyokf+H5maMIV8uxYctFA6vp934BuMZULz
         NVuogrtGpWsdpmkC1crZDlMlo97f3sGUrpvrEVrp+vwOFI1PHBlLPWS7euSHNehq71mh
         lurg==
X-Gm-Message-State: AOAM531EPv1vctAKpANRBxVfSzmzCVuC+xsCq91mEXDLwRvrMTIGvINa
        652E5z7Jj7rHiYrmnri9Lg==
X-Google-Smtp-Source: ABdhPJzlnDcuhhVI4hiEfqlZ1Pe9A8O6OQwWK9MJEiy48yQsA1yVQVaR3yopwASE2T7I+7qKMSEfiA==
X-Received: by 2002:a05:6808:3a7:: with SMTP id n7mr3550077oie.45.1634044603773;
        Tue, 12 Oct 2021 06:16:43 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e28sm1404519oiy.10.2021.10.12.06.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 06:16:43 -0700 (PDT)
Received: (nullmailer pid 2655630 invoked by uid 1000);
        Tue, 12 Oct 2021 13:16:42 -0000
Date:   Tue, 12 Oct 2021 08:16:42 -0500
From:   Rob Herring <robh@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org
Subject: Re: [RFC net-next PATCH 01/16] dt-bindings: net: Add pcs property
Message-ID: <YWWKuhn4FfgbcqO/@robh.at.kernel.org>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-2-sean.anderson@seco.com>
 <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 10:39:36AM +0100, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:12PM -0400, Sean Anderson wrote:
> > Add a property for associating PCS devices with ethernet controllers.
> > Because PCS has no generic analogue like PHY, I have left off the
> > -handle suffix.
> 
> For PHYs, we used to have phy and phy-device as property names, but the
> modern name is "phy-handle". I think we should do the same here, so I
> would suggest using "pcs-handle".

On 1G and up ethernet, we have 2 PHYs. There's the external (typically) 
ethernet PHY which is what the above properties are for. Then there's 
the on-chip serdes PHY similar to SATA, PCIe, etc. which includes the 
PCS part. For this part, we should use the generic PHY binding. I think 
we already have bindings doing that.

Rob
