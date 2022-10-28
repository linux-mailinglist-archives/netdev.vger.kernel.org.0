Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD17611959
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 19:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJ1Rfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 13:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJ1Rfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 13:35:36 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAF21C25F2
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 10:35:35 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id n130so6879262yba.10
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rYXXTNqLvAXZdTvJAPPYctkYF0bgfrq1NQcFjeCYXcA=;
        b=q3FNUgJRBmPyYm7vxF2W6ganSjLZNHkggNhua37hx82MYcqxYOSjwWtGbIg69w63p+
         IprBOEkwK3QFmbB1c8LT2aSqbndha/Dnzint/oEvS51heEd+wRyQGe2GcDDV1M16dSes
         fby9+YYx7yoPYZTKkeyIy+rO0MJ09zQ84w1oLtlYbHkLJpNxJQ4wbBGt7dp1Q7tuoogG
         v46FqgoTn/46ElbKwKWy+Ffrx/bZFFnE13vp4KjQl+A3V5YnSVpmYPv37VnwErq0tYDd
         pgJ3uUzm3y2Nm9tvkabKMjcrsQHh8tucxD8h29sLQzLYH2CK4Xtvq8E07riHepbtOdEh
         Dv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rYXXTNqLvAXZdTvJAPPYctkYF0bgfrq1NQcFjeCYXcA=;
        b=ZSBRwFZLavMt5B6XDyLXeL9BT5vbrXOCqI6V6YcBcFHWQxjZZ/xzobZ8/Qkyi6QxLo
         pPaQ0RCuvSLTD+PbmS1VoGy59w/bm9+511yFvQt0ehccIQdSvd+Aqm6MsR45SHCIScsv
         Ixf939vJIFza3LH+M9X5GoieJk5htL7UCoI7Xf8phhVxsSVtspKYW1dzV0L+uGsl4z4n
         I7qBhdFwMHphfl6s1ID2NlcwC6YLQi7aOrLECLm/kEsfmRFBKLNyAFBJByofP9AqP/nI
         pok4ATA0mcnCtp5LtCTDYvxloMYzjNQLLw3qAbVHSDpVzCMKM3N3BF+GSK9jP2Livv01
         WcWw==
X-Gm-Message-State: ACrzQf05dtEqX79//ejkQprDmUSukfH9uVUERYGEJrd1O72e+qU//OUs
        M0j+JYTPkkRlpon5EJwbpoOWb1e+HvlXCg0+fs9GNg==
X-Google-Smtp-Source: AMsMyM4izDvP2GEmp8c4SGkLRtqUTJwyAfmyMIM042B9osSHOEO3fXv9m4PJkVynv3Cgmg92/qucK/Cz8xfXblnoZBc=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr317101ybx.427.1666978534173; Fri, 28
 Oct 2022 10:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <20221027211014.3581513-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20221027211014.3581513-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 28 Oct 2022 10:35:23 -0700
Message-ID: <CANn89iLEuY4gA5bVOOUGNAK_zpQJGaY-B1Rt=L=OOKZheLyFgg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: add PACKET_FANOUT_FLAG_IGNORE_OUTGOING
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, vincent.whitchurch@axis.com, cpascoe@google.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 2:10 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> Extend packet socket option PACKET_IGNORE_OUTGOING to fanout groups.
>
...
> Instead, introduce a new fanout group flag with the same behavior.
>
> Tested with https://github.com/wdebruij/kerneltools/blob/master/tests/test_psock_fanout_ignore_outgoing.c
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
