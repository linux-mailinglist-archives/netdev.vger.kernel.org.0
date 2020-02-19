Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C395A164859
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBSPTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:19:01 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39261 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgBSPTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:19:01 -0500
Received: by mail-ot1-f65.google.com with SMTP id 77so465856oty.6;
        Wed, 19 Feb 2020 07:19:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JwUjvFjlBTnRJsVvsxdVVLk710Ge/pdqeSH+IOmuiEE=;
        b=nJFIiKqJjWGpGqp1PWfCb7bzSpnLPAFsH4vfvwdcAGWRa0L/SihNAicBmjNQ1Z1ogE
         tr3FoMG29KGijx3H38nBaxvBPLxkEBvrsfY/O2x+Rk31uVWNUEFZAG49Zkngfh/9n+cV
         iIBg0073jlElxsl1j3CrLDv4NxHLMShTC02rYhdn0JXyC9Mgjv02s2+jac5VExlp0OtU
         axYIYk52dG4bC1UI3hcjuVq2V1t6y9lygoS9nfKWGcCz/vPb7oZvIH0yOKSCL6x6XvlU
         4hpN94zLzmYiojtiRuqa9RqrjSU5pOlqf8rTQj8TucK0bn2QqwGZqNh2NJMcs/j6Q+H8
         hcgQ==
X-Gm-Message-State: APjAAAUGwgEwx4VqelFNeTNtKlpZubm9AMSDoGOlvwSfa3rV29utlWi1
        tuF/JunuIWTfEF4BLh9JVQ==
X-Google-Smtp-Source: APXvYqwv1BAD7eCKzfnd4cfc1ZK3tq+eY/VfMVvWjyLMpU9xD2FVh+tpdOKUVefJ8lnV8NqCeHERtQ==
X-Received: by 2002:a9d:62d8:: with SMTP id z24mr19238661otk.362.1582125540499;
        Wed, 19 Feb 2020 07:19:00 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q22sm13618otf.17.2020.02.19.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:18:59 -0800 (PST)
Received: (nullmailer pid 8771 invoked by uid 1000);
        Wed, 19 Feb 2020 15:18:59 -0000
Date:   Wed, 19 Feb 2020 09:18:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     min.li.xe@renesas.com
Cc:     mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: ptp: Add device tree
 binding for IDT 82P33 based PTP clock
Message-ID: <20200219151859.GA5294@bogus>
References: <1581114255-6415-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581114255-6415-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 05:24:15PM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add device tree binding doc for the PTP clock based on IDT 82P33
> Synchronization Management Unit (SMU).
> 
> Changes since v1:
>  - As suggested by Rob Herring:
>    1. Drop reg description for i2c
>    2. Replace i2c@1 with i2c
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  .../devicetree/bindings/ptp/ptp-idt82p33.yaml      | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
> new file mode 100644
> index 0000000..4c8f87a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
> @@ -0,0 +1,45 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ptp/ptp-idt82p33.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: IDT 82P33 PTP Clock Device Tree Bindings
> +
> +description: |
> +  IDT 82P33XXX Synchronization Management Unit (SMU) based PTP clock
> +
> +maintainers:
> +  - Min Li <min.li.xe@renesas.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - idt,82p33810
> +      - idt,82p33813
> +      - idt,82p33814
> +      - idt,82p33831
> +      - idt,82p33910
> +      - idt,82p33913
> +      - idt,82p33914
> +      - idt,82p33931
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg

Needs a:

addtionalProperties: false

> +
> +examples:
> +  - |
> +    i2c {
> +        compatible = "abc,acme-1234";
> +        reg = <0x01 0x400>;

Drop these 2 properties.

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phc@51 {
> +            compatible = "idt,82p33810";
> +            reg = <0x51>;
> +        };
> +    };
> -- 
> 2.7.4
> 
