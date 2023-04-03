Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6381B6D4565
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjDCNNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjDCNNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:13:17 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A672105
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:13:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso19818229wms.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 06:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680527595;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9s0Ceu6X8kD+WqyYPxBVxkLSVlKtr5TDBPKdbvsxrlM=;
        b=Ej6DuNbex6wQy1usWdjs5dqOW6yfMrD+l4j6/o2Fl99sUlIlOsuaKvfWbZTVXmk0zJ
         vaO2QIbLNTLcscjozYp1jXeJEafCWiOaSclZaWWUROUBks39Ic8201laig6RjR8HaJ/v
         qWk3UoUUT6P8+lqza5ULMU/LioPQZ06NN0mVTlkEvRk/KI87yuhh0LaxQ1wGlBn013RG
         ncffCgMt7qesmPyb17JRT8SQfiKM7tchFsOmEBBX8SAelTNwrbvtEE2UGmUBbawpmxv/
         XcPKAZChUg/4LD1b8LGnaiqIQAQwJBgCvrMM0vCr8Vn6WjlWVo7fsiCXLh0nlU6OxQbd
         Y9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680527595;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9s0Ceu6X8kD+WqyYPxBVxkLSVlKtr5TDBPKdbvsxrlM=;
        b=GdzPnDgKe1Yg7uRfMEeGb2e+5/CFhtUAOXlsRbejlbHeUgAZV/3NZhkaf47cB93yTy
         9ix5CR4qeaS/xFI1zIHzXsuZXesN2J4NGH0xITbWEAUw0l5rBagW2FQJgQEJqokj1dIY
         wwqCwrwxtIxhpdVzadudTKoKEBuTWd6d/FKwYMCrX11kXDpERtsb/XgK+/o/2MgDBZVF
         7PRrTihPt3prB59g7IKa4GEkeOXikK5b+sfqmluNEmhgbjL0ct/4rWVdME+Xo9HtlreK
         /+8bsXaI+NLwZDeGe+QNS126Foz+H7CRBBNe6RmoomY6E5VyvaSe+lwyfRsgA+zHrcd7
         dlYw==
X-Gm-Message-State: AAQBX9evpJteQONKmvbhu0Q1yVV/mp+tdrQD3t5Q5FRabsSNU+/W4hBp
        B+SWls9yaMRr3CIV478m2y4=
X-Google-Smtp-Source: AKy350Yg03Vnaeewu/oz5M0I0o0/jv1AupdfGQM+aikrncplH/JFn1AWBOlvqLlSrJtz8M1fWiNogw==
X-Received: by 2002:a05:600c:21c2:b0:3f0:41b3:9256 with SMTP id x2-20020a05600c21c200b003f041b39256mr8567585wmj.10.1680527594662;
        Mon, 03 Apr 2023 06:13:14 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id l24-20020a1c7918000000b003e203681b26sm12041654wme.29.2023.04.03.06.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 06:13:14 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 0/4] sfc: support unicast PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
References: <20230331111404.17256-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <d51dce20-5365-5653-d5af-972132bc40ac@gmail.com>
Date:   Mon, 3 Apr 2023 14:13:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230331111404.17256-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2023 12:14, Íñigo Huguet wrote:
> Unicast PTP was not working with sfc NICs.
> 
> The reason was that these NICs don't timestamp all incoming packets,
> but instead they only timestamp packets of the queues that are selected
> for that. Currently, only one RX queue is configured for timestamp: the
> RX queue of the PTP channel. The packets that are put in the PTP RX
> queue are selected according to firmware filters configured from the
> driver.
> 
> Multicast PTP was already working because the needed filters are known
> in advance, so they're inserted when PTP is enabled. This patches
> add the ability to dynamically add filters for unicast addresses,
> extracted from the TX PTP-event packets.
> 
> Since we don't know in advance how many filters we'll need, some info
> about the filters need to be saved. This will allow to check if a filter
> already exists or if a filter is too old and should be removed.
> 
> Note that the previous point is unnecessary for multicast filters, but
> I've opted to change how they're handled to match the new unicast's
> filters to avoid having duplicate insert/remove_filters functions,
> once for each type of filter.
> 
> Tested: With ptp4l, all combinations of IPv4/IPv6, master/slave and
> unicast/multicast
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
