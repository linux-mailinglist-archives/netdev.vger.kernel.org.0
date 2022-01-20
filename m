Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2D0495363
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiATRgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:36:42 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:44613 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiATRgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:36:41 -0500
Received: by mail-ot1-f43.google.com with SMTP id a10-20020a9d260a000000b005991bd6ae3eso8456217otb.11;
        Thu, 20 Jan 2022 09:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WrX4RV5ysW0eX2CGJIXQSl/WeTomxdQMP58KeR+spxE=;
        b=I9OX+pEOqCIGnHNJ4+9sFjgWb1cKv9Jp+HnNOhFqQ40IvHxk/SLubcNmfRayl2rTMo
         m3uDqQbmVSzLPaG1Ay/PFOL1j38m+Njzu66Z0HtbXr4fld2AxEOFUaPwrbYre1Wugg6a
         0wPzwAj+EkCNROqR2UhVgBoNweqVbwwBdoBAcqwKfTTTxwV6ldCwzImUMo2uAhKOClAN
         CzFrDcP99ftupja08jUO6k4TGqX4TvPVAEQ7CwB0N7ohE0eIR+I/x5PjKfgwn9ZisU8d
         LReZp2eom3c44GQ7zolnD3SVdqaToROjM3Imi/H+NWWnWAUOZ69DZkEV6zkcMmTsX6aF
         j12w==
X-Gm-Message-State: AOAM533wLTARc7WbMK1xaGtjlZw9F/ktjt05hqmM+MfXTSOozhYzPqJL
        p7ZW0c6Vbt5Bt4TwrWWMjQ==
X-Google-Smtp-Source: ABdhPJxDTZOBw8MHBl2N7Vjg2CtBXyfBif+NH70e74zuFxGUs8bgC25UKRzfIjDXQ/+mTARQ5fTp6w==
X-Received: by 2002:a9d:75d6:: with SMTP id c22mr9166540otl.273.1642700200671;
        Thu, 20 Jan 2022 09:36:40 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id h5sm1446668oor.4.2022.01.20.09.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 09:36:39 -0800 (PST)
Received: (nullmailer pid 1649046 invoked by uid 1000);
        Thu, 20 Jan 2022 17:36:38 -0000
Date:   Thu, 20 Jan 2022 11:36:38 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        linux-kernel@vger.kernel.org, Rui Miguel Silva <rmfrfs@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        Sriram Dash <sriram.dash@samsung.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix array schemas encoded as matrices
Message-ID: <YemdpgQqS8FX9/5g@robh.at.kernel.org>
References: <20220119015627.2443334-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119015627.2443334-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 19:56:26 -0600, Rob Herring wrote:
> The YAML DT encoding has leaked into some array properties. Properties
> which are defined as an array should have a schema that's just an array.
> That means there should only be a single level of 'minItems',
> 'maxItems', and/or 'items'.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/media/nxp,imx7-mipi-csi2.yaml    | 12 ++--
>  .../bindings/media/nxp,imx8mq-mipi-csi2.yaml  | 12 ++--
>  .../bindings/net/can/bosch,m_can.yaml         | 52 ++++++++--------
>  .../bindings/net/ethernet-controller.yaml     | 59 +++++++++----------
>  4 files changed, 62 insertions(+), 73 deletions(-)
> 

Applied, thanks!
