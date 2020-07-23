Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B00F22AD58
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgGWLOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgGWLOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:14:52 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB255C0619DC;
        Thu, 23 Jul 2020 04:14:51 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so5980718eje.1;
        Thu, 23 Jul 2020 04:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vdYyoECOJpkvRW+iDSJN0RIdv+nH41NS293U/5tTNzU=;
        b=B5vDCuMK34uIsnpD9z3FcIKsP+ARgUC68tC2JBNii294ZVz92X5OyPMGm1cnHIYPvl
         3DKQSNa/jdlu0biVdgVy3X/Usw30FobXy8VPbwfs9mZO4hgKFIB5Q6ou4++0iHZWcmIg
         rfstWtDzaQOlAHrnGsoBfnDZMJ2kD6uwV1y2oKkj2sr770VnwjwNmw0Za18fcxNwyhPN
         PX5gNfWd5bOhXJY1Kvg+SfF57+CLOAPlOGTBbqcVuFCBHygW7tXdpNSN+uznlRCislSc
         n2D4vVeaN2C63ZjJ8LYUcP4YwR3kpvL7IT5R8VKRAe3yBJewccDUsJmVY4TugCpk7vZl
         wX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vdYyoECOJpkvRW+iDSJN0RIdv+nH41NS293U/5tTNzU=;
        b=OSvvl4od8qhpj0fbhiA5979OI0+nto4RcDPfbflf+CsAatqxszOPd30p2nbgNR+IfU
         Hd4Ap9iZqCDKpgUp/3NGF5K7lQtcFWmFg7DLFnZ6EUXBh/VXovuO6fj16efUU0UZJB56
         /yZaiZovVILBMf1WY2kqzsc28Xlbo1UNKEuIIMVN9CcfLJ94OEb+/LRhUFn+19ynMxmr
         k+mdHaryMe5vp8ozuKPKGl1b+kojsES1aVxBo8FD/TjgQC+XFj3r/D/vvcvm8xuVF0i+
         9ryHfVoYSCkW38tTAwIW5BkJD0WHLiwdFF/WScJ0DlHUbTehhAEeCth11uxc5MqgI1dW
         srSg==
X-Gm-Message-State: AOAM530tjR5YjkGijVHLCXbqdpcgxRzpeQ+0qqsNcCysFIF6kxanE7VZ
        6AArdUThi60tVzU3ctXj05E=
X-Google-Smtp-Source: ABdhPJz4rM+z9eQOHfGGUF+Hj1F0q1VizoeW8bUipy1mWLCV1z/2+oZlfysZjxBFObbrbyKXQkFElw==
X-Received: by 2002:a17:906:1187:: with SMTP id n7mr3696742eja.161.1595502890446;
        Thu, 23 Jul 2020 04:14:50 -0700 (PDT)
Received: from ltop.local ([2a02:a03f:a7fb:e200:f109:49dc:4e2a:ea12])
        by smtp.gmail.com with ESMTPSA id y22sm1817552ejj.67.2020.07.23.04.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 04:14:49 -0700 (PDT)
Date:   Thu, 23 Jul 2020 13:14:47 +0200
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 01/26] bpfilter: fix up a sparse annotation
Message-ID: <20200723111447.3xj7cidlsspofsja@ltop.local>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723060908.50081-2-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 08:08:43AM +0200, Christoph Hellwig wrote:
> The __user doesn't make sense when casting to an integer type, just
> switch to a uintptr_t cast which also removes the need for the __force.

Feel free to add my:

Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

-- Luc
