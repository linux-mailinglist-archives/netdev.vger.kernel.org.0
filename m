Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A8848491F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 21:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiADUQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 15:16:30 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:38513 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiADUQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 15:16:29 -0500
Received: by mail-oi1-f180.google.com with SMTP id s73so61154502oie.5;
        Tue, 04 Jan 2022 12:16:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=75KdaeRZ1jVa25k2aqyDkyMYUVMAqnMfp8vxvIY/EvM=;
        b=xEk0wtRlgQQ9bO1CpmDfrw+bFyIWtrrl+/uN3pEHq0pz/J/o+qQjGWtOGN8M95+qYS
         F4GqPPLx2p18iBW/70rc9XIz1ObIyP9sfDPb7VtkZsNgtodwiF46FeTzA2g3PPJV0X5L
         NPMKCAzTz4erArOEuUgY0B/v4rQhIHPTi0ClWFmYhKBsWrCFTZgL7/ilYkeU8+7OFIim
         Mx483ovykdZmXLg3va0GWo0KCDyuiOCQYcrVFSLzFqgXOqzwH8Gs9l5mFoiY8Kij9UX4
         Sawyc9S7XfuUCNBY77rhh0a2VJgFBIFVcUE6lGiAYHbuImUT0zatbVHxxEEA5nAtSTFt
         VWxg==
X-Gm-Message-State: AOAM532hmmbZOk0K5nCiEspwD4NqBjS/n+TF508fCeWK4Jpd2Mvafiva
        TeqKC26o0ypx04sui/jvjH0kyAh95Q==
X-Google-Smtp-Source: ABdhPJwkJhG+egsjUnjaP/dqAPbfiVolA6ZKSBcVw6ZOEQkNx5bPZrT2/dlciwh//xOu4pUbzDKEGg==
X-Received: by 2002:a05:6808:16a4:: with SMTP id bb36mr38016oib.112.1641327389124;
        Tue, 04 Jan 2022 12:16:29 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id i28sm8164650otf.12.2022.01.04.12.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 12:16:28 -0800 (PST)
Received: (nullmailer pid 1345397 invoked by uid 1000);
        Tue, 04 Jan 2022 20:16:27 -0000
Date:   Tue, 4 Jan 2022 14:16:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 3/5] dt-bindings: nvmem: allow referencing device defined
 cells by names
Message-ID: <YdSrG3EGDHMmhm1Y@robh.at.kernel.org>
References: <20211223110755.22722-1-zajec5@gmail.com>
 <20211223110755.22722-4-zajec5@gmail.com>
 <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
 <f173d7a6-70e7-498f-8a04-b025c75f2b66@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f173d7a6-70e7-498f-8a04-b025c75f2b66@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 10:58:56PM +0100, Rafał Miłecki wrote:
> On 23.12.2021 22:18, Rob Herring wrote:
> > On Thu, Dec 23, 2021 at 7:08 AM Rafał Miłecki <zajec5@gmail.com> wrote:
> > > 
> > > From: Rafał Miłecki <rafal@milecki.pl>
> > > 
> > > Not every NVMEM has predefined cells at hardcoded addresses. Some
> > > devices store cells in internal structs and custom formats. Referencing
> > > such cells is still required to let other bindings use them.
> > > 
> > > Modify binding to require "reg" xor "label". The later one can be used
> > > to match "dynamic" NVMEM cells by their names.
> > 
> > 'label' is supposed to correspond to a sticker on a port or something
> > human identifiable. It generally should be something optional to
> > making the OS functional. Yes, there are already some abuses of that,
> > but this case is too far for me.
> 
> Good to learn that!
> 
> "name" is special & not allowed I think.

It's the node name essentially. Why is using node names not sufficient? 
Do you have some specific examples?

Rob
