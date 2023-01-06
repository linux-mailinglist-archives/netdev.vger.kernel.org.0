Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CD1660465
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbjAFQia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbjAFQiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:38:05 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CE078A5C;
        Fri,  6 Jan 2023 08:38:03 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id fy8so4550739ejc.13;
        Fri, 06 Jan 2023 08:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cVVA+wtN3OwRb/Llt+vsUs/VHbWYd94vDiApWlf28eA=;
        b=ABQKaLwPguTKBSF04UtKiM3TJSxZzUYPYoqdOYC0irtnhPMRygdoBOKLtHXbiD8bUh
         gfNHXwr7rpHSdc1rf3SuXySjrRn0uIGWfMlAHDpr3xUOYtTfkXvkxk+qQtt0AHr+aJXx
         nw7ULMBESX5IwdWftp8lQ4qRHYWP6Anw4z4817kQZF3LB48kTdchDpgoQW2Gf3UNqOgJ
         S9XzK9OthCMViShxcBtwrVzMdpjYgglyOGHaeZc2a38W5AJj0HsIHnh8upsQRiDGvjpE
         UpP0i7YxFFCu/WMqJs+zD17riwqXvGuI6o4aEHEn9j4xr3HGqi/p7LC6xbJnbPxIlezw
         r/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVVA+wtN3OwRb/Llt+vsUs/VHbWYd94vDiApWlf28eA=;
        b=6Yp1Lzij7+dIhRpvdZ5lYBS+x+MHfCzPrY11pXlVPxc3H2I5zQ3LDmoAqJZ+YySoz3
         gy+QI12YHHClSVUr+P8CYK2l6x8s528fCIMIogz+sBe+sr7OcmaYe8Q9By1k7dboLl3i
         cd3tOooVhvGBDTfbo/QkS2rb5CRDkfampe5bdliBe+ptllfXRaT7J66Bon+LxTcfkZTN
         bPoPyzSMwiiJREKcNacxasrVVyU2QKGIrK+OLDPqyuSz4mGRZWuCuLsjZSQjEfcg5ZzU
         9gSnqzsE5voS68U7pXNH/faablpFQ0UBArTXtKmB+/EWpmZaGIExiv/DDCK61lucexoe
         hD9A==
X-Gm-Message-State: AFqh2kqaDm2bnQ9phpDzVkbvfpsFduAh7PbiJVgwnMIgsJagFqUQvbAr
        Uh20B36rLazFvMeokDeY/d0=
X-Google-Smtp-Source: AMrXdXuOH0umBDp9wrpS/HB4IQPoIxstkudT+eR+WDE7VdDybsxAkuOFnTnmy4R46+qCB3IcOd+IOg==
X-Received: by 2002:a17:907:d601:b0:7c1:2d36:d11a with SMTP id wd1-20020a170907d60100b007c12d36d11amr54637846ejc.11.1673023082381;
        Fri, 06 Jan 2023 08:38:02 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id k8-20020a17090632c800b00780982d77d1sm546762ejk.154.2023.01.06.08.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 08:38:02 -0800 (PST)
Date:   Fri, 6 Jan 2023 18:37:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 2/3] net: dsa: mv88e6xxx: shorten the locked
 section in mv88e6xxx_g1_atu_prob_irq_thread_fn()
Message-ID: <20230106163759.42jrkxuyjlg3l3s5@skbuf>
References: <20230106160529.1668452-1-netdev@kapio-technology.com>
 <20230106160529.1668452-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230106160529.1668452-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 05:05:28PM +0100, Hans J. Schultz wrote:
> As only the hardware access functions up til and including
> mv88e6xxx_g1_atu_mac_read() called under the interrupt handler
> need to take the chip lock, we release the chip lock after this call.
> The follow up code that handles the violations can run without the
> chip lock held.
> In further patches, the violation handler function will even be
> incompatible with having the chip lock held. This due to an AB/BA
> ordering inversion with rtnl_lock().
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---

Needs to compile without new warnings patch by patch.

../drivers/net/dsa/mv88e6xxx/global1_atu.c: In function ‘mv88e6xxx_g1_atu_prob_irq_thread_fn’:
../drivers/net/dsa/mv88e6xxx/global1_atu.c:460:1: warning: label ‘out’ defined but not used [-Wunused-label]
  460 | out:
      | ^~~
../drivers/net/dsa/mv88e6xxx/global1_atu.c:460:1: warning: unused label 'out'
