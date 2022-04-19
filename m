Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FC6506D74
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243793AbiDSNbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243736AbiDSNbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:31:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8550D21E1C;
        Tue, 19 Apr 2022 06:28:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id e62-20020a17090a6fc400b001d2cd8e9b0aso1750331pjk.5;
        Tue, 19 Apr 2022 06:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Gt27EbYhS9qJA9bFo3ES5TQ+M3mPhDrTTHCzoFmARGI=;
        b=TTITMF5ldzsjryyA1haYULWZJcPqXxNnxjg6fUuS4q+E+uNztjSeFm4paslPCdU0jl
         igaZQz3FSbN5pJAn9HDmXgRFlNZHLb7pdQuVaiNzCkYJXMPPsTRvlrURIrhIy4f2Mr61
         maW3029xdqGfPgmZ5lPQqeUuxy+01b5JPdF0imZ5Vtbf781uDccF3xvUaS99bZ7AUCCr
         +5765Eq6OP5kSX1kgpjCdDsWztWt3dv2nBq5DJvkqmCpEeNM+w794/gYgait+tSTggE5
         DyuMiwtz7R0IGqma+H+kPPu6ebQl68B75LB2iXtNSR8TsiBiRqSqAdwDvcr/B+S1S3W2
         TFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Gt27EbYhS9qJA9bFo3ES5TQ+M3mPhDrTTHCzoFmARGI=;
        b=VBEsezcnYj1oKLCX9opKyyddhcottZx5nud5ObYr8VbXwWJS+r++RwKZ9znZg6oFRI
         nOqFpjYUUavXE6mlJTF4rf7c9CW9VS0wXJasOMhYrJBODgssocechRLojiApuFQYzvH2
         ObJooPlqeUzZ+syaJwt+sz1W/yEaTBTNtCHbbglp1cK4/AntRdVLlFcViuum2mUisFpy
         GJLRUkAgDFlQ3CLIMy8majO7qYsfR88DNz8MTL4U6coRjtkGT1z0SZ5ULl0bzLd1mSSu
         wezlp5Gp4+ox8VRkBDjVCYVi81nnGLv8EKJe0qSKVzik3QnfFRnC0bbiKSIQShxjxGXi
         RZJg==
X-Gm-Message-State: AOAM530uSFAb/LU/GxwRk082tF5Ob7wXsqtLUnN+muFGPIhShwE4zRHM
        Cacq7lJaIUWBtzKiX9SohQ0=
X-Google-Smtp-Source: ABdhPJy6cH5/4e6XZZ4pT4pDqRzujdx8zF5e9ofQmq+fjlHAC4ig/75jn3fViJjD1vhmejDhoMsn2g==
X-Received: by 2002:a17:902:8483:b0:158:f833:b7a4 with SMTP id c3-20020a170902848300b00158f833b7a4mr10702309plo.100.1650374938037;
        Tue, 19 Apr 2022 06:28:58 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j16-20020a634a50000000b003a82190a495sm10071714pgl.62.2022.04.19.06.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 06:28:56 -0700 (PDT)
Date:   Tue, 19 Apr 2022 06:28:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add fsleep() in HW Rx timestamp
 checking loop
Message-ID: <20220419132853.GA19386@hoboy.vegasvil.org>
References: <20220413040115.2351987-1-tee.min.tan@intel.com>
 <20220413125915.GA667752@hoboy.vegasvil.org>
 <20220414072934.GA10025@linux.intel.com>
 <20220414104259.0b928249@kernel.org>
 <20220419005220.GA17634@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220419005220.GA17634@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 08:52:20AM +0800, Tan Tee Min wrote:

> I agree that the fsleep(1) (=1us) is a big hammer.
> Thus in order to improve this, I’ve figured out a smaller delay
> time that is enough for the context descriptor to be ready which
> is ndelay(500) (=500ns).

Why isn't the context descriptor ready?

I mean, the frame already belongs to the CPU, right?

Thanks,
Richard
