Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D1427CAD
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhJIS1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhJIS1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:27:37 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E320C061570;
        Sat,  9 Oct 2021 11:25:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so10223929pjb.3;
        Sat, 09 Oct 2021 11:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rq0DT40wgeoIBahXvlXDN6qrZsJagfk0p3A+Wt86z44=;
        b=cwle96yXpzeSO0zhPME/a7UdxCdZ1xJ30Z5HjCsAwsJsRhFONTm4oTr+QoCUGIQr6k
         o0BlxKDt/wGGNStuQhlPUkLihuCPDboSHl5M9x/FAlKLmHglnzimlkap4oDmHepdhGUz
         ZgkNIW0Fkbgowl5VhHqFj4irwAemHMF6WE3oWF02nBBq+N2811jAJQlh74hD93sHlxhV
         w0miNOub+2oVpC8f559uXC5wg7YZniZjdBQBKVbXOmt3fgfTWs/o3jjDXOmn7tNY+ylH
         wWW9eO3Sxf78EoidqDHVAvu5mGpHwt76pd62SnHJ9AdMtO7e+GRevBJr/Xu6s+DgPJHU
         EHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Rq0DT40wgeoIBahXvlXDN6qrZsJagfk0p3A+Wt86z44=;
        b=TT3gP5PhQ7beNTTx+AcbsdIMmKXnINNp4jhn8KDyRreJaAV78CIlz1QlSGyODjIuV8
         LlDAzwONk+ALDZ+cttXnTgkVHqzFkCpkWbs1F2fEbFuzgeazaXXNixLtcCskW5BUjaqw
         ZS+hyFunUUKQWuVobKtm5ZpmA0wG50MQpWDiI3st0hQ6dpDsxQ4ffAmx+qSblxO5AsmF
         JjvzwtOWMiwoClVe4tHCKZOhsVOaHkUmHn4gF+1SzFDA0K8VG/FxDLazac1HLqEpOWn3
         qfvzQWr8MciAkduM9DZvoOI94+HvBYs+2TE4OfEmP7EulyzBp+CG7+09wfWQ/xtZ3CqS
         t/IQ==
X-Gm-Message-State: AOAM530F3/5b8ZHZED7lwP3q2TNYvhDhnnb50SEtpu0k3a644kisCzcV
        Nu/K58C5i5ZaSjEzOfUGSGU=
X-Google-Smtp-Source: ABdhPJwv9ZNBaYid+cjoF5VHExieieinvF0GF619iQlFcY5xseXd55VzyAiiblbgVxA+ZZcOGuGeOg==
X-Received: by 2002:a17:902:6f01:b0:13b:7b8b:84a3 with SMTP id w1-20020a1709026f0100b0013b7b8b84a3mr15619760plk.40.1633803939610;
        Sat, 09 Oct 2021 11:25:39 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b16sm2848283pfm.58.2021.10.09.11.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:25:39 -0700 (PDT)
Date:   Sat, 9 Oct 2021 11:25:36 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20211009182536.GC21759@hoboy.vegasvil.org>
References: <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
 <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
 <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
 <20210930143527.GA14158@hoboy.vegasvil.org>
 <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
 <20211007201927.GA9326@hoboy.vegasvil.org>
 <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
 <20211009182414.GB21759@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211009182414.GB21759@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 11:24:14AM -0700, Richard Cochran wrote:
> Show that it always works, even with worst case crazy adjustments.

For example:

   * large frequency adjustments are more problematic. I've checked that
     some drivers allow up to 10^6 ppm...
     This could lead to non-negligible error.

Thanks,
Richard
