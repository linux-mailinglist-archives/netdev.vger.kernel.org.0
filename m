Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7467A2711C9
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgITCkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:40:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE13C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:40:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t7so5352947pjd.3
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c+SreByrs7jnO0XOVrgO0Z0vt6gNP7bnrZUXsfndP+4=;
        b=jZogF0cHoQoy8dedmYD7TgLQ+Zv0Fof8YlxvM0qu14kdp9VnLj7V6ODZioaxfUJv7G
         TT4+XC6deVlq5DC+AGhK/ZV89PErHsqIEeLl649n2GETVJGEfeGbhs+6iJfZRv35IGGO
         eEl1jXlpwpaQ2RLXaLeOzAuy2eklHr7+QUuAGOXGATlxH3tg8W6dCw8YPE6Vo/YevvRP
         ZgWDD1D0WwwodjmrWADXlG5fXukHG3Laz1FFGgfesqQ88/yAMUXagtxqOhtKvgMGF0pk
         XjHisv8912lPosq9lWv6PvA5jcqvGhDuoYa/vGP5NrR9razdUbjJZIgOX+eEs7vFHcyu
         wkFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+SreByrs7jnO0XOVrgO0Z0vt6gNP7bnrZUXsfndP+4=;
        b=kngglBv846dyKQ7VKrfOoF6NFQNfWjfpNNw+yNlZDoAXPk23S1b4a3MoRWZKFwcV2p
         c8DylFgFQI+iAs5tDZ6OORChiutcKsUPIxqY3uVNd0xDrzXaTOkY9ATMZ+Ui2/XbKTXe
         rDYsdib8kSC8j5kQ+VefQVqTGc44W+q6SmfRxH5uY82l4+6HWBOfCFa7HtfgOQNo77vR
         WJK6biIR4BlhF1SHVIgdFuvMFLYWS4ZKOryJpwVAs3qoAybohs/uXIx2YxBe2VeLywR/
         VDaslF24N76krElmO4yKMobDTCB/m4BNHPFNIxpMju34Ar1fg4amJ+CkQES/WNkLZa94
         aZRQ==
X-Gm-Message-State: AOAM530jXnlA65tbBXBnR0KYjgUhmipHdKHnO0CY2Q7NQG1Evv9DILhW
        oLvD74gRgySKp48m2DA466M=
X-Google-Smtp-Source: ABdhPJzglg0qE0qXVqQPzpYlSYKLEFngMmyxJuACYHulvHez9gVVInOCLZaEfBghIqsJjMIwiyTn4A==
X-Received: by 2002:a17:902:b682:b029:d2:4ca:281e with SMTP id c2-20020a170902b682b02900d204ca281emr11576439pls.13.1600569624729;
        Sat, 19 Sep 2020 19:40:24 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id mp3sm6758783pjb.33.2020.09.19.19.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:40:23 -0700 (PDT)
Subject: Re: [RFC PATCH 6/9] net: dsa: allow 8021q uppers while the bridge has
 vlan_filtering=0
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f9dd7bac-6939-0161-b00f-493ec8ddacc9@gmail.com>
Date:   Sat, 19 Sep 2020 19:40:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> When the bridge has VLAN awareness disabled there isn't any duplication
> of functionality, since the bridge does not process VLAN. Don't deny
> adding 8021q uppers to DSA switch ports in that case. The switch is
> supposed to simply pass traffic leaving the VLAN tag as-is, and the
> stack will happily strip the VLAN tag for all 8021q uppers that exist.
> 
> We need to ensure that there are no 8021q uppers when the user attempts
> to enable bridge vlan_filtering.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
