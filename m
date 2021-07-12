Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C799D3C5DF0
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhGLOIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:08:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230297AbhGLOH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 10:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626098711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3unN0zkrgoq84WPqxz/v8YEWmhcZ2MZQYoWXmOdm4I4=;
        b=IBJDqlYuLxgsfZPLgZOy+elnFmJjIVLSmMhgteyMbtVcDjiZTD/FnSMWvzgCJlr9xFSiuw
        XUAsdCNPAZIZDFmEohBsVnR6P763zTFx4XMtIeYEdBSkmhViYw6XtQvim3/fQnyY49UIf2
        6JcqVB+HZ/2PNCgCsGA9djDqlTyev5o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-rNxNoxeKPvK17lU56YEf3A-1; Mon, 12 Jul 2021 10:05:09 -0400
X-MC-Unique: rNxNoxeKPvK17lU56YEf3A-1
Received: by mail-wr1-f69.google.com with SMTP id a4-20020adffb840000b02901304c660e75so7097359wrr.19
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 07:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3unN0zkrgoq84WPqxz/v8YEWmhcZ2MZQYoWXmOdm4I4=;
        b=ozwGlM1rNKmO4x1OUkH6t/3O6yhDRLSdN2IRgHkjUj595Q9Wq3fCOAmOonBWoU5n3c
         pQ9eBuektTQ4xbi44FY/S5IaVRK7rCBpF8cNmi+TRC5WBnYHCdrr4OLVU+deWijOQfLg
         FvZ4fz03jrLHlFsNDHPsFxJKwDKmW4aNIMEOWV36cUOaUQhvAm1U9CzRAxtN6SGIYh1f
         h1LaTGAgERO573wPQp+gNvs9cWH3v9XwEbFsRh3ymrl3PmBH+WU2vBSU2fgCIgq9Lx7/
         guv6TJU9TK4Ek8I5i78Mei8WYoC0Wetd4sYFOFvjb1mO6MHxJAe3g7J8lRudiBufHgXu
         cjnQ==
X-Gm-Message-State: AOAM533ITgmHe0Lr4ByzZes/5GLXKdCRmqpewX35CryP3gAjmZm+IQgv
        HHP2L/L2WYvO8TIrVEcuoK3ShRgFA658bVG2OQ/gveTUTf1szA9lODDck6MbRPvk4IQJk8siPG1
        S1wiDQkqw/KYn197K
X-Received: by 2002:adf:9cc7:: with SMTP id h7mr34504727wre.186.1626098708394;
        Mon, 12 Jul 2021 07:05:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl/0mZkZ1fKRvRfeyqcJCQAZq/JIdLstv68F3HiLdMLGaxk1Bge7PC28K/VRQoL8ARUR1+uA==
X-Received: by 2002:adf:9cc7:: with SMTP id h7mr34504701wre.186.1626098708247;
        Mon, 12 Jul 2021 07:05:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id 129sm5833398wmz.26.2021.07.12.07.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 07:05:07 -0700 (PDT)
Message-ID: <970fa58decaef6c86db206c00d6c7ab6582b45d3.camel@redhat.com>
Subject: Re: [PATCH net 1/3] udp: check for encap using encap_enable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Mon, 12 Jul 2021 16:05:06 +0200
In-Reply-To: <6fbf2c3d-d42a-ecae-7fff-9efd0b58280a@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
         <20210712005554.26948-2-vfedorenko@novek.ru>
         <b076d20cb378302543db6d15310a4059ded08ecf.camel@redhat.com>
         <6fbf2c3d-d42a-ecae-7fff-9efd0b58280a@novek.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-12 at 13:32 +0100, Vadim Fedorenko wrote:
> On 12.07.2021 09:37, Paolo Abeni wrote:
> > > Fixes: 60fb9567bf30 ("udp: implement complete book-keeping for encap_needed")
> > 
> > IMHO this not fix. Which bug are you observing that is addressed here?
> > 
> I thought that introduction of encap_enabled should go further to switch the
> code to check this particular flag and leave encap_type as a description of
> specific type (or subtype) of used encapsulation.

Than to me it looks more like a refactor than a fix. Is this strictly
needed by the following patch? if not, I suggest to consider net-next
as a target for this patch, or even better, drop it altogether. 

Cheers,

Paolo

