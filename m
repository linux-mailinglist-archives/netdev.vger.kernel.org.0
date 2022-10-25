Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109CB60D710
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiJYW15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiJYW1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:27:55 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF01ADAC;
        Tue, 25 Oct 2022 15:27:54 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sc25so16457354ejc.12;
        Tue, 25 Oct 2022 15:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QQH4TaYIF6o38h7xbsFuFuW1teTfoq+Fiszi+NsDgAM=;
        b=iEqpYCwY/QVTnjy4gBWJRmoe3Liq1KuoPKwrWuNlpEGzeZXOhDJpUiEj3kT9vW7NA/
         n7Bldio0YTQRAJrAB5UJF391QPEcFHf93zLfCQ0Gvn6osvR1S4etwVwMlBSiuZWwPKG+
         HM5tUBIMYq0PHOguc3cpA8ZjYjgHg5D+iycaQrxBSFsoGsqiKbuXvxAbCqB1q+LAtCVF
         SS7DgOEA5Vn8bCi7EQGT0teXoRjIT32KudE2spuo4w+yApmVbwFSd1M4ghPtYIP+b/Fv
         GWFR3Ffp75tp3SNFEdrgXr1XGD/RBidr1h4LT1eoCSv0raqElEqQx37Og87uy5Y9JjOU
         b3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQH4TaYIF6o38h7xbsFuFuW1teTfoq+Fiszi+NsDgAM=;
        b=nzPBE1zPK876xpAY8ESupVgY6tlBT/wT6de4uwmnRNaL+9PFFpETA/68wfPvdC1TPH
         D7vYKOKSSgf/fFcyaPhH4VvkN353XiJNYxp9eKGzF4vek3ao+lEXYbbtRyQy3DgLV7EE
         rB3r8E5BR6pXiimuhu86l4HRD1HDBFm9dI9TdTaxQQXnqKQsnqS1mBT0KiYkBREUI3G5
         ifccLKwfidAIAL1Tme8T+B/N9+P581rB6oPwADYhnMoVF6Ll84oUlQgBKQz6Uopm55dn
         MhjMyY2F9OFQoTFLeytAjdHH0K6vOWPHyjhDae+mvRX3l645QerZMoMUJ07tlLA+ZXq+
         Zwgg==
X-Gm-Message-State: ACrzQf3ivpHrBnRc7/WhEkKvVQKu+WcnhOXWdcglzWhsJ57xs1qZCeF0
        8K3Jir6B/Yn/3Nfd5RAcWYQ=
X-Google-Smtp-Source: AMsMyM4yuBBqbTkrLresixT63VODi3DoEvd2NVhI8pHLQRLJHMmALipMbV/mqYxTnflvOY/B8Waj0g==
X-Received: by 2002:a17:907:e93:b0:78d:46b3:3a76 with SMTP id ho19-20020a1709070e9300b0078d46b33a76mr33905029ejc.133.1666736872599;
        Tue, 25 Oct 2022 15:27:52 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id m8-20020a509308000000b0045bd257b307sm2302860eda.22.2022.10.25.15.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:27:51 -0700 (PDT)
Date:   Tue, 25 Oct 2022 15:27:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, yangbo.lu@nxp.com,
        radhey.shyam.pandey@amd.com, anirudha.sarangi@amd.com,
        harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Message-ID: <Y1hi5YHS/ATx79JJ@hoboy.vegasvil.org>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
 <20221024165723.GA1896281-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024165723.GA1896281-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 11:57:23AM -0500, Rob Herring wrote:
> On Thu, Oct 20, 2022 at 11:41:10PM -0600, Sarath Babu Naidu Gaddam wrote:
> > There is currently no standard property to pass PTP device index
> > information to ethernet driver when they are independent.
> > 
> > ptp-hardware-clock property will contain phandle to PTP clock node.
> > 
> > Freescale driver currently has this implementation but it will be
> > good to agree on a generic (optional) property name to link to PTP
> > phandle to Ethernet node. In future or any current ethernet driver
> > wants to use this method of reading the PHC index,they can simply use
> > this generic name and point their own PTP clock node, instead of
> > creating separate property names in each ethernet driver DT node.
> 
> Seems like this does the same thing as 
> Documentation/devicetree/bindings/ptp/timestamper.txt.
> 
> Or perhaps what we have in bindings/timestamp/ which unfortunately does 
> about the same thing.
> 
> The latter one is more flexible and follows standard provider/consumer 
> patterns. So timestamper.txt should probably be deprecated.

I don't see how you can do that.  The provider/consumer semantics are
completely opposite.

The three (including present patch) bindings specify three different
relationships.

Thanks,
Richard
