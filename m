Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1C8656B6F
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 14:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiL0NrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 08:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiL0NrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 08:47:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D15B863
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 05:47:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o2so7773935pjh.4
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 05:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i7pAa6GrsUMa9aMR3tkmNbY+p2zZDCAQG5QANHco4Hs=;
        b=N2TIZYSVv/smePKAhsiOvYTxPgDB69wMf0p2OBwSSVHkvmWIqbaXM5VXmiG/XoNNoq
         TXuB68OHweM9bgZPxjz1U+HPPPOYzweoko9YTONHTru/HxYw+rpx36eTy//Fgi4p2INB
         sZwSYilto7oU2uEDAi3yD7ydDQCIqajhUq6kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7pAa6GrsUMa9aMR3tkmNbY+p2zZDCAQG5QANHco4Hs=;
        b=izy5cgxWRFYerDmXGqWLK6HMOPDrzdw4tURwahmencXcEOu8etgeyqzyzIHG0CKGtV
         Pwrp3EqVssl/kTaVDIGwbVTAS51tcoyhPTh+5lYrLsbjYcM+Cd+Bmpd/OBldKA4Dxk5d
         LJ+WCz2fQEybG+/yuNjj8pE76SbZf2T/+a9+7fxVU628Mda/8suDpGUfqsXEb8lAq3J6
         T7NX9mjd/BbTRVpcnsFCZ4pF7s0xANFNwnSfvpORhzqJTT5K9nHU4ViC8Z/CPwro+IjX
         4xqmyoB/OwSCDrW+KVp75kPJ/zVcS57+38dghdo+6TrJ0T1SA60fsLI/v911DvL6DYlz
         CzcQ==
X-Gm-Message-State: AFqh2koyx+Lgxuc+wmEya0oN33mHKZBAlAxUNkhyOzV5r8jkNznYAqrC
        wDq7AVJoOleKifGnc+3ZzvXr8g==
X-Google-Smtp-Source: AMrXdXuDCxYhKyLOCt/CIA0l3dS0V6bCKVMSH1IYN3cJG/WKCIcujWestcE/3nUAcR27uHHD8SyDhQ==
X-Received: by 2002:a17:902:e74d:b0:189:6d2f:4bcd with SMTP id p13-20020a170902e74d00b001896d2f4bcdmr30429794plf.0.1672148841140;
        Tue, 27 Dec 2022 05:47:21 -0800 (PST)
Received: from 19b382bb30c4 (lma3293270.lnk.telstra.net. [60.231.90.117])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c20200b00190f5e3bcd9sm9166096pll.23.2022.12.27.05.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 05:47:20 -0800 (PST)
Date:   Tue, 27 Dec 2022 13:47:06 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuniyu@amazon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/4] net/sched: retpoline wrappers for tc
Message-ID: <20221227134706.GA344240@19b382bb30c4>
References: <20221206135513.1904815-1-pctammela@mojatatu.com>
 <20221227083317.GA1025927@82a1e6c4c19b>
 <e527f418-1cfc-df4d-614f-873128bb1368@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e527f418-1cfc-df4d-614f-873128bb1368@mojatatu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 09:24:22AM -0300, Pedro Tammela wrote:
> On 27/12/2022 05:33, Rudi Heitbaum wrote:
> > Hi Pedro,
> > 
> > Compiling kernel 6.2-rc1 fails on x86_64 when CONFIG_NET_CLS or
> > CONFIG_NET_CLS_ACT is not set, when CONFIG_RETPOLINE=y is set.

...

> Hi Rudi,
> 
> Thanks for the report.
> Could you try the following patch?
> 
> diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
> index ceed2fc089ff..d323fffb839a 100644
> --- a/include/net/tc_wrapper.h
> +++ b/include/net/tc_wrapper.h
> @@ -216,6 +216,8 @@ static inline int tc_classify(struct sk_buff *skb, const
> struct tcf_proto *tp,
>         return tp->classify(skb, tp, res);
>  }
> 
> +#endif /* CONFIG_NET_CLS */
> +
>  static inline void tc_wrapper_init(void)
>  {
>  #ifdef CONFIG_X86
> @@ -224,8 +226,6 @@ static inline void tc_wrapper_init(void)
>  #endif
>  }
> 
> -#endif /* CONFIG_NET_CLS */
> -
>  #else
> 
>  #define TC_INDIRECT_SCOPE static

Hi Pedro,

I had to adjust it slightly to apply cleanly.
But works correctly with my .config now.

Thanks
Rudi

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
index ceed2fc089ff..d323fffb839a 100644
--- a/include/net/tc_wrapper.h
+++ b/include/net/tc_wrapper.h
@@ -216,6 +216,8 @@
 	return tp->classify(skb, tp, res);
 }
 
+#endif /* CONFIG_NET_CLS */
+
 static inline void tc_wrapper_init(void)
 {
 #ifdef CONFIG_X86
@@ -224,8 +226,6 @@
 #endif
 }
 
-#endif /* CONFIG_NET_CLS */
-
 #else
 
 #define TC_INDIRECT_SCOPE static
