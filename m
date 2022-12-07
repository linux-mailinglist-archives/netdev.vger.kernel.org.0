Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A326457E2
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLGKbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLGKbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:31:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A93A7
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670408991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jbx620gLeOSel9BhXLWySiUXyAHwun+ZwloNL3W64Q0=;
        b=Y5l3w6yb/IAErBLDHyA6PHat9XorLaiW/rwM2G03tVl4Sktpv2ejqwX5WDyiVVY1P/noyI
        d8/L8UdhFTU/su97NyN4mXNPqNWd6GISQa/lvOJl6jgPcubiobVOc3MD8h5QntINQC9LhU
        3c3pNEp098XvAPeHfPLVwNOW6tWidhM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-NOPUWI4UOiSqneQwEftyKg-1; Wed, 07 Dec 2022 05:29:50 -0500
X-MC-Unique: NOPUWI4UOiSqneQwEftyKg-1
Received: by mail-wm1-f70.google.com with SMTP id n8-20020a05600c294800b003d1cc68889dso440870wmd.7
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 02:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jbx620gLeOSel9BhXLWySiUXyAHwun+ZwloNL3W64Q0=;
        b=fLtmr/meQBxJyXA0JMCAcmi6JW4msKkP/pTEzFFARpACA7rpSPzuBTMLYBY6l+NzpG
         rPh3musTJlSyGpv2H8oqenlHdKBJDZhFGMDcsvPNSsxgntCgw9LXJ5qVQ3dYgYP8leug
         sPdMyv6z2G1RaCp3ijAjBSPo8pPHJUXniYFayIQBBGJ7xoSLTCwaJZivcX3Z+8CS44VV
         Pob/kWhpUsKsKZ1C2019aWo3M13Q9jZNKhvf77j+GK05bWB9+7zIgH1eFqg/gZK+zd0p
         WyUuDNlsqKHec1CuR6aBJCNrgsY+Sp5mcEt973mlsd43Vbi1H/R2dAj5SbnzNDKQFaUa
         bdCg==
X-Gm-Message-State: ANoB5pkGia+PQ//52UAlUcdCzE+D2CHPw7XXZnTJbCm11SK/Y9azCh2B
        GCbM3uZ8OP0era2l90DXWu7dL8P9+o2NY5Me3oAmY6q2o6kRn3wcL2vn3ICyWJQI7sOn4TPbxrG
        jvkbVyT1ppeDVQrMh
X-Received: by 2002:a5d:4143:0:b0:242:1551:9759 with SMTP id c3-20020a5d4143000000b0024215519759mr27557048wrq.476.1670408988824;
        Wed, 07 Dec 2022 02:29:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7w3De6nwn9QwmUklcg5FgZg0lboaZShQwv0tgeak2w13scTOZtUPKiMr8T18C4Si+fN9qhiA==
X-Received: by 2002:a5d:4143:0:b0:242:1551:9759 with SMTP id c3-20020a5d4143000000b0024215519759mr27557033wrq.476.1670408988586;
        Wed, 07 Dec 2022 02:29:48 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id i10-20020a1c540a000000b003d1f2c3e571sm1179006wmb.33.2022.12.07.02.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:29:48 -0800 (PST)
Message-ID: <21c752a196bae3977cc0f91182b6ae9cef9ed532.camel@redhat.com>
Subject: Re: [PATCH net-next 4/6] tsnep: Prepare RX buffer for XDP support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Date:   Wed, 07 Dec 2022 11:29:46 +0100
In-Reply-To: <20221203215416.13465-5-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
         <20221203215416.13465-5-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-12-03 at 22:54 +0100, Gerhard Engleder wrote:
> @@ -808,6 +809,16 @@ static void tsnep_tx_close(struct tsnep_tx *tx)
>  	tsnep_tx_ring_cleanup(tx);
>  }
>  
> +static inline unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
> +{
> +	struct tsnep_adapter *adapter = rx->adapter;
> +
> +	if (tsnep_xdp_is_enabled(adapter))
> +		return XDP_PACKET_HEADROOM;
> +
> +	return TSNEP_SKB_PAD;
> +}

please, no 'inline' in .c files, thanks!

Paolo

