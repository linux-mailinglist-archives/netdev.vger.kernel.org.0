Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196E63C9DFA
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhGOLwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhGOLwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 07:52:05 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B08C06175F;
        Thu, 15 Jul 2021 04:49:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l8-20020a05600c1d08b02902333d79327aso2809579wms.3;
        Thu, 15 Jul 2021 04:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SPeDyGqSFTj9HX+TvNrLA2iuffSVaR/KQ4kPJuR8e/M=;
        b=Qy/WO4VrpSuEySNBwwsfFYofOH+IjOzbTGpeTrOkiKNb4/6EczG0KPE+o2vY6wLLBE
         uk+4/8dW+lgtRR2DrK0QRrBjuyHresMx4q/iF07XkrSInCbdDW6co1gor7SRmR+/vxIl
         lPZ1TGGP2lINEnRrDiWF53s3jRz4EsSrQHwE7PEaJMRJManpe8l0UVzQk7fyuuQlFIK3
         s4DAE3MdZ8SfyNAENfyEDdX77VoH+qyyZqhFs+ZpeXmGVgOqavGJbMJ+/kimF6Lhlyeo
         7cxKoV7icjbliOzMjnmWJwQ2PSUREXgKpW+5CyQR03hIkg45y+8cGKsNagObqKcdYz/I
         yfrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SPeDyGqSFTj9HX+TvNrLA2iuffSVaR/KQ4kPJuR8e/M=;
        b=ozGf7kHyBabDYhaoreMvQXb6fLg+gmmCB+3zZbHbP3eifebkVKIzJAyHvjD7Qj58We
         JdBnohjnm1gQkMs1+5z1dKtxKnvyZGLsHLYNdiSYviIw7OESl7/Nm8KJX0/Cjgm5CYIm
         V6tpjKnKBWXcOQqabZK886TJS5LbeRK0AqzDedJ5qsy1x7xf0o7H2WZrRdCPQ1bzxeLf
         y1ygwVxsMJVqXQ1pgj5S6k9RucrXforeEY891PX0yzAfvYQ97uwvxdRHnPRf4JmIdcne
         q9BEOfBQ39dzF817YalSeV5J7UqR/SISnY0Z8/FRAV4TJ6iFtzjNwCvzg72R9PgvF00S
         CyhQ==
X-Gm-Message-State: AOAM531zq5twUYmZbT1Dn/nVTcOz85ZRqO9qnS+50gkm9CnTIrZFYdKZ
        1/KQHdNmtzvi3N7JqBzuT+Y=
X-Google-Smtp-Source: ABdhPJxl7aRVCwersA2utu/73GOu1JUMoD3qRN3k/qfhuWo8/Mc32tscT2CS07sOz1/1eJFHhqtynQ==
X-Received: by 2002:a05:600c:5106:: with SMTP id o6mr9981855wms.18.1626349750216;
        Thu, 15 Jul 2021 04:49:10 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id u12sm6383779wrt.50.2021.07.15.04.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 04:49:09 -0700 (PDT)
Date:   Thu, 15 Jul 2021 14:49:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <20210715114908.ripblpevmdujkf2m@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
 <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
 <trinity-84a570e8-7b5f-44f7-b10c-169d4307d653-1626347772540@3c-app-gmx-bap31>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-84a570e8-7b5f-44f7-b10c-169d4307d653-1626347772540@3c-app-gmx-bap31>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 01:16:12PM +0200, Lino Sanfilippo wrote:
> Sure, I will test this solution. But I think NETIF_F_FRAGLIST should also be
> cleared in this case, right?

Hmm, interesting question. I think only hns3 makes meaningful use of
NETIF_F_FRAGLIST, right? I'm looking at hns3_fill_skb_to_desc().
Other drivers seem to set it for ridiculous reasons - looking at commit
66aa0678efc2 ("ibmveth: Support to enable LSO/CSO for Trunk VEA.") -
they set NETIF_F_FRAGLIST and then linearize the skb chain anyway. The
claimed 4x throughput benefit probably has to do with less skbs
traversing the stack? I don't know.

Anyway, it is hard to imagine all the things that could go wrong with
chains of IP fragments on a DSA interface, precisely because I have so
few examples to look at. I would say, header taggers are probably fine,
tail taggers not so much, so apply the same treatment as for NETIF_F_SG?
