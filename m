Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFB71B5F2B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgDWP3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729014AbgDWP3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:29:02 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAD7C08ED7D
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:29:01 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 145so3093241pfw.13
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ReuV0muqIW4qNrciBUp7pZTStaUmITZb0zJ0j9n4UQQ=;
        b=0lgF00Onp4lz1C51x2uyX2HoVJmADMkBV1XX4XTdEgz/bMfNChVJ29s6bjmYiL7QKA
         zKGWlSwjI7v9p9OfcvmjUOOtxCXGiEH3dip3MG0sDgQ86RLj9wP5Vy0JV4IrebWhT9wf
         /O02D2YQ/VwLSKx4GpdCKAe2dIHwAFYW+/qdOWYGRICBflcX+GVaAuCFjIWgAiluXMU6
         hWGJ0XKKoRrWL5F1RAEWrFejNmXUUo2vNDeHErykBUxHphR8C6oXx0AqCTKUzHEfU79h
         eppeVTSJvTzMZvpOtaO3YRwBZk0GlXilhSeTDorGO2aQAAaV5kdjxA5Jvlb/stZwUQli
         Vrsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ReuV0muqIW4qNrciBUp7pZTStaUmITZb0zJ0j9n4UQQ=;
        b=gAd+dhKiuKQHYOdwtqoC1Fl29ggvhkRk0LBXryRYgAnMWcEqw7SR/x28kFynB98Jvy
         uCjLYRklsYt2BUcj2Gu3qpXoRyy5R1rkga+6B307iIsBi/Tq8P7/9tbgpx9BE5GvBg+i
         D5yt4Orli2bvMlq/SS/ws2MbcCzCYdaXh/cmJRpsxzuthZ7aJy9hq2VfSDNLV78M16Ri
         MqU97DDz0vQxgWf1pCuEkwL9U5G2PN1wgB+oau0QjUFBM8Kb1y8iBZWNOC4vAJZ4ke9R
         HPrCXrZAX78AlcrWPZdcrNxyr5g9HRgiQMdjid8d8pOtYR73aOelTiiystm3a/WeXIKA
         rTkg==
X-Gm-Message-State: AGi0PubF8SnV/7Y1BkHjjAexAot+FzAd5ikFwAA3v4GJaCiYdNcz1VxN
        cw1oJM5GEbhTN7Aqa50Sgb/mFw==
X-Google-Smtp-Source: APiQypJqo+X1hHrf6z0sZ8RPlZMPhRFy69TnCdKyIHtAbDgm1WxtiFVZsArrgVZ9b1AQxOJlPBiTkw==
X-Received: by 2002:a63:c44b:: with SMTP id m11mr4579558pgg.313.1587655741462;
        Thu, 23 Apr 2020 08:29:01 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t7sm2887215pfh.143.2020.04.23.08.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 08:29:01 -0700 (PDT)
Date:   Thu, 23 Apr 2020 08:28:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        nipun.gupta@nxp.com, shawnguo@kernel.org
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Message-ID: <20200423082804.6235b084@hermes.lan>
In-Reply-To: <158765387082.1613879.14971732890635443222.stgit@firesoul>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
        <158765387082.1613879.14971732890635443222.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 16:57:50 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> Drivers ndo_setup_tc call should return -EOPNOTSUPP, when it cannot
> support the qdisc type. Other return values will result in failing the
> qdisc setup.  This lead to qdisc noop getting assigned, which will
> drop all TX packets on the interface.
> 
> Fixes: ab1e6de2bd49 ("dpaa2-eth: Add mqprio support")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Would it be possible to use extack as well?
Putting errors in dmesg is unhelpful
