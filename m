Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF702277CC
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 06:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgGUE5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 00:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGUE5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 00:57:10 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF64C061794;
        Mon, 20 Jul 2020 21:57:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g10so1338190wmc.1;
        Mon, 20 Jul 2020 21:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MOHZPUcZmQ1+3Cm43KVtLVEMv7NaU72MO15NMay1HOU=;
        b=WRThQTDlSSJMxAftVyK9UvBNMrio/jAxRn/LyrqEgQ/3ffpNbjjqAs9hZ3w+ktVqXF
         hOWof8LtwTAeTtUSYhPaTguBwSae/53dUhGweyz4PUb6QCME2LjqjUTWbn5rKD023AvX
         D/Zp02WIJXBqKaUMo7QryaVdA1RUcWKGH0TAkCPYuPti30jlIgH8iqeTFuDRvJEnca6f
         qFVICtCT2+Y9aYrZyqNxUOyB1QvroX9cCm0UJcf5t0jiEDqb5dNvzP7Otu+0+EfuFfMv
         3V9PE4EJDEpwNweDpLt3mFR/Zo8Kn5ga8OWdAsYbbNqn/wjSIZ4LsH9DcXdk+2T/oVJA
         dgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MOHZPUcZmQ1+3Cm43KVtLVEMv7NaU72MO15NMay1HOU=;
        b=WKl/EO8djZwyDGFI/VU43nFSIa/CtRD3Siero/aLrYbXksKYnZggkEMGQuuImrXtdg
         qdDGMYMQF2O9MKQ6oQl1Ag3rqy6v2UbuHoD23U3lxXnFWJSF6l8hTs9ZgG0/iMp5Ghf5
         DmaxzDtAqASYAAlIIF5ZWp0b0XDvBM2Hbq0S+rFzUDbr85bDFwsdzjoRZdKTyWOfelHv
         1m5H0X4OoaVUyBdRG8lgRBPblLdJfURJ+Iha+eM2ubqjYLCjMigQULEXOLi3BJMxFm+L
         /0pD+BFu6GbyAGl4y/esQ64hsmna1A61viSsUFbJHqonbYOs9OCe8PaJJ6g6a9dV1abn
         QnIw==
X-Gm-Message-State: AOAM530+fKDbDc2oxURuGXcldO2OHsKkhCQjwO/JShl/7f4Hw+io0hZD
        2lapUgdEtD6vFO4AoSisuxc=
X-Google-Smtp-Source: ABdhPJy2O1AFpYh990sNPQv4CD/XFQDSbauwsPZg9MkzniGMGCUNueyPAJgZPdNKJM7mnUEzPZBuKA==
X-Received: by 2002:a05:600c:2182:: with SMTP id e2mr2190555wme.186.1595307428909;
        Mon, 20 Jul 2020 21:57:08 -0700 (PDT)
Received: from [10.230.8.108] ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id i14sm5751539wrc.19.2020.07.20.21.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 21:57:08 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: dsa: Add flag for 802.1AD when adding VLAN for
 dsa switch and port
To:     hongbo.wang@nxp.com, xiaoliang.yang_1@nxp.com,
        allan.nielsen@microchip.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux-devel@linux.nxdi.nxp.com
References: <20200720104119.19146-1-hongbo.wang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3c41dab1-307c-51f3-9d39-a164e8ffcdee@gmail.com>
Date:   Mon, 20 Jul 2020 21:57:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720104119.19146-1-hongbo.wang@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/2020 3:41 AM, hongbo.wang@nxp.com wrote:
> From: "hongbo.wang" <hongbo.wang@nxp.com>
> 
> the following command can be supported:
> ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100

You should probably include the switch driver that is going to be
benefiting from doing these changes in the patch series, provide a cover
letter when sending more than one patch, and also combine both the add
and delete parts.

Since you already have visibility into proto, it may not be necessary at
all for now to define a BRIDGE_VLAN_INFO_8021AD bit in order to pass
that flag down to DSA for programming the VLAN, just pass proto to
dsa_port_vid_add() or a boolean flag which indicates whether this is the
customer or service tag that you are trying to program?
-- 
Florian
