Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF7B6CB554
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjC1EKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjC1EKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:10:24 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76763118
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:10:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t4so5515788wra.7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679976621;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K6l7NBdUxqXPaUsRBgFYjMV2RN3u207OLmSj0punu04=;
        b=fSpdG+HI7zB+PC49XYkj+evqAVfqwKG95e8s2m+gSVFKhqbqtwNVkK09bazgoEI7xR
         SS5n6Tfs6LE9dt8BGEbRTXiFPTthtF36bI42gvfcIx2Rli4FxuP18g7dDLotlLkIwefC
         vh6vl2eCg8lwhuU0mWtgRO9QIMTmEONZEJGFTW26WFyHZ/NoN9X4KwYT2K+Ge5x3U/5B
         CebRAOxM8o1YKIeVonHil8wCaBEKy1trmdkK4hXeibKKmTW/r5ZGrQt0r4A+T37c2K0/
         XinZYgd0cczNRpsJxMmB0xHN6VwDCL3GnaUDiEW6PR24nhJRwEVShKBBCKsWfKf/Yn10
         Uvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679976621;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K6l7NBdUxqXPaUsRBgFYjMV2RN3u207OLmSj0punu04=;
        b=7yguF0IPNSG6UHi7vFo85bYUZcqI2/DWMUzvX2pyNnmFzBeyv2RBr0e3wXrC/TWs1D
         7HrVVIfDCtaDpoNEhhIM1BNDD89buLLy+UQNzRcmvGR5nUUacgEYXPZvs3FZpTyz1OLd
         CNJenznGTlQCWeFzs3YIZQ8PRA/74DoEcQze58qoa4wOVHDsrAxORKChzN7LBV/z7DQR
         RJyPP3O0dwkOkLlA2iHvTZX+qMnMy6SzEeYsSjqi/RNm0xN3mApjYtftxsMohlSyQD5v
         lbUhgeaRCLEhRnFE+wI/Ps7W7k5IFNRziL9a0gYYuaDMux/mK6GsO/eYlyS853fdVf8h
         ZczQ==
X-Gm-Message-State: AAQBX9d0QWmK1wGjD9ef3SNicgxNPFlXl/u8vFed0PTSld2bk8it/kSl
        ja2HfwKO+xSJ9+Mp/AsgsLI=
X-Google-Smtp-Source: AKy350buTwmcGRLvw3JfE7IAf7QbDNXMOrfAbB65dMLE795V/EqDeYsnL6ZYrXaVIIEe1u0fzkor0A==
X-Received: by 2002:a5d:564c:0:b0:2de:bb7c:ea16 with SMTP id j12-20020a5d564c000000b002debb7cea16mr7236048wrw.37.1679976620729;
        Mon, 27 Mar 2023 21:10:20 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id j1-20020a05600c1c0100b003ee6def283bsm10882802wms.11.2023.03.27.21.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 21:10:20 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 3/4] sfc: support unicast PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
References: <20230327105755.13949-1-ihuguet@redhat.com>
 <20230327105755.13949-4-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <72849de7-1acc-00e0-5e82-3e62ddcd54fd@gmail.com>
Date:   Tue, 28 Mar 2023 05:10:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230327105755.13949-4-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 27/03/2023 11:57, Íñigo Huguet wrote:
> When sending a PTP event packet, add the correct filters that will make
> that future incoming unicast PTP event packets will be timestamped.
> The unicast address for the filter is gotten from the outgoing skb
> before sending it.
> 
> Until now they were not timestamped because only filters that match with
> the PTP multicast addressed were being configured into the NIC for the
> PTP special channel. Packets received through different channels are not
> timestamped, getting "received SYNC without timestamp" error in ptp4l.
> 
> Note that the inserted filters are never removed unless the NIC is stopped
> or reconfigured, so efx_ptp_stop is called. Removal of old filters will
> be handled by the next patch.
> 
> Additionally, cleanup a bit efx_ptp_xmit_skb_mc to use the reverse xmas
> tree convention and remove an unnecessary assignment to rc variable in
> void function.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
