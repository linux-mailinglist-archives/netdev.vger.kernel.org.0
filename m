Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914E14B0516
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiBJFag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:30:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbiBJFae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:30:34 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390B510C3;
        Wed,  9 Feb 2022 21:30:31 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n23so8328827pfo.1;
        Wed, 09 Feb 2022 21:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=B+k9EBgVJ7SUsUnC8gQS8vNlnkocvufufbWUpKBqPLE=;
        b=dr9tvwGLU56mFo3ILpm21tn1fz4cB71qiGMZaWGScjc3gEle18DntA7k9OEQwyQi8F
         uMd9B1Ke17e4JCWeiMrAksPAIN45s7LxZcetwBfu5E3B2hMnzdlLoe084hb5marhcixz
         N1xgx8fU/MXiMP/rZAC5PT5/cfGhL9qgmPJ1q5r3Pn5FDm/npuG9/WKV/nT6DQKVgcOm
         C26MYlJDF5IzeiKSpVf1ffx/xjrytMQtReROAH14vqx+LNr5xxUXpIiE2X5b+fMJEMG7
         V+s7qaHvVF0BaQ3zRTxCYXcTeX9xkdXRmv45B35JpkCLqeBUDc4nb7FIVoTB+D8xorXK
         s40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B+k9EBgVJ7SUsUnC8gQS8vNlnkocvufufbWUpKBqPLE=;
        b=oiL7kKj4Q8b0MMMrchVgVIm8z1Bs4yKJbJMw+56eYb/TOr5UKxBOj+IcsEUOm5qsAZ
         czNCgEo6GcyFTebmvDHasein407SvNvM0zZUnLFNNqxW5HwunxGjY5Jd+lu/3ZQnvbwf
         yTsOh7LLbPTn1H09OnCDViATTsgaVRXXI9gbp8JXSM4IScndIx32tVzxeTs2HKERLhT/
         Ep2w533r455+COa4JFapywI/nn2EVDX27oOvjaUm54WbUBD72ftq01Ki5WcOl/zxZVK3
         Ac5qi082+q0D0PEvDQUKHTUbBpMpmvO9mPiqGrzNxa7ySe3bgah8AgJuDIlVyulmuZ40
         VRCA==
X-Gm-Message-State: AOAM531oZpUKHHGTy+amw7f8RksvdRZ6tMDhzooewZUHqCajM9GAun2w
        aeFF5Y/sZozW1r9dNGouKk4=
X-Google-Smtp-Source: ABdhPJzgY1dDq98hcIutln2fFZUO/ZyWEdbSTqqZaulNRMM2LF5bUwWoUamjaCDwvFdDqxS9kOCa9g==
X-Received: by 2002:a05:6a00:2451:: with SMTP id d17mr5863302pfj.70.1644471030832;
        Wed, 09 Feb 2022 21:30:30 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id c11sm14910594pgl.92.2022.02.09.21.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 21:30:30 -0800 (PST)
Message-ID: <ac8ba5ec-158d-b6b5-699e-123ecaa575e9@gmail.com>
Date:   Wed, 9 Feb 2022 21:30:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 02/11] net: ping6: support packet timestamping
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
References: <20220210003649.3120861-1-kuba@kernel.org>
 <20220210003649.3120861-3-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220210003649.3120861-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/22 4:36 PM, Jakub Kicinski wrote:
> Nothing prevents the user from requesting timestamping
> on ping6 sockets, yet timestamps are not going to be reported.
> Plumb the flags through.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv6/ping.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

no opinion on the Fixes tag.
