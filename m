Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683D45834BD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiG0VLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237839AbiG0VLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:11:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302725A166;
        Wed, 27 Jul 2022 14:11:17 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id p5so11981102edi.12;
        Wed, 27 Jul 2022 14:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SszM4KOD8a75RFBoCwKtsjfdyb3hDocLRY8C+kxQmUg=;
        b=IxHzYXT76+F096MsZeTqNWie9IPQS08bwMwBPEXfE5ZtH7bgA8V8RkiOpGrTNd282R
         z/2G7Im13NncEJK9NZ7v5Ry/H2AThIAWcFvOXcaya0dvOI42LgEC2B1jG5yZAqJKesPs
         rE/6GRO1h4o1/oZ6J3yPuGiyTd8S/+FjZDvCmLhHqA1A9v4JafhvCGBHQcJUAOley+jD
         /yXrprKIwWDFgHCBjdf1agSWillnqmZawYwNRgtEZEijqVBahiV/uCHHxeGFVTngXQBR
         JJsQ0ZwxzldMvhgizbyjibDRtmdYFPP2aqLVY/KbF4+jINyKJydjGQP9PTV560BItVku
         t5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SszM4KOD8a75RFBoCwKtsjfdyb3hDocLRY8C+kxQmUg=;
        b=lrOr9+hTkeO9FupmbcPrZ+kIkWL1sz44L8ULyIbQ9JOzPIyl2Q/HqjJAo6T2BJp2Vq
         X/YKKRuA1LDSp79N/wUl06CNZUnm6g5apTBYaw9JetoH/4qhXwpo4hbxK6D7/y0PzgaP
         tNuLjLw/OiZLJIgYDIkvlDBUWEfxrtxSIHavWANlqYDfKZxurpVXneTA9K5hqecWQVs6
         xgKSc/cu9jw5QT8S7etCFqU9Nar5YUJej7aHpfnPK32ci+RaFNUrg3Pr337XHYUlq/WK
         QdcQK9XxnijrrANG7gZLL+3xAQiJengTNrSXS2QN79Rz7UXAbHRim8vWKpd7SDQI3zEF
         VBwQ==
X-Gm-Message-State: AJIora8CTSVz3Pw0/8Zp91f3T77gQSh0tcyKcsSfGPcXDcyFaSgFtshl
        ASAgRm1nUYNkVhjIM75BvCM=
X-Google-Smtp-Source: AGRyM1sxDMJ86KJfyU2VR4XAcwE98iLOUptOxM+Kb+fwKVIplQAw4YhK36PCVxbazJHnBCIQncvoUA==
X-Received: by 2002:a05:6402:48c:b0:43a:8bc7:f440 with SMTP id k12-20020a056402048c00b0043a8bc7f440mr24244806edv.8.1658956275526;
        Wed, 27 Jul 2022 14:11:15 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906218a00b00705cdfec71esm7965666eju.7.2022.07.27.14.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 14:11:14 -0700 (PDT)
Date:   Thu, 28 Jul 2022 00:11:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <20220727211112.kcpbxbql3tw5q5sx@skbuf>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf>
 <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 07:40:00PM +0200, Marcin Wojtas wrote:
> SET_NETDEV_DEV() fills net_device->dev.parent with &pdev->dev
> and in most cases it is sufficient apparently it is sufficient for
> fwnode_find_parent_dev_match (at least tests with mvneta case proves
> it's fine).

Indeed, mvneta works, which is a plain old platform device that hasn't
even been converted to fwnode, so why don't the others?

Well, as it turns out, it's one of the cases where I spoke to soon,
thinking I knew what was the problem why probing failed, before actually
debugging.

I thought there was no dmesg output from DSA at all, which would have
indicated an eternal -EPROBE_DEFER situation. But there's one tiny line
I had overlooked:

[    5.094013] mscc_felix 0000:00:00.5: error -EINVAL: Failed to register DSA switch

This comes from here:

static int dsa_port_parse_fw(struct dsa_port *dp, struct fwnode_handle *fwnode)
{
	struct fwnode_handle *ethernet = fwnode_find_reference(fwnode, "ethernet", 0);
	bool link = fwnode_property_present(fwnode, "link");
	const char *name = NULL;
	int ret;

	ret = fwnode_property_read_string(fwnode, "label", &name);
//	if (ret)
//		return ret;

	dp->fwnode = fwnode;

The 'label' property of a port was optional, you've made it mandatory by accident.
It is used only by DSA drivers that register using platform data.

(side note, I can't believe you actually have a 'label' property for the
CPU port and how many people are in the same situation as you; you know
it isn't used for anything, right? how do we stop the cargo cult?)

> Can you please check applying following diff:
> 
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -695,20 +695,22 @@ EXPORT_SYMBOL_GPL(fwnode_get_nth_parent);
>   * The routine can be used e.g. as a callback for class_find_device().
>   *
>   * Returns: %1 - match is found
>   *          %0 - match not found
>   */
>  int fwnode_find_parent_dev_match(struct device *dev, const void *data)
>  {
>         for (; dev; dev = dev->parent) {
>                 if (device_match_fwnode(dev, data))
>                         return 1;
> +               else if (device_match_of_node(dev, to_of_node(data))
> +                       return 1;
>         }
> 
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(fwnode_find_parent_dev_match);

So, nothing to do with device_match_fwnode() failing, that would have
been strange, come to think about it. Sorry for the noise here.

But looking at the deeper implementation of dev_fwnode() as:

struct fwnode_handle *dev_fwnode(struct device *dev)
{
	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
		of_fwnode_handle(dev->of_node) : dev->fwnode;
}

I wonder, why did you have to modify mvpp2? It looks at dev->of_node
prior to returning dev->fwnode. It should work.
