Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E087668AE3
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 05:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbjAMEcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 23:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjAMEb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 23:31:29 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0711C13F32
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:30:23 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z4-20020a17090a170400b00226d331390cso23213391pjd.5
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KhDf6P8vyW7BfUp3OCgCLoIDhIMOS/6pCLAWG0Jz5g8=;
        b=POO2QZbqa0xuVPGERSmMKbSRhUxY1WXL5l7ip8t+k7QDMQzHkv4hQZ+Y3kZZep1hao
         ygOApl86Kzhjw7Xm3FnYCWnWu0NymhFHwT7gBq0gHI54Ijxgn8YOpdcPBxDkRIhFFbaK
         DlAc8n8y8B5WImnd7CAv82hM/FRdFe8MJjbjAZ9TCEFyF6UVoVt24rS9BVuvUYDzlqOT
         XzxUI9ThP4+6mhoh4LiRMfW7J5Bag0R9uAH6/QMc3xG2NZEnDNoMZ0nQiPtmrwOsUtCp
         PcwuFxnAh34YxC7saMi7iSa5g9jXzPi9RcXeJEQC6yO8oKBbtxskZvBzRkUCElIwbuXq
         0TVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KhDf6P8vyW7BfUp3OCgCLoIDhIMOS/6pCLAWG0Jz5g8=;
        b=xaxwlMJ0eXdDatozSCCPIfHKbygUzeaXwEVDeB7xYUl+Tzudf25UHYDa9OpLPHSS4C
         cjW/KQ5JsMClUgEPhpiHDWXRLweOCNc65+ARx5ouiDcKn1dx9EWQwBIjcj7GjMhi4HX9
         0cnm0CF489DbLeh00NXBpApZ2Su1gKgGE+WakA5TxXI91PVakwggF0f3emnHQgemMdx4
         hsaLxh90rXus4Rr24//wQpBSsMjWrQk8gQICs28h9rabTN1/DWPAOR0Te8GUEwaBXXdb
         2IhZasZYAIWca7kBeKceNzJ4Xn6bzaTA3cV0nwPjZsG3IWk8ZANx80yTSX+nDC+QWGrt
         5yUg==
X-Gm-Message-State: AFqh2krFVkpe1X7MZn295o6h6s4N0N/Z6PYB7m1BRGtTgnHiZypJ+R9+
        kfFhhHL70smt4l/hRLsXR06wlo9ag0cpehP806I=
X-Google-Smtp-Source: AMrXdXsKV/+eDyNvW19t3/GcfblZodwWjFiSL8PajYfdoXLP49FFBA6+5wn1omS1vu3xUMEf4/Q3aw==
X-Received: by 2002:a17:90a:5d13:b0:220:9794:249c with SMTP id s19-20020a17090a5d1300b002209794249cmr81893480pji.47.1673584222497;
        Thu, 12 Jan 2023 20:30:22 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090a684700b002260c751b00sm1946791pjm.23.2023.01.12.20.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 20:30:21 -0800 (PST)
Date:   Thu, 12 Jan 2023 20:30:19 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Message-ID: <20230112203019.738d9744@hermes.local>
In-Reply-To: <20230113034617.2767057-2-liuhangbin@gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
        <20230113034617.2767057-1-liuhangbin@gmail.com>
        <20230113034617.2767057-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023 11:46:17 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> 	if (tb[TCA_EXT_WARN_MSG]) {
> +		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
> +		print_nl();
> +	}
> +

Errors should go to stderr, and not to stdout. And no JSON support please.
