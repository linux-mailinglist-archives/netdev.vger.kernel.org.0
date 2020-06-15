Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45571F9E97
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 19:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgFORdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 13:33:39 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43283 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbgFORdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 13:33:39 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so1201735iol.10;
        Mon, 15 Jun 2020 10:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=znZgzikhMiF0cbCjoL/7dPoO9dxXB49OkKB382FTvmg=;
        b=fqFrv9XFPl6JtQT8QqsdD+LdQ9cKr/6lKqZwrH43x2abtqBjvSGC9ZQBdA+7lMpZTD
         DxzusKYiownfVcfyyi65+HEczWuY63wsPh3qRVkfnfF0nbdkooADIoGGrtIiCRhjtukG
         EiGwLZFOqfLVhkX90uebiwa2klduVc9/pFPoCJJ0fPlqBWt99aAV0+5D91H1eM9Mco/i
         on7kh22R0XyYinFOebV6uRd46S6UfgSj10u/leB14cqtEHhSj1gYXqhaVjZKnYg6DClx
         gUrDDse9TvyiF7qsQBp3ej36kIGTH3In66+cqUvUsfvSDGGjTn3T6igz2GY3yCF/iIja
         KJNQ==
X-Gm-Message-State: AOAM5308/ok95ZKsIKIkTia423qBKi5aaDBFhriDPxash+kjabpQyt/f
        FaqBHgKG3cGVX3UYJnwC7g==
X-Google-Smtp-Source: ABdhPJzXoSwMCaTACFLMwlk6gXQKI8aMZe4Phl8uJe8Gr4CHl70EOj8Q76+n5J1AZwaFmMG52CMW+w==
X-Received: by 2002:a05:6638:a0a:: with SMTP id 10mr22203426jan.30.1592242418380;
        Mon, 15 Jun 2020 10:33:38 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id t189sm8209948iod.16.2020.06.15.10.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 10:33:37 -0700 (PDT)
Received: (nullmailer pid 2004792 invoked by uid 1000);
        Mon, 15 Jun 2020 17:33:36 -0000
Date:   Mon, 15 Jun 2020 11:33:36 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/4] dt-bindings: net: Add tx and rx internal
 delays
Message-ID: <20200615173336.GA2002437@bogus>
References: <20200604111410.17918-1-dmurphy@ti.com>
 <20200604111410.17918-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604111410.17918-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 06:14:07AM -0500, Dan Murphy wrote:
> tx-internal-delays and rx-internal-delays are a common setting for RGMII
> capable devices.
> 
> These properties are used when the phy-mode or phy-controller is set to
> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
> controller that the PHY will add the internal delay for the connection.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ethernet-phy.yaml       | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 9b1f1147ca36..edd0245d132b 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -162,6 +162,19 @@ properties:
>      description:
>        Specifies a reference to a node representing a SFP cage.
>  
> +
> +  rx-internal-delay-ps:
> +    $ref: /schemas/types.yaml#definitions/uint32

Standard units already have a type, so you can drop this.

> +    description: |
> +      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable RX internal delays.
> +
> +  tx-internal-delay-ps:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +      RGMII Transmit PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable TX internal delays.
> +
>  required:
>    - reg
>  
> -- 
> 2.26.2
> 
