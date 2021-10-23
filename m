Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE28D4385BB
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 00:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhJWWNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 18:13:09 -0400
Received: from ixit.cz ([94.230.151.217]:43448 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhJWWNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Oct 2021 18:13:08 -0400
Received: from [192.168.1.138] (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 395BA20064;
        Sun, 24 Oct 2021 00:10:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1635027046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MfqblF+1rj3tmjWqu4kRVHLDcxNNvTNU5QQ8iw6qvy0=;
        b=d46oFwDxH1zjuLwINI/aSrCATiG5mJxl+7Erta2rhJybbpOkiRYbXyo+xefNv6tn1yox4p
        RnEaQUaQVpcmAmwITtiY+siTf/fA7DW2CbFPi99Kltk8t6Lp5lBUxdLn/P7BFCVSCma8ma
        UitvzMonrbS309h9z4bCR6+CZALjG3Y=
Date:   Sun, 24 Oct 2021 00:10:40 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings
 to yaml
To:     Rob Herring <robh@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~okias/devicetree@lists.sr.ht, devicetree@vger.kernel.org
Message-Id: <SXAG1R.XBYYXLESDTAF1@ixit.cz>
In-Reply-To: <YW2+R4drCwcmzKMK@robh.at.kernel.org>
References: <20211017160210.85543-1-david@ixit.cz>
        <1634559233.484644.2074240.nullmailer@robh.at.kernel.org>
        <RAC61R.YOBPB57076K71@ixit.cz> <YW2+R4drCwcmzKMK@robh.at.kernel.org>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well, but the nxp,pn544 won't using `clock-frequency`. So do I have to 
keep the property there anyway?

David


On Mon, Oct 18 2021 at 13:34:47 -0500, Rob Herring <robh@kernel.org> 
wrote:
> On Mon, Oct 18, 2021 at 03:04:03PM +0200, David Heidelberg wrote:
>> 
>> 
>> 
>>  On Mon, Oct 18 2021 at 07:13:53 -0500, Rob Herring 
>> <robh@kernel.org> wrote:
>>  > On Sun, 17 Oct 2021 18:02:10 +0200, David Heidelberg wrote:
>>  > >  Convert bindings for NXP PN544 NFC driver to YAML syntax.
>>  > >
>>  > >  Signed-off-by: David Heidelberg <david@ixit.cz>
>>  > >  ---
>>  > >  v2
>>  > >   - Krzysztof is a maintainer
>>  > >   - pintctrl dropped
>>  > >   - 4 space indent for example
>>  > >   - nfc node name
>>  > >  v3
>>  > >   - remove whole pinctrl
>>  > >  v4
>>  > >   - drop clock-frequency, which is inherited by i2c bus
>>  > >
>>  > >   .../bindings/net/nfc/nxp,pn544.yaml           | 56
>>  > > +++++++++++++++++++
>>  > >   .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
>>  > >   2 files changed, 56 insertions(+), 33 deletions(-)
>>  > >   create mode 100644
>>  > > Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>>  > >   delete mode 100644
>>  > > Documentation/devicetree/bindings/net/nfc/pn544.txt
>>  > >
>>  Full log is available here: 
>> https://patchwork.ozlabs.org/patch/1542257
>>  >
>>  > Running 'make dtbs_check' with the schema in this patch gives the
>>  > following warnings. Consider if they are expected or the schema is
>>  > incorrect. These may not be new warnings.
>>  >
>>  > Note that it is not yet a requirement to have 0 warnings for 
>> dtbs_check.
>>  > This will change in the future.
>>  >
>>  >
>>  >
>>  > nfc@28: 'clock-frequency' does not match any of the regexes:
>>  > 'pinctrl-[0-9]+'
>>  > 	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-E1565.dt.yaml
>>  > 	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-PM269.dt.yaml
>>  >
>>  > nfc@2a: 'clock-frequency' does not match any of the regexes:
>>  > 'pinctrl-[0-9]+'
>>  > 	arch/arm/boot/dts/tegra30-asus-nexus7-tilapia-E1565.dt.yaml
>>  >
>> 
>>  Patches for this are already in grate repository and will be sent to
>>  mainline soon! :)
> 
> Okay. I was under the impression 'clock-frequency' was removed 
> thinking
> it is in the i2c bus schema already. It is, but unfortunately you need
> it here too if used because all properties for a node have to be 
> listed
> in the schema for the node. 'unevaluatedProperties' can't evaluate
> properties in the child nodes of the parent schema with the properties
> of the child schema.
> 
> Rob


