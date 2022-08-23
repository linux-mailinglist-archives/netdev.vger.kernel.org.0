Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F659CE24
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiHWB4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239413AbiHWB4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:56:09 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFB65A8BE;
        Mon, 22 Aug 2022 18:56:08 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v23so6254898plo.9;
        Mon, 22 Aug 2022 18:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc;
        bh=sGqKXB9CbkDajhR+modCZLtZrOoPOipy+fOk+EXu+eM=;
        b=iGDvHGmkOsCcuKyuz17aYzCxW6Z4YbL3ZvatJ4IupUl/nsvPFKpkZOcWBtjdJmCrKc
         eX0sC8aN61RVYcfxD02r9Am99FG7wrfnaciS/8re/C/nYJ6wGlmAImeitI3zOmTfKejF
         g6NUbw0nHTWLOcuoItc2lzscWGQW7eK+5ZnRDvf3yq30WEPK+Jcyo2RIeMbU/SvFlGLy
         sQqEYNc3m9k9UJbxKNANSvRzHub5NSDXxA3PPJsZoompEk1KQxo+7M8FSctIXnzaTLeH
         nXJNuATNMFVZ2kjLNAUHUStpr3SpA6n62r9oIIGkhEOWqn/zsdudb3PbLy+jjs0iGma2
         0g3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc;
        bh=sGqKXB9CbkDajhR+modCZLtZrOoPOipy+fOk+EXu+eM=;
        b=621niWSUo5ZCxsLcxaxBMlMe4crY2PJ41ZbrZi2vNMmhjIUj2UaCOjTzTIgmNpn12H
         0V+m2px6L01cTbIwj5Xx1ORo3hpRyrp3NIAdOGifsJ4autDJOEMLN+XZ1uzTN69l/oY4
         4IdBHSa/hd9JiM64OY0wSbd0dfI4xUttjXvx3cQ0JUIqi9Ye39CFmRJRYY0LUE7hOF9b
         /jK+BhTyF3aQJemgbnZYl3nenf33SwEIhC4snb4CVkl0buMYSYUeISTjyYcK3ehQeqAt
         mkkVa/+eu9NVI2YRV4BSi/lMJpoOnmPW09N2fhJjog1iECx/iZL2gO3oaeLjwmwii674
         K4gQ==
X-Gm-Message-State: ACgBeo2ZsX66pkRTi5OxYsvw77nUIdk1zAZoBYSlQb7UwyWboSn5O0mz
        vBKIDR+tza3CRCxaFrHCeynvXJcosRs=
X-Google-Smtp-Source: AA6agR68WxNuTAiL4voQsP9GJTi/q8nEdMNL14F0mH38c+d4lapnGtZke8dfRffijmlj2m6+y/v4qg==
X-Received: by 2002:a17:902:8ec7:b0:172:ac9c:4757 with SMTP id x7-20020a1709028ec700b00172ac9c4757mr22347095plo.163.1661219768110;
        Mon, 22 Aug 2022 18:56:08 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t14-20020a63444e000000b0042a06dc9a75sm7789926pgk.13.2022.08.22.18.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 18:56:07 -0700 (PDT)
Message-ID: <630433b7.630a0220.6ca31.e01f@mx.google.com>
X-Google-Original-Message-ID: <20220823015606.GA206719@cgel.zte@gmail.com>
Date:   Tue, 23 Aug 2022 01:56:06 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH 0/2] Namespaceify two sysctls related with route
References: <20220816022522.81772-1-xu.xin16@zte.com.cn>
 <20220817205237.3e701f0b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817205237.3e701f0b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 08:52:37PM -0700, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 02:25:22 +0000 cgel.zte@gmail.com wrote:
> > Different netns has different requirements on the setting of error_cost
> > and error_burst, which are related with limiting the frequency of sending
> > ICMP_DEST_UNREACH packets or outputing error message to dmesg.
> 
> Could you add a bit more detail about why you need this knob per netns?

Yes, I have sent new-version patches which update the commit lot at
https://lore.kernel.org/all/20220822045310.203649-1-xu.xin16@zte.com.cn/

The sysctls of error_cost and error_burst are important knobs to control
the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
containers has requirements on the tuning of error_cost and error_burst,
for host's security, the sysctls should exist per network namespace so
not to bother the host's sysctl setting.

> The code looks fine, no objections there, what I'm confused by is that
> we don't have this knob for IPv6. So is it somehow important enough for
> v4 to be per-ns and yet not important enough to exist at all on v6?
> 

Sorry, but I'm not familiar with IPv6 implementation.

> Could you add Documentation in Documentation/admin-guide/sysctl/net.rst
> while at it, and use READ_ONCE / WRITE_ONCE when accessing the sysctl?
> 

Yes, done.

> Please make sure to CC the relevant maintainers. IP maintainers were
> not CCed here. The get_maintainers script will tell you who to CC,
> please use it.

Fine, done.
