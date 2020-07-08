Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0E2185AC
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgGHLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgGHLLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:11:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A36C08C5DC;
        Wed,  8 Jul 2020 04:11:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m9so9566100pfh.0;
        Wed, 08 Jul 2020 04:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zSjyM6g1C34TxuHd9W0ErF1Cg927sxQ1oq29ZbJpSug=;
        b=nCZG6pOPxnpDrleuRASYW8PXQBsvs3SnMsj6Ni9nGc0zPbEcTx9u0HKEwAgSA7h1Di
         ifBOf8/D4Z/0ZHURa+MSt6tstvqtHvAVqMi65CE0JLzUnkBer7XLhU25mctSV1BZc+Bh
         fTRfe6TP5I/mj8OmcEWTsKtC8NNxIJ9xegOrDOvToWSMqbUqp2PCi2TfckgUtuAabBOd
         WZtVYFjgaYAI53/JW23LUlYQcMRD5XusOZSlJ4O4Lb3xxvr6V+qn8JQQ2c2MnQc07rVk
         iP6BQ9+zgAz6mlXbSpYMFoY6JX28dhvEP2Vakv1ipavaLweUF+7gv2VPzBgxSZZfAI1I
         pycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zSjyM6g1C34TxuHd9W0ErF1Cg927sxQ1oq29ZbJpSug=;
        b=ePMxmZo+D+WOQh7Kd8oP+TiWXA0zIR9riXsz5Tsq58koYLZfe9JCJFmN8QM+D7mKnW
         zq7JYYd6UvgFiM5ZfpIBxGrIedxUjle3/lOAJXgKwDxoumG/bzhydpPNRKoq8HXcWCWO
         t230Wt03/r3h9rktM8UbtNoAt/D2ldRRdH4wgmBzJs8dUcl4v3wUueoQZz75H9mgw6fh
         CDnvp7kQcho0Q2elrBT1I9XDjZGmyWjqDIFUffnCnqx9/2PJb3eXrwlYRyyyb0LuKq/Q
         AC3YIYrTOPU0dy3pmcb9AT73K4WBXy4LGFGXNsNKItlhncCGv2MMnXC7G63FaeLAILbY
         Rc4w==
X-Gm-Message-State: AOAM533VGNFgYKljUM2vOfZ2R3dVTFEvpLiyS+16POBHrn5wEtvMRrLB
        wsdce+wAaKaQyltNiRFY9ws=
X-Google-Smtp-Source: ABdhPJzlBCQcbdO/pjB3HwANwtrwUPpeRd3/sBgg7PASPwSq4Vk3+7wvcnAxanPDH7mQvBqRhBD0NQ==
X-Received: by 2002:a62:16:: with SMTP id 22mr36905734pfa.120.1594206671579;
        Wed, 08 Jul 2020 04:11:11 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id o1sm5035018pjf.17.2020.07.08.04.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 04:11:11 -0700 (PDT)
Date:   Wed, 8 Jul 2020 04:11:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sergey Organov <sorganov@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200708111109.GE9080@hoboy>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
 <20200706152721.3j54m73bm673zlnj@skbuf>
 <874kqksdrb.fsf@osv.gnss.ru>
 <20200707063651.zpt6bblizo5r3kir@skbuf>
 <87sge371hv.fsf@osv.gnss.ru>
 <20200707164329.pm4p73nzbsda3sfv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707164329.pm4p73nzbsda3sfv@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 07:43:29PM +0300, Vladimir Oltean wrote:
> And overall, my argument is: you are making a user-visible change, for
> basically no strong reason, other than the fact that you like zero
> better. You're trying to reduce confusion, not increase it, right?

;^)
 
> I agree with the basic fact that zero is a simpler and more consistent
> value to initialize a PHC with, than the system time. As I've already
> shown to you, I even attempted to make a similar change to the ptp_qoriq
> driver which was rejected. So I hoped that you could bring some better
> arguments than "I believe 0 is simpler". Since no value is right, no
> value is wrong either, so why make a change in the first place? The only
> value in _changing_ to zero would be if all drivers were changed to use
> it consistently, IMO.

Right.

I would not appose making all PHCs start with zero.  If you feel
strongly about starting all PHCs at zero, please prepare a patch set
and get the ACKs of the appropriate driver maintainers.

(The effort seems pointless to me because the user needs to consult
the synchronization flags in any case.)

Thanks,
Richard
