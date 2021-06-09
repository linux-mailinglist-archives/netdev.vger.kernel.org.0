Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A133A128C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhFILZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbhFILZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 07:25:44 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A00C061574;
        Wed,  9 Jun 2021 04:23:35 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so4022308wmd.5;
        Wed, 09 Jun 2021 04:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hl0ZlS/jy+ohwp7UBTSA1Y+yafFiV6jTfgi2KCYzcQ8=;
        b=iI9oYwaDV4ODVFV6tDx3Xs+W1u21EiUw0OcZasu9pfTx5QzwGIxbhs4PlxOrmCSGEv
         mchRC8LEgGC9e7VPX/FXEfETwbs7gNHAb+Zs490L/CmTD/b6RSc+dmxk2JVKGsAx1yQE
         01uNgtcDSaXKlL+BsJQCyZ+6eaUmGFlWNCYcpHtCrmUFa/SIbg9iScmLyBMov+OjAOp/
         QFrkM9qHU+ZJpHyXOEqBnh5eNarsZSe4VfOVnKLWra2mCebazVsQkaDCixESUMcknALZ
         AgY0jmBBVct4dicL2gLlXfWsJn44g37eIaQq/UCvdlilxR85glrPJO0cnBfLjCh8S+oJ
         h9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hl0ZlS/jy+ohwp7UBTSA1Y+yafFiV6jTfgi2KCYzcQ8=;
        b=kTuNlnrXuS/wN1VlEo7/ytI8POTmhO38TMuKuJ+s12eQGccn4F+bXS/U2WwggxEIrp
         +Jg8DFsqWDCUgxwfSb6HkAmOGhcxvyLxBLWEQOaqexS7YGTit7aERmNwP5FhSfd9t7V2
         b1KAO6YbVGXjalPosQHR3spkSfBHZmggkb3TQaB4okxTEsuKrRt65GrmZK3wX+9B3vuj
         XILUuMhfoBRsSsx0PndX6tV4ey1BcpNL5GjhtPuuvdTgc9ovzcfApfZO97FQ61cdocB0
         TjMsa04StC6h91JOku9KgnKIQih8LbdE416Hx6U06e4zH1kadFOnAbP44lsQ1Bk6isJx
         sVcQ==
X-Gm-Message-State: AOAM531kRMk1Pge1xYBxP2CbnF8MXdFBY17TWIIJsv+VQ2NLjO2z4ov0
        e0oJ5LgLWTegWB2zmT0ck2L74V3t+rCjYQ==
X-Google-Smtp-Source: ABdhPJxqp8aR45xOonTijKKA+I0mVtkltfR3tyB828cRGq+lHr/6bqjldW8ADyoVMS91XVwBnh7nfw==
X-Received: by 2002:a7b:c106:: with SMTP id w6mr26762890wmi.75.1623237813867;
        Wed, 09 Jun 2021 04:23:33 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id t4sm23787947wru.53.2021.06.09.04.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 04:23:33 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always
 tagged
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210608212204.3978634-1-f.fainelli@gmail.com>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <a2201578-6e65-80ca-d685-97705c298740@gmail.com>
Date:   Wed, 9 Jun 2021 12:23:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210608212204.3978634-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/06/2021 22:22, Florian Fainelli wrote:

> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
> VLANs") forced the CPU port to be always tagged in any VLAN membership.
> This was necessary back then because we did not support Broadcom tags
> for all configurations so the only way to differentiate tagged and
> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
> port into being always tagged.
>
> With most configurations enabling Broadcom tags, especially after
> 8fab459e69ab ("net: dsa: b53: Enable Broadcom tags for 531x5/539x
> families") we do not need to apply this unconditional force tagging of
> the CPU port in all VLANs.
>
> A helper function is introduced to faciliate the encapsulation of the
> specific condition requiring the CPU port to be tagged in all VLANs and
> the dsa_switch_ops::untag_bridge_pvid boolean is moved to when
> dsa_switch_ops::setup is called when we have already determined the
> tagging protocol we will be using.
>
> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Tested-by: Matthew Hagan <mnhagan88@gmail.com>

