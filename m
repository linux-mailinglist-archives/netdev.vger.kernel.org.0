Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F1C4ACF36
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346173AbiBHCxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346159AbiBHCxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:53:33 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C54AC043180;
        Mon,  7 Feb 2022 18:53:33 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w1so3118818plb.6;
        Mon, 07 Feb 2022 18:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TvU18owe9ZWd1cq4uocLqjER98f6qQtBka56T9zgFZg=;
        b=VRBlBOWvNBDobE1O+I3hV27jvLAwdGD+FpB0WoVMzR2JAwlOzwzPXfvl1Hp1CQcgWe
         670Q1G9t7CccWognR6rfo7DuCEwFUbO4KNWWD9rjq/71kewgDotcpOgaaHbaWz2DxNrF
         jvq3cX7H+LOVLAqQLMo52eYpBk+MHeRTI1kB40rcz9/pv9se7xiBl+1bVb3sXvGPNuby
         Y+6ySan/gnLAfKIrnc1QjBaFDSb7vg/8PTFfVIVeJW4K5Zos3f14uGXw9FEMc29fFEzA
         uxkO7odJsO6Mc0I/PZMn+AUZLQ/cq2rW/LyJTv2ht/wPzvftG4QK+B9CJToYLNCpLnpQ
         mbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TvU18owe9ZWd1cq4uocLqjER98f6qQtBka56T9zgFZg=;
        b=SAVlzQyvvB374kfXuxA1ks+jd+XEelpkUCbCdEp3mJJy3qtZ0QVBotWVrccLTTTjy9
         rgTbhH6PQmyZ1qRJgSd/VVFN/kcyrR5+dGXNY0G3XNWlsX7rCz8wVK0Z/RPz4mV8qYNs
         tTZWIbZCiCT+zbDnAqYsYTnrOfNX63eD6hCdUzyuF68bGmmJw5K4/o3WKK8TeKyvSjmW
         P5aqXNGDxQFebVVamoPkW0h3dF3KWEvQk0WiHVPds95vosc1wOWqtE3ZsnfDqSGLt4gG
         iQQC0T54UFSYMXxEkkpf2IxZy8BTGahNZMMzI2sfRNTnhyDMNwd0iGeoU/EoBIfUCi05
         pFyA==
X-Gm-Message-State: AOAM530AGb9wYQP9nDMpDUa4A32R48QGncfJa4dKtVD9xybV7b0K2o6h
        3lwQd0b3Kvp77QvU7oGb7RI=
X-Google-Smtp-Source: ABdhPJw57qVsWNvchY2NA172jphZHWpialbUdEBVwTYkWhG6CJ/QKVRJ5vbF8VEUM0a/xMygZg6EVQ==
X-Received: by 2002:a17:90b:3e8e:: with SMTP id rj14mr2090220pjb.38.1644288812562;
        Mon, 07 Feb 2022 18:53:32 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e20sm12966667pfn.4.2022.02.07.18.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:53:31 -0800 (PST)
Message-ID: <6b895ac5-2d78-23d8-fa2b-9184ed0c9ca6@gmail.com>
Date:   Mon, 7 Feb 2022 18:53:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next 02/10] net: dsa: move mib->cnt_ptr reset code
 to ksz_common.c
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-3-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207172204.589190-3-prasanna.vengateshan@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 9:21 AM, Prasanna Vengateshan wrote:
> mib->cnt_ptr resetting is handled in multiple places as part of
> port_init_cnt(). Hence moved mib->cnt_ptr code to ksz common layer
> and removed from individual product files.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
