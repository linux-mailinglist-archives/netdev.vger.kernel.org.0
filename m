Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9748B68C55B
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjBFSFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBFSFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:05:46 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9792193DC;
        Mon,  6 Feb 2023 10:05:45 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c2so13806129qtw.5;
        Mon, 06 Feb 2023 10:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TfHweyQypgT88dcV2bDP1Gsm9WfNuarzKmo0tThjIPw=;
        b=QmIBFvFjPEuuMs7kluLSdEAuJuxt12IW0UIZv2K+BY3Pg7LXI/PdEoitple6kt5q62
         4KNqoC213XLKUmx0UUVFPyOLe5ps/YZqZFOwIlFlq7YlkL+n3yjOD55leHNoDT3ZYxLe
         EhNqeW+hmlbpQLinwTz5ROJY1Z/74Zz6Ba9AdRzaDttETXiYMd/Z38oWojtZb+zRR8Z7
         6B9CC31DAJWyEbryzsA9IkpHB38yEjAzVu2DrBUSEfUo7YJiKNvlBCD3Hg5MUTbWQrll
         JRQnOLi3X9rzVVf4LNP6ROF672RCrLpYO5KSd2nY9xUZxzKGgLDE10VFr2Mwfhy4vFSJ
         SWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TfHweyQypgT88dcV2bDP1Gsm9WfNuarzKmo0tThjIPw=;
        b=yeKXQYivFwEJIFj8W6f7LI9EY41W8SHkMBlXnxM8QMkSZlFd9Cr+rAMOJpyL3bI+Qc
         x6690kqWIDsixRw7BeiHpMZU3jBjw+G5TcKnp8KlzztKsy++pzlHyPC9UHQ4AxiuEFzM
         BIYM8Mmn54TwRIMJmHxZt1f2XTK8gjjoQurMlwT3UyF0rau8mzTPzb84EHSviBIhyOWj
         6Pdu1KiLkDEoqcwU18UQd/Hi2eSXjqXkq9Ry6OEcW660OswLL8C5+x0JovuL6AcmYnxZ
         4bOf3fMv6MPzgRZxahyhPBnvh6xLXIuIxo3aIThZ35WnC7wXYa1DydaLH/gS4RwgamPP
         uB2g==
X-Gm-Message-State: AO0yUKWjOGF8+BleoMOaF+xIUcQFu87beN6sJJGpYsRdTKKVLTn7ziqR
        lUwbLPFcC/GrHuxwd0m2VdU=
X-Google-Smtp-Source: AK7set+JDjyRia7uB1q+yROPDUU/xoNvixXPaC99c+QpibrRazWR6cN0o1/qd+rpqn+zhZ5BBM3Lcg==
X-Received: by 2002:a05:622a:1052:b0:3b6:313a:e27a with SMTP id f18-20020a05622a105200b003b6313ae27amr303395qte.40.1675706744651;
        Mon, 06 Feb 2023 10:05:44 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t66-20020a374645000000b0072862fcbbdcsm803599qka.42.2023.02.06.10.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 10:05:43 -0800 (PST)
Message-ID: <9cf4eb5f-64d8-5e7f-6fa1-39ed08d66e77@gmail.com>
Date:   Mon, 6 Feb 2023 10:05:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
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

On 2/5/23 06:07, Vladimir Oltean wrote:
> Frank reports that in a mt7530 setup where some ports are standalone and
> some are in a VLAN-aware bridge, 8021q uppers of the standalone ports
> lose their VLAN tag on xmit, as seen by the link partner.
> 
> This seems to occur because once the other ports join the VLAN-aware
> bridge, mt7530_port_vlan_filtering() also calls
> mt7530_port_set_vlan_aware(ds, cpu_dp->index), and this affects the way
> that the switch processes the traffic of the standalone port.
> 
> Relevant is the PVC_EG_TAG bit. The MT7530 documentation says about it:
> 
> EG_TAG: Incoming Port Egress Tag VLAN Attribution
> 0: disabled (system default)
> 1: consistent (keep the original ingress tag attribute)
> 
> My interpretation is that this setting applies on the ingress port, and
> "disabled" is basically the normal behavior, where the egress tag format
> of the packet (tagged or untagged) is decided by the VLAN table
> (MT7530_VLAN_EGRESS_UNTAG or MT7530_VLAN_EGRESS_TAG).
> 
> But there is also an option of overriding the system default behavior,
> and for the egress tagging format of packets to be decided not by the
> VLAN table, but simply by copying the ingress tag format (if ingress was
> tagged, egress is tagged; if ingress was untagged, egress is untagged;
> aka "consistent). This is useful in 2 scenarios:
> 
> - VLAN-unaware bridge ports will always encounter a miss in the VLAN
>    table. They should forward a packet as-is, though. So we use
>    "consistent" there. See commit e045124e9399 ("net: dsa: mt7530: fix
>    tagged frames pass-through in VLAN-unaware mode").
> 
> - Traffic injected from the CPU port. The operating system is in god
>    mode; if it wants a packet to exit as VLAN-tagged, it sends it as
>    VLAN-tagged. Otherwise it sends it as VLAN-untagged*.
> 
> *This is true only if we don't consider the bridge TX forwarding offload
> feature, which mt7530 doesn't support.
> 
> So for now, make the CPU port always stay in "consistent" mode to allow
> software VLANs to be forwarded to their egress ports with the VLAN tag
> intact, and not stripped.
> 
> Link: https://lore.kernel.org/netdev/trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36/
> Fixes: e045124e9399 ("net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode")
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

