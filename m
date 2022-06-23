Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E490B556FC4
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiFWBP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiFWBP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:15:27 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03096427F5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 18:15:27 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 59so5122713qvb.3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 18:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CwBYvGmCRrwFzcAOXH4H2xZ3G5NMOayLaSvBIXIZ4lQ=;
        b=Z/am4R1W1v9hGE7RzxJ53Ao5ZswPtUXFd0nsVflChgURE6YJ1ixDLgZyDV3JYGJGPa
         fXek2ux8WxYIn+skxPvrrWI0Bld2F/iFNTcOU/u75n8gCRQ7iSmm+h/HXHVCFtgzjYdj
         oFa2KFVI8ZD8zIdmtF/6qtMRWWifBEgL256Lb5TNh/h8HXlWwChiHhkzTkgRJOB1PLzX
         PnEHnVuksdyjDyJslFGWaVA2XFq3EUDJ34jJJTOnbRARVBVj9sA3UPQ2JygOS/6Ojdbu
         pqUY9Zn6dleGK3cBgYLMjj93VleMRQuiIuTZzGLjhfaN8o2XkwuFe7SHwfQTNZzNqwCu
         al9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CwBYvGmCRrwFzcAOXH4H2xZ3G5NMOayLaSvBIXIZ4lQ=;
        b=QN8FIy5dBY5dELguDJwZVjTBVf1sBMyCXxMXNAFUD8X5MYzl4O4jqHqu9w3AusVnfr
         fI3rJ5dKSTSLUfe5wPNbs9H0x89eHYj0ADtzBKCVKXlS8rlHBWrEhjlremkIBtNtINsZ
         e7BewMgMynXwNWDNB7y7Cus9RfuZFw8R+uQGRXppEGrb7aWPxd8WdXERzPgVtVZDKhFk
         KpoMmcTy+FKXp6wWfx4OaRDDvbgbvf2NTzqUBT0r9/LcAunj+Q2gE6BXCDrQcQLdbYvD
         KS5/mIGffYItPEKvJ69JSfvkpZP1SmRgEbZMj0lWftMs7U5oahTsR33zm4OuZQsjDNf7
         DE4Q==
X-Gm-Message-State: AJIora8llaZ625/fwX9NrWKACs0fvR8FmPEMIYXDhnSl86zUsrlaE0Hq
        3n1QC/FZ+VSLoLeCnowK+d7AV5C2twY=
X-Google-Smtp-Source: AGRyM1uqqvCDJ92ytqAxbLkoW6v9tfjuJb3Yt+Vnr7jf8d0t0bCT/wIci4g4KK0pf8T+olUZUDs2dA==
X-Received: by 2002:a05:6214:1bc7:b0:470:610b:a588 with SMTP id m7-20020a0562141bc700b00470610ba588mr5237579qvc.33.1655946925950;
        Wed, 22 Jun 2022 18:15:25 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id bm31-20020a05620a199f00b006a6a1e4aec2sm16747367qkb.49.2022.06.22.18.15.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 18:15:25 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-3178acf2a92so145803007b3.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 18:15:25 -0700 (PDT)
X-Received: by 2002:a81:110:0:b0:317:a640:ad04 with SMTP id
 16-20020a810110000000b00317a640ad04mr7954186ywb.427.1655946925081; Wed, 22
 Jun 2022 18:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220623000234.61774-1-dmichail@fungible.com>
In-Reply-To: <20220623000234.61774-1-dmichail@fungible.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 22 Jun 2022 21:14:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeRjCQimk66=jo8WwB7_2OVmZFdz4kWwHtLMxH5ZxqF8A@mail.gmail.com>
Message-ID: <CA+FuTSeRjCQimk66=jo8WwB7_2OVmZFdz4kWwHtLMxH5ZxqF8A@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: pass ipv6_args to udpgso_bench's IPv6
 TCP test
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 8:02 PM Dimitris Michailidis
<d.michailidis@fungible.com> wrote:
>
> udpgso_bench.sh has been running its IPv6 TCP test with IPv4 arguments
> since its initial conmit. Looks like a typo.
>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> Cc: willemb@google.com
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for the fix Dimitris.
