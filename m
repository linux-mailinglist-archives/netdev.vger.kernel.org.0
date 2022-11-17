Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A287762DBEE
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiKQMtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiKQMtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:49:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031EC49082
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668689244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=buqGHDPiQJHf1KNEW0nK5wP2/DH4XboNhmUH3LThJvY=;
        b=eBRA4NPzqVcsLdiz29JpcWZ7k1whHimCiWDz0A2IlhlDTb/MAUGli41n7uu6fVQxwVdFK/
        FA4GmUR7oOpoU0lap2al88sX8xsVFs8n5d0GJjWQnORE017PqyZKMdPH6QT2hmEconwQEh
        6I3MPWHmOBRiDt48y+wHpnwQAmKJHSc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-262-sXEVbhtdPba3qc1Ak_Tlew-1; Thu, 17 Nov 2022 07:47:23 -0500
X-MC-Unique: sXEVbhtdPba3qc1Ak_Tlew-1
Received: by mail-qv1-f72.google.com with SMTP id lb11-20020a056214318b00b004c63b9f91e5so1460194qvb.8
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:47:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=buqGHDPiQJHf1KNEW0nK5wP2/DH4XboNhmUH3LThJvY=;
        b=d7+MVZvEqobq7CMSE/+JiBhlg0dY3sWfF17aMw6GP5qoWOl/iVWyuler1KrNeW9J+F
         GzUTuvT97MroQNrKlo7u4oQyZhLBXxbnXQsTneHYNyyPKRFIOdlbkAUaOvJtbaAVkwh4
         K5TI6aS/yK3ccg22z77iZhEhvDMr59vaeFvsqMDM9VTJjquK82qUfoaccJEnEwhojZ9W
         ULdyvJX3lCf1qOc/uk1CJP2vkvJGX55rW/vyoEEoXOid8C1HOEXLvXXwaTAYTSKY3xG3
         rvDv0GYSr2CXOtSiF7hs3fzmjAz3TVx6vd3oQmSJKyP58JcmEZexHESFwuOt3w3Xz8kT
         cTzg==
X-Gm-Message-State: ANoB5pkQ+rrsJaUdh1OaeHTOEKTo7AsfBhnUAGy7WZ9fBw7QhFc7jC6B
        9UBsounhG7+4V05t4QlHcp1tnPoak7HDO4ior1bSLyfqXEv3HmVVc/mm9Xp5GxaQTj47PMfT0xU
        xHBinMh69RFLIrV6F
X-Received: by 2002:a05:6214:5e03:b0:4c6:8c62:dc26 with SMTP id li3-20020a0562145e0300b004c68c62dc26mr955987qvb.31.1668689242418;
        Thu, 17 Nov 2022 04:47:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6NrRNYLZ0ls6R0kRlwmfiR1dzZc4+V2fXHP+b9MOCSAMSE9sqYH0BM/PWGnjA/EhmMQRECEw==
X-Received: by 2002:a05:6214:5e03:b0:4c6:8c62:dc26 with SMTP id li3-20020a0562145e0300b004c68c62dc26mr955979qvb.31.1668689242181;
        Thu, 17 Nov 2022 04:47:22 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id i11-20020a05620a248b00b006fb3884e10bsm401452qkn.24.2022.11.17.04.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 04:47:21 -0800 (PST)
Message-ID: <e5a89aa3bffe442e7bb5e58af5b5b43d7745995b.camel@redhat.com>
Subject: Re: [PATCH net-next] NFC: nci: Extend virtual NCI deinit test
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dmitry Vyukov <dvyukov@google.com>, bongsu.jeon@samsung.com,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     syzkaller@googlegroups.com, Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 17 Nov 2022 13:47:18 +0100
In-Reply-To: <20221115095941.787250-1-dvyukov@google.com>
References: <20221115095941.787250-1-dvyukov@google.com>
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

On Tue, 2022-11-15 at 10:59 +0100, Dmitry Vyukov wrote:
> Extend the test to check the scenario when NCI core tries to send data
> to already closed device to ensure that nothing bad happens.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  tools/testing/selftests/nci/nci_dev.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
> index 162c41e9bcae8..272958a4ad102 100644
> --- a/tools/testing/selftests/nci/nci_dev.c
> +++ b/tools/testing/selftests/nci/nci_dev.c
> @@ -888,6 +888,16 @@ TEST_F(NCI, deinit)
>  			   &msg);
>  	ASSERT_EQ(rc, 0);
>  	EXPECT_EQ(get_dev_enable_state(&msg), 0);
> +
> +	// Test that operations that normally send packets to the driver
> +	// don't cause issues when the device is already closed.
> +	// Note: the send of NFC_CMD_DEV_UP itself still succeeds it's just
> +	// that the device won't actually be up.
> +	close(self->virtual_nci_fd);
> +	self->virtual_nci_fd = -1;

I think you need to handle correctly negative value of virtual_nci_fd
in FIXTURE_TEARDOWN(NCI), otherwise it should trigger an assert on
pthread_join() - read() operation will fail in virtual_deinit*()

Cheers,

Paolo

