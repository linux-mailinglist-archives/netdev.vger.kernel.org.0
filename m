Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCDBBB67DB
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387564AbfIRQRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:17:52 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35887 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387555AbfIRQRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 12:17:51 -0400
Received: by mail-yw1-f65.google.com with SMTP id x64so158237ywg.3
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 09:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6QlbipEnPFwX9muuIKHe5PLCoSBx9xZIwzLdN8C3uE8=;
        b=D+/255qrQrYQOXxAmv4LlylvlDjqUa0vVFqYf7FYQfiAGkEL5c/8YCmk5dZLJaAFDa
         8YGySDWZXiqN0HpKw/rT7Ae7FA6y3BC1GyCfYfDCRt0OmdwBuUG0aqkmSfoi4lyh658y
         P2OP5Nj1SgJFvGc1hun2EXfJhVuZyRwcCdtETzooZI+u72jGgXe8hR5jlvq4x2PWe5hd
         NIpI+UYbE/5+8plsgweSUIAJDjT4QSKj7ovvVQwKMo/6oIu9pRYdpO80tPALRqaNDqvy
         CY87BS+gutx6Jz7iKeQ8auU+K9XSkjsTY/eHDBUege1zPul1ilvT5/SKbALcEp7OkQGz
         QpRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6QlbipEnPFwX9muuIKHe5PLCoSBx9xZIwzLdN8C3uE8=;
        b=Zaj/Vs+lndADsNbgMs/ftHZr0x2gAEo5zPd72pEhbBELUI8iT9KTFRbKSIEYSOJ/M1
         Pyqkb8ewIE7kQVOdX4sOH6xVYnTCA/rrf6FgUhXWcf4nMF9HYrOYKHKEvbE9efdTv1Or
         YDWLjQubgGCCyPbYC+176BiWnbThv0gxNNssOest365HXvcD9u+DfCSVTMcn9vFH0Pn8
         l8YYIvTXnHhGf2m3leBd19wiFLR6UVp2HgROHyC1g6JFe+pJtEexhYfVkgmVOTS5VtaV
         NWYz+v0gYO9psmPBe7pWK4RU2Dx9YcpVHSgH5Ln+x+xLAZSfcgAgbas0b6LFnSen6tzU
         yXBA==
X-Gm-Message-State: APjAAAV5L/6OufX+N4NEwU33vxO1U4HjNELiotgYqlIObMrhPNKM7c4S
        Gg58HJlLXzPborcA9S8DtiSzcZxU
X-Google-Smtp-Source: APXvYqyKgMcIbMJfAZLozWKDpKIta51REMJ1n9uMjniIVDiw4UelaXKfzVtzR45pDnj+2+53HJFVEA==
X-Received: by 2002:a0d:cb51:: with SMTP id n78mr4165270ywd.401.1568823470548;
        Wed, 18 Sep 2019 09:17:50 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id v204sm1298320ywb.23.2019.09.18.09.17.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 09:17:50 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id t15so215257ybg.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 09:17:50 -0700 (PDT)
X-Received: by 2002:a25:774d:: with SMTP id s74mr3472088ybc.473.1568823465067;
 Wed, 18 Sep 2019 09:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
In-Reply-To: <20190918072517.16037-1-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Sep 2019 12:17:08 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
Message-ID: <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patchset adds support to do GRO/GSO by chaining packets
> of the same flow at the SKB frag_list pointer. This avoids
> the overhead to merge payloads into one big packet, and
> on the other end, if GSO is needed it avoids the overhead
> of splitting the big packet back to the native form.
>
> Patch 1 Enables UDP GRO by default.
>
> Patch 2 adds a netdev feature flag to enable listifyed GRO,
> this implements one of the configuration options discussed
> at netconf 2019.
>
> Patch 3 adds a netdev software feature set that defaults to off
> and assigns the new listifyed GRO feature flag to it.
>
> Patch 4 adds the core infrastructure to do fraglist GRO/GSO.
>
> Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
> GRO supported socket is found.

Very nice feature, Steffen. Aside from questions around performance,
my only question is really how this relates to GSO_BY_FRAGS.

More specifically, whether we can remove that in favor of using your
new skb_segment_list. That would actually be a big first step in
simplifying skb_segment back to something manageable.
