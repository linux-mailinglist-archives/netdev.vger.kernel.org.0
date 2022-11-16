Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC9F62C799
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbiKPS0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiKPS0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:26:50 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396472A415;
        Wed, 16 Nov 2022 10:26:48 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id d7so9847186qkk.3;
        Wed, 16 Nov 2022 10:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J6IVpnek7jp7RQNs0vIif8yhh7QCajs41fZS8TKx6p0=;
        b=h1qkaXFxcj98WnQoGy/PtLTyHKGmkvuMbnDfgO5LBZfcK0V831Al4rsNV3cGUNNLrY
         WGUAVyJEckfwatgwNiwuAcVIjSLufaTfSe14kj5G/QN4zlXUYVmBkJfPQgz+7VE0/mVf
         2Z8QYszEBNZa5kS+o8tpcRPTs1Qa0wgtxT9g0Ke4aR6CM/3PoWNelOqZ1kF9XqfJeW6e
         7zj/2gQcIDUR4gtTF/I1MbVxGIH9iap1yRfoh+FV9ySicHqPIJD3dEruBWQDBLFE1BwS
         S/wXPsTZlWw3VvIt+3me5p7VO5ZxwhHK3XDMrVuCtLb1gti16n7jXE+zyGjwVYq5p+Pu
         8utA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J6IVpnek7jp7RQNs0vIif8yhh7QCajs41fZS8TKx6p0=;
        b=h/O3/X1SzhAAT5BSnUz0Rw962bj/wpv5v9ezfKwxtQDuil5xoJq77WpTJdJLzx8HcI
         5H1SI/Iwcg5DnS+g14HB6Ptjh4DevTC9URyf7JUL/wG/FCgFvtLhpMYwhmpcezajN5z7
         LeMdEj16dZ2pvOwfujTvAZWGyi8wztnXHSq8/oQk2wKjlCfXVesE40MTDirxcS+ffdjz
         yI43Ir665q6wybQNTSpxpTY+skMr9gIlxyJkjghaAAYDfQkKWI65GKQGi4MargoKsb5M
         yStjz6BG1pUeLhp/bxepyvtrIELjaOoIkpQiHy31sTaUsUI2yIFJGQvJGYlmlPJ/LASf
         jIQQ==
X-Gm-Message-State: ANoB5plX+dxvktfj7veNh57Qi68/LhUxob87yMVfbWcbmU85sYrxP7Lo
        oNaByBbd42p41GkxnZCXQbg=
X-Google-Smtp-Source: AA0mqf53yxUvhGGS5Xx6pm5ju9mEcwGhd4nEqXg+sOyj8VWQ8fxrID1w4+NG5cvcE8lwWIQ2enh/rg==
X-Received: by 2002:ae9:ed81:0:b0:6fb:9f9c:fb1d with SMTP id c123-20020ae9ed81000000b006fb9f9cfb1dmr7126989qkg.499.1668623207254;
        Wed, 16 Nov 2022 10:26:47 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id cm26-20020a05622a251a00b0039cc82a319asm9126221qtb.76.2022.11.16.10.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 10:26:46 -0800 (PST)
Message-ID: <623b0d5d-98b7-0ef0-6622-69686ea49269@gmail.com>
Date:   Wed, 16 Nov 2022 10:26:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 5/6] net: dsa: tag_mtk: assign per-port queues
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20221116080734.44013-1-nbd@nbd.name>
 <20221116080734.44013-6-nbd@nbd.name>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221116080734.44013-6-nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/2022 12:07 AM, Felix Fietkau wrote:
> Keeps traffic sent to the switch within link speed limits
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
