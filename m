Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3383A56647D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 10:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiGEHyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiGEHyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:54:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9025F13DC4
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657007648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tufRtQKbTo3rS0btL+UYqas1bVXMYGvWTAIeL1ApdqA=;
        b=SZGpCnN1YTi60+dwW5RsEDnOouIceBTK1iqb/VYQUJgWtvBfE/+A8JSwkeRMxrgFSr8Ncu
        57NjelqlcWbPlYOXob8xXAzmEkGi/S4LRH1fPPco6DhL+OOn5qmFC0mQlJHICcq02hLlH0
        oYgfZ8xG61d27wbpBwl5Arg8hDz3Qc4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-3HDbyvWEOJSSBcB64-AP0g-1; Tue, 05 Jul 2022 03:54:07 -0400
X-MC-Unique: 3HDbyvWEOJSSBcB64-AP0g-1
Received: by mail-wm1-f71.google.com with SMTP id p6-20020a05600c358600b003a0483b3c2eso6428700wmq.3
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 00:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tufRtQKbTo3rS0btL+UYqas1bVXMYGvWTAIeL1ApdqA=;
        b=wHvaW95jsCaVIglamqMMrIkWuevMQq9NuKPN4c/DCoaza6ehkONzLoc3KFs0n9kzYo
         0E1PNTDr3nULgXgDqcOTAdBR5CiTA1F9dqNUPycEKS18uBfiwfxvJSl+oRAaUtjP2vz/
         i9Bsbh992OY5IwY8PxjC8IxhFBHMoHt3rT6AijEGQ6mACulJyPpOmexCqyPwZSyU0Dnd
         O5+6UomCA527REJigDGOvqeYydGyW/7AGodLgH7MhIlWYnk7MNjvmJnZ7a3m1Z9eigZs
         W3zHH8Zac+G4W+tcbgDlGSBLnVt9j+Z2UKJaW1LgrP3Gis07ZaSGZ4N3dYbJp9WHwiwe
         j1sQ==
X-Gm-Message-State: AJIora9+eChGXCbi4ekH+IQL1MbFHu+2aXoEETv5sUx7+ouqpGfxHqQ+
        jg7ehcIz0hcqRxICIMzca8sr19TR5PVGTWrNn8A+2Ckt9Y2IJYNoI7oLJNEAHIySr8by4/+KkJW
        stMihrNevp3JphT+b
X-Received: by 2002:a05:6000:993:b0:21b:8f16:5b3f with SMTP id by19-20020a056000099300b0021b8f165b3fmr28827111wrb.628.1657007646234;
        Tue, 05 Jul 2022 00:54:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uNMlOXcr9psHUwbnyN7RAF8PNIACsY7C7zjQujYBMkhBpyM+8/uGCocrkXAop97RfUceZQLg==
X-Received: by 2002:a05:6000:993:b0:21b:8f16:5b3f with SMTP id by19-20020a056000099300b0021b8f165b3fmr28827086wrb.628.1657007646005;
        Tue, 05 Jul 2022 00:54:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id t5-20020a1c4605000000b0039db31f6372sm18361871wma.2.2022.07.05.00.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 00:54:05 -0700 (PDT)
Message-ID: <cf2b6d442c7e066ddb404f0e688dd43497cf93d0.camel@redhat.com>
Subject: Re: [net-next v4 4/4] selftests: seg6: add selftest for SRv6
 H.L2Encaps.Red behavior
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Date:   Tue, 05 Jul 2022 09:54:04 +0200
In-Reply-To: <20220701150152.24103-5-andrea.mayer@uniroma2.it>
References: <20220701150152.24103-1-andrea.mayer@uniroma2.it>
         <20220701150152.24103-5-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-01 at 17:01 +0200, Andrea Mayer wrote:
> This selftest is designed for testing the H.L2Encaps.Red behavior. It
> instantiates a virtual network composed of several nodes: hosts and SRv6
> routers. Each node is realized using a network namespace that is
> properly interconnected to others through veth pairs.
> The test considers SRv6 routers implementing a L2 VPN leveraged by hosts
> for communicating with each other. Such routers make use of the SRv6
> H.L2Encaps.Red behavior for applying SRv6 policies to L2 traffic coming
> from hosts.
> 
> The correct execution of the behavior is verified through reachability
> tests carried out between hosts belonging to the same VPN.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>


It looks like the same remarks I made on the previous patch apply here,
too.

Cheers,

Paolo

