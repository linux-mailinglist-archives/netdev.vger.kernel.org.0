Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF443C5833
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349796AbhGLImr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 04:42:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378127AbhGLIkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 04:40:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626079048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtgmkbA7fK2EhA7rQfsGaJ3jsKdgs8bOBRgjTk8BvzY=;
        b=JQjbI3z/zDRl0E7MhdsKwod5/sibrucIu0laXMu2igHu5ipt+9+l2AvEkiCYuCt8Jrm83G
        8K6DC3ScQgL3LddaM4qsXk1clj9pDP3ygZ/0z4hRjUZM+o3/W4ewyijnnICi6w0l1Gs6Yk
        6DL3GlfoJU65RhoOrBLv1m7vu7hw75Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-Q6hzz-tDMl2xzpwHCJNpmg-1; Mon, 12 Jul 2021 04:37:26 -0400
X-MC-Unique: Q6hzz-tDMl2xzpwHCJNpmg-1
Received: by mail-wr1-f70.google.com with SMTP id k3-20020a5d52430000b0290138092aea94so6840514wrc.20
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 01:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QtgmkbA7fK2EhA7rQfsGaJ3jsKdgs8bOBRgjTk8BvzY=;
        b=dp0iyzo4UXnYgCyGeYQ5G4Z168nVckCzMf0EgpkIqaqJppOxmTZ/Q2nZR+H4/Ko7TV
         /rFPAqGVNqkUiJjM8sw7V6kCfc/WMCdB/axJP1cjnTjupuRr+qtq2stMbLJyJzgWOkd3
         RPQpJxjCv1oSRNgxYFZDF+RQS+MVyzGWUi4/zFZQOAv69dPBVtOJHkpsxY+vih71KtXj
         /w096eyIKoSzVmF4KYPOrQYDZWsc61C3JjrN81Am+Aur2vFk+xdzgeV0MbNJ8wyWALW0
         wvVBAQDM4pEuaUp3oY65nz7G6xSgJmVSlTkuldO3/jtUSvJCYBpt+MJdrkqyM353ZOc0
         X+Aw==
X-Gm-Message-State: AOAM5315fOVWalLRYjUY6H10nnoC8HK0CGp9n8Yel2lrcYeYDfXdKUIy
        1aqieSBCaSYI3OsqELhkjwAWSkH8NTFuCzjVftF3amUy/8L2PMFEzpqc9BmGEp+YBoyqJQeRU4a
        MZ1VYMXr7a56UOVik
X-Received: by 2002:a5d:4a85:: with SMTP id o5mr23309471wrq.410.1626079045480;
        Mon, 12 Jul 2021 01:37:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzu5oi3ak/0W8s7hVbWKYG9EG0vSJNSfmuisXBgV/rwfB+qSBwOX9LH3uV5tjhLte+1fP/tQ==
X-Received: by 2002:a5d:4a85:: with SMTP id o5mr23309454wrq.410.1626079045274;
        Mon, 12 Jul 2021 01:37:25 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id p5sm14017148wrd.25.2021.07.12.01.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 01:37:25 -0700 (PDT)
Message-ID: <b076d20cb378302543db6d15310a4059ded08ecf.camel@redhat.com>
Subject: Re: [PATCH net 1/3] udp: check for encap using encap_enable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Mon, 12 Jul 2021 10:37:24 +0200
In-Reply-To: <20210712005554.26948-2-vfedorenko@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
         <20210712005554.26948-2-vfedorenko@novek.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2021-07-12 at 03:55 +0300, Vadim Fedorenko wrote:
> Usage of encap_type as a flag to determine encapsulation of udp
> socket is not correct because there is special encap_enable field
> for this check. Many network drivers use this field as a flag
> instead of correctly indicate type of encapsulation. Remove such
> usage and update all checks to use encap_enable field

Uhmm... this looks quite dangerous to me. Apparently l2tp and gtp clear
'encap_type' to prevent the rx path pushing pkts into the encap on
shutdown. Will such tunnel's shutdown be safe with the above?

> Fixes: 60fb9567bf30 ("udp: implement complete book-keeping for encap_needed")

IMHO this not fix. Which bug are you observing that is addressed here?

Thanks!

Paolo

