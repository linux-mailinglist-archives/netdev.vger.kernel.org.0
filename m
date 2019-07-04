Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD81E5FC73
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfGDRYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:24:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54464 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfGDRX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 13:23:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so3391149wme.4
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 10:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y4voAUiJJKE00AR2uSiAh6BEDQ5M7euB2mZzQvioBBI=;
        b=AMvBLGrkP3CxUMSu0pr8Ckfnkpodk0l7sqq8Obe/MOQ8WwX1KdepPQ+ppj3izznsRx
         BPfFUnRlk4/8LeKNLiudk/y7uO4kWDyowv/67oOFxJvhDJHaP0AW+A81dAoIsJk13Ipu
         qDj5cZoFiDPeAuItKuxoonv77G4RvV0pQxyyXo2fkt0nx+c48mqY0BB3yvRCWIwAZGs6
         zfSCJGDFcJ0LSua8fwDx9g+k3FsJuG6QOlRJR8pGb2hxqp1WYZMe1J21oA2+UpXMtYqc
         HQPqW1Si8gyGWg3pJcJ2dOayzk7n9QTGSdtb6TCbnSSIEBUm2QdK4+wROyyMd2CyU+2s
         d1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y4voAUiJJKE00AR2uSiAh6BEDQ5M7euB2mZzQvioBBI=;
        b=HAZ05BHk1WI24DHpgY688cHCKiC9ETbdBVEE3273Z+ttYxW46I5hR7uHAexdTH4rFv
         3e60EixlZoLf8HxeNAmAgs6zpGPJYh9MBT6brVaIU7L1MzLjVoD6nB+0o0/SMA1gWDmJ
         mzBAxrnemvueV3ZoMQzkR+duX+eP61BUsoncMLZ/glBYCqFu7dEpKwJ4wmDz/6utu1D3
         7PxAfEnRhL0QqHNIPg3yzf1RKerkFYLY0OVko9f2MVEW/4IUxdCTMg6+C+33BgEtBvFt
         LjHE9vpkNUNxFZ10PzpcF2L2UDsFIMu+Ovx0VMZb0aTyQ2xr6lGoARq3B0zNJ+eGIXN4
         xM0w==
X-Gm-Message-State: APjAAAVpYJ3adiaJWk9Tiayg6ncZnS8dCGM9gdnUMOH8y4w0hpOq4MVZ
        6d61BBqsG4d4eHYCVMziJ725wg==
X-Google-Smtp-Source: APXvYqxR4bWTM5Aja4k+CHVHyqNjVnyHlOR72b86JbspolqS1srdqfiF4hRoTqd9BH0wTPlRkH3nnw==
X-Received: by 2002:a1c:ac81:: with SMTP id v123mr389342wme.145.1562261037825;
        Thu, 04 Jul 2019 10:23:57 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id 2sm2219802wrn.29.2019.07.04.10.23.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 10:23:57 -0700 (PDT)
Date:   Thu, 4 Jul 2019 20:23:54 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next V2] net: core: page_pool: add user refcnt and
 reintroduce page_pool_destroy
Message-ID: <20190704172354.GA14255@apalos>
References: <156225871578.1603.6630229522953924907.stgit@firesoul>
 <20190704171354.GC2923@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704171354.GC2923@khorivan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan,

> 
> Have trouble with inet today...I will pick up it as my changes depend on it.
> And send probably in couple hours after verification.
Maybe you'd like to add your signed-off on this one since it was based on your
patchset?

Regards
/Ilias
