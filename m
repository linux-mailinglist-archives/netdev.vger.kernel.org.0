Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D75BF184
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiITXte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiITXtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:49:33 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF8332B
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:49:30 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u9so9947753ejy.5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=pFN8cihJVHzr5yPjSDML+qWJPiNZrqYBqdqOmDZbjTE=;
        b=UA3jDdquY54HdmL9ZgcdidKpus+QFFJ2hHuK503oAwF6yImZg3zlmFraxos9T7dX49
         rMlNKkKZS9VgcgU6L8vhEsVeM24QnzuzOVPQvTzdTiS81s7pOr10Y8qCd291e6F1puO+
         PZEyuS4YyQSMOShlnRrzcrrOtp+FULZOwnAUzrlk1YvYkYWBAhjmV9hqGiVKMVNOJ8m2
         QI7O7j2AHOXJn94rxSsUOHK5EYCzSXJLFx61+mZER60yBjRuXaai8Zc6kmPD9tPAVrtq
         InoKRut+2z6vgIeA4BwWpNlw5gl83O7EKsQ45wWpoc2jgCjguOfwzsGDmGA8OwahffJ3
         +aNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=pFN8cihJVHzr5yPjSDML+qWJPiNZrqYBqdqOmDZbjTE=;
        b=xmpv86EA2Z9YWZVMV5opijA4P0unv+VrAtV2ykQWNhwFB0N9R8mKgMNUU+ALgWR0wi
         +mQu0NntUf0vKaQolnoHs8ZyDGD7Ik12tYRQbv32R7LY5OsQkDUNWRqoxGVGydpdm+iG
         WSMxE1TODi3m12XUKs5/CowpYwqqF8c/Ivs4ZQmXPye6oMktXtn5GzdItu2Woy2eXxIH
         hGkWeITaFZ5Em2b4Tf8Ikjlg/sTtqYeIzpHmPzYRC3t6OmawM1n84DVtUG+5yWNgLwnY
         UDZVpTxH88/p9l/XisAbftNt0p0hnrrUBCldheXhhEZ8p64XZrAbIz8UlIzd0RMhFvgS
         FtdA==
X-Gm-Message-State: ACrzQf2MzDCuulWaq0tV856t5BABrtTb5apjrLFZk4h52gl8cAi2XXb9
        dVyuNjmKq5NiL9VCGt/FDHM=
X-Google-Smtp-Source: AMsMyM5s1atZy+xFJiScdUKk3v9MFFcv8cfo8Gj7d/JYtrmKf8lvoTuo5CCkfbWoH0LCkjy1D7s6QQ==
X-Received: by 2002:a17:906:7304:b0:6ff:a76:5b09 with SMTP id di4-20020a170906730400b006ff0a765b09mr18654068ejc.193.1663717768568;
        Tue, 20 Sep 2022 16:49:28 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id w23-20020a170906185700b0073d71792c8dsm498285eje.180.2022.09.20.16.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 16:49:28 -0700 (PDT)
Date:   Wed, 21 Sep 2022 02:49:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        hauke@hauke-m.de, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com
Subject: Re: [PATCH -next 4/7] net: dsa: lantiq: Switch to use
 dev_err_probe() helper
Message-ID: <20220920234926.aujk4siqrsq4jgku@skbuf>
References: <20220915114214.3145427-1-yangyingliang@huawei.com>
 <20220915114214.3145427-5-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915114214.3145427-5-yangyingliang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 07:42:11PM +0800, Yang Yingliang wrote:
> dev_err() can be replace with dev_err_probe() which will check if error
> code is -EPROBE_DEFER.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
