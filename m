Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0340A3B951B
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 18:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhGARCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 13:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229929AbhGARCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 13:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625158776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JHh8ICKOowqqu/ghi9bTRyehDsl7GNMy0SOY9PPvc9Q=;
        b=hJgpjQ58cTpygw4YrSkl7QIRF4XrVpS+N3ap1QsRH7xfjl+FAz5qb8NYM7RLDe8hSPNy0M
        jLj0NzADYH6dYIDeK3X20e0/TsWong3s/hNwDQVswGKeI5qCsLIN/gPhm3/Ci/nWMQ+XR9
        omvLTgNDQGW3RegV2WK2WPP6ZY2SbB0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-_gRJn7o3NbaUXzDtddTy_g-1; Thu, 01 Jul 2021 12:59:35 -0400
X-MC-Unique: _gRJn7o3NbaUXzDtddTy_g-1
Received: by mail-wr1-f71.google.com with SMTP id p12-20020a5d59ac0000b0290125818b9a60so2792019wrr.19
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 09:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JHh8ICKOowqqu/ghi9bTRyehDsl7GNMy0SOY9PPvc9Q=;
        b=P5RrC0dYAQCfs/5YYSgPhk8nLwnOpvPQwk2AGyKQXvNVPY2cUU+UyyU7x5sD2uLHK1
         yPGPyeQNYTqklm6jovIPqKUYhGNkkp2fqkSw+GhUi8gDwyfcWwPkV28u9uKVMKg2g6a8
         OBRGDoMfQVCStZLlme07p+gTan4QVI9gTCN32RnMJQOn8AozpzLQxFqmAw4p35we7X5J
         2TcwF/LPmatSb4EiwfDPN5ET7iaX+ifkss69X/XehA6Lch5KVp/odjBoW7TXkB/yVglL
         d/Xb+DiINQ6CbSZ3XhWQUHp+YXxynkKSHbRmXWf5kJ9fvgir7XStTfWkiWBTYaYJkrCt
         1MPg==
X-Gm-Message-State: AOAM531/rYB509lWFx/8Dv38Xohc19PWszHWEE4l2FS0Om9C4BiL3+bN
        TRkbCKLpOEmPBB0VQR7B7+sRagk6aar5gqBxYwypPm6oggpSKZqcFOLk2DfsQW+niLIBKflQadQ
        ma3AADqkhANSgikSW
X-Received: by 2002:a1c:4b08:: with SMTP id y8mr708124wma.80.1625158774498;
        Thu, 01 Jul 2021 09:59:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUJwaFSBPDak7ty0IV5j7y2eQyFVUQYPsp6gCVoc+oDBE3CM0+VQeowj59kEauWhKjd5LaHQ==
X-Received: by 2002:a1c:4b08:: with SMTP id y8mr708103wma.80.1625158774317;
        Thu, 01 Jul 2021 09:59:34 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id v25sm543261wrd.65.2021.07.01.09.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 09:59:33 -0700 (PDT)
Date:   Thu, 1 Jul 2021 18:59:31 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
Message-ID: <20210701165931.GB3933@pc-32.home>
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
 <YN1Wxm0mOFFhbuTl@shredder>
 <20210701145943.GA3933@pc-32.home>
 <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 09:38:44AM -0600, David Ahern wrote:
> On 7/1/21 8:59 AM, Guillaume Nault wrote:
> > I first tried to write this selftest using VRFs, but there were some
> > problems that made me switch to namespaces (I don't remember precisely
> > which ones, probably virtual tunnel devices in collect_md mode).
> 
> if you hit a problem with the test not working, send me the test script
> and I will take a look.

Okay, thanks.

