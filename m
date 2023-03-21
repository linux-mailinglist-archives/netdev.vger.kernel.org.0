Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C7D6C3C37
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCUUuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCUUuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:50:54 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AF0E3B8;
        Tue, 21 Mar 2023 13:50:53 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 31so2699378qvc.1;
        Tue, 21 Mar 2023 13:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431853;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YqkNWWpGsCv886LAxLON5Ak8M4spZwSJ4mLLYdG8e4c=;
        b=dQaqaYFYhOT+adxztuCKCzgHPs22u0jGKyiJnWk5XMpUlCj8vCCruML4u3X4BkIMFp
         SMw8w+w1GLJg79ubUWuyl388xwV3gu/hX1Qsc4KmN07NcH5WZPG1muIYaRI2gzKcdFNZ
         WXgORn7TTJaF+51B+nxgBjg2F1loph+5N/QoukJxBpn3Lyz85C2s5Cs/Y+GVQlrqwhnO
         6Girb6u02hJsn8nPWGUBFMjt3kZangfebA6/tEJA1PLmTHJ3/EDKA+FtdpTHaUV6Fvnj
         wLQJ3pT+ESrYpJ25TPHL6L1rz+ObcGoE0oV694DKMf8/x4gVZecf/JGrY9cnipQ4cuoa
         9iuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431853;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YqkNWWpGsCv886LAxLON5Ak8M4spZwSJ4mLLYdG8e4c=;
        b=e39kC0mfDz8P5HVqZGXm+zdkYYf/wUNZNbGczbqd97jUeOvh5mOheFNGcue68KGRB3
         V9V1PUVzyEt5Ow/4IJEUanMGmjGyggpuU21wBqCg0pPtZDXIkCDl6DUbpmH7F+upr2gZ
         EN2gHmuctNOMT4dWPd+kKO9a0NxFgppvq5VeqO8x5/wygSiC6vdnVocDHXdhVKhVBCcQ
         LqjbyuRlHnAB4pnucli95wxNOaHTQqRDEloBdoBrT16KPT2gshrM3EcNiHpmeBK1AxVD
         7tKBY0ZSfKbmNZLLW4zu+fXwft60jO+3UYYU4eIjj1a+nZUdkG818NFUeMxiL5omjo+b
         XchQ==
X-Gm-Message-State: AO0yUKWkECsscXdgGr0WrBWy5lZCTjCt6MUjUBFoNrui6eO8AT4P2Gc+
        up9ZRv1Hcv/k0dT3WQwzaaA=
X-Google-Smtp-Source: AK7set/y+BVW09RqrnAdKpFecwOIWZFiQTR1+oIx4AxRnQYKmzVn51M3gro7Hr1jOQg+dYXSjskVjw==
X-Received: by 2002:a05:6214:19e1:b0:5aa:d98a:8ace with SMTP id q1-20020a05621419e100b005aad98a8acemr2207320qvc.19.1679431852888;
        Tue, 21 Mar 2023 13:50:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a4-20020ae9e804000000b007467f8b76f0sm5469353qkg.41.2023.03.21.13.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 13:50:52 -0700 (PDT)
Message-ID: <3217ce9f-1069-d63a-032c-9eeed92d896e@gmail.com>
Date:   Tue, 21 Mar 2023 13:50:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        andrew@lunn.ch, jonas.gorski@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230317120815.321871-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230317120815.321871-1-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 05:08, Álvaro Fernández Rojas wrote:
> When BCM63xx internal switches are connected to switches with a 4-byte
> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
> based on its PVID (which is likely 0).
> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
> tag is properly processed. The next step would to decode the corresponding
> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
> 6-byte tag and the 4-byte tag handling fails.
> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
> tag before passing it to the 4-byte tag decoding.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

