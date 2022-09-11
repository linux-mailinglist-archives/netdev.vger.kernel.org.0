Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22825B4CD5
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 11:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiIKJDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 05:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiIKJDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 05:03:41 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C01A39B88;
        Sun, 11 Sep 2022 02:03:40 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id iw17so5858274plb.0;
        Sun, 11 Sep 2022 02:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date;
        bh=Kr6/Om/0NREnjozpuGQOaVHKHAHxskJmGNV3oyHv3K8=;
        b=msXX4pYXfjyDfjIuaiOnniF6JthsWkmdTST+DH5mh92HWV3HgPnM1O/iQyb6LKfWaV
         fNtwT1sSXt9muX/OE7q5mZMwsFjxf7xTh/rtfJ4CCPRRHonLkdWWOBHG3LPRBYufWL/Z
         HPlBrEIIDhHxcJNgy+6FslrCUO9OWRkEnsKCe0DptNcBWb0wUpGc9yJs4Az1Y0JPiYGv
         X1tlWjbHZlUET+j+F00TyCNmo2imDrcK2UkHq9eLRO+E+4Xb7umTFXXEnX38Kdxm5CfU
         5mvizvX+RtMvBDMKb/sE/mq4zOEBVjr/U0hrglC4ot3mUuxS6S4NZmjgd5l0Tv0PXCRF
         X8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Kr6/Om/0NREnjozpuGQOaVHKHAHxskJmGNV3oyHv3K8=;
        b=WeOtL2iKRV9JXyIr9Cx160cwNMy3/he6MiO2YuU+fz68HgKc1QPKn+no8vyCjHMEqx
         JI9jcmYlNEniXWVzMS293mH8DTu+6pfep6VI6JQrOPmwOeOpHwlGyVczNS5657TM4/Gc
         ktiy8zJ+HSYEYvofB5gGd1DJiLnLi2uvr2RuJI0GO+DFGVM/3LPM2P9IUdvLBN19l1Mw
         He0ECV14HcbhLMKXkm6w+QI+emfSq7u9ighZeMhSi2e/d6ildQq/57B8+BHIjF+BufDW
         8yeMzolCO+YQJJtslg1SZnv7RF+E4hhxAh1d/Y2QWt9qF4qiEeXFecr3xrxoyn9NBkb4
         iVWA==
X-Gm-Message-State: ACgBeo2e5RYqwo/1I+r5jEkN1uQC6sLslg6zWn6PdKrBNSowdTBe5Ncz
        00D0V644aX/y+c+zBKAp0QzATF57xRI=
X-Google-Smtp-Source: AA6agR7N4TxeWC4P/k4VG+pSPItVs/dpsotDSIa5iCQMJNKkdKkJOcf11TKu4P7Q+u7rLPezEzkMBg==
X-Received: by 2002:a17:90b:1bca:b0:1fb:7eaf:8955 with SMTP id oa10-20020a17090b1bca00b001fb7eaf8955mr18622511pjb.37.1662887020055;
        Sun, 11 Sep 2022 02:03:40 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g186-20020a6252c3000000b00541e7922fa0sm1894940pfb.191.2022.09.11.02.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 02:03:38 -0700 (PDT)
Message-ID: <631da46a.620a0220.ebe5b.2b70@mx.google.com>
X-Google-Original-Message-ID: <20220911090336.GA14537@cgel.zte@gmail.com>
Date:   Sun, 11 Sep 2022 09:03:36 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: Re: [PATCH v3 3/3] ipv4: add documentation of two sysctls about icmp
References: <20220830091453.286285-1-xu.xin16@zte.com.cn>
 <20220830091718.286452-1-xu.xin16@zte.com.cn>
 <fd70dbcd-961f-9edd-78e4-23a7ef20187b@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd70dbcd-961f-9edd-78e4-23a7ef20187b@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 12:07:11PM +0200, Nicolas Dichtel wrote:
> 
> Le 30/08/2022 à 11:17, cgel.zte@gmail.com a écrit :
> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > Add the descriptions of the sysctls of error_cost and error_burst in
> > Documentation/networking/ip-sysctl.rst.
> > 
> > Signed-off-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
> > Reviewed-by: Yunkai Zhang (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> Maybe you could resubmit this one alone?
> 

Okay. did.

> 
> Thank you,
> Nicolas
