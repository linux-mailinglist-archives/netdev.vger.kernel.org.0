Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A723B556FF1
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346548AbiFWBci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbiFWBch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:32:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193704339C;
        Wed, 22 Jun 2022 18:32:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cv13so14744494pjb.4;
        Wed, 22 Jun 2022 18:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Rizxo4YIgzujeff3i3wJibaet374744wEuNwtRhWUPU=;
        b=bmuqoVyOs9kIVFlZ1bb2/ytvsmaCVCgE/WaGLJOqTUtqwGAFpof+gO+Hdlep3ugTKq
         8uJsP3us+JgCqpmlGy+b2A+5mhHF6HR282W6H8fUf3Fabhl3BRo321QYwuLdH1mW3MEl
         9lAca6H+96IG6mLfqEaOF7DSPyCTND5ALmk1qDkju5efF5x604xA0+OExupLYfmWm/u1
         H+aZHGH8cczvhv5h1300Y7I2TuF3AqpDW7B+1rAeWNz205/wgzrV1aB6ronEEiqIcdOt
         pqgRjcweiq7UmxVz9gNI7LCQ7HWwV4XJfmH5pAJz4mqWyd7ccVdvunssGuQ7QGTbwNTQ
         KwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Rizxo4YIgzujeff3i3wJibaet374744wEuNwtRhWUPU=;
        b=tC9dvC/JB87VkQdwIxGy+ESQg0COgM5GA8JsL8d7YoWw5AgkpGfkG6Dc3e7ao/EEsy
         8E+oXKVThJ/hG3HaCC1EPI9qknIi8gdT/fsQfRluA0BXSCe0lw5mDboyk9nUpVcDXUWm
         t22tkM8s0yI9J0FSQZ04a27rmuRD+GmLx0wa1Zhl/l2DwDt2PPJoQRdFBvFR9+s3ksYC
         +ctP61d+2KN844ceN8xXg+JefjoFUcxzxDYG0kbOPxKLCHKQuUNhDylKNDJW68aWQjGG
         uKmKP7mTPAzPZEk1lsxDCJXzvGqtG6oixxzHm7BWv2OquepAwu+YbTctAG9jfAoTuvDx
         tjlQ==
X-Gm-Message-State: AJIora+UjbjzUhRxRXaKfJCtWKhWnxgVwgGfjoo8y3BsGmewtbMZeUMw
        cEmoVcx7Vg5jlEoSh7I29Bw=
X-Google-Smtp-Source: AGRyM1unsrqEe2CVtMLzBfGaE7XL1ldbhN2npVXYGftEcZRAYRp7crbsIaxQji9rGneJS+MmRKNKrQ==
X-Received: by 2002:a17:90b:4f41:b0:1ed:712:fd80 with SMTP id pj1-20020a17090b4f4100b001ed0712fd80mr688781pjb.224.1655947956594;
        Wed, 22 Jun 2022 18:32:36 -0700 (PDT)
Received: from localhost ([98.97.116.244])
        by smtp.gmail.com with ESMTPSA id m18-20020a639412000000b0040c74f0cdb5sm10031147pge.6.2022.06.22.18.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 18:32:36 -0700 (PDT)
Date:   Wed, 22 Jun 2022 18:32:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jian Shen <shenjian15@huawei.com>, daniel@iogearbox.net,
        shmulik@metanetworks.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Message-ID: <62b3c2b310915_6a3b2208bf@john.notmuch>
In-Reply-To: <20220622135002.8263-1-shenjian15@huawei.com>
References: <20220622135002.8263-1-shenjian15@huawei.com>
Subject: RE: [PATCH net] test_bpf: fix incorrect netdev features
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jian Shen wrote:
> The prototype of .features is netdev_features_t, it should use
> NETIF_F_LLTX and NETIF_F_HW_VLAN_STAG_TX, not NETIF_F_LLTX_BIT
> and NETIF_F_HW_VLAN_STAG_TX_BIT.
> 
> Fixes: cf204a718357 ("test_bpf: Introduce 'gso_linear_no_head_frag' skb_segment test")
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
