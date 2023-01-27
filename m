Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C29E67EEE7
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjA0T5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjA0T5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:57:03 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5608BB9C;
        Fri, 27 Jan 2023 11:54:59 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso5716217pjp.3;
        Fri, 27 Jan 2023 11:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yz6kQ1IpYKt4VfifN60MhcNWON+aHdItmmwRWsxHFY0=;
        b=KAmCN824S8+SoOwjm61Gy41fzUeMcDnfEjJEl15OMScNiKP10RsYwTdtorVkfzeoJp
         IeKsjfnKUVZYUYVzWMa5lqmV25H2UfIXcgg8PYkBwy9VdqFva/ZSc+btymLAL1VOB1x0
         PYKpYKy3Jdr0U/7PV1YcJjPktVsujB4X9Tvq6Pwhn1ucSbJmv1E8umm6Nzk17WLadK/H
         1ArHv1yWfB8TWZpuUMCi8UN0Be/Wq6odwQYbXtJsx1N/XfW/p80i9EykjKJbt/pDp4F3
         Uk3s2ag11JIP7Dj+KIHZCrGcujC9wg+DQ9nPqPvGVUDLs8t9EcmReCGAiiA+IY1aurrn
         0y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yz6kQ1IpYKt4VfifN60MhcNWON+aHdItmmwRWsxHFY0=;
        b=Y6Q8enws6r3mSeiRYre7YCDx+Buj0y+8gm7jqKgX7OqqCKnWfO0nqHGsnvjJQ1CPmj
         aM+BOMDgbdo1ViVGpYLkEe2kAIhM9Ax7Blwp/OXwkHXqV87fDhDDdjOpNbSnwFZ1JNvH
         E1DLeM+oLyBBpogxSXd5hg85ObxKZopun7VcJQoRHZDj1xNbMwk5i6sFsMwofGiAF+dW
         8++gyW0QfP4GVHvs6FktBGgJQtn707RWf7xFL+BNc8uBECV/QIOJ3SLSapUllqTGsZV2
         7xqVP4swy1TRztsPkpvfDvgrFKEL+Phun+7IMVVgsG8dZKMslCnVnKeTDm27yAMWFKV4
         Vtaw==
X-Gm-Message-State: AO0yUKUoqWIReuWv8CzRHvC6S+xtH0xEuwW8a2aJEKiNdY6BncN5VVi7
        3n/KyeZHafItiqRRp9NRSsE=
X-Google-Smtp-Source: AK7set+yDRy+RHBZlNumbI9FYNG1ud+od03i3c45xIx1oQ95c86vvLN9+HGblLXlxotzmquwqEMumg==
X-Received: by 2002:a17:90b:17ca:b0:22c:4693:ca93 with SMTP id me10-20020a17090b17ca00b0022c4693ca93mr4267064pjb.20.1674849241331;
        Fri, 27 Jan 2023 11:54:01 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bb16-20020a17090b009000b0020dc318a43esm3101242pjb.25.2023.01.27.11.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:54:00 -0800 (PST)
Message-ID: <44004691-4f1f-a810-b499-9e447f1e0ff0@gmail.com>
Date:   Fri, 27 Jan 2023 11:53:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 13/13] mfd: ocelot: add external ocelot switch
 control
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-14-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-14-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 11:35 AM, Colin Foster wrote:
> Utilize the existing ocelot MFD interface to add switch functionality to
> the Microsemi VSC7512 chip.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Acked-for-MFD-by: Lee Jones <lee@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
