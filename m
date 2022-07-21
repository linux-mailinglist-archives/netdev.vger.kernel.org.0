Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115E857C509
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 09:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiGUHJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 03:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiGUHJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 03:09:14 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4045E7B346
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:09:13 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bv24so921600wrb.3
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=VE0LYpBcSNLxgeKI7cPWq0L3IMO+8/VrqV7u3JYjwXE=;
        b=eK/pGzO2n6WNLTNZO3Wd0ggPr4sppqc2TD1nUpb+tDhAms8nFEZmQmVFrA8jRCR0P5
         RQCYcp5aPDhe4Ekv+Lv8FD11jDbxoRwd05zIYzhlt7yLNrV+/NhG9E3yE8RJHB/bxjnM
         4E/StMXj5w3VQx90jWR2MAhjCT0foKvDnbKnDqIpWbXqto5ydoWY2r1OK49Zvi/DcjgA
         iwNo+ZBB+irKddepVl6RDPPWQQgFki1PFY48YaB5vLMSIhBRgd2F4/f100YkJPdWl7rl
         y1IGSd16N8ZPpZJFK5k08dE8pzL+KpTAY5apyN4946Tp755UiGjLWZ5HSYM7EH7AXT7q
         6PxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=VE0LYpBcSNLxgeKI7cPWq0L3IMO+8/VrqV7u3JYjwXE=;
        b=Ncg9JJvHzi1NeQ+M1cniJqaxEyINAJpFFEj5fE5TesffAeLQIFepEmSPIxE+RkfT2M
         KdJmBrTlMuXjXp++L+05W0nHPX1edaM0gVi7zIVfTb2Wpbt3E+0/DGUp3+DYUJmnpht/
         LUFLnX3CvwDIuE1fRMA2AV0u/dWQN9pYpqGLKFBY4aHwAWFwVlSV22EKqQpiLKmvfGsF
         MD14Zs743pp8AegjfS834uQ7AvbaosCc9KV+JoAbt8o22hl/mHx2auRYHmpdzzA7QfvM
         EjctJct82pVnXSBHED+H1nGg4zKrICFO003Z/oDH0fpFxihfmgS5g0VSve0/fj1PrZPt
         YXEg==
X-Gm-Message-State: AJIora80H1Ku0DW1wIBQswrqJ25uqx5yXal7vgWAY4gTZkUJsvPurVIv
        NEVxuD/UghQNCkCzzGrb/s313w==
X-Google-Smtp-Source: AGRyM1vpOKAfATUcM8qlCM2ouUnThntzP+VxAoH0+K3O4DTe/+n6mZSxk9Ee/fycS5xGUIXpJpfSxQ==
X-Received: by 2002:a5d:4c4d:0:b0:21d:866e:4739 with SMTP id n13-20020a5d4c4d000000b0021d866e4739mr32190232wrt.147.1658387351367;
        Thu, 21 Jul 2022 00:09:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:956c:3203:b371:1705? ([2a01:e0a:b41:c160:956c:3203:b371:1705])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b003a30af0ec83sm2665435wmq.25.2022.07.21.00.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 00:09:10 -0700 (PDT)
Message-ID: <5128cc99-121c-843d-8a65-a930bfb6fa79@6wind.com>
Date:   Thu, 21 Jul 2022 09:09:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 net-next] net: ipv6: avoid accepting values greater
 than 2 for accept_untracked_na
Content-Language: en-US
To:     Jaehee Park <jhpark1013@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com
References: <20220720183632.376138-1-jhpark1013@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220720183632.376138-1-jhpark1013@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 20/07/2022 à 20:36, Jaehee Park a écrit :
> The accept_untracked_na sysctl changed from a boolean to an integer
> when a new knob '2' was added. This patch provides a safeguard to avoid
> accepting values that are not defined in the sysctl. When setting a
> value greater than 2, the user will get an 'invalid argument' warning.
> 
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Suggested-by: Roopa Prabhu <roopa@nvidia.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
