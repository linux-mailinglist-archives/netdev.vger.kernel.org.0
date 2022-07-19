Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D272257A08C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbiGSOII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbiGSOHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:07:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2873FA03;
        Tue, 19 Jul 2022 06:24:15 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l23so27163141ejr.5;
        Tue, 19 Jul 2022 06:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hyatuYhZCtPLqI4fGrNWk6EujsX1AdtOLboSvM2Wu/w=;
        b=qPAEipJo7rduBwV/2Va2Cn5cyOYobIilom1aYIqhHJz28pjR7Wm7O0rqeKfq30J7MQ
         UU3slDYc80gMAJugXk0VFAPV+RKkX10DmD8rZdMADTQ0Uecnpd03S76M+D1Bj+kbVoxV
         OjZ0I8ru8+4NOOtn2rBME1D7zRyteKQMXpW1U8Bkh0D0OVqOsDADOrXCVD74Ef1m7qGs
         fc3ObCuJFCXILqXGkhU8NFW808oh+k7XdkdttBak2OrjyQIcnjhqW/FcxSf4HslcpQsp
         t8WNc9ZFddrZ6agk4jQggSJ+2eXg//7+8sUsTtdz1Q/pmL0Vw3pm58Yr4KUh5uih6gFr
         FjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hyatuYhZCtPLqI4fGrNWk6EujsX1AdtOLboSvM2Wu/w=;
        b=hSLiHDm6YQ2gHVrwWQD6CLtPflJrx0fIBhxofEgE507xbngEQAOsxpn+gnJiQGmria
         1Azrl7YIqcManJU/9GE0tWBZMWPpBtOVdaiyRd09SYTk09aiZNlQDiOrNVcpZ2sH7hJ6
         lhTIYXOQZRsqDRGN+ehmvglHl7511BT8Q5pHJlvrgiaQm8n8qP0mjJQ1av33SJA3AMuz
         OCD+nYNQtPUn/4o5bIrIq7KaLoW4OtcddRDIycqKK4XPWyHWVvAMhN7YPq3pwWmtG49i
         DvqCu4cC54VAVAWeJgvkJNihVB6bFV9fPKGH7WhnfZ9msulU+k/TiZHv6Fminjrt2/Xo
         Mrsw==
X-Gm-Message-State: AJIora/u6TRoPlRX8u7AY0MCxNwKyUPkjTt0ABQqsPKZjjV/qlstwExg
        u5nd08qRceq2QlYcBOYf6O0=
X-Google-Smtp-Source: AGRyM1ude/xwU1U0DI1OGoAd1dYcv6tkayoAHp+s4dv/PoHmA+QDdR+n1g4UGU/uHsHYXuM0Yr/Rlw==
X-Received: by 2002:a17:907:7b95:b0:6f4:ff03:981a with SMTP id ne21-20020a1709077b9500b006f4ff03981amr30989164ejc.653.1658237053665;
        Tue, 19 Jul 2022 06:24:13 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090616c800b00715a02874acsm6654643ejd.35.2022.07.19.06.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:12 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:24:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 11/15] net: dsa: qca8k: move port mirror
 functions to common code
Message-ID: <20220719132410.uru6vbimevxyuto6@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-13-ansuelsmth@gmail.com>
 <20220719005726.8739-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-13-ansuelsmth@gmail.com>
 <20220719005726.8739-13-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:22AM +0200, Christian Marangi wrote:
> The same port mirror functions are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
